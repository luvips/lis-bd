-- =============================================================================
-- LIS Laboratorio Clínico — Fase 6: Índices
-- Depende de: Fase 4 (tablas creadas; se ejecuta antes de cargar datos)
--
-- Se usa CREATE INDEX sin CONCURRENTLY porque las tablas están vacías en
-- este despliegue inicial y así el archivo puede correr en una transacción.
-- Cualquier índice que se agregue después sobre datos en producción debe
-- usar CREATE INDEX CONCURRENTLY fuera de transacción (regla 12).
--
-- Regla 23 (no duplicar índices): una FK cuya(s) columna(s) ya son el
-- prefijo de un índice UNIQUE o compuesto no recibe un índice propio; ese
-- índice existente ya sirve para verificar la referencia. 08_validacion.sql
-- comprueba que toda FK quede cubierta.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- 1. Índices de FK ------------------------------------------------------------
-- Catálogo
CREATE INDEX idx_antecedente_paciente_paciente ON antecedente_paciente (paciente_id);
-- estudio_tipo_muestra.estudio_id -> cubierto por uq_estudio_tipo_muestra (estudio_id, tipo_muestra)
-- parametro_estudio.estudio_id    -> cubierto por uq_parametro_estudio_nombre (estudio_id, nombre)
-- valor_referencia.parametro_estudio_id: el índice GiST de ex_valor_referencia_traslape
-- es parcial (WHERE activo) y no ve los rangos inactivos, así que no sirve para la FK.
CREATE INDEX idx_valor_referencia_parametro    ON valor_referencia (parametro_estudio_id);
-- estudio_equipo.estudio_id   -> cubierto por uq_estudio_equipo (estudio_id, equipo_id)
CREATE INDEX idx_estudio_equipo_equipo         ON estudio_equipo (equipo_id);
-- paquete_estudio.paquete_id  -> cubierto por uq_paquete_estudio (paquete_id, estudio_id)
CREATE INDEX idx_paquete_estudio_estudio       ON paquete_estudio (estudio_id);

-- Clínico
-- solicitud.paciente_id       -> cubierto por idx_solicitud_paciente_fecha (sección 2)
CREATE INDEX idx_solicitud_medico              ON solicitud (medico_id);
-- detalle_solicitud.solicitud_id -> cubierto por uq_detalle_solicitud_estudio_repeticion
CREATE INDEX idx_detalle_solicitud_estudio     ON detalle_solicitud (estudio_id);
CREATE INDEX idx_detalle_solicitud_paquete     ON detalle_solicitud (paquete_origen_id)
    WHERE paquete_origen_id IS NOT NULL;       -- la mayoría de filas son NULL (venta suelta)
CREATE INDEX idx_muestra_solicitud             ON muestra (solicitud_id);
CREATE INDEX idx_muestra_personal              ON muestra (personal_id);
-- muestra_detalle_solicitud.muestra_id           -> cubierto por uq_muestra_detalle_solicitud
-- muestra_detalle_solicitud.detalle_solicitud_id -> cubierto por uq_muestra_detalle_solicitud_repeticion
CREATE INDEX idx_procesamiento_muestra_detalle ON procesamiento (muestra_id, detalle_solicitud_id);
-- procesamiento.equipo_id     -> cubierto por idx_procesamiento_equipo_fecha (sección 2)
CREATE INDEX idx_procesamiento_personal        ON procesamiento (personal_id);
-- resultado.procesamiento_id  -> cubierto por uq_resultado_procesamiento
-- resultado_valor.resultado_id -> cubierto por uq_resultado_valor_parametro
CREATE INDEX idx_resultado_valor_parametro     ON resultado_valor (parametro_estudio_id);
CREATE INDEX idx_resultado_valor_referencia    ON resultado_valor (valor_referencia_id, parametro_estudio_id);
CREATE INDEX idx_historial_resultado_valor_valor    ON historial_resultado_valor (resultado_valor_id);
CREATE INDEX idx_historial_resultado_valor_personal ON historial_resultado_valor (modificado_por);
CREATE INDEX idx_estado_equipo_equipo          ON estado_equipo (equipo_id);
CREATE INDEX idx_estado_equipo_personal        ON estado_equipo (registrado_por);

-- Comercial
-- cuenta.solicitud_id         -> cubierto por uq_cuenta_solicitud
CREATE INDEX idx_detalle_cuenta_cuenta         ON detalle_cuenta (cuenta_id);
CREATE INDEX idx_detalle_cuenta_detalle_sol    ON detalle_cuenta (detalle_solicitud_id)
    WHERE detalle_solicitud_id IS NOT NULL;    -- líneas de paquete siempre son NULL
-- pago.cuenta_id              -> cubierto por idx_pago_cuenta_fecha (sección 2)
CREATE INDEX idx_pago_personal                 ON pago (recibido_por);

-- 2. Índices compuestos (diccionario, sección 7) ------------------------------
CREATE INDEX idx_solicitud_paciente_fecha   ON solicitud (paciente_id, fecha_solicitud DESC);
-- El diccionario pide (estado, fecha_solicitud), pero detalle_solicitud no
-- tiene fecha_solicitud; su marca temporal equivalente es creado_en.
CREATE INDEX idx_detalle_solicitud_estado_fecha ON detalle_solicitud (estado, creado_en);
CREATE INDEX idx_procesamiento_equipo_fecha ON procesamiento (equipo_id, fecha_inicio DESC);
CREATE INDEX idx_pago_cuenta_fecha          ON pago (cuenta_id, fecha_pago);
-- "Valor vigente de un analito en un resultado" lo resuelve
-- uq_resultado_valor_parametro (resultado_id, parametro_estudio_id): hay una
-- sola fila por analito y las versiones previas viven en el historial.

-- 3. Índices parciales --------------------------------------------------------
CREATE INDEX idx_detalle_pendiente ON detalle_solicitud (creado_en)
    WHERE estado NOT IN ('completado', 'repetido_completado', 'cancelado');
CREATE INDEX idx_equipo_no_operativo ON equipo (estado_operativo)
    WHERE estado_operativo <> 'operativo';
CREATE INDEX idx_cuenta_abierta ON cuenta (fecha_cuenta)
    WHERE estado_pago IN ('pendiente', 'parcialmente_pagada');
COMMENT ON INDEX idx_detalle_pendiente   IS 'Dashboard de estudios pendientes ordenados por antigüedad.';
COMMENT ON INDEX idx_equipo_no_operativo IS 'Validación rápida de equipos no disponibles.';
COMMENT ON INDEX idx_cuenta_abierta      IS 'Caja: cuentas por cobrar.';

-- 4. Índices GIN --------------------------------------------------------------
-- Ninguno: paciente.antecedentes y resultado.datos_estructurados (JSONB) se
-- normalizaron en antecedente_paciente y resultado_valor. personal.certificaciones
-- es JSONB informativo que ninguna consulta filtra (regla 20: sin índices
-- especulativos).

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP INDEX idx_cuenta_abierta, idx_equipo_no_operativo, idx_detalle_pendiente,
--   idx_pago_cuenta_fecha, idx_procesamiento_equipo_fecha,
--   idx_detalle_solicitud_estado_fecha, idx_solicitud_paciente_fecha,
--   idx_pago_personal, idx_detalle_cuenta_detalle_sol, idx_detalle_cuenta_cuenta,
--   idx_estado_equipo_personal, idx_estado_equipo_equipo,
--   idx_historial_resultado_valor_personal, idx_historial_resultado_valor_valor,
--   idx_resultado_valor_referencia, idx_resultado_valor_parametro,
--   idx_procesamiento_personal, idx_procesamiento_muestra_detalle,
--   idx_muestra_personal, idx_muestra_solicitud, idx_detalle_solicitud_paquete,
--   idx_detalle_solicitud_estudio, idx_solicitud_medico, idx_paquete_estudio_estudio,
--   idx_estudio_equipo_equipo, idx_valor_referencia_parametro,
--   idx_antecedente_paciente_paciente;
