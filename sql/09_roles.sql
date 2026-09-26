-- =============================================================================
-- LIS Laboratorio Clínico — Fase 10: Roles de aplicación (mínimo privilegio)
-- Depende de: Fase 7 (todas las tablas, funciones y triggers ya existen)
-- NO se consolida en schema.sql (igual que 08_validacion.sql): es una fase
-- de seguridad que se aplica aparte, después del esquema.
--
-- MODELO DE ROLES (regla 29: mínimo privilegio, roles de aplicación sin
-- SUPERUSER/CREATEDB, permisos por GRANT explícito):
--
--   lis_admin (POSTGRES_USER)  -- dueño de todos los objetos. Superusuario
--       por el propio bootstrap de la imagen oficial de postgres. Solo se
--       usa para desplegar el esquema (Fase 0-9) y para migraciones futuras.
--       LA APLICACIÓN NUNCA SE CONECTA CON ESTE USUARIO.
--
--   Roles de grupo (NOLOGIN, son los que reciben los GRANT):
--     lis_recepcion   -- admisión: registra pacientes/médicos, abre solicitudes
--     lis_laboratorio -- flebotomistas y técnicos: toma de muestra, procesa,
--                        captura resultados
--     lis_supervisor  -- hereda lis_laboratorio + libera resultados, cambia
--                        estado de equipos, autoriza cancelaciones
--     lis_caja        -- cobranza: cuentas, líneas de cobro, pagos
--     lis_reporting   -- solo lectura de todo el schema (BI/auditoría)
--
--   Roles de conexión (LOGIN, uno por servicio de la app; password desde
--   variables de entorno vía \getenv, nunca hardcodeada — regla 30):
--     app_recepcion, app_laboratorio, app_supervisor, app_caja, app_reporting
--
-- DECISIÓN CLAVE: los triggers de negocio que escriben en OTRA tabla distinta
-- de la que dispara el evento (recalcular solicitud.estado_global, cuenta,
-- anular detalle_cuenta, descartar muestra, versionar en el historial) se
-- vuelven SECURITY DEFINER (dueño: lis_admin) en este archivo. Así, un rol
-- de aplicación solo necesita privilegios sobre la tabla que él mismo
-- modifica directamente; el efecto en cascada lo ejecuta el trigger con los
-- privilegios de su dueño, no con los del rol que disparó el evento. Sin
-- esto, por ejemplo, lis_laboratorio necesitaría UPDATE directo sobre
-- solicitud.estado_global (una columna que nunca debería tocar a mano) solo
-- para que el trigger de detalle_solicitud pudiera actualizarla.
-- Las funciones ya declaran SET search_path = lis, pg_temp (Fase 7), el
-- requisito de seguridad para que un SECURITY DEFINER no sea inyectable via
-- search_path.
--
-- No hay DELETE en ningún GRANT de este archivo: ningún rol de aplicación
-- borra filas físicamente (los catálogos usan activo=FALSE; lo clínico y lo
-- comercial son append/actualiza-en-sitio con historial). Solo lis_admin,
-- como dueño, podría hacerlo, y no se espera que lo haga en operación normal.
--
-- Los GRANT de columna (UPDATE (col1, col2)) se usan donde una tabla mezcla
-- columnas que el rol sí captura a mano con columnas que mantiene un
-- trigger o un DEFAULT (ver comentario en cada bloque). INSERT se deja a
-- nivel de tabla (no por columna): la app arma la fila completa al crearla;
-- la restricción importa al UPDATE, cuando una columna calculada no debe
-- sobrescribirse después.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- -----------------------------------------------------------------------------
-- 0. Higiene de PUBLIC (regla 29): en Postgres un schema nuevo no otorga
--    nada a PUBLIC por defecto (a diferencia del schema "public"), así que
--    esto es defensivo/explícito, no corrige un hueco real hoy.
-- -----------------------------------------------------------------------------
REVOKE ALL ON SCHEMA lis FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA lis FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA lis FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA lis FROM PUBLIC;

-- -----------------------------------------------------------------------------
-- 1. SECURITY DEFINER en triggers/funciones que escriben en otra tabla o en
--    una bitácora append-only. Dueño: lis_admin (quien ejecuta esta fase).
--    fn_validar_saldo_pago y fn_bloquear_equipo_no_operativo también quedan
--    definer: hacen SELECT ... FOR UPDATE/FOR SHARE, y ese bloqueo de fila
--    exige privilegios sobre la tabla bloqueada que un rol ajeno a esa tabla
--    (ej. lis_caja sobre equipo) no tendría por qué tener.
--    El resto de las funciones de Fase 7 (validaciones de FK/formato que
--    solo leen tablas que el propio rol ya puede leer) se quedan como
--    invoker: no hay razón para elevarlas.
-- -----------------------------------------------------------------------------
ALTER FUNCTION fn_estado_global_solicitud()               SECURITY DEFINER;
ALTER FUNCTION fn_bloquear_equipo_no_operativo()           SECURITY DEFINER;
ALTER FUNCTION fn_historial_resultado()                    SECURITY DEFINER;
ALTER FUNCTION fn_recalcular_totales_cuenta(uuid)          SECURITY DEFINER;
ALTER FUNCTION fn_recalcular_cuenta()                      SECURITY DEFINER;
ALTER FUNCTION fn_validar_saldo_pago()                     SECURITY DEFINER;
ALTER FUNCTION fn_cancelar_detalle_cuenta()                SECURITY DEFINER;
ALTER FUNCTION fn_descartar_muestra_cancelada()            SECURITY DEFINER;

-- Folios/números de cuenta: sus DEFAULT llaman a estas funciones, que hacen
-- nextval() sobre secuencias propiedad de lis_admin. Definer evita tener que
-- otorgar USAGE de las secuencias a cada rol que hace INSERT en solicitud o
-- cuenta.
ALTER FUNCTION fn_formatear_folio(text, bigint)            SECURITY DEFINER;
ALTER FUNCTION fn_generar_folio_solicitud()                SECURITY DEFINER;
ALTER FUNCTION fn_generar_numero_cuenta()                  SECURITY DEFINER;

-- -----------------------------------------------------------------------------
-- 2. Roles de grupo (NOLOGIN)
-- -----------------------------------------------------------------------------
CREATE ROLE lis_recepcion    NOLOGIN;
CREATE ROLE lis_laboratorio  NOLOGIN;
CREATE ROLE lis_supervisor   NOLOGIN;
CREATE ROLE lis_caja         NOLOGIN;
CREATE ROLE lis_reporting    NOLOGIN;

COMMENT ON ROLE lis_recepcion   IS 'Admisión: alta de pacientes/médicos, apertura de solicitudes. Sin acceso a lo clínico ni a cobranza.';
COMMENT ON ROLE lis_laboratorio IS 'Flebotomistas y técnicos: toma de muestra, procesamiento, captura de resultados. Sin acceso a cobranza.';
COMMENT ON ROLE lis_supervisor  IS 'Hereda lis_laboratorio. Además: libera resultados (es_definitivo), cambia estado de equipos, autoriza cancelaciones de estudios.';
COMMENT ON ROLE lis_caja        IS 'Cobranza: cuentas, líneas de cobro, pagos. Sin acceso a lo clínico.';
COMMENT ON ROLE lis_reporting   IS 'Solo lectura de todo el schema lis. Para BI/reportes/auditoría; nunca escribe.';

-- Jerarquía: un login en lis_supervisor hereda automáticamente todo lo que
-- puede hacer lis_laboratorio, sin duplicar GRANT.
GRANT lis_laboratorio TO lis_supervisor;

-- Todo rol necesita conectarse a la base y usar el schema antes de que
-- cualquier GRANT sobre una tabla sirva de algo.
GRANT CONNECT ON DATABASE lis_laboratorio TO lis_recepcion, lis_laboratorio, lis_supervisor, lis_caja, lis_reporting;
GRANT USAGE ON SCHEMA lis TO lis_recepcion, lis_laboratorio, lis_supervisor, lis_caja, lis_reporting;

-- gen_uuid_v7() es el DEFAULT de la PK de las 24 tablas: el REVOKE ALL de la
-- sección 0 también le quita EXECUTE a PUBLIC, y sin este GRANT cualquier
-- INSERT que no liste "id" explícitamente falla (la app normal nunca lo
-- lista). Se otorga a todo rol que inserta; lis_reporting no lo necesita.
GRANT EXECUTE ON FUNCTION gen_uuid_v7() TO lis_recepcion, lis_laboratorio, lis_supervisor, lis_caja;

-- -----------------------------------------------------------------------------
-- 3. lis_recepcion — admisión
-- -----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON paciente, antecedente_paciente, medico TO lis_recepcion;
-- Catálogo: solo lectura (precios, estudios, paquetes, personal para listas).
GRANT SELECT ON estudio, estudio_tipo_muestra, parametro_estudio, paquete,
                 paquete_estudio, valor_referencia, estudio_equipo, equipo, personal
    TO lis_recepcion;
GRANT SELECT, INSERT ON solicitud, detalle_solicitud TO lis_recepcion;
-- solicitud.folio se genera con el DEFAULT fn_generar_folio_solicitud():
-- aunque la función es SECURITY DEFINER (usa la secuencia como lis_admin),
-- quien ejecuta el INSERT sigue necesitando EXECUTE sobre la función misma.
GRANT EXECUTE ON FUNCTION fn_generar_folio_solicitud() TO lis_recepcion;
-- estado_global lo mantiene el trigger (definer); recepción solo toca estas
-- dos columnas de una solicitud ya creada.
GRANT UPDATE (observaciones, prioridad) ON solicitud TO lis_recepcion;
-- Informativo (para decirle al paciente su saldo); nada de cobranza directa.
GRANT SELECT ON cuenta TO lis_recepcion;

-- -----------------------------------------------------------------------------
-- 4. lis_laboratorio — flebotomistas y técnicos
-- -----------------------------------------------------------------------------
GRANT SELECT ON paciente, antecedente_paciente, medico, solicitud TO lis_laboratorio;
GRANT SELECT ON estudio, estudio_tipo_muestra, parametro_estudio, paquete,
                 paquete_estudio, valor_referencia, estudio_equipo, equipo, personal
    TO lis_laboratorio;
-- Progresa el estado del estudio y registra repeticiones; NUNCA crea
-- detalle_solicitud (eso es admisión) ni cancela (eso es el supervisor).
GRANT SELECT ON detalle_solicitud TO lis_laboratorio;
GRANT UPDATE (estado, motivo_repeticion, numero_repeticion) ON detalle_solicitud TO lis_laboratorio;
-- Tubo físico: lo crea, lo vincula a los estudios, actualiza su condición.
GRANT SELECT, INSERT ON muestra, muestra_detalle_solicitud TO lis_laboratorio;
GRANT UPDATE (estado, condicion, temperatura_conservacion, observaciones) ON muestra TO lis_laboratorio;
-- Corridas de equipo y resultados.
GRANT SELECT, INSERT ON procesamiento, resultado, resultado_valor TO lis_laboratorio;
GRANT UPDATE (equipo_id, personal_id, muestra_id, detalle_solicitud_id, fecha_fin, estado, es_reprocesamiento, observaciones)
    ON procesamiento TO lis_laboratorio;
-- es_definitivo (liberar el resultado) es del supervisor, no del técnico.
GRANT UPDATE (observaciones, procesamiento_id) ON resultado TO lis_laboratorio;
GRANT UPDATE (resultado_id, parametro_estudio_id, valor_referencia_id, valor_numerico, valor_texto, interpretacion)
    ON resultado_valor TO lis_laboratorio;
-- Bitácoras: solo lectura. El trigger (definer) es quien escribe en ellas.
GRANT SELECT ON historial_resultado_valor, estado_equipo TO lis_laboratorio;

-- -----------------------------------------------------------------------------
-- 5. lis_supervisor — además de lo anterior (heredado de lis_laboratorio)
-- -----------------------------------------------------------------------------
-- Libera resultados para entrega.
GRANT UPDATE (es_definitivo) ON resultado TO lis_supervisor;
-- Cambia el estado operativo de un equipo y registra el motivo (ya lo dice
-- el COMMENT de equipo.estado_operativo: "Solo ADMINISTRADOR puede
-- cambiarlo"). No hay trigger todavía que sincronice esto automáticamente
-- (ver README, Pendiente): por eso el rol necesita escribir las dos tablas.
GRANT UPDATE (estado_operativo, fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento) ON equipo TO lis_supervisor;
GRANT INSERT ON estado_equipo TO lis_supervisor;
-- Autoriza cancelar un estudio (cruza lo clínico y lo comercial: dispara
-- trg_cancelar_detalle_cuenta y trg_descartar_muestra_cancelada, ambos
-- definer, así que no hace falta darle a supervisor acceso directo a
-- detalle_cuenta ni volver a otorgar UPDATE de muestra más allá del que ya
-- heredó de lis_laboratorio).
GRANT UPDATE (estado) ON detalle_solicitud TO lis_supervisor;

-- -----------------------------------------------------------------------------
-- 6. lis_caja — cobranza
-- -----------------------------------------------------------------------------
GRANT SELECT ON paciente, medico, personal TO lis_caja;
GRANT SELECT ON estudio, paquete, paquete_estudio TO lis_caja;
GRANT SELECT ON solicitud, detalle_solicitud TO lis_caja;
GRANT SELECT, INSERT ON cuenta TO lis_caja;
-- Mismo caso que fn_generar_folio_solicitud() arriba: SECURITY DEFINER no
-- exime al llamador de tener EXECUTE sobre la función.
GRANT EXECUTE ON FUNCTION fn_generar_numero_cuenta() TO lis_caja;
-- subtotal/total/saldo_pendiente/estado_pago/numero_cuenta los mantienen el
-- trigger y el DEFAULT (ambos definer); descuento_total es la única
-- columna que caja captura a mano.
GRANT UPDATE (descuento_total) ON cuenta TO lis_caja;
GRANT SELECT, INSERT ON detalle_cuenta TO lis_caja;
-- anulado normalmente lo pone trg_cancelar_detalle_cuenta (definer), pero
-- caja también puede anular una línea a mano (error de captura).
GRANT UPDATE (anulado) ON detalle_cuenta TO lis_caja;
GRANT SELECT, INSERT ON pago TO lis_caja;
-- Un pago no se "edita" (monto/método/cuenta): se cancela (estado) y se
-- vuelve a capturar. Coherente con que pago no tiene UPDATE de monto_pagado
-- en ningún flujo de negocio documentado.
GRANT UPDATE (estado, observaciones) ON pago TO lis_caja;

-- -----------------------------------------------------------------------------
-- 7. lis_reporting — solo lectura de todo
-- -----------------------------------------------------------------------------
GRANT SELECT ON ALL TABLES IN SCHEMA lis TO lis_reporting;
-- Si en el futuro lis_admin agrega una tabla nueva, que sea legible por
-- reporting sin acordarse de otorgarlo a mano; para los roles que ESCRIBEN
-- no se hace lo mismo a propósito (regla 29: cada permiso de escritura se
-- otorga a mano, tabla por tabla, nunca por default).
ALTER DEFAULT PRIVILEGES FOR ROLE lis_admin IN SCHEMA lis GRANT SELECT ON TABLES TO lis_reporting;

-- -----------------------------------------------------------------------------
-- 8. Roles de conexión (LOGIN). Password desde el entorno del contenedor
--    (regla 30): docker-compose.yml exige APP_*_PASSWORD con ${VAR:?...},
--    así que si esta fase corre es porque ya existen.
-- -----------------------------------------------------------------------------
\getenv app_recepcion_password APP_RECEPCION_PASSWORD
\getenv app_laboratorio_password APP_LABORATORIO_PASSWORD
\getenv app_supervisor_password APP_SUPERVISOR_PASSWORD
\getenv app_caja_password APP_CAJA_PASSWORD
\getenv app_reporting_password APP_REPORTING_PASSWORD

CREATE ROLE app_recepcion    LOGIN PASSWORD :'app_recepcion_password'    IN ROLE lis_recepcion;
CREATE ROLE app_laboratorio  LOGIN PASSWORD :'app_laboratorio_password'  IN ROLE lis_laboratorio;
CREATE ROLE app_supervisor   LOGIN PASSWORD :'app_supervisor_password'   IN ROLE lis_supervisor;
CREATE ROLE app_caja         LOGIN PASSWORD :'app_caja_password'         IN ROLE lis_caja;
CREATE ROLE app_reporting    LOGIN PASSWORD :'app_reporting_password'    IN ROLE lis_reporting;

COMMENT ON ROLE app_recepcion   IS 'Cuenta de conexión del módulo de admisión. Miembro de lis_recepcion; sin privilegios propios.';
COMMENT ON ROLE app_laboratorio IS 'Cuenta de conexión del módulo de laboratorio. Miembro de lis_laboratorio; sin privilegios propios.';
COMMENT ON ROLE app_supervisor  IS 'Cuenta de conexión de supervisión. Miembro de lis_supervisor; sin privilegios propios.';
COMMENT ON ROLE app_caja        IS 'Cuenta de conexión del módulo de caja. Miembro de lis_caja; sin privilegios propios.';
COMMENT ON ROLE app_reporting   IS 'Cuenta de conexión de reportes/BI. Miembro de lis_reporting; sin privilegios propios.';

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP OWNED BY app_recepcion, app_laboratorio, app_supervisor, app_caja, app_reporting;
-- DROP ROLE app_recepcion, app_laboratorio, app_supervisor, app_caja, app_reporting;
-- ALTER DEFAULT PRIVILEGES FOR ROLE lis_admin IN SCHEMA lis REVOKE SELECT ON TABLES FROM lis_reporting;
-- DROP OWNED BY lis_recepcion, lis_laboratorio, lis_supervisor, lis_caja, lis_reporting;
-- DROP ROLE lis_recepcion, lis_laboratorio, lis_supervisor, lis_caja, lis_reporting;
-- ALTER FUNCTION fn_generar_numero_cuenta() SECURITY INVOKER;
-- ALTER FUNCTION fn_generar_folio_solicitud() SECURITY INVOKER;
-- ALTER FUNCTION fn_formatear_folio(text, bigint) SECURITY INVOKER;
-- ALTER FUNCTION fn_descartar_muestra_cancelada() SECURITY INVOKER;
-- ALTER FUNCTION fn_cancelar_detalle_cuenta() SECURITY INVOKER;
-- ALTER FUNCTION fn_validar_saldo_pago() SECURITY INVOKER;
-- ALTER FUNCTION fn_recalcular_cuenta() SECURITY INVOKER;
-- ALTER FUNCTION fn_recalcular_totales_cuenta(uuid) SECURITY INVOKER;
-- ALTER FUNCTION fn_historial_resultado() SECURITY INVOKER;
-- ALTER FUNCTION fn_bloquear_equipo_no_operativo() SECURITY INVOKER;
-- ALTER FUNCTION fn_estado_global_solicitud() SECURITY INVOKER;
