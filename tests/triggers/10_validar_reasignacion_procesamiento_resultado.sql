-- =============================================================================
-- Prueba 10 — trg_validar_reasignacion_procesamiento / trg_validar_reasignacion_resultado
-- Reasignar procesamiento.detalle_solicitud_id o resultado.procesamiento_id
-- a otro estudio después de capturar valores se rechaza. Antes de capturar
-- valores, o hacia un procesamiento del mismo estudio, se permite.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

-- d1 biometría hemática (...0011), d2 glucosa (...0012)
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', 'en_procesamiento'),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', 'en_procesamiento');
-- Un solo tubo (301) sirve a los dos estudios, así la FK compuesta de
-- procesamiento admite reasignarlo de un detalle a otro sin cambiar de tubo.
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000301', 'T-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201'),
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000202');
INSERT INTO procesamiento (id, muestra_id, detalle_solicitud_id, equipo_id, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000351', '00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201',
     '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004'),
    ('00000000-0000-7000-8000-000000000352', '00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000202',
     '00000000-0000-7000-8000-000000000007', '00000000-0000-7000-8000-000000000004');

-- Sin resultado todavía: reasignar el procesamiento de BH a glucosa se permite
UPDATE procesamiento SET detalle_solicitud_id = '00000000-0000-7000-8000-000000000202'
 WHERE id = '00000000-0000-7000-8000-000000000351';
SELECT pg_temp.chk((SELECT detalle_solicitud_id FROM procesamiento WHERE id = '00000000-0000-7000-8000-000000000351')
                   = '00000000-0000-7000-8000-000000000202',
                 'Sin resultado capturado, reasignar el procesamiento se permite');
UPDATE procesamiento SET detalle_solicitud_id = '00000000-0000-7000-8000-000000000201'
 WHERE id = '00000000-0000-7000-8000-000000000351';

-- Se captura un resultado de Hemoglobina en el procesamiento de BH
INSERT INTO resultado (id, procesamiento_id) VALUES
    ('00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000351'),
    ('00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000352');
INSERT INTO resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion) VALUES
    ('00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000041',
     '00000000-0000-7000-8000-000000000031', 14.0, 'normal');

SELECT pg_temp.espera_error($$
    UPDATE lis.procesamiento SET detalle_solicitud_id = '00000000-0000-7000-8000-000000000202'
     WHERE id = '00000000-0000-7000-8000-000000000351'
$$, '23514', 'Reasignar a glucosa un procesamiento con Hemoglobina ya capturada es rechazado');

SELECT pg_temp.espera_error($$
    UPDATE lis.resultado SET procesamiento_id = '00000000-0000-7000-8000-000000000352'
     WHERE id = '00000000-0000-7000-8000-000000000401'
$$, '23514', 'Mover el resultado con Hemoglobina al procesamiento de glucosa es rechazado');

-- Reasignar a un procesamiento del mismo estudio (BH, repetición) se permite
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado, numero_repeticion) VALUES
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', 'en_procesamiento', 1);
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000203');
INSERT INTO procesamiento (id, muestra_id, detalle_solicitud_id, equipo_id, personal_id, es_reprocesamiento) VALUES
    ('00000000-0000-7000-8000-000000000353', '00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000203',
     '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004', TRUE);
UPDATE resultado SET procesamiento_id = '00000000-0000-7000-8000-000000000353'
 WHERE id = '00000000-0000-7000-8000-000000000401';
SELECT pg_temp.chk((SELECT procesamiento_id FROM resultado WHERE id = '00000000-0000-7000-8000-000000000401')
                   = '00000000-0000-7000-8000-000000000353',
                 'Mover el resultado a otro procesamiento del mismo estudio se permite');

ROLLBACK;
