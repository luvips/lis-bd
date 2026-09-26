-- =============================================================================
-- Prueba 7 — trg_descartar_muestra_cancelada
-- Cancelar un DETALLE_SOLICITUD con tubo en 'tomada' -> 'descartada'.
-- Aplica también a estudios de paquete. Tubos ya analizados no cambian.
-- Un tubo compartido solo se descarta cuando se cancela el último estudio
-- vigente que lo usa.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

-- d1 suelto con tubo propio tomado; d2 y d3 de paquete comparten un tubo
-- en_analisis; d4 (otra BH, intento aparte) con tubo ya analizado.
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, paquete_origen_id, estado, numero_repeticion) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', NULL,                                    'muestra_tomada',   0),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', '00000000-0000-7000-8000-000000000021', 'en_procesamiento', 0),
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000013', '00000000-0000-7000-8000-000000000021', 'en_procesamiento', 0),
    ('00000000-0000-7000-8000-000000000204', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', NULL,                                    'en_procesamiento', 1);
INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000301', 'T-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003', 'tomada'),
    ('00000000-0000-7000-8000-000000000302', 'T-CB-0002', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003', 'en_analisis'),
    ('00000000-0000-7000-8000-000000000303', 'T-CB-0003', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003', 'analizada');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000301', '00000000-0000-7000-8000-000000000201'),
    ('00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000202'),
    ('00000000-0000-7000-8000-000000000302', '00000000-0000-7000-8000-000000000203'),
    ('00000000-0000-7000-8000-000000000303', '00000000-0000-7000-8000-000000000204');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000201';
SELECT pg_temp.chk((SELECT estado FROM muestra WHERE id = '00000000-0000-7000-8000-000000000301') = 'descartada',
                 'Detalle suelto cancelado: tubo tomado -> descartada');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000202';
SELECT pg_temp.chk((SELECT estado FROM muestra WHERE id = '00000000-0000-7000-8000-000000000302') = 'en_analisis',
                 'Tubo compartido: cancelar glucosa no lo descarta mientras lípidos siga vigente');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000203';
SELECT pg_temp.chk((SELECT estado FROM muestra WHERE id = '00000000-0000-7000-8000-000000000302') = 'descartada',
                 'Tubo compartido: al cancelar el último estudio vigente -> descartada');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000204';
SELECT pg_temp.chk((SELECT estado FROM muestra WHERE id = '00000000-0000-7000-8000-000000000303') = 'analizada',
                 'Tubo ya analizado no se modifica');

ROLLBACK;
