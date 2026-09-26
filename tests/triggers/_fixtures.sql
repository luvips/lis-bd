-- =============================================================================
-- Datos mínimos de catálogo compartidos por las pruebas de triggers.
-- Se incluye con \ir después de BEGIN; todo se descarta con ROLLBACK.
-- UUID fijos para que cada prueba los referencie sin variables:
--   ...0001 paciente        ...0011 estudio BH (150.00)
--   ...0002 medico          ...0012 estudio glucosa (80.00)
--   ...0003 flebotomista    ...0013 estudio perfil lipídico (120.00)
--   ...0004 técnico         ...0021 paquete check-up (180.00) = glucosa + lípidos
--   ...0005 supervisor      ...0041/44 parámetros de BH (Hemoglobina, Leucocitos)
--   ...0006 equipo 1        ...0042/43 parámetros Glucosa / Colesterol
--   ...0007 equipo 2        ...0031/32/33/34 valores de referencia
--                           ...0101 solicitud (folio automático)
-- Los tres estudios aceptan sangre_venosa; glucosa acepta además sangre_capilar.
-- =============================================================================
\ir ../_helpers.sql

INSERT INTO paciente (id, curp, nombre, apellido_paterno, fecha_nacimiento, sexo_biologico)
VALUES ('00000000-0000-7000-8000-000000000001', 'PEGJ900101HCSRRN09', 'Juan', 'Pérez', '1990-01-01', 'M');

INSERT INTO medico (id, cedula_profesional, nombre, apellido_paterno)
VALUES ('00000000-0000-7000-8000-000000000002', 'CED-TEST-01', 'Ana', 'López');

INSERT INTO personal (id, numero_empleado, nombre, apellido_paterno, rol) VALUES
    ('00000000-0000-7000-8000-000000000003', 'EMP-T-01', 'Luis', 'Gómez',  'flebotomista'),
    ('00000000-0000-7000-8000-000000000004', 'EMP-T-02', 'Rosa', 'Díaz',   'tecnico_laboratorio'),
    ('00000000-0000-7000-8000-000000000005', 'EMP-T-03', 'Mario','Ruiz',   'supervisor');

INSERT INTO equipo (id, numero_serie, nombre_modelo) VALUES
    ('00000000-0000-7000-8000-000000000006', 'SN-T-01', 'Analizador Hematológico'),
    ('00000000-0000-7000-8000-000000000007', 'SN-T-02', 'Analizador Químico');

INSERT INTO estudio (id, codigo, nombre, categoria, precio) VALUES
    ('00000000-0000-7000-8000-000000000011', 'T-HEM-001', 'Biometría hemática', 'Hematologia',     150.00),
    ('00000000-0000-7000-8000-000000000012', 'T-QC-001',  'Glucosa',            'Quimica_Clinica',  80.00),
    ('00000000-0000-7000-8000-000000000013', 'T-QC-002',  'Perfil lipídico',    'Quimica_Clinica', 120.00);

INSERT INTO estudio_tipo_muestra (estudio_id, tipo_muestra, es_preferida) VALUES
    ('00000000-0000-7000-8000-000000000011', 'sangre_venosa',  TRUE),
    ('00000000-0000-7000-8000-000000000012', 'sangre_venosa',  TRUE),
    ('00000000-0000-7000-8000-000000000012', 'sangre_capilar', FALSE),
    ('00000000-0000-7000-8000-000000000013', 'sangre_venosa',  TRUE);

INSERT INTO parametro_estudio (id, estudio_id, nombre, unidad_medida, orden) VALUES
    ('00000000-0000-7000-8000-000000000041', '00000000-0000-7000-8000-000000000011', 'Hemoglobina', 'g/dL',     1),
    ('00000000-0000-7000-8000-000000000044', '00000000-0000-7000-8000-000000000011', 'Leucocitos',  'x10^3/uL', 2),
    ('00000000-0000-7000-8000-000000000042', '00000000-0000-7000-8000-000000000012', 'Glucosa',     'mg/dL',    1),
    ('00000000-0000-7000-8000-000000000043', '00000000-0000-7000-8000-000000000013', 'Colesterol',  'mg/dL',    1);

INSERT INTO paquete (id, codigo, nombre, precio_paquete)
VALUES ('00000000-0000-7000-8000-000000000021', 'T-PKG-01', 'Check-up Básico', 180.00);

INSERT INTO paquete_estudio (paquete_id, estudio_id) VALUES
    ('00000000-0000-7000-8000-000000000021', '00000000-0000-7000-8000-000000000012'),
    ('00000000-0000-7000-8000-000000000021', '00000000-0000-7000-8000-000000000013');

INSERT INTO valor_referencia (id, parametro_estudio_id, valor_minimo, valor_maximo) VALUES
    ('00000000-0000-7000-8000-000000000031', '00000000-0000-7000-8000-000000000041', 13.5, 17.5),
    ('00000000-0000-7000-8000-000000000034', '00000000-0000-7000-8000-000000000044', 4.5,  11.0),
    ('00000000-0000-7000-8000-000000000032', '00000000-0000-7000-8000-000000000042', 70,   100),
    ('00000000-0000-7000-8000-000000000033', '00000000-0000-7000-8000-000000000043', NULL, 200);

INSERT INTO estudio_equipo (estudio_id, equipo_id, es_equipo_primario) VALUES
    ('00000000-0000-7000-8000-000000000011', '00000000-0000-7000-8000-000000000006', TRUE),
    ('00000000-0000-7000-8000-000000000012', '00000000-0000-7000-8000-000000000007', TRUE);

INSERT INTO solicitud (id, paciente_id, medico_id)
VALUES ('00000000-0000-7000-8000-000000000101',
        '00000000-0000-7000-8000-000000000001',
        '00000000-0000-7000-8000-000000000002');
