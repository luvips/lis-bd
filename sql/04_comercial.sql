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
