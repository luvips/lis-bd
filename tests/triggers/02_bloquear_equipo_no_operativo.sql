-- =============================================================================
-- Prueba 2 — trg_bloquear_equipo_no_operativo
-- Un EQUIPO en fuera_de_servicio no admite PROCESAMIENTO; uno operativo sí.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', 'muestra_tomada');
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000301', 'T-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201');

UPDATE equipo SET estado_operativo = 'fuera_de_servicio' WHERE id = '00000000-0000-7000-8000-000000000006';

SELECT pg_temp.espera_error($$
    INSERT INTO lis.procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004')
$$, '23514', 'Procesamiento en equipo fuera_de_servicio es rechazado');

UPDATE equipo SET estado_operativo = 'en_mantenimiento' WHERE id = '00000000-0000-7000-8000-000000000006';
SELECT pg_temp.espera_error($$
    INSERT INTO lis.procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
    VALUES ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004')
$$, '23514', 'Procesamiento en equipo en_mantenimiento es rechazado');

INSERT INTO procesamiento (muestra_id, detalle_solicitud_id, equipo_id, personal_id)
VALUES ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000007', '00000000-0000-7000-8000-000000000004');
SELECT pg_temp.chk((SELECT count(*) FROM procesamiento WHERE equipo_id = '00000000-0000-7000-8000-000000000007') = 1,
                 'Procesamiento en equipo operativo se registra');

ROLLBACK;
