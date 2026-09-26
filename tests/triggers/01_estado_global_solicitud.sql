-- =============================================================================
-- Prueba 1 — trg_estado_global_solicitud
-- 2 DETALLE_SOLICITUD en 1 SOLICITUD; se cambia el estado de ambos y se
-- verifica el recálculo de solicitud.estado_global en cada paso.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

-- d1 = ...0201 (BH suelta), d2 = ...0202 (glucosa suelta)
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011'),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012');
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'recibida',
                 'INSERT de 2 detalles pendientes -> recibida');

UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id = '00000000-0000-7000-8000-000000000201';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'en_toma_de_muestra',
                 'd1 muestra_tomada, d2 pendiente -> en_toma_de_muestra');

UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = '00000000-0000-7000-8000-000000000201';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'en_procesamiento',
                 'd1 en_procesamiento -> en_procesamiento');

UPDATE detalle_solicitud SET estado = 'completado' WHERE id = '00000000-0000-7000-8000-000000000201';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'parcialmente_completada',
                 'd1 completado, d2 pendiente -> parcialmente_completada');

UPDATE detalle_solicitud SET estado = 'requiere_repeticion', motivo_repeticion = 'Muestra hemolizada'
 WHERE id = '00000000-0000-7000-8000-000000000202';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'parcialmente_completada',
                 'd2 requiere_repeticion con d1 completado -> sigue parcialmente_completada');

UPDATE detalle_solicitud SET estado = 'repetido_completado', numero_repeticion = 1
 WHERE id = '00000000-0000-7000-8000-000000000202';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'completada',
                 'd1 completado + d2 repetido_completado -> completada');

UPDATE solicitud SET estado_global = 'entregada' WHERE id = '00000000-0000-7000-8000-000000000101';
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000013', 'cancelado');
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'entregada',
                 'detalle cancelado no cuenta y "entregada" no se degrada a completada');

-- Segunda solicitud (...0102): todos sus detalles se cancelan
INSERT INTO solicitud (id, paciente_id, medico_id) VALUES
    ('00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000001', '00000000-0000-7000-8000-000000000002');
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000211', '00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000011', 'muestra_tomada'),
    ('00000000-0000-7000-8000-000000000212', '00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000012', 'pendiente_muestra');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000211';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000102') = 'recibida',
                 '1 de 2 cancelado: se evalúa solo el detalle vivo (pendiente) -> recibida');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000212';
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000102') = 'cancelada',
                 'Todos los detalles cancelados -> cancelada');

INSERT INTO detalle_solicitud (solicitud_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-000000000102', '00000000-0000-7000-8000-000000000013');
SELECT pg_temp.chk((SELECT estado_global FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000102') = 'recibida',
                 'Nuevo detalle en solicitud cancelada -> se recalcula (recibida)');

ROLLBACK;
