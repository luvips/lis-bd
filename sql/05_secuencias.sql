-- =============================================================================
-- LIS Laboratorio Clínico — Fase 5: Secuencias y funciones de folio
-- Depende de: Fase 4
--
-- DECISIÓN: secuencia CONTINUA (no reinicia cada año).
--   * nextval() no es transaccional ni bloquea: dos sesiones concurrentes
--     nunca obtienen el mismo número, sin serializar los INSERT.
--   * Reiniciar por año exigiría un job en el cambio de año (carrera a
--     medianoche) o una tabla contador con bloqueo de fila que serializa
--     todas las altas. Ninguno se justifica para un folio.
--   * El año del prefijo es informativo (año de emisión, zona
--     America/Mexico_City); la unicidad la garantiza el número.
--   * Pueden existir huecos (rollback consume el número). Es aceptable: el
--     folio identifica, no cuenta.
--   * Se rellena a 6 dígitos; a partir de 1,000,000 crece sin truncar
--     (VARCHAR(20) admite hasta 11 dígitos).
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

CREATE SEQUENCE seq_folio_solicitud AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE;
CREATE SEQUENCE seq_numero_cuenta   AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE;

CREATE FUNCTION fn_formatear_folio(p_prefijo text, p_numero bigint)
RETURNS varchar
LANGUAGE sql STABLE PARALLEL SAFE
SET search_path = lis, pg_temp
AS $$
    SELECT p_prefijo || '-'
        || to_char(now() AT TIME ZONE 'America/Mexico_City', 'YYYY') || '-'
        || CASE WHEN p_numero < 1000000 THEN lpad(p_numero::text, 6, '0') ELSE p_numero::text END
$$;
COMMENT ON FUNCTION fn_formatear_folio(text, bigint) IS 'Arma folios PREFIJO-YYYY-NNNNNN con el año actual en America/Mexico_City.';

CREATE FUNCTION fn_generar_folio_solicitud()
RETURNS varchar
LANGUAGE sql VOLATILE
SET search_path = lis, pg_temp
AS $$ SELECT fn_formatear_folio('SOL', nextval('lis.seq_folio_solicitud')) $$;
COMMENT ON FUNCTION fn_generar_folio_solicitud() IS 'Folio de solicitud SOL-YYYY-000001 (secuencia continua).';

CREATE FUNCTION fn_generar_numero_cuenta()
RETURNS varchar
LANGUAGE sql VOLATILE
SET search_path = lis, pg_temp
AS $$ SELECT fn_formatear_folio('CTA', nextval('lis.seq_numero_cuenta')) $$;
COMMENT ON FUNCTION fn_generar_numero_cuenta() IS 'Número de cuenta CTA-YYYY-000001 (secuencia continua).';

ALTER SEQUENCE seq_folio_solicitud OWNED BY solicitud.folio;
ALTER SEQUENCE seq_numero_cuenta   OWNED BY cuenta.numero_cuenta;

ALTER TABLE solicitud ALTER COLUMN folio         SET DEFAULT fn_generar_folio_solicitud();
ALTER TABLE cuenta    ALTER COLUMN numero_cuenta SET DEFAULT fn_generar_numero_cuenta();

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- ALTER TABLE cuenta    ALTER COLUMN numero_cuenta DROP DEFAULT;
-- ALTER TABLE solicitud ALTER COLUMN folio         DROP DEFAULT;
-- DROP FUNCTION fn_generar_numero_cuenta(), fn_generar_folio_solicitud(), fn_formatear_folio(text, bigint);
-- DROP SEQUENCE seq_numero_cuenta, seq_folio_solicitud;
