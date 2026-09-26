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
