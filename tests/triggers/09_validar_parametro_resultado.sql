-- =============================================================================
-- Prueba 9 — trg_validar_parametro_resultado
-- Un RESULTADO_VALOR solo admite analitos del estudio que se procesó:
-- Hemoglobina en una corrida de glucosa se rechaza, al insertar y al
-- reasignar el parámetro con UPDATE.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

-- Corrida de glucosa (estudio ...0012)
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', 'en_procesamiento');
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000302', 'T-CB-0002', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000202');
INSERT INTO procesamiento (id, muestra_id, detalle_solicitud_id, equipo_id, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000352', '00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000202',
     '00000000-0000-7000-8000-000000000007', '00000000-0000-7000-8000-000000000004');
INSERT INTO resultado (id, procesamiento_id) VALUES
    ('00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000352');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.resultado_valor (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico)
    VALUES ('00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000041',
            '00000000-0000-7000-8000-000000000031', 14.0)
$$, '23514', 'Hemoglobina en una corrida de glucosa es rechazada');

INSERT INTO resultado_valor (id, resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion) VALUES
    ('00000000-0000-7000-8000-000000000413', '00000000-0000-7000-8000-000000000402', '00000000-0000-7000-8000-000000000042',
     '00000000-0000-7000-8000-000000000032', 92, 'normal');
SELECT pg_temp.chk((SELECT count(*) FROM resultado_valor WHERE resultado_id = '00000000-0000-7000-8000-000000000402') = 1,
                 'Glucosa en su propia corrida se registra');

SELECT pg_temp.espera_error($$
    UPDATE lis.resultado_valor
       SET parametro_estudio_id = '00000000-0000-7000-8000-000000000044', valor_referencia_id = NULL
     WHERE id = '00000000-0000-7000-8000-000000000413'
$$, '23514', 'Reasignar el valor a Leucocitos (otro estudio) con UPDATE es rechazado');

ROLLBACK;
