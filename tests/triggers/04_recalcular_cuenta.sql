-- =============================================================================
-- Prueba 4 — trg_recalcular_cuenta
-- INSERT/UPDATE en DETALLE_CUENTA y PAGO -> recálculo de subtotal, total,
-- saldo_pendiente y estado_pago de CUENTA.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir _fixtures.sql

INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-000000000201', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011');
INSERT INTO cuenta (id, solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000501', '00000000-0000-7000-8000-000000000101');

INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario) VALUES
    ('00000000-0000-7000-8000-000000000501', 'estudio_individual', '00000000-0000-7000-8000-000000000201', 'Biometría hemática', 150.00);
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente, estado_pago) = (150.00, 150.00, 150.00, 'pendiente'::estado_cuenta)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'INSERT línea individual 150 -> subtotal/total/saldo 150, pendiente');

INSERT INTO detalle_cuenta (id, cuenta_id, origen, concepto, precio_unitario) VALUES
    ('00000000-0000-7000-8000-000000000601', '00000000-0000-7000-8000-000000000501', 'paquete', 'Check-up Básico', 180.00);
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente) = (330.00, 330.00, 330.00)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'INSERT línea de paquete 180 -> 330');

INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por) VALUES
    ('00000000-0000-7000-8000-000000000501', 100.00, 'efectivo', '00000000-0000-7000-8000-000000000005');
SELECT pg_temp.chk((SELECT (saldo_pendiente, estado_pago) = (230.00, 'parcialmente_pagada'::estado_cuenta)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'PAGO 100 -> saldo 230, parcialmente_pagada');

UPDATE detalle_cuenta SET precio_unitario = 150.00 WHERE id = '00000000-0000-7000-8000-000000000601';
SELECT pg_temp.chk((SELECT (subtotal, total, saldo_pendiente) = (300.00, 300.00, 200.00)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'UPDATE precio de línea 180 -> 150 -> subtotal 300, saldo 200');

UPDATE pago SET estado = 'cancelado' WHERE cuenta_id = '00000000-0000-7000-8000-000000000501';
SELECT pg_temp.chk((SELECT (saldo_pendiente, estado_pago) = (300.00, 'pendiente'::estado_cuenta)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'Cancelar el pago -> saldo 300, vuelve a pendiente');

SELECT pg_temp.espera_error($$
    UPDATE lis.cuenta SET descuento_total = 500 WHERE id = '00000000-0000-7000-8000-000000000501';
    INSERT INTO lis.detalle_cuenta (cuenta_id, origen, concepto, precio_unitario)
    VALUES ('00000000-0000-7000-8000-000000000501', 'paquete', 'Ajuste', 0)
$$, '23514', 'Descuento mayor al subtotal deja total negativo -> CHECK lo rechaza');

ROLLBACK;
