-- =============================================================================
-- Prueba 6 — trg_cancelar_detalle_cuenta
-- Cancelar un DETALLE_SOLICITUD suelto -> su DETALLE_CUENTA queda anulado y
-- la CUENTA se recalcula. Cancelar uno de paquete -> la CUENTA no cambia.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

-- d1 BH suelta; d2/d3 expansión del paquete (glucosa + lípidos)
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, paquete_origen_id) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011', NULL),
    ('00000000-0000-7000-8000-000000000202', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', '00000000-0000-7000-8000-000000000021'),
    ('00000000-0000-7000-8000-000000000203', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000013', '00000000-0000-7000-8000-000000000021');
INSERT INTO cuenta (id, solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000501', '00000000-0000-7000-8000-000000000101');
INSERT INTO detalle_cuenta (id, cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario) VALUES
    ('00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000501', 'estudio_individual', '00000000-0000-7000-8000-000000000201', 'Biometría hemática', 150.00),
    ('00000000-0000-7000-8000-000000000602', '00000000-0000-7000-8000-000000000501', 'paquete',            NULL,                                    'Check-up Básico',    180.00);
SELECT pg_temp.chk((SELECT total FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501') = 330.00,
                 'Estado inicial: total 330 (150 suelto + 180 paquete)');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000201';
SELECT pg_temp.chk((SELECT anulado FROM detalle_cuenta WHERE id = '00000000-0000-7000-8000-000000000601'),
                 'Cancelar estudio suelto -> su línea de cuenta queda anulada');
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente) = (180.00, 180.00, 180.00)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'CUENTA recalculada: 330 -> 180');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000202';
SELECT pg_temp.chk((SELECT NOT anulado FROM detalle_cuenta WHERE id = '00000000-0000-7000-8000-000000000602'),
                 'Cancelar estudio de paquete -> la línea del paquete NO se anula');
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente) = (180.00, 180.00, 180.00)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'CUENTA sin cambio: sigue en 180 (sin reembolso parcial de paquetes)');

ROLLBACK;
