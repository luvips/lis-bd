-- =============================================================================
-- LIS Laboratorio Clínico — Seed 2: Transacciones de demostración
-- Depende de: seed/01_catalogo.sql ya cargado.
-- Se ejecuta como lis_admin, igual que 01_catalogo.sql (inserta directo en
-- tablas clínicas y comerciales sin pasar por los roles de aplicación;
-- para probar los roles use tests/roles/01_permisos.sql o conéctese con
-- app_recepcion/app_laboratorio/app_caja como haría la app real).
--
-- Cinco solicitudes que dejan la base en un estado no trivial para
-- documentación/demo (screenshots, exploración manual), cada una mostrando
-- un camino distinto del modelo:
--   A. Javier Romero  — BH suelto, flujo completo, pagado, entregada.
--   B. María López     — paquete prenatal, EN PROGRESO (parcialmente
--                         completada), un estudio ni siquiera con muestra
--                         tomada, pago parcial.
--   C. Carlos Hernández — QS6 suelto con REPETICIÓN (muestra hemolizada),
--                         completada, cuenta SIN pagos.
--   D. Ana Sofía Vázquez — LIP + PCR con un tubo COMPARTIDO; se cancela PCR
--                         después de tomar la muestra y el tubo sigue vivo
--                         porque LIP todavía lo usa.
--   E. Miriam Estrada  — cultivo con antibiograma (6 analitos cualitativos,
--                         S/I/R), pagado, entregada.
--
-- Cada bloque es un DO $$ ... $$ procedural: refleja cómo lo haría la app
-- (una solicitud a la vez, guardando los ids que va necesitando), y no usa
-- ningún UUID a mano, todo por clave natural (curp, cedula_profesional,
-- codigo, numero_empleado, numero_serie).
--
-- Uso:
--   docker compose -f docker/docker-compose.yml --env-file .env exec -T db \
--     psql -U lis_admin -d lis_laboratorio -v ON_ERROR_STOP=1 < seed/02_demo_transacciones.sql
--   (o make seed, después de 01_catalogo.sql)
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- -----------------------------------------------------------------------------
-- A. Javier Romero — BH suelto, flujo completo hasta entregada y pagada
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_paciente   uuid := (SELECT id FROM paciente WHERE curp = 'ROMJ850312HDFMNS08');
    v_medico     uuid := (SELECT id FROM medico WHERE cedula_profesional = 'CED-1023456');
    v_estudio    uuid := (SELECT id FROM estudio WHERE codigo = 'BH');
    v_flebo      uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-001');
    v_tecnico    uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-004');
    v_cajero     uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-007');
    v_equipo     uuid := (SELECT id FROM equipo WHERE numero_serie = 'SYS-XN550-001');
    v_solicitud  uuid;
    v_detalle    uuid;
    v_muestra    uuid;
    v_proc       uuid;
    v_resultado  uuid;
    v_cuenta     uuid;
BEGIN
    INSERT INTO solicitud (paciente_id, medico_id, prioridad)
    VALUES (v_paciente, v_medico, 'normal') RETURNING id INTO v_solicitud;

    INSERT INTO detalle_solicitud (solicitud_id, estudio_id)
    VALUES (v_solicitud, v_estudio) RETURNING id INTO v_detalle;

    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id, temperatura_conservacion)
    VALUES ('LIS-0001-A', v_solicitud, 'sangre_venosa', 4.00, v_flebo, 'refrigerada') RETURNING id INTO v_muestra;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra, v_detalle);
    UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id = v_detalle;

    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES (v_muestra, v_detalle, v_equipo, v_tecnico) RETURNING id INTO v_proc;
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_detalle;

    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND vr.sexo_aplicable = 'M'),
           v.valor, 'normal'
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Hemoglobina', 15.4::numeric), ('Hematocrito', 46), ('Eritrocitos', 5.1)) AS v(nombre, valor)
        ON pe.nombre = v.nombre
    WHERE pe.estudio_id = v_estudio;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND vr.sexo_aplicable IS NULL),
           v.valor, 'normal'
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Leucocitos', 6.8::numeric), ('Plaquetas', 260)) AS v(nombre, valor)
        ON pe.nombre = v.nombre
    WHERE pe.estudio_id = v_estudio;

    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE muestra SET estado = 'analizada' WHERE id = v_muestra;
    UPDATE detalle_solicitud SET estado = 'completado' WHERE id = v_detalle;
    UPDATE resultado SET es_definitivo = TRUE WHERE id = v_resultado;

    INSERT INTO cuenta (solicitud_id) VALUES (v_solicitud) RETURNING id INTO v_cuenta;
    INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
    SELECT v_cuenta, 'estudio_individual', v_detalle, e.nombre, e.precio FROM estudio e WHERE e.id = v_estudio;
    INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    SELECT v_cuenta, total, 'tarjeta_debito', v_cajero FROM cuenta WHERE id = v_cuenta;

    UPDATE solicitud SET estado_global = 'entregada' WHERE id = v_solicitud;
END
$$;

-- -----------------------------------------------------------------------------
-- B. María López — paquete prenatal, en progreso (parcialmente completada)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_paciente   uuid := (SELECT id FROM paciente WHERE curp = 'LOMA900718MDFPRR02');
    v_medico     uuid := (SELECT id FROM medico WHERE cedula_profesional = 'CED-1034567');
    v_paquete    uuid := (SELECT id FROM paquete WHERE codigo = 'PKG-PRENATAL');
    v_flebo      uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-002');
    v_tecnico    uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-005');
    v_cajero     uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-008');
    v_eq_hema    uuid := (SELECT id FROM equipo WHERE numero_serie = 'SYS-XN550-001');
    v_solicitud  uuid;
    v_det_bh     uuid;
    v_det_gsrh   uuid;
    v_det_qs6    uuid;
    v_det_ego    uuid;
    v_muestra_a  uuid;  -- venosa: BH + GSRH
    v_muestra_b  uuid;  -- venosa: QS6
    v_proc       uuid;
    v_resultado  uuid;
    v_cuenta     uuid;
BEGIN
    INSERT INTO solicitud (paciente_id, medico_id, prioridad)
    VALUES (v_paciente, v_medico, 'normal') RETURNING id INTO v_solicitud;

    INSERT INTO detalle_solicitud (solicitud_id, estudio_id, paquete_origen_id)
    SELECT v_solicitud, pe.estudio_id, v_paquete
    FROM paquete_estudio pe WHERE pe.paquete_id = v_paquete;

    SELECT id INTO v_det_bh   FROM detalle_solicitud WHERE solicitud_id = v_solicitud AND estudio_id = (SELECT id FROM estudio WHERE codigo = 'BH');
    SELECT id INTO v_det_gsrh FROM detalle_solicitud WHERE solicitud_id = v_solicitud AND estudio_id = (SELECT id FROM estudio WHERE codigo = 'GSRH');
    SELECT id INTO v_det_qs6  FROM detalle_solicitud WHERE solicitud_id = v_solicitud AND estudio_id = (SELECT id FROM estudio WHERE codigo = 'QS6');
    SELECT id INTO v_det_ego  FROM detalle_solicitud WHERE solicitud_id = v_solicitud AND estudio_id = (SELECT id FROM estudio WHERE codigo = 'EGO');

    -- Un tubo de sangre venosa sirve para BH y GSRH; otro, para QS6 (ayuno).
    -- EGO (orina) todavía no se toma: así la solicitud queda mixta.
    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id)
    VALUES ('LIS-0002-A', v_solicitud, 'sangre_venosa', 5.00, v_flebo) RETURNING id INTO v_muestra_a;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra_a, v_det_bh), (v_muestra_a, v_det_gsrh);

    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id)
    VALUES ('LIS-0002-B', v_solicitud, 'sangre_venosa', 4.00, v_flebo) RETURNING id INTO v_muestra_b;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra_b, v_det_qs6);

    UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id IN (v_det_bh, v_det_gsrh, v_det_qs6);

    -- BH y GSRH se procesan y completan.
    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES (v_muestra_a, v_det_bh, v_eq_hema, v_tecnico) RETURNING id INTO v_proc;
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_det_bh;
    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND vr.sexo_aplicable = 'F'),
           v.valor, 'normal'
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Hemoglobina', 12.8::numeric), ('Hematocrito', 39), ('Eritrocitos', 4.4)) AS v(nombre, valor)
        ON pe.nombre = v.nombre
    WHERE pe.estudio_id = (SELECT id FROM estudio WHERE codigo = 'BH');
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND vr.sexo_aplicable IS NULL),
           v.valor, 'normal'
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Leucocitos', 7.5::numeric), ('Plaquetas', 240)) AS v(nombre, valor) ON pe.nombre = v.nombre
    WHERE pe.estudio_id = (SELECT id FROM estudio WHERE codigo = 'BH');
    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE detalle_solicitud SET estado = 'completado' WHERE id = v_det_bh;

    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES (v_muestra_a, v_det_gsrh, v_eq_hema, v_tecnico) RETURNING id INTO v_proc;
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_det_gsrh;
    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_texto)
    SELECT v_resultado, pe.id, v.valor
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Grupo ABO', 'O'), ('Factor Rh', 'Positivo')) AS v(nombre, valor) ON pe.nombre = v.nombre
    WHERE pe.estudio_id = (SELECT id FROM estudio WHERE codigo = 'GSRH');
    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE detalle_solicitud SET estado = 'completado' WHERE id = v_det_gsrh;

    -- QS6: solo se tomó la muestra, aún no se procesa (queda en_procesamiento
    -- global una vez se marque; aquí se deja en muestra_tomada a propósito).
    -- EGO: ni siquiera se ha tomado la muestra (sigue en pendiente_muestra).
    -- Resultado en solicitud.estado_global: 2 completados de 4 -> parcialmente_completada.

    INSERT INTO cuenta (solicitud_id) VALUES (v_solicitud) RETURNING id INTO v_cuenta;
    INSERT INTO detalle_cuenta (cuenta_id, origen, concepto, precio_unitario)
    SELECT v_cuenta, 'paquete', p.nombre, p.precio_paquete FROM paquete p WHERE p.id = v_paquete;
    INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES (v_cuenta, 300.00, 'efectivo', v_cajero);
END
$$;

-- -----------------------------------------------------------------------------
-- C. Carlos Hernández — QS6 suelto con repetición (muestra hemolizada)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_paciente   uuid := (SELECT id FROM paciente WHERE curp = 'HECA780425HDFRRN05');
    v_medico     uuid := (SELECT id FROM medico WHERE cedula_profesional = 'CED-1067890');
    v_estudio    uuid := (SELECT id FROM estudio WHERE codigo = 'QS6');
    v_flebo      uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-003');
    v_tecnico    uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-006');
    v_equipo     uuid := (SELECT id FROM equipo WHERE numero_serie = 'ROC-C311-002');
    v_solicitud  uuid;
    v_detalle    uuid;
    v_muestra1   uuid;
    v_muestra2   uuid;
    v_proc       uuid;
    v_resultado  uuid;
    v_cuenta     uuid;
BEGIN
    INSERT INTO solicitud (paciente_id, medico_id, prioridad)
    VALUES (v_paciente, v_medico, 'urgente') RETURNING id INTO v_solicitud;
    INSERT INTO detalle_solicitud (solicitud_id, estudio_id)
    VALUES (v_solicitud, v_estudio) RETURNING id INTO v_detalle;

    -- Intento 1: se hemoliza, se descarta y se marca requiere_repeticion.
    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id)
    VALUES ('LIS-0003-A', v_solicitud, 'sangre_venosa', 4.00, v_flebo) RETURNING id INTO v_muestra1;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra1, v_detalle);
    UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id = v_detalle;
    UPDATE muestra SET condicion = 'hemolizada', estado = 'descartada' WHERE id = v_muestra1;
    UPDATE detalle_solicitud SET estado = 'requiere_repeticion', motivo_repeticion = 'Muestra hemolizada en la toma inicial',
                                  numero_repeticion = 1
     WHERE id = v_detalle;

    -- Intento 2: exitoso. numero_repeticion se copia solo (trigger 8).
    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id)
    VALUES ('LIS-0003-B', v_solicitud, 'sangre_venosa', 4.00, v_flebo) RETURNING id INTO v_muestra2;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra2, v_detalle);
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_detalle;

    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id, es_reprocesamiento)
    VALUES (v_muestra2, v_detalle, v_equipo, v_tecnico, TRUE) RETURNING id INTO v_proc;
    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND (vr.sexo_aplicable = 'M' OR vr.sexo_aplicable IS NULL)
              AND (vr.edad_minima IS NULL OR vr.edad_minima = 19) LIMIT 1),
           v.valor, v.interpretacion::interpretacion_resultado
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES
        ('Glucosa', 142::numeric, 'alto'), ('Urea', 32, 'normal'), ('Creatinina', 1.0, 'normal'),
        ('Ácido Úrico', 5.2, 'normal'), ('Colesterol Total', 205, 'alto'), ('Triglicéridos', 165, 'alto')
    ) AS v(nombre, valor, interpretacion) ON pe.nombre = v.nombre
    WHERE pe.estudio_id = v_estudio;

    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE muestra SET estado = 'analizada' WHERE id = v_muestra2;
    UPDATE detalle_solicitud SET estado = 'repetido_completado' WHERE id = v_detalle;
    UPDATE resultado SET es_definitivo = TRUE, observaciones = 'Glucosa y perfil lipídico alterados; se sugiere valoración endocrinológica.'
     WHERE id = v_resultado;

    -- Cuenta creada pero sin ningún pago: demuestra estado_pago = pendiente.
    INSERT INTO cuenta (solicitud_id) VALUES (v_solicitud) RETURNING id INTO v_cuenta;
    INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
    SELECT v_cuenta, 'estudio_individual', v_detalle, e.nombre, e.precio FROM estudio e WHERE e.id = v_estudio;
END
$$;

-- -----------------------------------------------------------------------------
-- D. Ana Sofía Vázquez — LIP + PCR con tubo compartido; se cancela PCR
--    después de tomar la muestra y el tubo sigue vivo por LIP.
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_paciente   uuid := (SELECT id FROM paciente WHERE curp = 'VASA020911MDFLNN01');
    v_medico     uuid := (SELECT id FROM medico WHERE cedula_profesional = 'CED-1078901');
    v_est_lip    uuid := (SELECT id FROM estudio WHERE codigo = 'LIP');
    v_est_pcr    uuid := (SELECT id FROM estudio WHERE codigo = 'PCR');
    v_flebo      uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-001');
    v_tecnico    uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-005');
    v_cajero     uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-007');
    v_eq_quim    uuid := (SELECT id FROM equipo WHERE numero_serie = 'ROC-C311-002');
    v_eq_inm     uuid := (SELECT id FROM equipo WHERE numero_serie = 'ROC-E411-003');
    v_solicitud  uuid;
    v_det_lip    uuid;
    v_det_pcr    uuid;
    v_muestra    uuid;
    v_proc       uuid;
    v_resultado  uuid;
    v_cuenta     uuid;
BEGIN
    INSERT INTO solicitud (paciente_id, medico_id, prioridad)
    VALUES (v_paciente, v_medico, 'normal') RETURNING id INTO v_solicitud;
    INSERT INTO detalle_solicitud (solicitud_id, estudio_id) VALUES (v_solicitud, v_est_lip) RETURNING id INTO v_det_lip;
    INSERT INTO detalle_solicitud (solicitud_id, estudio_id) VALUES (v_solicitud, v_est_pcr) RETURNING id INTO v_det_pcr;

    -- Un solo tubo de ayuno sirve para LIP y PCR.
    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, volumen_ml, personal_id)
    VALUES ('LIS-0004-A', v_solicitud, 'sangre_venosa', 5.00, v_flebo) RETURNING id INTO v_muestra;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra, v_det_lip), (v_muestra, v_det_pcr);
    UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id IN (v_det_lip, v_det_pcr);

    -- LIP se procesa y completa.
    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES (v_muestra, v_det_lip, v_eq_quim, v_tecnico) RETURNING id INTO v_proc;
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_det_lip;
    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
    SELECT v_resultado, pe.id,
           (SELECT vr.id FROM valor_referencia vr WHERE vr.parametro_estudio_id = pe.id AND (vr.sexo_aplicable = 'F' OR vr.sexo_aplicable IS NULL)),
           v.valor, 'normal'
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES ('Colesterol Total', 178::numeric), ('Triglicéridos', 95), ('HDL', 58), ('LDL', 102), ('VLDL', 19)) AS v(nombre, valor)
        ON pe.nombre = v.nombre
    WHERE pe.estudio_id = v_est_lip;
    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE detalle_solicitud SET estado = 'completado' WHERE id = v_det_lip;

    -- El paciente decide no hacerse la PCR después de haber dado la muestra.
    -- trg_cancelar_detalle_cuenta (no hay línea de cuenta todavía: no-op) y
    -- trg_descartar_muestra_cancelada corren; el tubo NO se descarta porque
    -- LIP (no cancelado) sigue usándolo.
    UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = v_det_pcr;

    -- Se factura solo lo que sigue vigente: PCR se canceló antes de llegar
    -- a cuenta, así que nunca genera línea (a diferencia de cancelar un
    -- estudio que YA estaba facturado, donde trg_cancelar_detalle_cuenta
    -- es quien anula la línea existente).
    INSERT INTO cuenta (solicitud_id) VALUES (v_solicitud) RETURNING id INTO v_cuenta;
    INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
    SELECT v_cuenta, 'estudio_individual', v_det_lip, e.nombre, e.precio FROM estudio e WHERE e.id = v_est_lip;
    INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    SELECT v_cuenta, total, 'transferencia', v_cajero FROM cuenta WHERE id = v_cuenta;
    UPDATE solicitud SET estado_global = 'entregada' WHERE id = v_solicitud;
END
$$;

-- -----------------------------------------------------------------------------
-- E. Miriam Estrada — cultivo con antibiograma (6 analitos cualitativos)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_paciente   uuid := (SELECT id FROM paciente WHERE curp = 'ESLM940509MDFTPR01');
    v_medico     uuid := (SELECT id FROM medico WHERE cedula_profesional = 'CED-1023456');
    v_estudio    uuid := (SELECT id FROM estudio WHERE codigo = 'CULT');
    v_flebo      uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-002');
    v_tecnico    uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-006');
    v_cajero     uuid := (SELECT id FROM personal WHERE numero_empleado = 'EMP-008');
    v_equipo     uuid := (SELECT id FROM equipo WHERE numero_serie = 'MIC-INC200-005');
    v_solicitud  uuid;
    v_detalle    uuid;
    v_muestra    uuid;
    v_proc       uuid;
    v_resultado  uuid;
    v_cuenta     uuid;
BEGIN
    INSERT INTO solicitud (paciente_id, medico_id, prioridad)
    VALUES (v_paciente, v_medico, 'normal') RETURNING id INTO v_solicitud;
    INSERT INTO detalle_solicitud (solicitud_id, estudio_id) VALUES (v_solicitud, v_estudio) RETURNING id INTO v_detalle;

    INSERT INTO muestra (codigo_barras, solicitud_id, tipo_muestra, personal_id, observaciones)
    VALUES ('LIS-0005-A', v_solicitud, 'otro', v_flebo, 'Exudado faríngeo') RETURNING id INTO v_muestra;
    INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES (v_muestra, v_detalle);
    UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id = v_detalle;

    INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id, observaciones)
    VALUES (v_muestra, v_detalle, v_equipo, v_tecnico, 'Incubación 72 h a 37°C') RETURNING id INTO v_proc;
    UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = v_detalle;

    INSERT INTO resultado (procesamiento_id) VALUES (v_proc) RETURNING id INTO v_resultado;
    INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_texto)
    SELECT v_resultado, pe.id, v.valor
    FROM parametro_estudio pe
    JOIN LATERAL (VALUES
        ('Identificación',                       'Streptococcus pyogenes'),
        ('Penicilina',                            'S'),
        ('Amoxicilina/Ácido Clavulánico',         'S'),
        ('Eritromicina',                          'R'),
        ('Clindamicina',                          'S'),
        ('Vancomicina',                           'S')
    ) AS v(nombre, valor) ON pe.nombre = v.nombre
    WHERE pe.estudio_id = v_estudio;

    UPDATE procesamiento SET estado = 'completado', fecha_fin = now() WHERE id = v_proc;
    UPDATE muestra SET estado = 'analizada' WHERE id = v_muestra;
    UPDATE detalle_solicitud SET estado = 'completado' WHERE id = v_detalle;
    UPDATE resultado SET es_definitivo = TRUE WHERE id = v_resultado;

    INSERT INTO cuenta (solicitud_id) VALUES (v_solicitud) RETURNING id INTO v_cuenta;
    INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
    SELECT v_cuenta, 'estudio_individual', v_detalle, e.nombre, e.precio FROM estudio e WHERE e.id = v_estudio;
    INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, referencia_pago, recibido_por)
    SELECT v_cuenta, total, 'tarjeta_credito', 'AUT-445210', v_cajero FROM cuenta WHERE id = v_cuenta;
    UPDATE solicitud SET estado_global = 'entregada' WHERE id = v_solicitud;
END
$$;

COMMIT;

-- Resumen esperado tras correr este archivo sobre un catálogo recién
-- cargado (además de lo de 01_catalogo.sql), verificado contra la base real:
--   5 solicitud, 9 detalle_solicitud, 7 muestra, 9 muestra_detalle_solicitud,
--   6 procesamiento, 6 resultado, 29 resultado_valor, 5 cuenta,
--   5 detalle_cuenta, 4 pago (D no paga la línea de PCR: queda cancelada
--   antes de facturarla, así que solo tiene un pago por la línea de LIP).
-- Un vistazo rápido:
--   SELECT s.folio, p.nombre, p.apellido_paterno, s.estado_global, c.estado_pago, c.saldo_pendiente
--   FROM solicitud s JOIN paciente p ON p.id = s.paciente_id
--   LEFT JOIN cuenta c ON c.solicitud_id = s.id
--   ORDER BY s.creado_en;
