-- =============================================================================
-- LIS Laboratorio Clínico — Fase 8: Validación estructural completa
-- Script de verificación (no crea objetos persistentes). Ejecutar con:
--   psql -d lis_laboratorio -f sql/08_validacion.sql
-- Toda línea "OK - ..." es una aserción cumplida; "[error esperado ...]"
-- marca un constraint violado a propósito, no un fallo. Cualquier fallo
-- real aborta con "FALLO - ..." y código de salida distinto de 0.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir ../tests/_helpers.sql

-- -----------------------------------------------------------------------------
-- 1. Estructura
-- -----------------------------------------------------------------------------
-- FK sin índice cuyo prefijo coincida con sus columnas (debe devolver 0).
-- Un índice parcial solo cuenta si su predicado es "<col> IS NOT NULL": la
-- verificación de la FK busca valores no nulos, así que ese índice ve todas
-- las filas relevantes; otro predicado (p. ej. WHERE activo) no.
CREATE TEMP VIEW fk_sin_indice AS
SELECT c.conrelid::regclass AS tabla, c.conname AS fk
FROM pg_constraint c
WHERE c.contype = 'f'
  AND c.connamespace = 'lis'::regnamespace
  AND NOT EXISTS (
        SELECT 1
        FROM pg_index i
        WHERE i.indrelid = c.conrelid
          AND (i.indpred IS NULL
               OR pg_get_expr(i.indpred, i.indrelid) ~ '^\(\w+ IS NOT NULL\)$')
          AND (string_to_array(i.indkey::text, ' ')::int2[])[1:cardinality(c.conkey)] = c.conkey
  );
\pset tuples_only off
\pset format aligned
SELECT tabla, fk FROM fk_sin_indice;
\pset tuples_only on
\pset format unaligned
SELECT pg_temp.chk((SELECT count(*) FROM fk_sin_indice) = 0, 'Toda FK tiene un índice que la cubre');

SELECT pg_temp.chk(
    (SELECT count(*) FROM pg_constraint
      WHERE contype = 'f' AND connamespace = 'lis'::regnamespace
        AND (confdeltype <> 'r' OR confupdtype <> 'r')) = 0,
    'Toda FK usa ON DELETE RESTRICT ON UPDATE RESTRICT');

SELECT pg_temp.chk(
    (SELECT count(*) FROM information_schema.columns
      WHERE table_schema = 'lis' AND column_name = 'id'
        AND column_default = 'gen_uuid_v7()') = 24,
    'Las 24 tablas usan PK id con DEFAULT gen_uuid_v7()');

SELECT pg_temp.chk(
    (SELECT count(*) FROM information_schema.columns
      WHERE table_schema = 'lis' AND data_type = 'timestamp without time zone') = 0,
    'Ninguna columna usa TIMESTAMP sin zona horaria');

SELECT pg_temp.chk(
    (SELECT count(*) FROM information_schema.columns
      WHERE table_schema = 'lis' AND data_type IN ('real', 'double precision')) = 0,
    'Ninguna columna usa FLOAT/REAL');

SELECT pg_temp.chk(
    (SELECT array_agg(table_name::text || '.' || column_name::text ORDER BY table_name) FROM information_schema.columns
      WHERE table_schema = 'lis' AND data_type = 'jsonb')
    = ARRAY['personal.certificaciones'],
    'Solo personal.certificaciones sigue en JSONB (antecedentes y resultados normalizados)');

SELECT pg_temp.chk(
    (SELECT count(*) FROM pg_attribute a
       JOIN pg_class t ON t.oid = a.attrelid AND t.relkind = 'r'
      WHERE t.relnamespace = 'lis'::regnamespace AND a.attnum > 0 AND NOT a.attisdropped
        AND NOT a.attnotnull
        AND col_description(a.attrelid, a.attnum) IS NULL) = 0,
    'Toda columna que admite NULL tiene COMMENT que lo justifica (regla 4)');

SELECT pg_temp.chk(
    (SELECT array_agg(table_name::text ORDER BY table_name) FROM information_schema.columns
      WHERE table_schema = 'lis' AND column_name = 'activo')
    = ARRAY['antecedente_paciente', 'estudio', 'medico', 'paciente', 'paquete',
            'parametro_estudio', 'personal', 'valor_referencia'],
    'activo solo en catálogos con borrado lógico (no en equipo ni tablas puente)');

SELECT pg_temp.chk(
    (SELECT count(*) FROM pg_type WHERE typnamespace = 'lis'::regnamespace AND typtype = 'e') = 19,
    'Existen los 19 tipos ENUM');

SELECT pg_temp.chk(
    (SELECT count(DISTINCT tgname) FROM pg_trigger
      WHERE NOT tgisinternal AND tgrelid::regclass::text IN
            ('detalle_solicitud', 'procesamiento', 'resultado', 'resultado_valor', 'detalle_cuenta', 'pago',
             'muestra_detalle_solicitud')) = 11,
    'Existen los 11 triggers de negocio');

-- -----------------------------------------------------------------------------
-- 2. Flujo end-to-end
--    paciente -> solicitud con paquete + estudio suelto -> cuenta -> 2 tubos
--    para 3 estudios -> procesamiento -> resultados por analito (con una
--    corrección) -> pagos
-- -----------------------------------------------------------------------------
INSERT INTO paciente (id, curp, nombre, apellido_paterno, fecha_nacimiento, sexo_biologico, correo)
VALUES ('00000000-0000-7000-8000-00000000e001', 'LOMA850315MCSPRR02', 'María de los Ángeles Guadalupe', 'López',
        '1985-03-15', 'F', 'maria.lopez@example.com');
INSERT INTO antecedente_paciente (paciente_id, tipo, descripcion) VALUES
    ('00000000-0000-7000-8000-00000000e001', 'alergia',            'Penicilina'),
    ('00000000-0000-7000-8000-00000000e001', 'enfermedad_cronica', 'Hipotiroidismo');
INSERT INTO medico (id, cedula_profesional, nombre, apellido_paterno)
VALUES ('00000000-0000-7000-8000-00000000e002', 'CED-E2E-01', 'Carlos', 'Ramírez');
INSERT INTO personal (id, numero_empleado, nombre, apellido_paterno, rol) VALUES
    ('00000000-0000-7000-8000-00000000e003', 'EMP-E2E-01', 'Laura', 'Méndez', 'flebotomista'),
    ('00000000-0000-7000-8000-00000000e004', 'EMP-E2E-02', 'Pedro', 'Sánchez', 'tecnico_laboratorio'),
    ('00000000-0000-7000-8000-00000000e005', 'EMP-E2E-03', 'Elena', 'Torres', 'supervisor');
INSERT INTO equipo (id, numero_serie, nombre_modelo)
VALUES ('00000000-0000-7000-8000-00000000e006', 'SN-E2E-01', 'Analizador Multiparamétrico');
INSERT INTO estudio (id, codigo, nombre, categoria, precio) VALUES
    ('00000000-0000-7000-8000-00000000e011', 'E2E-HEM', 'Biometría hemática', 'Hematologia',     150.00),
    ('00000000-0000-7000-8000-00000000e012', 'E2E-GLU', 'Glucosa',            'Quimica_Clinica',  80.00),
    ('00000000-0000-7000-8000-00000000e013', 'E2E-LIP', 'Perfil lipídico',    'Quimica_Clinica', 120.00);
INSERT INTO estudio_tipo_muestra (estudio_id, tipo_muestra, es_preferida)
SELECT id, 'sangre_venosa', TRUE FROM estudio WHERE codigo LIKE 'E2E-%';
INSERT INTO parametro_estudio (id, estudio_id, nombre, unidad_medida, orden) VALUES
    ('00000000-0000-7000-8000-00000000e041', '00000000-0000-7000-8000-00000000e011', 'Hemoglobina', 'g/dL',     1),
    ('00000000-0000-7000-8000-00000000e044', '00000000-0000-7000-8000-00000000e011', 'Leucocitos',  'x10^3/uL', 2),
    ('00000000-0000-7000-8000-00000000e042', '00000000-0000-7000-8000-00000000e012', 'Glucosa',     'mg/dL',    1),
    ('00000000-0000-7000-8000-00000000e043', '00000000-0000-7000-8000-00000000e013', 'Colesterol',  'mg/dL',    1);
INSERT INTO valor_referencia (id, parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable) VALUES
    ('00000000-0000-7000-8000-00000000e031', '00000000-0000-7000-8000-00000000e041', 12.0, 16.0, 'F'),
    ('00000000-0000-7000-8000-00000000e034', '00000000-0000-7000-8000-00000000e044', 4.5,  11.0, NULL),
    ('00000000-0000-7000-8000-00000000e032', '00000000-0000-7000-8000-00000000e042', 70,   100,  NULL),
    ('00000000-0000-7000-8000-00000000e033', '00000000-0000-7000-8000-00000000e043', NULL, 200,  NULL);
INSERT INTO paquete (id, codigo, nombre, precio_paquete)
VALUES ('00000000-0000-7000-8000-00000000e021', 'E2E-PKG', 'Check-up Básico', 180.00);
INSERT INTO paquete_estudio (paquete_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-00000000e021', '00000000-0000-7000-8000-00000000e012'),
    ('00000000-0000-7000-8000-00000000e021', '00000000-0000-7000-8000-00000000e013');
INSERT INTO estudio_equipo (estudio_id, equipo_id, es_equipo_primario)
SELECT id, '00000000-0000-7000-8000-00000000e006', TRUE
FROM estudio WHERE codigo LIKE 'E2E-%';

-- Solicitud: estudio suelto + expansión del paquete
INSERT INTO solicitud (id, paciente_id, medico_id, prioridad)
VALUES ('00000000-0000-7000-8000-00000000e101', '00000000-0000-7000-8000-00000000e001',
        '00000000-0000-7000-8000-00000000e002', 'urgente');
INSERT INTO detalle_solicitud (solicitud_id, estudio_id, paquete_origen_id)
VALUES ('00000000-0000-7000-8000-00000000e101', '00000000-0000-7000-8000-00000000e011', NULL);
INSERT INTO detalle_solicitud (solicitud_id, estudio_id, paquete_origen_id)
SELECT '00000000-0000-7000-8000-00000000e101', pe.estudio_id, pe.paquete_id
FROM paquete_estudio pe
WHERE pe.paquete_id = '00000000-0000-7000-8000-00000000e021';

SELECT pg_temp.chk((SELECT folio ~ '^SOL-\d{4}-\d{6}$' FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101'),
                   'Folio generado con formato SOL-YYYY-NNNNNN');
SELECT pg_temp.chk((SELECT count(*) FROM detalle_solicitud WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101') = 3,
                   'Paquete expandido: 1 suelto + 2 del paquete = 3 detalles');

-- Cuenta: 1 línea por estudio suelto, 1 sola línea por el paquete
INSERT INTO cuenta (id, solicitud_id)
VALUES ('00000000-0000-7000-8000-00000000e501', '00000000-0000-7000-8000-00000000e101');
INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
SELECT '00000000-0000-7000-8000-00000000e501', 'estudio_individual', ds.id, e.nombre, e.precio
FROM detalle_solicitud ds
JOIN estudio e ON e.id = ds.estudio_id
WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101' AND ds.paquete_origen_id IS NULL;
INSERT INTO detalle_cuenta (cuenta_id, origen, concepto, precio_unitario)
SELECT '00000000-0000-7000-8000-00000000e501', 'paquete', p.nombre, p.precio_paquete
FROM paquete p WHERE p.id = '00000000-0000-7000-8000-00000000e021';

SELECT pg_temp.chk((SELECT numero_cuenta ~ '^CTA-\d{4}-\d{6}$' FROM cuenta WHERE id = '00000000-0000-7000-8000-00000000e501'),
                   'Número de cuenta con formato CTA-YYYY-NNNNNN');
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente, estado_pago) = (330.00, 330.00, 330.00, 'pendiente'::estado_cuenta)
                      FROM cuenta WHERE id = '00000000-0000-7000-8000-00000000e501'),
                   'Cuenta: 150 suelto + 180 paquete (no 80+120) = 330 pendiente');

-- Toma de muestras: tubo EDTA para la BH, un solo tubo de química para glucosa y lípidos
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id, volumen_ml, temperatura_conservacion) VALUES
    ('00000000-0000-7000-8000-00000000e201', 'E2E-EDTA', '00000000-0000-7000-8000-00000000e101', 'sangre_venosa',
     '00000000-0000-7000-8000-00000000e003', 3.00, 'refrigerada'),
    ('00000000-0000-7000-8000-00000000e202', 'E2E-QC',   '00000000-0000-7000-8000-00000000e101', 'sangre_venosa',
     '00000000-0000-7000-8000-00000000e003', 5.00, 'refrigerada');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id)
SELECT CASE ds.estudio_id WHEN '00000000-0000-7000-8000-00000000e011'
            THEN '00000000-0000-7000-8000-00000000e201'::uuid
            ELSE '00000000-0000-7000-8000-00000000e202'::uuid END,
       ds.id
FROM detalle_solicitud ds
WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101';
SELECT pg_temp.chk((SELECT count(DISTINCT mds.muestra_id) = 2 AND count(*) = 3
                      FROM muestra_detalle_solicitud mds JOIN muestra m ON m.id = mds.muestra_id
                     WHERE m.solicitud_id = '00000000-0000-7000-8000-00000000e101'),
                   '2 tubos cubren 3 estudios (un tubo compartido por glucosa y lípidos)');
UPDATE detalle_solicitud SET estado = 'muestra_tomada'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101') = 'en_toma_de_muestra',
                   'Muestras tomadas -> solicitud en_toma_de_muestra');

-- Procesamiento: una corrida por (tubo, estudio)
INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
SELECT mds.muestra_id, mds.detalle_solicitud_id, '00000000-0000-7000-8000-00000000e006', '00000000-0000-7000-8000-00000000e004'
FROM muestra_detalle_solicitud mds
JOIN detalle_solicitud ds ON ds.id = mds.detalle_solicitud_id
WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101';
SELECT pg_temp.espera_error($$
    INSERT INTO lis.procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    SELECT '00000000-0000-7000-8000-00000000e201', ds.id, '00000000-0000-7000-8000-00000000e006', '00000000-0000-7000-8000-00000000e004'
    FROM lis.detalle_solicitud ds
    WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101' AND ds.estudio_id = '00000000-0000-7000-8000-00000000e012'
$$, '23503', 'Procesar glucosa con el tubo EDTA (no vinculado) es rechazado por la FK compuesta');
UPDATE detalle_solicitud SET estado = 'en_procesamiento'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101';
UPDATE muestra SET estado = 'en_analisis'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101') = 'en_procesamiento',
                   'Procesamiento iniciado -> solicitud en_procesamiento');

-- Resultados: una cabecera por corrida, un valor por analito
INSERT INTO resultado (procesamiento_id, es_definitivo)
SELECT p.id, TRUE
FROM procesamiento p
JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101';
INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion)
SELECT r.id, pe.id, vr.id,
       CASE pe.nombre WHEN 'Hemoglobina' THEN 11.2 WHEN 'Leucocitos' THEN 7.0
                      WHEN 'Glucosa' THEN 92 ELSE 185 END,
       CASE pe.nombre WHEN 'Hemoglobina' THEN 'bajo' ELSE 'normal' END::interpretacion_resultado
FROM resultado r
JOIN procesamiento p ON p.id = r.procesamiento_id
JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
JOIN parametro_estudio pe ON pe.estudio_id = ds.estudio_id
JOIN valor_referencia vr ON vr.parametro_estudio_id = pe.id AND vr.activo
WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101';
SELECT pg_temp.chk((SELECT count(*) FROM resultado_valor rv
                      JOIN resultado r ON r.id = rv.resultado_id
                      JOIN procesamiento p ON p.id = r.procesamiento_id
                      JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
                     WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101') = 4,
                   '3 resultados con 4 valores (la BH reporta 2 analitos)');
SELECT pg_temp.chk((SELECT e.numero_serie = 'SN-E2E-01' AND per.numero_empleado = 'EMP-E2E-02'
                      FROM resultado r
                      JOIN procesamiento p ON p.id = r.procesamiento_id
                      JOIN equipo e ON e.id = p.equipo_id
                      JOIN personal per ON per.id = p.personal_id
                      JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
                     WHERE ds.solicitud_id = '00000000-0000-7000-8000-00000000e101'
                       AND ds.estudio_id = '00000000-0000-7000-8000-00000000e011'),
                   'Trazabilidad: del resultado se llega a equipo y operador');
UPDATE procesamiento p SET estado = 'completado', fecha_fin = now()
  FROM detalle_solicitud ds
 WHERE ds.id = p.detalle_solicitud_id AND ds.solicitud_id = '00000000-0000-7000-8000-00000000e101';
UPDATE muestra SET estado = 'analizada'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101';

-- Primero se completa un estudio, luego el resto
UPDATE detalle_solicitud SET estado = 'completado'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101'
   AND estudio_id = '00000000-0000-7000-8000-00000000e011';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101') = 'parcialmente_completada',
                   '1 de 3 completado -> parcialmente_completada');
UPDATE detalle_solicitud SET estado = 'completado'
 WHERE solicitud_id = '00000000-0000-7000-8000-00000000e101' AND estado <> 'completado';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101') = 'completada',
                   '3 de 3 completados -> completada');

-- Corrección de la hemoglobina por recalibración
SET LOCAL lis.personal_id = '00000000-0000-7000-8000-00000000e005';
SET LOCAL lis.motivo_modificacion = 'Recalibración del equipo';
UPDATE resultado_valor SET valor_numerico = 12.4, interpretacion = 'normal'
 WHERE parametro_estudio_id = '00000000-0000-7000-8000-00000000e041';
SELECT pg_temp.chk((SELECT count(*) = 1 AND min(h.valor_numerico_snapshot) = 11.2 AND max(rv.numero_version) = 2
                      FROM historial_resultado_valor h
                      JOIN resultado_valor rv ON rv.id = h.resultado_valor_id
                     WHERE rv.parametro_estudio_id = '00000000-0000-7000-8000-00000000e041'),
                   'Corrección versionada: historial con 11.2, valor en versión 2');
SELECT pg_temp.chk((SELECT count(*) FROM historial_resultado_valor) = 1,
                   'Solo el analito corregido genera historial');

-- Pagos: parcial + liquidación
INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
VALUES ('00000000-0000-7000-8000-00000000e501', 130.00, 'efectivo', '00000000-0000-7000-8000-00000000e005');
SELECT pg_temp.chk((SELECT (saldo_pendiente, estado_pago) = (200.00, 'parcialmente_pagada'::estado_cuenta)
                      FROM cuenta WHERE id = '00000000-0000-7000-8000-00000000e501'),
                   'Pago parcial 130 -> saldo 200, parcialmente_pagada');
SELECT pg_temp.espera_error($$
    INSERT INTO lis.pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES ('00000000-0000-7000-8000-00000000e501', 250.00, 'tarjeta_credito', '00000000-0000-7000-8000-00000000e005')
$$, '23514', 'Pago de 250 con saldo 200 es rechazado');
INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, referencia_pago, recibido_por)
VALUES ('00000000-0000-7000-8000-00000000e501', 200.00, 'tarjeta_credito', 'AUT-778812', '00000000-0000-7000-8000-00000000e005');

UPDATE solicitud SET estado_global = 'entregada' WHERE id = '00000000-0000-7000-8000-00000000e101';

-- Consistencia final de todos los campos desnormalizados
SELECT pg_temp.chk((
    SELECT c.subtotal = (SELECT sum(precio_unitario) FROM detalle_cuenta WHERE cuenta_id = c.id AND NOT anulado)
       AND c.total = c.subtotal - c.descuento_total
       AND c.saldo_pendiente = c.total - (SELECT sum(monto_pagado) FROM pago WHERE cuenta_id = c.id AND estado = 'aplicado')
       AND c.estado_pago = 'pagada'
       AND c.saldo_pendiente = 0
    FROM cuenta c WHERE c.id = '00000000-0000-7000-8000-00000000e501'),
    'Cuenta final consistente: subtotal = Σ líneas, total = subtotal - descuento, saldo 0, pagada');
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-00000000e101') = 'entregada',
                   'Solicitud final: entregada');
SELECT pg_temp.chk((SELECT count(*) FROM antecedente_paciente
                     WHERE tipo = 'alergia' AND descripcion ILIKE '%penicilina%' AND activo) = 1,
                   'Búsqueda de pacientes alérgicos a penicilina por tipo de antecedente');

-- -----------------------------------------------------------------------------
-- 3. Rangos de referencia con vigencia
-- -----------------------------------------------------------------------------
SELECT pg_temp.espera_error($$
    INSERT INTO lis.valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, edad_minima)
    VALUES ('00000000-0000-7000-8000-00000000e041', 11.5, 15.5, 'F', 18)
$$, '23P01', 'Rango de Hemoglobina F traslapado con el vigente es rechazado (EXCLUDE)');
SELECT pg_temp.espera_error($$
    INSERT INTO lis.valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable)
    VALUES ('00000000-0000-7000-8000-00000000e041', 12.0, 17.0, NULL)
$$, '23P01', 'Rango para ambos sexos (NULL) traslapado con uno de F es rechazado (EXCLUDE)');
INSERT INTO valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable)
VALUES ('00000000-0000-7000-8000-00000000e041', 13.5, 17.5, 'M');
SELECT pg_temp.chk((SELECT count(*) FROM valor_referencia WHERE parametro_estudio_id = '00000000-0000-7000-8000-00000000e041') = 2,
                   'Rangos de M y F del mismo analito y periodo coexisten');

-- activo = FALSE anula un rango mal capturado y libera su lugar para la corrección
INSERT INTO valor_referencia (id, parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, edad_maxima)
VALUES ('00000000-0000-7000-8000-00000000e036', '00000000-0000-7000-8000-00000000e041', 10, 14, 'Intersex', NULL);
SELECT pg_temp.espera_error($$
    INSERT INTO lis.valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, edad_maxima)
    VALUES ('00000000-0000-7000-8000-00000000e041', 12, 16, 'Intersex', NULL)
$$, '23P01', 'La corrección choca mientras el rango erróneo siga activo');
UPDATE valor_referencia SET activo = FALSE WHERE id = '00000000-0000-7000-8000-00000000e036';
INSERT INTO valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, edad_maxima)
VALUES ('00000000-0000-7000-8000-00000000e041', 12, 16, 'Intersex', NULL);
SELECT pg_temp.chk(TRUE, 'Anulado el rango erróneo (activo = FALSE), la corrección se acepta');

-- Cambio de rango: se cierra el vigente y el nuevo arranca ese mismo día
UPDATE valor_referencia SET vigente_hasta = CURRENT_DATE + 30
 WHERE id = '00000000-0000-7000-8000-00000000e031';
INSERT INTO valor_referencia (id, parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, vigente_desde)
VALUES ('00000000-0000-7000-8000-00000000e035', '00000000-0000-7000-8000-00000000e041', 11.5, 15.5, 'F', CURRENT_DATE + 30);
SELECT pg_temp.chk((SELECT valor_referencia_id FROM resultado_valor
                     WHERE parametro_estudio_id = '00000000-0000-7000-8000-00000000e041')
                   = '00000000-0000-7000-8000-00000000e031',
                   'Nuevo rango consecutivo se acepta y el resultado previo conserva su rango original');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.valor_referencia (parametro_estudio_id, sexo_aplicable)
    VALUES ('00000000-0000-7000-8000-00000000e042', 'M')
$$, '23514', 'Rango sin mínimo ni máximo es rechazado');

-- -----------------------------------------------------------------------------
-- 4. Validaciones de formato
-- -----------------------------------------------------------------------------
SELECT pg_temp.espera_error($$
    INSERT INTO lis.paciente (curp, nombre, apellido_paterno, fecha_nacimiento, sexo_biologico)
    VALUES ('ABC123', 'Prueba', 'Formato', '2000-01-01', 'M')
$$, '23514', 'CURP con formato inválido es rechazada');
SELECT pg_temp.espera_error($$
    INSERT INTO lis.paciente (nombre, apellido_paterno, fecha_nacimiento, sexo_biologico, correo)
    VALUES ('Prueba', 'Formato', '2000-01-01', 'M', 'sin-arroba')
$$, '23514', 'Correo sin @ es rechazado');
SELECT pg_temp.chk((SELECT character_maximum_length FROM information_schema.columns
                     WHERE table_schema = 'lis' AND table_name = 'paciente' AND column_name = 'correo') = 254,
                   'correo admite 254 caracteres (RFC 5321)');

-- -----------------------------------------------------------------------------
-- 5. Los catálogos no admiten DELETE físico de filas referenciadas
-- -----------------------------------------------------------------------------
SELECT pg_temp.espera_error($$ DELETE FROM lis.estudio           WHERE id = '00000000-0000-7000-8000-00000000e011' $$, '23001', 'DELETE de ESTUDIO referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.paciente          WHERE id = '00000000-0000-7000-8000-00000000e001' $$, '23001', 'DELETE de PACIENTE referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.medico            WHERE id = '00000000-0000-7000-8000-00000000e002' $$, '23001', 'DELETE de MEDICO referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.personal          WHERE id = '00000000-0000-7000-8000-00000000e003' $$, '23001', 'DELETE de PERSONAL referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.equipo            WHERE id = '00000000-0000-7000-8000-00000000e006' $$, '23001', 'DELETE de EQUIPO referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.paquete           WHERE id = '00000000-0000-7000-8000-00000000e021' $$, '23001', 'DELETE de PAQUETE referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.parametro_estudio WHERE id = '00000000-0000-7000-8000-00000000e041' $$, '23001', 'DELETE de PARAMETRO_ESTUDIO referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.valor_referencia  WHERE id = '00000000-0000-7000-8000-00000000e031' $$, '23001', 'DELETE de VALOR_REFERENCIA referenciado falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.muestra           WHERE id = '00000000-0000-7000-8000-00000000e202' $$, '23001', 'DELETE de MUESTRA vinculada falla por RESTRICT');
SELECT pg_temp.espera_error($$ DELETE FROM lis.solicitud         WHERE id = '00000000-0000-7000-8000-00000000e101' $$, '23001', 'DELETE de SOLICITUD con detalles falla por RESTRICT');

ROLLBACK;
