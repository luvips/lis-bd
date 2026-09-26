-- =============================================================================
-- LIS Laboratorio Clínico — Seed 1: Catálogo (datos maestros)
-- Depende de: esquema completo (sql/schema.sql o sql/00_setup.sql..07_triggers.sql)
-- Se ejecuta como lis_admin (dueño del esquema): valor_referencia,
-- parametro_estudio, estudio, equipo, etc. son catálogo — ningún rol de
-- aplicación (sql/09_roles.sql) tiene INSERT ahí, solo SELECT.
--
-- No se referencia ningún UUID a mano: cada INSERT que necesita el id de
-- una fila creada antes la busca por su clave natural (codigo, cedula,
-- curp, numero_empleado, numero_serie) con una subconsulta. Así el archivo
-- se lee como catálogo real, no como una lista de UUID sin contexto, y se
-- puede reordenar o ampliar sin recalcular ids.
--
-- Contenido: 10 estudios (con sus analitos y rangos), 3 paquetes, 5
-- equipos, 8 personal, 6 médicos, 15 pacientes (con antecedentes en 5 de
-- ellos). Sin datos transaccionales (eso va en 02_demo_transacciones.sql).
--
-- Uso:
--   docker compose -f docker/docker-compose.yml --env-file .env exec -T db \
--     psql -U lis_admin -d lis_laboratorio -v ON_ERROR_STOP=1 < seed/01_catalogo.sql
--   (o make seed)
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;  -- falla si no se está en la base del LIS

-- -----------------------------------------------------------------------------
-- 1. EQUIPO
-- -----------------------------------------------------------------------------
INSERT INTO equipo (numero_serie, nombre_modelo, fabricante, ubicacion, fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento) VALUES
    ('SYS-XN550-001', 'Sysmex XN-550',            'Sysmex',     'Área de Hematología',    CURRENT_DATE - 60, CURRENT_DATE + 120),
    ('ROC-C311-002',  'Cobas c311',                'Roche',      'Área de Química Clínica', CURRENT_DATE - 45, CURRENT_DATE + 135),
    ('ROC-E411-003',  'Cobas e411',                'Roche',      'Área de Inmunología',    CURRENT_DATE - 30, CURRENT_DATE + 150),
    ('URI-CL500-004', 'Urisys Combilyzer CL-500',  'Roche',      'Área de Uroanálisis',    CURRENT_DATE - 90, CURRENT_DATE + 90),
    ('MIC-INC200-005','Incubadora Micro-200',      'Binder',     'Área de Microbiología',  CURRENT_DATE - 20, CURRENT_DATE + 160);

-- -----------------------------------------------------------------------------
-- 2. ESTUDIO + ESTUDIO_TIPO_MUESTRA + PARAMETRO_ESTUDIO + VALOR_REFERENCIA
-- -----------------------------------------------------------------------------
INSERT INTO estudio (codigo, nombre, categoria, descripcion, tiempo_procesamiento_estimado, requiere_ayuno, precio) VALUES
    ('BH',       'Biometría Hemática Completa',              'Hematologia',     'Serie roja, blanca y plaquetas.',                            '45 minutes',  FALSE, 180.00),
    ('QS6',      'Química Sanguínea de 6 Elementos',         'Quimica_Clinica', 'Glucosa, urea, creatinina, ácido úrico, colesterol, triglicéridos.', '1 hour', TRUE,  220.00),
    ('LIP',      'Perfil de Lípidos',                        'Quimica_Clinica', 'Colesterol total, triglicéridos, HDL, LDL, VLDL.',           '1 hour',      TRUE,  240.00),
    ('EGO',      'Examen General de Orina',                  'Uroanalisis',     'Físico, químico y sedimento urinario.',                      '30 minutes',  FALSE, 120.00),
    ('TIROIDES', 'Perfil Tiroideo',                          'Endocrinologia',  'TSH, T3 libre y T4 libre.',                                  '2 hours',     FALSE, 380.00),
    ('GSRH',     'Grupo Sanguíneo y Factor Rh',               'Hematologia',     'Tipificación ABO y Rh.',                                     '20 minutes',  FALSE, 100.00),
    ('PCR',      'Proteína C Reactiva',                      'Inmunologia',     'Marcador cuantitativo de inflamación.',                      '1 hour',      FALSE, 210.00),
    ('COPRO',    'Coprológico',                              'Microbiologia',   'Examen general de heces.',                                   '1 hour',      FALSE, 150.00),
    ('CULT',     'Cultivo de Exudado Faríngeo con Antibiograma', 'Microbiologia', 'Identificación bacteriana y sensibilidad a antibióticos.', '3 days',      FALSE, 450.00),
    ('HBA1C',    'Hemoglobina Glucosilada',                  'Quimica_Clinica', 'Control glucémico de los últimos 2-3 meses.',                '1 hour',      FALSE, 280.00);

INSERT INTO estudio_tipo_muestra (estudio_id, tipo_muestra, es_preferida)
SELECT id, v.tipo_muestra, v.es_preferida
FROM estudio, LATERAL (VALUES
    ('BH',       'sangre_venosa'::tipo_muestra, TRUE),
    ('QS6',      'sangre_venosa',               TRUE),
    ('QS6',      'sangre_capilar',              FALSE),
    ('LIP',      'sangre_venosa',               TRUE),
    ('EGO',      'orina',                       TRUE),
    ('TIROIDES', 'sangre_venosa',               TRUE),
    ('GSRH',     'sangre_venosa',               TRUE),
    ('PCR',      'sangre_venosa',               TRUE),
    ('COPRO',    'heces',                       TRUE),
    ('CULT',     'otro',                        TRUE),
    ('HBA1C',    'sangre_venosa',               TRUE)
) AS v(codigo, tipo_muestra, es_preferida)
WHERE estudio.codigo = v.codigo;

-- Un parámetro por analito. orden = posición en el reporte impreso.
INSERT INTO parametro_estudio (estudio_id, nombre, unidad_medida, orden)
SELECT id, v.nombre, v.unidad_medida, v.orden
FROM estudio, LATERAL (VALUES
    -- BH
    ('BH', 'Hemoglobina', 'g/dL',      1),
    ('BH', 'Hematocrito', '%',         2),
    ('BH', 'Eritrocitos', 'x10^6/uL',  3),
    ('BH', 'Leucocitos',  'x10^3/uL',  4),
    ('BH', 'Plaquetas',   'x10^3/uL',  5),
    -- QS6
    ('QS6', 'Glucosa',          'mg/dL', 1),
    ('QS6', 'Urea',             'mg/dL', 2),
    ('QS6', 'Creatinina',       'mg/dL', 3),
    ('QS6', 'Ácido Úrico',      'mg/dL', 4),
    ('QS6', 'Colesterol Total', 'mg/dL', 5),
    ('QS6', 'Triglicéridos',    'mg/dL', 6),
    -- LIP
    ('LIP', 'Colesterol Total', 'mg/dL', 1),
    ('LIP', 'Triglicéridos',    'mg/dL', 2),
    ('LIP', 'HDL',              'mg/dL', 3),
    ('LIP', 'LDL',              'mg/dL', 4),
    ('LIP', 'VLDL',             'mg/dL', 5),
    -- EGO (cualitativos sin unidad, salvo pH y densidad)
    ('EGO', 'Color',      NULL,   1),
    ('EGO', 'Aspecto',    NULL,   2),
    ('EGO', 'pH',         NULL,   3),
    ('EGO', 'Densidad',   NULL,   4),
    ('EGO', 'Proteínas',  NULL,   5),
    ('EGO', 'Glucosa',    NULL,   6),
    ('EGO', 'Cetonas',    NULL,   7),
    ('EGO', 'Sangre',     NULL,   8),
    -- TIROIDES
    ('TIROIDES', 'TSH',     'uUI/mL', 1),
    ('TIROIDES', 'T3 Libre','pg/mL',  2),
    ('TIROIDES', 'T4 Libre','ng/dL',  3),
    -- GSRH (cualitativos)
    ('GSRH', 'Grupo ABO',  NULL, 1),
    ('GSRH', 'Factor Rh',  NULL, 2),
    -- PCR
    ('PCR', 'Proteína C Reactiva', 'mg/L', 1),
    -- COPRO (cualitativos)
    ('COPRO', 'Consistencia',   NULL, 1),
    ('COPRO', 'Moco',           NULL, 2),
    ('COPRO', 'Sangre Oculta',  NULL, 3),
    ('COPRO', 'Parásitos',      NULL, 4),
    -- CULT: identificación + antibiograma (cualitativos S/I/R)
    ('CULT', 'Identificación',                          NULL, 1),
    ('CULT', 'Penicilina',                               NULL, 2),
    ('CULT', 'Amoxicilina/Ácido Clavulánico',            NULL, 3),
    ('CULT', 'Eritromicina',                             NULL, 4),
    ('CULT', 'Clindamicina',                             NULL, 5),
    ('CULT', 'Vancomicina',                               NULL, 6),
    -- HBA1C
    ('HBA1C', 'Hemoglobina Glucosilada', '%', 1)
) AS v(codigo, nombre, unidad_medida, orden)
WHERE estudio.codigo = v.codigo;

-- Rangos de referencia. Solo se listan los analitos cuantitativos; los
-- cualitativos (Color, Grupo ABO, antibiograma...) se interpretan por
-- catálogo de valores en la aplicación y no llevan valor_referencia
-- (resultado_valor.valor_referencia_id es nullable justo por esto).
INSERT INTO valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo, sexo_aplicable, edad_minima, edad_maxima)
SELECT pe.id, v.valor_minimo, v.valor_maximo, v.sexo_aplicable, v.edad_minima, v.edad_maxima
FROM parametro_estudio pe
JOIN estudio e ON e.id = pe.estudio_id
JOIN LATERAL (VALUES
    ('BH', 'Hemoglobina', 13.5::numeric, 17.5::numeric, 'M'::sexo_biologico, NULL::smallint, NULL::smallint),
    ('BH', 'Hemoglobina', 12.0, 16.0, 'F', NULL, NULL),
    ('BH', 'Hematocrito', 41, 53, 'M', NULL, NULL),
    ('BH', 'Hematocrito', 36, 46, 'F', NULL, NULL),
    ('BH', 'Eritrocitos', 4.5, 5.9, 'M', NULL, NULL),
    ('BH', 'Eritrocitos', 4.0, 5.2, 'F', NULL, NULL),
    ('BH', 'Leucocitos',  4.5, 11.0, NULL, NULL, NULL),
    ('BH', 'Plaquetas',   150, 450, NULL, NULL, NULL),
    ('QS6', 'Glucosa',     70, 100, NULL, NULL, NULL),
    ('QS6', 'Urea',        10, 50, NULL, NULL, NULL),
    ('QS6', 'Creatinina',  0.7, 1.3, 'M', NULL, NULL),
    ('QS6', 'Creatinina',  0.6, 1.1, 'F', NULL, NULL),
    ('QS6', 'Ácido Úrico', 3.4, 7.0, 'M', NULL, NULL),
    ('QS6', 'Ácido Úrico', 2.4, 6.0, 'F', NULL, NULL),
    -- Colesterol Total de QS6: rango pediátrico y de adulto, para mostrar
    -- el uso de edad_minima/edad_maxima (no se traslapan: 0-18 vs 19+).
    ('QS6', 'Colesterol Total', NULL, 170, NULL, NULL, 18),
    ('QS6', 'Colesterol Total', NULL, 200, NULL, 19,   NULL),
    ('QS6', 'Triglicéridos', NULL, 150, NULL, NULL, NULL),
    ('LIP', 'Colesterol Total', NULL, 200, NULL, NULL, NULL),
    ('LIP', 'Triglicéridos',    NULL, 150, NULL, NULL, NULL),
    ('LIP', 'HDL', 40, NULL, 'M', NULL, NULL),
    ('LIP', 'HDL', 50, NULL, 'F', NULL, NULL),
    ('LIP', 'LDL', NULL, 130, NULL, NULL, NULL),
    ('LIP', 'VLDL', NULL, 30, NULL, NULL, NULL),
    ('EGO', 'pH',       4.5, 8.0, NULL, NULL, NULL),
    ('EGO', 'Densidad', 1.005, 1.030, NULL, NULL, NULL),
    ('TIROIDES', 'TSH',      0.4, 4.0, NULL, NULL, NULL),
    ('TIROIDES', 'T3 Libre', 2.3, 4.2, NULL, NULL, NULL),
    ('TIROIDES', 'T4 Libre', 0.8, 1.8, NULL, NULL, NULL),
    ('PCR', 'Proteína C Reactiva', NULL, 10, NULL, NULL, NULL),
    ('HBA1C', 'Hemoglobina Glucosilada', NULL, 5.7, NULL, NULL, NULL)
) AS v(codigo, nombre, valor_minimo, valor_maximo, sexo_aplicable, edad_minima, edad_maxima)
    ON e.codigo = v.codigo AND pe.nombre = v.nombre;

-- -----------------------------------------------------------------------------
-- 3. ESTUDIO_EQUIPO — qué equipo procesa cada estudio
-- -----------------------------------------------------------------------------
INSERT INTO estudio_equipo (estudio_id, equipo_id, es_equipo_primario)
SELECT e.id, eq.id, TRUE
FROM estudio e
JOIN LATERAL (VALUES
    ('BH',       'SYS-XN550-001'),
    ('QS6',      'ROC-C311-002'),
    ('LIP',      'ROC-C311-002'),
    ('EGO',      'URI-CL500-004'),
    ('TIROIDES', 'ROC-E411-003'),
    ('GSRH',     'SYS-XN550-001'),
    ('PCR',      'ROC-E411-003'),
    ('COPRO',    'MIC-INC200-005'),
    ('CULT',     'MIC-INC200-005'),
    ('HBA1C',    'ROC-C311-002')
) AS v(codigo, numero_serie) ON e.codigo = v.codigo
JOIN equipo eq ON eq.numero_serie = v.numero_serie;

-- -----------------------------------------------------------------------------
-- 4. PAQUETE + PAQUETE_ESTUDIO
-- -----------------------------------------------------------------------------
INSERT INTO paquete (codigo, nombre, descripcion, precio_paquete) VALUES
    ('PKG-EJECUTIVO', 'Check-up Ejecutivo',           'Biometría, química, lípidos, orina y grupo sanguíneo.', 650.00),
    ('PKG-PRENATAL',  'Perfil Prenatal Básico',       'Biometría, química, grupo sanguíneo y orina.',          580.00),
    ('PKG-METABOLICO','Chequeo Tiroideo y Metabólico','Tiroides, química de 6 elementos y hemoglobina glucosilada.', 750.00);

INSERT INTO paquete_estudio (paquete_id, estudio_id)
SELECT p.id, e.id
FROM paquete p
JOIN LATERAL (VALUES
    ('PKG-EJECUTIVO', 'BH'), ('PKG-EJECUTIVO', 'QS6'), ('PKG-EJECUTIVO', 'LIP'),
    ('PKG-EJECUTIVO', 'EGO'), ('PKG-EJECUTIVO', 'GSRH'),
    ('PKG-PRENATAL', 'BH'), ('PKG-PRENATAL', 'QS6'), ('PKG-PRENATAL', 'GSRH'), ('PKG-PRENATAL', 'EGO'),
    ('PKG-METABOLICO', 'TIROIDES'), ('PKG-METABOLICO', 'QS6'), ('PKG-METABOLICO', 'HBA1C')
) AS v(codigo_paquete, codigo_estudio) ON p.codigo = v.codigo_paquete
JOIN estudio e ON e.codigo = v.codigo_estudio;

-- -----------------------------------------------------------------------------
-- 5. PERSONAL
-- -----------------------------------------------------------------------------
INSERT INTO personal (numero_empleado, nombre, apellido_paterno, apellido_materno, rol) VALUES
    ('EMP-001', 'Diana',    'Reyes',    'Molina',   'flebotomista'),
    ('EMP-002', 'Jorge',    'Salinas',  'Puente',   'flebotomista'),
    ('EMP-003', 'Mariana',  'Fuentes',  'Arce',     'flebotomista'),
    ('EMP-004', 'Héctor',   'Cabrera',  'Núñez',    'tecnico_laboratorio'),
    ('EMP-005', 'Paola',    'Estrada',  'Vidal',    'tecnico_laboratorio'),
    ('EMP-006', 'Iván',     'Marín',    'Solórzano','tecnico_laboratorio'),
    ('EMP-007', 'Gabriela', 'Ochoa',    'Terán',    'supervisor'),
    ('EMP-008', 'Raúl',     'Peña',     'Ibarra',   'supervisor');

-- -----------------------------------------------------------------------------
-- 6. MEDICO
-- -----------------------------------------------------------------------------
INSERT INTO medico (cedula_profesional, nombre, apellido_paterno, apellido_materno, especialidad, institucion) VALUES
    ('CED-1023456', 'Luis',     'Camacho', 'Rivas',    'Medicina General',   'Consultorio Camacho'),
    ('CED-1034567', 'Verónica', 'Aguilar', 'Soto',     'Ginecología',        'Hospital San Rafael'),
    ('CED-1045678', 'Andrés',   'Becerra', 'Luna',     'Endocrinología',     'Clínica Endocrina del Valle'),
    ('CED-1056789', 'Fernanda', 'Rosales', 'Cordero',  'Pediatría',          'Hospital Infantil'),
    ('CED-1067890', 'Ricardo',  'Villegas','Paredes',  'Medicina Interna',   NULL),
    ('CED-1078901', 'Claudia',  'Serrano', 'Mendieta', NULL,                 'Consultorio particular');

-- -----------------------------------------------------------------------------
-- 7. PACIENTE + ANTECEDENTE_PACIENTE
-- -----------------------------------------------------------------------------
INSERT INTO paciente (curp, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo_biologico, tipo_sanguineo, telefono, correo) VALUES
    ('ROMJ850312HDFMNS08', 'Javier',        'Romero',   'Nieves',    '1985-03-12', 'M', 'O+', '5512340001', 'javier.romero@example.com'),
    ('LOMA900718MDFPRR02', 'María',         'López',    'Prieto',    '1990-07-18', 'F', 'A+', '5512340002', 'maria.lopez@example.com'),
    ('HECA780425HDFRRN05', 'Carlos',        'Hernández','Arriaga',   '1978-04-25', 'M', 'B+', '5512340003', NULL),
    ('VASA020911MDFLNN01', 'Ana Sofía',     'Vázquez',  'Leyva',     '2002-09-11', 'F', 'O-', '5512340004', 'anasofia.vazquez@example.com'),
    ('OGDL650130HDFRRS09', 'Luis',          'Ogarrio',  'Delgado',   '1965-01-30', 'M', 'AB+','5512340005', NULL),
    ('CUTG991005MDFRRD07', 'Guadalupe',     'Curiel',   'Torres',    '1999-10-05', 'F', 'A-', '5512340006', 'guadalupe.curiel@example.com'),
    ('SAMR120814HDFLRC02', 'Ricardo',       'Salas',    'Montaño',   '2012-08-14', 'M', NULL, '5512340007', NULL),
    ('PECD880222MDFRRN04', 'Daniela',       'Pérez',    'Cordero',   '1988-02-22', 'F', 'B-', '5512340008', 'daniela.perez@example.com'),
    ('TOFR551120HDFRRL06', 'Rolando',       'Torres',   'Franco',    '1955-11-20', 'M', 'O+', '5512340009', NULL),
    ('MEGV931203MDFNLR03', 'Verónica',      'Mena',     'Guevara',   '1993-12-03', 'F', 'AB-','5512340010', 'veronica.mena@example.com'),
    ('BALD700617HDFRZN00', 'Daniel',        'Balderas', 'Loza',      '1970-06-17', 'M', 'A+', '5512340011', NULL),
    ('RIFN050228MDFVRT05', 'Fernanda',      'Rivas',    'Núñez',     '2005-02-28', 'F', 'O+', '5512340012', 'fernanda.rivas@example.com'),
    ('QUAJ821114HDFRLR08', 'Jorge',         'Quiroz',   'Alarcón',   '1982-11-14', 'M', 'B+', '5512340013', NULL),
    ('ESLM940509MDFTPR01', 'Miriam',        'Estrada',  'López',     '1994-05-09', 'F', 'A+', '5512340014', 'miriam.estrada@example.com'),
    ('CAMR630819HDFSRB07', 'Roberto',       'Casas',    'Mireles',   '1963-08-19', 'M', 'O-', '5512340015', NULL);

INSERT INTO antecedente_paciente (paciente_id, tipo, descripcion, fecha_diagnostico)
SELECT p.id, v.tipo, v.descripcion, v.fecha_diagnostico
FROM paciente p
JOIN LATERAL (VALUES
    ('ROMJ850312HDFMNS08', 'alergia'::tipo_antecedente,            'Penicilina', NULL::date),
    ('LOMA900718MDFPRR02', 'enfermedad_cronica'::tipo_antecedente, 'Hipotiroidismo', '2018-06-01'::date),
    ('HECA780425HDFRRN05', 'enfermedad_cronica'::tipo_antecedente, 'Diabetes tipo 2', '2015-02-10'::date),
    ('HECA780425HDFRRN05', 'medicamento'::tipo_antecedente,        'Metformina 850mg', NULL),
    ('OGDL650130HDFRRS09', 'cirugia'::tipo_antecedente,            'Bypass gástrico (2019)', '2019-09-15'::date),
    ('TOFR551120HDFRRL06', 'heredofamiliar'::tipo_antecedente,     'Cardiopatía isquémica (padre)', NULL)
) AS v(curp, tipo, descripcion, fecha_diagnostico) ON p.curp = v.curp;

COMMIT;

-- Resumen esperado tras correr este archivo (0 filas transaccionales):
--   SELECT (SELECT count(*) FROM estudio) AS estudios,
--          (SELECT count(*) FROM parametro_estudio) AS parametros,
--          (SELECT count(*) FROM valor_referencia) AS rangos,
--          (SELECT count(*) FROM paquete) AS paquetes,
--          (SELECT count(*) FROM equipo) AS equipos,
--          (SELECT count(*) FROM personal) AS personal,
--          (SELECT count(*) FROM medico) AS medicos,
--          (SELECT count(*) FROM paciente) AS pacientes;
-- Esperado: 10, 39, 28, 3, 5, 8, 6, 15.
