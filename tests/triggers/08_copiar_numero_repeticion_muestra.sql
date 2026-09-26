-- =============================================================================
-- Prueba 8 — trg_copiar_numero_repeticion_muestra
-- Al vincular un tubo con un estudio (MUESTRA_DETALLE_SOLICITUD):
--   * numero_repeticion se copia de DETALLE_SOLICITUD e ignora el valor
--     enviado por la aplicación;
--   * un mismo tubo puede servir a varios estudios;
--   * se rechaza un tubo de otra solicitud o de un tipo no aceptado.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', 'muestra_tomada'),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', 'muestra_tomada'),
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000013', 'muestra_tomada');

INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000301', 'T-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003'),
    ('00000000-0000-7000-8000-000000000302', 'T-CB-0002', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');

INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id, numero_repeticion) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201', 5);
SELECT pg_temp.chk((SELECT numero_repeticion FROM muestra_detalle_solicitud
                     WHERE muestra_id = '00000000-0000-7000-8000-000000000301') = 0,
                 'Primer intento: la app envía 5, se guarda 0 (valor del detalle)');

-- Un solo tubo para glucosa y perfil lipídico
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000202'),
    ('00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000203');
SELECT pg_temp.chk((SELECT count(*) FROM muestra_detalle_solicitud
                     WHERE muestra_id = '00000000-0000-7000-8000-000000000302') = 2,
                 'Un tubo sirve a dos estudios');

-- Repetición: el tubo hemolizado se descarta y el detalle pasa al intento 1
UPDATE muestra SET estado = 'descartada', condicion = 'hemolizada' WHERE id = '00000000-0000-7000-8000-000000000301';
UPDATE detalle_solicitud SET estado = 'requiere_repeticion', motivo_repeticion = 'Muestra hemolizada', numero_repeticion = 1
 WHERE id = '00000000-0000-7000-8000-000000000201';

INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000303', 'T-CB-0003', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003'),
    ('00000000-0000-7000-8000-000000000304', 'T-CB-0004', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003'),
    ('00000000-0000-7000-8000-000000000305', 'T-CB-0005', '00000000-0000-7000-8000-000000000101', 'orina',         '00000000-0000-7000-8000-000000000003');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000303', '00000000-0000-7000-8000-000000000201');
SELECT pg_temp.chk((SELECT numero_repeticion FROM muestra_detalle_solicitud
                     WHERE muestra_id = '00000000-0000-7000-8000-000000000303') = 1,
                 'Segundo intento: sin valor explícito, se guarda 1 (intento vigente del detalle)');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.muestra_detalle_solicitud (muestra_id, detalle_solicitud_id, numero_repeticion)
    VALUES ('00000000-0000-7000-8000-000000000304', '00000000-0000-7000-8000-000000000201', 0)
$$, '23505', 'Otro tubo para el mismo intento (la app envía 0, se fuerza 1) choca con UNIQUE(detalle, repeticion)');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.muestra_detalle_solicitud (muestra_id, detalle_solicitud_id)
    VALUES ('00000000-0000-7000-8000-000000000305', '00000000-0000-7000-8000-000000000203')
$$, '23514', 'Tubo de orina para perfil lipídico (solo sangre_venosa) es rechazado');

-- Tubo de otra solicitud del mismo paciente
INSERT INTO solicitud (id, paciente_id, medico_id) VALUES
    ('00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000001', '00000000-0000-7000-8000-000000000002');
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000306', 'T-CB-0006', '00000000-0000-7000-8000-000000000102', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');
SELECT pg_temp.espera_error($$
    INSERT INTO lis.muestra_detalle_solicitud (muestra_id, detalle_solicitud_id)
    VALUES ('00000000-0000-7000-8000-000000000306', '00000000-0000-7000-8000-000000000202')
$$, '23514', 'Tubo de otra solicitud es rechazado');

ROLLBACK;
