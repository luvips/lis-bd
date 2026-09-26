-- =============================================================================
-- LIS Laboratorio Clínico — Fase 0: Preparación del entorno
-- Ejecutar con:  psql -U postgres -f sql/00_setup.sql
-- -----------------------------------------------------------------------------
-- DECISIÓN PREVIA (UUID v7)
--   Versión verificada en el entorno de desarrollo: PostgreSQL 18.1
--   (SELECT version();). PG >= 18 trae uuidv7() nativo y monotónico por
--   sesión, por lo que gen_uuid_v7() es un envoltorio delgado sobre él.
--   Si el servidor fuera < 18, el bloque DO crea una implementación
--   PL/pgSQL (RFC 9562: 48 bits de epoch en ms + 12 bits de fracción
--   sub-milisegundo + 62 bits aleatorios), sin extensiones externas.
--   Todo el DDL usa gen_uuid_v7() y no uuidv7() directamente, para que el
--   esquema sea portable entre ambas versiones.
--
-- DECISIÓN DE SCHEMA
--   Se usa un schema dedicado "lis" en lugar de "public": permite otorgar
--   privilegios por schema (regla 29) y aísla los objetos del LIS de
--   extensiones u objetos ajenos. El search_path de la base se fija a
--   "lis, public".
--
-- DECISIÓN DE PK (desviación consciente de la regla 2)
--   La regla general prefiere BIGINT IDENTITY; el diccionario de datos
--   exige UUID v7 en las 19 tablas (IDs no predecibles expuestos al
--   paciente/médico y sin secuencia centralizada). Aplica la excepción que
--   la propia regla 2 contempla ("exposición pública del ID").
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8

-- @@BOOTSTRAP_BEGIN  (se omite en schema.sql, que corre sobre una base ya creada)
SELECT 'CREATE DATABASE lis_laboratorio ENCODING ''UTF8'' TEMPLATE template0'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'lis_laboratorio')
\gexec
\connect lis_laboratorio
\encoding UTF8
-- @@BOOTSTRAP_END

BEGIN;

CREATE SCHEMA lis;
COMMENT ON SCHEMA lis IS 'Objetos del LIS (Laboratory Information System) del laboratorio clínico.';

-- btree_gist: permite combinar "=" sobre escalares con "&&" sobre rangos en
-- una restricción EXCLUDE (anti-traslape de valor_referencia, Fase 2).
-- Se instala en public para no mezclar sus tipos con los del LIS.
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;

DO $$
BEGIN
    EXECUTE format('ALTER DATABASE %I SET search_path = lis, public', current_database());
END
$$;
SET search_path = lis, public;

DO $$
BEGIN
    IF current_setting('server_version_num')::int >= 180000 THEN
        EXECUTE $fn$
            CREATE FUNCTION lis.gen_uuid_v7() RETURNS uuid
            LANGUAGE sql VOLATILE PARALLEL SAFE
            AS 'SELECT uuidv7()'
        $fn$;
    ELSE
        EXECUTE $fn$
            CREATE FUNCTION lis.gen_uuid_v7() RETURNS uuid
            LANGUAGE plpgsql VOLATILE PARALLEL SAFE
            AS $body$
            DECLARE
                v_ts     timestamptz := clock_timestamp();
                v_ms     bigint      := floor(extract(epoch FROM v_ts) * 1000);
                v_sub_ms int         := ((extract(microseconds FROM v_ts)::bigint % 1000) * 4096 / 1000)::int;
                v_bytes  bytea       := uuid_send(gen_random_uuid());
            BEGIN
                v_bytes := overlay(v_bytes PLACING substring(int8send(v_ms) FROM 3) FROM 1 FOR 6);
                v_bytes := set_byte(v_bytes, 6, 112 | (v_sub_ms >> 8));   -- versión 7 + 4 bits altos
                v_bytes := set_byte(v_bytes, 7, v_sub_ms & 255);          -- 8 bits bajos
                RETURN encode(v_bytes, 'hex')::uuid;                      -- variante RFC ya viene de gen_random_uuid()
            END
            $body$
        $fn$;
    END IF;
END
$$;

COMMENT ON FUNCTION lis.gen_uuid_v7() IS
    'Genera UUID v7 ordenable temporalmente. PG>=18: envoltorio de uuidv7(); PG<18: implementación PL/pgSQL propia.';

COMMIT;

-- Criterio de aceptación (Fase 0):
--   SELECT a < b AS ordenado FROM (SELECT gen_uuid_v7() a) x, LATERAL (SELECT gen_uuid_v7() b) y;

-- DOWN ------------------------------------------------------------------------
-- DROP SCHEMA lis CASCADE;
-- DROP EXTENSION IF EXISTS btree_gist;
-- DROP DATABASE lis_laboratorio;   -- desde otra base
