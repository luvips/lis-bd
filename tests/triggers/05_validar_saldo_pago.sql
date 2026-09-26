-- =============================================================================
-- Prueba 5 — trg_validar_saldo_pago
-- PAGO que excede el saldo -> rechazado. PAGO válido -> saldo baja.
-- La serialización de pagos concurrentes (FOR UPDATE) se ejercita en la
-- batería de concurrencia (tests/volumen/).
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

SELECT pg_temp.espera_error($$
    INSERT INTO lis.pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES ('00000000-0000-7000-8000-000000000501', 200.00, 'efectivo', '00000000-0000-7000-8000-000000000005')
$$, '23514', 'PAGO 200 sobre saldo 150 es rechazado');

INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por) VALUES
    ('00000000-0000-7000-8000-000000000501', 50.00, 'tarjeta_debito', '00000000-0000-7000-8000-000000000005');
SELECT pg_temp.chk((SELECT saldo_pendiente FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501') = 100.00,
                 'PAGO válido 50 -> saldo baja a 100');

INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por) VALUES
    ('00000000-0000-7000-8000-000000000501', 100.00, 'transferencia', '00000000-0000-7000-8000-000000000005');
SELECT pg_temp.chk((SELECT (saldo_pendiente, estado_pago) = (0.00, 'pagada'::estado_cuenta)
                    FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000501'),
                 'PAGO exacto 100 -> saldo 0, pagada');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES ('00000000-0000-7000-8000-000000000501', 0.01, 'efectivo', '00000000-0000-7000-8000-000000000005')
$$, '23514', 'PAGO sobre cuenta ya pagada es rechazado');

INSERT INTO pago (id, cuenta_id, monto_pagado, metodo_pago, recibido_por, estado) VALUES
    ('00000000-0000-7000-8000-000000000701', '00000000-0000-7000-8000-000000000501', 500.00, 'efectivo', '00000000-0000-7000-8000-000000000005', 'cancelado');
SELECT pg_temp.espera_error($$
    UPDATE lis.pago SET estado = 'aplicado' WHERE id = '00000000-0000-7000-8000-000000000701'
$$, '23514', 'Reactivar un pago cancelado por encima del saldo es rechazado');

ROLLBACK;
