-- =============================================================================
-- Prueba de roles — sql/09_roles.sql
-- Se conecta como lis_admin (superusuario del bootstrap) y usa SET ROLE
-- para operar como cada rol de aplicación: SET ROLE cambia current_user, así
-- que las comprobaciones de privilegio se evalúan exactamente igual que si
-- la app se hubiera conectado con app_<rol> directamente. Un superusuario
-- puede SET ROLE a cualquier rol sin necesitar ser miembro de él.
--
-- Por cada rol: al menos una operación legítima que debe funcionar y al
-- menos una que debe rechazarse con 42501 (insufficient_privilege). El
-- objetivo no es repetir la lógica de negocio (eso ya lo cubre
-- tests/triggers/), sino probar que el LÍMITE de cada rol es el correcto:
-- ni de más (una operación de otro módulo se cuela) ni de menos (una
-- operación legítima del propio rol se rechaza).
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
\set QUIET on
BEGIN;
SET LOCAL search_path = lis, public;
\ir ../triggers/_fixtures.sql

-- Las funciones de aserción viven en pg_temp (creadas por _helpers.sql,
-- dueño lis_admin); deben poder llamarse también después de SET ROLE.
GRANT EXECUTE ON FUNCTION pg_temp.chk(boolean, text) TO PUBLIC;
GRANT EXECUTE ON FUNCTION pg_temp.espera_error(text, text, text) TO PUBLIC;

-- -----------------------------------------------------------------------------
-- lis_recepcion: admisión
-- -----------------------------------------------------------------------------
SET ROLE lis_recepcion;

INSERT INTO paciente (id, nombre, apellido_paterno, fecha_nacimiento, sexo_biologico)
VALUES ('00000000-0000-7000-8000-000000000901', 'Sofía', 'Cárdenas', '1998-04-02', 'F');
INSERT INTO antecedente_paciente (paciente_id, tipo, descripcion)
VALUES ('00000000-0000-7000-8000-000000000901', 'alergia', 'Sulfas');
SELECT pg_temp.chk(TRUE, 'lis_recepcion: registra paciente y antecedente');

UPDATE solicitud SET observaciones = 'Paciente en ayuno' WHERE id = '00000000-0000-7000-8000-000000000101';
SELECT pg_temp.chk((SELECT observaciones FROM solicitud WHERE id = '00000000-0000-7000-8000-000000000101') = 'Paciente en ayuno',
                 'lis_recepcion: actualiza observaciones de una solicitud existente');

-- Abre los estudios que se usan más abajo: crear detalle_solicitud es
-- trabajo de admisión, ni del laboratorio ni del supervisor.
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-000000000902', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000011');
INSERT INTO detalle_solicitud (id, solicitud_id, estudio_id, estado) VALUES
    ('00000000-0000-7000-8000-000000000907', '00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012', 'muestra_tomada');
SELECT pg_temp.chk(TRUE, 'lis_recepcion: abre dos detalle_solicitud (un estudio dentro de la solicitud)');

SELECT pg_temp.espera_error($$
    UPDATE lis.detalle_solicitud SET estado = 'cancelado' WHERE solicitud_id = '00000000-0000-7000-8000-000000000101'
$$, '42501', 'lis_recepcion: no puede cambiar el estado de un detalle_solicitud (es del laboratorio)');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES ('00000000-0000-7000-8000-000000000501', 10, 'efectivo', '00000000-0000-7000-8000-000000000005')
$$, '42501', 'lis_recepcion: no tiene acceso a pago (módulo de caja)');

RESET ROLE;

-- -----------------------------------------------------------------------------
-- lis_laboratorio: flebotomistas y técnicos
-- -----------------------------------------------------------------------------
SET ROLE lis_laboratorio;

SELECT pg_temp.espera_error($$
    INSERT INTO lis.detalle_solicitud (solicitud_id, estudio_id)
    VALUES ('00000000-0000-7000-8000-000000000101', '00000000-0000-7000-8000-000000000012')
$$, '42501', 'lis_laboratorio: no puede abrir un detalle_solicitud (es de admisión)');

UPDATE detalle_solicitud SET estado = 'muestra_tomada' WHERE id = '00000000-0000-7000-8000-000000000902';
SELECT pg_temp.chk(TRUE, 'lis_laboratorio: progresa el estado de un detalle_solicitud');

INSERT INTO muestra (id, codigo_barras, solicitud_id, tipo_muestra, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000903', 'ROL-CB-0001', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003');
INSERT INTO muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) VALUES
    ('00000000-0000-7000-8000-000000000903', '00000000-0000-7000-8000-000000000902');
SELECT pg_temp.chk(TRUE, 'lis_laboratorio: toma el tubo y lo vincula al estudio (trigger 8, invoker)');

UPDATE detalle_solicitud SET estado = 'en_procesamiento' WHERE id = '00000000-0000-7000-8000-000000000902';
INSERT INTO procesamiento (id, muestra_id, detalle_solicitud_id, equipo_id, personal_id) VALUES
    ('00000000-0000-7000-8000-000000000904', '00000000-0000-7000-8000-000000000903', '00000000-0000-7000-8000-000000000902',
     '00000000-0000-7000-8000-000000000006', '00000000-0000-7000-8000-000000000004');
SELECT pg_temp.chk(TRUE, 'lis_laboratorio: registra un procesamiento (trigger 2 sobre equipo, definer)');

INSERT INTO resultado (id, procesamiento_id) VALUES
    ('00000000-0000-7000-8000-000000000905', '00000000-0000-7000-8000-000000000904');
INSERT INTO resultado_valor (id, resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, interpretacion) VALUES
    ('00000000-0000-7000-8000-000000000906', '00000000-0000-7000-8000-000000000905', '00000000-0000-7000-8000-000000000041',
     '00000000-0000-7000-8000-000000000031', 14.0, 'normal');
SELECT pg_temp.chk(TRUE, 'lis_laboratorio: captura un resultado (trigger 9 sobre parametro_estudio/procesamiento, invoker)');

SET LOCAL lis.personal_id = '00000000-0000-7000-8000-000000000004';
SET LOCAL lis.motivo_modificacion = 'Repetición de lectura';
UPDATE resultado_valor SET valor_numerico = 14.2 WHERE id = '00000000-0000-7000-8000-000000000906';
SELECT pg_temp.chk((SELECT count(*) FROM historial_resultado_valor WHERE resultado_valor_id = '00000000-0000-7000-8000-000000000906') = 1,
                 'lis_laboratorio: corrige un valor; el trigger (definer) escribe el historial sin que el rol tenga INSERT ahí');

SELECT pg_temp.espera_error($$
    UPDATE lis.resultado SET es_definitivo = TRUE WHERE id = '00000000-0000-7000-8000-000000000905'
$$, '42501', 'lis_laboratorio: no puede liberar un resultado (es_definitivo es del supervisor)');

SELECT pg_temp.espera_error($$
    UPDATE lis.equipo SET estado_operativo = 'en_mantenimiento' WHERE id = '00000000-0000-7000-8000-000000000006'
$$, '42501', 'lis_laboratorio: no puede cambiar el estado de un equipo (es del supervisor)');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.cuenta (solicitud_id) VALUES ('00000000-0000-7000-8000-000000000101')
$$, '42501', 'lis_laboratorio: no tiene acceso a cuenta (módulo de caja)');

RESET ROLE;

-- -----------------------------------------------------------------------------
-- lis_supervisor: hereda lis_laboratorio + libera resultados, equipos, cancela
-- -----------------------------------------------------------------------------
SET ROLE lis_supervisor;

UPDATE resultado SET es_definitivo = TRUE WHERE id = '00000000-0000-7000-8000-000000000905';
SELECT pg_temp.chk((SELECT es_definitivo FROM resultado WHERE id = '00000000-0000-7000-8000-000000000905'),
                 'lis_supervisor: libera un resultado (es_definitivo)');

UPDATE equipo SET estado_operativo = 'en_mantenimiento' WHERE id = '00000000-0000-7000-8000-000000000007';
INSERT INTO estado_equipo (equipo_id, estado_anterior, estado_nuevo, motivo, registrado_por)
VALUES ('00000000-0000-7000-8000-000000000007', 'operativo', 'en_mantenimiento', 'Mantenimiento preventivo', '00000000-0000-7000-8000-000000000005');
SELECT pg_temp.chk(TRUE, 'lis_supervisor: cambia el estado de un equipo y lo registra en la bitácora');

UPDATE detalle_solicitud SET estado = 'cancelado' WHERE id = '00000000-0000-7000-8000-000000000907';
SELECT pg_temp.chk((SELECT estado FROM detalle_solicitud WHERE id = '00000000-0000-7000-8000-000000000907') = 'cancelado',
                 'lis_supervisor: cancela un detalle_solicitud (trigger 1 sobre solicitud, definer)');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
    VALUES ('00000000-0000-7000-8000-000000000501', 10, 'efectivo', '00000000-0000-7000-8000-000000000005')
$$, '42501', 'lis_supervisor: sigue sin acceso a pago (cancelar no es lo mismo que cobrar)');

RESET ROLE;

-- -----------------------------------------------------------------------------
-- lis_caja: cobranza
-- -----------------------------------------------------------------------------
SET ROLE lis_caja;

INSERT INTO cuenta (id, solicitud_id) VALUES ('00000000-0000-7000-8000-000000000908', '00000000-0000-7000-8000-000000000101');
SELECT pg_temp.chk((SELECT numero_cuenta FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000908') ~ '^CTA-\d{4}-\d{6}$',
                 'lis_caja: crea una cuenta (numero_cuenta via función definer, sin USAGE de secuencia)');

UPDATE cuenta SET descuento_total = 10 WHERE id = '00000000-0000-7000-8000-000000000908';
SELECT pg_temp.chk(TRUE, 'lis_caja: aplica un descuento');

SELECT pg_temp.espera_error($$
    UPDATE lis.cuenta SET saldo_pendiente = 0 WHERE id = '00000000-0000-7000-8000-000000000908'
$$, '42501', 'lis_caja: no puede tocar saldo_pendiente a mano (lo mantiene el trigger)');

INSERT INTO detalle_cuenta (cuenta_id, origen, detalle_solicitud_id, concepto, precio_unitario)
VALUES ('00000000-0000-7000-8000-000000000908', 'estudio_individual', '00000000-0000-7000-8000-000000000902', 'Biometría hemática', 150.00);
SELECT pg_temp.chk((SELECT subtotal FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000908') = 150.00,
                 'lis_caja: agrega una línea; el trigger (definer) recalcula subtotal sin que caja tenga UPDATE directo de esa columna');

INSERT INTO pago (cuenta_id, monto_pagado, metodo_pago, recibido_por)
VALUES ('00000000-0000-7000-8000-000000000908', 100.00, 'efectivo', '00000000-0000-7000-8000-000000000005');
-- total = 150 subtotal - 10 descuento (aplicado arriba) = 140; saldo tras pagar 100 = 40.
SELECT pg_temp.chk((SELECT saldo_pendiente FROM cuenta WHERE id = '00000000-0000-7000-8000-000000000908') = 40.00,
                 'lis_caja: registra un pago; trg_validar_saldo_pago (definer, FOR UPDATE sobre cuenta) y trg_recalcular_cuenta corren sin más privilegios');

SELECT pg_temp.espera_error($$
    UPDATE lis.pago SET monto_pagado = 999 WHERE cuenta_id = '00000000-0000-7000-8000-000000000908'
$$, '42501', 'lis_caja: no puede editar el monto de un pago ya capturado');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.muestra (codigo_barras, solicitud_id, tipo_muestra, personal_id)
    VALUES ('ROL-CB-0002', '00000000-0000-7000-8000-000000000101', 'sangre_venosa', '00000000-0000-7000-8000-000000000003')
$$, '42501', 'lis_caja: no tiene acceso a muestra (módulo clínico)');

RESET ROLE;

-- -----------------------------------------------------------------------------
-- lis_reporting: solo lectura de todo
-- -----------------------------------------------------------------------------
SET ROLE lis_reporting;

SELECT pg_temp.chk(
    (SELECT count(*) FROM paciente) >= 0
    AND (SELECT count(*) FROM resultado_valor) >= 0
    AND (SELECT count(*) FROM cuenta) >= 0
    AND (SELECT count(*) FROM pago) >= 0,
    'lis_reporting: lee las cuatro tablas de todos los módulos');

SELECT pg_temp.espera_error($$
    INSERT INTO lis.paciente (nombre, apellido_paterno, fecha_nacimiento, sexo_biologico)
    VALUES ('Prueba', 'Reporting', '2000-01-01', 'M')
$$, '42501', 'lis_reporting: no puede escribir en ninguna tabla');

RESET ROLE;

ROLLBACK;
