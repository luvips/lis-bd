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
