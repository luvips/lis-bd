-- =============================================================================
-- LIS Laboratorio Clínico — Fase 7: Funciones y triggers de negocio
-- Depende de: Fase 6
-- Pruebas aisladas (BEGIN ... ROLLBACK): tests/triggers/0N_*.sql
--
-- Orden de bloqueo (regla 28, evita deadlocks):
--   detalle_solicitud -> solicitud
--   detalle_solicitud -> detalle_cuenta -> cuenta
--   pago -> cuenta
--   procesamiento -> equipo (FOR SHARE)
--   muestra_detalle_solicitud -> detalle_solicitud / muestra (solo lectura)
--   resultado_valor -> resultado / procesamiento / detalle_solicitud (solo lectura)
-- Ningún trigger adquiere los bloqueos en orden inverso.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- -----------------------------------------------------------------------------
-- 1. trg_estado_global_solicitud
--    AFTER INSERT/UPDATE OF estado en detalle_solicitud
--    Matriz (en orden de prioridad):
--      solicitud sin detalles                        -> se conserva el estado
--      todos sus detalles cancelados                 -> cancelada
--    y, sobre los detalles NO cancelados:
--      todos completado/repetido_completado          -> completada
--      alguno completado                             -> parcialmente_completada
--      alguno en_procesamiento/requiere_repeticion   -> en_procesamiento
--      alguno muestra_tomada                         -> en_toma_de_muestra
--      todos pendiente_muestra                       -> recibida
--    'entregada' (fijado manualmente) no se degrada a 'completada'.
--    'cancelada' no es terminal: si luego se agrega un detalle no cancelado,
--    la solicitud se recalcula con la matriz normal.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_estado_global_solicitud()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_actual   estado_solicitud;
    v_nuevo    estado_solicitud;
    v_total    int;
    v_activos  int;
    v_tomadas  int;
    v_proceso  int;
    v_listos   int;
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.estado IS NOT DISTINCT FROM NEW.estado THEN
        RETURN NULL;
    END IF;

    -- Bloquea la solicitud primero: las actualizaciones concurrentes de
    -- detalles hermanos se serializan y el conteo siguiente ve lo confirmado.
    SELECT estado_global INTO v_actual
    FROM solicitud WHERE id = NEW.solicitud_id
    FOR UPDATE;

    SELECT count(*),
           count(*) FILTER (WHERE estado <> 'cancelado'),
           count(*) FILTER (WHERE estado = 'muestra_tomada'),
           count(*) FILTER (WHERE estado IN ('en_procesamiento', 'requiere_repeticion')),
           count(*) FILTER (WHERE estado IN ('completado', 'repetido_completado'))
      INTO v_total, v_activos, v_tomadas, v_proceso, v_listos
    FROM detalle_solicitud
    WHERE solicitud_id = NEW.solicitud_id;

    v_nuevo := CASE
        WHEN v_total = 0            THEN v_actual
        WHEN v_activos = 0          THEN 'cancelada'
        WHEN v_listos = v_activos   THEN 'completada'
        WHEN v_listos > 0           THEN 'parcialmente_completada'
        WHEN v_proceso > 0          THEN 'en_procesamiento'
        WHEN v_tomadas > 0          THEN 'en_toma_de_muestra'
        ELSE 'recibida'
    END::estado_solicitud;

    IF v_actual = 'entregada' AND v_nuevo = 'completada' THEN
        v_nuevo := 'entregada';
    END IF;

    IF v_nuevo IS DISTINCT FROM v_actual THEN
        UPDATE solicitud SET estado_global = v_nuevo WHERE id = NEW.solicitud_id;
    END IF;

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_estado_global_solicitud() IS 'Recalcula solicitud.estado_global a partir de los estados de sus detalles.';

CREATE TRIGGER trg_estado_global_solicitud
    AFTER INSERT OR UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW EXECUTE FUNCTION fn_estado_global_solicitud();

-- -----------------------------------------------------------------------------
-- 2. trg_bloquear_equipo_no_operativo
--    BEFORE INSERT en procesamiento. FOR SHARE evita que el equipo cambie de
--    estado entre la validación y el commit del procesamiento.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_bloquear_equipo_no_operativo()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estado estado_operativo_equipo;
BEGIN
    SELECT estado_operativo INTO v_estado
    FROM equipo WHERE id = NEW.equipo_id
    FOR SHARE;

    IF FOUND AND v_estado <> 'operativo' THEN
        RAISE EXCEPTION 'Equipo % no operativo (estado: %); no se puede registrar procesamiento',
                        NEW.equipo_id, v_estado
            USING ERRCODE = 'check_violation',
                  HINT = 'Solo se procesa en equipos con estado_operativo = operativo.';
    END IF;

    RETURN NEW;   -- si el equipo no existe, la FK reporta el error
END
$$;
COMMENT ON FUNCTION fn_bloquear_equipo_no_operativo() IS 'Rechaza procesamiento en equipos cuyo estado_operativo <> operativo.';

CREATE TRIGGER trg_bloquear_equipo_no_operativo
    BEFORE INSERT ON procesamiento
    FOR EACH ROW EXECUTE FUNCTION fn_bloquear_equipo_no_operativo();

-- -----------------------------------------------------------------------------
-- 3. trg_historial_resultado
--    BEFORE UPDATE en resultado_valor. Si cambia algún valor (valor_numerico,
--    valor_texto o interpretacion) copia la versión previa a
--    historial_resultado_valor e incrementa numero_version. Cada analito se
--    versiona por separado.
--    Quién y por qué se toman de variables de sesión que la aplicación fija
--    en la misma transacción:
--        SET LOCAL lis.personal_id = '<uuid>';
--        SET LOCAL lis.motivo_modificacion = 'error de captura';
--    Sin ellas la corrección se rechaza (historial exige ambos NOT NULL).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_historial_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_personal  uuid;
    v_motivo    text;
BEGIN
    NEW.numero_version := OLD.numero_version;   -- no editable a mano
    NEW.actualizado_en := now();

    IF (OLD.valor_numerico, OLD.valor_texto, OLD.interpretacion)
       IS NOT DISTINCT FROM
       (NEW.valor_numerico, NEW.valor_texto, NEW.interpretacion) THEN
        RETURN NEW;
    END IF;

    v_personal := nullif(current_setting('lis.personal_id', true), '')::uuid;
    v_motivo   := nullif(btrim(current_setting('lis.motivo_modificacion', true)), '');

    IF v_personal IS NULL OR v_motivo IS NULL THEN
        RAISE EXCEPTION 'Corregir el valor de resultado % requiere lis.personal_id y lis.motivo_modificacion', OLD.id
            USING ERRCODE = 'not_null_violation',
                  HINT = 'Ejecute SET LOCAL lis.personal_id y SET LOCAL lis.motivo_modificacion en la misma transacción.';
    END IF;

    INSERT INTO historial_resultado_valor (
        resultado_valor_id, version,
        valor_numerico_snapshot, valor_texto_snapshot, interpretacion_snapshot,
        motivo_modificacion, modificado_por
    ) VALUES (
        OLD.id, OLD.numero_version,
        OLD.valor_numerico, OLD.valor_texto, OLD.interpretacion,
        v_motivo, v_personal
    );

    NEW.numero_version := OLD.numero_version + 1;
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_historial_resultado() IS 'Versiona correcciones de resultado_valor en historial_resultado_valor. Requiere SET LOCAL lis.personal_id / lis.motivo_modificacion.';

CREATE TRIGGER trg_historial_resultado
    BEFORE UPDATE ON resultado_valor
    FOR EACH ROW EXECUTE FUNCTION fn_historial_resultado();

-- -----------------------------------------------------------------------------
-- 4. trg_recalcular_cuenta
--    AFTER INSERT/UPDATE en detalle_cuenta y en pago.
--      subtotal        = Σ precio_unitario de líneas no anuladas
--      total           = subtotal - descuento_total (CHECK total >= 0 rechaza
--                        descuentos mayores al subtotal)
--      saldo_pendiente = max(total - Σ pagos aplicados, 0)
--      estado_pago     = pagada si hay pagos y saldo 0; parcialmente_pagada
--                        si hay pagos y saldo > 0; pendiente si no hay pagos.
--                        'cancelada' se respeta (la fija la aplicación).
--    Si los pagos superan el total (p. ej. se anuló un estudio ya pagado) el
--    saldo queda en 0 y se emite WARNING; el trigger no genera ningún
--    movimiento de devolución.
--    saldo_pendiente es un campo desnormalizado; el sobrepago real permanece
--    calculable a partir de PAGO y DETALLE_CUENTA.anulado. La devolución es
--    un proceso manual, fuera de alcance (ver Pendiente en README.md).
--    CHECK (saldo_pendiente >= 0) se conserva como protección ante errores
--    de cálculo de otros triggers.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_recalcular_totales_cuenta(p_cuenta_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    c           record;
    v_subtotal  numeric(10,2);
    v_pagado    numeric(10,2);
    v_total     numeric(10,2);
    v_saldo     numeric(10,2);
    v_estado    estado_cuenta;
BEGIN
    SELECT numero_cuenta, subtotal, descuento_total, total, saldo_pendiente, estado_pago
      INTO c
    FROM cuenta WHERE id = p_cuenta_id
    FOR UPDATE;
    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT coalesce(sum(precio_unitario), 0) INTO v_subtotal
    FROM detalle_cuenta
    WHERE cuenta_id = p_cuenta_id AND NOT anulado;

    SELECT coalesce(sum(monto_pagado), 0) INTO v_pagado
    FROM pago
    WHERE cuenta_id = p_cuenta_id AND estado = 'aplicado';

    v_total := v_subtotal - c.descuento_total;
    v_saldo := greatest(v_total - v_pagado, 0);

    IF v_pagado > greatest(v_total, 0) THEN
        RAISE WARNING 'Cuenta %: pagos aplicados (%) superan el total (%); sobrepago de % (devolución manual)',
                      c.numero_cuenta, v_pagado, v_total, v_pagado - v_total;
    END IF;

    v_estado := CASE
        WHEN c.estado_pago = 'cancelada'     THEN 'cancelada'
        WHEN v_pagado > 0 AND v_saldo = 0    THEN 'pagada'
        WHEN v_pagado > 0                    THEN 'parcialmente_pagada'
        ELSE 'pendiente'
    END::estado_cuenta;

    IF (c.subtotal, c.total, c.saldo_pendiente, c.estado_pago)
       IS DISTINCT FROM (v_subtotal, v_total, v_saldo, v_estado) THEN
        UPDATE cuenta
           SET subtotal = v_subtotal,
               total = v_total,
               saldo_pendiente = v_saldo,
               estado_pago = v_estado
         WHERE id = p_cuenta_id;
    END IF;
END
$$;
COMMENT ON FUNCTION fn_recalcular_totales_cuenta(uuid) IS 'Recalcula subtotal, total, saldo_pendiente y estado_pago de una cuenta.';

CREATE FUNCTION fn_recalcular_cuenta()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    PERFORM fn_recalcular_totales_cuenta(NEW.cuenta_id);
    IF TG_OP = 'UPDATE' AND OLD.cuenta_id <> NEW.cuenta_id THEN
        PERFORM fn_recalcular_totales_cuenta(OLD.cuenta_id);
    END IF;
    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_recalcular_cuenta() IS 'Trigger compartido por detalle_cuenta y pago: dispara el recálculo de la cuenta afectada.';

CREATE TRIGGER trg_recalcular_cuenta
    AFTER INSERT OR UPDATE ON detalle_cuenta
    FOR EACH ROW EXECUTE FUNCTION fn_recalcular_cuenta();

CREATE TRIGGER trg_recalcular_cuenta
    AFTER INSERT OR UPDATE ON pago
    FOR EACH ROW EXECUTE FUNCTION fn_recalcular_cuenta();

-- -----------------------------------------------------------------------------
-- 5. trg_validar_saldo_pago
--    BEFORE INSERT en pago (y UPDATE de monto/estado/cuenta, para que un pago
--    cancelado no pueda "reactivarse" por encima del saldo).
--    FOR UPDATE sobre cuenta serializa pagos concurrentes de la misma cuenta:
--    el segundo espera al commit del primero y lee el saldo ya actualizado.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_saldo_pago()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_saldo       numeric(10,2);
    v_estado      estado_cuenta;
    v_disponible  numeric(10,2);
BEGIN
    IF NEW.estado <> 'aplicado' THEN
        RETURN NEW;
    END IF;

    SELECT saldo_pendiente, estado_pago INTO v_saldo, v_estado
    FROM cuenta WHERE id = NEW.cuenta_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN NEW;   -- la FK reporta el error
    END IF;

    IF v_estado = 'cancelada' THEN
        RAISE EXCEPTION 'La cuenta % está cancelada; no admite pagos', NEW.cuenta_id
            USING ERRCODE = 'check_violation';
    END IF;

    v_disponible := v_saldo;
    IF TG_OP = 'UPDATE' AND OLD.estado = 'aplicado' AND OLD.cuenta_id = NEW.cuenta_id THEN
        v_disponible := v_disponible + OLD.monto_pagado;
    END IF;

    IF NEW.monto_pagado > v_disponible THEN
        RAISE EXCEPTION 'Pago de % excede el saldo pendiente (%) de la cuenta %',
                        NEW.monto_pagado, v_disponible, NEW.cuenta_id
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_saldo_pago() IS 'Bloquea la cuenta (FOR UPDATE) y rechaza pagos aplicados mayores al saldo pendiente.';

CREATE TRIGGER trg_validar_saldo_pago
    BEFORE INSERT OR UPDATE OF monto_pagado, estado, cuenta_id ON pago
    FOR EACH ROW EXECUTE FUNCTION fn_validar_saldo_pago();

-- -----------------------------------------------------------------------------
-- 6. trg_cancelar_detalle_cuenta
--    AFTER UPDATE en detalle_solicitud cuando estado pasa a 'cancelado'.
--    Venta suelta (paquete_origen_id IS NULL): anula su línea de cuenta; el
--    UPDATE sobre detalle_cuenta dispara trg_recalcular_cuenta.
--    Parte de paquete: no hace nada (sin reembolso parcial de paquetes).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_cancelar_detalle_cuenta()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    IF NEW.paquete_origen_id IS NOT NULL THEN
        RETURN NULL;
    END IF;

    UPDATE detalle_cuenta
       SET anulado = TRUE
     WHERE detalle_solicitud_id = NEW.id
       AND origen = 'estudio_individual'
       AND NOT anulado;

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_cancelar_detalle_cuenta() IS 'Anula la línea de cuenta de un estudio suelto cancelado; ignora estudios de paquete.';

CREATE TRIGGER trg_cancelar_detalle_cuenta
    AFTER UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW
    WHEN (NEW.estado = 'cancelado' AND OLD.estado IS DISTINCT FROM 'cancelado')
    EXECUTE FUNCTION fn_cancelar_detalle_cuenta();

-- -----------------------------------------------------------------------------
-- 7. trg_descartar_muestra_cancelada
--    AFTER UPDATE en detalle_solicitud cuando estado pasa a 'cancelado':
--    todo tubo vinculado al detalle en 'tomada' o 'en_analisis' pasa a
--    'descartada', salvo que también sirva a otro estudio no cancelado (un
--    tubo compartido sigue vivo mientras algún estudio lo necesite).
--    Aplica siempre, sea venta suelta o parte de paquete.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_descartar_muestra_cancelada()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    UPDATE muestra m
       SET estado = 'descartada'
      FROM muestra_detalle_solicitud mds
     WHERE mds.detalle_solicitud_id = NEW.id
       AND m.id = mds.muestra_id
       AND m.estado IN ('tomada', 'en_analisis')
       AND NOT EXISTS (
             SELECT 1
             FROM muestra_detalle_solicitud otro
             JOIN detalle_solicitud ds ON ds.id = otro.detalle_solicitud_id
             WHERE otro.muestra_id = m.id
               AND otro.detalle_solicitud_id <> NEW.id
               AND ds.estado <> 'cancelado');

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_descartar_muestra_cancelada() IS 'Descarta tubos vivos (tomada/en_analisis) de un detalle cancelado si ningún otro estudio vigente los usa.';

CREATE TRIGGER trg_descartar_muestra_cancelada
    AFTER UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW
    WHEN (NEW.estado = 'cancelado' AND OLD.estado IS DISTINCT FROM 'cancelado')
    EXECUTE FUNCTION fn_descartar_muestra_cancelada();

-- -----------------------------------------------------------------------------
-- 8. trg_copiar_numero_repeticion_muestra
--    BEFORE INSERT en muestra_detalle_solicitud (vínculo tubo <-> estudio):
--      * numero_repeticion se deriva del intento vigente del detalle e
--        ignora el valor enviado por la aplicación;
--      * el tubo debe ser de la misma solicitud que el detalle (no se
--        mezclan muestras de pacientes);
--      * el tipo de muestra del tubo debe estar aceptado por el estudio
--        (estudio_tipo_muestra).
--    Sin FOR UPDATE: la toma de muestra es un acto físico secuencial; la
--    unicidad la protege UNIQUE(detalle_solicitud_id, numero_repeticion).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_copiar_numero_repeticion_muestra()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_detalle  record;
    v_muestra  record;
BEGIN
    SELECT solicitud_id, estudio_id, numero_repeticion INTO v_detalle
    FROM detalle_solicitud WHERE id = NEW.detalle_solicitud_id;
    SELECT solicitud_id, tipo_muestra INTO v_muestra
    FROM muestra WHERE id = NEW.muestra_id;

    IF v_detalle.solicitud_id IS NULL OR v_muestra.solicitud_id IS NULL THEN
        RETURN NEW;   -- si el detalle o la muestra no existen, la FK reporta el error
    END IF;

    IF v_muestra.solicitud_id <> v_detalle.solicitud_id THEN
        RAISE EXCEPTION 'La muestra % pertenece a otra solicitud que el detalle %',
                        NEW.muestra_id, NEW.detalle_solicitud_id
            USING ERRCODE = 'check_violation';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM estudio_tipo_muestra
                   WHERE estudio_id = v_detalle.estudio_id
                     AND tipo_muestra = v_muestra.tipo_muestra) THEN
        RAISE EXCEPTION 'El estudio % no acepta muestras de tipo %',
                        v_detalle.estudio_id, v_muestra.tipo_muestra
            USING ERRCODE = 'check_violation',
                  HINT = 'Registre el tipo en estudio_tipo_muestra o use otro tubo.';
    END IF;

    NEW.numero_repeticion := v_detalle.numero_repeticion;
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_copiar_numero_repeticion_muestra() IS 'Al vincular tubo y estudio: copia numero_repeticion del detalle y valida misma solicitud y tipo de muestra aceptado.';

CREATE TRIGGER trg_copiar_numero_repeticion_muestra
    BEFORE INSERT ON muestra_detalle_solicitud
    FOR EACH ROW EXECUTE FUNCTION fn_copiar_numero_repeticion_muestra();

-- -----------------------------------------------------------------------------
-- 9. trg_validar_parametro_resultado
--    BEFORE INSERT / UPDATE OF resultado_id, parametro_estudio_id en
--    resultado_valor: el analito debe pertenecer al estudio que se procesó
--    (resultado -> procesamiento -> detalle_solicitud.estudio_id). Impide,
--    p. ej., capturar Hemoglobina en una corrida de glucosa.
--    Una FK compuesta exigiría copiar estudio_id en procesamiento, resultado
--    y resultado_valor; el trigger evita esa cadena de desnormalización.
--    La revalidación tras reasignar procesamiento.detalle_solicitud_id o
--    resultado.procesamiento_id la cubren los triggers 10 y 11.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_parametro_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estudio_procesado  uuid;
    v_estudio_parametro  uuid;
BEGIN
    SELECT ds.estudio_id INTO v_estudio_procesado
    FROM resultado r
    JOIN procesamiento p      ON p.id = r.procesamiento_id
    JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
    WHERE r.id = NEW.resultado_id;

    SELECT estudio_id INTO v_estudio_parametro
    FROM parametro_estudio WHERE id = NEW.parametro_estudio_id;

    IF v_estudio_procesado IS NULL OR v_estudio_parametro IS NULL THEN
        RETURN NEW;   -- si el resultado o el parámetro no existen, la FK reporta el error
    END IF;

    IF v_estudio_parametro <> v_estudio_procesado THEN
        RAISE EXCEPTION 'El parámetro % no pertenece al estudio % procesado en el resultado %',
                        NEW.parametro_estudio_id, v_estudio_procesado, NEW.resultado_id
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_parametro_resultado() IS 'Rechaza un resultado_valor cuyo analito no pertenece al estudio del procesamiento.';

CREATE TRIGGER trg_validar_parametro_resultado
    BEFORE INSERT OR UPDATE OF resultado_id, parametro_estudio_id ON resultado_valor
    FOR EACH ROW EXECUTE FUNCTION fn_validar_parametro_resultado();

-- -----------------------------------------------------------------------------
-- Helper de los triggers 10 y 11: repite la comprobación del trigger 9 pero al
-- revés (contra un resultado que ya tiene valores capturados) cuando se
-- reasigna el estudio procesado *después* de la captura.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_resultado_contra_estudio(p_resultado_id uuid, p_estudio_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_parametro_id  uuid;
BEGIN
    SELECT rv.parametro_estudio_id INTO v_parametro_id
    FROM resultado_valor rv
    JOIN parametro_estudio pe ON pe.id = rv.parametro_estudio_id
    WHERE rv.resultado_id = p_resultado_id
      AND pe.estudio_id <> p_estudio_id
    LIMIT 1;

    IF v_parametro_id IS NOT NULL THEN
        RAISE EXCEPTION 'El resultado % ya tiene un valor del parámetro %, que no pertenece al estudio %',
                        p_resultado_id, v_parametro_id, p_estudio_id
            USING ERRCODE = 'check_violation';
    END IF;
END
$$;
COMMENT ON FUNCTION fn_validar_resultado_contra_estudio(uuid, uuid) IS 'Rechaza reasignar el estudio de un resultado que ya tiene valores de otro estudio. Usada por los triggers 10 y 11.';

-- -----------------------------------------------------------------------------
-- 10. trg_validar_reasignacion_procesamiento
--     BEFORE UPDATE OF detalle_solicitud_id en procesamiento: si el
--     procesamiento ya tiene un resultado con valores capturados, el nuevo
--     detalle_solicitud_id debe ser del mismo estudio que esos valores.
--     Cierra el hueco que dejaba abierto trg_validar_parametro_resultado: sin
--     este trigger, reasignar el procesamiento a otro estudio después de
--     capturar valores dejaría analitos de un estudio distinto sin que
--     ningún trigger lo notara.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_reasignacion_procesamiento()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_resultado_id  uuid;
    v_estudio_id    uuid;
BEGIN
    SELECT id INTO v_resultado_id FROM resultado WHERE procesamiento_id = NEW.id;
    IF v_resultado_id IS NULL THEN
        RETURN NEW;   -- sin resultado todavía, nada que revalidar
    END IF;

    SELECT estudio_id INTO v_estudio_id FROM detalle_solicitud WHERE id = NEW.detalle_solicitud_id;
    PERFORM fn_validar_resultado_contra_estudio(v_resultado_id, v_estudio_id);
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_reasignacion_procesamiento() IS 'Impide reasignar procesamiento.detalle_solicitud_id a otro estudio si su resultado ya tiene valores capturados.';

CREATE TRIGGER trg_validar_reasignacion_procesamiento
    BEFORE UPDATE OF detalle_solicitud_id ON procesamiento
    FOR EACH ROW
    WHEN (OLD.detalle_solicitud_id IS DISTINCT FROM NEW.detalle_solicitud_id)
    EXECUTE FUNCTION fn_validar_reasignacion_procesamiento();

-- -----------------------------------------------------------------------------
-- 11. trg_validar_reasignacion_resultado
--     BEFORE UPDATE OF procesamiento_id en resultado: si el resultado ya
--     tiene valores capturados, el nuevo procesamiento_id debe apuntar al
--     mismo estudio que esos valores. Simétrico al trigger 10, para el otro
--     lado de la relación 1:1 resultado-procesamiento.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_reasignacion_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estudio_id  uuid;
BEGIN
    SELECT ds.estudio_id INTO v_estudio_id
    FROM procesamiento p
    JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
    WHERE p.id = NEW.procesamiento_id;

    PERFORM fn_validar_resultado_contra_estudio(NEW.id, v_estudio_id);
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_reasignacion_resultado() IS 'Impide reasignar resultado.procesamiento_id a un procesamiento de otro estudio si el resultado ya tiene valores capturados.';

CREATE TRIGGER trg_validar_reasignacion_resultado
    BEFORE UPDATE OF procesamiento_id ON resultado
    FOR EACH ROW
    WHEN (OLD.procesamiento_id IS DISTINCT FROM NEW.procesamiento_id)
    EXECUTE FUNCTION fn_validar_reasignacion_resultado();

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TRIGGER trg_validar_reasignacion_resultado     ON resultado;
-- DROP TRIGGER trg_validar_reasignacion_procesamiento ON procesamiento;
-- DROP FUNCTION fn_validar_reasignacion_resultado(), fn_validar_reasignacion_procesamiento(),
--   fn_validar_resultado_contra_estudio(uuid, uuid);
-- DROP TRIGGER trg_validar_parametro_resultado ON resultado_valor;
-- DROP FUNCTION fn_validar_parametro_resultado();
-- DROP TRIGGER trg_copiar_numero_repeticion_muestra ON muestra_detalle_solicitud;
-- DROP TRIGGER trg_descartar_muestra_cancelada ON detalle_solicitud;
-- DROP TRIGGER trg_cancelar_detalle_cuenta     ON detalle_solicitud;
-- DROP TRIGGER trg_validar_saldo_pago          ON pago;
-- DROP TRIGGER trg_recalcular_cuenta           ON pago;
-- DROP TRIGGER trg_recalcular_cuenta           ON detalle_cuenta;
-- DROP TRIGGER trg_historial_resultado         ON resultado_valor;
-- DROP TRIGGER trg_bloquear_equipo_no_operativo ON procesamiento;
-- DROP TRIGGER trg_estado_global_solicitud     ON detalle_solicitud;
-- DROP FUNCTION fn_copiar_numero_repeticion_muestra(),
--   fn_descartar_muestra_cancelada(), fn_cancelar_detalle_cuenta(),
--   fn_validar_saldo_pago(), fn_recalcular_cuenta(), fn_recalcular_totales_cuenta(uuid),
--   fn_historial_resultado(), fn_bloquear_equipo_no_operativo(), fn_estado_global_solicitud();
