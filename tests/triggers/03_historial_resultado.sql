-- =============================================================================
-- Prueba 3 — trg_historial_resultado
-- UPDATE de valor_numerico en RESULTADO_VALOR -> fila en
-- HISTORIAL_RESULTADO_VALOR con el valor anterior y numero_version
-- incrementado. Cada analito se versiona por separado. Cambios que no tocan
-- valores no generan historial. Sin variables de sesión la corrección se
-- rechaza.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', 'en_procesamiento');
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000301', 'T-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003', 'analizada');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201');
INSERT INTO procesamiento (id, muestra_id, detalle_solicitud_id, equipo_id, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000351', '00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201',
     '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004');
INSERT INTO resultado (id, procesamiento_id) VALUES
    ('00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000351');
-- Biometría: dos analitos en el mismo resultado
INSERT INTO resultado_valor (id, resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion) VALUES
    ('00000000-0000-7000-8000-000000000411', '00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000041',
     '00000000-0000-7000-8000-000000000031', 12.1, 'bajo'),
    ('00000000-0000-7000-8000-000000000412', '00000000-0000-7000-8000-000000000401', '00000000-0000-7000-8000-000000000044',
     '00000000-0000-7000-8000-000000000034', 7.2, 'normal');

SELECT pg_temp.espera_error($$
    UPDATE lis.resultado_valor SET valor_referencia_id = '00000000-0000-7000-8000-000000000031'
     WHERE id = '00000000-0000-7000-8000-000000000412'
$$, '23503', 'Rango de otro analito (Hemoglobina para Leucocitos) es rechazado por la FK compuesta');

SELECT pg_temp.espera_error($$
    UPDATE lis.resultado_valor SET valor_numerico = 14.2 WHERE id = '00000000-0000-7000-8000-000000000411'
$$, '23502', 'Corrección sin lis.personal_id / lis.motivo_modificacion es rechazada');

SET LOCAL lis.personal_id = '00000000-0000-7000-8000-000000000005';
SET LOCAL lis.motivo_modificacion = 'Error de captura';

UPDATE resultado_valor SET valor_numerico = 14.2, interpretacion = 'normal'
 WHERE id = '00000000-0000-7000-8000-000000000411';

SELECT pg_temp.chk((SELECT numero_version FROM resultado_valor WHERE id = '00000000-0000-7000-8000-000000000411') = 2,
                 'numero_version de Hemoglobina pasa de 1 a 2');
SELECT pg_temp.chk((SELECT numero_version FROM resultado_valor WHERE id = '00000000-0000-7000-8000-000000000412') = 1,
                 'Leucocitos no se tocó: sigue en versión 1');
SELECT pg_temp.chk((SELECT count(*) FROM historial_resultado_valor WHERE resultado_valor_id = '00000000-0000-7000-8000-000000000411') = 1,
                 'Se crea 1 fila en historial_resultado_valor');
SELECT pg_temp.chk((SELECT version = 1 AND valor_numerico_snapshot = 12.1 AND interpretacion_snapshot = 'bajo'
                         AND motivo_modificacion = 'Error de captura'
                         AND modificado_por = '00000000-0000-7000-8000-000000000005'
                    FROM historial_resultado_valor WHERE resultado_valor_id = '00000000-0000-7000-8000-000000000411'),
                 'Snapshot guarda versión 1, valor 12.1 / bajo, motivo y autor');

UPDATE resultado_valor SET numero_version = 99
 WHERE id = '00000000-0000-7000-8000-000000000411';
SELECT pg_temp.chk((SELECT numero_version FROM resultado_valor WHERE id = '00000000-0000-7000-8000-000000000411') = 2
                 AND (SELECT count(*) FROM historial_resultado_valor WHERE resultado_valor_id = '00000000-0000-7000-8000-000000000411') = 1,
                 'Cambio sin valores no versiona y numero_version no es editable a mano');

UPDATE resultado_valor SET valor_texto = 'Recalibrado'
 WHERE id = '00000000-0000-7000-8000-000000000411';
SELECT pg_temp.chk((SELECT numero_version FROM resultado_valor WHERE id = '00000000-0000-7000-8000-000000000411') = 3,
                 'Cambio en valor_texto también versiona (versión 3)');

ROLLBACK;
