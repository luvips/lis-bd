-- =============================================================================
-- LIS Laboratorio Clínico — schema.sql (Fase 9, GENERADO: no editar a mano)
-- Consolidado de 00_setup.sql a 07_triggers.sql. Regenerar con sql/build_schema.sh
-- Ejecutar contra una base vacía:
--   createdb lis_laboratorio && psql -d lis_laboratorio -f sql/schema.sql
-- =============================================================================

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 00_setup.sql
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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 01_enums.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 1: Tipos ENUM
-- Depende de: Fase 0
-- 19 tipos: los 14 del diccionario (sección 2) más 5 que sustituyen
-- columnas VARCHAR + CHECK (tipo_sanguineo, prioridad_solicitud,
-- condicion_muestra, temperatura_conservacion) y el tipo de la nueva tabla
-- antecedente_paciente. Toda lista cerrada de valores es ENUM: una sola
-- convención en el esquema. "estado_registro" NO se crea: el diccionario lo
-- documenta como criterio pero se implementa como la columna activo BOOLEAN
-- en los catálogos.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

CREATE TYPE sexo_biologico AS ENUM ('M', 'F', 'Intersex');
CREATE TYPE categoria_estudio AS ENUM ('Hematologia', 'Quimica_Clinica', 'Microbiologia', 'Inmunologia', 'Endocrinologia', 'Uroanalisis');
CREATE TYPE tipo_muestra AS ENUM ('sangre_venosa', 'sangre_capilar', 'orina', 'heces', 'esputo', 'tejido', 'otro');
CREATE TYPE rol_personal AS ENUM ('flebotomista', 'tecnico_laboratorio', 'supervisor');
CREATE TYPE estado_operativo_equipo AS ENUM ('operativo', 'en_mantenimiento', 'fuera_de_servicio', 'dado_de_baja');
CREATE TYPE estado_solicitud AS ENUM ('recibida', 'en_toma_de_muestra', 'en_procesamiento', 'parcialmente_completada', 'completada', 'entregada', 'cancelada');
CREATE TYPE estado_detalle_solicitud AS ENUM ('pendiente_muestra', 'muestra_tomada', 'en_procesamiento', 'completado', 'requiere_repeticion', 'repetido_completado', 'cancelado');
CREATE TYPE estado_muestra AS ENUM ('tomada', 'en_analisis', 'analizada', 'descartada');
CREATE TYPE interpretacion_resultado AS ENUM ('normal', 'bajo', 'alto', 'critico', 'anormal');
CREATE TYPE estado_procesamiento AS ENUM ('en_proceso', 'completado', 'fallido', 'cancelado');
CREATE TYPE origen_detalle_cuenta AS ENUM ('estudio_individual', 'paquete');
CREATE TYPE estado_cuenta AS ENUM ('pendiente', 'parcialmente_pagada', 'pagada', 'cancelada');
CREATE TYPE tipo_pago AS ENUM ('efectivo', 'tarjeta_debito', 'tarjeta_credito', 'transferencia');
CREATE TYPE estado_pago_registro AS ENUM ('aplicado', 'devuelto', 'cancelado');
CREATE TYPE tipo_sanguineo AS ENUM ('O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-');
CREATE TYPE tipo_antecedente AS ENUM ('alergia', 'enfermedad_cronica', 'cirugia', 'medicamento', 'heredofamiliar', 'otro');
CREATE TYPE prioridad_solicitud AS ENUM ('normal', 'urgente');
CREATE TYPE condicion_muestra AS ENUM ('adecuada', 'hemolizada', 'lipemica', 'contaminada', 'insuficiente');
CREATE TYPE temperatura_conservacion AS ENUM ('ambiente', 'refrigerada', 'congelada');

COMMENT ON TYPE sexo_biologico           IS 'Sexo biológico del paciente; determina rangos de referencia (PACIENTE, VALOR_REFERENCIA).';
COMMENT ON TYPE categoria_estudio        IS 'Área del laboratorio a la que pertenece un estudio (ESTUDIO).';
COMMENT ON TYPE tipo_muestra             IS 'Tipo de muestra biológica aceptada (ESTUDIO_TIPO_MUESTRA) o tomada (MUESTRA).';
COMMENT ON TYPE rol_personal             IS 'Rol operativo del personal del laboratorio (PERSONAL).';
COMMENT ON TYPE estado_operativo_equipo  IS 'Disponibilidad de un equipo; solo "operativo" admite procesamiento (EQUIPO).';
COMMENT ON TYPE estado_solicitud         IS 'Estado global de una solicitud, calculado por trigger a partir de sus detalles; cancelada = todos sus detalles cancelados (SOLICITUD).';
COMMENT ON TYPE estado_detalle_solicitud IS 'Ciclo de vida granular de cada estudio solicitado (DETALLE_SOLICITUD).';
COMMENT ON TYPE estado_muestra           IS 'Ciclo de vida de una muestra física (MUESTRA).';
COMMENT ON TYPE interpretacion_resultado IS 'Interpretación de un analito frente a su valor de referencia (RESULTADO_VALOR).';
COMMENT ON TYPE estado_procesamiento     IS 'Estado de una corrida de procesamiento en equipo (PROCESAMIENTO).';
COMMENT ON TYPE origen_detalle_cuenta    IS 'Discriminador de línea de cuenta: estudio vendido suelto o paquete (DETALLE_CUENTA).';
COMMENT ON TYPE estado_cuenta            IS 'Estado de cobro de una cuenta (CUENTA).';
COMMENT ON TYPE tipo_pago                IS 'Método de pago (PAGO).';
COMMENT ON TYPE estado_pago_registro     IS 'Estado de un registro de pago; solo "aplicado" descuenta saldo (PAGO).';
COMMENT ON TYPE tipo_sanguineo           IS 'Grupo ABO y factor Rh (PACIENTE).';
COMMENT ON TYPE tipo_antecedente         IS 'Clasificación de un antecedente clínico (ANTECEDENTE_PACIENTE).';
COMMENT ON TYPE prioridad_solicitud      IS 'Prioridad de atención de una solicitud (SOLICITUD).';
COMMENT ON TYPE condicion_muestra        IS 'Calidad de la muestra al recibirla; distinta de adecuada suele implicar repetición (MUESTRA).';
COMMENT ON TYPE temperatura_conservacion IS 'Cadena de frío en la que se conserva la muestra (MUESTRA).';

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TYPE temperatura_conservacion, condicion_muestra, prioridad_solicitud,
--           tipo_antecedente, tipo_sanguineo,
--           estado_pago_registro, tipo_pago, estado_cuenta, origen_detalle_cuenta,
--           estado_procesamiento, interpretacion_resultado, estado_muestra,
--           estado_detalle_solicitud, estado_solicitud, estado_operativo_equipo,
--           rol_personal, tipo_muestra, categoria_estudio, sexo_biologico;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 02_catalogo.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 2: Tablas de catálogo
-- Depende de: Fase 1
-- Orden por dependencia de FK: paciente, antecedente_paciente, medico,
-- personal, equipo, estudio, estudio_tipo_muestra, parametro_estudio,
-- paquete, valor_referencia, estudio_equipo, paquete_estudio.
--
-- Convenciones aplicadas:
--   * Nombres de tabla en singular tal como el diccionario (desviación
--     documentada de la regla 1 "plural"): el diccionario es la fuente de
--     verdad del dominio y las FK ya siguen el patrón <tabla>_id.
--   * Cadenas (regla 3): VARCHAR(n) cuando n sale de un estándar o regla
--     de negocio, documentado en COMMENT ON COLUMN; TEXT para texto libre.
--     En PostgreSQL ambos ocupan solo lo escrito: n es una validación.
--       - correo      VARCHAR(254): máximo de una dirección (RFC 5321).
--       - telefono    VARCHAR(20):  E.164 = 15 dígitos + "+" y separadores.
--       - nombre y apellidos VARCHAR(100): sin estándar oficial; tope
--         amplio que admite nombres compuestos y solo frena basura.
--       - curp        CHAR(18) + CHECK de formato RENAPO.
--   * Toda columna que admite NULL lleva un COMMENT que explica por qué
--     (regla 4).
--   * Toda FK: ON DELETE RESTRICT ON UPDATE RESTRICT (catálogos nunca se
--     borran físicamente; se usa activo = FALSE).
--   * activo BOOLEAN en las tablas catálogo (regla del plan y de la sección
--     1 del diccionario), incluidas valor_referencia, parametro_estudio y
--     antecedente_paciente. Excepciones:
--       - equipo: su estado_operativo ya tiene el valor terminal
--         'dado_de_baja'; un activo adicional permitiría combinaciones
--         contradictorias. "Equipo activo" = estado_operativo <> 'dado_de_baja'.
--       - estudio_equipo, estudio_tipo_muestra y paquete_estudio: son
--         relaciones N:M sin historial clínico que dependa de ellas; un
--         vínculo que deja de aplicar se elimina con DELETE.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- 1. PACIENTE -----------------------------------------------------------------
CREATE TABLE paciente (
    id                UUID            NOT NULL DEFAULT gen_uuid_v7(),
    curp              CHAR(18),
    nombre            VARCHAR(100)    NOT NULL,
    apellido_paterno  VARCHAR(100)    NOT NULL,
    apellido_materno  VARCHAR(100),
    fecha_nacimiento  DATE            NOT NULL,
    sexo_biologico    sexo_biologico  NOT NULL,
    tipo_sanguineo    tipo_sanguineo,
    telefono          VARCHAR(20),
    correo            VARCHAR(254),
    activo            BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en         TIMESTAMPTZ     NOT NULL DEFAULT now(),
    actualizado_en    TIMESTAMPTZ     NOT NULL DEFAULT now(),
    CONSTRAINT pk_paciente PRIMARY KEY (id),
    CONSTRAINT uq_paciente_curp UNIQUE (curp),
    CONSTRAINT ck_paciente_curp CHECK (curp ~ '^[A-Z]{4}[0-9]{6}[HMX][A-Z]{5}[A-Z0-9][0-9]$'),
    CONSTRAINT ck_paciente_correo CHECK (correo ~ '^[^@\s]+@[^@\s]+$')
);
COMMENT ON TABLE  paciente IS 'Paciente del laboratorio. Nunca se elimina físicamente (activo = FALSE).';
COMMENT ON COLUMN paciente.curp IS 'CHAR(18): longitud fija RENAPO. Nullable (extranjeros/recién nacidos sin CURP); UNIQUE admite múltiples NULL.';
COMMENT ON COLUMN paciente.nombre IS 'VARCHAR(100): sin estándar oficial; tope amplio para nombres compuestos.';
COMMENT ON COLUMN paciente.apellido_materno IS 'Nullable: hay personas con un solo apellido.';
COMMENT ON COLUMN paciente.fecha_nacimiento IS 'Base para seleccionar rangos de referencia por edad.';
COMMENT ON COLUMN paciente.sexo_biologico IS 'Base para seleccionar rangos de referencia por sexo.';
COMMENT ON COLUMN paciente.tipo_sanguineo IS 'Nullable: se desconoce hasta que se tipifica.';
COMMENT ON COLUMN paciente.telefono IS 'VARCHAR(20): E.164 (15 dígitos) + "+" y separadores. Nullable: dato de contacto opcional.';
COMMENT ON COLUMN paciente.correo IS 'VARCHAR(254): máximo de una dirección según RFC 5321. Nullable: dato de contacto opcional.';

-- 2. ANTECEDENTE_PACIENTE (débil, 1:N de paciente) ---------------------------
CREATE TABLE antecedente_paciente (
    id                 UUID              NOT NULL DEFAULT gen_uuid_v7(),
    paciente_id        UUID              NOT NULL,
    tipo               tipo_antecedente  NOT NULL,
    descripcion        TEXT              NOT NULL,
    fecha_diagnostico  DATE,
    activo             BOOLEAN           NOT NULL DEFAULT TRUE,
    creado_en          TIMESTAMPTZ       NOT NULL DEFAULT now(),
    CONSTRAINT pk_antecedente_paciente PRIMARY KEY (id),
    CONSTRAINT fk_antecedente_paciente_paciente FOREIGN KEY (paciente_id)
        REFERENCES paciente (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_antecedente_paciente_descripcion CHECK (btrim(descripcion) <> '')
);
COMMENT ON TABLE  antecedente_paciente IS 'Antecedentes clínicos del paciente (alergias, crónicos, cirugías...). Sustituye la columna paciente.antecedentes JSONB: se consulta por tipo sin GIN y se valida con ENUM.';
COMMENT ON COLUMN antecedente_paciente.descripcion IS 'Texto libre, ej. "Penicilina", "Diabetes tipo 2".';
COMMENT ON COLUMN antecedente_paciente.fecha_diagnostico IS 'Nullable: el paciente a menudo no recuerda la fecha.';
COMMENT ON COLUMN antecedente_paciente.activo IS 'FALSE = antecedente resuelto o capturado por error; no se borra.';

-- 3. MEDICO -------------------------------------------------------------------
CREATE TABLE medico (
    id                  UUID          NOT NULL DEFAULT gen_uuid_v7(),
    cedula_profesional  VARCHAR(20)   NOT NULL,
    nombre              VARCHAR(100)  NOT NULL,
    apellido_paterno    VARCHAR(100)  NOT NULL,
    apellido_materno    VARCHAR(100),
    especialidad        VARCHAR(80),
    institucion         VARCHAR(120),
    telefono            VARCHAR(20),
    correo              VARCHAR(254),
    activo              BOOLEAN       NOT NULL DEFAULT TRUE,
    creado_en           TIMESTAMPTZ   NOT NULL DEFAULT now(),
    actualizado_en      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT pk_medico PRIMARY KEY (id),
    CONSTRAINT uq_medico_cedula_profesional UNIQUE (cedula_profesional),
    CONSTRAINT ck_medico_correo CHECK (correo ~ '^[^@\s]+@[^@\s]+$')
);
COMMENT ON TABLE  medico IS 'Médico solicitante de estudios.';
COMMENT ON COLUMN medico.cedula_profesional IS 'VARCHAR(20): la cédula SEP tiene 7-8 dígitos; margen para cédulas extranjeras.';
COMMENT ON COLUMN medico.apellido_materno IS 'Nullable: hay personas con un solo apellido.';
COMMENT ON COLUMN medico.especialidad IS 'Nullable: médicos generales no registran especialidad.';
COMMENT ON COLUMN medico.institucion IS 'Nullable: práctica privada sin institución.';
COMMENT ON COLUMN medico.telefono IS 'VARCHAR(20): E.164 + separadores. Nullable: contacto opcional.';
COMMENT ON COLUMN medico.correo IS 'VARCHAR(254): RFC 5321. Nullable: contacto opcional.';

-- 4. PERSONAL -----------------------------------------------------------------
CREATE TABLE personal (
    id                UUID          NOT NULL DEFAULT gen_uuid_v7(),
    numero_empleado   VARCHAR(20)   NOT NULL,
    nombre            VARCHAR(100)  NOT NULL,
    apellido_paterno  VARCHAR(100)  NOT NULL,
    apellido_materno  VARCHAR(100),
    rol               rol_personal  NOT NULL,
    certificaciones   JSONB,
    activo            BOOLEAN       NOT NULL DEFAULT TRUE,
    creado_en         TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT pk_personal PRIMARY KEY (id),
    CONSTRAINT uq_personal_numero_empleado UNIQUE (numero_empleado)
);
COMMENT ON TABLE  personal IS 'Personal del laboratorio: toma muestras, opera equipos, registra pagos y correcciones.';
COMMENT ON COLUMN personal.apellido_materno IS 'Nullable: hay personas con un solo apellido.';
COMMENT ON COLUMN personal.certificaciones IS 'Nullable, JSONB: lista semiestructurada informativa; ninguna regla de negocio la consulta.';

-- 5. EQUIPO -------------------------------------------------------------------
CREATE TABLE equipo (
    id                          UUID                     NOT NULL DEFAULT gen_uuid_v7(),
    numero_serie                VARCHAR(60)              NOT NULL,
    nombre_modelo               VARCHAR(120)             NOT NULL,
    fabricante                  VARCHAR(80),
    ubicacion                   VARCHAR(80),
    estado_operativo            estado_operativo_equipo  NOT NULL DEFAULT 'operativo',
    fecha_ultimo_mantenimiento  DATE,
    fecha_proximo_mantenimiento DATE,
    creado_en                   TIMESTAMPTZ              NOT NULL DEFAULT now(),
    CONSTRAINT pk_equipo PRIMARY KEY (id),
    CONSTRAINT uq_equipo_numero_serie UNIQUE (numero_serie)
);
COMMENT ON TABLE  equipo IS 'Analizador/instrumento del laboratorio.';
COMMENT ON COLUMN equipo.estado_operativo IS 'Desnormalizado a propósito: copia del último estado_nuevo de estado_equipo, para que trg_bloquear_equipo_no_operativo valide sin recorrer la bitácora. Solo ADMINISTRADOR lo cambia (regla de aplicación). dado_de_baja = inactivo (la tabla no tiene columna activo).';
COMMENT ON COLUMN equipo.fabricante IS 'Nullable: equipos antiguos o donados sin dato de fabricante.';
COMMENT ON COLUMN equipo.ubicacion IS 'Nullable: equipo en almacén o sin área asignada.';
COMMENT ON COLUMN equipo.fecha_ultimo_mantenimiento IS 'Nullable: equipo nuevo sin mantenimiento previo.';
COMMENT ON COLUMN equipo.fecha_proximo_mantenimiento IS 'Nullable: aún no programado.';

-- 6. ESTUDIO ------------------------------------------------------------------
CREATE TABLE estudio (
    id                             UUID               NOT NULL DEFAULT gen_uuid_v7(),
    codigo                         VARCHAR(20)        NOT NULL,
    nombre                         VARCHAR(120)       NOT NULL,
    categoria                      categoria_estudio  NOT NULL,
    descripcion                    TEXT,
    cantidad_muestras_requeridas   SMALLINT           NOT NULL DEFAULT 1,
    tiempo_procesamiento_estimado  INTERVAL,
    requiere_ayuno                 BOOLEAN            NOT NULL DEFAULT FALSE,
    indicaciones_especiales        TEXT,
    precio                         NUMERIC(10,2)      NOT NULL,
    activo                         BOOLEAN            NOT NULL DEFAULT TRUE,
    creado_en                      TIMESTAMPTZ        NOT NULL DEFAULT now(),
    actualizado_en                 TIMESTAMPTZ        NOT NULL DEFAULT now(),
    CONSTRAINT pk_estudio PRIMARY KEY (id),
    CONSTRAINT uq_estudio_codigo UNIQUE (codigo),
    CONSTRAINT ck_estudio_cantidad_muestras CHECK (cantidad_muestras_requeridas > 0),
    CONSTRAINT ck_estudio_precio CHECK (precio >= 0)
);
COMMENT ON TABLE  estudio IS 'Catálogo de estudios de laboratorio que se pueden solicitar. Los tipos de muestra aceptados viven en estudio_tipo_muestra; los analitos, en parametro_estudio.';
COMMENT ON COLUMN estudio.codigo IS 'Código interno, ej. "HEM-001".';
COMMENT ON COLUMN estudio.descripcion IS 'Nullable: texto opcional para el catálogo público.';
COMMENT ON COLUMN estudio.tiempo_procesamiento_estimado IS 'Nullable: estudios nuevos sin tiempo medido todavía.';
COMMENT ON COLUMN estudio.indicaciones_especiales IS 'Nullable: la mayoría de estudios no tiene indicaciones.';
COMMENT ON COLUMN estudio.precio IS 'Precio vigente simple, sin histórico (decisión de alcance). DETALLE_CUENTA guarda snapshot.';

-- 7. ESTUDIO_TIPO_MUESTRA (puente N:M) ----------------------------------------
CREATE TABLE estudio_tipo_muestra (
    id            UUID          NOT NULL DEFAULT gen_uuid_v7(),
    estudio_id    UUID          NOT NULL,
    tipo_muestra  tipo_muestra  NOT NULL,
    es_preferida  BOOLEAN       NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_estudio_tipo_muestra PRIMARY KEY (id),
    CONSTRAINT uq_estudio_tipo_muestra UNIQUE (estudio_id, tipo_muestra),
    CONSTRAINT fk_estudio_tipo_muestra_estudio FOREIGN KEY (estudio_id)
        REFERENCES estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
-- A lo sumo un tipo preferido por estudio.
CREATE UNIQUE INDEX uq_estudio_tipo_muestra_preferida
    ON estudio_tipo_muestra (estudio_id) WHERE es_preferida;
COMMENT ON TABLE  estudio_tipo_muestra IS 'Tipos de muestra que acepta cada estudio (N:M), ej. glucosa en sangre venosa o capilar. trg_copiar_numero_repeticion_muestra rechaza muestras de un tipo no aceptado.';
COMMENT ON COLUMN estudio_tipo_muestra.es_preferida IS 'Tipo que se indica por defecto al paciente; a lo sumo uno por estudio.';

-- 8. PARAMETRO_ESTUDIO (débil, 1:N de estudio) --------------------------------
CREATE TABLE parametro_estudio (
    id             UUID          NOT NULL DEFAULT gen_uuid_v7(),
    estudio_id     UUID          NOT NULL,
    nombre         VARCHAR(80)   NOT NULL,
    unidad_medida  VARCHAR(20),
    orden          SMALLINT      NOT NULL DEFAULT 1,
    activo         BOOLEAN       NOT NULL DEFAULT TRUE,
    creado_en      TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT pk_parametro_estudio PRIMARY KEY (id),
    CONSTRAINT uq_parametro_estudio_nombre UNIQUE (estudio_id, nombre),
    CONSTRAINT fk_parametro_estudio_estudio FOREIGN KEY (estudio_id)
        REFERENCES estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_parametro_estudio_orden CHECK (orden > 0)
);
COMMENT ON TABLE  parametro_estudio IS 'Analito que reporta un estudio (ej. Biometría hemática -> Hemoglobina, Leucocitos...). Un estudio simple tiene un solo parámetro.';
COMMENT ON COLUMN parametro_estudio.nombre IS 'Ej. "Hemoglobina". Único dentro del estudio.';
COMMENT ON COLUMN parametro_estudio.unidad_medida IS 'Ej. "g/dL". Nullable: analitos cualitativos (Positivo/Negativo, S/I/R) no tienen unidad.';
COMMENT ON COLUMN parametro_estudio.orden IS 'Posición del analito en el reporte impreso.';

-- 9. PAQUETE ------------------------------------------------------------------
CREATE TABLE paquete (
    id              UUID           NOT NULL DEFAULT gen_uuid_v7(),
    codigo          VARCHAR(20)    NOT NULL,
    nombre          VARCHAR(120)   NOT NULL,
    descripcion     TEXT,
    precio_paquete  NUMERIC(10,2)  NOT NULL,
    activo          BOOLEAN        NOT NULL DEFAULT TRUE,
    creado_en       TIMESTAMPTZ    NOT NULL DEFAULT now(),
    CONSTRAINT pk_paquete PRIMARY KEY (id),
    CONSTRAINT uq_paquete_codigo UNIQUE (codigo),
    CONSTRAINT ck_paquete_precio CHECK (precio_paquete >= 0)
);
COMMENT ON TABLE  paquete IS 'Combo promocional de estudios (ej. "Check-up Básico").';
COMMENT ON COLUMN paquete.descripcion IS 'Nullable: texto opcional para el catálogo público.';
COMMENT ON COLUMN paquete.precio_paquete IS 'Precio del combo; no es la suma de precios individuales. No admite reembolso parcial.';

-- 10. VALOR_REFERENCIA (débil, 1:N de parametro_estudio) ----------------------
-- El EXCLUDE compara sexos como conjuntos: cada sexo es un rango entero de
-- ancho 1 y "ambos" (NULL) los cubre todos, así que "ambos" && 'F' choca.
-- Con "=" no bastaría: NULL = 'F' (o un valor 'ambos' = 'F') nunca es verdadero.
CREATE FUNCTION fn_rango_sexo(p_sexo sexo_biologico)
RETURNS int4range
LANGUAGE sql IMMUTABLE PARALLEL SAFE
SET search_path = lis, pg_temp
AS $$
    SELECT CASE p_sexo
        WHEN 'M'        THEN int4range(1, 2)
        WHEN 'F'        THEN int4range(2, 3)
        WHEN 'Intersex' THEN int4range(3, 4)
        ELSE                 int4range(1, 4)   -- NULL = aplica a todos
    END
$$;
COMMENT ON FUNCTION fn_rango_sexo(sexo_biologico) IS 'Codifica sexo_aplicable como int4range para el EXCLUDE de valor_referencia; NULL cubre todos los sexos.';

CREATE TABLE valor_referencia (
    id                    UUID            NOT NULL DEFAULT gen_uuid_v7(),
    parametro_estudio_id  UUID            NOT NULL,
    valor_minimo          NUMERIC,
    valor_maximo          NUMERIC,
    sexo_aplicable        sexo_biologico,
    edad_minima           SMALLINT,
    edad_maxima           SMALLINT,
    vigente_desde         DATE            NOT NULL DEFAULT CURRENT_DATE,
    vigente_hasta         DATE,
    activo                BOOLEAN         NOT NULL DEFAULT TRUE,
    creado_en             TIMESTAMPTZ     NOT NULL DEFAULT now(),
    CONSTRAINT pk_valor_referencia PRIMARY KEY (id),
    -- Destino de la FK compuesta de resultado_valor: garantiza que el rango
    -- usado pertenece al mismo analito que se reporta.
    CONSTRAINT uq_valor_referencia_parametro UNIQUE (id, parametro_estudio_id),
    CONSTRAINT fk_valor_referencia_parametro FOREIGN KEY (parametro_estudio_id)
        REFERENCES parametro_estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_valor_referencia_edad_minima CHECK (edad_minima >= 0),
    CONSTRAINT ck_valor_referencia_edad_maxima CHECK (edad_maxima >= edad_minima),
    CONSTRAINT ck_valor_referencia_rango CHECK (valor_minimo <= valor_maximo),
    CONSTRAINT ck_valor_referencia_algun_limite CHECK (valor_minimo IS NOT NULL OR valor_maximo IS NOT NULL),
    CONSTRAINT ck_valor_referencia_vigencia CHECK (vigente_hasta > vigente_desde),
    -- Dos rangos activos del mismo analito no pueden traslaparse en sexo,
    -- edad y vigencia a la vez (un rango para ambos sexos choca con uno de 'F').
    CONSTRAINT ex_valor_referencia_traslape EXCLUDE USING gist (
        parametro_estudio_id WITH =,
        fn_rango_sexo(sexo_aplicable) WITH &&,
        int4range(edad_minima, edad_maxima, '[]') WITH &&,
        daterange(vigente_desde, vigente_hasta, '[)') WITH &&
    ) WHERE (activo)
);
COMMENT ON TABLE  valor_referencia IS 'Rango de referencia de un analito, por sexo, edad y periodo de vigencia. Un cambio de rango cierra el vigente (vigente_hasta) y crea uno nuevo: los resultados viejos conservan el rango con que se interpretaron.';
COMMENT ON COLUMN valor_referencia.valor_minimo IS 'Nullable: NULL si solo aplica máximo.';
COMMENT ON COLUMN valor_referencia.valor_maximo IS 'Nullable: NULL si solo aplica mínimo.';
COMMENT ON COLUMN valor_referencia.sexo_aplicable IS 'Nullable: NULL = aplica a ambos sexos.';
COMMENT ON COLUMN valor_referencia.edad_minima IS 'Años cumplidos. Nullable: NULL = sin límite inferior.';
COMMENT ON COLUMN valor_referencia.edad_maxima IS 'Años cumplidos, inclusive. Nullable: NULL = sin límite superior.';
COMMENT ON COLUMN valor_referencia.vigente_desde IS 'Primer día en que aplica el rango.';
COMMENT ON COLUMN valor_referencia.vigente_hasta IS 'Día en que deja de aplicar (exclusivo). Nullable: NULL = vigente sin fecha de término.';
COMMENT ON COLUMN valor_referencia.activo IS 'Validez del registro, no vigencia temporal: FALSE = capturado por error y anulado. Un rango anulado sale del EXCLUDE para que su corrección no choque con él. Un rango superado se cierra con vigente_hasta y sigue activo (fue válido en su periodo). Aplicable hoy = activo AND CURRENT_DATE <@ daterange(vigente_desde, vigente_hasta).';

-- 11. ESTUDIO_EQUIPO (puente N:M) ---------------------------------------------
CREATE TABLE estudio_equipo (
    id                  UUID         NOT NULL DEFAULT gen_uuid_v7(),
    estudio_id          UUID         NOT NULL,
    equipo_id           UUID         NOT NULL,
    es_equipo_primario  BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_estudio_equipo PRIMARY KEY (id),
    CONSTRAINT uq_estudio_equipo UNIQUE (estudio_id, equipo_id),
    CONSTRAINT fk_estudio_equipo_estudio FOREIGN KEY (estudio_id)
        REFERENCES estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_estudio_equipo_equipo FOREIGN KEY (equipo_id)
        REFERENCES equipo (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE estudio_equipo IS 'Qué equipos pueden procesar cada estudio (N:M).';

-- 12. PAQUETE_ESTUDIO (puente N:M) --------------------------------------------
CREATE TABLE paquete_estudio (
    id          UUID     NOT NULL DEFAULT gen_uuid_v7(),
    paquete_id  UUID     NOT NULL,
    estudio_id  UUID     NOT NULL,
    CONSTRAINT pk_paquete_estudio PRIMARY KEY (id),
    CONSTRAINT uq_paquete_estudio UNIQUE (paquete_id, estudio_id),
    CONSTRAINT fk_paquete_estudio_paquete FOREIGN KEY (paquete_id)
        REFERENCES paquete (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_paquete_estudio_estudio FOREIGN KEY (estudio_id)
        REFERENCES estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE paquete_estudio IS 'Estudios que componen un paquete (N:M). Un estudio no se repite en el mismo paquete.';

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TABLE paquete_estudio, estudio_equipo, valor_referencia, paquete,
--            parametro_estudio, estudio_tipo_muestra, estudio, equipo,
--            personal, medico, antecedente_paciente, paciente;
-- DROP FUNCTION fn_rango_sexo(sexo_biologico);

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 03_clinico.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 3: Tablas clínicas transaccionales
-- Depende de: Fase 2
-- Orden: solicitud, detalle_solicitud, muestra, muestra_detalle_solicitud,
--        procesamiento, resultado, resultado_valor,
--        historial_resultado_valor, estado_equipo.
--
-- Flujo que modela:
--   solicitud 1:N detalle_solicitud (un estudio pedido; aquí vive el estado)
--   solicitud 1:N muestra (tubo físico)
--   muestra N:M detalle_solicitud (un tubo sirve a varios estudios)
--   detalle_solicitud 1:N procesamiento (un renglón por intento/corrida)
--   procesamiento 1:1 resultado (cabecera) 1:N resultado_valor (un analito)
--
-- Ajustes aprobados aplicados:
--   * muestra_detalle_solicitud UNIQUE(detalle_solicitud_id, numero_repeticion):
--     un tubo por intento de cada estudio
--   * detalle_solicitud.paquete_origen_id nullable, FK a paquete
--   * detalle_solicitud UNIQUE(solicitud_id, estudio_id, numero_repeticion)
-- solicitud.folio recibe su DEFAULT en la Fase 5 (función de folio).
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- 1. SOLICITUD ----------------------------------------------------------------
CREATE TABLE solicitud (
    id               UUID                 NOT NULL DEFAULT gen_uuid_v7(),
    folio            VARCHAR(20)          NOT NULL,
    paciente_id      UUID                 NOT NULL,
    medico_id        UUID                 NOT NULL,
    fecha_solicitud  TIMESTAMPTZ          NOT NULL DEFAULT now(),
    estado_global    estado_solicitud     NOT NULL DEFAULT 'recibida',
    prioridad        prioridad_solicitud  NOT NULL DEFAULT 'normal',
    observaciones    TEXT,
    creado_en        TIMESTAMPTZ          NOT NULL DEFAULT now(),
    CONSTRAINT pk_solicitud PRIMARY KEY (id),
    CONSTRAINT uq_solicitud_folio UNIQUE (folio),
    CONSTRAINT fk_solicitud_paciente FOREIGN KEY (paciente_id)
        REFERENCES paciente (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_solicitud_medico FOREIGN KEY (medico_id)
        REFERENCES medico (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE  solicitud IS 'Orden de estudios de un paciente, emitida por un médico.';
COMMENT ON COLUMN solicitud.folio IS 'VARCHAR(20): formato SOL-YYYY-NNNNNN (15) con margen hasta 11 dígitos. Generado por fn_generar_folio_solicitud() (Fase 5).';
COMMENT ON COLUMN solicitud.fecha_solicitud IS 'Shard key candidata para PARTITION BY RANGE mensual.';
COMMENT ON COLUMN solicitud.estado_global IS 'Derivado: lo mantiene trg_estado_global_solicitud a partir de sus detalles ("cancelada" si todos están cancelados). "entregada" se fija manualmente.';
COMMENT ON COLUMN solicitud.observaciones IS 'Nullable: nota libre opcional del médico o de recepción.';

-- 2. DETALLE_SOLICITUD --------------------------------------------------------
CREATE TABLE detalle_solicitud (
    id                 UUID                      NOT NULL DEFAULT gen_uuid_v7(),
    solicitud_id       UUID                      NOT NULL,
    estudio_id         UUID                      NOT NULL,
    paquete_origen_id  UUID,
    estado             estado_detalle_solicitud  NOT NULL DEFAULT 'pendiente_muestra',
    motivo_repeticion  TEXT,
    numero_repeticion  SMALLINT                  NOT NULL DEFAULT 0,
    creado_en          TIMESTAMPTZ               NOT NULL DEFAULT now(),
    CONSTRAINT pk_detalle_solicitud PRIMARY KEY (id),
    CONSTRAINT uq_detalle_solicitud_estudio_repeticion UNIQUE (solicitud_id, estudio_id, numero_repeticion),
    CONSTRAINT fk_detalle_solicitud_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES solicitud (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_detalle_solicitud_estudio FOREIGN KEY (estudio_id)
        REFERENCES estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_detalle_solicitud_paquete FOREIGN KEY (paquete_origen_id)
        REFERENCES paquete (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_detalle_solicitud_numero_repeticion CHECK (numero_repeticion >= 0)
);
COMMENT ON TABLE  detalle_solicitud IS 'Eje del modelo: un estudio dentro de una solicitud y su estado. Los paquetes se expanden en N filas.';
COMMENT ON COLUMN detalle_solicitud.paquete_origen_id IS 'Nullable: NULL si el estudio se vendió suelto. Si no es NULL, cancelar no reembolsa (sin reembolso parcial de paquetes).';
COMMENT ON COLUMN detalle_solicitud.motivo_repeticion IS 'Nullable: solo aplica al repetir; obligatorio a nivel de aplicación cuando estado = requiere_repeticion.';
COMMENT ON COLUMN detalle_solicitud.numero_repeticion IS 'Intento vigente. Se incrementa en la misma fila al repetir; no se crea fila nueva.';

-- 3. MUESTRA ------------------------------------------------------------------
CREATE TABLE muestra (
    id                        UUID                      NOT NULL DEFAULT gen_uuid_v7(),
    codigo_barras             VARCHAR(40)               NOT NULL,
    solicitud_id              UUID                      NOT NULL,
    tipo_muestra              tipo_muestra              NOT NULL,
    volumen_ml                NUMERIC(6,2),
    fecha_toma                TIMESTAMPTZ               NOT NULL DEFAULT now(),
    personal_id               UUID                      NOT NULL,
    condicion                 condicion_muestra         NOT NULL DEFAULT 'adecuada',
    estado                    estado_muestra            NOT NULL DEFAULT 'tomada',
    temperatura_conservacion  temperatura_conservacion,
    observaciones             TEXT,
    CONSTRAINT pk_muestra PRIMARY KEY (id),
    CONSTRAINT uq_muestra_codigo_barras UNIQUE (codigo_barras),
    CONSTRAINT fk_muestra_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES solicitud (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_muestra_personal FOREIGN KEY (personal_id)
        REFERENCES personal (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_muestra_volumen CHECK (volumen_ml > 0)
);
COMMENT ON TABLE  muestra IS 'Tubo o contenedor físico tomado para una solicitud. Un tubo puede servir a varios estudios (muestra_detalle_solicitud).';
COMMENT ON COLUMN muestra.codigo_barras IS 'VARCHAR(40): etiqueta Code 128 del laboratorio con margen.';
COMMENT ON COLUMN muestra.personal_id IS 'Quién tomó la muestra.';
COMMENT ON COLUMN muestra.volumen_ml IS 'Volumen en mililitros. Nullable: hisopos y muestras sólidas no se miden por volumen.';
COMMENT ON COLUMN muestra.temperatura_conservacion IS 'Nullable: se registra al almacenar, no al tomar.';
COMMENT ON COLUMN muestra.observaciones IS 'Nullable: nota libre opcional de la toma.';

-- 4. MUESTRA_DETALLE_SOLICITUD (puente N:M) -----------------------------------
CREATE TABLE muestra_detalle_solicitud (
    id                    UUID      NOT NULL DEFAULT gen_uuid_v7(),
    muestra_id            UUID      NOT NULL,
    detalle_solicitud_id  UUID      NOT NULL,
    numero_repeticion     SMALLINT  NOT NULL DEFAULT 0,
    CONSTRAINT pk_muestra_detalle_solicitud PRIMARY KEY (id),
    CONSTRAINT uq_muestra_detalle_solicitud UNIQUE (muestra_id, detalle_solicitud_id),
    CONSTRAINT uq_muestra_detalle_solicitud_repeticion UNIQUE (detalle_solicitud_id, numero_repeticion),
    CONSTRAINT fk_muestra_detalle_solicitud_muestra FOREIGN KEY (muestra_id)
        REFERENCES muestra (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_muestra_detalle_solicitud_detalle FOREIGN KEY (detalle_solicitud_id)
        REFERENCES detalle_solicitud (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_muestra_detalle_solicitud_repeticion CHECK (numero_repeticion >= 0)
);
COMMENT ON TABLE  muestra_detalle_solicitud IS 'Qué estudios se analizan con cada tubo (N:M). trg_copiar_numero_repeticion_muestra valida que tubo y estudio sean de la misma solicitud y que el tipo de muestra sea aceptado.';
COMMENT ON COLUMN muestra_detalle_solicitud.numero_repeticion IS 'Intento del estudio al que sirve este tubo; lo copia el trigger desde detalle_solicitud. Un tubo por intento.';

-- 5. PROCESAMIENTO ------------------------------------------------------------
CREATE TABLE procesamiento (
    id                    UUID                  NOT NULL DEFAULT gen_uuid_v7(),
    muestra_id            UUID                  NOT NULL,
    detalle_solicitud_id  UUID                  NOT NULL,
    equipo_id             UUID                  NOT NULL,
    personal_id           UUID                  NOT NULL,
    fecha_inicio          TIMESTAMPTZ           NOT NULL DEFAULT now(),
    fecha_fin             TIMESTAMPTZ,
    estado                estado_procesamiento  NOT NULL DEFAULT 'en_proceso',
    es_reprocesamiento    BOOLEAN               NOT NULL DEFAULT FALSE,
    observaciones         TEXT,
    CONSTRAINT pk_procesamiento PRIMARY KEY (id),
    -- FK compuesta: el tubo procesado debe estar vinculado a ese estudio.
    CONSTRAINT fk_procesamiento_muestra_detalle FOREIGN KEY (muestra_id, detalle_solicitud_id)
        REFERENCES muestra_detalle_solicitud (muestra_id, detalle_solicitud_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_procesamiento_equipo FOREIGN KEY (equipo_id)
        REFERENCES equipo (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_procesamiento_personal FOREIGN KEY (personal_id)
        REFERENCES personal (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_procesamiento_fechas CHECK (fecha_fin >= fecha_inicio)
);
COMMENT ON TABLE  procesamiento IS 'Corrida (intento) de un estudio sobre un tubo en un equipo; un renglón por intento. trg_bloquear_equipo_no_operativo rechaza equipos no operativos.';
COMMENT ON COLUMN procesamiento.personal_id IS 'Quién operó el equipo.';
COMMENT ON COLUMN procesamiento.fecha_inicio IS 'Shard key candidata para PARTITION BY RANGE mensual.';
COMMENT ON COLUMN procesamiento.fecha_fin IS 'Nullable: NULL mientras la corrida sigue en curso.';
COMMENT ON COLUMN procesamiento.observaciones IS 'Nullable: incidencias opcionales de la corrida.';

-- 6. RESULTADO (cabecera, 1:1 con procesamiento) ------------------------------
CREATE TABLE resultado (
    id                UUID          NOT NULL DEFAULT gen_uuid_v7(),
    procesamiento_id  UUID          NOT NULL,
    es_definitivo     BOOLEAN       NOT NULL DEFAULT FALSE,
    observaciones     TEXT,
    fecha_resultado   TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT pk_resultado PRIMARY KEY (id),
    CONSTRAINT uq_resultado_procesamiento UNIQUE (procesamiento_id),
    CONSTRAINT fk_resultado_procesamiento FOREIGN KEY (procesamiento_id)
        REFERENCES procesamiento (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
COMMENT ON TABLE  resultado IS 'Cabecera del resultado de una corrida (1:1 con procesamiento): de ella se obtiene equipo, operador, tubo y estudio. Los valores van en resultado_valor.';
COMMENT ON COLUMN resultado.es_definitivo IS 'TRUE cuando el supervisor libera el resultado para entrega.';
COMMENT ON COLUMN resultado.observaciones IS 'Nullable: comentario opcional del químico en el reporte.';

-- 7. RESULTADO_VALOR (débil, 1:N de resultado; un renglón por analito) -------
CREATE TABLE resultado_valor (
    id                    UUID                      NOT NULL DEFAULT gen_uuid_v7(),
    resultado_id          UUID                      NOT NULL,
    parametro_estudio_id  UUID                      NOT NULL,
    valor_referencia_id   UUID,
    valor_numerico        NUMERIC,
    valor_texto           TEXT,
    interpretacion        interpretacion_resultado,
    numero_version        INTEGER                   NOT NULL DEFAULT 1,
    actualizado_en        TIMESTAMPTZ               NOT NULL DEFAULT now(),
    CONSTRAINT pk_resultado_valor PRIMARY KEY (id),
    CONSTRAINT uq_resultado_valor_parametro UNIQUE (resultado_id, parametro_estudio_id),
    CONSTRAINT fk_resultado_valor_resultado FOREIGN KEY (resultado_id)
        REFERENCES resultado (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_resultado_valor_parametro FOREIGN KEY (parametro_estudio_id)
        REFERENCES parametro_estudio (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    -- FK compuesta: el rango aplicado pertenece al mismo analito.
    CONSTRAINT fk_resultado_valor_referencia FOREIGN KEY (valor_referencia_id, parametro_estudio_id)
        REFERENCES valor_referencia (id, parametro_estudio_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_resultado_valor_algun_valor CHECK (valor_numerico IS NOT NULL OR valor_texto IS NOT NULL),
    CONSTRAINT ck_resultado_valor_numero_version CHECK (numero_version >= 1)
);
COMMENT ON TABLE  resultado_valor IS 'Valor de un analito dentro de un resultado (actualización in-place; versiones previas en historial_resultado_valor). Antibiogramas: un parámetro por antibiótico con valor_texto S/I/R.';
COMMENT ON COLUMN resultado_valor.valor_referencia_id IS 'Rango con que se interpretó. Nullable: analitos cualitativos sin rango numérico.';
COMMENT ON COLUMN resultado_valor.valor_numerico IS 'Nullable: resultado cuantitativo; NULL si el analito es cualitativo (CHECK exige numérico o texto).';
COMMENT ON COLUMN resultado_valor.valor_texto IS 'Nullable: resultado cualitativo ("Positivo", "S/I/R"); NULL si es cuantitativo.';
COMMENT ON COLUMN resultado_valor.interpretacion IS 'Nullable: calculada contra valor_referencia; NULL si no hay rango aplicable.';
COMMENT ON COLUMN resultado_valor.numero_version IS 'Lo incrementa trg_historial_resultado en cada corrección de valor.';

-- 8. HISTORIAL_RESULTADO_VALOR (append-only) ----------------------------------
CREATE TABLE historial_resultado_valor (
    id                        UUID                      NOT NULL DEFAULT gen_uuid_v7(),
    resultado_valor_id        UUID                      NOT NULL,
    version                   INTEGER                   NOT NULL,
    valor_numerico_snapshot   NUMERIC,
    valor_texto_snapshot      TEXT,
    interpretacion_snapshot   interpretacion_resultado,
    motivo_modificacion       TEXT                      NOT NULL,
    modificado_por            UUID                      NOT NULL,
    fecha_modificacion        TIMESTAMPTZ               NOT NULL DEFAULT now(),
    CONSTRAINT pk_historial_resultado_valor PRIMARY KEY (id),
    CONSTRAINT fk_historial_resultado_valor_valor FOREIGN KEY (resultado_valor_id)
        REFERENCES resultado_valor (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_historial_resultado_valor_personal FOREIGN KEY (modificado_por)
        REFERENCES personal (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_historial_resultado_valor_version CHECK (version >= 1)
);
COMMENT ON TABLE  historial_resultado_valor IS 'Bitácora append-only de versiones previas de un valor de resultado. La llena trg_historial_resultado.';
COMMENT ON COLUMN historial_resultado_valor.version IS 'numero_version del valor antes del cambio.';
COMMENT ON COLUMN historial_resultado_valor.valor_numerico_snapshot IS 'Nullable: copia fiel de resultado_valor.valor_numerico, que puede ser NULL.';
COMMENT ON COLUMN historial_resultado_valor.valor_texto_snapshot IS 'Nullable: copia fiel de resultado_valor.valor_texto, que puede ser NULL.';
COMMENT ON COLUMN historial_resultado_valor.interpretacion_snapshot IS 'Nullable: copia fiel de resultado_valor.interpretacion, que puede ser NULL.';
COMMENT ON COLUMN historial_resultado_valor.motivo_modificacion IS 'Repetición, error de captura, recalibración. Viene de la variable de sesión lis.motivo_modificacion.';
COMMENT ON COLUMN historial_resultado_valor.modificado_por IS 'Viene de la variable de sesión lis.personal_id.';

-- 9. ESTADO_EQUIPO (bitácora append-only) -------------------------------------
CREATE TABLE estado_equipo (
    id               UUID                     NOT NULL DEFAULT gen_uuid_v7(),
    equipo_id        UUID                     NOT NULL,
    estado_anterior  estado_operativo_equipo  NOT NULL,
    estado_nuevo     estado_operativo_equipo  NOT NULL,
    motivo           TEXT                     NOT NULL,
    registrado_por   UUID                     NOT NULL,
    fecha_cambio     TIMESTAMPTZ              NOT NULL DEFAULT now(),
    CONSTRAINT pk_estado_equipo PRIMARY KEY (id),
    CONSTRAINT fk_estado_equipo_equipo FOREIGN KEY (equipo_id)
        REFERENCES equipo (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_estado_equipo_personal FOREIGN KEY (registrado_por)
        REFERENCES personal (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_estado_equipo_cambio CHECK (estado_anterior <> estado_nuevo)
);
COMMENT ON TABLE estado_equipo IS 'Bitácora append-only de cambios de estado operativo de un equipo. equipo.estado_operativo guarda el último estado_nuevo.';

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TABLE estado_equipo, historial_resultado_valor, resultado_valor,
--            resultado, procesamiento, muestra_detalle_solicitud, muestra,
--            detalle_solicitud, solicitud;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 04_comercial.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 4: Tablas comerciales
-- Depende de: Fase 3
-- Orden: cuenta, detalle_cuenta, pago.
-- cuenta.numero_cuenta recibe su DEFAULT en la Fase 5 (función de folio).
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- 1. CUENTA -------------------------------------------------------------------
CREATE TABLE cuenta (
    id               UUID           NOT NULL DEFAULT gen_uuid_v7(),
    numero_cuenta    VARCHAR(20)    NOT NULL,
    solicitud_id     UUID           NOT NULL,
    subtotal         NUMERIC(10,2)  NOT NULL DEFAULT 0,
    descuento_total  NUMERIC(10,2)  NOT NULL DEFAULT 0,
    total            NUMERIC(10,2)  NOT NULL DEFAULT 0,
    saldo_pendiente  NUMERIC(10,2)  NOT NULL DEFAULT 0,
    estado_pago      estado_cuenta  NOT NULL DEFAULT 'pendiente',
    fecha_cuenta     TIMESTAMPTZ    NOT NULL DEFAULT now(),
    CONSTRAINT pk_cuenta PRIMARY KEY (id),
    CONSTRAINT uq_cuenta_numero_cuenta UNIQUE (numero_cuenta),
    CONSTRAINT uq_cuenta_solicitud UNIQUE (solicitud_id),
    CONSTRAINT fk_cuenta_solicitud FOREIGN KEY (solicitud_id)
        REFERENCES solicitud (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_cuenta_subtotal CHECK (subtotal >= 0),
    CONSTRAINT ck_cuenta_descuento_total CHECK (descuento_total >= 0),
    CONSTRAINT ck_cuenta_total CHECK (total >= 0),
    CONSTRAINT ck_cuenta_saldo_pendiente CHECK (saldo_pendiente >= 0)
);
COMMENT ON TABLE  cuenta IS 'Cuenta de cobro de una solicitud (1:1). Montos desnormalizados, mantenidos por trg_recalcular_cuenta.';
COMMENT ON COLUMN cuenta.numero_cuenta IS 'Ej. "CTA-2026-000001". Generado por fn_generar_numero_cuenta() (Fase 5).';
COMMENT ON COLUMN cuenta.subtotal IS 'Desnormalizado: suma de detalle_cuenta.precio_unitario no anulados.';
COMMENT ON COLUMN cuenta.total IS 'Desnormalizado: subtotal - descuento_total.';
COMMENT ON COLUMN cuenta.saldo_pendiente IS 'Desnormalizado: total - pagos aplicados. Protegido por trg_validar_saldo_pago.';
COMMENT ON COLUMN cuenta.fecha_cuenta IS 'Shard key candidata para PARTITION BY RANGE mensual.';

-- 2. DETALLE_CUENTA -----------------------------------------------------------
CREATE TABLE detalle_cuenta (
    id                    UUID                   NOT NULL DEFAULT gen_uuid_v7(),
    cuenta_id             UUID                   NOT NULL,
    origen                origen_detalle_cuenta  NOT NULL,
    detalle_solicitud_id  UUID,
    concepto              VARCHAR(150)           NOT NULL,
    precio_unitario       NUMERIC(10,2)          NOT NULL,
    anulado               BOOLEAN                NOT NULL DEFAULT FALSE,
    creado_en             TIMESTAMPTZ            NOT NULL DEFAULT now(),
    CONSTRAINT pk_detalle_cuenta PRIMARY KEY (id),
    CONSTRAINT fk_detalle_cuenta_cuenta FOREIGN KEY (cuenta_id)
        REFERENCES cuenta (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_detalle_cuenta_detalle_solicitud FOREIGN KEY (detalle_solicitud_id)
        REFERENCES detalle_solicitud (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_detalle_cuenta_precio_unitario CHECK (precio_unitario >= 0),
    CONSTRAINT ck_detalle_cuenta_origen CHECK (
        (origen = 'estudio_individual' AND detalle_solicitud_id IS NOT NULL)
        OR
        (origen = 'paquete' AND detalle_solicitud_id IS NULL)
    )
);
COMMENT ON TABLE  detalle_cuenta IS 'Línea de cobro. Un paquete vendido genera UNA sola línea origen=paquete sin FK a sus detalles de solicitud.';
COMMENT ON COLUMN detalle_cuenta.origen IS 'Discriminador: estudio_individual (con detalle_solicitud_id) | paquete (sin él).';
COMMENT ON COLUMN detalle_cuenta.detalle_solicitud_id IS 'Nullable: NULL en líneas de paquete (una línea cubre varios detalles); ck_detalle_cuenta_origen lo exige en estudio_individual.';
COMMENT ON COLUMN detalle_cuenta.concepto IS 'Snapshot del nombre del estudio o paquete al momento de la venta.';
COMMENT ON COLUMN detalle_cuenta.precio_unitario IS 'Snapshot del precio al momento de la venta.';
COMMENT ON COLUMN detalle_cuenta.anulado IS 'Lo marca trg_cancelar_detalle_cuenta al cancelar el estudio individual asociado.';

-- 3. PAGO ---------------------------------------------------------------------
CREATE TABLE pago (
    id               UUID                  NOT NULL DEFAULT gen_uuid_v7(),
    cuenta_id        UUID                  NOT NULL,
    monto_pagado     NUMERIC(10,2)         NOT NULL,
    metodo_pago      tipo_pago             NOT NULL,
    referencia_pago  VARCHAR(60),
    recibido_por     UUID                  NOT NULL,
    fecha_pago       TIMESTAMPTZ           NOT NULL DEFAULT now(),
    estado           estado_pago_registro  NOT NULL DEFAULT 'aplicado',
    observaciones    TEXT,
    CONSTRAINT pk_pago PRIMARY KEY (id),
    CONSTRAINT fk_pago_cuenta FOREIGN KEY (cuenta_id)
        REFERENCES cuenta (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_pago_personal FOREIGN KEY (recibido_por)
        REFERENCES personal (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_pago_monto_pagado CHECK (monto_pagado > 0)
);
COMMENT ON TABLE  pago IS 'Pago aplicado a una cuenta. trg_validar_saldo_pago serializa pagos concurrentes con FOR UPDATE sobre cuenta.';
COMMENT ON COLUMN pago.referencia_pago IS 'Autorización bancaria o folio de transferencia. Nullable: los pagos en efectivo no tienen referencia.';
COMMENT ON COLUMN pago.observaciones IS 'Nullable: nota libre opcional de caja.';
COMMENT ON COLUMN pago.fecha_pago IS 'Shard key candidata para PARTITION BY RANGE mensual.';

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TABLE pago, detalle_cuenta, cuenta;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 05_secuencias.sql
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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 06_indices.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 6: Índices
-- Depende de: Fase 4 (tablas creadas; se ejecuta antes de cargar datos)
--
-- Se usa CREATE INDEX sin CONCURRENTLY porque las tablas están vacías en
-- este despliegue inicial y así el archivo puede correr en una transacción.
-- Cualquier índice que se agregue después sobre datos en producción debe
-- usar CREATE INDEX CONCURRENTLY fuera de transacción (regla 12).
--
-- Regla 23 (no duplicar índices): una FK cuya(s) columna(s) ya son el
-- prefijo de un índice UNIQUE o compuesto no recibe un índice propio; ese
-- índice existente ya sirve para verificar la referencia. 08_validacion.sql
-- comprueba que toda FK quede cubierta.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- 1. Índices de FK ------------------------------------------------------------
-- Catálogo
CREATE INDEX idx_antecedente_paciente_paciente ON antecedente_paciente (paciente_id);
-- estudio_tipo_muestra.estudio_id -> cubierto por uq_estudio_tipo_muestra (estudio_id, tipo_muestra)
-- parametro_estudio.estudio_id    -> cubierto por uq_parametro_estudio_nombre (estudio_id, nombre)
-- valor_referencia.parametro_estudio_id: el índice GiST de ex_valor_referencia_traslape
-- es parcial (WHERE activo) y no ve los rangos inactivos, así que no sirve para la FK.
CREATE INDEX idx_valor_referencia_parametro    ON valor_referencia (parametro_estudio_id);
-- estudio_equipo.estudio_id   -> cubierto por uq_estudio_equipo (estudio_id, equipo_id)
CREATE INDEX idx_estudio_equipo_equipo         ON estudio_equipo (equipo_id);
-- paquete_estudio.paquete_id  -> cubierto por uq_paquete_estudio (paquete_id, estudio_id)
CREATE INDEX idx_paquete_estudio_estudio       ON paquete_estudio (estudio_id);

-- Clínico
-- solicitud.paciente_id       -> cubierto por idx_solicitud_paciente_fecha (sección 2)
CREATE INDEX idx_solicitud_medico              ON solicitud (medico_id);
-- detalle_solicitud.solicitud_id -> cubierto por uq_detalle_solicitud_estudio_repeticion
CREATE INDEX idx_detalle_solicitud_estudio     ON detalle_solicitud (estudio_id);
CREATE INDEX idx_detalle_solicitud_paquete     ON detalle_solicitud (paquete_origen_id)
    WHERE paquete_origen_id IS NOT NULL;       -- la mayoría de filas son NULL (venta suelta)
CREATE INDEX idx_muestra_solicitud             ON muestra (solicitud_id);
CREATE INDEX idx_muestra_personal              ON muestra (personal_id);
-- muestra_detalle_solicitud.muestra_id           -> cubierto por uq_muestra_detalle_solicitud
-- muestra_detalle_solicitud.detalle_solicitud_id -> cubierto por uq_muestra_detalle_solicitud_repeticion
CREATE INDEX idx_procesamiento_muestra_detalle ON procesamiento (muestra_id, detalle_solicitud_id);
-- procesamiento.equipo_id     -> cubierto por idx_procesamiento_equipo_fecha (sección 2)
CREATE INDEX idx_procesamiento_personal        ON procesamiento (personal_id);
-- resultado.procesamiento_id  -> cubierto por uq_resultado_procesamiento
-- resultado_valor.resultado_id -> cubierto por uq_resultado_valor_parametro
CREATE INDEX idx_resultado_valor_parametro     ON resultado_valor (parametro_estudio_id);
CREATE INDEX idx_resultado_valor_referencia    ON resultado_valor (valor_referencia_id, parametro_estudio_id);
CREATE INDEX idx_historial_resultado_valor_valor    ON historial_resultado_valor (resultado_valor_id);
CREATE INDEX idx_historial_resultado_valor_personal ON historial_resultado_valor (modificado_por);
CREATE INDEX idx_estado_equipo_equipo          ON estado_equipo (equipo_id);
CREATE INDEX idx_estado_equipo_personal        ON estado_equipo (registrado_por);

-- Comercial
-- cuenta.solicitud_id         -> cubierto por uq_cuenta_solicitud
CREATE INDEX idx_detalle_cuenta_cuenta         ON detalle_cuenta (cuenta_id);
CREATE INDEX idx_detalle_cuenta_detalle_sol    ON detalle_cuenta (detalle_solicitud_id)
    WHERE detalle_solicitud_id IS NOT NULL;    -- líneas de paquete siempre son NULL
-- pago.cuenta_id              -> cubierto por idx_pago_cuenta_fecha (sección 2)
CREATE INDEX idx_pago_personal                 ON pago (recibido_por);

-- 2. Índices compuestos (diccionario, sección 7) ------------------------------
CREATE INDEX idx_solicitud_paciente_fecha   ON solicitud (paciente_id, fecha_solicitud DESC);
-- El diccionario pide (estado, fecha_solicitud), pero detalle_solicitud no
-- tiene fecha_solicitud; su marca temporal equivalente es creado_en.
CREATE INDEX idx_detalle_solicitud_estado_fecha ON detalle_solicitud (estado, creado_en);
CREATE INDEX idx_procesamiento_equipo_fecha ON procesamiento (equipo_id, fecha_inicio DESC);
CREATE INDEX idx_pago_cuenta_fecha          ON pago (cuenta_id, fecha_pago);
-- "Valor vigente de un analito en un resultado" lo resuelve
-- uq_resultado_valor_parametro (resultado_id, parametro_estudio_id): hay una
-- sola fila por analito y las versiones previas viven en el historial.

-- 3. Índices parciales --------------------------------------------------------
CREATE INDEX idx_detalle_pendiente ON detalle_solicitud (creado_en)
    WHERE estado NOT IN ('completado', 'repetido_completado', 'cancelado');
CREATE INDEX idx_equipo_no_operativo ON equipo (estado_operativo)
    WHERE estado_operativo <> 'operativo';
CREATE INDEX idx_cuenta_abierta ON cuenta (fecha_cuenta)
    WHERE estado_pago IN ('pendiente', 'parcialmente_pagada');
COMMENT ON INDEX idx_detalle_pendiente   IS 'Dashboard de estudios pendientes ordenados por antigüedad.';
COMMENT ON INDEX idx_equipo_no_operativo IS 'Validación rápida de equipos no disponibles.';
COMMENT ON INDEX idx_cuenta_abierta      IS 'Caja: cuentas por cobrar.';

-- 4. Índices GIN --------------------------------------------------------------
-- Ninguno: paciente.antecedentes y resultado.datos_estructurados (JSONB) se
-- normalizaron en antecedente_paciente y resultado_valor. personal.certificaciones
-- es JSONB informativo que ninguna consulta filtra (regla 20: sin índices
-- especulativos).

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP INDEX idx_cuenta_abierta, idx_equipo_no_operativo, idx_detalle_pendiente,
--   idx_pago_cuenta_fecha, idx_procesamiento_equipo_fecha,
--   idx_detalle_solicitud_estado_fecha, idx_solicitud_paciente_fecha,
--   idx_pago_personal, idx_detalle_cuenta_detalle_sol, idx_detalle_cuenta_cuenta,
--   idx_estado_equipo_personal, idx_estado_equipo_equipo,
--   idx_historial_resultado_valor_personal, idx_historial_resultado_valor_valor,
--   idx_resultado_valor_referencia, idx_resultado_valor_parametro,
--   idx_procesamiento_personal, idx_procesamiento_muestra_detalle,
--   idx_muestra_personal, idx_muestra_solicitud, idx_detalle_solicitud_paquete,
--   idx_detalle_solicitud_estudio, idx_solicitud_medico, idx_paquete_estudio_estudio,
--   idx_estudio_equipo_equipo, idx_valor_referencia_parametro,
--   idx_antecedente_paciente_paciente;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 07_triggers.sql
-- =============================================================================
-- LIS Laboratorio Clínico — Fase 7: Funciones y triggers de negocio
-- Depende de: Fase 6
-- Pruebas aisladas (BEGIN ... ROLLBACK): tests/triggers/0N_*.sql
--
-- Orden de bloqueo (regla 28, evita deadlocks):
--   detalle_solicitud -> solicitud
--   detalle_solicitud -> detalle_cuenta -> cuenta
--   pago -> cuenta
--   procesamiento -> equipo (FOR SHARE)
--   muestra_detalle_solicitud -> detalle_solicitud / muestra (solo lectura)
--   resultado_valor -> resultado / procesamiento / detalle_solicitud (solo lectura)
-- Ningún trigger adquiere los bloqueos en orden inverso.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- -----------------------------------------------------------------------------
-- 1. trg_estado_global_solicitud
--    AFTER INSERT/UPDATE OF estado en detalle_solicitud
--    Matriz (en orden de prioridad):
--      solicitud sin detalles                        -> se conserva el estado
--      todos sus detalles cancelados                 -> cancelada
--    y, sobre los detalles NO cancelados:
--      todos completado/repetido_completado          -> completada
--      alguno completado                             -> parcialmente_completada
--      alguno en_procesamiento/requiere_repeticion   -> en_procesamiento
--      alguno muestra_tomada                         -> en_toma_de_muestra
--      todos pendiente_muestra                       -> recibida
--    'entregada' (fijado manualmente) no se degrada a 'completada'.
--    'cancelada' no es terminal: si luego se agrega un detalle no cancelado,
--    la solicitud se recalcula con la matriz normal.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_estado_global_solicitud()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_actual   estado_solicitud;
    v_nuevo    estado_solicitud;
    v_total    int;
    v_activos  int;
    v_tomadas  int;
    v_proceso  int;
    v_listos   int;
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.estado IS NOT DISTINCT FROM NEW.estado THEN
        RETURN NULL;
    END IF;

    -- Bloquea la solicitud primero: las actualizaciones concurrentes de
    -- detalles hermanos se serializan y el conteo siguiente ve lo confirmado.
    SELECT estado_global INTO v_actual
    FROM solicitud WHERE id = NEW.solicitud_id
    FOR UPDATE;

    SELECT count(*),
           count(*) FILTER (WHERE estado <> 'cancelado'),
           count(*) FILTER (WHERE estado = 'muestra_tomada'),
           count(*) FILTER (WHERE estado IN ('en_procesamiento', 'requiere_repeticion')),
           count(*) FILTER (WHERE estado IN ('completado', 'repetido_completado'))
      INTO v_total, v_activos, v_tomadas, v_proceso, v_listos
    FROM detalle_solicitud
    WHERE solicitud_id = NEW.solicitud_id;

    v_nuevo := CASE
        WHEN v_total = 0            THEN v_actual
        WHEN v_activos = 0          THEN 'cancelada'
        WHEN v_listos = v_activos   THEN 'completada'
        WHEN v_listos > 0           THEN 'parcialmente_completada'
        WHEN v_proceso > 0          THEN 'en_procesamiento'
        WHEN v_tomadas > 0          THEN 'en_toma_de_muestra'
        ELSE 'recibida'
    END::estado_solicitud;

    IF v_actual = 'entregada' AND v_nuevo = 'completada' THEN
        v_nuevo := 'entregada';
    END IF;

    IF v_nuevo IS DISTINCT FROM v_actual THEN
        UPDATE solicitud SET estado_global = v_nuevo WHERE id = NEW.solicitud_id;
    END IF;

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_estado_global_solicitud() IS 'Recalcula solicitud.estado_global a partir de los estados de sus detalles.';

CREATE TRIGGER trg_estado_global_solicitud
    AFTER INSERT OR UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW EXECUTE FUNCTION fn_estado_global_solicitud();

-- -----------------------------------------------------------------------------
-- 2. trg_bloquear_equipo_no_operativo
--    BEFORE INSERT en procesamiento. FOR SHARE evita que el equipo cambie de
--    estado entre la validación y el commit del procesamiento.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_bloquear_equipo_no_operativo()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estado estado_operativo_equipo;
BEGIN
    SELECT estado_operativo INTO v_estado
    FROM equipo WHERE id = NEW.equipo_id
    FOR SHARE;

    IF FOUND AND v_estado <> 'operativo' THEN
        RAISE EXCEPTION 'Equipo % no operativo (estado: %); no se puede registrar procesamiento',
                        NEW.equipo_id, v_estado
            USING ERRCODE = 'check_violation',
                  HINT = 'Solo se procesa en equipos con estado_operativo = operativo.';
    END IF;

    RETURN NEW;   -- si el equipo no existe, la FK reporta el error
END
$$;
COMMENT ON FUNCTION fn_bloquear_equipo_no_operativo() IS 'Rechaza procesamiento en equipos cuyo estado_operativo <> operativo.';

CREATE TRIGGER trg_bloquear_equipo_no_operativo
    BEFORE INSERT ON procesamiento
    FOR EACH ROW EXECUTE FUNCTION fn_bloquear_equipo_no_operativo();

-- -----------------------------------------------------------------------------
-- 3. trg_historial_resultado
--    BEFORE UPDATE en resultado_valor. Si cambia algún valor (valor_numerico,
--    valor_texto o interpretacion) copia la versión previa a
--    historial_resultado_valor e incrementa numero_version. Cada analito se
--    versiona por separado.
--    Quién y por qué se toman de variables de sesión que la aplicación fija
--    en la misma transacción:
--        SET LOCAL lis.personal_id = '<uuid>';
--        SET LOCAL lis.motivo_modificacion = 'error de captura';
--    Sin ellas la corrección se rechaza (historial exige ambos NOT NULL).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_historial_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_personal  uuid;
    v_motivo    text;
BEGIN
    NEW.numero_version := OLD.numero_version;   -- no editable a mano
    NEW.actualizado_en := now();

    IF (OLD.valor_numerico, OLD.valor_texto, OLD.interpretacion)
       IS NOT DISTINCT FROM
       (NEW.valor_numerico, NEW.valor_texto, NEW.interpretacion) THEN
        RETURN NEW;
    END IF;

    v_personal := nullif(current_setting('lis.personal_id', true), '')::uuid;
    v_motivo   := nullif(btrim(current_setting('lis.motivo_modificacion', true)), '');

    IF v_personal IS NULL OR v_motivo IS NULL THEN
        RAISE EXCEPTION 'Corregir el valor de resultado % requiere lis.personal_id y lis.motivo_modificacion', OLD.id
            USING ERRCODE = 'not_null_violation',
                  HINT = 'Ejecute SET LOCAL lis.personal_id y SET LOCAL lis.motivo_modificacion en la misma transacción.';
    END IF;

    INSERT INTO historial_resultado_valor (
        resultado_valor_id, version,
        valor_numerico_snapshot, valor_texto_snapshot, interpretacion_snapshot,
        motivo_modificacion, modificado_por
    ) VALUES (
        OLD.id, OLD.numero_version,
        OLD.valor_numerico, OLD.valor_texto, OLD.interpretacion,
        v_motivo, v_personal
    );

    NEW.numero_version := OLD.numero_version + 1;
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_historial_resultado() IS 'Versiona correcciones de resultado_valor en historial_resultado_valor. Requiere SET LOCAL lis.personal_id / lis.motivo_modificacion.';

CREATE TRIGGER trg_historial_resultado
    BEFORE UPDATE ON resultado_valor
    FOR EACH ROW EXECUTE FUNCTION fn_historial_resultado();

-- -----------------------------------------------------------------------------
-- 4. trg_recalcular_cuenta
--    AFTER INSERT/UPDATE en detalle_cuenta y en pago.
--      subtotal        = Σ precio_unitario de líneas no anuladas
--      total           = subtotal - descuento_total (CHECK total >= 0 rechaza
--                        descuentos mayores al subtotal)
--      saldo_pendiente = max(total - Σ pagos aplicados, 0)
--      estado_pago     = pagada si hay pagos y saldo 0; parcialmente_pagada
--                        si hay pagos y saldo > 0; pendiente si no hay pagos.
--                        'cancelada' se respeta (la fija la aplicación).
--    Si los pagos superan el total (p. ej. se anuló un estudio ya pagado) el
--    saldo queda en 0 y se emite WARNING; el trigger no genera ningún
--    movimiento de devolución.
--    saldo_pendiente es un campo desnormalizado; el sobrepago real permanece
--    calculable a partir de PAGO y DETALLE_CUENTA.anulado. La devolución es
--    un proceso manual, fuera de alcance (ver Pendiente en README.md).
--    CHECK (saldo_pendiente >= 0) se conserva como protección ante errores
--    de cálculo de otros triggers.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_recalcular_totales_cuenta(p_cuenta_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    c           record;
    v_subtotal  numeric(10,2);
    v_pagado    numeric(10,2);
    v_total     numeric(10,2);
    v_saldo     numeric(10,2);
    v_estado    estado_cuenta;
BEGIN
    SELECT numero_cuenta, subtotal, descuento_total, total, saldo_pendiente, estado_pago
      INTO c
    FROM cuenta WHERE id = p_cuenta_id
    FOR UPDATE;
    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT coalesce(sum(precio_unitario), 0) INTO v_subtotal
    FROM detalle_cuenta
    WHERE cuenta_id = p_cuenta_id AND NOT anulado;

    SELECT coalesce(sum(monto_pagado), 0) INTO v_pagado
    FROM pago
    WHERE cuenta_id = p_cuenta_id AND estado = 'aplicado';

    v_total := v_subtotal - c.descuento_total;
    v_saldo := greatest(v_total - v_pagado, 0);

    IF v_pagado > greatest(v_total, 0) THEN
        RAISE WARNING 'Cuenta %: pagos aplicados (%) superan el total (%); sobrepago de % (devolución manual)',
                      c.numero_cuenta, v_pagado, v_total, v_pagado - v_total;
    END IF;

    v_estado := CASE
        WHEN c.estado_pago = 'cancelada'     THEN 'cancelada'
        WHEN v_pagado > 0 AND v_saldo = 0    THEN 'pagada'
        WHEN v_pagado > 0                    THEN 'parcialmente_pagada'
        ELSE 'pendiente'
    END::estado_cuenta;

    IF (c.subtotal, c.total, c.saldo_pendiente, c.estado_pago)
       IS DISTINCT FROM (v_subtotal, v_total, v_saldo, v_estado) THEN
        UPDATE cuenta
           SET subtotal = v_subtotal,
               total = v_total,
               saldo_pendiente = v_saldo,
               estado_pago = v_estado
         WHERE id = p_cuenta_id;
    END IF;
END
$$;
COMMENT ON FUNCTION fn_recalcular_totales_cuenta(uuid) IS 'Recalcula subtotal, total, saldo_pendiente y estado_pago de una cuenta.';

CREATE FUNCTION fn_recalcular_cuenta()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    PERFORM fn_recalcular_totales_cuenta(NEW.cuenta_id);
    IF TG_OP = 'UPDATE' AND OLD.cuenta_id <> NEW.cuenta_id THEN
        PERFORM fn_recalcular_totales_cuenta(OLD.cuenta_id);
    END IF;
    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_recalcular_cuenta() IS 'Trigger compartido por detalle_cuenta y pago: dispara el recálculo de la cuenta afectada.';

CREATE TRIGGER trg_recalcular_cuenta
    AFTER INSERT OR UPDATE ON detalle_cuenta
    FOR EACH ROW EXECUTE FUNCTION fn_recalcular_cuenta();

CREATE TRIGGER trg_recalcular_cuenta
    AFTER INSERT OR UPDATE ON pago
    FOR EACH ROW EXECUTE FUNCTION fn_recalcular_cuenta();

-- -----------------------------------------------------------------------------
-- 5. trg_validar_saldo_pago
--    BEFORE INSERT en pago (y UPDATE de monto/estado/cuenta, para que un pago
--    cancelado no pueda "reactivarse" por encima del saldo).
--    FOR UPDATE sobre cuenta serializa pagos concurrentes de la misma cuenta:
--    el segundo espera al commit del primero y lee el saldo ya actualizado.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_saldo_pago()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_saldo       numeric(10,2);
    v_estado      estado_cuenta;
    v_disponible  numeric(10,2);
BEGIN
    IF NEW.estado <> 'aplicado' THEN
        RETURN NEW;
    END IF;

    SELECT saldo_pendiente, estado_pago INTO v_saldo, v_estado
    FROM cuenta WHERE id = NEW.cuenta_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN NEW;   -- la FK reporta el error
    END IF;

    IF v_estado = 'cancelada' THEN
        RAISE EXCEPTION 'La cuenta % está cancelada; no admite pagos', NEW.cuenta_id
            USING ERRCODE = 'check_violation';
    END IF;

    v_disponible := v_saldo;
    IF TG_OP = 'UPDATE' AND OLD.estado = 'aplicado' AND OLD.cuenta_id = NEW.cuenta_id THEN
        v_disponible := v_disponible + OLD.monto_pagado;
    END IF;

    IF NEW.monto_pagado > v_disponible THEN
        RAISE EXCEPTION 'Pago de % excede el saldo pendiente (%) de la cuenta %',
                        NEW.monto_pagado, v_disponible, NEW.cuenta_id
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_saldo_pago() IS 'Bloquea la cuenta (FOR UPDATE) y rechaza pagos aplicados mayores al saldo pendiente.';

CREATE TRIGGER trg_validar_saldo_pago
    BEFORE INSERT OR UPDATE OF monto_pagado, estado, cuenta_id ON pago
    FOR EACH ROW EXECUTE FUNCTION fn_validar_saldo_pago();

-- -----------------------------------------------------------------------------
-- 6. trg_cancelar_detalle_cuenta
--    AFTER UPDATE en detalle_solicitud cuando estado pasa a 'cancelado'.
--    Venta suelta (paquete_origen_id IS NULL): anula su línea de cuenta; el
--    UPDATE sobre detalle_cuenta dispara trg_recalcular_cuenta.
--    Parte de paquete: no hace nada (sin reembolso parcial de paquetes).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_cancelar_detalle_cuenta()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    IF NEW.paquete_origen_id IS NOT NULL THEN
        RETURN NULL;
    END IF;

    UPDATE detalle_cuenta
       SET anulado = TRUE
     WHERE detalle_solicitud_id = NEW.id
       AND origen = 'estudio_individual'
       AND NOT anulado;

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_cancelar_detalle_cuenta() IS 'Anula la línea de cuenta de un estudio suelto cancelado; ignora estudios de paquete.';

CREATE TRIGGER trg_cancelar_detalle_cuenta
    AFTER UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW
    WHEN (NEW.estado = 'cancelado' AND OLD.estado IS DISTINCT FROM 'cancelado')
    EXECUTE FUNCTION fn_cancelar_detalle_cuenta();

-- -----------------------------------------------------------------------------
-- 7. trg_descartar_muestra_cancelada
--    AFTER UPDATE en detalle_solicitud cuando estado pasa a 'cancelado':
--    todo tubo vinculado al detalle en 'tomada' o 'en_analisis' pasa a
--    'descartada', salvo que también sirva a otro estudio no cancelado (un
--    tubo compartido sigue vivo mientras algún estudio lo necesite).
--    Aplica siempre, sea venta suelta o parte de paquete.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_descartar_muestra_cancelada()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
BEGIN
    UPDATE muestra m
       SET estado = 'descartada'
      FROM muestra_detalle_solicitud mds
     WHERE mds.detalle_solicitud_id = NEW.id
       AND m.id = mds.muestra_id
       AND m.estado IN ('tomada', 'en_analisis')
       AND NOT EXISTS (
             SELECT 1
             FROM muestra_detalle_solicitud otro
             JOIN detalle_solicitud ds ON ds.id = otro.detalle_solicitud_id
             WHERE otro.muestra_id = m.id
               AND otro.detalle_solicitud_id <> NEW.id
               AND ds.estado <> 'cancelado');

    RETURN NULL;
END
$$;
COMMENT ON FUNCTION fn_descartar_muestra_cancelada() IS 'Descarta tubos vivos (tomada/en_analisis) de un detalle cancelado si ningún otro estudio vigente los usa.';

CREATE TRIGGER trg_descartar_muestra_cancelada
    AFTER UPDATE OF estado ON detalle_solicitud
    FOR EACH ROW
    WHEN (NEW.estado = 'cancelado' AND OLD.estado IS DISTINCT FROM 'cancelado')
    EXECUTE FUNCTION fn_descartar_muestra_cancelada();

-- -----------------------------------------------------------------------------
-- 8. trg_copiar_numero_repeticion_muestra
--    BEFORE INSERT en muestra_detalle_solicitud (vínculo tubo <-> estudio):
--      * numero_repeticion se deriva del intento vigente del detalle e
--        ignora el valor enviado por la aplicación;
--      * el tubo debe ser de la misma solicitud que el detalle (no se
--        mezclan muestras de pacientes);
--      * el tipo de muestra del tubo debe estar aceptado por el estudio
--        (estudio_tipo_muestra).
--    Sin FOR UPDATE: la toma de muestra es un acto físico secuencial; la
--    unicidad la protege UNIQUE(detalle_solicitud_id, numero_repeticion).
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_copiar_numero_repeticion_muestra()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_detalle  record;
    v_muestra  record;
BEGIN
    SELECT solicitud_id, estudio_id, numero_repeticion INTO v_detalle
    FROM detalle_solicitud WHERE id = NEW.detalle_solicitud_id;
    SELECT solicitud_id, tipo_muestra INTO v_muestra
    FROM muestra WHERE id = NEW.muestra_id;

    IF v_detalle.solicitud_id IS NULL OR v_muestra.solicitud_id IS NULL THEN
        RETURN NEW;   -- si el detalle o la muestra no existen, la FK reporta el error
    END IF;

    IF v_muestra.solicitud_id <> v_detalle.solicitud_id THEN
        RAISE EXCEPTION 'La muestra % pertenece a otra solicitud que el detalle %',
                        NEW.muestra_id, NEW.detalle_solicitud_id
            USING ERRCODE = 'check_violation';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM estudio_tipo_muestra
                   WHERE estudio_id = v_detalle.estudio_id
                     AND tipo_muestra = v_muestra.tipo_muestra) THEN
        RAISE EXCEPTION 'El estudio % no acepta muestras de tipo %',
                        v_detalle.estudio_id, v_muestra.tipo_muestra
            USING ERRCODE = 'check_violation',
                  HINT = 'Registre el tipo en estudio_tipo_muestra o use otro tubo.';
    END IF;

    NEW.numero_repeticion := v_detalle.numero_repeticion;
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_copiar_numero_repeticion_muestra() IS 'Al vincular tubo y estudio: copia numero_repeticion del detalle y valida misma solicitud y tipo de muestra aceptado.';

CREATE TRIGGER trg_copiar_numero_repeticion_muestra
    BEFORE INSERT ON muestra_detalle_solicitud
    FOR EACH ROW EXECUTE FUNCTION fn_copiar_numero_repeticion_muestra();

-- -----------------------------------------------------------------------------
-- 9. trg_validar_parametro_resultado
--    BEFORE INSERT / UPDATE OF resultado_id, parametro_estudio_id en
--    resultado_valor: el analito debe pertenecer al estudio que se procesó
--    (resultado -> procesamiento -> detalle_solicitud.estudio_id). Impide,
--    p. ej., capturar Hemoglobina en una corrida de glucosa.
--    Una FK compuesta exigiría copiar estudio_id en procesamiento, resultado
--    y resultado_valor; el trigger evita esa cadena de desnormalización.
--    La revalidación tras reasignar procesamiento.detalle_solicitud_id o
--    resultado.procesamiento_id la cubren los triggers 10 y 11.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_parametro_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estudio_procesado  uuid;
    v_estudio_parametro  uuid;
BEGIN
    SELECT ds.estudio_id INTO v_estudio_procesado
    FROM resultado r
    JOIN procesamiento p      ON p.id = r.procesamiento_id
    JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
    WHERE r.id = NEW.resultado_id;

    SELECT estudio_id INTO v_estudio_parametro
    FROM parametro_estudio WHERE id = NEW.parametro_estudio_id;

    IF v_estudio_procesado IS NULL OR v_estudio_parametro IS NULL THEN
        RETURN NEW;   -- si el resultado o el parámetro no existen, la FK reporta el error
    END IF;

    IF v_estudio_parametro <> v_estudio_procesado THEN
        RAISE EXCEPTION 'El parámetro % no pertenece al estudio % procesado en el resultado %',
                        NEW.parametro_estudio_id, v_estudio_procesado, NEW.resultado_id
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_parametro_resultado() IS 'Rechaza un resultado_valor cuyo analito no pertenece al estudio del procesamiento.';

CREATE TRIGGER trg_validar_parametro_resultado
    BEFORE INSERT OR UPDATE OF resultado_id, parametro_estudio_id ON resultado_valor
    FOR EACH ROW EXECUTE FUNCTION fn_validar_parametro_resultado();

-- -----------------------------------------------------------------------------
-- Helper de los triggers 10 y 11: repite la comprobación del trigger 9 pero al
-- revés (contra un resultado que ya tiene valores capturados) cuando se
-- reasigna el estudio procesado *después* de la captura.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_resultado_contra_estudio(p_resultado_id uuid, p_estudio_id uuid)
RETURNS void
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_parametro_id  uuid;
BEGIN
    SELECT rv.parametro_estudio_id INTO v_parametro_id
    FROM resultado_valor rv
    JOIN parametro_estudio pe ON pe.id = rv.parametro_estudio_id
    WHERE rv.resultado_id = p_resultado_id
      AND pe.estudio_id <> p_estudio_id
    LIMIT 1;

    IF v_parametro_id IS NOT NULL THEN
        RAISE EXCEPTION 'El resultado % ya tiene un valor del parámetro %, que no pertenece al estudio %',
                        p_resultado_id, v_parametro_id, p_estudio_id
            USING ERRCODE = 'check_violation';
    END IF;
END
$$;
COMMENT ON FUNCTION fn_validar_resultado_contra_estudio(uuid, uuid) IS 'Rechaza reasignar el estudio de un resultado que ya tiene valores de otro estudio. Usada por los triggers 10 y 11.';

-- -----------------------------------------------------------------------------
-- 10. trg_validar_reasignacion_procesamiento
--     BEFORE UPDATE OF detalle_solicitud_id en procesamiento: si el
--     procesamiento ya tiene un resultado con valores capturados, el nuevo
--     detalle_solicitud_id debe ser del mismo estudio que esos valores.
--     Cierra el hueco que dejaba abierto trg_validar_parametro_resultado: sin
--     este trigger, reasignar el procesamiento a otro estudio después de
--     capturar valores dejaría analitos de un estudio distinto sin que
--     ningún trigger lo notara.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_reasignacion_procesamiento()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_resultado_id  uuid;
    v_estudio_id    uuid;
BEGIN
    SELECT id INTO v_resultado_id FROM resultado WHERE procesamiento_id = NEW.id;
    IF v_resultado_id IS NULL THEN
        RETURN NEW;   -- sin resultado todavía, nada que revalidar
    END IF;

    SELECT estudio_id INTO v_estudio_id FROM detalle_solicitud WHERE id = NEW.detalle_solicitud_id;
    PERFORM fn_validar_resultado_contra_estudio(v_resultado_id, v_estudio_id);
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_reasignacion_procesamiento() IS 'Impide reasignar procesamiento.detalle_solicitud_id a otro estudio si su resultado ya tiene valores capturados.';

CREATE TRIGGER trg_validar_reasignacion_procesamiento
    BEFORE UPDATE OF detalle_solicitud_id ON procesamiento
    FOR EACH ROW
    WHEN (OLD.detalle_solicitud_id IS DISTINCT FROM NEW.detalle_solicitud_id)
    EXECUTE FUNCTION fn_validar_reasignacion_procesamiento();

-- -----------------------------------------------------------------------------
-- 11. trg_validar_reasignacion_resultado
--     BEFORE UPDATE OF procesamiento_id en resultado: si el resultado ya
--     tiene valores capturados, el nuevo procesamiento_id debe apuntar al
--     mismo estudio que esos valores. Simétrico al trigger 10, para el otro
--     lado de la relación 1:1 resultado-procesamiento.
-- -----------------------------------------------------------------------------
CREATE FUNCTION fn_validar_reasignacion_resultado()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = lis, pg_temp
AS $$
DECLARE
    v_estudio_id  uuid;
BEGIN
    SELECT ds.estudio_id INTO v_estudio_id
    FROM procesamiento p
    JOIN detalle_solicitud ds ON ds.id = p.detalle_solicitud_id
    WHERE p.id = NEW.procesamiento_id;

    PERFORM fn_validar_resultado_contra_estudio(NEW.id, v_estudio_id);
    RETURN NEW;
END
$$;
COMMENT ON FUNCTION fn_validar_reasignacion_resultado() IS 'Impide reasignar resultado.procesamiento_id a un procesamiento de otro estudio si el resultado ya tiene valores capturados.';

CREATE TRIGGER trg_validar_reasignacion_resultado
    BEFORE UPDATE OF procesamiento_id ON resultado
    FOR EACH ROW
    WHEN (OLD.procesamiento_id IS DISTINCT FROM NEW.procesamiento_id)
    EXECUTE FUNCTION fn_validar_reasignacion_resultado();

COMMIT;

-- DOWN ------------------------------------------------------------------------
-- DROP TRIGGER trg_validar_reasignacion_resultado     ON resultado;
-- DROP TRIGGER trg_validar_reasignacion_procesamiento ON procesamiento;
-- DROP FUNCTION fn_validar_reasignacion_resultado(), fn_validar_reasignacion_procesamiento(),
--   fn_validar_resultado_contra_estudio(uuid, uuid);
-- DROP TRIGGER trg_validar_parametro_resultado ON resultado_valor;
-- DROP FUNCTION fn_validar_parametro_resultado();
-- DROP TRIGGER trg_copiar_numero_repeticion_muestra ON muestra_detalle_solicitud;
-- DROP TRIGGER trg_descartar_muestra_cancelada ON detalle_solicitud;
-- DROP TRIGGER trg_cancelar_detalle_cuenta     ON detalle_solicitud;
-- DROP TRIGGER trg_validar_saldo_pago          ON pago;
-- DROP TRIGGER trg_recalcular_cuenta           ON pago;
-- DROP TRIGGER trg_recalcular_cuenta           ON detalle_cuenta;
-- DROP TRIGGER trg_historial_resultado         ON resultado_valor;
-- DROP TRIGGER trg_bloquear_equipo_no_operativo ON procesamiento;
-- DROP TRIGGER trg_estado_global_solicitud     ON detalle_solicitud;
-- DROP FUNCTION fn_copiar_numero_repeticion_muestra(),
--   fn_descartar_muestra_cancelada(), fn_cancelar_detalle_cuenta(),
--   fn_validar_saldo_pago(), fn_recalcular_cuenta(), fn_recalcular_totales_cuenta(uuid),
--   fn_historial_resultado(), fn_bloquear_equipo_no_operativo(), fn_estado_global_solicitud();
