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
