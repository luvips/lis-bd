-- =============================================================================
-- LIS Laboratorio Clínico — Seed 3: Volumen inicial de operación
-- GENERADO por seed/generate_volumen.py --seed 42. No editar a mano:
-- regenerar con el mismo comando para reproducir exactamente este archivo.
-- 5000 pacientes, 50 médicos, 100 estudios sintéticos, 10 técnicos, 15 equipos.
-- Independiente de seed/01_catalogo.sql (prefijos VOL- en todos los códigos);
-- puede cargarse solo, antes o después. Se ejecuta como lis_admin.
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
BEGIN;
SET search_path = lis, public;
DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;

-- 15 equipos
INSERT INTO equipo (numero_serie, nombre_modelo, fabricante, ubicacion, fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento) VALUES
    ('VOL-EQ-001', 'Mindray Modelo-214', 'Mindray', 'Área de Hematología', '2026-03-20', '2027-01-04'),
    ('VOL-EQ-002', 'Sysmex Modelo-328', 'Sysmex', 'Área de Química Clínica', '2026-03-21', '2026-11-21'),
    ('VOL-EQ-003', 'Mindray Modelo-858', 'Mindray', 'Área de Microbiología', '2026-09-03', '2027-03-26'),
    ('VOL-EQ-004', 'Siemens Modelo-132', 'Siemens', 'Área de Hematología', '2026-09-02', '2026-12-20'),
    ('VOL-EQ-005', 'Sysmex Modelo-617', 'Sysmex', 'Área de Microbiología', '2026-09-19', '2027-03-18'),
    ('VOL-EQ-006', 'Sysmex Modelo-833', 'Sysmex', 'Almacén', '2026-03-30', '2027-03-14'),
    ('VOL-EQ-007', 'Siemens Modelo-325', 'Siemens', 'Área de Uroanálisis', '2026-04-28', '2027-01-05'),
    ('VOL-EQ-008', 'Binder Modelo-990', 'Binder', 'Área de Hematología', '2026-03-15', '2026-12-05'),
    ('VOL-EQ-009', 'Mindray Modelo-532', 'Mindray', 'Área de Inmunología', '2026-07-16', '2026-12-04'),
    ('VOL-EQ-010', 'Sysmex Modelo-881', 'Sysmex', 'Área de Inmunología', '2026-08-30', '2026-11-18'),
    ('VOL-EQ-011', 'Siemens Modelo-199', 'Siemens', 'Área de Inmunología', '2026-06-29', '2027-03-29'),
    ('VOL-EQ-012', 'Abbott Modelo-926', 'Abbott', 'Área de Hematología', '2026-03-23', '2027-02-20'),
    ('VOL-EQ-013', 'Beckman Coulter Modelo-227', 'Beckman Coulter', 'Área de Uroanálisis', '2026-09-05', '2027-03-16'),
    ('VOL-EQ-014', 'Abbott Modelo-949', 'Abbott', 'Almacén', '2026-04-20', '2027-01-26'),
    ('VOL-EQ-015', 'Beckman Coulter Modelo-296', 'Beckman Coulter', 'Almacén', '2026-09-08', '2026-11-06');

-- 50 médicos
INSERT INTO medico (cedula_profesional, nombre, apellido_paterno, apellido_materno, especialidad, institucion, telefono) VALUES
    ('VOL-MED-00001', 'Gerardo', 'Ortiz', 'Pérez', NULL, 'Centro Médico ABC', '5516475255'),
    ('VOL-MED-00002', 'Hugo', 'Díaz', 'Cordero', 'Medicina Interna', 'Clínica del Valle', '5583276483'),
    ('VOL-MED-00003', 'Leticia', 'Hernández', 'Jiménez', NULL, 'Consultorio particular', '5556413953'),
    ('VOL-MED-00004', 'Fernanda', 'Cordero', 'Contreras', 'Ginecología', 'IMSS', '5523884969'),
    ('VOL-MED-00005', 'Sofía', 'Jiménez', 'Ramírez', 'Gastroenterología', NULL, '5510122691'),
    ('VOL-MED-00006', 'Fernanda', 'Estrada', 'Contreras', 'Gastroenterología', 'IMSS', '5580184514'),
    ('VOL-MED-00007', 'Verónica', 'Contreras', 'García', 'Oncología', 'IMSS', '5582814893'),
    ('VOL-MED-00008', 'Eduardo', 'Flores', 'Fuentes', NULL, 'Consultorio particular', '5595701543'),
    ('VOL-MED-00009', 'Antonio', 'Cabrera', 'Pérez', 'Medicina Interna', NULL, '5518227824'),
    ('VOL-MED-00010', 'Claudia', 'Fuentes', 'Morales', 'Oncología', 'IMSS', '5565787133'),
    ('VOL-MED-00011', 'Ricardo', 'Martínez', 'Delgado', 'Gastroenterología', 'Centro Médico ABC', '5593010310'),
    ('VOL-MED-00012', 'Ana', 'Medina', 'Reyes', 'Endocrinología', NULL, '5538299737'),
    ('VOL-MED-00013', 'Claudia', 'Rodríguez', 'Rodríguez', 'Geriatría', NULL, '5556670106'),
    ('VOL-MED-00014', 'Carmen', 'Rodríguez', 'Reyes', 'Pediatría', 'Centro Médico ABC', '5587262473'),
    ('VOL-MED-00015', 'Sergio', 'Salazar', 'Rodríguez', 'Medicina General', 'Consultorio particular', '5513267736'),
    ('VOL-MED-00016', 'Jorge', 'Aguilar', 'García', 'Nefrología', 'IMSS', '5574687234'),
    ('VOL-MED-00017', 'Juan', 'Delgado', 'Fuentes', 'Medicina General', 'ISSSTE', '5500978820'),
    ('VOL-MED-00018', 'Diego', 'Gómez', 'González', 'Dermatología', 'Hospital General', '5536193990'),
    ('VOL-MED-00019', 'Fernando', 'Delgado', 'Cabrera', 'Gastroenterología', 'ISSSTE', '5543534624'),
    ('VOL-MED-00020', 'Alejandra', 'González', 'García', 'Reumatología', 'Hospital General', '5518384251'),
    ('VOL-MED-00021', 'Eduardo', 'Ortiz', 'Flores', 'Reumatología', 'IMSS', '5598084124'),
    ('VOL-MED-00022', 'Mario', 'Rodríguez', 'Salazar', 'Ginecología', 'IMSS', '5549353487'),
    ('VOL-MED-00023', 'Araceli', 'Hernández', 'Pérez', 'Geriatría', NULL, '5540052427'),
    ('VOL-MED-00024', 'Elena', 'García', 'Sánchez', 'Medicina Interna', 'Clínica del Valle', '5580598262'),
    ('VOL-MED-00025', 'Manuel', 'Mendoza', 'López', 'Cardiología', 'Centro Médico ABC', '5531586923'),
    ('VOL-MED-00026', 'Pablo', 'Gómez', 'Romero', 'Medicina General', 'Clínica del Valle', '5556342160'),
    ('VOL-MED-00027', 'Adriana', 'Morales', 'Contreras', 'Cardiología', 'IMSS', '5533036541'),
    ('VOL-MED-00028', 'Sofía', 'Cordero', 'Medina', 'Nefrología', 'ISSSTE', '5501429401'),
    ('VOL-MED-00029', 'Sofía', 'Chávez', 'Alvarado', 'Dermatología', 'Hospital General', '5569340608'),
    ('VOL-MED-00030', 'Eduardo', 'Alvarado', 'González', 'Geriatría', 'ISSSTE', '5595148465'),
    ('VOL-MED-00031', 'Miriam', 'Ortiz', 'Salazar', 'Ginecología', 'Centro Médico ABC', '5566299468'),
    ('VOL-MED-00032', 'Manuel', 'Ortiz', 'Vázquez', 'Nefrología', 'ISSSTE', '5577738721'),
    ('VOL-MED-00033', 'Rosa', 'Solís', 'Peña', 'Cardiología', 'Hospital General', '5534332003'),
    ('VOL-MED-00034', 'Teresa', 'González', 'Contreras', 'Nefrología', 'Centro Médico ABC', '5567632016'),
    ('VOL-MED-00035', 'Jorge', 'Herrera', 'Contreras', 'Medicina General', 'Centro Médico ABC', '5517278895'),
    ('VOL-MED-00036', 'Teresa', 'Medina', 'Alvarado', NULL, NULL, '5527743487'),
    ('VOL-MED-00037', 'Alejandro', 'Vargas', 'González', 'Oncología', 'IMSS', '5534558122'),
    ('VOL-MED-00038', 'Roberto', 'Cruz', 'Vázquez', 'Medicina Interna', NULL, '5565876036'),
    ('VOL-MED-00039', 'Araceli', 'Delgado', 'Martínez', NULL, NULL, '5570546688'),
    ('VOL-MED-00040', 'Raúl', 'Jiménez', 'Díaz', 'Nefrología', NULL, '5506562729'),
    ('VOL-MED-00041', 'Adrián', 'Castillo', 'Delgado', 'Dermatología', 'Consultorio particular', '5516272046'),
    ('VOL-MED-00042', 'Claudia', 'Contreras', 'Chávez', 'Cardiología', NULL, '5546417080'),
    ('VOL-MED-00043', 'Adriana', 'Cordero', 'González', NULL, 'Consultorio particular', '5503309232'),
    ('VOL-MED-00044', 'Lucía', 'Sánchez', 'Cabrera', 'Pediatría', NULL, '5545299124'),
    ('VOL-MED-00045', 'Daniel', 'Martínez', 'Gutiérrez', 'Dermatología', NULL, '5563193149'),
    ('VOL-MED-00046', 'Pablo', 'Cabrera', 'López', 'Cardiología', NULL, '5551850671'),
    ('VOL-MED-00047', 'Sofía', 'Solís', 'Contreras', 'Oncología', 'Clínica del Valle', '5562849877'),
    ('VOL-MED-00048', 'Leticia', 'Delgado', 'Díaz', 'Cardiología', 'Centro Médico ABC', '5514737996'),
    ('VOL-MED-00049', 'María', 'Rojas', 'Chávez', 'Ginecología', NULL, '5535454948'),
    ('VOL-MED-00050', 'Arturo', 'Morales', 'Pérez', 'Pediatría', NULL, '5578377701');

-- 10 técnicos de laboratorio
INSERT INTO personal (numero_empleado, nombre, apellido_paterno, apellido_materno, rol) VALUES
    ('VOL-TEC-001', 'Adriana', 'Castillo', 'Reyes', 'tecnico_laboratorio'),
    ('VOL-TEC-002', 'Lucía', 'Delgado', 'Mendoza', 'tecnico_laboratorio'),
    ('VOL-TEC-003', 'Elena', 'Herrera', 'Ruiz', 'tecnico_laboratorio'),
    ('VOL-TEC-004', 'Diana', 'Salazar', 'Ramos', 'tecnico_laboratorio'),
    ('VOL-TEC-005', 'Miriam', 'Contreras', 'Díaz', 'tecnico_laboratorio'),
    ('VOL-TEC-006', 'Mónica', 'Jiménez', 'Sánchez', 'tecnico_laboratorio'),
    ('VOL-TEC-007', 'Ricardo', 'Sánchez', 'Fuentes', 'tecnico_laboratorio'),
    ('VOL-TEC-008', 'Francisco', 'Vázquez', 'Guzmán', 'tecnico_laboratorio'),
    ('VOL-TEC-009', 'Diana', 'Delgado', 'Herrera', 'tecnico_laboratorio'),
    ('VOL-TEC-010', 'Laura', 'Morales', 'Ortiz', 'tecnico_laboratorio');

-- 100 estudios sintéticos (catálogo real: seed/01_catalogo.sql)
INSERT INTO estudio (codigo, nombre, categoria, tiempo_procesamiento_estimado, requiere_ayuno, precio) VALUES
    ('VOL-001', 'Estudio Sintético Quimica Clinica #001', 'Quimica_Clinica'::categoria_estudio, '45 minutes', TRUE, 87.36),
    ('VOL-002', 'Estudio Sintético Quimica Clinica #002', 'Quimica_Clinica'::categoria_estudio, '45 minutes', TRUE, 108.35),
    ('VOL-003', 'Estudio Sintético Uroanalisis #003', 'Uroanalisis'::categoria_estudio, '30 minutes', FALSE, 471.45),
    ('VOL-004', 'Estudio Sintético Hematologia #004', 'Hematologia'::categoria_estudio, '90 minutes', FALSE, 328.93),
    ('VOL-005', 'Estudio Sintético Quimica Clinica #005', 'Quimica_Clinica'::categoria_estudio, '20 minutes', FALSE, 528.1),
    ('VOL-006', 'Estudio Sintético Hematologia #006', 'Hematologia'::categoria_estudio, '60 minutes', FALSE, 380.05),
    ('VOL-007', 'Estudio Sintético Hematologia #007', 'Hematologia'::categoria_estudio, '30 minutes', TRUE, 372.68),
    ('VOL-008', 'Estudio Sintético Hematologia #008', 'Hematologia'::categoria_estudio, '30 minutes', TRUE, 477.51),
    ('VOL-009', 'Estudio Sintético Endocrinologia #009', 'Endocrinologia'::categoria_estudio, '90 minutes', FALSE, 351.74),
    ('VOL-010', 'Estudio Sintético Inmunologia #010', 'Inmunologia'::categoria_estudio, '45 minutes', FALSE, 594.82),
    ('VOL-011', 'Estudio Sintético Endocrinologia #011', 'Endocrinologia'::categoria_estudio, '90 minutes', TRUE, 579.26),
    ('VOL-012', 'Estudio Sintético Quimica Clinica #012', 'Quimica_Clinica'::categoria_estudio, '120 minutes', FALSE, 423.42),
    ('VOL-013', 'Estudio Sintético Quimica Clinica #013', 'Quimica_Clinica'::categoria_estudio, '30 minutes', FALSE, 161.4),
    ('VOL-014', 'Estudio Sintético Inmunologia #014', 'Inmunologia'::categoria_estudio, '120 minutes', FALSE, 231.45),
    ('VOL-015', 'Estudio Sintético Microbiologia #015', 'Microbiologia'::categoria_estudio, '120 minutes', FALSE, 527.0),
    ('VOL-016', 'Estudio Sintético Uroanalisis #016', 'Uroanalisis'::categoria_estudio, '30 minutes', FALSE, 489.67),
    ('VOL-017', 'Estudio Sintético Endocrinologia #017', 'Endocrinologia'::categoria_estudio, '120 minutes', FALSE, 182.87),
    ('VOL-018', 'Estudio Sintético Endocrinologia #018', 'Endocrinologia'::categoria_estudio, '30 minutes', FALSE, 552.37),
    ('VOL-019', 'Estudio Sintético Hematologia #019', 'Hematologia'::categoria_estudio, '20 minutes', TRUE, 239.96),
    ('VOL-020', 'Estudio Sintético Endocrinologia #020', 'Endocrinologia'::categoria_estudio, '45 minutes', FALSE, 323.72),
    ('VOL-021', 'Estudio Sintético Uroanalisis #021', 'Uroanalisis'::categoria_estudio, '60 minutes', FALSE, 340.25),
    ('VOL-022', 'Estudio Sintético Inmunologia #022', 'Inmunologia'::categoria_estudio, '20 minutes', FALSE, 542.5),
    ('VOL-023', 'Estudio Sintético Microbiologia #023', 'Microbiologia'::categoria_estudio, '90 minutes', FALSE, 127.49),
    ('VOL-024', 'Estudio Sintético Endocrinologia #024', 'Endocrinologia'::categoria_estudio, '90 minutes', FALSE, 599.78),
    ('VOL-025', 'Estudio Sintético Microbiologia #025', 'Microbiologia'::categoria_estudio, '90 minutes', TRUE, 473.26),
    ('VOL-026', 'Estudio Sintético Endocrinologia #026', 'Endocrinologia'::categoria_estudio, '120 minutes', FALSE, 224.64),
    ('VOL-027', 'Estudio Sintético Inmunologia #027', 'Inmunologia'::categoria_estudio, '120 minutes', FALSE, 583.91),
    ('VOL-028', 'Estudio Sintético Microbiologia #028', 'Microbiologia'::categoria_estudio, '60 minutes', FALSE, 428.47),
    ('VOL-029', 'Estudio Sintético Microbiologia #029', 'Microbiologia'::categoria_estudio, '60 minutes', FALSE, 229.87),
    ('VOL-030', 'Estudio Sintético Endocrinologia #030', 'Endocrinologia'::categoria_estudio, '20 minutes', FALSE, 243.55),
    ('VOL-031', 'Estudio Sintético Hematologia #031', 'Hematologia'::categoria_estudio, '60 minutes', FALSE, 508.96),
    ('VOL-032', 'Estudio Sintético Uroanalisis #032', 'Uroanalisis'::categoria_estudio, '90 minutes', FALSE, 108.19),
    ('VOL-033', 'Estudio Sintético Microbiologia #033', 'Microbiologia'::categoria_estudio, '90 minutes', FALSE, 405.21),
    ('VOL-034', 'Estudio Sintético Quimica Clinica #034', 'Quimica_Clinica'::categoria_estudio, '45 minutes', FALSE, 562.39),
    ('VOL-035', 'Estudio Sintético Uroanalisis #035', 'Uroanalisis'::categoria_estudio, '60 minutes', TRUE, 586.04),
    ('VOL-036', 'Estudio Sintético Quimica Clinica #036', 'Quimica_Clinica'::categoria_estudio, '120 minutes', TRUE, 366.44),
    ('VOL-037', 'Estudio Sintético Inmunologia #037', 'Inmunologia'::categoria_estudio, '20 minutes', FALSE, 517.53),
    ('VOL-038', 'Estudio Sintético Inmunologia #038', 'Inmunologia'::categoria_estudio, '20 minutes', FALSE, 160.06),
    ('VOL-039', 'Estudio Sintético Microbiologia #039', 'Microbiologia'::categoria_estudio, '90 minutes', FALSE, 296.05),
    ('VOL-040', 'Estudio Sintético Inmunologia #040', 'Inmunologia'::categoria_estudio, '30 minutes', FALSE, 155.21),
    ('VOL-041', 'Estudio Sintético Endocrinologia #041', 'Endocrinologia'::categoria_estudio, '90 minutes', FALSE, 150.98),
    ('VOL-042', 'Estudio Sintético Microbiologia #042', 'Microbiologia'::categoria_estudio, '60 minutes', FALSE, 489.61),
    ('VOL-043', 'Estudio Sintético Hematologia #043', 'Hematologia'::categoria_estudio, '45 minutes', FALSE, 515.49),
    ('VOL-044', 'Estudio Sintético Uroanalisis #044', 'Uroanalisis'::categoria_estudio, '60 minutes', FALSE, 312.2),
    ('VOL-045', 'Estudio Sintético Microbiologia #045', 'Microbiologia'::categoria_estudio, '45 minutes', FALSE, 362.58),
    ('VOL-046', 'Estudio Sintético Microbiologia #046', 'Microbiologia'::categoria_estudio, '30 minutes', FALSE, 204.18),
    ('VOL-047', 'Estudio Sintético Quimica Clinica #047', 'Quimica_Clinica'::categoria_estudio, '60 minutes', TRUE, 467.25),
    ('VOL-048', 'Estudio Sintético Inmunologia #048', 'Inmunologia'::categoria_estudio, '60 minutes', FALSE, 492.04),
    ('VOL-049', 'Estudio Sintético Quimica Clinica #049', 'Quimica_Clinica'::categoria_estudio, '60 minutes', FALSE, 145.65),
    ('VOL-050', 'Estudio Sintético Microbiologia #050', 'Microbiologia'::categoria_estudio, '20 minutes', FALSE, 308.96),
    ('VOL-051', 'Estudio Sintético Inmunologia #051', 'Inmunologia'::categoria_estudio, '20 minutes', FALSE, 293.19),
    ('VOL-052', 'Estudio Sintético Quimica Clinica #052', 'Quimica_Clinica'::categoria_estudio, '20 minutes', FALSE, 583.99),
    ('VOL-053', 'Estudio Sintético Endocrinologia #053', 'Endocrinologia'::categoria_estudio, '120 minutes', FALSE, 121.76),
    ('VOL-054', 'Estudio Sintético Uroanalisis #054', 'Uroanalisis'::categoria_estudio, '90 minutes', FALSE, 244.66),
    ('VOL-055', 'Estudio Sintético Inmunologia #055', 'Inmunologia'::categoria_estudio, '90 minutes', TRUE, 115.58),
    ('VOL-056', 'Estudio Sintético Uroanalisis #056', 'Uroanalisis'::categoria_estudio, '45 minutes', FALSE, 468.32),
    ('VOL-057', 'Estudio Sintético Hematologia #057', 'Hematologia'::categoria_estudio, '120 minutes', FALSE, 132.26),
    ('VOL-058', 'Estudio Sintético Uroanalisis #058', 'Uroanalisis'::categoria_estudio, '45 minutes', FALSE, 103.92),
    ('VOL-059', 'Estudio Sintético Microbiologia #059', 'Microbiologia'::categoria_estudio, '45 minutes', FALSE, 155.7),
    ('VOL-060', 'Estudio Sintético Inmunologia #060', 'Inmunologia'::categoria_estudio, '90 minutes', FALSE, 173.63),
    ('VOL-061', 'Estudio Sintético Hematologia #061', 'Hematologia'::categoria_estudio, '90 minutes', FALSE, 402.25),
    ('VOL-062', 'Estudio Sintético Inmunologia #062', 'Inmunologia'::categoria_estudio, '90 minutes', TRUE, 319.8),
    ('VOL-063', 'Estudio Sintético Inmunologia #063', 'Inmunologia'::categoria_estudio, '45 minutes', FALSE, 547.43),
    ('VOL-064', 'Estudio Sintético Microbiologia #064', 'Microbiologia'::categoria_estudio, '120 minutes', FALSE, 118.41),
    ('VOL-065', 'Estudio Sintético Endocrinologia #065', 'Endocrinologia'::categoria_estudio, '45 minutes', FALSE, 300.64),
    ('VOL-066', 'Estudio Sintético Inmunologia #066', 'Inmunologia'::categoria_estudio, '45 minutes', TRUE, 280.04),
    ('VOL-067', 'Estudio Sintético Hematologia #067', 'Hematologia'::categoria_estudio, '30 minutes', FALSE, 266.66),
    ('VOL-068', 'Estudio Sintético Uroanalisis #068', 'Uroanalisis'::categoria_estudio, '45 minutes', TRUE, 511.62),
    ('VOL-069', 'Estudio Sintético Microbiologia #069', 'Microbiologia'::categoria_estudio, '20 minutes', FALSE, 436.62),
    ('VOL-070', 'Estudio Sintético Hematologia #070', 'Hematologia'::categoria_estudio, '90 minutes', FALSE, 513.08),
    ('VOL-071', 'Estudio Sintético Quimica Clinica #071', 'Quimica_Clinica'::categoria_estudio, '90 minutes', FALSE, 193.88),
    ('VOL-072', 'Estudio Sintético Endocrinologia #072', 'Endocrinologia'::categoria_estudio, '45 minutes', FALSE, 454.88),
    ('VOL-073', 'Estudio Sintético Uroanalisis #073', 'Uroanalisis'::categoria_estudio, '30 minutes', FALSE, 549.77),
    ('VOL-074', 'Estudio Sintético Hematologia #074', 'Hematologia'::categoria_estudio, '45 minutes', FALSE, 97.35),
    ('VOL-075', 'Estudio Sintético Uroanalisis #075', 'Uroanalisis'::categoria_estudio, '30 minutes', TRUE, 233.46),
    ('VOL-076', 'Estudio Sintético Inmunologia #076', 'Inmunologia'::categoria_estudio, '30 minutes', FALSE, 488.99),
    ('VOL-077', 'Estudio Sintético Endocrinologia #077', 'Endocrinologia'::categoria_estudio, '90 minutes', FALSE, 511.85),
    ('VOL-078', 'Estudio Sintético Inmunologia #078', 'Inmunologia'::categoria_estudio, '45 minutes', FALSE, 256.13),
    ('VOL-079', 'Estudio Sintético Inmunologia #079', 'Inmunologia'::categoria_estudio, '20 minutes', TRUE, 582.58),
    ('VOL-080', 'Estudio Sintético Uroanalisis #080', 'Uroanalisis'::categoria_estudio, '120 minutes', FALSE, 582.98),
    ('VOL-081', 'Estudio Sintético Microbiologia #081', 'Microbiologia'::categoria_estudio, '20 minutes', FALSE, 87.24),
    ('VOL-082', 'Estudio Sintético Hematologia #082', 'Hematologia'::categoria_estudio, '60 minutes', FALSE, 469.49),
    ('VOL-083', 'Estudio Sintético Endocrinologia #083', 'Endocrinologia'::categoria_estudio, '60 minutes', FALSE, 568.95),
    ('VOL-084', 'Estudio Sintético Uroanalisis #084', 'Uroanalisis'::categoria_estudio, '30 minutes', FALSE, 402.16),
    ('VOL-085', 'Estudio Sintético Microbiologia #085', 'Microbiologia'::categoria_estudio, '90 minutes', FALSE, 112.87),
    ('VOL-086', 'Estudio Sintético Uroanalisis #086', 'Uroanalisis'::categoria_estudio, '45 minutes', FALSE, 140.67),
    ('VOL-087', 'Estudio Sintético Hematologia #087', 'Hematologia'::categoria_estudio, '45 minutes', FALSE, 140.38),
    ('VOL-088', 'Estudio Sintético Endocrinologia #088', 'Endocrinologia'::categoria_estudio, '30 minutes', FALSE, 272.93),
    ('VOL-089', 'Estudio Sintético Uroanalisis #089', 'Uroanalisis'::categoria_estudio, '90 minutes', FALSE, 465.98),
    ('VOL-090', 'Estudio Sintético Inmunologia #090', 'Inmunologia'::categoria_estudio, '120 minutes', TRUE, 334.46),
    ('VOL-091', 'Estudio Sintético Microbiologia #091', 'Microbiologia'::categoria_estudio, '20 minutes', FALSE, 192.98),
    ('VOL-092', 'Estudio Sintético Quimica Clinica #092', 'Quimica_Clinica'::categoria_estudio, '45 minutes', TRUE, 436.55),
    ('VOL-093', 'Estudio Sintético Uroanalisis #093', 'Uroanalisis'::categoria_estudio, '45 minutes', TRUE, 223.46),
    ('VOL-094', 'Estudio Sintético Inmunologia #094', 'Inmunologia'::categoria_estudio, '20 minutes', FALSE, 413.69),
    ('VOL-095', 'Estudio Sintético Hematologia #095', 'Hematologia'::categoria_estudio, '20 minutes', FALSE, 206.66),
    ('VOL-096', 'Estudio Sintético Endocrinologia #096', 'Endocrinologia'::categoria_estudio, '30 minutes', TRUE, 477.88),
    ('VOL-097', 'Estudio Sintético Endocrinologia #097', 'Endocrinologia'::categoria_estudio, '30 minutes', FALSE, 201.16),
    ('VOL-098', 'Estudio Sintético Endocrinologia #098', 'Endocrinologia'::categoria_estudio, '20 minutes', FALSE, 591.69),
    ('VOL-099', 'Estudio Sintético Endocrinologia #099', 'Endocrinologia'::categoria_estudio, '45 minutes', FALSE, 137.16),
    ('VOL-100', 'Estudio Sintético Quimica Clinica #100', 'Quimica_Clinica'::categoria_estudio, '20 minutes', FALSE, 489.98);

-- Un tipo de muestra aceptado por estudio
INSERT INTO estudio_tipo_muestra (estudio_id, tipo_muestra, es_preferida)
SELECT e.id, v.tipo_muestra, TRUE FROM estudio e
JOIN (VALUES
    ('VOL-001', 'orina'::tipo_muestra),
    ('VOL-002', 'sangre_venosa'::tipo_muestra),
    ('VOL-003', 'sangre_capilar'::tipo_muestra),
    ('VOL-004', 'orina'::tipo_muestra),
    ('VOL-005', 'sangre_venosa'::tipo_muestra),
    ('VOL-006', 'sangre_capilar'::tipo_muestra),
    ('VOL-007', 'tejido'::tipo_muestra),
    ('VOL-008', 'heces'::tipo_muestra),
    ('VOL-009', 'esputo'::tipo_muestra),
    ('VOL-010', 'sangre_venosa'::tipo_muestra),
    ('VOL-011', 'tejido'::tipo_muestra),
    ('VOL-012', 'sangre_venosa'::tipo_muestra),
    ('VOL-013', 'heces'::tipo_muestra),
    ('VOL-014', 'heces'::tipo_muestra),
    ('VOL-015', 'otro'::tipo_muestra),
    ('VOL-016', 'orina'::tipo_muestra),
    ('VOL-017', 'esputo'::tipo_muestra),
    ('VOL-018', 'esputo'::tipo_muestra),
    ('VOL-019', 'sangre_venosa'::tipo_muestra),
    ('VOL-020', 'heces'::tipo_muestra),
    ('VOL-021', 'esputo'::tipo_muestra),
    ('VOL-022', 'sangre_capilar'::tipo_muestra),
    ('VOL-023', 'esputo'::tipo_muestra),
    ('VOL-024', 'sangre_venosa'::tipo_muestra),
    ('VOL-025', 'tejido'::tipo_muestra),
    ('VOL-026', 'otro'::tipo_muestra),
    ('VOL-027', 'otro'::tipo_muestra),
    ('VOL-028', 'tejido'::tipo_muestra),
    ('VOL-029', 'esputo'::tipo_muestra),
    ('VOL-030', 'orina'::tipo_muestra),
    ('VOL-031', 'heces'::tipo_muestra),
    ('VOL-032', 'tejido'::tipo_muestra),
    ('VOL-033', 'sangre_venosa'::tipo_muestra),
    ('VOL-034', 'sangre_venosa'::tipo_muestra),
    ('VOL-035', 'heces'::tipo_muestra),
    ('VOL-036', 'otro'::tipo_muestra),
    ('VOL-037', 'heces'::tipo_muestra),
    ('VOL-038', 'heces'::tipo_muestra),
    ('VOL-039', 'tejido'::tipo_muestra),
    ('VOL-040', 'sangre_venosa'::tipo_muestra),
    ('VOL-041', 'heces'::tipo_muestra),
    ('VOL-042', 'tejido'::tipo_muestra),
    ('VOL-043', 'heces'::tipo_muestra),
    ('VOL-044', 'sangre_venosa'::tipo_muestra),
    ('VOL-045', 'sangre_venosa'::tipo_muestra),
    ('VOL-046', 'orina'::tipo_muestra),
    ('VOL-047', 'esputo'::tipo_muestra),
    ('VOL-048', 'sangre_capilar'::tipo_muestra),
    ('VOL-049', 'sangre_venosa'::tipo_muestra),
    ('VOL-050', 'sangre_capilar'::tipo_muestra),
    ('VOL-051', 'orina'::tipo_muestra),
    ('VOL-052', 'esputo'::tipo_muestra),
    ('VOL-053', 'tejido'::tipo_muestra),
    ('VOL-054', 'esputo'::tipo_muestra),
    ('VOL-055', 'esputo'::tipo_muestra),
    ('VOL-056', 'tejido'::tipo_muestra),
    ('VOL-057', 'orina'::tipo_muestra),
    ('VOL-058', 'heces'::tipo_muestra),
    ('VOL-059', 'esputo'::tipo_muestra),
    ('VOL-060', 'esputo'::tipo_muestra),
    ('VOL-061', 'orina'::tipo_muestra),
    ('VOL-062', 'heces'::tipo_muestra),
    ('VOL-063', 'esputo'::tipo_muestra),
    ('VOL-064', 'esputo'::tipo_muestra),
    ('VOL-065', 'heces'::tipo_muestra),
    ('VOL-066', 'sangre_venosa'::tipo_muestra),
    ('VOL-067', 'otro'::tipo_muestra),
    ('VOL-068', 'tejido'::tipo_muestra),
    ('VOL-069', 'sangre_venosa'::tipo_muestra),
    ('VOL-070', 'otro'::tipo_muestra),
    ('VOL-071', 'tejido'::tipo_muestra),
    ('VOL-072', 'tejido'::tipo_muestra),
    ('VOL-073', 'otro'::tipo_muestra),
    ('VOL-074', 'esputo'::tipo_muestra),
    ('VOL-075', 'tejido'::tipo_muestra),
    ('VOL-076', 'otro'::tipo_muestra),
    ('VOL-077', 'sangre_capilar'::tipo_muestra),
    ('VOL-078', 'heces'::tipo_muestra),
    ('VOL-079', 'heces'::tipo_muestra),
    ('VOL-080', 'sangre_capilar'::tipo_muestra),
    ('VOL-081', 'heces'::tipo_muestra),
    ('VOL-082', 'orina'::tipo_muestra),
    ('VOL-083', 'otro'::tipo_muestra),
    ('VOL-084', 'heces'::tipo_muestra),
    ('VOL-085', 'heces'::tipo_muestra),
    ('VOL-086', 'heces'::tipo_muestra),
    ('VOL-087', 'tejido'::tipo_muestra),
    ('VOL-088', 'sangre_venosa'::tipo_muestra),
    ('VOL-089', 'orina'::tipo_muestra),
    ('VOL-090', 'heces'::tipo_muestra),
    ('VOL-091', 'orina'::tipo_muestra),
    ('VOL-092', 'tejido'::tipo_muestra),
    ('VOL-093', 'orina'::tipo_muestra),
    ('VOL-094', 'orina'::tipo_muestra),
    ('VOL-095', 'sangre_capilar'::tipo_muestra),
    ('VOL-096', 'tejido'::tipo_muestra),
    ('VOL-097', 'heces'::tipo_muestra),
    ('VOL-098', 'sangre_venosa'::tipo_muestra),
    ('VOL-099', 'sangre_venosa'::tipo_muestra),
    ('VOL-100', 'otro'::tipo_muestra)
) AS v(codigo, tipo_muestra) ON e.codigo = v.codigo;

-- 1 equipo por estudio (de los generados arriba)
INSERT INTO estudio_equipo (estudio_id, equipo_id, es_equipo_primario)
SELECT e.id, eq.id, TRUE FROM estudio e
JOIN (VALUES
    ('VOL-001', 'VOL-EQ-002'),
    ('VOL-002', 'VOL-EQ-002'),
    ('VOL-003', 'VOL-EQ-007'),
    ('VOL-004', 'VOL-EQ-002'),
    ('VOL-005', 'VOL-EQ-012'),
    ('VOL-006', 'VOL-EQ-012'),
    ('VOL-007', 'VOL-EQ-006'),
    ('VOL-008', 'VOL-EQ-013'),
    ('VOL-009', 'VOL-EQ-003'),
    ('VOL-010', 'VOL-EQ-009'),
    ('VOL-011', 'VOL-EQ-001'),
    ('VOL-012', 'VOL-EQ-010'),
    ('VOL-013', 'VOL-EQ-009'),
    ('VOL-014', 'VOL-EQ-009'),
    ('VOL-015', 'VOL-EQ-006'),
    ('VOL-016', 'VOL-EQ-011'),
    ('VOL-017', 'VOL-EQ-002'),
    ('VOL-018', 'VOL-EQ-007'),
    ('VOL-019', 'VOL-EQ-006'),
    ('VOL-020', 'VOL-EQ-014'),
    ('VOL-021', 'VOL-EQ-011'),
    ('VOL-022', 'VOL-EQ-013'),
    ('VOL-023', 'VOL-EQ-007'),
    ('VOL-024', 'VOL-EQ-014'),
    ('VOL-025', 'VOL-EQ-015'),
    ('VOL-026', 'VOL-EQ-012'),
    ('VOL-027', 'VOL-EQ-001'),
    ('VOL-028', 'VOL-EQ-005'),
    ('VOL-029', 'VOL-EQ-010'),
    ('VOL-030', 'VOL-EQ-005'),
    ('VOL-031', 'VOL-EQ-006'),
    ('VOL-032', 'VOL-EQ-002'),
    ('VOL-033', 'VOL-EQ-010'),
    ('VOL-034', 'VOL-EQ-009'),
    ('VOL-035', 'VOL-EQ-004'),
    ('VOL-036', 'VOL-EQ-003'),
    ('VOL-037', 'VOL-EQ-011'),
    ('VOL-038', 'VOL-EQ-008'),
    ('VOL-039', 'VOL-EQ-004'),
    ('VOL-040', 'VOL-EQ-014'),
    ('VOL-041', 'VOL-EQ-002'),
    ('VOL-042', 'VOL-EQ-006'),
    ('VOL-043', 'VOL-EQ-014'),
    ('VOL-044', 'VOL-EQ-009'),
    ('VOL-045', 'VOL-EQ-006'),
    ('VOL-046', 'VOL-EQ-002'),
    ('VOL-047', 'VOL-EQ-013'),
    ('VOL-048', 'VOL-EQ-005'),
    ('VOL-049', 'VOL-EQ-010'),
    ('VOL-050', 'VOL-EQ-004'),
    ('VOL-051', 'VOL-EQ-013'),
    ('VOL-052', 'VOL-EQ-007'),
    ('VOL-053', 'VOL-EQ-014'),
    ('VOL-054', 'VOL-EQ-009'),
    ('VOL-055', 'VOL-EQ-013'),
    ('VOL-056', 'VOL-EQ-014'),
    ('VOL-057', 'VOL-EQ-010'),
    ('VOL-058', 'VOL-EQ-010'),
    ('VOL-059', 'VOL-EQ-011'),
    ('VOL-060', 'VOL-EQ-011'),
    ('VOL-061', 'VOL-EQ-009'),
    ('VOL-062', 'VOL-EQ-001'),
    ('VOL-063', 'VOL-EQ-010'),
    ('VOL-064', 'VOL-EQ-015'),
    ('VOL-065', 'VOL-EQ-011'),
    ('VOL-066', 'VOL-EQ-014'),
    ('VOL-067', 'VOL-EQ-012'),
    ('VOL-068', 'VOL-EQ-005'),
    ('VOL-069', 'VOL-EQ-001'),
    ('VOL-070', 'VOL-EQ-003'),
    ('VOL-071', 'VOL-EQ-005'),
    ('VOL-072', 'VOL-EQ-012'),
    ('VOL-073', 'VOL-EQ-013'),
    ('VOL-074', 'VOL-EQ-005'),
    ('VOL-075', 'VOL-EQ-015'),
    ('VOL-076', 'VOL-EQ-006'),
    ('VOL-077', 'VOL-EQ-006'),
    ('VOL-078', 'VOL-EQ-001'),
    ('VOL-079', 'VOL-EQ-003'),
    ('VOL-080', 'VOL-EQ-014'),
    ('VOL-081', 'VOL-EQ-003'),
    ('VOL-082', 'VOL-EQ-010'),
    ('VOL-083', 'VOL-EQ-011'),
    ('VOL-084', 'VOL-EQ-007'),
    ('VOL-085', 'VOL-EQ-002'),
    ('VOL-086', 'VOL-EQ-003'),
    ('VOL-087', 'VOL-EQ-012'),
    ('VOL-088', 'VOL-EQ-011'),
    ('VOL-089', 'VOL-EQ-001'),
    ('VOL-090', 'VOL-EQ-002'),
    ('VOL-091', 'VOL-EQ-012'),
    ('VOL-092', 'VOL-EQ-009'),
    ('VOL-093', 'VOL-EQ-004'),
    ('VOL-094', 'VOL-EQ-007'),
    ('VOL-095', 'VOL-EQ-007'),
    ('VOL-096', 'VOL-EQ-008'),
    ('VOL-097', 'VOL-EQ-006'),
    ('VOL-098', 'VOL-EQ-003'),
    ('VOL-099', 'VOL-EQ-006'),
    ('VOL-100', 'VOL-EQ-005')
) AS v(codigo, numero_serie) ON e.codigo = v.codigo
JOIN equipo eq ON eq.numero_serie = v.numero_serie;

-- 1-3 analitos genéricos por estudio, con un rango de referencia numérico
INSERT INTO parametro_estudio (estudio_id, nombre, unidad_medida, orden)
SELECT e.id, v.nombre, v.unidad, v.orden FROM estudio e
JOIN (VALUES
    ('VOL-001', 'Analito 1', '%', 1),
    ('VOL-001', 'Analito 2', 'g/dL', 2),
    ('VOL-001', 'Analito 3', 'mg/dL', 3),
    ('VOL-002', 'Analito 1', 'U/L', 1),
    ('VOL-002', 'Analito 2', 'U/L', 2),
    ('VOL-003', 'Analito 1', 'mg/dL', 1),
    ('VOL-004', 'Analito 1', 'g/dL', 1),
    ('VOL-004', 'Analito 2', 'ng/mL', 2),
    ('VOL-005', 'Analito 1', 'mmol/L', 1),
    ('VOL-006', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-006', 'Analito 2', 'mmol/L', 2),
    ('VOL-006', 'Analito 3', 'mmol/L', 3),
    ('VOL-007', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-007', 'Analito 2', 'ng/mL', 2),
    ('VOL-008', 'Analito 1', 'mIU/mL', 1),
    ('VOL-008', 'Analito 2', 'g/dL', 2),
    ('VOL-008', 'Analito 3', '%', 3),
    ('VOL-009', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-009', 'Analito 2', 'g/dL', 2),
    ('VOL-010', 'Analito 1', 'ng/mL', 1),
    ('VOL-010', 'Analito 2', 'mmol/L', 2),
    ('VOL-011', 'Analito 1', 'ng/mL', 1),
    ('VOL-012', 'Analito 1', 'mg/dL', 1),
    ('VOL-013', 'Analito 1', 'mIU/mL', 1),
    ('VOL-013', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-014', 'Analito 1', 'mg/dL', 1),
    ('VOL-015', 'Analito 1', 'mg/dL', 1),
    ('VOL-016', 'Analito 1', 'mIU/mL', 1),
    ('VOL-016', 'Analito 2', 'ng/mL', 2),
    ('VOL-016', 'Analito 3', 'mIU/mL', 3),
    ('VOL-017', 'Analito 1', 'U/L', 1),
    ('VOL-018', 'Analito 1', 'ng/mL', 1),
    ('VOL-019', 'Analito 1', 'ng/mL', 1),
    ('VOL-019', 'Analito 2', '%', 2),
    ('VOL-019', 'Analito 3', 'g/dL', 3),
    ('VOL-020', 'Analito 1', 'mg/dL', 1),
    ('VOL-020', 'Analito 2', 'mmol/L', 2),
    ('VOL-021', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-021', 'Analito 2', 'U/L', 2),
    ('VOL-022', 'Analito 1', 'U/L', 1),
    ('VOL-022', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-022', 'Analito 3', 'mIU/mL', 3),
    ('VOL-023', 'Analito 1', '%', 1),
    ('VOL-023', 'Analito 2', 'g/dL', 2),
    ('VOL-023', 'Analito 3', 'x10^3/uL', 3),
    ('VOL-024', 'Analito 1', 'mg/dL', 1),
    ('VOL-024', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-024', 'Analito 3', 'mg/dL', 3),
    ('VOL-025', 'Analito 1', 'mmol/L', 1),
    ('VOL-025', 'Analito 2', 'g/dL', 2),
    ('VOL-026', 'Analito 1', '%', 1),
    ('VOL-026', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-026', 'Analito 3', 'x10^3/uL', 3),
    ('VOL-027', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-027', 'Analito 2', 'ng/mL', 2),
    ('VOL-028', 'Analito 1', 'g/dL', 1),
    ('VOL-029', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-029', 'Analito 2', 'mg/dL', 2),
    ('VOL-030', 'Analito 1', '%', 1),
    ('VOL-030', 'Analito 2', 'U/L', 2),
    ('VOL-031', 'Analito 1', 'mmol/L', 1),
    ('VOL-032', 'Analito 1', '%', 1),
    ('VOL-032', 'Analito 2', 'g/dL', 2),
    ('VOL-032', 'Analito 3', 'x10^3/uL', 3),
    ('VOL-033', 'Analito 1', 'g/dL', 1),
    ('VOL-034', 'Analito 1', 'mIU/mL', 1),
    ('VOL-034', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-035', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-035', 'Analito 2', 'g/dL', 2),
    ('VOL-035', 'Analito 3', 'x10^3/uL', 3),
    ('VOL-036', 'Analito 1', 'ng/mL', 1),
    ('VOL-036', 'Analito 2', '%', 2),
    ('VOL-036', 'Analito 3', 'mIU/mL', 3),
    ('VOL-037', 'Analito 1', '%', 1),
    ('VOL-038', 'Analito 1', 'U/L', 1),
    ('VOL-038', 'Analito 2', 'g/dL', 2),
    ('VOL-038', 'Analito 3', 'g/dL', 3),
    ('VOL-039', 'Analito 1', 'mIU/mL', 1),
    ('VOL-039', 'Analito 2', '%', 2),
    ('VOL-040', 'Analito 1', '%', 1),
    ('VOL-041', 'Analito 1', 'U/L', 1),
    ('VOL-042', 'Analito 1', 'mIU/mL', 1),
    ('VOL-042', 'Analito 2', 'g/dL', 2),
    ('VOL-043', 'Analito 1', 'U/L', 1),
    ('VOL-043', 'Analito 2', 'ng/mL', 2),
    ('VOL-043', 'Analito 3', 'mIU/mL', 3),
    ('VOL-044', 'Analito 1', 'U/L', 1),
    ('VOL-044', 'Analito 2', 'U/L', 2),
    ('VOL-045', 'Analito 1', 'g/dL', 1),
    ('VOL-045', 'Analito 2', 'U/L', 2),
    ('VOL-046', 'Analito 1', 'mmol/L', 1),
    ('VOL-046', 'Analito 2', 'mmol/L', 2),
    ('VOL-047', 'Analito 1', 'mmol/L', 1),
    ('VOL-047', 'Analito 2', '%', 2),
    ('VOL-047', 'Analito 3', '%', 3),
    ('VOL-048', 'Analito 1', 'U/L', 1),
    ('VOL-048', 'Analito 2', 'mmol/L', 2),
    ('VOL-048', 'Analito 3', 'g/dL', 3),
    ('VOL-049', 'Analito 1', 'mmol/L', 1),
    ('VOL-049', 'Analito 2', 'mmol/L', 2),
    ('VOL-049', 'Analito 3', 'ng/mL', 3),
    ('VOL-050', 'Analito 1', 'ng/mL', 1),
    ('VOL-050', 'Analito 2', 'mg/dL', 2),
    ('VOL-050', 'Analito 3', '%', 3),
    ('VOL-051', 'Analito 1', 'g/dL', 1),
    ('VOL-051', 'Analito 2', 'ng/mL', 2),
    ('VOL-051', 'Analito 3', 'mmol/L', 3),
    ('VOL-052', 'Analito 1', 'mmol/L', 1),
    ('VOL-052', 'Analito 2', 'mg/dL', 2),
    ('VOL-053', 'Analito 1', 'mg/dL', 1),
    ('VOL-053', 'Analito 2', '%', 2),
    ('VOL-054', 'Analito 1', 'ng/mL', 1),
    ('VOL-054', 'Analito 2', 'g/dL', 2),
    ('VOL-054', 'Analito 3', 'g/dL', 3),
    ('VOL-055', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-055', 'Analito 2', 'mmol/L', 2),
    ('VOL-055', 'Analito 3', 'mg/dL', 3),
    ('VOL-056', 'Analito 1', 'mmol/L', 1),
    ('VOL-056', 'Analito 2', 'mIU/mL', 2),
    ('VOL-057', 'Analito 1', '%', 1),
    ('VOL-058', 'Analito 1', 'mmol/L', 1),
    ('VOL-059', 'Analito 1', 'U/L', 1),
    ('VOL-059', 'Analito 2', 'mg/dL', 2),
    ('VOL-059', 'Analito 3', 'mmol/L', 3),
    ('VOL-060', 'Analito 1', 'g/dL', 1),
    ('VOL-061', 'Analito 1', '%', 1),
    ('VOL-062', 'Analito 1', 'g/dL', 1),
    ('VOL-062', 'Analito 2', 'U/L', 2),
    ('VOL-063', 'Analito 1', 'mg/dL', 1),
    ('VOL-063', 'Analito 2', 'mIU/mL', 2),
    ('VOL-064', 'Analito 1', 'mmol/L', 1),
    ('VOL-064', 'Analito 2', 'mmol/L', 2),
    ('VOL-065', 'Analito 1', 'U/L', 1),
    ('VOL-065', 'Analito 2', '%', 2),
    ('VOL-066', 'Analito 1', '%', 1),
    ('VOL-066', 'Analito 2', 'ng/mL', 2),
    ('VOL-067', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-067', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-068', 'Analito 1', '%', 1),
    ('VOL-068', 'Analito 2', 'mg/dL', 2),
    ('VOL-069', 'Analito 1', '%', 1),
    ('VOL-069', 'Analito 2', 'g/dL', 2),
    ('VOL-069', 'Analito 3', '%', 3),
    ('VOL-070', 'Analito 1', 'g/dL', 1),
    ('VOL-070', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-071', 'Analito 1', 'ng/mL', 1),
    ('VOL-072', 'Analito 1', 'ng/mL', 1),
    ('VOL-072', 'Analito 2', 'U/L', 2),
    ('VOL-072', 'Analito 3', '%', 3),
    ('VOL-073', 'Analito 1', 'g/dL', 1),
    ('VOL-073', 'Analito 2', 'U/L', 2),
    ('VOL-073', 'Analito 3', '%', 3),
    ('VOL-074', 'Analito 1', 'ng/mL', 1),
    ('VOL-074', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-075', 'Analito 1', 'U/L', 1),
    ('VOL-075', 'Analito 2', 'g/dL', 2),
    ('VOL-075', 'Analito 3', 'ng/mL', 3),
    ('VOL-076', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-076', 'Analito 2', '%', 2),
    ('VOL-077', 'Analito 1', 'U/L', 1),
    ('VOL-077', 'Analito 2', 'g/dL', 2),
    ('VOL-078', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-079', 'Analito 1', '%', 1),
    ('VOL-079', 'Analito 2', 'mg/dL', 2),
    ('VOL-079', 'Analito 3', '%', 3),
    ('VOL-080', 'Analito 1', 'ng/mL', 1),
    ('VOL-080', 'Analito 2', 'U/L', 2),
    ('VOL-080', 'Analito 3', 'mIU/mL', 3),
    ('VOL-081', 'Analito 1', '%', 1),
    ('VOL-081', 'Analito 2', 'mmol/L', 2),
    ('VOL-081', 'Analito 3', 'mIU/mL', 3),
    ('VOL-082', 'Analito 1', 'mIU/mL', 1),
    ('VOL-082', 'Analito 2', 'U/L', 2),
    ('VOL-083', 'Analito 1', 'U/L', 1),
    ('VOL-084', 'Analito 1', 'g/dL', 1),
    ('VOL-084', 'Analito 2', 'ng/mL', 2),
    ('VOL-084', 'Analito 3', 'g/dL', 3),
    ('VOL-085', 'Analito 1', 'mg/dL', 1),
    ('VOL-085', 'Analito 2', '%', 2),
    ('VOL-086', 'Analito 1', 'U/L', 1),
    ('VOL-087', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-088', 'Analito 1', 'U/L', 1),
    ('VOL-088', 'Analito 2', 'U/L', 2),
    ('VOL-088', 'Analito 3', 'U/L', 3),
    ('VOL-089', 'Analito 1', 'U/L', 1),
    ('VOL-090', 'Analito 1', 'mmol/L', 1),
    ('VOL-090', 'Analito 2', 'mg/dL', 2),
    ('VOL-091', 'Analito 1', 'x10^3/uL', 1),
    ('VOL-091', 'Analito 2', '%', 2),
    ('VOL-092', 'Analito 1', 'mIU/mL', 1),
    ('VOL-092', 'Analito 2', 'mmol/L', 2),
    ('VOL-092', 'Analito 3', 'ng/mL', 3),
    ('VOL-093', 'Analito 1', 'mmol/L', 1),
    ('VOL-094', 'Analito 1', 'mIU/mL', 1),
    ('VOL-094', 'Analito 2', 'mIU/mL', 2),
    ('VOL-094', 'Analito 3', 'ng/mL', 3),
    ('VOL-095', 'Analito 1', 'mmol/L', 1),
    ('VOL-096', 'Analito 1', 'mIU/mL', 1),
    ('VOL-097', 'Analito 1', '%', 1),
    ('VOL-098', 'Analito 1', 'mmol/L', 1),
    ('VOL-099', 'Analito 1', 'mmol/L', 1),
    ('VOL-100', 'Analito 1', 'ng/mL', 1),
    ('VOL-100', 'Analito 2', 'x10^3/uL', 2),
    ('VOL-100', 'Analito 3', 'x10^3/uL', 3)
) AS v(codigo, nombre, unidad, orden) ON e.codigo = v.codigo;

INSERT INTO valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo)
SELECT pe.id, v.minimo, v.maximo
FROM parametro_estudio pe JOIN estudio e ON e.id = pe.estudio_id
JOIN (VALUES
    ('VOL-001', 'Analito 1', 48.3, 131.8),
    ('VOL-001', 'Analito 2', 40.1, 62.6),
    ('VOL-001', 'Analito 3', 12.5, 80.2),
    ('VOL-002', 'Analito 1', 43.7, 103.6),
    ('VOL-002', 'Analito 2', 5.1, 91.2),
    ('VOL-003', 'Analito 1', 42.6, 78.3),
    ('VOL-004', 'Analito 1', 38.2, 72.8),
    ('VOL-004', 'Analito 2', 45.3, 68.6),
    ('VOL-005', 'Analito 1', 21.9, 117.1),
    ('VOL-006', 'Analito 1', 11.1, 61.7),
    ('VOL-006', 'Analito 2', 17.5, 29.9),
    ('VOL-006', 'Analito 3', 2.7, 57.9),
    ('VOL-007', 'Analito 1', 11.8, 111.3),
    ('VOL-007', 'Analito 2', 18.7, 31.2),
    ('VOL-008', 'Analito 1', 46.5, 132.0),
    ('VOL-008', 'Analito 2', 32.5, 113.7),
    ('VOL-008', 'Analito 3', 6.9, 42.7),
    ('VOL-009', 'Analito 1', 41.5, 114.1),
    ('VOL-009', 'Analito 2', 6.9, 80.4),
    ('VOL-010', 'Analito 1', 22.4, 32.9),
    ('VOL-010', 'Analito 2', 4.0, 37.0),
    ('VOL-011', 'Analito 1', 41.7, 101.1),
    ('VOL-012', 'Analito 1', 36.4, 93.9),
    ('VOL-013', 'Analito 1', 5.6, 41.5),
    ('VOL-013', 'Analito 2', 15.1, 29.4),
    ('VOL-014', 'Analito 1', 21.0, 102.5),
    ('VOL-015', 'Analito 1', 22.9, 42.9),
    ('VOL-016', 'Analito 1', 45.3, 109.0),
    ('VOL-016', 'Analito 2', 0.8, 57.2),
    ('VOL-016', 'Analito 3', 12.1, 35.0),
    ('VOL-017', 'Analito 1', 21.5, 86.8),
    ('VOL-018', 'Analito 1', 12.0, 59.5),
    ('VOL-019', 'Analito 1', 33.2, 50.9),
    ('VOL-019', 'Analito 2', 48.7, 64.8),
    ('VOL-019', 'Analito 3', 26.3, 82.0),
    ('VOL-020', 'Analito 1', 49.4, 109.3),
    ('VOL-020', 'Analito 2', 19.5, 71.8),
    ('VOL-021', 'Analito 1', 31.8, 130.1),
    ('VOL-021', 'Analito 2', 12.7, 24.2),
    ('VOL-022', 'Analito 1', 39.4, 80.4),
    ('VOL-022', 'Analito 2', 36.6, 103.1),
    ('VOL-022', 'Analito 3', 38.6, 114.8),
    ('VOL-023', 'Analito 1', 16.6, 30.6),
    ('VOL-023', 'Analito 2', 27.3, 110.5),
    ('VOL-023', 'Analito 3', 8.8, 88.9),
    ('VOL-024', 'Analito 1', 23.2, 95.8),
    ('VOL-024', 'Analito 2', 31.6, 114.6),
    ('VOL-024', 'Analito 3', 3.2, 83.1),
    ('VOL-025', 'Analito 1', 22.9, 59.3),
    ('VOL-025', 'Analito 2', 2.2, 30.2),
    ('VOL-026', 'Analito 1', 2.1, 96.1),
    ('VOL-026', 'Analito 2', 25.8, 124.8),
    ('VOL-026', 'Analito 3', 27.2, 60.0),
    ('VOL-027', 'Analito 1', 37.7, 64.9),
    ('VOL-027', 'Analito 2', 17.8, 98.1),
    ('VOL-028', 'Analito 1', 43.3, 83.2),
    ('VOL-029', 'Analito 1', 6.2, 49.3),
    ('VOL-029', 'Analito 2', 44.5, 121.4),
    ('VOL-030', 'Analito 1', 44.7, 89.5),
    ('VOL-030', 'Analito 2', 48.7, 103.4),
    ('VOL-031', 'Analito 1', 24.9, 118.1),
    ('VOL-032', 'Analito 1', 26.0, 108.1),
    ('VOL-032', 'Analito 2', 36.4, 53.5),
    ('VOL-032', 'Analito 3', 30.1, 114.1),
    ('VOL-033', 'Analito 1', 27.3, 66.2),
    ('VOL-034', 'Analito 1', 4.0, 73.5),
    ('VOL-034', 'Analito 2', 15.3, 79.5),
    ('VOL-035', 'Analito 1', 21.3, 93.4),
    ('VOL-035', 'Analito 2', 17.6, 31.4),
    ('VOL-035', 'Analito 3', 43.5, 85.2),
    ('VOL-036', 'Analito 1', 49.9, 84.6),
    ('VOL-036', 'Analito 2', 49.0, 144.3),
    ('VOL-036', 'Analito 3', 3.8, 71.2),
    ('VOL-037', 'Analito 1', 18.2, 100.3),
    ('VOL-038', 'Analito 1', 34.0, 129.8),
    ('VOL-038', 'Analito 2', 7.1, 71.8),
    ('VOL-038', 'Analito 3', 39.1, 52.2),
    ('VOL-039', 'Analito 1', 3.4, 83.5),
    ('VOL-039', 'Analito 2', 18.3, 62.8),
    ('VOL-040', 'Analito 1', 28.4, 92.9),
    ('VOL-041', 'Analito 1', 34.0, 129.4),
    ('VOL-042', 'Analito 1', 18.6, 97.3),
    ('VOL-042', 'Analito 2', 28.7, 86.4),
    ('VOL-043', 'Analito 1', 19.9, 88.4),
    ('VOL-043', 'Analito 2', 12.5, 32.7),
    ('VOL-043', 'Analito 3', 36.8, 91.7),
    ('VOL-044', 'Analito 1', 19.3, 79.9),
    ('VOL-044', 'Analito 2', 13.1, 46.5),
    ('VOL-045', 'Analito 1', 22.3, 122.0),
    ('VOL-045', 'Analito 2', 14.3, 106.8),
    ('VOL-046', 'Analito 1', 24.6, 45.6),
    ('VOL-046', 'Analito 2', 42.6, 93.3),
    ('VOL-047', 'Analito 1', 44.9, 95.0),
    ('VOL-047', 'Analito 2', 4.4, 75.8),
    ('VOL-047', 'Analito 3', 42.3, 81.1),
    ('VOL-048', 'Analito 1', 17.4, 33.2),
    ('VOL-048', 'Analito 2', 27.1, 117.3),
    ('VOL-048', 'Analito 3', 42.6, 116.7),
    ('VOL-049', 'Analito 1', 46.4, 113.8),
    ('VOL-049', 'Analito 2', 39.7, 95.5),
    ('VOL-049', 'Analito 3', 6.1, 34.2),
    ('VOL-050', 'Analito 1', 6.9, 88.0),
    ('VOL-050', 'Analito 2', 1.3, 61.2),
    ('VOL-050', 'Analito 3', 18.4, 100.7),
    ('VOL-051', 'Analito 1', 27.6, 92.7),
    ('VOL-051', 'Analito 2', 4.3, 42.1),
    ('VOL-051', 'Analito 3', 50.0, 124.7),
    ('VOL-052', 'Analito 1', 26.3, 105.5),
    ('VOL-052', 'Analito 2', 41.2, 57.8),
    ('VOL-053', 'Analito 1', 48.6, 116.4),
    ('VOL-053', 'Analito 2', 22.5, 93.7),
    ('VOL-054', 'Analito 1', 17.2, 106.2),
    ('VOL-054', 'Analito 2', 39.0, 106.6),
    ('VOL-054', 'Analito 3', 9.1, 106.1),
    ('VOL-055', 'Analito 1', 21.6, 113.6),
    ('VOL-055', 'Analito 2', 2.8, 24.0),
    ('VOL-055', 'Analito 3', 7.7, 32.5),
    ('VOL-056', 'Analito 1', 16.1, 89.9),
    ('VOL-056', 'Analito 2', 17.3, 112.0),
    ('VOL-057', 'Analito 1', 44.7, 130.8),
    ('VOL-058', 'Analito 1', 12.5, 79.7),
    ('VOL-059', 'Analito 1', 27.5, 48.8),
    ('VOL-059', 'Analito 2', 15.1, 73.1),
    ('VOL-059', 'Analito 3', 25.1, 50.3),
    ('VOL-060', 'Analito 1', 47.1, 71.0),
    ('VOL-061', 'Analito 1', 32.9, 107.8),
    ('VOL-062', 'Analito 1', 30.3, 116.1),
    ('VOL-062', 'Analito 2', 28.2, 112.5),
    ('VOL-063', 'Analito 1', 1.4, 15.5),
    ('VOL-063', 'Analito 2', 32.1, 94.0),
    ('VOL-064', 'Analito 1', 32.6, 111.6),
    ('VOL-064', 'Analito 2', 20.8, 88.3),
    ('VOL-065', 'Analito 1', 24.9, 91.3),
    ('VOL-065', 'Analito 2', 14.5, 110.6),
    ('VOL-066', 'Analito 1', 24.1, 106.5),
    ('VOL-066', 'Analito 2', 34.2, 71.0),
    ('VOL-067', 'Analito 1', 3.6, 19.0),
    ('VOL-067', 'Analito 2', 22.0, 75.6),
    ('VOL-068', 'Analito 1', 10.2, 74.8),
    ('VOL-068', 'Analito 2', 15.6, 90.3),
    ('VOL-069', 'Analito 1', 36.7, 124.2),
    ('VOL-069', 'Analito 2', 48.8, 70.6),
    ('VOL-069', 'Analito 3', 18.5, 79.0),
    ('VOL-070', 'Analito 1', 16.0, 68.0),
    ('VOL-070', 'Analito 2', 13.4, 45.7),
    ('VOL-071', 'Analito 1', 4.8, 40.9),
    ('VOL-072', 'Analito 1', 19.2, 84.6),
    ('VOL-072', 'Analito 2', 12.4, 100.3),
    ('VOL-072', 'Analito 3', 8.0, 47.5),
    ('VOL-073', 'Analito 1', 28.9, 67.0),
    ('VOL-073', 'Analito 2', 38.2, 93.0),
    ('VOL-073', 'Analito 3', 25.7, 80.6),
    ('VOL-074', 'Analito 1', 15.4, 27.5),
    ('VOL-074', 'Analito 2', 47.3, 102.8),
    ('VOL-075', 'Analito 1', 48.3, 77.7),
    ('VOL-075', 'Analito 2', 17.6, 32.1),
    ('VOL-075', 'Analito 3', 24.7, 114.1),
    ('VOL-076', 'Analito 1', 32.7, 85.1),
    ('VOL-076', 'Analito 2', 26.8, 113.0),
    ('VOL-077', 'Analito 1', 21.5, 110.9),
    ('VOL-077', 'Analito 2', 36.4, 115.1),
    ('VOL-078', 'Analito 1', 18.3, 64.4),
    ('VOL-079', 'Analito 1', 28.5, 56.0),
    ('VOL-079', 'Analito 2', 27.7, 44.3),
    ('VOL-079', 'Analito 3', 25.2, 104.0),
    ('VOL-080', 'Analito 1', 14.0, 113.0),
    ('VOL-080', 'Analito 2', 34.0, 54.7),
    ('VOL-080', 'Analito 3', 48.8, 94.3),
    ('VOL-081', 'Analito 1', 39.7, 80.2),
    ('VOL-081', 'Analito 2', 46.9, 124.8),
    ('VOL-081', 'Analito 3', 10.0, 65.8),
    ('VOL-082', 'Analito 1', 25.0, 39.1),
    ('VOL-082', 'Analito 2', 6.9, 46.9),
    ('VOL-083', 'Analito 1', 23.7, 74.8),
    ('VOL-084', 'Analito 1', 30.3, 86.7),
    ('VOL-084', 'Analito 2', 16.4, 81.6),
    ('VOL-084', 'Analito 3', 8.1, 107.3),
    ('VOL-085', 'Analito 1', 37.0, 73.9),
    ('VOL-085', 'Analito 2', 16.8, 101.3),
    ('VOL-086', 'Analito 1', 26.6, 100.4),
    ('VOL-087', 'Analito 1', 15.0, 98.4),
    ('VOL-088', 'Analito 1', 18.4, 89.0),
    ('VOL-088', 'Analito 2', 49.0, 111.5),
    ('VOL-088', 'Analito 3', 39.8, 115.1),
    ('VOL-089', 'Analito 1', 34.4, 46.8),
    ('VOL-090', 'Analito 1', 23.7, 120.7),
    ('VOL-090', 'Analito 2', 39.1, 119.0),
    ('VOL-091', 'Analito 1', 28.9, 103.8),
    ('VOL-091', 'Analito 2', 29.2, 54.5),
    ('VOL-092', 'Analito 1', 31.5, 97.3),
    ('VOL-092', 'Analito 2', 42.1, 65.4),
    ('VOL-092', 'Analito 3', 34.0, 46.8),
    ('VOL-093', 'Analito 1', 47.4, 67.3),
    ('VOL-094', 'Analito 1', 0.9, 39.1),
    ('VOL-094', 'Analito 2', 7.6, 79.7),
    ('VOL-094', 'Analito 3', 20.5, 100.2),
    ('VOL-095', 'Analito 1', 46.0, 134.6),
    ('VOL-096', 'Analito 1', 36.8, 52.4),
    ('VOL-097', 'Analito 1', 6.9, 35.6),
    ('VOL-098', 'Analito 1', 16.3, 85.9),
    ('VOL-099', 'Analito 1', 26.3, 64.5),
    ('VOL-100', 'Analito 1', 8.7, 100.8),
    ('VOL-100', 'Analito 2', 17.1, 59.0),
    ('VOL-100', 'Analito 3', 38.6, 113.5)
) AS v(codigo, nombre, minimo, maximo) ON e.codigo = v.codigo AND pe.nombre = v.nombre;

-- 5000 pacientes, vía COPY (mucho más rápido que INSERT para este volumen)
COPY paciente (curp, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, sexo_biologico, tipo_sanguineo, telefono, correo) FROM stdin;
HIRJ391107XHJYJWN7	Lucía	Torres	Morales	1939-11-07	Intersex	B-	5584419866	paciente1@example.com
OUIX940831HPGGRI94	Manuel	López	Pérez	1994-08-31	M	A+	5593308330	\N
RFNU250410MPPUGYS5	Miriam	Guzmán	Ramírez	2025-04-10	F	B+	5519380262	paciente3@example.com
XJBA410917HJSTDKS7	Emilio	Castillo	Gómez	1941-09-17	M	\N	5528743152	paciente4@example.com
ZJSV950630XYGFTUZ6	Arturo	Gómez	\N	1995-06-30	Intersex	\N	5561227530	\N
XSAI730625HULWHBH7	Sergio	Díaz	Gutiérrez	1973-06-25	M	B+	5584145933	paciente6@example.com
NWRP920321MYRZVGP9	Patricia	Contreras	Estrada	1992-03-21	F	O-	5585191088	\N
DVGW860205XSPCQOD7	Manuel	Flores	Herrera	1986-02-05	Intersex	A+	5579087406	\N
LWCR870923HBCPBJ02	Rodrigo	Vázquez	López	1987-09-23	M	A+	5565676618	\N
EXHA780417MYAJOV86	Laura	Gómez	Castillo	1978-04-17	F	\N	5533752431	\N
GCDT040223XBOTVWD3	Emilio	Peña	Martínez	2004-02-23	Intersex	O+	5538302843	paciente11@example.com
JEVQ040626XHNJIB99	Claudia	Chávez	Chávez	2004-06-26	Intersex	A+	5568705685	paciente12@example.com
HHJW830404MEZOBR06	Patricia	Gutiérrez	Fuentes	1983-04-04	F	\N	5563435175	\N
TTBC650420XGZYSX93	Diana	Morales	Aguilar	1965-04-20	Intersex	AB-	5554033173	paciente14@example.com
YJMO961119XRULJIX8	Fernando	Castillo	Salazar	1996-11-19	Intersex	AB-	5575355609	paciente15@example.com
XNJE731012XGKHMSP7	Manuel	Martínez	Delgado	1973-10-12	Intersex	\N	5554777252	\N
UBQB361122XCVBYA02	Guadalupe	Gómez	Fuentes	1936-11-22	Intersex	A-	\N	\N
VTPV680710HPAARR00	Arturo	Contreras	Peña	1968-07-10	M	O+	5548408621	paciente18@example.com
LIZM030203XCLMOSP3	Manuel	Reyes	Herrera	2003-02-03	Intersex	B+	5510166687	\N
ZKSD671118HQBHGW44	Iván	Flores	Alvarado	1967-11-18	M	O+	5548902503	paciente20@example.com
SHSM110301XVRKMYI1	Miriam	Castillo	Gutiérrez	2011-03-01	Intersex	\N	5550163159	paciente21@example.com
ZOPH010320XLRMNFY1	Pablo	Chávez	\N	2001-03-20	Intersex	B+	5511426265	paciente22@example.com
ECFN160726HORRQNG0	José	Gutiérrez	Díaz	2016-07-26	M	O-	5519956046	paciente23@example.com
QFVM740605HFEIJI52	Rodrigo	Salazar	Reyes	1974-06-05	M	O-	5546471543	paciente24@example.com
JAMK130801MTMZKOV6	Teresa	Peña	Rodríguez	2013-08-01	F	A+	5593752654	paciente25@example.com
IZML920101XDSGSRL8	Guadalupe	Cabrera	Chávez	1992-01-01	Intersex	O+	5573741672	paciente26@example.com
OTPS190207HMRQWN80	Alejandro	Cruz	Aguilar	2019-02-07	M	B-	5589113529	\N
ZNDA390206XDIHQX78	Daniela	Cordero	Ramos	1939-02-06	Intersex	A-	5567982507	\N
JKOZ940627MGQPLPG7	Ana	Sánchez	Cruz	1994-06-27	F	AB-	5540105123	paciente29@example.com
ZMUF041208XFUVNMB9	Ricardo	Ramos	Contreras	2004-12-08	Intersex	A-	5566033419	\N
IVPQ150707XUKTMTZ9	Eduardo	Mendoza	Contreras	2015-07-07	Intersex	O-	5579249912	paciente31@example.com
MNTE791129HSMNFP82	Manuel	Sánchez	Cruz	1979-11-29	M	\N	5542257905	paciente32@example.com
UPNV800523MPNWOPK1	Patricia	Morales	Salazar	1980-05-23	F	O+	5534043842	paciente33@example.com
DIYR740511XLRYBY28	Elena	Rojas	Sánchez	1974-05-11	Intersex	A-	5513407451	paciente34@example.com
LWTU631130HNFTEZN3	Gerardo	Reyes	Delgado	1963-11-30	M	O+	5584982544	paciente35@example.com
BIUE430424XWEHEWU3	Yolanda	Rodríguez	Romero	1943-04-24	Intersex	AB+	5594667116	paciente36@example.com
SAYX960517MCXOUVW1	Miriam	Mendoza	Rojas	1996-05-17	F	\N	5563745458	paciente37@example.com
DUZO210813XADFOOA6	Beatriz	Rojas	Hernández	2021-08-13	Intersex	A-	5524241541	paciente38@example.com
WYHN600809XUCWDAN7	Ricardo	Hernández	Gutiérrez	1960-08-09	Intersex	O-	5538700516	paciente39@example.com
KLJE160624MMYYEUJ1	Ana	Jiménez	Rodríguez	2016-06-24	F	\N	5592753269	paciente40@example.com
XMLN721104HKZEHIF3	Luis	Rodríguez	Sánchez	1972-11-04	M	\N	5594043898	\N
MDHP810504MUTCQAX5	Gabriela	Cordero	Reyes	1981-05-04	F	A+	5596582710	paciente42@example.com
ZMQJ200424HUWQYN16	Alejandro	Vázquez	\N	2020-04-24	M	O-	5589241418	paciente43@example.com
UVUC570407HJWNXHD3	Javier	Chávez	Solís	1957-04-07	M	O-	5517990421	\N
QZXI781026HFLEXYR1	Iván	García	Ruiz	1978-10-26	M	O+	5564814917	paciente45@example.com
FIYD921001MSVXDH60	Guadalupe	Rojas	Flores	1992-10-01	F	O+	5503075622	paciente46@example.com
NXKI030619HCSLDQD2	Javier	Cordero	Chávez	2003-06-19	M	A-	5506174451	paciente47@example.com
THOL590522HSPYYG83	Eduardo	Morales	Gutiérrez	1959-05-22	M	A+	\N	paciente48@example.com
KAYV400602HMXXJDN8	Javier	Ruiz	García	1940-06-02	M	A-	5502410386	paciente49@example.com
UMCS131005MSBNVEP4	Karla	Pérez	Medina	2013-10-05	F	B+	5565574313	\N
KNDR831205XLYGOJ34	Francisco	Cruz	Vargas	1983-12-05	Intersex	O-	\N	paciente51@example.com
KECW500929MHLMQBT4	Leticia	Estrada	\N	1950-09-29	F	A+	\N	paciente52@example.com
ZZED160805MABYHEM6	Elena	Salazar	Contreras	2016-08-05	F	B-	5519941013	paciente53@example.com
BOBF140930MSNXMPB6	Carmen	Ramírez	Ramos	2014-09-30	F	AB+	5532447209	paciente54@example.com
BCIM821006HENGUZ73	Óscar	Ortiz	Salazar	1982-10-06	M	\N	5565787598	paciente55@example.com
ZYIB230209MZPQLYO2	Verónica	Martínez	Jiménez	2023-02-09	F	O-	5534803965	paciente56@example.com
SAWW430928HLSSESM7	Jorge	Reyes	Ruiz	1943-09-28	M	\N	5570103930	paciente57@example.com
WFZK950303HBAESWJ1	Ricardo	Peña	Ramírez	1995-03-03	M	\N	5515691545	\N
KFWR670701HWTZLHL6	Rodrigo	Alvarado	Rojas	1967-07-01	M	B+	5542209690	\N
PEKX160525MCHLKFF5	Carmen	Peña	Cabrera	2016-05-25	F	AB-	\N	\N
ABMO610208XXNFNPY5	Miguel	Ruiz	Rodríguez	1961-02-08	Intersex	\N	5579327104	\N
XCRC110421MKTTPWB6	Laura	González	Aguilar	2011-04-21	F	A+	5562015336	paciente62@example.com
HDBM990121XSRPEBX0	Rosa	Fuentes	Ortiz	1999-01-21	Intersex	AB+	\N	paciente63@example.com
FUJC070304XPDJZM47	Mónica	Guzmán	Martínez	2007-03-04	Intersex	B+	\N	paciente64@example.com
IOOI210925HHISBEG1	Eduardo	Aguilar	Vargas	2021-09-25	M	B-	5569380686	paciente65@example.com
JCMW830104XBQSQZJ1	Carmen	Guzmán	Reyes	1983-01-04	Intersex	AB-	5523320616	\N
MRMR171206XKIQOA76	Manuel	Estrada	González	2017-12-06	Intersex	O-	5529991191	paciente67@example.com
UPST910517XPBFIMJ9	Leticia	Ruiz	Torres	1991-05-17	Intersex	AB+	\N	paciente68@example.com
ILAK830208MZJJIPG3	Miriam	Reyes	\N	1983-02-08	F	A+	5575469137	\N
BQZF520130MCJWQMI8	Diana	Rojas	Mendoza	1952-01-30	F	O+	5530307053	\N
AHLP640817MTOFPS95	Rosa	Castillo	Sánchez	1964-08-17	F	B-	5541406029	paciente71@example.com
UNQA010806HYYVAPI2	Diego	Jiménez	Vázquez	2001-08-06	M	O+	5594466574	\N
DAQV730420MLRUTTS4	Lucía	Herrera	Castillo	1973-04-20	F	O-	5554544432	paciente73@example.com
VKVE890626HXAUPJQ6	Mario	Hernández	Estrada	1989-06-26	M	AB+	5509935387	paciente74@example.com
VRFJ500427XDPEXI92	Iván	Medina	Flores	1950-04-27	Intersex	B-	5535346554	paciente75@example.com
STCP730520MGQDVM74	Yolanda	Sánchez	Solís	1973-05-20	F	AB+	\N	paciente76@example.com
OEKW450821HFYCPKL5	Francisco	Ramos	Cabrera	1945-08-21	M	O+	\N	\N
TNUN140216HMNPMAC8	Daniel	Flores	Pérez	2014-02-16	M	A-	5505830033	paciente78@example.com
JFCB721204MJJOXQ75	Gabriela	Ramírez	Medina	1972-12-04	F	AB+	5525753260	\N
FDLW800619XUZBMUQ8	Alejandro	Vázquez	Delgado	1980-06-19	Intersex	O+	5501001676	\N
JNVD241126MVQITTI6	Paola	Cruz	Solís	2024-11-26	F	O-	5591411739	\N
NJFB620818MRPGWPV3	Leticia	Herrera	Ruiz	1962-08-18	F	O+	\N	\N
CYQC400723HXXDIUO7	Emilio	Cabrera	Cruz	1940-07-23	M	B+	5501204556	paciente83@example.com
VUFK130428HLOTIXF5	Diego	López	\N	2013-04-28	M	B-	5566746762	\N
NSPZ160607XSVOFTY5	Rosa	Hernández	Flores	2016-06-07	Intersex	O+	5527716701	\N
SHVK601021MQQWWTG6	María	Herrera	Cabrera	1960-10-21	F	A-	5562890028	paciente86@example.com
HKIB961221MQHRUMZ3	Yolanda	Flores	Rojas	1996-12-21	F	O-	5597177517	paciente87@example.com
ACZT760623HTUJQRN7	Carlos	Castillo	Salazar	1976-06-23	M	B-	5503758997	paciente88@example.com
KLUZ250717MJRQLWG0	Miriam	Vargas	Jiménez	2025-07-17	F	A+	5561493316	\N
UVSD210726HYOOVS62	Iván	Ramos	Romero	2021-07-26	M	AB-	\N	paciente90@example.com
FWSF550831XXEDMVU8	Diego	Delgado	Medina	1955-08-31	Intersex	AB+	5593465472	\N
KWXR480709XUGGGTS5	Karla	Medina	Salazar	1948-07-09	Intersex	A+	5528851587	paciente92@example.com
NZAQ000201XDAMEBD3	Paola	Romero	Fuentes	2000-02-01	Intersex	B+	5524420438	\N
HXUR480224MMHQZZS0	Laura	Peña	Salazar	1948-02-24	F	AB+	5558004397	paciente94@example.com
XTGY760912XXGJOFE2	Paola	Cordero	Delgado	1976-09-12	Intersex	A+	5516064842	\N
EKTB220226MYUTVJ59	María	Ramos	Cruz	2022-02-26	F	\N	5558328182	paciente96@example.com
KKLJ660324XGYTQP90	Pablo	Pérez	Vázquez	1966-03-24	Intersex	O-	5573993056	paciente97@example.com
QYLQ230710HZQOPBS3	Roberto	Torres	Ortiz	2023-07-10	M	B-	5512880133	paciente98@example.com
CXVE670925MAOWKBF1	Leticia	Rodríguez	Alvarado	1967-09-25	F	O+	5548193466	paciente99@example.com
DRAU650502MXTCYXC1	Daniela	Chávez	\N	1965-05-02	F	B-	5514491476	paciente100@example.com
XMZZ130703XRJUEJX0	Juan	Guzmán	Jiménez	2013-07-03	Intersex	\N	5521009968	paciente101@example.com
NUQE060928HFFHTIM1	Manuel	Vázquez	Ruiz	2006-09-28	M	A+	5590878141	\N
EVUH930912HDJTCGU7	Rodrigo	Delgado	Ramos	1993-09-12	M	AB-	5549299556	\N
ILEV860812MXKPOOW4	Adriana	Jiménez	Cordero	1986-08-12	F	AB-	5529142834	paciente104@example.com
ASSM690126XYSGBRQ8	Miguel	González	Medina	1969-01-26	Intersex	\N	5525639427	paciente105@example.com
ZTVF490830HYQEOFL9	Roberto	Mendoza	Reyes	1949-08-30	M	A+	5575037314	paciente106@example.com
POBB901202HUKDWQR4	Hugo	Vázquez	Mendoza	1990-12-02	M	\N	5566591846	paciente107@example.com
ZPTA820122HQEOFHE8	Arturo	Castillo	Ruiz	1982-01-22	M	B+	5522591365	paciente108@example.com
UNAH110410MBESSFI8	Lucía	Guzmán	Delgado	2011-04-10	F	O+	5520242869	paciente109@example.com
TPPF850609XHNTEZL9	Juan	Ortiz	Vázquez	1985-06-09	Intersex	\N	5557991366	\N
NETD640504HFPTTB88	Francisco	Herrera	Medina	1964-05-04	M	O-	\N	paciente111@example.com
QNLB870110XWQNHZ46	Patricia	García	Cordero	1987-01-10	Intersex	B-	5591624731	\N
QDQA731119XMUGWZU6	Emilio	Torres	García	1973-11-19	Intersex	B-	5569448695	paciente113@example.com
FLRR820615XPIJSLZ2	Pablo	Vázquez	Salazar	1982-06-15	Intersex	O-	5572138658	paciente114@example.com
ZCEP250406XTNCCIO5	Paola	Hernández	Solís	2025-04-06	Intersex	O-	5566984902	paciente115@example.com
GBZT000130MQQWHTK0	María	Morales	Herrera	2000-01-30	F	B-	5502146566	paciente116@example.com
XRSL000319XLIHTG36	José	González	Salazar	2000-03-19	Intersex	O+	5568181845	paciente117@example.com
WOMS030419XPYHYK37	Arturo	Fuentes	Cabrera	2003-04-19	Intersex	O+	5541633565	paciente118@example.com
VXKC891212HRFPKLN9	Iván	Torres	Pérez	1989-12-12	M	B+	5537333433	\N
CVVP141225HTAYRB45	Emilio	Peña	Rodríguez	2014-12-25	M	B-	5594728463	paciente120@example.com
RBQL410609HMVYFOH8	Juan	Herrera	Guzmán	1941-06-09	M	AB-	5500369155	paciente121@example.com
TKLF830614MPNGNWX5	Verónica	Salazar	Díaz	1983-06-14	F	AB+	5529293143	paciente122@example.com
ZAFN830422MPEUQRU7	Claudia	Cruz	Cruz	1983-04-22	F	B+	5590612034	paciente123@example.com
LRRZ930509XILANDW9	Francisco	Vargas	Torres	1993-05-09	Intersex	A-	5582455877	paciente124@example.com
FUZK471104MNUTSME1	Teresa	Ortiz	Cruz	1947-11-04	F	A+	5555449647	paciente125@example.com
FFAE880806MXHVIXF3	Diana	Delgado	Vargas	1988-08-06	F	A+	5511780068	paciente126@example.com
MJHH661228HXJOUEI8	Carlos	Torres	Pérez	1966-12-28	M	A+	\N	paciente127@example.com
IROE411113MWRFST39	Yolanda	Guzmán	Fuentes	1941-11-13	F	AB+	5584578317	paciente128@example.com
YELJ781015MPRAWP44	Mónica	Cruz	García	1978-10-15	F	O+	5549308536	paciente129@example.com
MHIC901010MNUHQYR4	Fernanda	Reyes	Cordero	1990-10-10	F	\N	5563122417	paciente130@example.com
EBRA231231MFDJIE20	Miriam	Peña	Chávez	2023-12-31	F	A-	\N	\N
OWZB920602HKCYEBR6	Ricardo	Romero	Rojas	1992-06-02	M	O-	5523460136	paciente132@example.com
VGPM781226MVJKFUC8	Adriana	López	Rodríguez	1978-12-26	F	\N	5574350313	paciente133@example.com
MZHA150102MBSZWPJ5	María	Flores	Delgado	2015-01-02	F	O-	5571950052	paciente134@example.com
UYLZ541229HOXGAWY5	Miguel	Rojas	Salazar	1954-12-29	M	A+	5507784873	paciente135@example.com
TRFC471124XQEOJI85	Iván	Chávez	Díaz	1947-11-24	Intersex	AB-	\N	paciente136@example.com
LYTH481113MKXCVRY3	Diana	Gómez	Peña	1948-11-13	F	\N	5582945651	\N
BGDP090917XGDBSUY7	Miguel	López	Ramírez	2009-09-17	Intersex	\N	5594053910	paciente138@example.com
ZUBL830930HRXNLZD9	Óscar	Rojas	Pérez	1983-09-30	M	B+	5514138113	paciente139@example.com
FRXR690821HNXDYUW7	Francisco	Herrera	Cabrera	1969-08-21	M	AB+	5522868528	paciente140@example.com
LNYU491210MNXKTH83	Sofía	Chávez	Chávez	1949-12-10	F	AB+	5545776004	paciente141@example.com
HGKA370604XYWIRQ99	Alejandro	Gutiérrez	\N	1937-06-04	Intersex	A+	\N	paciente142@example.com
HIZJ030428HCSMSGE5	Miguel	Torres	Delgado	2003-04-28	M	AB-	5591940961	paciente143@example.com
YHXU470915MTAUYUY0	Sofía	Alvarado	Sánchez	1947-09-15	F	B+	5558925832	\N
CHNJ800616XZMEEKF7	Pablo	Vargas	Cabrera	1980-06-16	Intersex	O+	5541686227	paciente145@example.com
XQHH700623MCIYNKF1	Fernanda	Cordero	Salazar	1970-06-23	F	AB+	5553559042	paciente146@example.com
HGVL210917XEYXCDD3	Miriam	Vargas	Vargas	2021-09-17	Intersex	A+	5540514770	paciente147@example.com
IRPT580603XXEWWVB6	Patricia	Vázquez	Herrera	1958-06-03	Intersex	\N	\N	\N
ACMV661230MIVVLDB4	Claudia	Peña	Contreras	1966-12-30	F	AB+	5568157981	\N
HQJK220304XPMXFAW5	Adrián	Salazar	Martínez	2022-03-04	Intersex	B-	5538404608	paciente150@example.com
XMQV171111HTUVHNP9	Miguel	Ramos	Ramírez	2017-11-11	M	A+	5549578232	paciente151@example.com
WQEN631220XYEUSFU1	Lucía	Morales	Gutiérrez	1963-12-20	Intersex	\N	5512520566	paciente152@example.com
YGDE120208XFAYTTR9	Miriam	Solís	Díaz	2012-02-08	Intersex	A-	5530517289	paciente153@example.com
EFGH830324XBNYAI03	Rodrigo	Gómez	Rojas	1983-03-24	Intersex	A-	5512797573	paciente154@example.com
XSTR701117HQUWZB71	Andrés	Aguilar	Castillo	1970-11-17	M	AB-	5503886086	paciente155@example.com
JYJO460525XFNJTB72	Carlos	Morales	Castillo	1946-05-25	Intersex	AB-	5571812982	paciente156@example.com
WGOC450419MIKWUWK1	Karla	Martínez	Delgado	1945-04-19	F	O-	5575186892	paciente157@example.com
VEFE470728MFYWBNT4	Guadalupe	Flores	Cabrera	1947-07-28	F	AB-	5521230940	paciente158@example.com
GSVP040525MONOCTA3	Elena	García	Rojas	2004-05-25	F	\N	5583022050	\N
CBDN960113HFFVJT92	Hugo	Cabrera	Gutiérrez	1996-01-13	M	AB-	5550145561	paciente160@example.com
IKQN630603XQGWGTD1	Miguel	Ortiz	Sánchez	1963-06-03	Intersex	\N	5579469548	paciente161@example.com
XUPP790211XZFTHWS3	Iván	Ramírez	Rojas	1979-02-11	Intersex	O+	5571396605	paciente162@example.com
ZCJJ021130XQRKYAH5	Fernando	García	Ortiz	2002-11-30	Intersex	B-	5599023557	paciente163@example.com
RKOZ840531HNXBQJU8	Óscar	Ramírez	Solís	1984-05-31	M	\N	\N	paciente164@example.com
AKMU000729MRFSTML9	Carmen	Ruiz	Cruz	2000-07-29	F	O-	5545046173	paciente165@example.com
ZBYG920301MCOQAZ48	Claudia	Herrera	Sánchez	1992-03-01	F	A+	5578452182	\N
AJBV150507HTCKOBG8	Sergio	Aguilar	Herrera	2015-05-07	M	B+	\N	paciente167@example.com
IRKY000111XOVDIEK4	Yolanda	Vázquez	Morales	2000-01-11	Intersex	O-	\N	paciente168@example.com
IEWZ970301XJSHFCT9	Francisco	Vázquez	Salazar	1997-03-01	Intersex	B-	5502070160	\N
WWOT500921MLJKGW81	Verónica	Estrada	Solís	1950-09-21	F	AB-	5517174773	paciente170@example.com
FWVK900725HZKOPAE7	Diego	Peña	Mendoza	1990-07-25	M	O-	5572459928	\N
ZJRO190517XMSNHTP8	Cecilia	Rodríguez	Cordero	2019-05-17	Intersex	A+	5561539669	paciente172@example.com
WSPD590529XSTOKRG7	Karla	Reyes	González	1959-05-29	Intersex	A+	5561919657	paciente173@example.com
YUZA440914HYEVEO84	Luis	Vázquez	Delgado	1944-09-14	M	AB+	5573354946	paciente174@example.com
QMEJ370329MBLRBA95	Ana	Delgado	\N	1937-03-29	F	O-	5503696566	paciente175@example.com
MLNE751128XJVEEAE0	Fernando	Gómez	Morales	1975-11-28	Intersex	A+	5576212679	paciente176@example.com
OMLH520301XFNTAS53	Eduardo	Contreras	Salazar	1952-03-01	Intersex	\N	5589500975	\N
YYIO370701MQCQTCP7	Miriam	Pérez	Herrera	1937-07-01	F	O-	5589490580	paciente178@example.com
LZJJ871220XFBWTXT9	Yolanda	Guzmán	Ramos	1987-12-20	Intersex	B+	\N	paciente179@example.com
XTAJ530303HPCEQCR4	Daniel	Hernández	Ortiz	1953-03-03	M	A+	5544019292	paciente180@example.com
FZQB820327MKCETE56	Carmen	Gómez	Reyes	1982-03-27	F	AB+	5572395041	\N
MVWM041010MPIEQNA4	Fernanda	Guzmán	Fuentes	2004-10-10	F	AB-	5558018569	paciente182@example.com
USMO021030MYVXHXM8	Alejandra	Díaz	Rodríguez	2002-10-30	F	B-	5525800106	\N
GBAT030220HCBTVGH1	Hugo	Vargas	Ortiz	2003-02-20	M	O-	5526921244	paciente184@example.com
NWVY560918HYKIFYE4	Óscar	Contreras	Díaz	1956-09-18	M	O+	5550442717	paciente185@example.com
ERYN160104HGTUDOQ1	Andrés	Castillo	Rojas	2016-01-04	M	O+	\N	paciente186@example.com
EUUA810201MBVMIEV6	Beatriz	Vargas	\N	1981-02-01	F	O+	5577661830	paciente187@example.com
LKVJ411107XMBUUCX8	Miriam	Guzmán	Fuentes	1941-11-07	Intersex	B-	\N	paciente188@example.com
MVGJ381209MWMDUWW7	Cecilia	Morales	López	1938-12-09	F	O-	5573203093	paciente189@example.com
ZOAB771101HKBKZXC6	Pablo	Fuentes	Rojas	1977-11-01	M	O-	5587829310	paciente190@example.com
HWUE210818MAFUBJG7	Cecilia	Martínez	Peña	2021-08-18	F	A+	5511179931	paciente191@example.com
EKZG761006MYBSFKE1	Alejandra	Castillo	Cabrera	1976-10-06	F	B+	5562582739	\N
PCAA240502HFCWUSS6	Pablo	Solís	Flores	2024-05-02	M	AB-	5532487632	paciente193@example.com
CUZJ400625HLNARHM1	Andrés	Gómez	Peña	1940-06-25	M	\N	5595883734	\N
FFVB810207HBULJG14	Pablo	Cruz	Guzmán	1981-02-07	M	B-	5570108220	paciente195@example.com
KNGX730922HVKHYDU3	Luis	Reyes	Delgado	1973-09-22	M	O-	5563631797	\N
MLEO091006MXGULIM5	Patricia	Vázquez	Contreras	2009-10-06	F	A+	\N	paciente197@example.com
FYKH880320MJTFZZK9	Patricia	Sánchez	Contreras	1988-03-20	F	\N	5516873977	\N
HSES731002XANBBP60	Diego	Reyes	Alvarado	1973-10-02	Intersex	AB+	5571773180	paciente199@example.com
CAPV670821MJFWOSB7	Claudia	Ramírez	Reyes	1967-08-21	F	AB-	5562570165	paciente200@example.com
SZGZ770127MVCTKXD8	Daniela	Díaz	Peña	1977-01-27	F	B-	5516579055	\N
KHRD130427XUPXYSN3	Paola	González	Vázquez	2013-04-27	Intersex	B-	5548640155	paciente202@example.com
RJOT641119XLZVWZE3	Laura	Sánchez	Fuentes	1964-11-19	Intersex	AB-	\N	paciente203@example.com
WEPE150909HGQUAJ08	Manuel	González	Díaz	2015-09-09	M	A+	5567043103	paciente204@example.com
UZKP661128XSVWQR27	Sofía	Ramos	Ramos	1966-11-28	Intersex	B+	5542437540	\N
RJFF611117MWWVZEK3	Karla	Flores	Flores	1961-11-17	F	O-	\N	paciente206@example.com
WBVK750411HLELORK8	Sergio	Torres	Vázquez	1975-04-11	M	B+	5506727520	paciente207@example.com
JYSV830322XEZSXOV1	Ana	Ramos	Ortiz	1983-03-22	Intersex	AB-	5528140693	paciente208@example.com
QHZY730525HIGACR21	Ricardo	Hernández	Morales	1973-05-25	M	\N	5575998056	\N
LJOR941017MCGXOX07	Sofía	Aguilar	Ortiz	1994-10-17	F	B+	5566299123	paciente210@example.com
MCAN571126XUINFR39	Hugo	González	Delgado	1957-11-26	Intersex	A+	5564870494	paciente211@example.com
EIJU250708XUPDUVS6	Adrián	Jiménez	\N	2025-07-08	Intersex	A+	5530147195	paciente212@example.com
WDLQ380502XXSAIFD2	Diego	Torres	Guzmán	1938-05-02	Intersex	B-	5525204565	\N
YUFY080508MDTYFRU5	Rosa	Solís	Medina	2008-05-08	F	B+	5551895202	paciente214@example.com
GEQH160719MGZRTW78	Beatriz	Rojas	Flores	2016-07-19	F	\N	5516711207	paciente215@example.com
YKFW781022XJAXDHI2	Rodrigo	Ramírez	Estrada	1978-10-22	Intersex	A-	5532161107	paciente216@example.com
QSBP660719HDIBCJA1	Francisco	Rodríguez	\N	1966-07-19	M	O-	5539325012	paciente217@example.com
XTHQ550909MSCDSYA8	Silvia	Ruiz	Medina	1955-09-09	F	A-	5542801387	paciente218@example.com
LMNG090706XQHNDYU1	Eduardo	Vargas	Rodríguez	2009-07-06	Intersex	AB-	5527548015	paciente219@example.com
OHRN640206MJNGCZ45	Gabriela	Contreras	Gutiérrez	1964-02-06	F	A+	\N	paciente220@example.com
EMMW150116XSDXFCX3	Francisco	Castillo	Pérez	2015-01-16	Intersex	B-	5561367499	\N
MPQI400630XEYODDQ7	Pablo	Ruiz	Estrada	1940-06-30	Intersex	AB-	5520101702	paciente222@example.com
YCVY170204XQYPZOM4	Óscar	Cruz	Peña	2017-02-04	Intersex	AB-	5548588006	paciente223@example.com
OBBF860113HRVYJWK7	Roberto	Vargas	Aguilar	1986-01-13	M	AB+	5567197889	paciente224@example.com
PSMT020209XVLYJKD0	Beatriz	Flores	Castillo	2002-02-09	Intersex	O+	5555905616	paciente225@example.com
HUJS030711MCWCJDV2	Daniela	Ruiz	Reyes	2003-07-11	F	O+	5507698640	paciente226@example.com
SDZP961023XDWVGK58	Juan	Chávez	Aguilar	1996-10-23	Intersex	B-	5545637183	\N
XCWS690915HDSKIC77	Manuel	Cabrera	Jiménez	1969-09-15	M	AB+	5514846853	paciente228@example.com
AUWQ090715MFSPGV34	Teresa	Medina	Salazar	2009-07-15	F	\N	5569083572	\N
CUGN970224XIJUFIP6	Daniela	Gutiérrez	Romero	1997-02-24	Intersex	A-	5530347786	paciente230@example.com
ZZIV020722HRFUBX50	Francisco	Flores	Martínez	2002-07-22	M	O+	5515941651	paciente231@example.com
QDQV591105XSYQIPF3	Diana	Ramírez	Cabrera	1959-11-05	Intersex	O-	5555963632	\N
PRLW200920HDKRNPP4	Alejandro	Vargas	Delgado	2020-09-20	M	A+	5554090034	paciente233@example.com
HOMA771001MMIJCYP4	Cecilia	Mendoza	Sánchez	1977-10-01	F	A-	5527560417	paciente234@example.com
FWIQ511012MCLNTX95	Leticia	Ramos	Rodríguez	1951-10-12	F	AB-	5502720634	paciente235@example.com
ETVN570409HZKOPXI4	Carlos	Flores	Cordero	1957-04-09	M	A+	5554316526	paciente236@example.com
TUHC670907XOGIWFD6	Sergio	Martínez	Salazar	1967-09-07	Intersex	AB+	5521529108	paciente237@example.com
ZIJX080823MPMENGN4	Leticia	Rojas	Vázquez	2008-08-23	F	A-	5562044397	paciente238@example.com
EKWM830903MVGWMW19	Silvia	Cordero	García	1983-09-03	F	B+	\N	paciente239@example.com
VZTW710504HXZBAI69	Ricardo	Reyes	Ruiz	1971-05-04	M	AB+	5565280924	\N
QNEI620107MDKBEPR5	Alejandra	Contreras	Chávez	1962-01-07	F	AB+	5549485625	paciente241@example.com
OBGE540215MBHFBPQ2	Beatriz	Cruz	Solís	1954-02-15	F	AB-	5570758777	\N
JFFX070618XQISVSN9	Carmen	Cruz	Pérez	2007-06-18	Intersex	O+	5592613715	\N
DKEA420519XCOWVP34	Daniela	Sánchez	Delgado	1942-05-19	Intersex	O+	5509759230	paciente244@example.com
TMCM400504MIFHYMF0	Alejandra	Hernández	Salazar	1940-05-04	F	A-	5564214764	paciente245@example.com
GPOM790930XPISTNF6	Alejandro	Ruiz	Mendoza	1979-09-30	Intersex	B-	5566108573	paciente246@example.com
CJON780901XCZPJEI4	Manuel	Rojas	Cordero	1978-09-01	Intersex	A-	5549081081	paciente247@example.com
ILIS521025MCYQAD32	Laura	Contreras	Cabrera	1952-10-25	F	A+	5501645977	paciente248@example.com
TIVD580920MNRAAMH0	Alejandra	Gómez	Pérez	1958-09-20	F	A+	5576974995	paciente249@example.com
EAGD140708XAWGAG42	Daniela	Castillo	Pérez	2014-07-08	Intersex	A-	5583147276	\N
PPAO390408HSHGJSZ0	Mario	Cruz	Vargas	1939-04-08	M	B-	\N	paciente251@example.com
XRJB720413XPMPQS53	Diego	Romero	Delgado	1972-04-13	Intersex	O+	5569581467	\N
FJXG231115XPLOHQO9	Sofía	Ruiz	Alvarado	2023-11-15	Intersex	B-	5572466572	paciente253@example.com
GFTP100311MDZNPJP3	Miriam	Pérez	Ramírez	2010-03-11	F	\N	\N	\N
ZCKN221114MDTHDRO7	Sofía	Flores	Medina	2022-11-14	F	B+	5550842891	paciente255@example.com
DZTT380419MZDRBQG2	Carmen	Contreras	Sánchez	1938-04-19	F	O-	5552478712	paciente256@example.com
NYYA860506MHZPKJ62	Leticia	Ramírez	Morales	1986-05-06	F	O-	5565328632	paciente257@example.com
VLAO540614MEYAWZ71	Daniela	Contreras	Herrera	1954-06-14	F	O-	5562606029	\N
VWRJ890903XXXKLAR8	Paola	Herrera	Romero	1989-09-03	Intersex	A+	5573899756	paciente259@example.com
XXEQ600907MRJGCQ94	Ana	López	Aguilar	1960-09-07	F	\N	5520089434	paciente260@example.com
QLDB690627XYUDOJA7	Antonio	Hernández	Torres	1969-06-27	Intersex	B-	5599893544	paciente261@example.com
HDKQ590729XSGYLOG2	Claudia	Ramírez	Herrera	1959-07-29	Intersex	AB+	5511062737	\N
MISP551113XUNOWP02	Laura	Castillo	Herrera	1955-11-13	Intersex	A+	5577288137	paciente263@example.com
NDDL711007XSJBQEH5	Ricardo	Salazar	Sánchez	1971-10-07	Intersex	B+	5544702296	\N
DRLC250720MBNPSJ25	Araceli	Ortiz	Rojas	2025-07-20	F	AB+	5592287772	paciente265@example.com
HMKR901231MBVOXIF2	Ana	Peña	Romero	1990-12-31	F	O+	5548181398	paciente266@example.com
ADVR800823HFAIZGP9	Daniel	Herrera	Guzmán	1980-08-23	M	AB-	\N	paciente267@example.com
AKNF480528MNAQKMQ1	Fernanda	Delgado	\N	1948-05-28	F	O-	5582422412	paciente268@example.com
AWBJ090616MMDKENU4	Lucía	Flores	Chávez	2009-06-16	F	AB+	5510339937	paciente269@example.com
RNCP840114XANUHAR8	Gerardo	Sánchez	Chávez	1984-01-14	Intersex	O-	5582496718	\N
NROB770707HAOTJUK0	Eduardo	Fuentes	Reyes	1977-07-07	M	O+	5574946539	paciente271@example.com
JCMW190619MDEXRI13	Guadalupe	Flores	Cabrera	2019-06-19	F	\N	5555474355	\N
ATPA670929XAVFNR56	Hugo	Martínez	Ramírez	1967-09-29	Intersex	\N	\N	paciente273@example.com
VOVD510202XLMTLML0	Miguel	Fuentes	\N	1951-02-02	Intersex	O-	5537030453	\N
PLBI040920XPWWTGA3	Alejandra	Gutiérrez	Jiménez	2004-09-20	Intersex	AB+	5549872839	paciente275@example.com
CEIS581024XHQXZIM0	Claudia	Gómez	Ramírez	1958-10-24	Intersex	\N	5587060566	\N
BXHB570823XINROKA6	Laura	Contreras	Herrera	1957-08-23	Intersex	A-	5590361332	paciente277@example.com
ZASZ861226HUKIHD43	Óscar	Solís	Guzmán	1986-12-26	M	B-	5558319971	paciente278@example.com
KWCZ911118XEBZOBT9	Antonio	Pérez	López	1991-11-18	Intersex	AB+	\N	paciente279@example.com
TYNH170220XTZVTA36	Carlos	Ortiz	Castillo	2017-02-20	Intersex	AB-	5599150785	paciente280@example.com
ZGSE720719HUQILN49	Carlos	García	González	1972-07-19	M	AB-	5520024968	paciente281@example.com
PJTK120706MJLAQSJ0	Gabriela	Delgado	Cruz	2012-07-06	F	A-	5580653331	paciente282@example.com
SSKT490420XJNKFD30	María	Contreras	Ramos	1949-04-20	Intersex	AB-	5503379337	paciente283@example.com
ALAC510817MLARDES7	Carmen	Aguilar	Gómez	1951-08-17	F	A-	5550033423	paciente284@example.com
GAFI090920XDAVEMH5	Eduardo	Ramos	Reyes	2009-09-20	Intersex	A-	5535528961	\N
LKTN630612HUHBYTM8	Pablo	Morales	Aguilar	1963-06-12	M	B+	5553042897	\N
FQMY191202HUYQLP77	Pablo	Guzmán	Peña	2019-12-02	M	A+	5558777496	paciente287@example.com
HMGJ850307XNMSFLQ8	Sofía	López	Morales	1985-03-07	Intersex	O-	5514785390	paciente288@example.com
LZPK890118XIMAFOO4	Hugo	Alvarado	Alvarado	1989-01-18	Intersex	O-	5514888143	\N
VKIJ080205HXYVIGI8	Eduardo	López	Ramos	2008-02-05	M	B+	\N	\N
UAPU571002MQYEMHO3	Carmen	Castillo	Delgado	1957-10-02	F	AB-	5598775153	paciente291@example.com
LESE230114XJXAPZW5	Emilio	Vázquez	Salazar	2023-01-14	Intersex	A-	5568459090	paciente292@example.com
TSMM431006HGMCRMM7	Ricardo	Cabrera	Estrada	1943-10-06	M	O-	5574121820	paciente293@example.com
MJGH431224XJVQCOD5	Guadalupe	Martínez	González	1943-12-24	Intersex	\N	\N	paciente294@example.com
NPXC770811MMGEGJ17	Fernanda	Flores	Ramírez	1977-08-11	F	A+	5549387430	paciente295@example.com
KSPO780724MOSBXCS7	Ana	Castillo	Reyes	1978-07-24	F	B-	5546926329	paciente296@example.com
WBHF900607MIURJVE3	Fernanda	Gómez	Rodríguez	1990-06-07	F	AB-	5581511856	paciente297@example.com
CUWV230505MXOMKXZ3	Claudia	Medina	\N	2023-05-05	F	AB+	\N	\N
OCCR820401XVHWOE44	Araceli	Ramírez	Contreras	1982-04-01	Intersex	A+	5509124186	\N
LFGW860316XBVRGOD8	Silvia	García	Cruz	1986-03-16	Intersex	O-	5547090063	paciente300@example.com
AKGV230326MVCHDZK2	Adriana	Morales	Romero	2023-03-26	F	O+	5515583938	paciente301@example.com
FAMU960922MKAMGOO1	Laura	Jiménez	Ruiz	1996-09-22	F	B+	5550136497	paciente302@example.com
IDTK100510HUWMVYI5	Iván	Fuentes	Cabrera	2010-05-10	M	A+	5557150997	paciente303@example.com
ATYD041113XJHXNYP9	Elena	Jiménez	García	2004-11-13	Intersex	O-	\N	paciente304@example.com
HXTO220503MXKEIKC8	Claudia	Cruz	Cordero	2022-05-03	F	AB+	5540355338	\N
KFOU781215XACPCGD2	Raúl	Jiménez	Aguilar	1978-12-15	Intersex	A-	5529833816	paciente306@example.com
HJJS710521MOUGIZ41	Verónica	Morales	Gómez	1971-05-21	F	B-	5527768962	paciente307@example.com
JTRE570828MRXFIM34	María	Aguilar	Pérez	1957-08-28	F	AB-	5589715273	\N
MNMX810825HLMPJUE6	José	García	Mendoza	1981-08-25	M	O+	5516923645	paciente309@example.com
NXHH910303MPBLUWB2	Cecilia	Mendoza	Cordero	1991-03-03	F	B+	5524399201	paciente310@example.com
CQGN380506XFNIWJ68	Paola	Aguilar	Delgado	1938-05-06	Intersex	AB+	5561195243	paciente311@example.com
PADC100818MYWNQNS6	Miriam	Gutiérrez	\N	2010-08-18	F	A+	5522372817	paciente312@example.com
YGIN530221HOUTDUK1	Jorge	Morales	Gómez	1953-02-21	M	B+	\N	\N
VYDA820318HBIYAVC1	Ricardo	Martínez	Guzmán	1982-03-18	M	A-	5506984775	paciente314@example.com
LVMM410426MTBLKZG0	Sofía	Ramos	Reyes	1941-04-26	F	AB-	5562091843	paciente315@example.com
UKAU250616XLBZXK23	Daniela	Guzmán	Morales	2025-06-16	Intersex	AB-	5591567164	paciente316@example.com
EPZC221121XJVROF21	Manuel	Herrera	Medina	2022-11-21	Intersex	AB-	5533321160	\N
IVPV610321MDVERU51	Araceli	Aguilar	Jiménez	1961-03-21	F	B-	5599156686	paciente318@example.com
KXSG170928HXDSLEU6	Alejandro	Sánchez	Sánchez	2017-09-28	M	O+	5598366552	paciente319@example.com
OKEJ770612XHPVOES2	Adriana	Jiménez	García	1977-06-12	Intersex	O+	5548149737	\N
XZHW490827MXBYFPZ4	Guadalupe	Ramos	Vázquez	1949-08-27	F	A+	5586567566	\N
RMDE621103XKYZSZD4	Daniel	Ortiz	Morales	1962-11-03	Intersex	AB-	5592774233	paciente322@example.com
SDVZ600810HEMNVFD1	Rodrigo	Cordero	\N	1960-08-10	M	B-	5520185962	paciente323@example.com
JWTF811125MUXMYWF7	Adriana	López	Castillo	1981-11-25	F	AB+	5575011117	paciente324@example.com
IWXD820920XZSFMP14	Sergio	Martínez	Cabrera	1982-09-20	Intersex	A+	\N	\N
RRZZ900530XQPCQS81	Eduardo	Castillo	Martínez	1990-05-30	Intersex	A-	5512920875	\N
IYBC750411HDQJLRK6	Daniel	Vázquez	Pérez	1975-04-11	M	O+	5508487297	paciente327@example.com
WDVB061129XHBGEJN2	Araceli	Ruiz	Medina	2006-11-29	Intersex	\N	5554296184	\N
IVNW401224XERGCUR3	Yolanda	Flores	Pérez	1940-12-24	Intersex	B-	5589262566	\N
VRNC151114XKUCLKR2	Raúl	González	Fuentes	2015-11-14	Intersex	A-	5516361128	paciente330@example.com
SJRI621124MTDBFKY2	Silvia	Rojas	Ruiz	1962-11-24	F	B-	5588967924	\N
SXIB911003XXULWYP9	Paola	Cruz	Cruz	1991-10-03	Intersex	AB+	5527578446	paciente332@example.com
JNYK400926XCUCCXP1	Leticia	Jiménez	Pérez	1940-09-26	Intersex	A+	5514870682	paciente333@example.com
TGXA240628XWNWRXW3	Daniela	Fuentes	Castillo	2024-06-28	Intersex	\N	5509728321	paciente334@example.com
MFLD810414HKVHRYH4	Arturo	Ruiz	Alvarado	1981-04-14	M	B+	5543096348	paciente335@example.com
LATO200730HKJLDAW2	Adrián	Contreras	Rojas	2020-07-30	M	AB+	5516731882	paciente336@example.com
PMLJ050615MLNFRZR1	María	Cruz	Torres	2005-06-15	F	AB-	5572256053	\N
BFVG441127MPVIDN58	Guadalupe	Ramírez	Ramos	1944-11-27	F	AB-	5525686211	paciente338@example.com
VKNT210125HXANPJS7	Miguel	Ruiz	Reyes	2021-01-25	M	O-	5539282341	paciente339@example.com
XQTF621101XGSUUEO1	Raúl	Alvarado	Rodríguez	1962-11-01	Intersex	A+	5543260931	paciente340@example.com
HHKN371022MPBQNUD4	Daniela	Herrera	Solís	1937-10-22	F	O-	5545635020	\N
TDNF000808XIPLKJH1	Elena	Chávez	Guzmán	2000-08-08	Intersex	O+	5525559895	\N
UXTD140112MBSUGG21	Claudia	Delgado	Rodríguez	2014-01-12	F	O-	5595473820	\N
LLOU380404MWDNCP08	Elena	Torres	Salazar	1938-04-04	F	\N	5529424090	paciente344@example.com
QCFO470831XYQMRYY6	Roberto	Castillo	Fuentes	1947-08-31	Intersex	B+	5502939087	paciente345@example.com
WIRD990224XFHBRHS0	Laura	Torres	Jiménez	1999-02-24	Intersex	A+	5542403381	\N
WRIX180409MENTJKD0	Cecilia	Estrada	Chávez	2018-04-09	F	B-	5542408916	paciente347@example.com
OHKI070330MGSUZYZ2	Yolanda	Solís	Salazar	2007-03-30	F	AB-	5565271727	\N
JAJF670823HFMVTGE2	Francisco	Cabrera	Gómez	1967-08-23	M	O-	5576182091	paciente349@example.com
BEHY411119HCIEUTA0	Carlos	García	Cordero	1941-11-19	M	O-	5551327972	paciente350@example.com
RDAB690611MDRJDQ02	Patricia	Reyes	Díaz	1969-06-11	F	O+	5503662543	paciente351@example.com
DJLC050805XTKDLCC9	Gerardo	Sánchez	Sánchez	2005-08-05	Intersex	A+	5585926249	paciente352@example.com
LIZW660516MZCZAEJ5	Araceli	Rodríguez	Rojas	1966-05-16	F	A+	5571196421	paciente353@example.com
PWNT870918HZUKEZP6	Jorge	Aguilar	Rojas	1987-09-18	M	AB+	5588788361	paciente354@example.com
CHLA620830MGALRPI1	Rosa	Cabrera	Jiménez	1962-08-30	F	O+	5552472863	\N
XAWN911116HLBWDVE7	Juan	Ramírez	Cruz	1991-11-16	M	A+	\N	paciente356@example.com
NEYF510307HPXEXQT7	Antonio	González	\N	1951-03-07	M	AB+	5570412009	paciente357@example.com
ORWI640927XSQJWH12	Ricardo	García	Alvarado	1964-09-27	Intersex	B+	5586236903	paciente358@example.com
KUUM821128XMFBZL13	Verónica	Estrada	Contreras	1982-11-28	Intersex	B+	5515950342	paciente359@example.com
JGRG440216HUBHICC9	Francisco	Estrada	\N	1944-02-16	M	AB-	\N	paciente360@example.com
GKYM801110MXLEWVG5	María	Ruiz	Castillo	1980-11-10	F	AB+	5581820967	paciente361@example.com
UCWH180903HGZVUEK8	Manuel	Flores	Contreras	2018-09-03	M	\N	5598572545	paciente362@example.com
CESU710417MPDZAET8	Guadalupe	Aguilar	Peña	1971-04-17	F	O-	5575242149	paciente363@example.com
PIYO020806HUEDSPC5	Luis	Gómez	Contreras	2002-08-06	M	B+	5592758955	\N
UBXZ700122MHWRAEG4	Rosa	Vargas	López	1970-01-22	F	AB+	5561367157	paciente365@example.com
DMYN600202XGMKCKV9	Yolanda	Contreras	Gómez	1960-02-02	Intersex	AB-	5571470827	\N
YMBZ711024HLZNPGD3	Ricardo	Cabrera	\N	1971-10-24	M	O+	5564421214	paciente367@example.com
VIFB060713MCNKYJK3	Yolanda	Vargas	Herrera	2006-07-13	F	B-	5577826596	paciente368@example.com
EKVX700606XXXXKAJ7	Cecilia	Estrada	Delgado	1970-06-06	Intersex	A+	5551648072	paciente369@example.com
GNWR581102XYFTMGW3	Adriana	Rodríguez	\N	1958-11-02	Intersex	A-	5590550448	paciente370@example.com
NLLR880804HNQYKDL7	Iván	Rojas	Contreras	1988-08-04	M	AB+	5589286646	paciente371@example.com
UATN170911XDPXYT81	Gabriela	Rodríguez	Rodríguez	2017-09-11	Intersex	AB-	5504633786	\N
UWZX880909MMALZH64	Laura	Ruiz	Contreras	1988-09-09	F	B+	5544630600	\N
KFSN970404MHRMGTZ0	Leticia	Herrera	Estrada	1997-04-04	F	AB+	5562658263	\N
YUIR500208HFKGCCB6	Arturo	Sánchez	Castillo	1950-02-08	M	O+	5592098196	\N
HUHJ081231XGRHXYY4	Alejandro	Contreras	Ruiz	2008-12-31	Intersex	O+	5520911791	\N
LGMD491218MPZANC51	Mónica	Gómez	Rojas	1949-12-18	F	A-	5565722402	paciente377@example.com
PTTR940817XAFQXIH3	Mónica	López	Ramos	1994-08-17	Intersex	O+	5588235130	paciente378@example.com
CLWR071112HUJOXZ56	Luis	Ramírez	Guzmán	2007-11-12	M	\N	5534234619	paciente379@example.com
ONTX861107XIKTDTY6	Andrés	Flores	Rojas	1986-11-07	Intersex	A-	5551720849	paciente380@example.com
MADF940219XZKNZFW3	Miriam	Cordero	Herrera	1994-02-19	Intersex	O-	5555251050	paciente381@example.com
CMJT750509HGQGDRR9	Sergio	Cabrera	Jiménez	1975-05-09	M	O-	5566553307	paciente382@example.com
KSMH711013MSAJAUA7	Daniela	Sánchez	Flores	1971-10-13	F	B+	5560880501	paciente383@example.com
CRYK891027MPTBMJ37	Diana	Gutiérrez	Ruiz	1989-10-27	F	O-	5591030021	paciente384@example.com
XZLR080803XAWBIZC1	Rosa	Alvarado	Pérez	2008-08-03	Intersex	O+	5514596422	paciente385@example.com
NUOV460202HDQQHS47	Miguel	Chávez	Delgado	1946-02-02	M	B+	5573144158	paciente386@example.com
CCPB630523HGAVGOY3	Hugo	Cordero	Vázquez	1963-05-23	M	AB-	5539885472	paciente387@example.com
OTQG910223HYMGCI12	Adrián	Ramírez	Mendoza	1991-02-23	M	B+	5591271130	paciente388@example.com
LIDR850216HCLNGEZ8	Alejandro	Martínez	Herrera	1985-02-16	M	AB+	5507451066	\N
PQND710330HVBUHDO1	Roberto	Gómez	Herrera	1971-03-30	M	O+	5594318143	paciente390@example.com
XWIP060104XGFZGLS9	Paola	Castillo	Rodríguez	2006-01-04	Intersex	B+	5512897432	paciente391@example.com
AVPN130105HKAFICK0	Jorge	Gómez	Contreras	2013-01-05	M	B-	5590737100	paciente392@example.com
EYDD580102MJZXKO55	Leticia	Jiménez	Flores	1958-01-02	F	\N	5574570545	paciente393@example.com
QXUA640319XENHVEW7	Beatriz	Estrada	Díaz	1964-03-19	Intersex	O+	5565313614	paciente394@example.com
IVLK100116XMSNIJM0	Patricia	Vargas	Herrera	2010-01-16	Intersex	\N	5591679541	paciente395@example.com
JTRV781020MFJPJCS0	Lucía	Cruz	Cruz	1978-10-20	F	AB-	\N	\N
LVAB870218XIELJZ68	Antonio	Hernández	García	1987-02-18	Intersex	A+	5542369143	\N
DIJT381229MJFSNVU9	Adriana	Solís	Castillo	1938-12-29	F	A+	5534268344	\N
NDEQ550719XOWKQVW7	Alejandra	Contreras	Aguilar	1955-07-19	Intersex	B-	5566708061	paciente399@example.com
LETR791015XSJBYMI6	Araceli	Gutiérrez	Delgado	1979-10-15	Intersex	O+	5587010415	paciente400@example.com
XSVQ141104MXWBWG72	Silvia	Guzmán	Hernández	2014-11-04	F	\N	5572324407	paciente401@example.com
DQDH710727HGDPAQ26	Carlos	González	\N	1971-07-27	M	O+	5546723849	paciente402@example.com
FEXV231018XHFQXW83	Gabriela	Sánchez	Solís	2023-10-18	Intersex	AB-	5541975466	paciente403@example.com
JODS230325HMASJB20	Sergio	Romero	Cruz	2023-03-25	M	B-	5577402588	\N
ELUX661122XSKOWZI4	Laura	Aguilar	Gómez	1966-11-22	Intersex	B+	5517679298	paciente405@example.com
SLST400117XMCBAXK3	Arturo	Ramírez	Delgado	1940-01-17	Intersex	O-	5577533126	paciente406@example.com
XCOY220519MLTUAFU1	Ana	Hernández	Sánchez	2022-05-19	F	AB-	5598334774	\N
SAUV180108XDGBZEA5	Ricardo	Alvarado	Morales	2018-01-08	Intersex	AB+	5515287339	paciente408@example.com
EZCO490305XNUMCSF2	Iván	Ruiz	Salazar	1949-03-05	Intersex	\N	5517309850	\N
FJCR190823MSHQTQT6	Leticia	Torres	Ruiz	2019-08-23	F	O+	5519740056	\N
XKYV520618MBHPCZC5	Araceli	Hernández	Salazar	1952-06-18	F	O-	5599187240	\N
JZHA821122MBAYZZM8	Rosa	Jiménez	Alvarado	1982-11-22	F	AB+	5508706626	paciente412@example.com
LLGK370804XNBHHCA3	Alejandro	Sánchez	Peña	1937-08-04	Intersex	AB+	5589003010	\N
HJET661216HMPVDVE1	Manuel	López	Estrada	1966-12-16	M	B+	5537537458	\N
RQDB630220XLNWTPR1	Raúl	Herrera	Chávez	1963-02-20	Intersex	A-	5583483152	\N
DAPB400327HIISMJF0	Iván	Vargas	Contreras	1940-03-27	M	B+	5567066703	\N
RYLA221206HTYKIZN0	Hugo	Alvarado	Gutiérrez	2022-12-06	M	B-	5596601864	paciente417@example.com
QIFM560930XOXHEAR4	Adrián	Alvarado	Cabrera	1956-09-30	Intersex	O-	5584596094	paciente418@example.com
DJSV240818XKIFOOB7	Arturo	Cordero	Estrada	2024-08-18	Intersex	O+	5557836091	\N
IYZI090810XIPEHUL2	Verónica	Chávez	Vargas	2009-08-10	Intersex	O+	5502879508	paciente420@example.com
LRWB641116HTHLDC67	Iván	Torres	Martínez	1964-11-16	M	O-	5533595616	paciente421@example.com
NULP950908HJTAFLC4	José	Chávez	Mendoza	1995-09-08	M	A+	5501935889	paciente422@example.com
EMYU600731HCCHSQ96	Roberto	Delgado	\N	1960-07-31	M	\N	5580978875	\N
OKXD050109XWHOXNX1	Daniel	Reyes	Mendoza	2005-01-09	Intersex	B-	5515793763	paciente424@example.com
SVET650405HIZJKKH1	Adrián	Fuentes	Romero	1965-04-05	M	AB+	5529732702	\N
DEBN590204MAWFCE68	Beatriz	Salazar	Guzmán	1959-02-04	F	AB+	5552683415	paciente426@example.com
XLON190214MUOXNJ42	Silvia	Estrada	López	2019-02-14	F	A+	5598120995	paciente427@example.com
SIYD601201MHJPKB78	Fernanda	Chávez	Medina	1960-12-01	F	\N	5564565220	paciente428@example.com
TKDL740220XJFDJI57	Leticia	Vázquez	Díaz	1974-02-20	Intersex	A-	5544913421	\N
BRRZ441007XGAPALN4	Silvia	Flores	\N	1944-10-07	Intersex	AB+	5582741176	paciente430@example.com
LZCX381109HZHXCKK8	Diego	Ramírez	Sánchez	1938-11-09	M	B-	5581506185	\N
UAHE681024XSMHVGQ7	Fernanda	Solís	\N	1968-10-24	Intersex	A+	5527423183	\N
NWIT220404HMUSHUW7	Raúl	Salazar	Gómez	2022-04-04	M	\N	5524347769	paciente433@example.com
OKHV880204MNDFOKH5	Gabriela	Rodríguez	Ortiz	1988-02-04	F	AB+	5577963044	paciente434@example.com
KNMZ650307MONMIBR7	Guadalupe	Salazar	Torres	1965-03-07	F	A-	5504763928	\N
RAXA710619XZMCYWV5	Antonio	Peña	Ramírez	1971-06-19	Intersex	\N	\N	\N
RMWH500718HJZFLK03	Eduardo	Fuentes	Flores	1950-07-18	M	\N	5500081867	\N
IXDZ220916MMUMEXR1	Gabriela	Martínez	Reyes	2022-09-16	F	O-	\N	paciente438@example.com
RTED510403XXSZMGT5	Emilio	Martínez	\N	1951-04-03	Intersex	AB+	5504473149	paciente439@example.com
IPJW750530MRQHMA56	Daniela	Pérez	Romero	1975-05-30	F	B-	5517390637	paciente440@example.com
UCDR530205XFGPSHF2	Francisco	Cordero	Cruz	1953-02-05	Intersex	AB+	5578930746	paciente441@example.com
STNA631204MIWGYR58	Leticia	Cruz	\N	1963-12-04	F	AB-	5535778811	paciente442@example.com
XDFG790203HODBNPK8	Roberto	Ramírez	Flores	1979-02-03	M	AB-	5586604164	paciente443@example.com
UFEJ750227XQVGZTX8	Javier	Herrera	Mendoza	1975-02-27	Intersex	B+	5535228705	paciente444@example.com
WGGW971005HDROKDD9	Raúl	González	García	1997-10-05	M	AB-	5515835034	\N
IRRU411201MVGCSEG3	Silvia	Gutiérrez	Castillo	1941-12-01	F	B+	5591289659	paciente446@example.com
PGFA651006XZHGCZJ2	Mónica	Díaz	Peña	1965-10-06	Intersex	A+	5505102876	paciente447@example.com
MMYM750627MWPLJQU8	Gabriela	Medina	Reyes	1975-06-27	F	O-	5532426877	paciente448@example.com
LFAL670328MOYVLX13	Lucía	Sánchez	Alvarado	1967-03-28	F	\N	5536520375	paciente449@example.com
IQAT430730HIBUIU46	Daniel	Gutiérrez	Mendoza	1943-07-30	M	O+	5544090797	paciente450@example.com
LATW220424MEWXFEF6	Diana	Cordero	Rodríguez	2022-04-24	F	O-	\N	paciente451@example.com
GUTX370706HAKVKWK9	Ricardo	Rodríguez	Díaz	1937-07-06	M	B-	5566013824	\N
FUXA890108MJIRLDV7	Guadalupe	Díaz	Medina	1989-01-08	F	O-	5571112125	paciente453@example.com
LOCX680703HHJVUGI4	Gerardo	Flores	Vázquez	1968-07-03	M	O+	5542429563	paciente454@example.com
WOIC020621MPLSLL77	Araceli	Morales	Ortiz	2002-06-21	F	A+	\N	paciente455@example.com
UZVZ940813MJGKWQ94	Patricia	Fuentes	Alvarado	1994-08-13	F	O-	5534374018	paciente456@example.com
SMVS920504HBKWDUW0	Raúl	Ramírez	Chávez	1992-05-04	M	A+	5555125427	paciente457@example.com
NXMP630607HHIXLTV7	Sergio	Peña	Cabrera	1963-06-07	M	AB+	5538166496	paciente458@example.com
WQGS390222HYEEVKD1	Arturo	Flores	Estrada	1939-02-22	M	B+	5525762702	\N
GNCX481013HHEVRYX0	Manuel	Gutiérrez	Reyes	1948-10-13	M	AB-	5517863767	paciente460@example.com
YKJV891111HXNTMRE5	Roberto	Ramírez	Ramírez	1989-11-11	M	AB-	5590392355	paciente461@example.com
HEPG671027HBGJNCV6	Andrés	Estrada	González	1967-10-27	M	A+	5544670462	\N
VXDU940902XMZZAFU2	Laura	Rodríguez	Pérez	1994-09-02	Intersex	\N	5570766046	\N
LYPW800911XKRLDZL6	Antonio	Estrada	Vargas	1980-09-11	Intersex	\N	5512059438	paciente464@example.com
BDPO000618XLBTVLQ6	Carmen	Contreras	Contreras	2000-06-18	Intersex	B-	5508424560	paciente465@example.com
BRXM600128MHFCRDI2	Cecilia	López	Ruiz	1960-01-28	F	AB-	5545793897	\N
DMQX521105MCKUXJ16	Sofía	López	Solís	1952-11-05	F	O+	5541613944	paciente467@example.com
SPGY920301XNIXWYL4	Beatriz	Reyes	Hernández	1992-03-01	Intersex	\N	5596244063	\N
ZUKD711229MHHAWKO1	Lucía	Ramírez	Contreras	1971-12-29	F	B+	5597969586	paciente469@example.com
OEOX511209XPGRWFY4	José	Ramos	Ruiz	1951-12-09	Intersex	AB+	\N	paciente470@example.com
GXQL180414HJJYKO30	Óscar	Rojas	Ruiz	2018-04-14	M	A+	5529596604	paciente471@example.com
TDDM911015MGGDSJL2	Adriana	Aguilar	Ramírez	1991-10-15	F	AB+	5553694551	paciente472@example.com
MHMP771218XYOJOFL6	Alejandra	Solís	Fuentes	1977-12-18	Intersex	B+	\N	paciente473@example.com
SUNN910507MNGUATO2	Cecilia	Gómez	Rodríguez	1991-05-07	F	\N	5599605932	paciente474@example.com
TZUM590131MRQGFOX3	Lucía	Pérez	Martínez	1959-01-31	F	A+	5535241039	paciente475@example.com
FOQU540404HDZTKFP7	Hugo	Estrada	Reyes	1954-04-04	M	O-	\N	\N
ZNIW190605XRDWYT80	Emilio	Herrera	Aguilar	2019-06-05	Intersex	AB-	5504605687	paciente477@example.com
ZDXF580217HLNVKEP7	Carlos	Cruz	Delgado	1958-02-17	M	A-	5551773454	paciente478@example.com
TBYE010115MEQJAHX9	Carmen	Vargas	Cabrera	2001-01-15	F	B-	5542947742	paciente479@example.com
UHAG020827XSJESAQ5	Alejandro	Cruz	Aguilar	2002-08-27	Intersex	\N	5586792529	paciente480@example.com
FQPF670727MPMAVCV3	Rosa	Mendoza	Rojas	1967-07-27	F	B+	5524913577	paciente481@example.com
HXGL450228XVBMUDV8	Araceli	García	Herrera	1945-02-28	Intersex	O-	5588107983	\N
WOFB631113XTIRICM1	Eduardo	Cordero	Jiménez	1963-11-13	Intersex	A+	5503339977	\N
OCPG150418HDRSGT54	Ricardo	Solís	Guzmán	2015-04-18	M	O+	5517399704	paciente484@example.com
PQJU800324XJIRHKR8	Javier	Rojas	Ramos	1980-03-24	Intersex	\N	5571270587	paciente485@example.com
OKUV420922HRFGYDO3	Luis	Alvarado	Rodríguez	1942-09-22	M	B+	5558714939	paciente486@example.com
FTVF490408MKQPUT04	Verónica	Morales	Flores	1949-04-08	F	A-	5574524555	paciente487@example.com
MBNL570510MUZEOYR0	Silvia	Castillo	García	1957-05-10	F	A-	5544505665	paciente488@example.com
IDCH481127XFKXPX40	Roberto	Vázquez	Vargas	1948-11-27	Intersex	AB+	5573499601	\N
PEXC151011MKYXNEJ9	Mónica	Fuentes	Ortiz	2015-10-11	F	B+	5581735984	paciente490@example.com
ZWWX470816MKLYOXN2	Miriam	Martínez	González	1947-08-16	F	B-	5575534490	\N
BQBQ540219XLASNB65	Emilio	Alvarado	Rojas	1954-02-19	Intersex	\N	5595119181	paciente492@example.com
UGYC710104XYVNIO22	Beatriz	Pérez	Contreras	1971-01-04	Intersex	B-	\N	paciente493@example.com
AMSJ451212MATMAAO5	Karla	Herrera	Alvarado	1945-12-12	F	AB+	5539587395	paciente494@example.com
JFDA070331XRTBYE85	Carmen	Cabrera	Cruz	2007-03-31	Intersex	O-	5553334264	\N
ODMA470101HOXXGMD7	Gerardo	Ruiz	\N	1947-01-01	M	AB-	5536911289	paciente496@example.com
TLXK590417HNGGCZ65	Jorge	Vázquez	Rojas	1959-04-17	M	AB-	5517006661	paciente497@example.com
HWCU981005MUZMPAR5	Leticia	González	Cordero	1998-10-05	F	O+	5532902822	paciente498@example.com
TNFN920523HFFQEXL5	Juan	Estrada	Ortiz	1992-05-23	M	O-	5507346549	paciente499@example.com
ENBR591021HMYTXQK2	Ricardo	Martínez	López	1959-10-21	M	O-	\N	paciente500@example.com
NROE840127HTZUAJ47	Fernando	González	Guzmán	1984-01-27	M	B+	5585917793	\N
DWMJ590124XTDHHIL4	Alejandro	Cruz	Pérez	1959-01-24	Intersex	B-	5579889425	paciente502@example.com
ZMUB580821XZGFAEC3	Manuel	Delgado	López	1958-08-21	Intersex	A+	5509775396	paciente503@example.com
XIUY150303HQKKFIV7	Sergio	Peña	Vargas	2015-03-03	M	\N	5515841560	paciente504@example.com
RWJE141212HLJONRF8	Carlos	Jiménez	Sánchez	2014-12-12	M	A+	5583230358	paciente505@example.com
RHWQ930315HFLFDVK9	Daniel	Herrera	Fuentes	1993-03-15	M	A-	5528963406	\N
JACI610102XWRVJGE0	Emilio	Guzmán	Ramírez	1961-01-02	Intersex	AB+	5572362669	\N
MDXX130220MSVEGOJ4	Ana	Jiménez	Díaz	2013-02-20	F	B-	\N	\N
HVOJ830622MDRXTOJ1	Rosa	Rodríguez	Estrada	1983-06-22	F	B-	5506417692	paciente509@example.com
DCXT781031XTLHVP16	Carmen	Rojas	Jiménez	1978-10-31	Intersex	O+	5544485645	\N
SNVI051116HDYWPRY9	Iván	Rojas	Rojas	2005-11-16	M	\N	5560919191	\N
MWXB871123HLUZOO70	Eduardo	Delgado	Estrada	1987-11-23	M	AB+	5560392051	\N
VLLH930726MIOZBK34	Carmen	Martínez	Torres	1993-07-26	F	A+	5585652715	paciente513@example.com
XCUM160825XKTPUFY3	Elena	Jiménez	Gutiérrez	2016-08-25	Intersex	B+	5575575225	\N
JYRR750616HFMTWCM1	Daniel	Gutiérrez	Cordero	1975-06-16	M	O-	5564258562	paciente515@example.com
HOBH960907HREVIA53	Diego	Ortiz	Pérez	1996-09-07	M	A-	5537320430	paciente516@example.com
GNFQ741009MSMUSMQ5	Leticia	Vargas	Salazar	1974-10-09	F	B+	5553585125	paciente517@example.com
ZQWP370923XRKDZTO5	Raúl	Fuentes	Rodríguez	1937-09-23	Intersex	\N	5537490797	paciente518@example.com
RUBL850703MPWECVW1	Ana	Flores	\N	1985-07-03	F	B+	5509762637	paciente519@example.com
QNEY540209XRVSKAD5	Daniela	Gutiérrez	Cabrera	1954-02-09	Intersex	O-	5519186233	paciente520@example.com
PXDK420530HCDMSWY6	Emilio	Gómez	\N	1942-05-30	M	AB+	5525214526	paciente521@example.com
LUUC050528MKOYDQQ0	Ana	Gómez	Morales	2005-05-28	F	O+	5505120800	paciente522@example.com
FGUT391231MPFRGLG2	María	Cabrera	González	1939-12-31	F	B-	5572827090	paciente523@example.com
VFSQ940604HFDPGTJ9	Pablo	Gutiérrez	Rodríguez	1994-06-04	M	B-	5586718153	paciente524@example.com
LBPZ220103HVWYSD71	Emilio	Rojas	Castillo	2022-01-03	M	B-	5599886834	paciente525@example.com
MNMC870629MPAPDK97	Beatriz	Morales	Solís	1987-06-29	F	AB+	5540803149	paciente526@example.com
ABJM771021XGLRBV18	Patricia	Gómez	Hernández	1977-10-21	Intersex	\N	5585031723	paciente527@example.com
TABM680413HGWDJAP5	Iván	Vázquez	Cabrera	1968-04-13	M	A+	5535602293	paciente528@example.com
GUXI971213MNWANNY4	Araceli	Alvarado	Solís	1997-12-13	F	A-	5574906072	paciente529@example.com
ZPCF441018HRKFXIZ4	Luis	Solís	Flores	1944-10-18	M	\N	5594116318	paciente530@example.com
DDHB821013HMFCYWE3	Miguel	Herrera	Guzmán	1982-10-13	M	AB+	5572790833	paciente531@example.com
IFLO480818HGUBMMJ4	Daniel	García	Ramos	1948-08-18	M	\N	\N	\N
CHTQ860320HJRFERU0	Ricardo	Vargas	\N	1986-03-20	M	O-	5568809255	\N
SBMY250606HSDHYUC9	Hugo	Jiménez	\N	2025-06-06	M	\N	\N	paciente534@example.com
OXHV910115MPTILU37	Silvia	Cordero	Peña	1991-01-15	F	A+	5553242642	paciente535@example.com
WRHM881202HEULGM06	Fernando	Gutiérrez	Contreras	1988-12-02	M	AB-	5576755562	paciente536@example.com
XVZT080412HLORYZ05	Antonio	Vázquez	Cabrera	2008-04-12	M	B+	5527187496	\N
QNFO410831HAWGMSL4	Ricardo	Salazar	Aguilar	1941-08-31	M	A+	5593265732	paciente538@example.com
XUBV780219MDZCCAA0	Alejandra	Peña	Peña	1978-02-19	F	B-	5555323415	paciente539@example.com
JDZR990929MFEFND89	Silvia	Vargas	Gómez	1999-09-29	F	AB+	5587431271	paciente540@example.com
YASW100612HLOSSF20	Mario	Aguilar	Guzmán	2010-06-12	M	AB-	5595515122	paciente541@example.com
UKJW390622XZZCLT50	Pablo	Cruz	Morales	1939-06-22	Intersex	AB+	5554384807	paciente542@example.com
ONKB020218HIXYVOF5	Juan	Cordero	Gutiérrez	2002-02-18	M	\N	\N	paciente543@example.com
GPMM910803XBWVIWY5	José	Cabrera	\N	1991-08-03	Intersex	B-	5566525483	paciente544@example.com
VKQD530623MAZEZYG3	Ana	Vargas	Pérez	1953-06-23	F	O-	5512931100	paciente545@example.com
OUKZ690726MVDTDBI3	Yolanda	Peña	Delgado	1969-07-26	F	O-	5510633016	paciente546@example.com
WFPJ710603XXVSBOL8	Roberto	Guzmán	Rojas	1971-06-03	Intersex	O+	\N	paciente547@example.com
DWYC621210MGFKYHK6	Patricia	Fuentes	Morales	1962-12-10	F	B+	5584364538	\N
CPLX200317XBTYNC20	Arturo	Ortiz	González	2020-03-17	Intersex	O-	5559194575	paciente549@example.com
RXGH970813MSFBWL07	Sofía	Rojas	Rojas	1997-08-13	F	AB-	5567772266	paciente550@example.com
MLAN120502HZVFESL3	Pablo	Chávez	Solís	2012-05-02	M	O-	\N	paciente551@example.com
FJRI900720MHGPTX56	Alejandra	Morales	\N	1990-07-20	F	AB+	5527051157	paciente552@example.com
PAJU880521HFKUJV19	Antonio	Herrera	Vázquez	1988-05-21	M	O-	5584552597	\N
HKUP631228MZIRKSV3	Sofía	Romero	Chávez	1963-12-28	F	A+	5593993379	paciente554@example.com
ETKC580608HQPOTXR1	Ricardo	Medina	Aguilar	1958-06-08	M	AB-	5534250733	paciente555@example.com
IKPK550607MTRGZUM9	Sofía	Peña	Cruz	1955-06-07	F	O-	5503884366	paciente556@example.com
AUUY230621HNCLOYJ7	Manuel	Torres	Ortiz	2023-06-21	M	AB+	5597514743	paciente557@example.com
ADBK391218MRPLEKY8	Gabriela	Flores	Chávez	1939-12-18	F	O+	5556259045	paciente558@example.com
CCEE810306XDQFWHF5	Luis	Medina	Ramírez	1981-03-06	Intersex	B-	5565176808	paciente559@example.com
GOFD520904MYIHHB90	Miriam	Cruz	Pérez	1952-09-04	F	O+	5537003322	paciente560@example.com
YJPA791218MVWWNRE0	Fernanda	Solís	Martínez	1979-12-18	F	A-	5533970519	paciente561@example.com
AUXT770818XJIRLQY2	Yolanda	Flores	Cruz	1977-08-18	Intersex	A-	5545354614	paciente562@example.com
FDBM070520MZDXGGT3	Teresa	Cordero	Castillo	2007-05-20	F	B+	5503943804	\N
KOMT610223HYFPPRS3	Diego	Ramos	Aguilar	1961-02-23	M	O-	5500900404	paciente564@example.com
UGNX060603XLCINUB4	Claudia	Flores	Mendoza	2006-06-03	Intersex	O+	5542473107	\N
RIIA630524HWSPCXJ3	Luis	Reyes	Delgado	1963-05-24	M	O-	5560076762	paciente566@example.com
JXPG620118XZIAVIM3	Yolanda	López	Díaz	1962-01-18	Intersex	AB-	5509687304	paciente567@example.com
LVLX110113XRREKXW6	Rodrigo	Contreras	Fuentes	2011-01-13	Intersex	A+	5557542786	paciente568@example.com
LUOO951118MYRVFBV8	Ana	Estrada	Ramírez	1995-11-18	F	A+	5582923616	paciente569@example.com
IRVF250517XXHVWZV7	Patricia	López	Cabrera	2025-05-17	Intersex	O-	5558686395	paciente570@example.com
EWYG850114XWAZQZG7	Silvia	Rodríguez	Cordero	1985-01-14	Intersex	A+	5543643813	\N
IODN190922HLVMAWT5	Manuel	Sánchez	González	2019-09-22	M	AB+	5546997990	paciente572@example.com
PZMY621118HRYDNWW7	Raúl	Chávez	Torres	1962-11-18	M	O+	5571748113	paciente573@example.com
TPBK040131XJRYWON9	Alejandra	Rodríguez	Ramos	2004-01-31	Intersex	AB+	\N	paciente574@example.com
QFOI190716XWSMZRD4	Carmen	Martínez	Vargas	2019-07-16	Intersex	O-	5572742049	paciente575@example.com
PPHA071116HMYXZUL6	Hugo	Cruz	González	2007-11-16	M	O+	5535973711	\N
LZWN810324HAWQWL81	Rodrigo	Estrada	Vargas	1981-03-24	M	AB+	5546861114	paciente577@example.com
EDAF440526XCSFVG28	Iván	Guzmán	Reyes	1944-05-26	Intersex	B-	5571296180	\N
LBQZ240925HADQVI70	Manuel	Ramírez	Castillo	2024-09-25	M	B+	5525373377	paciente579@example.com
ZCEV770302HEQEYC48	Jorge	Aguilar	Solís	1977-03-02	M	O-	5536534606	\N
XLMO650625MTHXEP66	Beatriz	Castillo	\N	1965-06-25	F	A+	5584716906	\N
IMIO920802HUZKJRU4	Iván	Cruz	López	1992-08-02	M	AB-	5569899927	paciente582@example.com
CIUI690204XIJTQHU5	Guadalupe	Ramos	Peña	1969-02-04	Intersex	A-	5554358644	paciente583@example.com
YWJG531007XVVLWR95	Fernanda	Morales	Ramírez	1953-10-07	Intersex	A-	5598214339	paciente584@example.com
MPWI030914MSORKEQ9	Verónica	Cordero	Mendoza	2003-09-14	F	O-	5568601347	paciente585@example.com
IBNU071113XPTDPNY5	Adriana	Díaz	Romero	2007-11-13	Intersex	O-	5515001418	paciente586@example.com
BVSB070511HADKTXR4	Pablo	Rodríguez	Alvarado	2007-05-11	M	AB+	5539994853	\N
MGRT530615XAFCSXR7	Adriana	Chávez	Flores	1953-06-15	Intersex	O-	\N	paciente588@example.com
HIDA430601HHVJNSY7	Antonio	Contreras	Gómez	1943-06-01	M	A-	5516772696	\N
KAPQ950111MTMOTGX2	Claudia	Rojas	Herrera	1995-01-11	F	O-	5562633556	\N
AVSH390722XUWCOWB6	Daniel	Jiménez	Guzmán	1939-07-22	Intersex	B-	5507676164	paciente591@example.com
SUQT060129MQZGBMX0	Sofía	Torres	Flores	2006-01-29	F	A-	\N	paciente592@example.com
IOEJ780813HENIFH04	Andrés	Salazar	Pérez	1978-08-13	M	A+	5531909248	paciente593@example.com
WCCY710903MDIZFRH7	Araceli	Flores	Morales	1971-09-03	F	\N	5522823052	paciente594@example.com
EFBP900529XEEHTLR7	Miriam	Martínez	Hernández	1990-05-29	Intersex	A-	5513290162	\N
RXMQ760514MOUQLZZ4	Rosa	Rojas	Castillo	1976-05-14	F	\N	5528720319	paciente596@example.com
JLAK920105MPGYAG12	Laura	Estrada	Aguilar	1992-01-05	F	AB-	5524632037	\N
ENBH840304MEUDJLD5	Karla	Contreras	Vázquez	1984-03-04	F	AB-	5561945887	\N
QFAD430109MEXWRID0	Ana	Ruiz	Gutiérrez	1943-01-09	F	\N	5585076597	paciente599@example.com
DOYP730314MNYQBV99	Gabriela	Mendoza	Herrera	1973-03-14	F	\N	\N	paciente600@example.com
EEYG011010MCTMIMO0	Alejandra	Vargas	Solís	2001-10-10	F	O+	5523693626	paciente601@example.com
BIXP480908MZCHOF51	Claudia	García	Flores	1948-09-08	F	O-	5559574988	paciente602@example.com
VVWS111012XQVIZTP3	Hugo	Solís	Herrera	2011-10-12	Intersex	O+	5545847609	paciente603@example.com
HOED460921MWRQLNZ6	Laura	Cruz	Jiménez	1946-09-21	F	B-	5532971506	paciente604@example.com
LDJH951017MPPMSGZ6	Patricia	Romero	Martínez	1995-10-17	F	A-	5592529596	paciente605@example.com
RNPC120411HZZWUED0	Luis	Pérez	García	2012-04-11	M	AB-	5524559102	paciente606@example.com
BTAG370131MZFMPDR9	Laura	López	Pérez	1937-01-31	F	B+	5581942179	paciente607@example.com
WJBM050829HKVFWP25	Óscar	Medina	Estrada	2005-08-29	M	\N	5566345337	\N
DOEE120627HXCJYKU9	Juan	Pérez	Sánchez	2012-06-27	M	A-	5566189437	paciente609@example.com
BZIM210508MFPOVMU7	Verónica	Castillo	González	2021-05-08	F	A+	5565920246	\N
TPIG790926MXFNBYA5	Patricia	López	Reyes	1979-09-26	F	B-	5555017833	\N
QSTT451206XGNYXZC7	Fernanda	Medina	Castillo	1945-12-06	Intersex	\N	5570450691	paciente612@example.com
SHOI501105MJUBHVQ6	Karla	Estrada	Chávez	1950-11-05	F	B+	\N	\N
BCZZ870228HIRRNA64	Emilio	Vargas	García	1987-02-28	M	O+	5593884136	paciente614@example.com
NCKU640411MHPADEQ2	Verónica	Fuentes	García	1964-04-11	F	B+	5562632514	paciente615@example.com
EDAH370726XCYYZYR2	Karla	Salazar	González	1937-07-26	Intersex	O-	5551887817	paciente616@example.com
FMZG940118MRIXATF1	Carmen	Pérez	Pérez	1994-01-18	F	A+	5528837505	paciente617@example.com
FGTU060908MPYSXWE3	Laura	Medina	Castillo	2006-09-08	F	AB-	5576553007	\N
KNXA670716XKOCED78	Iván	Martínez	Mendoza	1967-07-16	Intersex	O-	5577885190	paciente619@example.com
BDBJ990531XVEWIMJ4	Óscar	Reyes	Alvarado	1999-05-31	Intersex	B-	5518517446	\N
QTTD420306MLDDIYV5	Alejandra	Gómez	Ramírez	1942-03-06	F	O-	5539130448	paciente621@example.com
RVJD990128HMYBJNF5	Pablo	Salazar	Fuentes	1999-01-28	M	B+	5521190170	paciente622@example.com
RZHC720923MKFFUSG0	Fernanda	Fuentes	Flores	1972-09-23	F	AB-	5522836084	paciente623@example.com
NGTV200530XMGQJLI6	Teresa	Morales	Reyes	2020-05-30	Intersex	AB+	5544391649	paciente624@example.com
ESFU630920HSDVHEC3	Roberto	Delgado	Torres	1963-09-20	M	A-	5516234190	paciente625@example.com
OEEX070324XUZDLK06	Antonio	García	Ramos	2007-03-24	Intersex	\N	5573236533	paciente626@example.com
FBZB840224MXOQJG01	Daniela	Hernández	Alvarado	1984-02-24	F	B+	5542607819	paciente627@example.com
PMIF500605MPHOEAP7	Cecilia	Jiménez	Díaz	1950-06-05	F	AB+	5588214584	paciente628@example.com
CSDH231201MJIZHY99	Yolanda	Herrera	Castillo	2023-12-01	F	\N	5578020586	paciente629@example.com
YNIW610124HZISGUZ9	Raúl	Morales	Gutiérrez	1961-01-24	M	B-	\N	paciente630@example.com
PYHR930920HKPHNRB1	Mario	Reyes	Ramos	1993-09-20	M	O-	5523603768	paciente631@example.com
XGGL051208HDBIAS01	Carlos	Salazar	Ramírez	2005-12-08	M	B+	5573153911	paciente632@example.com
PWIR211010XFVYWXA7	Patricia	Solís	Reyes	2021-10-10	Intersex	A-	5551189394	\N
FAXD630421XUSAVIM2	Iván	Ruiz	Salazar	1963-04-21	Intersex	A+	5502333247	\N
XGLU600817MYYJVNJ1	Adriana	Peña	Sánchez	1960-08-17	F	A+	5502508261	\N
HWFI860930HWQWRV79	Francisco	González	Rodríguez	1986-09-30	M	B-	5529893762	paciente636@example.com
XZYA420823MGMJMY87	Mónica	Chávez	Vázquez	1942-08-23	F	O-	5512038187	paciente637@example.com
HZEH770519XBQTRCP8	Adriana	Ramírez	Gómez	1977-05-19	Intersex	\N	\N	paciente638@example.com
FBNP510612HGEZZHF8	Alejandro	Torres	Ramírez	1951-06-12	M	A+	5516815724	paciente639@example.com
VWAZ560307MXACKFF1	María	López	Martínez	1956-03-07	F	A-	5517850902	paciente640@example.com
JYJI671026MFCRET87	Fernanda	Sánchez	Medina	1967-10-26	F	B+	5512248905	paciente641@example.com
BAVI711225HHMLUKF5	Arturo	Alvarado	López	1971-12-25	M	\N	5526691362	paciente642@example.com
JFZS921119XMXBRWC7	Sergio	Chávez	Hernández	1992-11-19	Intersex	O+	5536998795	paciente643@example.com
ECBI090228HZBDMI71	Gerardo	Peña	Herrera	2009-02-28	M	\N	5504428773	paciente644@example.com
IHEV891117MCEWMTS2	Miriam	Morales	González	1989-11-17	F	\N	5546420362	paciente645@example.com
YICO971218XBMJUMK5	Beatriz	Herrera	Rodríguez	1997-12-18	Intersex	B-	5502635582	\N
ZIJQ881106XSQQAYO1	Juan	Pérez	Gutiérrez	1988-11-06	Intersex	B-	5588245279	paciente647@example.com
UBJH640214HGGGYLM8	Hugo	Ramos	\N	1964-02-14	M	B+	5516321119	paciente648@example.com
GHSC380319MUVGPGI6	Diana	Sánchez	Estrada	1938-03-19	F	B-	5506011987	paciente649@example.com
NYRX480923MQAAFGB0	Fernanda	Rodríguez	Medina	1948-09-23	F	O-	5561829803	paciente650@example.com
JTDX600424MNATVGZ5	Paola	Solís	Torres	1960-04-24	F	B-	5501491189	\N
KASE821130XYNGFXK3	Daniel	Jiménez	Herrera	1982-11-30	Intersex	\N	5537455611	\N
XBLU890315HAYZKH56	Iván	Ortiz	Fuentes	1989-03-15	M	AB+	5508112600	paciente653@example.com
TCYA460520HMEVOCU3	Arturo	Vázquez	Castillo	1946-05-20	M	O-	5534550688	\N
YRUE870828XTGQIJC1	Francisco	Rojas	Rojas	1987-08-28	Intersex	A-	5580873543	paciente655@example.com
NBGH130629XULTXDD1	Araceli	Salazar	Herrera	2013-06-29	Intersex	B-	5509085991	paciente656@example.com
SZFM021103MYTWST09	Silvia	Gómez	Vargas	2002-11-03	F	AB+	5548997184	\N
EKSD030621MJAYQJM2	Silvia	Aguilar	Cabrera	2003-06-21	F	A-	5534266980	paciente658@example.com
DOYN680419XAUOFXN4	Juan	Salazar	Castillo	1968-04-19	Intersex	\N	5538935953	paciente659@example.com
ALNV510615XDEWST15	Alejandro	Salazar	Ortiz	1951-06-15	Intersex	O+	5526958264	\N
CGAR690309XPZNDVJ3	Gerardo	Cabrera	Romero	1969-03-09	Intersex	\N	5551434682	\N
AFPY490124MHAAVQ19	Yolanda	Medina	López	1949-01-24	F	AB+	5561016831	\N
CMQB210609HTUICJE5	Emilio	Peña	Martínez	2021-06-09	M	O+	5528397620	paciente663@example.com
OTJM860316HFBWOEZ6	Óscar	Díaz	Rojas	1986-03-16	M	A+	5550817760	paciente664@example.com
MQVR230913XICGGG33	Karla	Estrada	Torres	2023-09-13	Intersex	O-	5555235617	paciente665@example.com
DCTF641128HAMDHY13	Sergio	García	Flores	1964-11-28	M	\N	5552778956	\N
JISB990212HXFSKBJ6	Sergio	González	Fuentes	1999-02-12	M	B+	5516440373	paciente667@example.com
OXZP440717HVQFFCA2	Roberto	Guzmán	Cruz	1944-07-17	M	O-	5598213486	\N
HYNH860613XRHDQF85	Hugo	Rojas	Estrada	1986-06-13	Intersex	AB+	\N	\N
XUNM761117MVDOPWD6	Diana	Martínez	Delgado	1976-11-17	F	AB-	5568205068	\N
KVFC940527XMVVLAV8	Diana	Flores	Solís	1994-05-27	Intersex	AB-	5546921821	paciente671@example.com
TBRS580103HRYVIH19	Ricardo	Cabrera	Contreras	1958-01-03	M	\N	5580220509	paciente672@example.com
WIQJ610608HUEJTK68	Hugo	Fuentes	Estrada	1961-06-08	M	O-	5545788707	\N
GRYV821121HFATOIY1	Antonio	Fuentes	Aguilar	1982-11-21	M	O-	5577987682	paciente674@example.com
EKQS500823XGPXBZ85	Araceli	Alvarado	Cruz	1950-08-23	Intersex	\N	\N	paciente675@example.com
AVLY460709XMMXTK39	Alejandra	Reyes	Díaz	1946-07-09	Intersex	O+	\N	\N
LIIF490404MQMOSMM2	Araceli	Fuentes	Ramos	1949-04-04	F	B-	5594232894	paciente677@example.com
DKMF411124HICVVKL8	Diego	Morales	Cabrera	1941-11-24	M	B-	5572562926	paciente678@example.com
VLDH550811HQDRWMX5	Diego	Jiménez	Estrada	1955-08-11	M	O+	5578468509	paciente679@example.com
GJUT250120MDVQSCH7	Beatriz	Ortiz	Jiménez	2025-01-20	F	AB-	5538593401	paciente680@example.com
DKKG850113HDGXFLN6	Roberto	Gutiérrez	Ortiz	1985-01-13	M	AB-	5581367500	paciente681@example.com
DJYZ531002MCBYLF36	Yolanda	Cruz	Cordero	1953-10-02	F	\N	5519878092	paciente682@example.com
RYLM780624HFEKRZ16	Alejandro	Mendoza	Medina	1978-06-24	M	O+	5598678744	paciente683@example.com
UKXS770304HNLZKZS2	Raúl	Ramos	Díaz	1977-03-04	M	\N	5591165020	paciente684@example.com
UHCH730219HEUDZKU1	Miguel	Gutiérrez	Jiménez	1973-02-19	M	A-	\N	paciente685@example.com
XFVD751124HJJJQQY6	Arturo	Vázquez	Alvarado	1975-11-24	M	AB-	5536774620	\N
CQGZ061222XFWRZDI3	Elena	Flores	Ortiz	2006-12-22	Intersex	O-	5592049106	paciente687@example.com
GWRO110516HLARFY46	Arturo	Reyes	Rojas	2011-05-16	M	\N	5572257754	paciente688@example.com
ESBK910929METCQY36	Elena	Solís	Ramírez	1991-09-29	F	\N	5516082717	\N
SUSF420906MAKFFEN6	Lucía	Vázquez	Vázquez	1942-09-06	F	A+	5565914388	\N
SRGK541203HRJIND57	Ricardo	Cordero	Reyes	1954-12-03	M	AB-	5564309544	paciente691@example.com
SOAF710802MSFOCFD5	Teresa	Sánchez	Vargas	1971-08-02	F	A-	5597871375	\N
ZVYD230321XEZLMXD8	Araceli	Herrera	Cruz	2023-03-21	Intersex	A-	5504879788	paciente693@example.com
QLFH651113XURMBZC3	Mario	Ruiz	Mendoza	1965-11-13	Intersex	O+	5543619951	paciente694@example.com
CAYE450215MUSFYXW0	Leticia	Flores	Cabrera	1945-02-15	F	O-	5574830930	paciente695@example.com
TDEM170526MBUEXEH3	Ana	Vázquez	Rojas	2017-05-26	F	A+	5576720191	\N
DTXB211225MOEXKV77	Fernanda	Rodríguez	Gómez	2021-12-25	F	A-	5593049366	paciente697@example.com
QDEY560123XZJFDCS0	José	Gómez	Gutiérrez	1956-01-23	Intersex	\N	5582509522	paciente698@example.com
WLLX080513MMZCZXA3	Patricia	Martínez	Delgado	2008-05-13	F	B-	5597013712	\N
JYEG901226MAICXYJ0	Sofía	Salazar	Mendoza	1990-12-26	F	A+	5506159273	paciente700@example.com
XXCN851226MNSANHI2	Guadalupe	Flores	Hernández	1985-12-26	F	B+	5515542034	\N
PSYU391202HOLNZJE5	Carlos	Martínez	Castillo	1939-12-02	M	AB-	5555462347	paciente702@example.com
BRBY151027HDZZQDC3	Emilio	Torres	García	2015-10-27	M	O+	5568317641	paciente703@example.com
ZXVL161230MODESAG5	Rosa	López	Herrera	2016-12-30	F	O+	5538067130	paciente704@example.com
QIPJ930504HGZMFDM0	Ricardo	Pérez	Ortiz	1993-05-04	M	O+	5525885766	paciente705@example.com
GVZY951018MGTMFZ24	María	Vázquez	García	1995-10-18	F	AB+	5562159183	paciente706@example.com
IMNN200728XDJKUSB1	Beatriz	Guzmán	\N	2020-07-28	Intersex	O-	\N	paciente707@example.com
XUIS231223XHRYRCR9	Adrián	Sánchez	López	2023-12-23	Intersex	O+	5515204998	\N
MZTQ420515XPUHUCM7	Andrés	Cordero	Rojas	1942-05-15	Intersex	AB-	5566984166	paciente709@example.com
PSIH820323HHFYKNL3	Francisco	Rojas	Hernández	1982-03-23	M	\N	5594991970	\N
GOBQ230518MORFDC00	Verónica	Alvarado	Ramírez	2023-05-18	F	A+	5504181359	paciente711@example.com
DCOA450323XXRQUSS8	Ana	Delgado	Cruz	1945-03-23	Intersex	O+	5518644822	paciente712@example.com
OQLO740703MARFBZB4	Araceli	Ruiz	Jiménez	1974-07-03	F	\N	\N	paciente713@example.com
GMSC500310MJTMCYF2	Lucía	Pérez	Gómez	1950-03-10	F	\N	5594296882	paciente714@example.com
BSLH011009MWDIZC11	Silvia	Guzmán	Hernández	2001-10-09	F	B-	5578327488	\N
ZZVV730811XUMFJUC9	Gerardo	Ruiz	Contreras	1973-08-11	Intersex	AB+	5549668349	paciente716@example.com
AERK851128MDMEFLP6	Karla	Medina	González	1985-11-28	F	B+	5520893486	paciente717@example.com
EIMP860819XEYQOTE6	Sergio	Peña	\N	1986-08-19	Intersex	O+	5511413193	paciente718@example.com
NDHG610813XPXNAKL3	Alejandra	Flores	Vázquez	1961-08-13	Intersex	O+	5558816502	paciente719@example.com
TDNK140725MUBGWJR0	Beatriz	Gutiérrez	Torres	2014-07-25	F	AB+	5517718249	paciente720@example.com
MORE480108XDICOI08	Alejandra	López	García	1948-01-08	Intersex	O-	5559266486	paciente721@example.com
WTRO900324XJQMSJF5	Gabriela	Reyes	Delgado	1990-03-24	Intersex	B-	5550119292	\N
MWBL630318XDCPCND3	Teresa	Guzmán	Reyes	1963-03-18	Intersex	\N	5586365362	\N
PABA910927XTUUSJI4	Arturo	Chávez	Hernández	1991-09-27	Intersex	\N	5542046648	paciente724@example.com
FAZJ020322MKNLPY25	Paola	Romero	Alvarado	2002-03-22	F	\N	5597453389	\N
MZEU470227HFYNKWS0	Antonio	Mendoza	Castillo	1947-02-27	M	O-	5559953006	\N
YZON390427HPWVPJZ2	Carlos	Gómez	Gómez	1939-04-27	M	B-	5560112411	paciente727@example.com
MBAY680516XRADPS76	Miriam	Torres	Herrera	1968-05-16	Intersex	AB-	5582312995	paciente728@example.com
IFUZ540821HNCEXDK0	Adrián	Díaz	Romero	1954-08-21	M	A-	5537536596	paciente729@example.com
LIQF100805XJEDVRO8	Carlos	Contreras	Solís	2010-08-05	Intersex	B-	5554006445	\N
EGEW150929MOJYRT59	Alejandra	Cruz	González	2015-09-29	F	O-	5563342720	\N
PLWA450313XURBZCY3	Patricia	Aguilar	González	1945-03-13	Intersex	O+	5530693588	paciente732@example.com
JABW460910MZUXDQE6	Teresa	Jiménez	Jiménez	1946-09-10	F	AB-	5548165244	\N
RGRL510825XWCPTTN7	Rodrigo	Torres	Hernández	1951-08-25	Intersex	\N	5553912878	paciente734@example.com
SNSQ741016MQYEYWD4	Yolanda	Fuentes	Peña	1974-10-16	F	B-	5527147246	\N
IFIE611231HGRUHS22	Diego	Estrada	Aguilar	1961-12-31	M	\N	5591218706	paciente736@example.com
QBWS790508HRGFEDC1	Mario	Cabrera	Gómez	1979-05-08	M	O+	5520018676	paciente737@example.com
VRZV720310HPWMDA91	Adrián	Martínez	Solís	1972-03-10	M	B+	5561403845	paciente738@example.com
PINZ550317XYYRUEM5	Jorge	Delgado	Hernández	1955-03-17	Intersex	B+	5595100307	paciente739@example.com
KXSM410204MOCKAWC6	Verónica	García	Díaz	1941-02-04	F	AB+	5566411065	\N
JAZO370318HRKDMTR9	Iván	Pérez	Jiménez	1937-03-18	M	AB-	\N	paciente741@example.com
RGJR880201MEMRXSZ2	Beatriz	Salazar	Alvarado	1988-02-01	F	AB+	5508386888	paciente742@example.com
ZTCL820314XALZSNL5	Antonio	Guzmán	Cordero	1982-03-14	Intersex	AB-	5597609320	paciente743@example.com
SRFM781128HAJCRAX2	Fernando	Ruiz	Solís	1978-11-28	M	O-	5555851777	\N
FZCD710920HRVZURJ4	Hugo	Ramírez	Aguilar	1971-09-20	M	O-	5596264222	paciente745@example.com
ZWIX201212MXLIED95	Alejandra	Medina	Vargas	2020-12-12	F	B+	5505682092	\N
XBCU410730MMHWKNR0	Paola	García	Martínez	1941-07-30	F	AB-	5524728289	paciente747@example.com
PQUQ171003XFFWIW23	Leticia	Díaz	\N	2017-10-03	Intersex	O-	5561685071	\N
DSLA170713MTFOZDF5	Elena	Cordero	Hernández	2017-07-13	F	A+	5505370923	\N
PIWU250429MCQSZJ95	Ana	Alvarado	García	2025-04-29	F	B+	5529876989	\N
PYDN391203MXCTZX62	Sofía	Ramírez	Díaz	1939-12-03	F	AB-	5548131045	\N
VFCO051103MJGZZXX7	Beatriz	Salazar	Castillo	2005-11-03	F	B+	5535268064	paciente752@example.com
HWIJ760730MRQGRJL5	Guadalupe	Alvarado	Delgado	1976-07-30	F	A-	5546280550	paciente753@example.com
KLCL700215MMFGSFA9	Mónica	Hernández	Vargas	1970-02-15	F	O+	5555107409	\N
QMDT551110HVAEKZS7	Carlos	Pérez	Contreras	1955-11-10	M	AB+	\N	paciente755@example.com
HKIW920616HCVFACI2	Óscar	Martínez	Peña	1992-06-16	M	AB-	5595002601	paciente756@example.com
ZUVV390108MSIOUTV0	Claudia	Gómez	Ruiz	1939-01-08	F	AB-	5571732798	\N
HVYC230322MBAMJVN4	Miriam	Delgado	Cordero	2023-03-22	F	O+	5591045203	paciente758@example.com
UTDH981101XUKTTF85	Gabriela	Ortiz	Fuentes	1998-11-01	Intersex	B-	5535952056	\N
UAMS240726HNRBCRY7	Fernando	Rojas	Cabrera	2024-07-26	M	AB-	5537842339	paciente760@example.com
MPOM250627MYFKKAN2	Silvia	Mendoza	Martínez	2025-06-27	F	B-	5517365426	\N
UFVS200402HWYEHZO4	Sergio	Fuentes	Delgado	2020-04-02	M	B-	5510090605	\N
IHAE791212XDCMMOO2	Silvia	Fuentes	Romero	1979-12-12	Intersex	O+	5557598875	paciente763@example.com
NJFM560724HBHHNVL0	Luis	Flores	Delgado	1956-07-24	M	A+	5558214770	paciente764@example.com
FHWY500319HRAFGNK1	José	Vargas	Ruiz	1950-03-19	M	A+	\N	paciente765@example.com
AVLS601122XDNDYD66	Cecilia	Sánchez	Rojas	1960-11-22	Intersex	A-	5558819597	paciente766@example.com
WBYY211001MKHPRYN1	Verónica	Rodríguez	Herrera	2021-10-01	F	\N	5592897284	paciente767@example.com
FXYP130507MFABFRN9	Yolanda	Hernández	Medina	2013-05-07	F	B+	5532204144	paciente768@example.com
DCNL580826MSTWGWA2	Cecilia	Vázquez	Herrera	1958-08-26	F	O+	5530423227	paciente769@example.com
YYEQ220108HCNKBNQ6	Iván	Rodríguez	Morales	2022-01-08	M	A-	\N	paciente770@example.com
OLMS840929HDTRHEE0	Eduardo	Estrada	Vargas	1984-09-29	M	A+	5516174690	paciente771@example.com
HXRI020131HCTMMFJ9	Daniel	Herrera	Martínez	2002-01-31	M	O-	5531670805	paciente772@example.com
YBMH840604MWMECS66	Leticia	Romero	Castillo	1984-06-04	F	B-	5549444076	paciente773@example.com
HSNL610522HAJUTMK7	Hugo	Gutiérrez	Morales	1961-05-22	M	A-	5526261142	\N
URWK410501MIVEDV68	Lucía	Ramírez	Ramos	1941-05-01	F	O+	5579919623	paciente775@example.com
HGRK020131XZHEXJ32	Jorge	Estrada	Aguilar	2002-01-31	Intersex	B-	5558333430	paciente776@example.com
VQPM490818HALXIL36	Luis	Pérez	Mendoza	1949-08-18	M	B+	5576945353	paciente777@example.com
QMZC560114XNGIECL5	María	Díaz	Estrada	1956-01-14	Intersex	B+	5580959481	paciente778@example.com
LSMM550306HJOFDHA7	Gerardo	Castillo	Chávez	1955-03-06	M	B+	5559142614	\N
ZFND030704XJYKJGD7	Arturo	Cordero	Morales	2003-07-04	Intersex	AB+	5573100817	paciente780@example.com
XROC920909MRIKFGX4	Verónica	Cruz	Pérez	1992-09-09	F	A+	5587447017	\N
QNZK630913HXEHOO22	Diego	Cordero	Martínez	1963-09-13	M	AB+	5556337014	paciente782@example.com
LEOR621130XCALKU70	Miriam	López	Solís	1962-11-30	Intersex	O+	\N	\N
OVGD970118XNATJHH3	Eduardo	Ramírez	Gómez	1997-01-18	Intersex	AB+	5517203136	paciente784@example.com
XATU091212MFSXUPP5	Miriam	Cruz	Castillo	2009-12-12	F	A+	5595332227	\N
JLPW250811XWZHZLO2	Roberto	Herrera	Gómez	2025-08-11	Intersex	A-	5518507610	paciente786@example.com
ZDYQ810127MZFGMBG0	Guadalupe	Medina	Estrada	1981-01-27	F	AB-	5561583882	paciente787@example.com
IYMP771026MGKOYII2	Lucía	Solís	Torres	1977-10-26	F	A-	5532228019	\N
WVVU111124HFFXLMD6	Eduardo	Salazar	Cabrera	2011-11-24	M	A+	5595350637	paciente789@example.com
MVZP010517HIDHAPU3	Luis	Cordero	Hernández	2001-05-17	M	\N	5518520136	\N
SXPV050304XLMCKXR7	Carlos	Medina	Castillo	2005-03-04	Intersex	O+	5549121516	paciente791@example.com
NIAS960220MVCSXMN9	Ana	González	Ramos	1996-02-20	F	B-	5575207020	\N
DEXV810324MCEJCGP6	Verónica	García	Cordero	1981-03-24	F	AB+	5597609873	\N
YFEO370512MUMVYA35	Paola	Guzmán	Estrada	1937-05-12	F	\N	5578653394	\N
GAQV980114XXZSUKL3	Jorge	Solís	Ramos	1998-01-14	Intersex	O-	5521915057	paciente795@example.com
AWBA820906MENROMT4	Gabriela	Cabrera	Ortiz	1982-09-06	F	\N	5567649797	paciente796@example.com
WBIK870619HBANHLU3	Fernando	Morales	Ruiz	1987-06-19	M	AB-	5596496927	paciente797@example.com
SWMH130601HKGBWL30	Mario	Solís	Ruiz	2013-06-01	M	A+	5512827636	\N
RSYK700117HTMLJN13	Diego	Chávez	Herrera	1970-01-17	M	B+	5544344149	\N
WIIS031227XOJHSI04	Mónica	Delgado	Estrada	2003-12-27	Intersex	O+	5582230958	paciente800@example.com
SVRU370126XYQSIDP2	Rosa	Guzmán	Vázquez	1937-01-26	Intersex	O-	5597202170	paciente801@example.com
WZNL690311MKPZSEI0	Araceli	Herrera	Ortiz	1969-03-11	F	A-	\N	paciente802@example.com
XTHS120604XBAEXLG2	Diego	Gutiérrez	González	2012-06-04	Intersex	O-	5575658963	paciente803@example.com
NZCS410531MTGCIWX8	Cecilia	Guzmán	Salazar	1941-05-31	F	B+	5556631138	paciente804@example.com
NFVX080824HEBHGJ34	Mario	Vázquez	Gómez	2008-08-24	M	A+	5531043796	paciente805@example.com
ABRZ510303XUKWWER6	Daniela	Castillo	Fuentes	1951-03-03	Intersex	O+	5517741743	paciente806@example.com
ZZLB770807MFFRTI16	Claudia	Chávez	Jiménez	1977-08-07	F	B-	5552332829	paciente807@example.com
DGGA740411HHAHGI07	Miguel	Martínez	Castillo	1974-04-11	M	AB-	\N	paciente808@example.com
AONE420119XYPTTLU3	Yolanda	Alvarado	Mendoza	1942-01-19	Intersex	O+	5553012398	paciente809@example.com
WZEB010609MERJOCB1	Verónica	Reyes	\N	2001-06-09	F	AB-	5522405076	paciente810@example.com
PUUW510214MPKINDL4	Lucía	Fuentes	Rodríguez	1951-02-14	F	O+	5583872725	paciente811@example.com
SZWK530923HMMYRJQ8	Jorge	Cruz	López	1953-09-23	M	A+	5573379121	\N
HWLW211221HRNZXTD1	Juan	Sánchez	Medina	2021-12-21	M	AB-	5574039251	paciente813@example.com
KXYD720127XPDFFE56	Gabriela	Torres	Gómez	1972-01-27	Intersex	B+	5587220542	\N
UMGG720915MXXAWRM3	Verónica	Aguilar	Torres	1972-09-15	F	B+	5570488789	paciente815@example.com
LTVM241023MYQVLCU3	María	Díaz	Flores	2024-10-23	F	AB-	5592663295	paciente816@example.com
ZFFL970216MSEANCZ5	Verónica	Vargas	Guzmán	1997-02-16	F	\N	\N	paciente817@example.com
SJDC120314HKYNGBJ9	José	Cordero	Flores	2012-03-14	M	B-	5596363726	\N
NMCK211126XVITQA95	Rosa	Ortiz	Gómez	2021-11-26	Intersex	O-	5513800498	paciente819@example.com
FEDF180325HZCLXJ61	Iván	Flores	Cordero	2018-03-25	M	B-	5568687640	\N
BMJJ770716XYEVABY2	Antonio	Herrera	Salazar	1977-07-16	Intersex	\N	5577873585	paciente821@example.com
JYXD580719MTNXEGS2	Cecilia	Castillo	Castillo	1958-07-19	F	O-	5562213204	paciente822@example.com
ZDJX060410HPQSYWH1	Manuel	Flores	Fuentes	2006-04-10	M	AB-	5572699994	paciente823@example.com
XRAB151016XHNNNAK0	Francisco	Cordero	Morales	2015-10-16	Intersex	O+	\N	paciente824@example.com
GDAK900317XUBKZFR3	Ricardo	Fuentes	Fuentes	1990-03-17	Intersex	\N	5580582692	paciente825@example.com
RWNF900108XOYNHHL8	Teresa	Peña	Vargas	1990-01-08	Intersex	A-	5589633761	paciente826@example.com
MODH091108XNRJYDA1	Antonio	Solís	Castillo	2009-11-08	Intersex	A-	5582339218	paciente827@example.com
TXCQ590809XPKWYXB6	Sergio	Ruiz	Contreras	1959-08-09	Intersex	AB-	5510659208	paciente828@example.com
EOTO700104XNDOQWH5	Miriam	Díaz	González	1970-01-04	Intersex	AB+	5583845720	paciente829@example.com
MYFT771104XLSDEK23	Manuel	Castillo	Castillo	1977-11-04	Intersex	B+	5599255394	paciente830@example.com
ESTA460314XOIUPE06	Alejandra	García	Gutiérrez	1946-03-14	Intersex	B+	\N	paciente831@example.com
RZTO250523XJVVPI95	Pablo	Rojas	\N	2025-05-23	Intersex	B+	5518398416	paciente832@example.com
GMXS941207MRZRDMS9	Leticia	Contreras	Solís	1994-12-07	F	\N	\N	\N
ZMAK790723HFDBFMI7	Pablo	Estrada	Solís	1979-07-23	M	O+	5548900824	paciente834@example.com
RRSR250909MGVZBK44	Sofía	Herrera	Jiménez	2025-09-09	F	\N	5599741856	paciente835@example.com
LABA550106HGBVLXY6	José	Cruz	Vargas	1955-01-06	M	O-	5595305641	paciente836@example.com
OSBQ861225XYPXAUH8	Roberto	Vargas	Ortiz	1986-12-25	Intersex	AB-	5500136510	\N
BMPI410728MVKNRMX2	Gabriela	Torres	Estrada	1941-07-28	F	B+	5562215599	paciente838@example.com
FDTA090317MKHGUUS7	Patricia	Chávez	Gómez	2009-03-17	F	O+	5547648455	paciente839@example.com
HKAP771018XCEJKXW3	Diego	Chávez	Jiménez	1977-10-18	Intersex	O-	5590036221	paciente840@example.com
UOPF121122HNYIRU83	Adrián	Guzmán	Solís	2012-11-22	M	B-	5558522942	paciente841@example.com
QKPL380116MTCOCBV0	Patricia	Chávez	Sánchez	1938-01-16	F	\N	5505491477	paciente842@example.com
EJOQ560611MXXXJD31	Adriana	Mendoza	Ruiz	1956-06-11	F	B-	5597344930	paciente843@example.com
DQGN080322MCZCWGP8	Rosa	Fuentes	\N	2008-03-22	F	A+	5508788281	paciente844@example.com
RNFK000224HVCKFD24	Raúl	Fuentes	García	2000-02-24	M	AB+	5535378018	paciente845@example.com
IMPC990630HXPOXMK9	Eduardo	Alvarado	Morales	1999-06-30	M	AB+	5514336299	paciente846@example.com
TSSS210105MZAWBDD8	Cecilia	Alvarado	Ramos	2021-01-05	F	\N	5539083521	paciente847@example.com
JFUJ440731XMIXQY74	Mónica	Romero	Ortiz	1944-07-31	Intersex	AB-	5572857595	paciente848@example.com
ECOX090831HSOXRTE2	Arturo	Sánchez	Hernández	2009-08-31	M	B+	5539717059	paciente849@example.com
PYFQ870727MMQDCFN0	Alejandra	Rodríguez	Vázquez	1987-07-27	F	A-	5556811939	paciente850@example.com
AAXZ740109MTVXSUK1	Leticia	Fuentes	Ramos	1974-01-09	F	AB-	5505528669	\N
QRYA581211MYXOXAU3	Ana	Solís	Chávez	1958-12-11	F	A+	5501193910	\N
UKLD130905XHXNBSD8	Alejandro	Cabrera	Gutiérrez	2013-09-05	Intersex	B-	5518104502	\N
WZZQ420124XPGMYMI7	Adrián	Vázquez	Ramos	1942-01-24	Intersex	O-	5558969335	\N
YNCL961114XUJOVHF5	Carlos	García	Fuentes	1996-11-14	Intersex	AB+	5539792551	\N
VEQH211201MPPFOAK8	Adriana	Castillo	Peña	2021-12-01	F	AB+	5566053428	\N
BDTW181114MOKUGK84	Mónica	González	Romero	2018-11-14	F	AB+	5505103880	\N
NEQD070111HIUIVI31	José	Torres	Romero	2007-01-11	M	\N	5539530969	paciente858@example.com
WASF690707MFQRYI67	Paola	Castillo	Estrada	1969-07-07	F	B+	5551358727	\N
NZRR381128MDZDYMR0	Araceli	Morales	\N	1938-11-28	F	A-	5539881873	paciente860@example.com
HGMJ600116MYPOAIG3	Cecilia	Ruiz	Jiménez	1960-01-16	F	O+	5591538602	paciente861@example.com
BICU380922MFHCTBW7	Patricia	Ruiz	Flores	1938-09-22	F	AB-	5544100794	\N
RUCB500512HTPWTJG2	Jorge	Díaz	Reyes	1950-05-12	M	A+	5587098726	paciente863@example.com
PJZE180923XFJAIWN2	Emilio	Vázquez	Mendoza	2018-09-23	Intersex	AB+	\N	paciente864@example.com
NDWM780725XGBPAE86	Carlos	López	Aguilar	1978-07-25	Intersex	AB-	5520200953	paciente865@example.com
NRSA080207MAKOPTU0	Diana	Ramírez	Mendoza	2008-02-07	F	O+	\N	\N
OGTO540205MCGYYB22	Carmen	Cabrera	Martínez	1954-02-05	F	A+	\N	\N
CUMP460518MEFDAZQ5	Silvia	López	Guzmán	1946-05-18	F	B+	5517192817	paciente868@example.com
EHYJ370711MJZEFLJ1	Mónica	Gutiérrez	Hernández	1937-07-11	F	AB+	\N	paciente869@example.com
XVXA130102HSIJXO42	Adrián	Delgado	Pérez	2013-01-02	M	AB+	5532655132	paciente870@example.com
RAVE610215HILWLS85	Óscar	Contreras	Gutiérrez	1961-02-15	M	O-	5521191589	paciente871@example.com
WJXT571013HZRNIP96	Jorge	Alvarado	Castillo	1957-10-13	M	\N	5523760088	\N
VRCS860601MDSBPJI1	Mónica	Martínez	Jiménez	1986-06-01	F	AB+	5506983692	paciente873@example.com
IOBQ860712MFDHSQ05	Adriana	Díaz	Medina	1986-07-12	F	B+	5520212372	paciente874@example.com
YGAB070124MAARQMP4	Araceli	Ramos	\N	2007-01-24	F	AB+	5591900889	paciente875@example.com
AASC540212XMSYXUJ3	Jorge	Sánchez	Castillo	1954-02-12	Intersex	A+	5537989790	paciente876@example.com
RNPI410226XMHBBA64	Cecilia	Ramos	Pérez	1941-02-26	Intersex	A-	5511371181	paciente877@example.com
QEYS960227XZJEAGQ0	Mónica	Salazar	Torres	1996-02-27	Intersex	O-	5553466075	paciente878@example.com
WIMN451103XOEWBDD8	Mónica	Estrada	Delgado	1945-11-03	Intersex	A+	5502818223	paciente879@example.com
MEBQ390711XLQCPIU2	Teresa	Ortiz	Cruz	1939-07-11	Intersex	AB-	5553642357	\N
ERWK400621MDRDVNE2	Ana	Flores	Salazar	1940-06-21	F	B-	5504610079	\N
ERHQ180202HEOCACL3	Alejandro	Alvarado	Hernández	2018-02-02	M	A+	5561512048	paciente882@example.com
YXYI050810HJMXBJL2	Raúl	Alvarado	Chávez	2005-08-10	M	AB-	5534601915	\N
EIHL810813MRNCPN82	Paola	Solís	Gutiérrez	1981-08-13	F	A+	5512726708	paciente884@example.com
EEIC400407MTONRO64	Miriam	Aguilar	Castillo	1940-04-07	F	B+	5512903500	paciente885@example.com
JEEH820516HKIZGJD4	Pablo	Medina	Cabrera	1982-05-16	M	AB+	5568212156	paciente886@example.com
ZFAM740302XVWIZJF1	Elena	Ruiz	Torres	1974-03-02	Intersex	O-	5597388182	paciente887@example.com
VSZJ950622HQQZFXE8	Diego	Alvarado	Jiménez	1995-06-22	M	\N	5568066405	paciente888@example.com
GVXI971102HCZXFHB1	Juan	Gómez	Mendoza	1997-11-02	M	AB+	\N	paciente889@example.com
EDWX810307XUQMBBM2	Diego	García	Reyes	1981-03-07	Intersex	O+	5531978999	paciente890@example.com
AGJP410721HDHDYW51	Luis	Pérez	López	1941-07-21	M	AB-	5586016259	paciente891@example.com
JUOQ670808HKLAUDE3	Rodrigo	Medina	Delgado	1967-08-08	M	AB-	5558210728	paciente892@example.com
YBWH720109MODNDNB8	Rosa	García	Contreras	1972-01-09	F	\N	5597223996	\N
HBON950504MRDAFZS8	Beatriz	Sánchez	Rojas	1995-05-04	F	O+	5585578002	paciente894@example.com
MFFD060809XMSBZMY8	Carmen	Ortiz	Ramírez	2006-08-09	Intersex	B-	5546706751	paciente895@example.com
XECK630318XBXDNJJ6	Antonio	Reyes	Mendoza	1963-03-18	Intersex	O-	\N	paciente896@example.com
UQYI410425HZFJGWH9	Francisco	Mendoza	\N	1941-04-25	M	\N	5592484813	\N
AKHB520915MEDLCM45	Laura	Alvarado	González	1952-09-15	F	\N	5546339534	paciente898@example.com
YIPN150209HIYEPQ11	José	Chávez	\N	2015-02-09	M	B-	5585512817	paciente899@example.com
YSPQ920509MDKLIEY0	Carmen	Rodríguez	Delgado	1992-05-09	F	AB-	5560244654	paciente900@example.com
ODAO191209MGBQODX6	Karla	Cruz	\N	2019-12-09	F	B+	5578370317	paciente901@example.com
CJQK990220HWOVFMD2	Arturo	Martínez	Vargas	1999-02-20	M	A+	5568627288	paciente902@example.com
OUMV241024HGEPCWN5	Sergio	Romero	Ramírez	2024-10-24	M	A-	5567625923	paciente903@example.com
NVWA210123MZIQQMO2	Diana	Medina	Estrada	2021-01-23	F	O+	5553405089	paciente904@example.com
KTON391119MIYAKGU6	Claudia	Cabrera	Pérez	1939-11-19	F	AB-	\N	paciente905@example.com
IFNC941108XSWAHZ74	Leticia	Contreras	Ramos	1994-11-08	Intersex	A+	5573627320	paciente906@example.com
COLU570531HPNTDPG6	Óscar	Cruz	Rodríguez	1957-05-31	M	A+	\N	\N
RMSR010904XHBLFD19	Leticia	Fuentes	Ortiz	2001-09-04	Intersex	O+	5522026980	\N
NRAC200421MOOYAGF6	Verónica	Castillo	González	2020-04-21	F	A-	5505004933	\N
HDZO731203MFSIZO13	Verónica	Torres	Aguilar	1973-12-03	F	\N	\N	\N
BFLT020527XXTRKDO9	Luis	Castillo	Chávez	2002-05-27	Intersex	A-	5527281291	paciente911@example.com
YSNB380410HENWNOZ5	Eduardo	Cordero	\N	1938-04-10	M	A+	5528453974	paciente912@example.com
AQRN601122XJANXPX6	Adriana	Mendoza	\N	1960-11-22	Intersex	O+	5580192902	\N
HTBI460807HIRSBSO2	Mario	Mendoza	Gutiérrez	1946-08-07	M	A+	5533320235	\N
BDTX941115HHKJKZC3	Pablo	Mendoza	Ramos	1994-11-15	M	AB+	5588439333	paciente915@example.com
NEAZ720814MRALSX83	Yolanda	Reyes	Flores	1972-08-14	F	O-	5544129075	paciente916@example.com
BDEH400521MPMGCP34	Alejandra	Peña	Ramírez	1940-05-21	F	B-	5510629419	\N
EFMO730303MCWHDPX3	Alejandra	Peña	Rodríguez	1973-03-03	F	AB+	5564752864	paciente918@example.com
OZYH141206HAASSF84	Iván	Martínez	Alvarado	2014-12-06	M	B-	5540321153	paciente919@example.com
YEDS610228MUDJHVD8	María	Chávez	Vázquez	1961-02-28	F	AB-	5597247925	paciente920@example.com
RHWI800922MUZVKW81	Yolanda	Ramírez	Pérez	1980-09-22	F	A+	5504877067	paciente921@example.com
SRNL721126XDLTBFV7	Roberto	Vázquez	Flores	1972-11-26	Intersex	\N	5564085858	paciente922@example.com
NWZP621226XEMZFA64	Patricia	Flores	Chávez	1962-12-26	Intersex	AB+	5592543551	paciente923@example.com
LAYD470922MRFLXZZ2	Verónica	Salazar	Gómez	1947-09-22	F	B+	5586394201	paciente924@example.com
JSSF171130HTAZAT06	Pablo	Flores	Díaz	2017-11-30	M	A+	5570266045	paciente925@example.com
PJUB191001HAWHTCD1	Daniel	Mendoza	Gómez	2019-10-01	M	A-	5538922247	\N
AQEO880126XPVBKMR6	Sergio	Aguilar	López	1988-01-26	Intersex	O-	5560762643	paciente927@example.com
HOFG960712XINCONJ3	Iván	García	\N	1996-07-12	Intersex	O-	5536109441	paciente928@example.com
IJDX940607MGOFOPY8	Patricia	Morales	Aguilar	1994-06-07	F	B-	5560634942	paciente929@example.com
KKDQ830409HROACPM2	Emilio	Díaz	González	1983-04-09	M	B+	5502483744	paciente930@example.com
NYKZ941003HGQMSI29	Gerardo	Rojas	Díaz	1994-10-03	M	O+	5548536268	paciente931@example.com
XWIC861024MUAATKO8	Miriam	Contreras	Herrera	1986-10-24	F	B-	5557421643	paciente932@example.com
YHPR730725XCIVNBT7	Mónica	Martínez	López	1973-07-25	Intersex	AB+	5543788443	paciente933@example.com
ULNI500201MNOEVMO6	Diana	Aguilar	Vargas	1950-02-01	F	\N	5515418589	paciente934@example.com
DAYQ731226HJKBWO96	Miguel	Vargas	Flores	1973-12-26	M	O+	5535660503	paciente935@example.com
AMPU061013MOVGAM41	Mónica	Alvarado	Reyes	2006-10-13	F	\N	5522667941	paciente936@example.com
GQYK960319XVTZBM43	Mario	Medina	Alvarado	1996-03-19	Intersex	AB+	5528987605	paciente937@example.com
SEED980801XWOBIU96	Óscar	Martínez	Solís	1998-08-01	Intersex	O-	5567066320	paciente938@example.com
GZSS830301MFYQTC82	Beatriz	Flores	García	1983-03-01	F	AB-	5526533717	paciente939@example.com
IFMS701212HJFAGW83	Javier	Alvarado	Gutiérrez	1970-12-12	M	O-	5535490145	paciente940@example.com
TFCT910812XKROGAX4	Emilio	Vargas	\N	1991-08-12	Intersex	\N	5543884302	paciente941@example.com
NPQA150921XMUMUIO1	Daniela	González	Fuentes	2015-09-21	Intersex	B-	5589016492	paciente942@example.com
OYBD410615XPBTENT0	Ana	Pérez	Morales	1941-06-15	Intersex	AB-	5530880817	\N
FUYJ760515HJQKYAB7	Arturo	Flores	Romero	1976-05-15	M	A+	5595927411	paciente944@example.com
MDFZ460519HPMMEA90	Fernando	Delgado	Estrada	1946-05-19	M	\N	5503917026	\N
UUFU910707MIKQVPA1	Mónica	Díaz	Estrada	1991-07-07	F	A+	\N	paciente946@example.com
NTAS060615XCEHOLP0	Fernanda	Cruz	Mendoza	2006-06-15	Intersex	A+	5549760396	paciente947@example.com
MKEY040101MWJBLLO6	María	Ramírez	Ortiz	2004-01-01	F	B+	5518754036	paciente948@example.com
WSOP940218MHQLIWZ6	Leticia	Medina	Sánchez	1994-02-18	F	A+	5523606679	paciente949@example.com
SJSP920416XVFEXBQ2	Emilio	Ortiz	Ramírez	1992-04-16	Intersex	\N	5526992066	paciente950@example.com
LMTS450831MTVESX93	Silvia	Delgado	Morales	1945-08-31	F	A-	5587688777	paciente951@example.com
HIQF141105MBQZITP1	Beatriz	Alvarado	\N	2014-11-05	F	B-	5583912260	\N
VWOM371201HETXXCT3	Manuel	Gutiérrez	\N	1937-12-01	M	O+	5591341038	paciente953@example.com
EBST830726MRNUKVY4	Alejandra	Cruz	Fuentes	1983-07-26	F	A+	5524059208	\N
PNNT420130MZDTIRZ2	Leticia	Jiménez	\N	1942-01-30	F	\N	5505682017	paciente955@example.com
DQNS890115HKPEYYS0	Óscar	García	Romero	1989-01-15	M	B+	5547412531	paciente956@example.com
ABPP170115MPGUFC55	Lucía	Peña	Castillo	2017-01-15	F	O+	5519202599	paciente957@example.com
OBGJ061125HXFZJJR7	Daniel	Morales	Morales	2006-11-25	M	B+	5504760786	paciente958@example.com
PNKC630903HYYTCZ40	Ricardo	González	García	1963-09-03	M	\N	5551732895	\N
CRZL710617MQALLRF1	Fernanda	Morales	López	1971-06-17	F	B-	5574496539	paciente960@example.com
BJAS250630MHZAWJU4	Guadalupe	Cordero	Guzmán	2025-06-30	F	O-	5503982218	\N
XXBH561129HQLRRMR0	Daniel	Aguilar	Flores	1956-11-29	M	AB-	5502652951	paciente962@example.com
GXHK471217MXNEGBM9	Gabriela	Alvarado	Vázquez	1947-12-17	F	AB-	5508806708	paciente963@example.com
FBVW720320XDTWTC84	Verónica	Guzmán	López	1972-03-20	Intersex	A-	\N	\N
RIRK950829HRBKFZZ3	Pablo	Aguilar	Rodríguez	1995-08-29	M	A+	5519604722	\N
ILWI821128HJPXWZD8	Andrés	Guzmán	Guzmán	1982-11-28	M	A+	5531714619	paciente966@example.com
MNEN530813XFHKWYY0	Raúl	Cabrera	Rojas	1953-08-13	Intersex	B-	5502618402	paciente967@example.com
MQMB440519XKBMHBZ6	Araceli	Vargas	\N	1944-05-19	Intersex	A-	5505028164	paciente968@example.com
BSDF730208XBZXHUB2	Patricia	Delgado	Vázquez	1973-02-08	Intersex	B-	5594523759	paciente969@example.com
FMBB670628XTWRNBI7	Rodrigo	Jiménez	Cabrera	1967-06-28	Intersex	B-	5574544920	paciente970@example.com
KHQC420908XDRAURH8	Verónica	Estrada	Ortiz	1942-09-08	Intersex	AB+	5558344566	\N
PBKW700605HNMAHZ01	Andrés	Mendoza	Rojas	1970-06-05	M	AB+	5548607047	paciente972@example.com
EGLZ240419HCLQLAE5	Gerardo	Romero	Castillo	2024-04-19	M	A-	5517316715	paciente973@example.com
FIJC140303MGHSKJ29	Rosa	Vargas	Mendoza	2014-03-03	F	B+	\N	paciente974@example.com
OSBK630611MXODSXF8	Diana	Mendoza	Chávez	1963-06-11	F	\N	5546936561	paciente975@example.com
UVRO020125HMRALV30	Mario	Chávez	Rojas	2002-01-25	M	A+	5577184301	paciente976@example.com
GGEW040114HWTWPGI3	José	Estrada	Rojas	2004-01-14	M	AB+	5502825326	paciente977@example.com
IFOP081222MHTWFH85	Fernanda	Peña	Cordero	2008-12-22	F	A+	\N	\N
NTGH191119HYZFQIS2	José	Cabrera	García	2019-11-19	M	A-	5571998290	paciente979@example.com
IWKE500218MMBOKNE3	Alejandra	Chávez	Ramos	1950-02-18	F	\N	5510064332	\N
OOGG850603MCNXQWC6	Cecilia	Cruz	Rojas	1985-06-03	F	AB+	5570703850	\N
ZJEU800728HJCXBU44	Ricardo	Peña	Peña	1980-07-28	M	O+	5574067582	paciente982@example.com
NFAB500319MHWMGZ65	Patricia	Mendoza	García	1950-03-19	F	AB+	5546149745	paciente983@example.com
SWYS370925XVPXSRR9	Adriana	Vázquez	Vázquez	1937-09-25	Intersex	O-	5586099550	paciente984@example.com
NJGE560315XEXHSIY1	Karla	Vázquez	Romero	1956-03-15	Intersex	A+	5589811594	paciente985@example.com
CFVO621215MNXWFEM9	Adriana	Torres	\N	1962-12-15	F	\N	5547422567	paciente986@example.com
EEGO780708XQURUPD5	Guadalupe	González	Medina	1978-07-08	Intersex	\N	5541680613	paciente987@example.com
XSTR831017MIMAYVU8	Silvia	Cordero	Gutiérrez	1983-10-17	F	AB+	5594963830	paciente988@example.com
RBSE210310MNCMMEA1	Patricia	Morales	Sánchez	2021-03-10	F	AB+	5557864578	paciente989@example.com
FIPN161011MIAABM77	Alejandra	Ruiz	Ruiz	2016-10-11	F	B-	5568240516	paciente990@example.com
JICY480610MQSTPJA2	Alejandra	Rodríguez	Torres	1948-06-10	F	A-	5568608357	paciente991@example.com
NGBT030929XJZIEG66	Miguel	Vargas	\N	2003-09-29	Intersex	O+	5550898309	paciente992@example.com
SYNU240825MCTPTP52	Diana	González	Delgado	2024-08-25	F	B+	5528413569	\N
LYYM070519HYWPJQA9	Manuel	Chávez	Contreras	2007-05-19	M	B-	5539405980	\N
EUZB010628MZHCLQI5	María	Flores	Torres	2001-06-28	F	\N	5507342031	paciente995@example.com
OLTL860721MDVJCQ14	Lucía	Contreras	Fuentes	1986-07-21	F	\N	5530882958	paciente996@example.com
HUYH110617XFNAXUX8	Ana	Díaz	Romero	2011-06-17	Intersex	AB+	5542767483	\N
SGVU500126MVCLCZ71	Claudia	García	Gómez	1950-01-26	F	AB-	5524265594	paciente998@example.com
EOXE040808XHUPDO69	Adriana	Martínez	Cruz	2004-08-08	Intersex	O+	5523790065	paciente999@example.com
RIZO650713XOSKWIE7	Patricia	Solís	Hernández	1965-07-13	Intersex	AB+	5553981889	paciente1000@example.com
SCKP940203MTBRSJX8	Diana	Vázquez	González	1994-02-03	F	AB+	5583848876	\N
CEHS891223HMVDFDB5	Diego	Cruz	Guzmán	1989-12-23	M	O-	5581298861	paciente1002@example.com
MMWY250208HTBDBOI3	Emilio	Martínez	Rojas	2025-02-08	M	AB-	5598268933	\N
OBHW441021XKBNPK38	Ana	Alvarado	Estrada	1944-10-21	Intersex	AB+	5533557077	\N
KKKU161002HBVYKOC5	Gerardo	Flores	Vázquez	2016-10-02	M	A+	5587993844	\N
CJCJ380720MPBUWDJ3	Sofía	Medina	Rodríguez	1938-07-20	F	B-	5536871568	paciente1006@example.com
ORBE700421XHUJZYR5	Luis	Delgado	Vargas	1970-04-21	Intersex	AB+	5546794036	paciente1007@example.com
ETKP410814MGYPQVN1	Gabriela	Martínez	Vázquez	1941-08-14	F	B-	5575729273	\N
CKRL750121MWVJUFO3	Elena	Vázquez	Ramírez	1975-01-21	F	A+	5565185483	paciente1009@example.com
ZMPW990729MIMFXDW9	María	Contreras	Gutiérrez	1999-07-29	F	B-	5517491617	\N
SRCU890613HJDHZYT4	Jorge	Flores	Rodríguez	1989-06-13	M	AB-	5509483774	\N
UHGY660216HAZENUW0	Daniel	Ramírez	Ortiz	1966-02-16	M	AB+	5521836677	\N
EKXM250808XHIFZBI2	Gerardo	Romero	González	2025-08-08	Intersex	A+	5534998013	paciente1013@example.com
TXAD930812MPOTCKJ4	Elena	Jiménez	Rojas	1993-08-12	F	B+	5514409233	paciente1014@example.com
LNJE440412MZMBDRY3	Ana	Contreras	Castillo	1944-04-12	F	AB-	5563199569	paciente1015@example.com
OMIZ640403MCJTBAN8	Silvia	Flores	Rojas	1964-04-03	F	B-	\N	\N
ZIYJ510213MVIRMPJ2	Alejandra	González	Vázquez	1951-02-13	F	\N	5539047331	\N
VPJS920315MGELCDQ9	Mónica	Aguilar	Pérez	1992-03-15	F	AB-	5579531204	\N
NDQG860903MBWQZL60	Gabriela	Reyes	Cordero	1986-09-03	F	O+	\N	paciente1019@example.com
KCCI180305MHNPRNK1	Adriana	Pérez	Delgado	2018-03-05	F	O+	5581871096	paciente1020@example.com
BNUR500622MUAENSM3	Daniela	Gutiérrez	Contreras	1950-06-22	F	O-	5542306002	\N
KWAV630917HKEFJXG1	Arturo	Alvarado	Cordero	1963-09-17	M	B+	5506670151	\N
MNHG370716XXQEEEI4	Adriana	Cabrera	Rodríguez	1937-07-16	Intersex	O+	\N	paciente1023@example.com
MEUA920428XDVXTYC1	Alejandro	Gómez	Hernández	1992-04-28	Intersex	O-	5548433913	\N
GFHX540409HTIKNVS5	Eduardo	Gómez	Sánchez	1954-04-09	M	A+	5528644976	paciente1025@example.com
IFXB080524HXZSLH17	Alejandro	Delgado	Alvarado	2008-05-24	M	AB-	5534985297	paciente1026@example.com
MLKS910427MCIPYMK5	Fernanda	Pérez	Gómez	1991-04-27	F	A-	5580966414	paciente1027@example.com
LFJO630213MYIYMNU3	Adriana	Reyes	Delgado	1963-02-13	F	B-	5596298532	\N
JDKP120319XCFUOU03	Silvia	Aguilar	Delgado	2012-03-19	Intersex	\N	5554346858	paciente1029@example.com
DMXR550501HEJSPSP9	Hugo	Cabrera	\N	1955-05-01	M	\N	5516153811	paciente1030@example.com
HAPZ230212XGPEMB42	Sofía	Morales	Pérez	2023-02-12	Intersex	O+	5548967808	paciente1031@example.com
DJMZ131129MGSYJZ26	Diana	Díaz	Sánchez	2013-11-29	F	A+	5542926456	\N
ZSUJ480713HAGMSI61	Andrés	Rodríguez	Delgado	1948-07-13	M	O-	5566497196	paciente1033@example.com
GKHT050816XDBDMDK5	Juan	Romero	Salazar	2005-08-16	Intersex	O+	5539949013	\N
PVZG501226MVIRZDS0	Mónica	Vázquez	Romero	1950-12-26	F	\N	5541016793	\N
JSUW380328MSVVCYB0	Elena	Pérez	García	1938-03-28	F	B+	5520288661	paciente1036@example.com
HJED220310XYGIQXV4	Luis	González	Estrada	2022-03-10	Intersex	\N	5520353160	paciente1037@example.com
GRMB161017XCKZPDF7	Fernanda	Rodríguez	Delgado	2016-10-17	Intersex	O-	5521940247	paciente1038@example.com
JCDE171026HROUJKI7	Jorge	Herrera	Cordero	2017-10-26	M	O-	5593678576	\N
CBUP541227MJTDVMH9	Claudia	Estrada	Salazar	1954-12-27	F	B+	5521540131	paciente1040@example.com
VFMC390203HNRILKK5	Ricardo	Hernández	Alvarado	1939-02-03	M	A+	5574102547	paciente1041@example.com
TIQQ620705HLNMTJ69	Adrián	Contreras	Estrada	1962-07-05	M	A-	5505195675	paciente1042@example.com
EFOU990228MXCOEMZ2	Claudia	Mendoza	Medina	1999-02-28	F	B-	5504607001	\N
MQUN250413XFIBZW67	Araceli	Díaz	Jiménez	2025-04-13	Intersex	O-	5506689041	paciente1044@example.com
QXDD080630XLZVFEO2	Manuel	García	Flores	2008-06-30	Intersex	\N	5528240847	paciente1045@example.com
TJBA720917HICBXY94	Arturo	Morales	Estrada	1972-09-17	M	AB-	5513511350	paciente1046@example.com
EFYU420707MQSEAZ14	Claudia	Chávez	Vargas	1942-07-07	F	O-	5557809783	\N
DTJW981025XKHJCTV2	Juan	González	\N	1998-10-25	Intersex	\N	5514478674	paciente1048@example.com
UQVR180210XTHAMHW7	Alejandro	Salazar	\N	2018-02-10	Intersex	\N	5503789121	\N
XMTS511229XAKKRKW7	Gabriela	Vargas	Reyes	1951-12-29	Intersex	B-	5540842906	paciente1050@example.com
LEQT981231MZRNAME0	Silvia	Solís	\N	1998-12-31	F	AB+	5573374570	\N
VRCJ880319MSRBELO0	Patricia	Vargas	Jiménez	1988-03-19	F	\N	5576992964	\N
ZZAR961001MJVFHXJ4	Beatriz	Rojas	Gómez	1996-10-01	F	A+	5580041724	\N
DKRK711117MKOJSAY2	Alejandra	Reyes	Castillo	1971-11-17	F	AB-	5560242570	\N
TJLF650214HHCKURI8	Antonio	Cruz	Ramos	1965-02-14	M	AB+	5540296629	paciente1055@example.com
EEAJ711121MCNORYL1	Verónica	Rodríguez	Flores	1971-11-21	F	B-	5592669370	paciente1056@example.com
HSFQ141115HBJRYLA2	Emilio	Ruiz	Vázquez	2014-11-15	M	A+	\N	\N
GLTH031122XPTPCTD0	Carlos	Rodríguez	Cordero	2003-11-22	Intersex	O+	5529561622	paciente1058@example.com
XLLT790813MJAXOSJ3	Miriam	Díaz	González	1979-08-13	F	O+	5553231677	paciente1059@example.com
OXJH991003XOAZXDS5	Teresa	González	Aguilar	1999-10-03	Intersex	A-	5511776665	\N
EAZS190926HFRCWUU7	Hugo	Guzmán	Romero	2019-09-26	M	\N	\N	paciente1061@example.com
VDMP190711XURVOAY7	Gabriela	Hernández	Reyes	2019-07-11	Intersex	AB+	5532237185	paciente1062@example.com
XJUQ790516HLNHPCF4	Diego	Ramírez	Solís	1979-05-16	M	A+	5530003753	paciente1063@example.com
EINL070225XTVUQMY9	Claudia	Cruz	González	2007-02-25	Intersex	A-	5578417837	paciente1064@example.com
BDDY130324XIVAMZW2	Miguel	Ramos	Herrera	2013-03-24	Intersex	AB+	5526735127	\N
LVMK811113MYMTPNQ8	Alejandra	Ruiz	Reyes	1981-11-13	F	AB-	5596224945	paciente1066@example.com
NSES250320HNKMRKH2	Manuel	Romero	Chávez	2025-03-20	M	O+	5527672935	paciente1067@example.com
IECE640419XSDJNZX0	Mario	Delgado	Torres	1964-04-19	Intersex	A+	5534778045	paciente1068@example.com
DQJW920322XUBOAGO9	Claudia	Contreras	Ramírez	1992-03-22	Intersex	\N	5547823372	paciente1069@example.com
MYXO811208XAMGNUO2	Karla	Díaz	Castillo	1981-12-08	Intersex	\N	5501122008	\N
GYGN070624MOVSMA62	Patricia	Aguilar	Fuentes	2007-06-24	F	\N	5571360549	paciente1071@example.com
LNIS370503MWBDGEQ9	Araceli	Estrada	Salazar	1937-05-03	F	B-	5519350011	paciente1072@example.com
WWUB610722MRBGQX69	Fernanda	Sánchez	Herrera	1961-07-22	F	O+	5510404315	paciente1073@example.com
QUUD080810XIQUGPT7	Hugo	González	Ramos	2008-08-10	Intersex	B-	5503090168	paciente1074@example.com
IBCT760629MBEOZVG6	Gabriela	Vargas	Vargas	1976-06-29	F	\N	5537161158	paciente1075@example.com
SSPM180204MOLSXW73	Carmen	Herrera	Sánchez	2018-02-04	F	A-	5517050583	paciente1076@example.com
NKOW940716MERLHLP3	Sofía	Cordero	Delgado	1994-07-16	F	\N	5526621775	paciente1077@example.com
NNRP420523HTGAYGA2	Hugo	Ramos	Díaz	1942-05-23	M	\N	5527276698	paciente1078@example.com
XWBF521223HKEQLJ11	Alejandro	Chávez	Mendoza	1952-12-23	M	A-	\N	paciente1079@example.com
PEXA421109HUOYHRK7	Adrián	García	Cabrera	1942-11-09	M	AB-	5511842527	paciente1080@example.com
OCEC241218MBEWIEM4	Claudia	García	Hernández	2024-12-18	F	B+	5505777196	paciente1081@example.com
LWTN911227XLYMMY36	Adriana	Delgado	Rodríguez	1991-12-27	Intersex	B+	\N	paciente1082@example.com
YIAA991209XTWLEFS2	Gerardo	Herrera	Morales	1999-12-09	Intersex	AB+	5553793221	paciente1083@example.com
LWJP231031MVHNBYH5	Adriana	Peña	Contreras	2023-10-31	F	AB-	5591150101	paciente1084@example.com
EMLR221021HSWGVI35	Fernando	García	\N	2022-10-21	M	AB-	5533548835	paciente1085@example.com
PSCI890804HMHWQNY4	Andrés	Gómez	Cabrera	1989-08-04	M	A-	5503172665	\N
SFXP020124XVEJABC2	Manuel	Gutiérrez	Ramos	2002-01-24	Intersex	O+	5501460519	\N
DMUG470108MXBUWXM3	Mónica	Vázquez	Rojas	1947-01-08	F	B-	5536930100	paciente1088@example.com
CROQ040903XDXAZJ80	Carlos	Herrera	Delgado	2004-09-03	Intersex	A+	5535415892	paciente1089@example.com
WHUO020310HNNCHY06	Andrés	Jiménez	\N	2002-03-10	M	A+	5508122681	paciente1090@example.com
OALW560927XHCCBL93	Andrés	Contreras	Torres	1956-09-27	Intersex	A-	\N	paciente1091@example.com
EDRS990914MDXJEV19	Claudia	Estrada	Medina	1999-09-14	F	A-	5565016767	paciente1092@example.com
QRZG660909HNHNRQW0	Arturo	Rojas	Ramírez	1966-09-09	M	O-	5562762922	paciente1093@example.com
SWWG240925MOUMCMU2	Karla	Medina	Medina	2024-09-25	F	A+	5598907499	\N
TPPO950210MENKTPY4	Silvia	Fuentes	Chávez	1995-02-10	F	O+	5538580501	paciente1095@example.com
PRSG960229MSCESLZ5	Laura	Vargas	Aguilar	1996-02-29	F	O-	5571148600	paciente1096@example.com
FIIT710807MWUFQO97	Beatriz	López	\N	1971-08-07	F	B-	5503029301	\N
QMUB671226HPIFSYB6	Ricardo	Solís	\N	1967-12-26	M	B-	5522336931	paciente1098@example.com
PUGA550717HEZIZFY6	Roberto	Flores	García	1955-07-17	M	A+	5597537405	paciente1099@example.com
VTLN900828XVYPIBY8	Jorge	Cordero	Gutiérrez	1990-08-28	Intersex	AB-	5554453451	\N
QGVX931226XIQGZJ93	Diego	Salazar	Romero	1993-12-26	Intersex	B-	5562673664	paciente1101@example.com
LQPA830429HQTJHF09	Miguel	Martínez	Contreras	1983-04-29	M	\N	5544369580	paciente1102@example.com
XBTF930502XRIMOFA0	Cecilia	Gutiérrez	Hernández	1993-05-02	Intersex	AB-	5529390773	paciente1103@example.com
LVUV550101MAHRAC02	Patricia	Delgado	Solís	1955-01-01	F	B-	5551502045	\N
CEOT050517HIYVVVO3	Javier	Rodríguez	Ramos	2005-05-17	M	AB-	5553111235	paciente1105@example.com
OIER460507MNVMFZW1	Yolanda	Flores	Gómez	1946-05-07	F	O+	5573838554	paciente1106@example.com
TUCS540217HHKDCPT5	Alejandro	Solís	López	1954-02-17	M	B-	5537062728	paciente1107@example.com
DECV910305MKPLNXK6	Karla	Morales	Torres	1991-03-05	F	B+	5526084818	paciente1108@example.com
BNSH691226XCTNHAP9	Mario	Castillo	Delgado	1969-12-26	Intersex	B-	5567045059	paciente1109@example.com
HVZD860314XFYGIZO8	Manuel	Ramírez	Romero	1986-03-14	Intersex	\N	5504851420	\N
VERF210805XZXHDHQ2	Miriam	Reyes	Mendoza	2021-08-05	Intersex	AB-	5557672991	\N
UIGC000224MQWGUJP6	Gabriela	Delgado	\N	2000-02-24	F	B-	5510297711	paciente1112@example.com
EMZK710619MZCOGF61	Patricia	Delgado	Contreras	1971-06-19	F	AB+	5591087392	\N
KOGV550223XONYPDB5	Verónica	Reyes	González	1955-02-23	Intersex	A+	5577074599	paciente1114@example.com
BAZF970324HAEYUM73	Eduardo	Morales	Díaz	1997-03-24	M	\N	5590345029	paciente1115@example.com
YBIA670721MTYXZGR6	Karla	Castillo	\N	1967-07-21	F	AB-	5541823688	\N
FCBY850909HKDHHIY0	Mario	Reyes	Ramírez	1985-09-09	M	O-	5522013882	paciente1117@example.com
XCYV640409HMQDXY03	Jorge	López	Morales	1964-04-09	M	AB+	5538917369	\N
NPFB820216XBALECQ1	Ana	Delgado	Cordero	1982-02-16	Intersex	O+	5507163485	paciente1119@example.com
DFGO961221HAQLCYH9	Pablo	Cordero	Estrada	1996-12-21	M	O-	5545456972	paciente1120@example.com
ONPC090117MHOOXVH8	Alejandra	Aguilar	Estrada	2009-01-17	F	\N	5526395612	paciente1121@example.com
LPGO920504MDGRQPS0	Beatriz	Vargas	Martínez	1992-05-04	F	A+	5534614466	\N
VDCZ400519MONYDVT2	Claudia	Vázquez	\N	1940-05-19	F	O-	5548319686	\N
MKMR030415MSMSQPB3	Mónica	Guzmán	\N	2003-04-15	F	AB+	5530048379	paciente1124@example.com
LSFX570122HEYWTDK7	Roberto	Jiménez	Pérez	1957-01-22	M	O+	5593410406	paciente1125@example.com
FEQF850320XIPDQGB1	Manuel	Delgado	Fuentes	1985-03-20	Intersex	\N	5596075789	paciente1126@example.com
JSTO821209XTTBKFI1	Laura	Cordero	Cabrera	1982-12-09	Intersex	AB-	5548656581	paciente1127@example.com
CPGU861203XZVWKNP1	Fernanda	Rodríguez	García	1986-12-03	Intersex	AB+	5512975572	paciente1128@example.com
GPRQ881128MCCSGQD6	Laura	Romero	Estrada	1988-11-28	F	\N	5520130716	paciente1129@example.com
WGND530929MZHCPT75	Claudia	Flores	Jiménez	1953-09-29	F	B+	5504903729	paciente1130@example.com
KWNH050724MVTSRYH2	Sofía	Herrera	Medina	2005-07-24	F	AB-	5539225517	paciente1131@example.com
RCUX961015HIPNFDL3	Emilio	Estrada	Gómez	1996-10-15	M	AB+	5518639945	\N
KMGY170427HBTHAY49	Rodrigo	Salazar	Jiménez	2017-04-27	M	AB+	5559096459	paciente1133@example.com
XTTF750414HWDOPUM5	Óscar	Díaz	López	1975-04-14	M	O-	5581133973	paciente1134@example.com
VHWJ821012MAWFJEK2	María	Guzmán	Sánchez	1982-10-12	F	B+	\N	paciente1135@example.com
XHNK090226XJADRDT4	Sergio	Hernández	Reyes	2009-02-26	Intersex	B+	5584202435	\N
VXQN150224XVCKNIA9	Andrés	Vargas	Pérez	2015-02-24	Intersex	B+	5575398913	paciente1137@example.com
CVUT361128MBQFMCE0	Gabriela	Solís	Chávez	1936-11-28	F	A-	5559429920	paciente1138@example.com
SVNT861129HFYFSLO3	Antonio	Guzmán	Aguilar	1986-11-29	M	\N	5594118390	paciente1139@example.com
EJAM690218HNVFQXM4	Pablo	Gutiérrez	Cordero	1969-02-18	M	AB+	5548893343	paciente1140@example.com
XBQN021130HYZLZJL4	Rodrigo	Herrera	Peña	2002-11-30	M	A-	5526928550	paciente1141@example.com
YRUQ110208HZTLTI40	Ricardo	Martínez	Ruiz	2011-02-08	M	A-	5596453591	paciente1142@example.com
DZRQ840828MGABYSV4	Fernanda	Ramos	\N	1984-08-28	F	A+	5573449668	paciente1143@example.com
OANW020728MDOWUA19	Karla	Delgado	Delgado	2002-07-28	F	O+	\N	\N
GZQI570902MZWODKZ7	Ana	Pérez	\N	1957-09-02	F	B-	5550518860	paciente1145@example.com
JWGL070526MTUNSQU0	Paola	Ortiz	Gómez	2007-05-26	F	B+	5505669375	paciente1146@example.com
CPWR860929HSFKZOH4	Emilio	Torres	Salazar	1986-09-29	M	O+	5550385762	paciente1147@example.com
UJSH790501MYXNRBY3	Rosa	González	Reyes	1979-05-01	F	B-	5530101278	paciente1148@example.com
GAYJ670723XUQLEW57	Hugo	Pérez	Peña	1967-07-23	Intersex	B-	5570365620	paciente1149@example.com
UTIM061013XQYTMXP3	Diego	Vázquez	Ortiz	2006-10-13	Intersex	O-	5523357617	paciente1150@example.com
DOJI500716XLOONF02	Yolanda	Hernández	Jiménez	1950-07-16	Intersex	AB+	5567850898	paciente1151@example.com
YLTI390121XVJUHJ65	Guadalupe	Rojas	Rojas	1939-01-21	Intersex	A+	5537740376	paciente1152@example.com
EAPN470701XOLCJT25	María	Ortiz	\N	1947-07-01	Intersex	A-	5515733099	\N
BZNL590627HMLXQEP4	Óscar	López	Díaz	1959-06-27	M	B+	5585653523	paciente1154@example.com
VYAB640531HIOASXF1	Fernando	Alvarado	Solís	1964-05-31	M	O+	5549561199	paciente1155@example.com
RDVK171214XQGXOZR6	Elena	Castillo	Pérez	2017-12-14	Intersex	AB+	\N	paciente1156@example.com
YUNQ680125MPVAIX39	Karla	Alvarado	Medina	1968-01-25	F	AB+	5568290525	paciente1157@example.com
TCIW680225XFWHWHA2	Adriana	Mendoza	\N	1968-02-25	Intersex	A+	5540547398	paciente1158@example.com
CRMM060502HBJPJOP3	Luis	Torres	González	2006-05-02	M	\N	5514785247	\N
TIJD960516MAXVFXO8	Leticia	Ramírez	\N	1996-05-16	F	AB-	5551866477	paciente1160@example.com
VGAE800522HLQLGI05	Luis	Vázquez	González	1980-05-22	M	\N	5553988521	paciente1161@example.com
ZSQJ200718XWVZCF96	Óscar	Ramos	Peña	2020-07-18	Intersex	B-	5581675923	paciente1162@example.com
RWYB170706HXBGRCQ6	Daniel	Jiménez	Cabrera	2017-07-06	M	A-	5592421959	paciente1163@example.com
CQKE100308HPGJCCS6	Gerardo	Hernández	Rodríguez	2010-03-08	M	O-	5515553015	\N
RCVW860306HDBTXNX9	Juan	Gutiérrez	Vargas	1986-03-06	M	\N	5555766345	paciente1165@example.com
SDEN720214MTTIKED6	Laura	Salazar	Gómez	1972-02-14	F	B+	5591061669	\N
IEZX660226HDMREN62	Mario	Herrera	Flores	1966-02-26	M	A+	5575626996	paciente1167@example.com
ZWCX740504HAALSHI5	Arturo	Morales	Rojas	1974-05-04	M	AB-	5528703220	\N
KTPX750808XEIZGR31	Fernanda	Contreras	Díaz	1975-08-08	Intersex	A+	5514520580	paciente1169@example.com
ZMBJ240422HRAFZFQ0	Adrián	Solís	Castillo	2024-04-22	M	AB+	5547476950	paciente1170@example.com
KNMW800605HIGBDMV5	Alejandro	Pérez	Delgado	1980-06-05	M	AB+	5538878887	paciente1171@example.com
HCGM691022MVBNUEI9	Sofía	Alvarado	Peña	1969-10-22	F	O+	5513860479	\N
GQAG240509MKDYXXQ8	Araceli	Pérez	Peña	2024-05-09	F	B-	5582944191	\N
OERH980220XSLCXN43	Rosa	Hernández	Jiménez	1998-02-20	Intersex	O+	5553267084	paciente1174@example.com
ZKMW501108XVESFL82	Pablo	Solís	Romero	1950-11-08	Intersex	A+	5528018323	paciente1175@example.com
XJVN770922HPNUPQB9	Fernando	Medina	Alvarado	1977-09-22	M	AB+	5583744959	paciente1176@example.com
PKLV180616HZWKTUK8	Luis	Jiménez	Morales	2018-06-16	M	AB-	5574114862	paciente1177@example.com
ZTTP150303MNIKHI05	Beatriz	Sánchez	Cordero	2015-03-03	F	B-	\N	paciente1178@example.com
OQTN890722XHXAZBN5	Diego	Gutiérrez	Peña	1989-07-22	Intersex	\N	5501630159	paciente1179@example.com
QIYR140530XZXGJYK7	Manuel	Gómez	Cruz	2014-05-30	Intersex	AB+	5509846018	paciente1180@example.com
ACKH760129MOXHLZ76	María	Vázquez	Gutiérrez	1976-01-29	F	AB+	5571554460	paciente1181@example.com
NPIX451105XMUWEPI0	Manuel	Castillo	\N	1945-11-05	Intersex	B-	5564991192	paciente1182@example.com
QLXB530911MFCLKXN8	Daniela	Vargas	Cruz	1953-09-11	F	A-	5577558212	paciente1183@example.com
PUQI900123MJXMAO99	Mónica	Vázquez	Mendoza	1990-01-23	F	O+	5551991981	paciente1184@example.com
DZJT981202MYFKGVG6	Sofía	González	Díaz	1998-12-02	F	B+	5528385974	paciente1185@example.com
BPAL450308MKJXTIN4	Sofía	Aguilar	Delgado	1945-03-08	F	A-	5568771569	\N
TBPM561112HWHJDLN5	Rodrigo	García	Díaz	1956-11-12	M	AB-	5500115477	paciente1187@example.com
VIWR520417MPEFLL38	Teresa	Torres	González	1952-04-17	F	B-	5513547416	paciente1188@example.com
HERL120218XLLRAYW7	Rodrigo	Contreras	Chávez	2012-02-18	Intersex	B+	5558166028	paciente1189@example.com
FHGX881127MXUZUJ20	Cecilia	Solís	Morales	1988-11-27	F	B+	\N	\N
WDIX681123MPVSPXP4	Carmen	Delgado	Vargas	1968-11-23	F	O-	5559508374	paciente1191@example.com
MDAC710224MOLTVAC1	Guadalupe	Sánchez	Morales	1971-02-24	F	AB-	5567949078	paciente1192@example.com
WEDX900116XZLSZYP8	Eduardo	Herrera	Rodríguez	1990-01-16	Intersex	AB+	5535367355	paciente1193@example.com
ERRG140331XIYCGHW1	Emilio	López	Contreras	2014-03-31	Intersex	A-	5514309742	paciente1194@example.com
PWYX970807MSNOYCR8	Teresa	Jiménez	Jiménez	1997-08-07	F	O+	5500735658	paciente1195@example.com
VNHX090616MPZSIWE2	Leticia	Martínez	Ramos	2009-06-16	F	\N	5586691122	paciente1196@example.com
FZMC961028HDSPZU89	Luis	Torres	Flores	1996-10-28	M	A+	5594657446	paciente1197@example.com
JCDQ000808XDZYWRV1	Fernando	Gómez	Chávez	2000-08-08	Intersex	A-	5573805203	paciente1198@example.com
OXNQ060429XJYDRYR7	Sofía	Fuentes	Delgado	2006-04-29	Intersex	O-	5522014833	\N
RGMA100730MGAQPYZ4	Guadalupe	Rodríguez	Vargas	2010-07-30	F	AB-	5509067618	\N
PNUP250704MWCUNFG7	Fernanda	Cruz	Mendoza	2025-07-04	F	A+	\N	paciente1201@example.com
DQMS981104XHBHVFY4	Pablo	Salazar	\N	1998-11-04	Intersex	B-	5549674199	\N
ZIZZ910110HSBSXW50	Ricardo	Jiménez	Martínez	1991-01-10	M	A-	5551970181	paciente1203@example.com
ESMO761110MAOIFDV3	Elena	Cabrera	Castillo	1976-11-10	F	O-	5562526022	\N
LZIQ841115XAETHGX8	Elena	Martínez	Medina	1984-11-15	Intersex	A-	5543910657	\N
IMSG430510MYWWLDB2	Yolanda	Pérez	Ramos	1943-05-10	F	O-	5512833195	paciente1206@example.com
HKZY420224XTODPPF7	Adriana	Guzmán	García	1942-02-24	Intersex	O+	5556870941	\N
RZHY030103XUURSKN3	Gerardo	García	Castillo	2003-01-03	Intersex	AB-	5541876776	paciente1208@example.com
UWSZ410401HWOVUVO1	Roberto	Díaz	Chávez	1941-04-01	M	AB-	5503324967	paciente1209@example.com
YAJR150421MIRBSJ23	Araceli	Torres	Ramos	2015-04-21	F	O-	5556054270	paciente1210@example.com
PNDD530920XDBPSPZ4	Yolanda	Mendoza	Gutiérrez	1953-09-20	Intersex	AB-	5556572897	\N
IVAY950606MGSATQQ6	Lucía	Cabrera	Medina	1995-06-06	F	\N	5560669926	\N
TYOO220916XOOTLOC3	Alejandro	Romero	Guzmán	2022-09-16	Intersex	AB+	5537792711	\N
RTNF140127MFVZBN82	Beatriz	Reyes	Sánchez	2014-01-27	F	B+	5533302399	paciente1214@example.com
WAMS891001MIWHVAZ9	Mónica	Aguilar	\N	1989-10-01	F	B-	5535786529	paciente1215@example.com
ZMII221011HQRKJR45	Arturo	Ramos	Hernández	2022-10-11	M	A-	5598042554	paciente1216@example.com
YJEL881208XKZAPR18	Lucía	García	Vargas	1988-12-08	Intersex	\N	5578602039	paciente1217@example.com
CTWK220902HRMNGSI8	Carlos	Reyes	Guzmán	2022-09-02	M	AB-	5572873142	paciente1218@example.com
VSMJ830323XJDNAHM2	Rodrigo	Romero	Sánchez	1983-03-23	Intersex	\N	5507005102	paciente1219@example.com
VFXW120715MUYACX55	Alejandra	Pérez	Martínez	2012-07-15	F	B+	5541648792	paciente1220@example.com
NEOK890502XUXAYDW2	Miguel	Hernández	Díaz	1989-05-02	Intersex	AB+	5597442036	\N
ZGGA420215XSLQPEP8	Araceli	Ramos	Fuentes	1942-02-15	Intersex	A-	5506014579	\N
QWDT950113HUOADLC1	Roberto	Rojas	Fuentes	1995-01-13	M	AB+	5572092519	\N
HHWE140528HSOAISM7	Diego	Salazar	Ruiz	2014-05-28	M	B-	5591585511	paciente1224@example.com
TFAZ000526HOKOJWH4	Pablo	Estrada	Pérez	2000-05-26	M	A+	5573962625	paciente1225@example.com
USZP981016XXOHYU17	Patricia	Reyes	Gómez	1998-10-16	Intersex	AB-	5544343549	paciente1226@example.com
PDKM930409XYWJHQC2	Guadalupe	Flores	Aguilar	1993-04-09	Intersex	O+	5534804247	paciente1227@example.com
SJAT210407MCNWLPO7	Guadalupe	Solís	\N	2021-04-07	F	AB+	5526622549	\N
TYCW201223HIUBDVV2	Antonio	Romero	Jiménez	2020-12-23	M	AB-	5517226414	paciente1229@example.com
AUCQ461124MIETZHN5	Daniela	Cabrera	García	1946-11-24	F	\N	5547422983	paciente1230@example.com
WPZP431215XZCLHTB2	Silvia	Chávez	Romero	1943-12-15	Intersex	A+	5524736500	paciente1231@example.com
WUBN220502HJONCUT4	Andrés	Cabrera	\N	2022-05-02	M	A+	5573554042	paciente1232@example.com
WXBX601010HNOLZIO9	Roberto	Peña	Cruz	1960-10-10	M	A-	5539690453	paciente1233@example.com
QPRW100130XHKOGH61	Adriana	Gómez	Ruiz	2010-01-30	Intersex	A-	5573453302	paciente1234@example.com
YPIA990611MUSRLG32	Gabriela	Rodríguez	Cruz	1999-06-11	F	O+	5550516023	paciente1235@example.com
LKRP921207MBZSIUD4	Laura	Martínez	Pérez	1992-12-07	F	A+	5545641199	\N
ZBPY791203MQCSCHW0	Yolanda	Pérez	Jiménez	1979-12-03	F	B-	5534941971	paciente1237@example.com
MNZH450709MFQUUER6	Yolanda	Chávez	Sánchez	1945-07-09	F	A-	\N	paciente1238@example.com
VRVL650705HWNHKEA0	Rodrigo	Romero	González	1965-07-05	M	AB-	5515042059	paciente1239@example.com
OOCJ720419MGVGWNB8	Rosa	Ruiz	Romero	1972-04-19	F	O+	5590101461	paciente1240@example.com
QRDR780908XTGBIZZ1	Fernando	Estrada	Medina	1978-09-08	Intersex	AB+	5588168785	\N
UBVS940417XMKMYR82	Iván	Romero	López	1994-04-17	Intersex	AB+	5580072720	paciente1242@example.com
OGLN080529XJAOQHB8	Antonio	Ortiz	Solís	2008-05-29	Intersex	A-	\N	paciente1243@example.com
SLDU690429MILJTRN6	Araceli	Herrera	Delgado	1969-04-29	F	AB-	5546749066	paciente1244@example.com
YPDC950613XNJLNBW9	Emilio	Vargas	Salazar	1995-06-13	Intersex	B-	5534318073	paciente1245@example.com
LNKY501102HZGHYP47	José	López	Herrera	1950-11-02	M	A-	\N	\N
FNDL550707MJRPVEA1	Paola	Salazar	Delgado	1955-07-07	F	A+	5502545500	paciente1247@example.com
SSRG660102MSPMUOP8	Silvia	López	López	1966-01-02	F	\N	5546163034	\N
CJHK730905HFTJTHB7	Gerardo	Hernández	\N	1973-09-05	M	B+	5599654662	paciente1249@example.com
ZMFE710528MKEOYKZ0	Miriam	Morales	Herrera	1971-05-28	F	O+	5530234056	paciente1250@example.com
LQSX660804MBIDQUK8	Yolanda	Rodríguez	Pérez	1966-08-04	F	O+	5566608123	paciente1251@example.com
UTBS820222MRMZGNF5	Rosa	Salazar	Díaz	1982-02-22	F	A+	5595844420	\N
MGXC761130MHOHOCT5	Miriam	Salazar	Fuentes	1976-11-30	F	O+	5511802669	paciente1253@example.com
SNAM650902MCAIOZF8	Carmen	Sánchez	Reyes	1965-09-02	F	O-	5599256924	paciente1254@example.com
CBHI991008MCICGYE8	Elena	Salazar	Vázquez	1999-10-08	F	O-	5581405132	paciente1255@example.com
OBQL971006HNASXID6	Sergio	Delgado	Gutiérrez	1997-10-06	M	AB-	5587831031	\N
YEOK140706MVPTIZD7	Beatriz	Aguilar	Guzmán	2014-07-06	F	B+	\N	\N
QOAT700914MHHTDWO6	Mónica	Torres	Delgado	1970-09-14	F	B+	\N	paciente1258@example.com
AHFN910304MYZOLHE8	Gabriela	González	\N	1991-03-04	F	O+	5563101089	paciente1259@example.com
HMBM961102MJABIOS8	Gabriela	Romero	Flores	1996-11-02	F	AB+	5548698948	\N
ZDAB890518HOZOAYE7	Sergio	García	Reyes	1989-05-18	M	AB-	5537594933	paciente1261@example.com
DSWY860120HNBBITB2	Sergio	Herrera	González	1986-01-20	M	O-	5541559674	\N
NWKL600317HFHSDPB3	Hugo	Herrera	Cabrera	1960-03-17	M	A-	5500499926	paciente1263@example.com
UOHD821121MOGSJY12	Claudia	Aguilar	Peña	1982-11-21	F	B+	5523858653	paciente1264@example.com
OVCI760202HWCHISM1	Diego	Guzmán	Aguilar	1976-02-02	M	AB-	5567060558	paciente1265@example.com
EDWD710327MMEKAM99	Yolanda	Jiménez	Contreras	1971-03-27	F	A-	5554646398	paciente1266@example.com
KLPA671017MHTWHII7	María	Rodríguez	Solís	1967-10-17	F	O-	5566925529	paciente1267@example.com
FMBA421107XBVCZZH0	Carlos	Ramos	\N	1942-11-07	Intersex	O-	5561619738	\N
CHAB130328MVXRQEM8	Beatriz	Peña	Pérez	2013-03-28	F	B+	5569908672	\N
DPVO780405HUHUNLU6	Luis	Hernández	Torres	1978-04-05	M	O-	5521882206	\N
MCUU820812HUWHAEM6	Arturo	Castillo	Sánchez	1982-08-12	M	B+	5569368359	paciente1271@example.com
HEHZ500907MSVCWSO2	Yolanda	Contreras	García	1950-09-07	F	B-	5582671269	\N
FFKF961213XTNYIIT8	Arturo	Estrada	Cabrera	1996-12-13	Intersex	B+	5536868111	paciente1273@example.com
WQAK710618HRPPCKU5	Antonio	López	Martínez	1971-06-18	M	O+	5562787902	paciente1274@example.com
IMHO600409XFDNFXZ6	Francisco	Cruz	\N	1960-04-09	Intersex	O+	5535841802	paciente1275@example.com
YHXO830919MZSGTL59	Lucía	Peña	Rojas	1983-09-19	F	B-	5519247411	\N
GWQN240903XELMUO11	Fernando	Castillo	Contreras	2024-09-03	Intersex	O-	5584233008	\N
ESFU621228MIUREQ33	Adriana	López	Medina	1962-12-28	F	A+	5507883127	\N
APEA090329MCTOARS2	Sofía	Ortiz	Cruz	2009-03-29	F	\N	5516279636	paciente1279@example.com
WAAL640502HCBQDTT8	Andrés	Chávez	Pérez	1964-05-02	M	B+	5526230036	\N
XUQH111218MAWGVIJ4	Patricia	Ramírez	López	2011-12-18	F	A-	5553916928	\N
NZNT140813XMRPXVT0	Antonio	Romero	Jiménez	2014-08-13	Intersex	A-	5504544106	\N
RJJZ640319MXKRADV1	Mónica	Delgado	Martínez	1964-03-19	F	AB-	5529628092	\N
TZNT670118HSWNDXM1	Eduardo	García	Martínez	1967-01-18	M	B-	5555232280	paciente1284@example.com
HLIX980614XBWWJPZ2	Roberto	Contreras	Solís	1998-06-14	Intersex	B-	5539501115	paciente1285@example.com
OWRR840314MRFMBHF7	Alejandra	Medina	Gómez	1984-03-14	F	B+	5503045880	paciente1286@example.com
ZJEF190910XTHLWKS5	María	Sánchez	Alvarado	2019-09-10	Intersex	A+	\N	paciente1287@example.com
TTCD810331MVGZOS93	Silvia	Romero	Vargas	1981-03-31	F	O+	5557627451	\N
QSOB381124MZYDLVK2	María	Salazar	Ruiz	1938-11-24	F	O-	5536896008	\N
SQST680918MXHAVPR6	Daniela	González	Medina	1968-09-18	F	O-	5539979927	\N
QVPX061014MRQVLE65	Miriam	Castillo	Jiménez	2006-10-14	F	\N	5586818439	paciente1291@example.com
UAPH241220XPSJTST4	Raúl	Hernández	Cabrera	2024-12-20	Intersex	B-	5544410769	paciente1292@example.com
KJUH560720HJYOLSG6	Rodrigo	Alvarado	Solís	1956-07-20	M	O+	5543598398	paciente1293@example.com
TWZS521109XNLQKO63	Alejandra	Cabrera	Contreras	1952-11-09	Intersex	AB-	5581678434	paciente1294@example.com
VDZV670326MOOMDVM5	Leticia	Vázquez	Vargas	1967-03-26	F	O+	5507883692	\N
GNSS040716HTKERKC2	Iván	Medina	García	2004-07-16	M	A-	\N	paciente1296@example.com
HKWV840805HWKZDJ22	Adrián	Castillo	Flores	1984-08-05	M	B+	5503223477	\N
HWLK730329MLLWOBJ0	Carmen	Peña	López	1973-03-29	F	O+	5574136445	paciente1298@example.com
RSHV160126MTCUEPA6	Carmen	Castillo	Flores	2016-01-26	F	B-	\N	paciente1299@example.com
RUHU440604HWUALMS4	Mario	Cruz	Cruz	1944-06-04	M	AB+	5553045555	paciente1300@example.com
APPP870412HYRTZVT3	Miguel	Romero	Ramos	1987-04-12	M	A-	5576399046	\N
VENS610124XAFVFED9	Eduardo	Reyes	Aguilar	1961-01-24	Intersex	AB-	5550617906	paciente1302@example.com
BBGS100401MGIJTB36	María	González	Rodríguez	2010-04-01	F	AB-	5516218333	paciente1303@example.com
MZUT731119XEDAKHB7	Beatriz	González	Flores	1973-11-19	Intersex	O-	5560082283	paciente1304@example.com
JTRK970605MPXRROK8	Diana	Díaz	Hernández	1997-06-05	F	A+	\N	\N
CFNS390813HRBJIN05	Iván	Herrera	Martínez	1939-08-13	M	\N	5524760960	paciente1306@example.com
KFLO430627MGOROWQ7	Karla	Cruz	Torres	1943-06-27	F	AB-	5584070946	paciente1307@example.com
TQQT121221MOERJEZ8	Karla	Hernández	Pérez	2012-12-21	F	O+	5528261641	paciente1308@example.com
QNBK671031HMXWMR60	Ricardo	Morales	González	1967-10-31	M	A-	\N	paciente1309@example.com
SLUC381008XEOSQGH2	Pablo	Aguilar	Guzmán	1938-10-08	Intersex	B+	5553541601	paciente1310@example.com
QOAW231220HDPAWQZ7	Andrés	Salazar	Salazar	2023-12-20	M	O-	5507710740	\N
MOWE720303HUJNCVD5	Fernando	Salazar	Vargas	1972-03-03	M	O-	\N	paciente1312@example.com
DPRX520807XLAXFAX0	José	Hernández	Hernández	1952-08-07	Intersex	A+	5549723920	\N
TZTP930114XIUOVWV3	Eduardo	Peña	Guzmán	1993-01-14	Intersex	AB+	5574425269	paciente1314@example.com
MJDL180404MYXGOJC5	Lucía	Cordero	Ortiz	2018-04-04	F	O-	5533793766	paciente1315@example.com
VMYA590112XQKKPYF7	Mónica	Vargas	Sánchez	1959-01-12	Intersex	B+	5505849688	\N
GZKQ200704MMFJXBW7	Silvia	Peña	\N	2020-07-04	F	B+	5509998632	\N
DDCW151208HBWQLZE8	Ricardo	Cruz	Delgado	2015-12-08	M	B+	5568985932	\N
GBVO651227MXWGUI80	Leticia	Cabrera	Medina	1965-12-27	F	O+	5526425972	\N
PZRD790509MWTECYS7	Gabriela	Fuentes	Cabrera	1979-05-09	F	B+	5584746042	paciente1320@example.com
PZFC640714MINCOF55	Laura	Guzmán	Torres	1964-07-14	F	\N	\N	\N
QQUT700222HOSRQO45	Andrés	Gómez	Alvarado	1970-02-22	M	B+	5584741340	\N
AWKT880603XNFWOKE9	Alejandro	Delgado	Vázquez	1988-06-03	Intersex	A-	5538901248	\N
DCLN890319MRZMEWI3	Paola	Estrada	Ruiz	1989-03-19	F	O+	5570659480	paciente1324@example.com
EOUJ620508HHHBGOL7	Carlos	Aguilar	\N	1962-05-08	M	O-	5524475631	paciente1325@example.com
APRF630126HRPRYZD6	Miguel	Solís	Fuentes	1963-01-26	M	AB+	\N	paciente1326@example.com
MMHL790830MNKWJC70	Sofía	Peña	Ramos	1979-08-30	F	A+	5588252128	paciente1327@example.com
KTIM420921MSWTQYT2	Daniela	Delgado	\N	1942-09-21	F	\N	5528470520	\N
OCZX751126XYFGXFB3	Sergio	Flores	Fuentes	1975-11-26	Intersex	AB+	5586427786	\N
OXMA780406XXHEAQ47	Karla	Ramos	Cruz	1978-04-06	Intersex	\N	5547106283	paciente1330@example.com
LPHK620723MNFGUE27	Cecilia	Solís	Solís	1962-07-23	F	O+	\N	paciente1331@example.com
BEYO060224MHXUVEK8	Rosa	Ruiz	Guzmán	2006-02-24	F	B-	5570424025	paciente1332@example.com
SZOO370920MUBJDD07	Daniela	Herrera	Jiménez	1937-09-20	F	\N	5515964673	paciente1333@example.com
IQVI390406MXVNPXO3	Fernanda	Estrada	\N	1939-04-06	F	A+	5591248955	paciente1334@example.com
NFHV490727XTIKSSR2	Mario	Martínez	\N	1949-07-27	Intersex	AB+	5576089530	\N
QAWD740126XHXQPCY2	Carlos	Jiménez	Reyes	1974-01-26	Intersex	\N	5556890581	\N
OIZG070312XKMOAE27	Juan	Sánchez	Vázquez	2007-03-12	Intersex	A+	5571565969	paciente1337@example.com
PKSK940111XTSLLAV5	Araceli	Delgado	Ortiz	1994-01-11	Intersex	A-	5562917148	paciente1338@example.com
FWKE941015MXVLEZD7	Araceli	González	Peña	1994-10-15	F	\N	5582165119	paciente1339@example.com
JWJK810825HEBZGBI7	Luis	Gutiérrez	Mendoza	1981-08-25	M	AB+	5547308824	paciente1340@example.com
XCZF100412HXJJAXL9	Emilio	Mendoza	Reyes	2010-04-12	M	A-	5563409412	paciente1341@example.com
VFLP610414HSKSSBB4	Emilio	Salazar	Mendoza	1961-04-14	M	AB-	5541232546	\N
ZJXX070611XHIZQWX7	Yolanda	Estrada	Sánchez	2007-06-11	Intersex	O-	5599627686	\N
DEAY561102MFTCWWN8	Adriana	Ortiz	Sánchez	1956-11-02	F	O-	5501494802	paciente1344@example.com
CSMV611130XNJZLFM1	Carlos	Salazar	Herrera	1961-11-30	Intersex	O-	5590821335	paciente1345@example.com
YNUM041015XPBJWWE7	Rosa	Vázquez	Cruz	2004-10-15	Intersex	O-	\N	paciente1346@example.com
QZYP460131XJBKADP3	Verónica	Cabrera	Sánchez	1946-01-31	Intersex	A+	\N	paciente1347@example.com
PCIQ230330HPYMLB57	Alejandro	Torres	Alvarado	2023-03-30	M	B-	5525723163	\N
XCCU800715HVXYBK20	Emilio	Morales	Cordero	1980-07-15	M	A-	5599630667	\N
MMVT480506MHWEYHN7	Teresa	Estrada	Estrada	1948-05-06	F	O+	\N	\N
PCIU730914XBRNGHL3	Óscar	Herrera	Martínez	1973-09-14	Intersex	B+	5506587448	paciente1351@example.com
OKTX031126XASPFE75	Roberto	Peña	Flores	2003-11-26	Intersex	\N	5525854551	\N
GJQF390408HYYHNP88	Mario	Cabrera	Martínez	1939-04-08	M	A-	5573693238	\N
QJNN930127MZIQNX44	Miriam	Reyes	Vargas	1993-01-27	F	O-	5571206317	paciente1354@example.com
ILQJ141022HAQDDXR4	Daniel	Vargas	López	2014-10-22	M	O-	5528143611	paciente1355@example.com
GMCC480809MQTFMXB5	Laura	Rodríguez	Martínez	1948-08-09	F	B-	5546542683	paciente1356@example.com
IZAG370116MJZVIUU4	Yolanda	Jiménez	Pérez	1937-01-16	F	B-	5556600301	\N
HQMZ391206MSPIVEG7	Cecilia	Ramírez	Cruz	1939-12-06	F	A-	5583850957	\N
TSCN610628XVLBRDE3	Roberto	Torres	\N	1961-06-28	Intersex	AB+	5540348484	\N
NFZP630929XSKWVSV1	María	Contreras	\N	1963-09-29	Intersex	B+	5595449669	paciente1360@example.com
WWLN500223HEPKFQA0	Emilio	Pérez	Guzmán	1950-02-23	M	O-	5517344794	paciente1361@example.com
NWGR520709MHFNIX69	Silvia	Gómez	Sánchez	1952-07-09	F	AB-	5500170781	\N
MCXX850703XHBIYST8	Gabriela	Ortiz	Ramos	1985-07-03	Intersex	B+	\N	paciente1363@example.com
ZHKW490905MLYEZRM3	Verónica	Solís	Solís	1949-09-05	F	AB-	5587567981	paciente1364@example.com
IUOW911017HPDCKQ92	Adrián	Ramírez	Chávez	1991-10-17	M	O-	5570894107	paciente1365@example.com
MIIM420112HWUCDS63	Carlos	Romero	Gutiérrez	1942-01-12	M	O+	5575424738	paciente1366@example.com
PXVP040207XJRVXP30	Silvia	Ramos	Gómez	2004-02-07	Intersex	O+	5581253251	\N
FYFM381024XPSSBT06	Rosa	Salazar	Salazar	1938-10-24	Intersex	AB+	5528653839	paciente1368@example.com
VQED570926MYWAAG40	Karla	González	Castillo	1957-09-26	F	O+	5537808866	paciente1369@example.com
ZYWB531201XSQHIQR9	Sergio	Flores	\N	1953-12-01	Intersex	A+	5567487629	paciente1370@example.com
KMKO521118HENPMLR1	Diego	Guzmán	Díaz	1952-11-18	M	\N	5517947795	\N
EBFN580108HFMTHBN2	Francisco	Gutiérrez	Ramírez	1958-01-08	M	AB+	5545257330	paciente1372@example.com
YIYY580220XBXMHKF6	Silvia	López	Contreras	1958-02-20	Intersex	\N	5524767512	paciente1373@example.com
ABXZ720627XLGMXY09	Roberto	Guzmán	Cabrera	1972-06-27	Intersex	A-	5576334228	paciente1374@example.com
OEZH050109XPVFFKN1	Pablo	Flores	Herrera	2005-01-09	Intersex	O+	5537008942	paciente1375@example.com
IGGH240926MYGVDU88	Araceli	López	Vargas	2024-09-26	F	A-	5556125780	\N
LYVV690720HDPNSVY8	Sergio	Rodríguez	Cordero	1969-07-20	M	O+	5564554421	paciente1377@example.com
VFNJ700119XAKGWE23	Karla	Fuentes	Contreras	1970-01-19	Intersex	AB+	5559342883	paciente1378@example.com
TOVV440131XQGVGCX0	Luis	Jiménez	Peña	1944-01-31	Intersex	A-	5598596551	paciente1379@example.com
NXUQ860819XMUVYBZ7	Juan	Ramírez	Castillo	1986-08-19	Intersex	A-	5576714998	paciente1380@example.com
XAHQ171001HKFJEPY2	Javier	Delgado	Peña	2017-10-01	M	A+	5559637439	paciente1381@example.com
TJAG950710MRSLKZS6	Adriana	Estrada	Peña	1995-07-10	F	B-	5553170873	\N
XZOG120806HMVMHVK5	Rodrigo	Pérez	\N	2012-08-06	M	AB+	5573223487	\N
ZDSD250413HBTAJR76	Andrés	González	Castillo	2025-04-13	M	AB+	5507326447	paciente1384@example.com
PQLT660215XLUICP10	Leticia	Cabrera	Morales	1966-02-15	Intersex	O+	5571645810	\N
SJIP860907MZGWHR28	Leticia	Reyes	Romero	1986-09-07	F	O+	5552890566	paciente1386@example.com
OOCS590503HQYRQH24	Javier	Morales	Gutiérrez	1959-05-03	M	A-	5550968593	paciente1387@example.com
QSUS210910MVMIMZK4	Verónica	Chávez	Reyes	2021-09-10	F	A-	5535486952	paciente1388@example.com
HQOC221107HAQRBGV4	Emilio	Rodríguez	Aguilar	2022-11-07	M	AB+	5566049037	paciente1389@example.com
VXCN140930MCFFDZV0	Mónica	Contreras	Delgado	2014-09-30	F	A-	5565586819	paciente1390@example.com
HGGL710918HERNWWZ0	Juan	Gutiérrez	Herrera	1971-09-18	M	O-	5585500295	paciente1391@example.com
ACFJ470225MZLODRF5	Claudia	Herrera	\N	1947-02-25	F	\N	\N	paciente1392@example.com
YSDG741006XMUZXLC5	Lucía	Pérez	Estrada	1974-10-06	Intersex	B-	5519396871	paciente1393@example.com
UJTE240916XTGWFY95	Guadalupe	González	Fuentes	2024-09-16	Intersex	O+	5519612933	paciente1394@example.com
EBSY110205HZIBVBN7	Gerardo	Morales	Ruiz	2011-02-05	M	O-	5577588562	paciente1395@example.com
WFNZ190812MXEXBUO0	Elena	García	Rodríguez	2019-08-12	F	AB+	5551657121	\N
DVXE450124MVWUYHO3	Guadalupe	Cordero	Pérez	1945-01-24	F	O+	5559879206	paciente1397@example.com
NRVW711128HQWTDAY1	Carlos	Ortiz	Ramos	1971-11-28	M	AB+	5504505211	\N
DMZI790310HYDWRYA4	Emilio	Vázquez	García	1979-03-10	M	B+	5560819714	\N
IISL960709XAMASVV8	Diana	Reyes	Cabrera	1996-07-09	Intersex	O+	5527456698	\N
UBPI740620XETICJJ9	Alejandra	Fuentes	Ruiz	1974-06-20	Intersex	O+	5557762538	\N
LGBD530523MMJPEQZ1	Beatriz	Aguilar	Estrada	1953-05-23	F	AB-	5568590262	paciente1402@example.com
EYXR910109MMNAYGT9	Fernanda	Pérez	Aguilar	1991-01-09	F	\N	5568967016	paciente1403@example.com
FCLP210919HEGCWEU2	Emilio	Rojas	Ortiz	2021-09-19	M	B+	5535256008	paciente1404@example.com
COFD461202XLBKYEA5	Diana	Peña	Aguilar	1946-12-02	Intersex	A-	5513184560	paciente1405@example.com
EXWW120501XDATCER4	Sergio	Ortiz	Reyes	2012-05-01	Intersex	A-	5541408783	\N
YREW720825HJBYEDH6	Hugo	Solís	Guzmán	1972-08-25	M	\N	5513799818	\N
NLOQ110224HYTYZNN5	Juan	Cabrera	Gutiérrez	2011-02-24	M	B-	5574526348	paciente1408@example.com
UEKJ511026XJXFEUU3	Manuel	Morales	Rojas	1951-10-26	Intersex	B-	5578828050	paciente1409@example.com
QPFA081227MIOMPNY6	Alejandra	Mendoza	Herrera	2008-12-27	F	O+	5588745871	paciente1410@example.com
VGWM190404HRLTGDX2	Juan	Solís	Vázquez	2019-04-04	M	AB+	5507414430	paciente1411@example.com
ESZT931105HMJLWOT4	José	Aguilar	Ortiz	1993-11-05	M	A-	5599711533	paciente1412@example.com
NTOA691201MCAYBXN4	Carmen	Delgado	Flores	1969-12-01	F	A-	5599758586	paciente1413@example.com
MBWZ791030XEDLSSJ7	Laura	Herrera	Guzmán	1979-10-30	Intersex	B+	5563827490	paciente1414@example.com
TKIR050308HBOAJON1	Francisco	Sánchez	Gómez	2005-03-08	M	B+	5583687477	paciente1415@example.com
MNYL890811MMAAVOY2	Mónica	García	Jiménez	1989-08-11	F	A+	5582128219	paciente1416@example.com
PRZI101207HYOENIN9	Diego	Medina	Fuentes	2010-12-07	M	A-	5504596920	paciente1417@example.com
RLHD010325MFGIUIN5	Lucía	Castillo	\N	2001-03-25	F	\N	5549811846	paciente1418@example.com
HORV580705HCPYWAT8	Alejandro	Gómez	Aguilar	1958-07-05	M	A-	5548116595	paciente1419@example.com
IFCT740511XHPSYGG3	Miriam	Salazar	Mendoza	1974-05-11	Intersex	AB+	5565972767	paciente1420@example.com
ZRNC930512MGYJCPQ9	Paola	Rojas	Vázquez	1993-05-12	F	O-	5538088426	paciente1421@example.com
ZPMD641008HLABDCF3	Francisco	Morales	García	1964-10-08	M	O-	5580442364	paciente1422@example.com
ACAX710730HQMDZMQ7	Gerardo	González	Delgado	1971-07-30	M	O+	5599157380	paciente1423@example.com
OFBS910104XVMDBZL3	Claudia	Aguilar	Jiménez	1991-01-04	Intersex	AB-	5543205869	paciente1424@example.com
PDVY370611HULLVOM2	Mario	Díaz	Peña	1937-06-11	M	AB-	5511549177	\N
SNQK390114HNQRWR96	Rodrigo	Romero	\N	1939-01-14	M	O-	\N	paciente1426@example.com
MPSJ801017MGWGNIR7	Lucía	Estrada	Ruiz	1980-10-17	F	O+	5532767659	paciente1427@example.com
MMTI590323MSUIOXF5	Diana	Ramos	Cordero	1959-03-23	F	B-	5534745024	\N
ARXI670827MVXQTMU3	Adriana	Vargas	Estrada	1967-08-27	F	B+	5503754807	paciente1429@example.com
MSGF920517MXTDHNY4	Adriana	Fuentes	Fuentes	1992-05-17	F	\N	\N	paciente1430@example.com
ZICL381207HAXMGFQ0	Raúl	Jiménez	Hernández	1938-12-07	M	B-	5526583879	paciente1431@example.com
UNIW000707HZMNXBP3	Mario	Ortiz	Contreras	2000-07-07	M	A+	5539974159	\N
CAFU201213HPNBPZ81	Iván	Cabrera	González	2020-12-13	M	B-	5548497797	\N
GKOU030302HLIWPQN5	Antonio	Martínez	Torres	2003-03-02	M	O+	5552602706	paciente1434@example.com
CUWR820806MVDFTFP6	Alejandra	Alvarado	Hernández	1982-08-06	F	O-	5591237745	paciente1435@example.com
XGHP621213XNQOAK60	Laura	Gutiérrez	Rodríguez	1962-12-13	Intersex	AB-	5506510640	paciente1436@example.com
OQXI980913MQGZAHQ8	Rosa	Vázquez	Cordero	1998-09-13	F	B-	5565404492	paciente1437@example.com
ORQH150307XZVZMZQ3	Carlos	Peña	\N	2015-03-07	Intersex	O-	5585984440	paciente1438@example.com
AGFU060524XBOULNA5	Claudia	Chávez	Delgado	2006-05-24	Intersex	A+	5590152302	paciente1439@example.com
ATFH060204XLMLIAP0	Fernanda	Peña	Morales	2006-02-04	Intersex	AB-	5591540273	paciente1440@example.com
LGCR710129HKAAJEM1	Carlos	Cruz	Solís	1971-01-29	M	\N	5506820481	paciente1441@example.com
LJQJ440221HWOGQL27	Daniel	Reyes	Hernández	1944-02-21	M	AB-	5598245538	paciente1442@example.com
VGYQ120912MENIESW1	Yolanda	Pérez	Rojas	2012-09-12	F	\N	5555768815	paciente1443@example.com
SNXX140814XTKJIX67	Luis	Reyes	Medina	2014-08-14	Intersex	AB+	5550488491	paciente1444@example.com
IJNW670111MJBHKA26	Diana	Martínez	Ramírez	1967-01-11	F	B-	5559355881	paciente1445@example.com
YKJO860521XYOUPPR5	Silvia	Ramírez	Vargas	1986-05-21	Intersex	A+	5512387249	paciente1446@example.com
PBWJ240318HKLTJRT9	Raúl	Estrada	López	2024-03-18	M	AB+	5541662395	paciente1447@example.com
SHKA930129XFYONOQ9	Beatriz	Rojas	Ramos	1993-01-29	Intersex	O+	5512272765	\N
IDPU070815HBBKJLV8	Manuel	Mendoza	Solís	2007-08-15	M	A-	5555955621	paciente1449@example.com
YNNQ621230XBRZTLA4	Fernanda	Vázquez	Guzmán	1962-12-30	Intersex	O-	\N	paciente1450@example.com
LKVP171009XRKYFC39	Carlos	Ortiz	Guzmán	2017-10-09	Intersex	A-	5586093160	paciente1451@example.com
CBLL371111XZYRGTF1	Ana	Fuentes	Martínez	1937-11-11	Intersex	O-	5532026400	paciente1452@example.com
HPSB861108HFAVVH88	Hugo	Reyes	Cabrera	1986-11-08	M	AB-	5518893844	paciente1453@example.com
ONMH560524MXIZEXA8	Rosa	Rodríguez	Romero	1956-05-24	F	A-	5512426647	\N
OURG020816XYVYFY59	Miriam	Romero	Martínez	2002-08-16	Intersex	AB+	5579581877	paciente1455@example.com
QOVC901130MJIMTGV3	Mónica	Peña	Gutiérrez	1990-11-30	F	O-	5556642394	\N
ARSZ570823HMIYSMY6	Óscar	Aguilar	Delgado	1957-08-23	M	\N	\N	paciente1457@example.com
ZEHV550817XYUUUER6	Patricia	Gómez	Cabrera	1955-08-17	Intersex	\N	5520373378	paciente1458@example.com
JWQK810809HPQHBIV5	Roberto	González	Romero	1981-08-09	M	AB+	5557657868	paciente1459@example.com
MUXP430706HUNIUIQ3	Mario	Ruiz	Ramírez	1943-07-06	M	AB+	5527056146	paciente1460@example.com
ECVQ990723MNOIOWG5	Carmen	Torres	Hernández	1999-07-23	F	A+	\N	paciente1461@example.com
VVAZ940721XKNLUDP3	Claudia	Pérez	Herrera	1994-07-21	Intersex	B-	5585081432	paciente1462@example.com
NNWG450130XFPVSWD4	Claudia	Medina	Guzmán	1945-01-30	Intersex	A+	5581060891	paciente1463@example.com
CQIL710818MOUYJS05	Guadalupe	López	Ramírez	1971-08-18	F	O+	5527025996	\N
GBJA520110HUPPXXX1	Pablo	Ortiz	Medina	1952-01-10	M	A-	\N	\N
MRSO151225XJKZGOH4	Silvia	Cruz	Ramírez	2015-12-25	Intersex	AB-	5520431927	\N
BFHG900107HMCNLK60	Jorge	Romero	Ruiz	1990-01-07	M	AB+	5547555267	paciente1467@example.com
BEOX580908HKDAAL18	Hugo	Reyes	Guzmán	1958-09-08	M	AB-	\N	paciente1468@example.com
WQCM180409MOWTGZL3	Karla	González	Gómez	2018-04-09	F	B-	5539330548	\N
PBOS960121XJGEDW73	Karla	Chávez	Romero	1996-01-21	Intersex	O+	5526468551	paciente1470@example.com
CKWJ440618HRQBYKG0	Rodrigo	López	Cordero	1944-06-18	M	A-	5565336330	paciente1471@example.com
WBAS831224XRJDMYQ3	Teresa	Mendoza	Morales	1983-12-24	Intersex	AB-	5502170470	\N
GUSX480508HPCOURX6	Ricardo	Peña	Jiménez	1948-05-08	M	\N	5569750591	paciente1473@example.com
BVLX370922XLSCYM93	Raúl	Cabrera	González	1937-09-22	Intersex	A-	5517936470	paciente1474@example.com
LWWZ910219XUJLEXV9	Miriam	Torres	López	1991-02-19	Intersex	A-	5557076509	\N
NEUX961231HFODSVK6	Diego	García	Cordero	1996-12-31	M	O+	5561186801	\N
UCSI730107XSARCU30	Leticia	Jiménez	García	1973-01-07	Intersex	O+	5527628058	paciente1477@example.com
VSOE001102MWMQEDG9	Yolanda	Rojas	Pérez	2000-11-02	F	B-	5596460773	paciente1478@example.com
DSFE640317XBLDGLZ3	Rodrigo	Aguilar	Cabrera	1964-03-17	Intersex	AB-	5589250075	\N
UPGL880530MRDREXH7	Diana	Díaz	Herrera	1988-05-30	F	AB-	5574779359	paciente1480@example.com
RHLM060506XTSSPYH2	Daniela	Ramos	Gutiérrez	2006-05-06	Intersex	B-	5501930646	paciente1481@example.com
CSNS731211HSGGLHC3	Miguel	Aguilar	Sánchez	1973-12-11	M	O-	5587830568	\N
KFNW960308XFBETVR8	Rosa	Guzmán	Reyes	1996-03-08	Intersex	AB-	5581128269	paciente1483@example.com
HSFZ850307XEESHC27	Roberto	Ortiz	Sánchez	1985-03-07	Intersex	\N	5503947505	paciente1484@example.com
OJGC180830MEVJGJU3	Miriam	Rojas	Cabrera	2018-08-30	F	B-	5511575092	paciente1485@example.com
XZGM220818MSWLOUW6	Verónica	Hernández	Medina	2022-08-18	F	A+	5543391686	paciente1486@example.com
MSYI240401MHYSUIR1	María	Herrera	Chávez	2024-04-01	F	O+	5510427974	paciente1487@example.com
QZCQ160227MRUTNTH3	Mónica	Delgado	García	2016-02-27	F	A+	5593575384	paciente1488@example.com
GJOL220514XMBUCNS2	Miguel	Rodríguez	Rojas	2022-05-14	Intersex	AB+	5555462021	paciente1489@example.com
WFEV620211MHSJAPF7	Miriam	Torres	Peña	1962-02-11	F	A-	5534660954	paciente1490@example.com
SQCB420819HOSYLDZ3	Rodrigo	Hernández	Reyes	1942-08-19	M	B-	5541202241	paciente1491@example.com
NIVC950619MQXKIDM3	Ana	Aguilar	Estrada	1995-06-19	F	A-	5550285915	paciente1492@example.com
TDVL670917XXPRFSD5	Silvia	Chávez	Vargas	1967-09-17	Intersex	A+	5549221911	paciente1493@example.com
DJDJ800717HAYCGQX6	Daniel	Delgado	Díaz	1980-07-17	M	A-	5542652012	paciente1494@example.com
BTQU120202HJWJNT68	Carlos	Vargas	López	2012-02-02	M	\N	5559481827	\N
VKTD460303XNJIWUH5	Antonio	Reyes	Contreras	1946-03-03	Intersex	A-	5518011308	paciente1496@example.com
FHJF561118HRIWAXI2	Francisco	Rodríguez	Fuentes	1956-11-18	M	B+	5567132025	\N
BOPM531224MAJYETM9	Verónica	Reyes	Vargas	1953-12-24	F	\N	5566740877	paciente1498@example.com
JWBA540720HHGWBZX1	Juan	Vargas	Gómez	1954-07-20	M	O+	5597247254	\N
VGSF720728MPNYXYO9	Gabriela	González	Fuentes	1972-07-28	F	\N	5523818289	\N
YORU101023MNQAPXC4	Cecilia	Morales	Solís	2010-10-23	F	A+	5535731899	paciente1501@example.com
FVCU720709HGKHJW30	Luis	Pérez	Delgado	1972-07-09	M	B-	\N	paciente1502@example.com
RRYJ601108XSJVSTZ3	José	Rojas	García	1960-11-08	Intersex	B-	5586621380	paciente1503@example.com
IXLI760305XXFFLSV5	Iván	González	Torres	1976-03-05	Intersex	O-	5530591541	paciente1504@example.com
TNPJ230531HKDVHZ13	Hugo	Ruiz	Rodríguez	2023-05-31	M	AB+	5590504173	paciente1505@example.com
WPQZ480112HZOBWGL3	Miguel	Reyes	Romero	1948-01-12	M	\N	5581718993	paciente1506@example.com
EDCF470111MOXKSNP7	Lucía	Vargas	Chávez	1947-01-11	F	A-	\N	paciente1507@example.com
MFHB800714HNXYKZQ0	Antonio	Rodríguez	Fuentes	1980-07-14	M	O+	5581803648	paciente1508@example.com
QEJC190830XWIARC20	Jorge	López	Ramírez	2019-08-30	Intersex	A+	5561687873	\N
AGVE480531HAIGUJ54	Manuel	Cabrera	Guzmán	1948-05-31	M	A-	5544210651	paciente1510@example.com
UJDG240830HDHKLK39	Manuel	Castillo	\N	2024-08-30	M	B+	5572239567	\N
QZYT611221HYRSRP97	Raúl	Aguilar	González	1961-12-21	M	AB-	5575138771	\N
TOUU050917HZFBIQ43	Andrés	Fuentes	Cabrera	2005-09-17	M	O+	5519455868	paciente1513@example.com
DRRV000726HAPSVMT0	Óscar	Contreras	Jiménez	2000-07-26	M	A-	5515758593	paciente1514@example.com
MXEB660518HLIJTGP9	Gerardo	Fuentes	Reyes	1966-05-18	M	A+	5595406385	paciente1515@example.com
UCYL390418MGORVIL0	María	Ramírez	Contreras	1939-04-18	F	B-	5555354407	paciente1516@example.com
WQQR831003XZSFUWI1	Paola	Delgado	Contreras	1983-10-03	Intersex	O+	5572040947	paciente1517@example.com
OLVP640103HRWAIDB4	Carlos	Gómez	Rodríguez	1964-01-03	M	\N	5571864426	\N
RNPC750327MDZADQ37	Gabriela	Rojas	Torres	1975-03-27	F	O+	5525704430	paciente1519@example.com
TPVI741207HTZZVBN0	Manuel	Aguilar	Herrera	1974-12-07	M	B+	5538177998	paciente1520@example.com
JOAJ110423XQDDVGD1	Manuel	Torres	Cabrera	2011-04-23	Intersex	\N	5543231456	paciente1521@example.com
CPBA720521HHIHYOR3	Arturo	Sánchez	Mendoza	1972-05-21	M	A+	5567405362	paciente1522@example.com
KIDU520111XCDSAUI0	Fernanda	Cruz	González	1952-01-11	Intersex	AB+	\N	\N
BLEF550525XCVJIF17	Pablo	Cordero	Hernández	1955-05-25	Intersex	A-	5553842561	\N
WTJI740710MXENZWF8	Laura	Chávez	Peña	1974-07-10	F	B+	5555375826	paciente1525@example.com
ITSV160309XJBFZGI3	Sofía	Peña	Fuentes	2016-03-09	Intersex	B-	5593580352	paciente1526@example.com
BPWV970517HQCSVU23	Ricardo	Martínez	Rojas	1997-05-17	M	B-	5542524777	paciente1527@example.com
SHBJ540623MNJZBB10	Beatriz	Díaz	Torres	1954-06-23	F	AB+	5582648627	paciente1528@example.com
ZRLU050418MJUZMAG2	Carmen	Vázquez	Delgado	2005-04-18	F	O-	\N	paciente1529@example.com
LXGT530131HNBCYND9	Sergio	Flores	Torres	1953-01-31	M	A-	5547079262	paciente1530@example.com
MYBG640324HELBUHT3	Iván	Guzmán	Sánchez	1964-03-24	M	\N	5544278952	paciente1531@example.com
ISNX720901HIKZJTW9	Fernando	Pérez	Rojas	1972-09-01	M	B-	5581273174	paciente1532@example.com
HEEV780409XIAFGTN6	Lucía	Cruz	Rodríguez	1978-04-09	Intersex	A+	5517640404	paciente1533@example.com
MHQC760305MDALAEI8	Alejandra	Mendoza	Flores	1976-03-05	F	A+	\N	paciente1534@example.com
ZQWE100707MOYNPPR2	Lucía	Solís	Ruiz	2010-07-07	F	A-	5554337327	paciente1535@example.com
CLDB081213HAEMAP22	Andrés	Romero	Delgado	2008-12-13	M	O-	5548696537	\N
FARS931016MRGCROO0	Paola	Reyes	Martínez	1993-10-16	F	B-	\N	paciente1537@example.com
ETPG160411HICXJQV0	Sergio	Vargas	Jiménez	2016-04-11	M	A+	5575908268	paciente1538@example.com
RUUP230409HCFYDQR5	Andrés	Hernández	Gómez	2023-04-09	M	A+	5559602331	paciente1539@example.com
LDOL401110XOZTAGK3	Araceli	Peña	Contreras	1940-11-10	Intersex	O+	5588806094	paciente1540@example.com
HABO141025MQURNPW8	Alejandra	García	Díaz	2014-10-25	F	AB-	5585095914	paciente1541@example.com
NTJV900904MMEOFQ15	Teresa	Vargas	Reyes	1990-09-04	F	O-	5514204384	paciente1542@example.com
PMIV160323MGJTGSS1	Guadalupe	Torres	Cruz	2016-03-23	F	AB+	5567407886	paciente1543@example.com
TCYC010613XBMUZN32	Diana	Mendoza	Vargas	2001-06-13	Intersex	AB+	5518793978	paciente1544@example.com
FISG381225MDNXIL72	Claudia	Contreras	González	1938-12-25	F	B+	5578047040	paciente1545@example.com
OLMZ500723XSFNWSI0	Roberto	Aguilar	Medina	1950-07-23	Intersex	A-	5527357125	paciente1546@example.com
ARYK250420MOVQSLH5	Verónica	González	Reyes	2025-04-20	F	A-	5542566009	paciente1547@example.com
PZRG430625XNUTBWN0	Beatriz	García	Ramos	1943-06-25	Intersex	A-	5541365329	paciente1548@example.com
OXZO480830MAXPZB10	Diana	Fuentes	Estrada	1948-08-30	F	O+	5561433700	paciente1549@example.com
JGMR980110XOCVXUY3	Adriana	Pérez	Rojas	1998-01-10	Intersex	\N	5576215774	paciente1550@example.com
NDQE860710XJYRXPT1	Óscar	Torres	Medina	1986-07-10	Intersex	B+	5585314198	paciente1551@example.com
CUFE100422HGWHSS72	Fernando	Vázquez	Cabrera	2010-04-22	M	O-	5500713204	paciente1552@example.com
LVID190513XXOUWMY0	Arturo	Ruiz	Guzmán	2019-05-13	Intersex	B+	5589391164	paciente1553@example.com
MLPX580415XNMMIPZ0	Pablo	Rojas	Vargas	1958-04-15	Intersex	\N	5508529645	paciente1554@example.com
TRQP740424HQESRQ52	Luis	Rojas	Ortiz	1974-04-24	M	AB-	5542206185	paciente1555@example.com
ZVHU831021MQNZVIC0	Araceli	Estrada	Fuentes	1983-10-21	F	AB+	5524663903	\N
WGSH761207HHACDD64	Alejandro	Reyes	Pérez	1976-12-07	M	O+	5548855875	paciente1557@example.com
KCIG160517XNTOIL38	Daniel	Ruiz	Castillo	2016-05-17	Intersex	A-	5579838713	paciente1558@example.com
GZRW661016MZSLWX86	Daniela	Peña	Reyes	1966-10-16	F	B+	\N	paciente1559@example.com
TXSD711129HYXNEI19	Ricardo	Aguilar	Sánchez	1971-11-29	M	B+	5562936842	paciente1560@example.com
GNPS840908MXTBCAI7	Leticia	Sánchez	Delgado	1984-09-08	F	O-	5509520387	\N
UILX220107HZMFJXR6	Carlos	Mendoza	Cabrera	2022-01-07	M	A+	5516566339	\N
XEME081025XKHVRCR0	Iván	López	Ortiz	2008-10-25	Intersex	A-	\N	paciente1563@example.com
VIFB191110MEJQJGW0	Yolanda	Estrada	Ortiz	2019-11-10	F	AB-	5509332809	paciente1564@example.com
IAJZ011218XGCATA37	Mónica	Contreras	\N	2001-12-18	Intersex	O-	5523532773	paciente1565@example.com
EOLP860625MHKKJRG4	Alejandra	Torres	González	1986-06-25	F	AB-	5526661539	\N
WBEC840325XLBUDGQ3	Elena	Ramírez	Gómez	1984-03-25	Intersex	A-	5562798958	\N
SCET620703MTBHODH2	Carmen	Vargas	Vázquez	1962-07-03	F	AB-	5539557142	\N
FBWM370719XUXVKTF0	Jorge	Romero	Gómez	1937-07-19	Intersex	O+	5543643644	\N
CIEF721218HWYWAUD7	Rodrigo	Cabrera	Romero	1972-12-18	M	A+	5576835278	\N
PDBT651001XGGRYLN0	Ana	Vargas	Chávez	1965-10-01	Intersex	O+	\N	\N
QXNU950117HPOKJMX8	Hugo	Alvarado	Ramírez	1995-01-17	M	AB+	5528470344	paciente1572@example.com
MLUZ520302XYVNQJE5	Fernando	Jiménez	Ortiz	1952-03-02	Intersex	B+	5535175735	paciente1573@example.com
SVML900322HWSLSNU6	Emilio	Medina	Rojas	1990-03-22	M	O+	\N	paciente1574@example.com
FSMX111221HIQIUEF0	Iván	Jiménez	Chávez	2011-12-21	M	A+	5525145579	paciente1575@example.com
MNBI820404XCJENJN0	Roberto	Contreras	Jiménez	1982-04-04	Intersex	A+	5570813722	paciente1576@example.com
UYEJ930415HVGTEFX0	Carlos	Martínez	Morales	1993-04-15	M	O-	5549628407	paciente1577@example.com
BROR710807XGVVJY56	Sofía	Delgado	Morales	1971-08-07	Intersex	AB-	5500782446	paciente1578@example.com
NVAV051028MSUJGQ08	Fernanda	Estrada	Salazar	2005-10-28	F	A+	5550855925	paciente1579@example.com
MSYE911201MGZYEK22	Verónica	Cabrera	Gómez	1991-12-01	F	AB-	5546892704	paciente1580@example.com
NNMD470321HBLDJTY1	Gerardo	Reyes	Torres	1947-03-21	M	\N	\N	paciente1581@example.com
YXXQ910205XWQPTFR4	Pablo	Flores	Salazar	1991-02-05	Intersex	B+	5539518695	paciente1582@example.com
RHWU380407HHDRHRB1	Antonio	Gutiérrez	Salazar	1938-04-07	M	AB+	5534769123	paciente1583@example.com
ZACY760420MVFFZAE6	Teresa	Reyes	Peña	1976-04-20	F	A-	\N	paciente1584@example.com
DLEG730916HCGHMUN1	José	García	Reyes	1973-09-16	M	B+	5598212702	\N
DFTL501209XTAHDV37	Mónica	Alvarado	López	1950-12-09	Intersex	B-	5590001917	paciente1586@example.com
JJQH410630MIGZQY41	Leticia	Vázquez	Gómez	1941-06-30	F	B-	5554746911	paciente1587@example.com
ERFB820610XIBBTH70	Carlos	Salazar	Ramírez	1982-06-10	Intersex	\N	5534912321	paciente1588@example.com
WGFI470825XWCRHEW2	José	Martínez	Estrada	1947-08-25	Intersex	AB-	5552021311	paciente1589@example.com
MPVA100918XDXYCM28	Iván	Ortiz	Vázquez	2010-09-18	Intersex	O-	5567862902	paciente1590@example.com
FNOH580203MYAFFBT1	Claudia	Medina	Torres	1958-02-03	F	AB-	5553040531	paciente1591@example.com
OKZK230410MAQIQKK8	Beatriz	González	Ramos	2023-04-10	F	B+	5577037846	paciente1592@example.com
UOMI230812MVJBKQO5	Guadalupe	García	Jiménez	2023-08-12	F	B-	5501727279	paciente1593@example.com
DWRH230604HEALDCK1	Adrián	Ramírez	Cabrera	2023-06-04	M	A-	5563680199	\N
CCVP970630HUWIPZE1	Jorge	Gutiérrez	\N	1997-06-30	M	AB-	\N	paciente1595@example.com
MGUV751105XCFZZID7	Iván	Vargas	Medina	1975-11-05	Intersex	O+	5548138819	\N
NPZW630120HMOONCV2	Carlos	Díaz	Ramos	1963-01-20	M	B+	5501709217	paciente1597@example.com
ZBEE570913MVGRAIW3	Ana	Guzmán	Contreras	1957-09-13	F	B+	5527725320	paciente1598@example.com
IQSR771231MPZHLW67	Cecilia	Delgado	Gómez	1977-12-31	F	A+	5529933570	\N
VNGW891009MTZQJYY4	María	Peña	Medina	1989-10-09	F	\N	5527398356	paciente1600@example.com
RNVO591222MMFZEPP5	Patricia	Reyes	Salazar	1959-12-22	F	A-	5540620166	\N
LMWG170630MIWKFNN6	Beatriz	Hernández	Ramírez	2017-06-30	F	A+	5588623357	\N
UJGI590502MJECCD35	Mónica	Mendoza	Sánchez	1959-05-02	F	B+	5544957421	paciente1603@example.com
JMHQ561024XDLCFTH1	Paola	Gutiérrez	Solís	1956-10-24	Intersex	AB+	5579246429	paciente1604@example.com
GUTT960928XQPLYUH5	Mario	Gómez	Vázquez	1996-09-28	Intersex	A-	5507514518	\N
KORF210514MIKXGCB8	Paola	Cabrera	Reyes	2021-05-14	F	O-	5564378624	\N
NANN690117HXXSMDB6	Emilio	Solís	Díaz	1969-01-17	M	AB+	5574912187	paciente1607@example.com
CYIO870820XCLSADG2	Alejandra	López	García	1987-08-20	Intersex	B-	\N	paciente1608@example.com
IYBF440213HPFRZT86	Luis	Romero	\N	1944-02-13	M	\N	5521208614	paciente1609@example.com
OTMY490609XMTTUY28	Verónica	Ortiz	López	1949-06-09	Intersex	B+	5501414424	paciente1610@example.com
WRNC030810XWLSLF75	María	Jiménez	Flores	2003-08-10	Intersex	B+	5557637982	paciente1611@example.com
VTUR830823HGMONA44	Ricardo	Chávez	Cabrera	1983-08-23	M	O-	\N	paciente1612@example.com
IHSB560628XHKZNXB2	Javier	Fuentes	García	1956-06-28	Intersex	\N	5586966096	\N
PKCZ240315MFCBCQS2	Lucía	Contreras	Castillo	2024-03-15	F	AB+	5526441802	paciente1614@example.com
ZTUH370730MKMLHKK4	Silvia	Ortiz	Ruiz	1937-07-30	F	A-	5579507655	paciente1615@example.com
XEKC600623HFFKXRS6	Raúl	Torres	Ruiz	1960-06-23	M	AB-	5501752279	paciente1616@example.com
FGZT960502HMPIVSD2	Andrés	Díaz	Alvarado	1996-05-02	M	O+	5585407008	\N
ENSX000511HKPKHW85	Ricardo	Cabrera	Ramírez	2000-05-11	M	O-	5539763529	\N
IBQL231014HEAMZHN4	Manuel	Ramírez	Flores	2023-10-14	M	AB+	\N	paciente1619@example.com
FUML781221MTGVGW60	Rosa	Rojas	Cruz	1978-12-21	F	B+	5591716033	paciente1620@example.com
JCQU990721XJHNUZ10	Lucía	Jiménez	Mendoza	1999-07-21	Intersex	A+	5593137880	paciente1621@example.com
NPXX040307XNPOZO33	Araceli	González	\N	2004-03-07	Intersex	AB+	5576455459	paciente1622@example.com
WIGL530608HYXXDDD2	Alejandro	Medina	Ramos	1953-06-08	M	AB+	5595533089	paciente1623@example.com
LVXC070412HJUQKKB7	Francisco	Reyes	Pérez	2007-04-12	M	O+	5540626067	\N
QPNF980424HDNJRHQ2	Ricardo	Solís	Gutiérrez	1998-04-24	M	AB-	5597302940	paciente1625@example.com
VBFH100909MXZYLQN7	Leticia	Guzmán	Ruiz	2010-09-09	F	AB-	5525828488	paciente1626@example.com
TLCM510406HVXKTSE9	Daniel	Delgado	Gutiérrez	1951-04-06	M	B+	5564464523	paciente1627@example.com
JEXQ100701HMPRLKQ7	José	Torres	Mendoza	2010-07-01	M	O+	5589779501	paciente1628@example.com
YHNP641025MEYUKBI8	Fernanda	Vargas	Peña	1964-10-25	F	O+	\N	paciente1629@example.com
UPHI510525XWNBVHG6	Miguel	Contreras	López	1951-05-25	Intersex	O-	5540799216	paciente1630@example.com
JUFW941004MQWVGE96	Paola	Chávez	Rojas	1994-10-04	F	AB-	5585150668	paciente1631@example.com
KLNV630809HNCNNRT0	Eduardo	Ruiz	Sánchez	1963-08-09	M	A-	5536460595	paciente1632@example.com
GSKN060131XGFEILE8	Emilio	Sánchez	González	2006-01-31	Intersex	A+	5596192126	paciente1633@example.com
PRJQ730923MPSYQU03	Yolanda	Gutiérrez	Aguilar	1973-09-23	F	O-	5530527043	paciente1634@example.com
IEHA871119HDEPJMA1	Jorge	Ruiz	Pérez	1987-11-19	M	AB-	5519198637	paciente1635@example.com
ZMAN050611XZEFGA03	Juan	Herrera	Ruiz	2005-06-11	Intersex	B-	5535775694	\N
JAWB540112XGXFPGB3	Laura	Gutiérrez	García	1954-01-12	Intersex	A+	5582746352	paciente1637@example.com
RQWY150504HEAHRA19	Pablo	Ramos	Pérez	2015-05-04	M	B-	5562185311	\N
ZGUM230117HNMMHMT7	Arturo	Pérez	Estrada	2023-01-17	M	A+	5532659845	\N
VTIA651028HHPLGLM1	Hugo	Rojas	Gómez	1965-10-28	M	A-	5545275671	paciente1640@example.com
ORBO801005MZCEWYZ5	Guadalupe	Reyes	Castillo	1980-10-05	F	A+	5594891852	paciente1641@example.com
AWCK440228XDISOO56	Ana	Reyes	Flores	1944-02-28	Intersex	B+	5536165765	\N
KVIW661206HSVAEST8	Miguel	Aguilar	Cabrera	1966-12-06	M	B+	5543457766	\N
UKAY941211HXBWSCX9	Adrián	Fuentes	Alvarado	1994-12-11	M	B-	5578323959	paciente1644@example.com
JCEU550929MOANMD95	Carmen	García	Delgado	1955-09-29	F	A-	5587807202	\N
RDCF410604HAYSTNZ7	Adrián	Solís	Salazar	1941-06-04	M	AB+	5572037344	paciente1646@example.com
DSUW680407MALMVK54	Sofía	Romero	Contreras	1968-04-07	F	A-	5577054673	paciente1647@example.com
XKIN721010HRURPXP0	Roberto	Torres	García	1972-10-10	M	B-	5586810253	paciente1648@example.com
KIPY140410HQBVBSU8	Daniel	Gómez	Romero	2014-04-10	M	O+	5514615970	\N
GQQK850419HIMOYWO4	Adrián	Delgado	López	1985-04-19	M	AB-	5569390894	\N
PCQH911030HEDGALS2	Daniel	Herrera	Cabrera	1991-10-30	M	\N	5525111903	paciente1651@example.com
SJCF660513XKSOTTC3	Andrés	García	Flores	1966-05-13	Intersex	A+	5587676606	paciente1652@example.com
GYJA450706XUGSTP93	Laura	Cabrera	González	1945-07-06	Intersex	\N	5543081836	\N
VOWA691020XFMYMH62	Silvia	Cabrera	Solís	1969-10-20	Intersex	O+	5554818513	\N
OOMO950219HPCSEW98	Luis	Guzmán	Hernández	1995-02-19	M	A+	5530287574	\N
NAMO061220XPQPDTK4	Gabriela	Gómez	García	2006-12-20	Intersex	AB-	5526557136	\N
XJKH630611MOLYFL24	Paola	Torres	Rodríguez	1963-06-11	F	B+	5588252699	paciente1657@example.com
DDKX570521XNPHZH85	Antonio	Herrera	Rodríguez	1957-05-21	Intersex	O-	5564670506	paciente1658@example.com
GCSH591011XINKWBL7	José	Estrada	Medina	1959-10-11	Intersex	B-	5560345633	paciente1659@example.com
LEIY380729XKOBKCU5	Claudia	Cruz	Peña	1938-07-29	Intersex	AB-	5526388032	paciente1660@example.com
VQXV151111XMYFWW66	Elena	Cruz	Aguilar	2015-11-11	Intersex	AB-	5547623703	paciente1661@example.com
WFNQ580407MDSGDZJ2	Cecilia	Díaz	Vargas	1958-04-07	F	B+	\N	paciente1662@example.com
YMFL471214HHVSIXG8	Adrián	Jiménez	García	1947-12-14	M	B-	5554189258	paciente1663@example.com
HLMH451104HAGFQE17	Luis	Torres	Hernández	1945-11-04	M	A-	5549047986	paciente1664@example.com
ECGE670116HYXZLB76	Fernando	Medina	Alvarado	1967-01-16	M	A+	5568564347	paciente1665@example.com
GASF100119XLROFQS6	Daniela	Herrera	Fuentes	2010-01-19	Intersex	AB-	5536316330	paciente1666@example.com
MEQY581221MAHGWMT9	Fernanda	López	Flores	1958-12-21	F	O+	5547491163	\N
DBWW050320XDMNHYY6	Paola	Jiménez	López	2005-03-20	Intersex	A+	5528455414	paciente1668@example.com
FSLC120129XYDUAQT8	Alejandra	Ramos	Aguilar	2012-01-29	Intersex	AB+	\N	paciente1669@example.com
MAJN090508MSAUDOQ9	Diana	López	Hernández	2009-05-08	F	B-	5591624410	paciente1670@example.com
PHEC370319XNLBFVR2	Guadalupe	Fuentes	Chávez	1937-03-19	Intersex	A-	5593544071	paciente1671@example.com
LAFH790618XVVALUB6	José	Contreras	Peña	1979-06-18	Intersex	AB+	5548533317	paciente1672@example.com
XZCF021026MSZRWFS9	Karla	Cabrera	Ruiz	2002-10-26	F	A+	5528815208	paciente1673@example.com
MRAD470604XFNTNFV0	Iván	Ramírez	Vargas	1947-06-04	Intersex	B-	5573249139	\N
ITME820208HZHRHQS4	Antonio	Flores	Flores	1982-02-08	M	O+	5537654399	paciente1675@example.com
GHAQ240108HNUIDJ96	Emilio	Salazar	Herrera	2024-01-08	M	A-	5590850504	paciente1676@example.com
AKDR730418XEGOPFG0	Beatriz	Rojas	Ramos	1973-04-18	Intersex	O+	5544793911	paciente1677@example.com
ILMQ620114MVQWIQZ5	Mónica	García	\N	1962-01-14	F	AB-	5574496660	paciente1678@example.com
ZPID490516HEARDRA3	Roberto	Aguilar	Ortiz	1949-05-16	M	AB+	5538252894	\N
AEMT890829HYWKPOX2	Daniel	Reyes	Sánchez	1989-08-29	M	AB+	5548031636	paciente1680@example.com
CHKH760131HPMIFT63	Sergio	Chávez	Cordero	1976-01-31	M	A-	\N	paciente1681@example.com
QURL211228MGFTZR33	Adriana	Estrada	Castillo	2021-12-28	F	B+	5501149974	paciente1682@example.com
OBIY850529MSTBSN38	Mónica	Rojas	Cordero	1985-05-29	F	O-	5556597739	paciente1683@example.com
KPGM231101HRXSDB70	Hugo	Morales	Torres	2023-11-01	M	B+	5575694307	paciente1684@example.com
ZQOV660704HOZCVX19	Pablo	Rodríguez	Medina	1966-07-04	M	O-	5587236341	\N
WNOD430615MEMKZPK8	Elena	Ramos	Salazar	1943-06-15	F	O-	5529127898	paciente1686@example.com
TMAU191231XQJDXWW8	Ricardo	Torres	Delgado	2019-12-31	Intersex	B-	5537304376	\N
PDNY231013XTIIRWG4	Óscar	Mendoza	Rojas	2023-10-13	Intersex	B+	\N	\N
BEHY881205XDBXNJC7	Javier	López	Mendoza	1988-12-05	Intersex	AB-	5568228854	\N
PSXT611207HELDZU43	Rodrigo	Díaz	Delgado	1961-12-07	M	AB+	5554758783	paciente1690@example.com
SXWE081130MLUWSB17	Ana	Hernández	Chávez	2008-11-30	F	AB-	5553601743	paciente1691@example.com
JDGD210718MNVMPOW2	Guadalupe	Flores	Hernández	2021-07-18	F	AB-	5507127971	paciente1692@example.com
ZYJF470522HWOFSXB4	Rodrigo	Chávez	\N	1947-05-22	M	A-	5517676227	\N
UHSC900310XKQJNI42	Iván	Gutiérrez	González	1990-03-10	Intersex	B-	5546782036	paciente1694@example.com
VFMC221017MHIAWT43	Miriam	Rodríguez	Ruiz	2022-10-17	F	O-	5520667665	\N
FUUD001027HWNSIHV3	Ricardo	Jiménez	Gómez	2000-10-27	M	A+	5586178058	paciente1696@example.com
FDHM050811HYZORY96	Arturo	López	Vargas	2005-08-11	M	B+	5552615107	\N
FTLB930124XRMRPZR4	Iván	Mendoza	García	1993-01-24	Intersex	O-	5535998962	paciente1698@example.com
KNAB030816MMUFKVW1	Elena	Castillo	Castillo	2003-08-16	F	B-	\N	paciente1699@example.com
SGPQ181217XISKGCL7	Carmen	Vargas	Mendoza	2018-12-17	Intersex	A-	5545801976	paciente1700@example.com
IVMC900223HKEWZNV3	Francisco	Díaz	Pérez	1990-02-23	M	A+	5524708101	\N
TRRI190402XBYRTVQ3	Francisco	Flores	Vargas	2019-04-02	Intersex	AB-	5548126817	paciente1702@example.com
AKQR490501XZSTAK60	Raúl	García	Herrera	1949-05-01	Intersex	\N	5503340508	paciente1703@example.com
UQXV950214HNZZSSC2	Iván	Hernández	Jiménez	1995-02-14	M	O-	5511669460	paciente1704@example.com
NONY440625XIEQDEW9	Miguel	Flores	Ortiz	1944-06-25	Intersex	\N	5562074988	paciente1705@example.com
ASEA901110MHHCXI15	Silvia	Chávez	Gómez	1990-11-10	F	AB+	5557166578	paciente1706@example.com
BJHQ941003HSVYMJG6	José	Ortiz	Peña	1994-10-03	M	B+	5586295322	paciente1707@example.com
PMID430606HFNDGVX5	Raúl	Cruz	Salazar	1943-06-06	M	AB-	5586180583	paciente1708@example.com
UIEV010526MUPQQL88	Araceli	López	Mendoza	2001-05-26	F	O-	5506965693	\N
ONWF400505XEHNRHF2	Araceli	Estrada	Cruz	1940-05-05	Intersex	AB-	5541839955	paciente1710@example.com
ZEQA110418MCOPCVB6	Leticia	Salazar	López	2011-04-18	F	A+	5550269447	\N
WHTC000613MAXGFHH8	Lucía	Vázquez	Cordero	2000-06-13	F	AB+	5567906674	paciente1712@example.com
VBJA180810XRHQIH38	Alejandra	Ramírez	Rodríguez	2018-08-10	Intersex	A+	5518777953	\N
HTEE720903XIELYP47	Daniel	Cruz	Vázquez	1972-09-03	Intersex	A+	5545750218	paciente1714@example.com
JNBH780709MWMGQHZ8	Verónica	Pérez	Ortiz	1978-07-09	F	AB-	5584204759	paciente1715@example.com
YPBM850818HSWXHVL8	Eduardo	Medina	Gutiérrez	1985-08-18	M	B-	5502546167	paciente1716@example.com
ZCQY660214MSQZNG01	Daniela	Vargas	Herrera	1966-02-14	F	A-	5559459211	paciente1717@example.com
UBCT951208MIOGPP12	Diana	Vargas	Solís	1995-12-08	F	AB+	5589654997	paciente1718@example.com
ZZEA111213XBRWUDB0	Jorge	Guzmán	Solís	2011-12-13	Intersex	O-	5528669062	paciente1719@example.com
SYYY030103MBSWMOG0	Paola	Chávez	Rodríguez	2003-01-03	F	\N	\N	paciente1720@example.com
FVFP010403XVUJXWZ6	Iván	Medina	Gómez	2001-04-03	Intersex	B-	5529483051	paciente1721@example.com
UGIG090802XYHKHN35	Adrián	Cruz	González	2009-08-02	Intersex	AB-	5577342658	paciente1722@example.com
WUSO981112MTCIAP41	Guadalupe	Vázquez	García	1998-11-12	F	A+	5506199074	paciente1723@example.com
VIPE510118MZXCODK4	Araceli	Romero	Rojas	1951-01-18	F	A-	5568303253	paciente1724@example.com
OXXM780103XPGKXA48	Rodrigo	Cruz	Chávez	1978-01-03	Intersex	O-	5572839476	\N
ITWU171029XZTGVMP1	Emilio	González	Aguilar	2017-10-29	Intersex	AB+	5575644390	paciente1726@example.com
MGAB460104HUMGMEH0	Óscar	Estrada	Castillo	1946-01-04	M	B-	5564078704	paciente1727@example.com
YYGW930201XXPXUVP9	Francisco	Pérez	Cordero	1993-02-01	Intersex	AB+	5527295986	paciente1728@example.com
SSWY790516MBPCFWY9	Miriam	Hernández	Gutiérrez	1979-05-16	F	O-	5582700293	\N
QSGP900826XINAFCP6	Miriam	Rodríguez	Ramírez	1990-08-26	Intersex	\N	5541577129	paciente1730@example.com
CXSL920224XZNYCP15	Javier	Gómez	Cordero	1992-02-24	Intersex	B-	5522355285	paciente1731@example.com
ERYW561109XFTHZHW2	Juan	Alvarado	Cruz	1956-11-09	Intersex	\N	5589715359	paciente1732@example.com
XPIN490609MIVLKB32	Paola	Flores	Gutiérrez	1949-06-09	F	\N	5501850880	paciente1733@example.com
AXVK580609MRDUAK70	Alejandra	Castillo	Ruiz	1958-06-09	F	O-	\N	paciente1734@example.com
IIPN530819XCSGOR96	Leticia	Romero	Rojas	1953-08-19	Intersex	AB+	5564653334	paciente1735@example.com
PSEE071202MZWNFQH9	Mónica	Cabrera	Jiménez	2007-12-02	F	O-	5523743873	\N
JAKU711119MAIPEY00	Guadalupe	Chávez	Sánchez	1971-11-19	F	AB-	5596291459	paciente1737@example.com
YXKS771214HDTRCOT7	Fernando	Aguilar	\N	1977-12-14	M	A-	5553978858	paciente1738@example.com
ULOD440917MHDZUT84	Rosa	Estrada	Ruiz	1944-09-17	F	B+	5596163952	paciente1739@example.com
UFCE860523MHQIQO25	Paola	Guzmán	Reyes	1986-05-23	F	AB+	5519189875	paciente1740@example.com
XFTB140511XUYABKA5	Carmen	Fuentes	Jiménez	2014-05-11	Intersex	B+	5517365854	\N
FJNE980725XVXPDEM9	Claudia	González	Díaz	1998-07-25	Intersex	A-	5506533535	paciente1742@example.com
MZFQ740728MFXWDTZ0	Alejandra	Delgado	Martínez	1974-07-28	F	\N	5575788273	paciente1743@example.com
HSUQ841110MXHNMNB9	Adriana	Hernández	Guzmán	1984-11-10	F	AB-	5578550044	paciente1744@example.com
FTXY891116XXAVCA29	Luis	Vargas	Estrada	1989-11-16	Intersex	A-	5526527825	\N
LNPD590718HCOOKG97	José	Ramos	Pérez	1959-07-18	M	A+	5558198708	paciente1746@example.com
GWRZ570214MALGXMV9	María	Rojas	Chávez	1957-02-14	F	AB-	5583950705	\N
FCYE850704HRDKMRP8	Diego	López	Romero	1985-07-04	M	AB-	5527853798	paciente1748@example.com
PDPH051004HANWGSC8	Manuel	Cabrera	Pérez	2005-10-04	M	B-	5506848368	paciente1749@example.com
KVNB870724MMPPLLW7	Karla	Flores	Castillo	1987-07-24	F	A-	5554105772	paciente1750@example.com
TXQR670503HCAURKU8	Manuel	López	Fuentes	1967-05-03	M	AB-	5557845720	paciente1751@example.com
CLBZ000121HOXYJSP1	Manuel	Sánchez	\N	2000-01-21	M	AB+	5581611556	paciente1752@example.com
VULB860323HBBJKRT0	Antonio	Cordero	Díaz	1986-03-23	M	\N	5527069906	paciente1753@example.com
XWUQ940629MBVHZUZ3	Teresa	Reyes	Cordero	1994-06-29	F	\N	5547224558	paciente1754@example.com
LCZY040804HYJUVFQ4	Raúl	López	Jiménez	2004-08-04	M	AB+	5539000453	paciente1755@example.com
YRZX471120XNPUFKG4	Verónica	Martínez	Salazar	1947-11-20	Intersex	O+	5561709987	\N
DMNR381103MRDHAH84	Leticia	García	Medina	1938-11-03	F	AB+	5528150164	paciente1757@example.com
ELHN150919MDEOMS67	Fernanda	Cruz	Jiménez	2015-09-19	F	AB+	5529579474	paciente1758@example.com
ZODO700524XHUHCYV7	Carlos	Solís	Medina	1970-05-24	Intersex	O-	5504261447	\N
DLFN570104MIJLVV62	Alejandra	López	Torres	1957-01-04	F	AB+	5545419137	paciente1760@example.com
ATGZ130816MRZGOHZ5	Teresa	Medina	Alvarado	2013-08-16	F	A+	5527607414	paciente1761@example.com
LGJE080830MKLKMC93	María	Flores	Sánchez	2008-08-30	F	A+	5562138415	paciente1762@example.com
ULYE470815HPKALM88	Daniel	Ruiz	Ramírez	1947-08-15	M	O+	5548207271	\N
FVTG660304HPQDXZP2	Francisco	Gutiérrez	\N	1966-03-04	M	AB+	5573326277	paciente1764@example.com
QZQD950814MSUJYM87	Karla	Ortiz	Peña	1995-08-14	F	AB-	5592944993	paciente1765@example.com
XYMN110827HQIWTAV3	Fernando	Rojas	Rojas	2011-08-27	M	AB+	5578320316	\N
TAKH850508XJBGRV83	Paola	Vázquez	Guzmán	1985-05-08	Intersex	A-	5551801664	paciente1767@example.com
DTHQ200703HQWXTUX3	Jorge	Reyes	Fuentes	2020-07-03	M	O-	5543978157	\N
VMYN231023HAQNFHY5	Diego	Chávez	Pérez	2023-10-23	M	O+	5502622478	paciente1769@example.com
ENUD630409HZYHKB02	Miguel	Ramos	Salazar	1963-04-09	M	O-	\N	\N
UAME810315HWTQCB45	Ricardo	Guzmán	Delgado	1981-03-15	M	A+	5568665083	paciente1771@example.com
JBOH150715HPGBQV31	Gerardo	Castillo	Flores	2015-07-15	M	B+	5590390920	paciente1772@example.com
AUFU820618MJPJQK29	Yolanda	Castillo	López	1982-06-18	F	\N	5589213273	paciente1773@example.com
ESOV100323MVFYKIC1	Verónica	Cruz	Vázquez	2010-03-23	F	B+	5538475431	paciente1774@example.com
RBBP841217MUSFXI13	Carmen	Gutiérrez	Díaz	1984-12-17	F	AB+	5598375550	\N
AXPX220408MOBTSBM1	Elena	Reyes	Mendoza	2022-04-08	F	AB-	5511359804	\N
IADB880105HCJMACM3	Carlos	Mendoza	Delgado	1988-01-05	M	B-	5562260931	paciente1777@example.com
HHDM500727XDJBREM1	Javier	Ramírez	Castillo	1950-07-27	Intersex	O+	\N	\N
OXIB970508MKYDTVX0	Laura	Estrada	Ortiz	1997-05-08	F	\N	\N	paciente1779@example.com
ZHUL540225HFZNHLX1	José	Ramos	Vargas	1954-02-25	M	AB-	5535241302	paciente1780@example.com
MNKX201111XNAFJSK3	Cecilia	Aguilar	Rodríguez	2020-11-11	Intersex	B-	5577414905	paciente1781@example.com
VTTP480331MWZVYLK6	Alejandra	Morales	Rojas	1948-03-31	F	O-	5578989168	paciente1782@example.com
CIFX170504HIDFJW64	Raúl	Rodríguez	Sánchez	2017-05-04	M	B-	5567313717	paciente1783@example.com
NMTK640708XJKUBRW7	Arturo	Pérez	García	1964-07-08	Intersex	O+	5501176170	paciente1784@example.com
GRHC850311HVQUUC32	Óscar	López	Ramírez	1985-03-11	M	O+	5557965640	\N
EYMX990827XBWORES1	Miguel	Cordero	Chávez	1999-08-27	Intersex	O-	5543424114	paciente1786@example.com
IYQE121010MEHBUNS2	Alejandra	Ortiz	Alvarado	2012-10-10	F	O-	5568460389	paciente1787@example.com
WNMK000913HECYPJ14	Óscar	Ramos	Reyes	2000-09-13	M	B-	5531649506	\N
UDHU830119MVJUNXP1	Cecilia	Ortiz	Vázquez	1983-01-19	F	O+	5589078695	paciente1789@example.com
AIDW050502MVKUIUS7	Guadalupe	Sánchez	Herrera	2005-05-02	F	B+	5533435973	paciente1790@example.com
YLEL800914XHCVZW45	María	López	Alvarado	1980-09-14	Intersex	O+	5509370118	paciente1791@example.com
AXTL671209MFSAKXW0	Elena	Cabrera	Díaz	1967-12-09	F	B-	5592818472	paciente1792@example.com
UFJC710529XNUDCTW4	Carlos	Castillo	Estrada	1971-05-29	Intersex	O+	5562789088	paciente1793@example.com
YDEV171001XDOSKTI8	Sofía	Hernández	Morales	2017-10-01	Intersex	A+	5523312567	paciente1794@example.com
YNDN410223MFWOWDQ1	María	Vázquez	Ruiz	1941-02-23	F	A-	5527732357	\N
JXEA650126MTIFBOP7	Yolanda	Torres	Rodríguez	1965-01-26	F	B+	5587199425	\N
UZAY050611XSLLWX97	Hugo	Cabrera	Ramos	2005-06-11	Intersex	AB-	5593642737	paciente1797@example.com
NVZC161022MESECHU1	Patricia	Jiménez	Solís	2016-10-22	F	O-	5513301075	\N
SIQY380429XJWXDFN2	Luis	Gómez	Castillo	1938-04-29	Intersex	A+	5520873857	\N
PAQL030610XROQGPK1	Claudia	Gutiérrez	Rodríguez	2003-06-10	Intersex	A-	5516822608	\N
HCOR690914XJIWTR93	Fernando	Vargas	Rodríguez	1969-09-14	Intersex	\N	\N	paciente1801@example.com
DDHZ761216MGOBVIR6	Cecilia	Vargas	Jiménez	1976-12-16	F	A+	5555407700	paciente1802@example.com
EGIR790313HXDVDY60	Adrián	Ruiz	Medina	1979-03-13	M	\N	5593850284	paciente1803@example.com
XLHO820209XCLNYJG5	Verónica	Flores	Medina	1982-02-09	Intersex	A-	5507066670	paciente1804@example.com
DSZC170810XWNWCDV5	Karla	Castillo	Jiménez	2017-08-10	Intersex	A-	\N	\N
BHPP640408HTCOAYN7	Rodrigo	Sánchez	Torres	1964-04-08	M	A-	\N	\N
LQEB000104XPEZDML4	Adriana	Ramírez	García	2000-01-04	Intersex	AB-	5542468473	\N
VTAK740207MWHMZOH2	Guadalupe	Alvarado	Ramírez	1974-02-07	F	O+	5520957890	paciente1808@example.com
RDST371214MYZZNRQ4	Miriam	Chávez	\N	1937-12-14	F	B-	5578174420	paciente1809@example.com
LWVK380519MNPZIAL0	Guadalupe	Solís	Pérez	1938-05-19	F	O-	5575993001	\N
XURB940602MMUPASE4	Yolanda	Solís	López	1994-06-02	F	B+	5554840000	paciente1811@example.com
LITO490719HMQZGJ87	José	Ortiz	Torres	1949-07-19	M	B-	5560489924	paciente1812@example.com
GQBW390121HPTKXCF8	Ricardo	Vargas	Pérez	1939-01-21	M	O-	5516525081	paciente1813@example.com
AOCY950525MPICUNR7	Teresa	Martínez	Rodríguez	1995-05-25	F	AB-	5563103231	paciente1814@example.com
MDNQ390423MIJIMS04	Paola	Hernández	Gutiérrez	1939-04-23	F	B-	5589244183	\N
OUEI480325HXVVIY59	Diego	Pérez	Reyes	1948-03-25	M	A+	5575914489	paciente1816@example.com
KYRI910331HMHZSES8	Mario	García	Gutiérrez	1991-03-31	M	\N	5507376764	paciente1817@example.com
IELD030620MSDROD12	Claudia	Vargas	Chávez	2003-06-20	F	\N	5547676660	paciente1818@example.com
MIEK110120HSVUTGH7	Daniel	Sánchez	Mendoza	2011-01-20	M	AB+	5570856759	\N
XSUV540413XNPBVJR7	Rodrigo	Cordero	Vázquez	1954-04-13	Intersex	AB-	5514057702	paciente1820@example.com
TJBU021007XZTWTRU7	Juan	Pérez	Ortiz	2002-10-07	Intersex	B-	5563744845	paciente1821@example.com
HKWI061107MFAWKAV3	Miriam	Cordero	Romero	2006-11-07	F	O+	5527728276	paciente1822@example.com
IFXU730810XNMAHN19	Ana	Salazar	Salazar	1973-08-10	Intersex	\N	\N	paciente1823@example.com
YTZJ680311MGWLBB49	Daniela	Gutiérrez	Gómez	1968-03-11	F	AB+	5565377784	\N
SDMG191210MVNSKA42	Laura	Romero	Cabrera	2019-12-10	F	B-	5550169156	paciente1825@example.com
BPVB070124XAQCGGT9	Carlos	Guzmán	Cruz	2007-01-24	Intersex	O+	5574326924	paciente1826@example.com
SULT650520HTDDUWL9	Javier	García	Aguilar	1965-05-20	M	B+	5540311828	paciente1827@example.com
LDCU721017XEAZGHD5	Yolanda	Rodríguez	Ruiz	1972-10-17	Intersex	AB+	5569423943	paciente1828@example.com
FQQJ460313HMHPXPP4	Rodrigo	Guzmán	Ortiz	1946-03-13	M	\N	5550302772	paciente1829@example.com
FLBK891005HLGFNOJ4	Sergio	Cabrera	González	1989-10-05	M	B+	5583726877	paciente1830@example.com
ITCZ740828HFQNOF67	Rodrigo	Medina	Herrera	1974-08-28	M	AB-	5586910407	paciente1831@example.com
FXJD970812HXKPHC60	Andrés	Aguilar	Aguilar	1997-08-12	M	A+	\N	\N
CETY741121HZIHZWP7	Iván	García	Rodríguez	1974-11-21	M	O+	5526578149	paciente1833@example.com
GCVC920716MADXKQT5	Alejandra	Martínez	Vázquez	1992-07-16	F	AB+	5531370017	\N
PHAF531018HDWWOG33	Luis	Vargas	Martínez	1953-10-18	M	A-	5570101492	paciente1835@example.com
FXVI430406HAANCG76	Emilio	Salazar	Flores	1943-04-06	M	B-	5596602514	\N
CRWA180402XZBJKBF5	Rosa	López	Guzmán	2018-04-02	Intersex	A-	5519596027	paciente1837@example.com
TNNB820402HKIQKMJ5	Pablo	Díaz	Rojas	1982-04-02	M	AB-	5542246406	paciente1838@example.com
XYPK550924MIDXQF57	Lucía	Medina	Sánchez	1955-09-24	F	O-	5548816058	\N
PBRF931220HMPXRMU0	Daniel	Rojas	Ramos	1993-12-20	M	B+	5541442942	paciente1840@example.com
BWLB770526MCKDHO66	Carmen	Solís	\N	1977-05-26	F	A+	5549704241	paciente1841@example.com
AOMV470427XRCOUAC6	Fernanda	Medina	Cruz	1947-04-27	Intersex	\N	\N	\N
XUZO720409MMNXDVD5	Sofía	Cabrera	Jiménez	1972-04-09	F	B+	5571500760	\N
AAOP460927MRIFQJX5	Sofía	Sánchez	Fuentes	1946-09-27	F	AB-	5586770667	\N
YHJS760208HDIGAUJ1	Andrés	Flores	Gómez	1976-02-08	M	B-	5525978336	paciente1845@example.com
FVYB160725MLSSZIS7	Mónica	Hernández	Cabrera	2016-07-25	F	AB+	5588012256	paciente1846@example.com
RRBE480811HLPVBZE6	Javier	Vázquez	García	1948-08-11	M	A+	5563703559	paciente1847@example.com
MYCN450131XWNESMW8	Francisco	Chávez	Vargas	1945-01-31	Intersex	AB+	5536025368	paciente1848@example.com
ILBZ960621HRAMTIB9	Pablo	Hernández	Gómez	1996-06-21	M	AB-	5573871834	paciente1849@example.com
KRJQ901017HJHWYZO0	Juan	Solís	\N	1990-10-17	M	O+	5503560897	paciente1850@example.com
LTZA830718MJJOTBU8	Mónica	Cabrera	Reyes	1983-07-18	F	A-	\N	paciente1851@example.com
ONIL110527HDGAVYD5	Raúl	Cordero	Martínez	2011-05-27	M	O+	5519857547	\N
JAMF820402XQFQKZA7	Ana	García	Gómez	1982-04-02	Intersex	A+	5532052851	paciente1853@example.com
IOCC110827MZORQPW0	Araceli	Hernández	Ramos	2011-08-27	F	B-	5591841805	paciente1854@example.com
APIU611003MBIXLCV6	Laura	Ramírez	\N	1961-10-03	F	A-	5527692689	paciente1855@example.com
TGBS500813XEVLFGD6	Arturo	Vargas	Contreras	1950-08-13	Intersex	O+	5536071241	\N
KRCS671109HHNMSJM6	Andrés	Gutiérrez	Ramírez	1967-11-09	M	B+	5565314594	paciente1857@example.com
KDJM730517MWHZUD87	Elena	Sánchez	Fuentes	1973-05-17	F	\N	5563302304	\N
YHDV690204HSMAYEU0	Antonio	Jiménez	Herrera	1969-02-04	M	A+	5540043866	paciente1859@example.com
MBXF120111MOKPXQ06	Karla	López	Cordero	2012-01-11	F	A-	5505373808	paciente1860@example.com
OACT750212HZSRFJ37	Francisco	Morales	López	1975-02-12	M	O+	5575186210	paciente1861@example.com
GMOQ500604XVFQUUE6	Alejandra	Cordero	Romero	1950-06-04	Intersex	\N	5560066881	paciente1862@example.com
FLFR600710HVIMKQB6	Raúl	Delgado	\N	1960-07-10	M	\N	5579224199	paciente1863@example.com
BQGI750918XRXATRW4	Mario	García	López	1975-09-18	Intersex	B+	5578904833	\N
XUEM430724MBFDGC60	Elena	Aguilar	Contreras	1943-07-24	F	AB+	5564059974	\N
WGOQ500318HFUYKWP7	Arturo	Rojas	García	1950-03-18	M	O-	5588704155	paciente1866@example.com
WCJF071009XDPVKMI4	Francisco	Reyes	Vargas	2007-10-09	Intersex	AB-	5544331782	paciente1867@example.com
NNEB821122XQJAOQR6	Lucía	López	Peña	1982-11-22	Intersex	B+	5515774662	\N
NKUE500225XKKVJEQ5	Karla	Rojas	Chávez	1950-02-25	Intersex	\N	5567292990	paciente1869@example.com
NVAD211026HKYIDH72	Miguel	Romero	Díaz	2021-10-26	M	AB-	5538688339	\N
MEEL780830HUINUQ02	Emilio	Fuentes	Estrada	1978-08-30	M	AB+	5510356574	paciente1871@example.com
CWJY420829HSFNEPO5	Javier	Gutiérrez	Cordero	1942-08-29	M	O+	5500126646	paciente1872@example.com
BSCA550623HBTDNMW9	Daniel	Alvarado	Estrada	1955-06-23	M	B-	5543001784	paciente1873@example.com
FZAU631004HKFWEK99	Óscar	Rojas	Cordero	1963-10-04	M	\N	5573073216	paciente1874@example.com
XOBU210816MRVVMYE1	Leticia	Castillo	Rodríguez	2021-08-16	F	AB-	\N	paciente1875@example.com
ANIF400619MEONZIP4	María	Solís	López	1940-06-19	F	B+	5565265053	\N
FQLW240527MSLGWR87	Lucía	Torres	Romero	2024-05-27	F	B-	5587592041	paciente1877@example.com
HBZD570424MMIXHAP2	Verónica	Herrera	Flores	1957-04-24	F	AB-	5544433294	paciente1878@example.com
UXJW630719MBJPOEQ6	Rosa	Alvarado	Rojas	1963-07-19	F	B+	5572834190	paciente1879@example.com
SORJ720324XJFTQFP1	Yolanda	González	\N	1972-03-24	Intersex	AB+	5521282658	paciente1880@example.com
QSCA000329XKULPSF5	María	Hernández	Gómez	2000-03-29	Intersex	\N	5534565123	\N
AQYA630904MNUGCXP9	Mónica	Hernández	Contreras	1963-09-04	F	B-	5543578459	\N
UDZC190228MFMJUEG8	Claudia	Sánchez	Flores	2019-02-28	F	O-	5547889377	\N
UXAU920614HMEMVGL7	Eduardo	Martínez	Peña	1992-06-14	M	AB+	5543265720	paciente1884@example.com
PQTZ220221MXUHOT77	Teresa	Herrera	Rojas	2022-02-21	F	AB-	5523999636	paciente1885@example.com
DVZS010920HRVHQL29	Pablo	Herrera	Díaz	2001-09-20	M	A+	5562901651	paciente1886@example.com
ZRXP850911XDLUKXO3	Claudia	Chávez	Ortiz	1985-09-11	Intersex	A-	\N	paciente1887@example.com
JPKM680320XCTNXD36	Teresa	Jiménez	Vázquez	1968-03-20	Intersex	B-	5521000278	paciente1888@example.com
YOBY650807XALDUEU3	Gabriela	Cabrera	Herrera	1965-08-07	Intersex	\N	5506319053	paciente1889@example.com
USVF831013MWPJVZY2	Teresa	Vázquez	Salazar	1983-10-13	F	A+	5589753115	\N
VAOK480826MOTGXDT4	Beatriz	Vázquez	Ramírez	1948-08-26	F	B+	5541996459	paciente1891@example.com
IASW760220XEYPOVE5	Gerardo	Gómez	Morales	1976-02-20	Intersex	AB-	5536850705	paciente1892@example.com
AGCU541102XRNOEA45	Manuel	Ruiz	Sánchez	1954-11-02	Intersex	O-	5556619667	paciente1893@example.com
IAYC040909HAFMULV7	Luis	Ramos	Díaz	2004-09-09	M	AB+	5575665732	paciente1894@example.com
ANQK950615MTAZYZJ3	Paola	Gutiérrez	Hernández	1995-06-15	F	A-	\N	paciente1895@example.com
ANDM680821MKHOHZA5	Beatriz	Gómez	Rojas	1968-08-21	F	A-	5542890781	paciente1896@example.com
UMDL530909MBPDBNZ1	Patricia	Delgado	Cabrera	1953-09-09	F	AB+	5536705904	\N
TNVG851227MDTSJN20	Lucía	Cabrera	Guzmán	1985-12-27	F	AB+	5587496122	paciente1898@example.com
QJWP770313XOSRQQJ4	Sergio	Martínez	Rojas	1977-03-13	Intersex	A-	5596868627	paciente1899@example.com
BSWO551027XCKIPKW0	Eduardo	Jiménez	\N	1955-10-27	Intersex	O-	5533672115	paciente1900@example.com
RFJY110610XMJTUZH3	Laura	González	Fuentes	2011-06-10	Intersex	AB-	\N	paciente1901@example.com
ZZGV660305HDLSNUP7	Daniel	Díaz	Flores	1966-03-05	M	\N	\N	\N
XCWH790930XMZSZAB4	Diana	Peña	Rodríguez	1979-09-30	Intersex	AB-	5546449405	paciente1903@example.com
IEPR700615XSCWUCK6	Miguel	Ramos	Jiménez	1970-06-15	Intersex	\N	5509860681	paciente1904@example.com
XMDD870618MPYOVER2	Gabriela	Pérez	Solís	1987-06-18	F	O+	5570805858	\N
WVSW820409XKWPFJA0	José	Torres	Guzmán	1982-04-09	Intersex	A-	\N	\N
LSRT850810HNFYEVT9	Rodrigo	Herrera	Pérez	1985-08-10	M	B+	5576419495	paciente1907@example.com
CAEZ220504HMHGITI2	Jorge	Mendoza	Cabrera	2022-05-04	M	AB-	5577085942	paciente1908@example.com
LIGW590323HIIRZFF3	Antonio	Peña	Mendoza	1959-03-23	M	\N	5511557694	paciente1909@example.com
LLZH570421XFGPLA63	Rodrigo	Rodríguez	Fuentes	1957-04-21	Intersex	AB-	5575252324	\N
ZXPZ940522XSNKNF90	Manuel	Rodríguez	Cabrera	1994-05-22	Intersex	AB-	5535006455	paciente1911@example.com
JBPV700925HRFQMFX5	Mario	Gutiérrez	Flores	1970-09-25	M	\N	5529370625	paciente1912@example.com
LLRE200423MVENEYM1	Diana	Vázquez	Herrera	2020-04-23	F	AB+	5550115327	paciente1913@example.com
OPKY410828HMWRQW03	Emilio	Gutiérrez	Ortiz	1941-08-28	M	AB-	\N	paciente1914@example.com
ZWKH221215XQFRSRE2	Adriana	Fuentes	Herrera	2022-12-15	Intersex	A+	5539657537	paciente1915@example.com
KMEF690721MEARVGR6	Mónica	Ortiz	Flores	1969-07-21	F	B+	5529961380	paciente1916@example.com
NSSZ600506XUGTTIV1	Daniela	Aguilar	\N	1960-05-06	Intersex	O+	5583829216	\N
FPQL630623XWPZZDD3	Laura	Aguilar	\N	1963-06-23	Intersex	AB+	5505695625	paciente1918@example.com
GKFR130228XQRTSVA8	Adriana	Aguilar	González	2013-02-28	Intersex	\N	5586081107	\N
MAHY620731XNQAQUV8	Elena	Gómez	Vázquez	1962-07-31	Intersex	\N	5543721326	paciente1920@example.com
RZHY060906XCWSCV60	Paola	Rojas	Romero	2006-09-06	Intersex	B+	5543097975	paciente1921@example.com
RYBC141101MZQXPI32	Rosa	Torres	Salazar	2014-11-01	F	O-	5531126597	paciente1922@example.com
ECPQ160224HDOZYAT2	Francisco	Hernández	Vázquez	2016-02-24	M	A-	5575888118	paciente1923@example.com
MLEO150420HFMCRSG0	José	Romero	Torres	2015-04-20	M	B-	5500179251	\N
CGVO240215XBFASU91	Ricardo	Cruz	Cordero	2024-02-15	Intersex	B+	\N	paciente1925@example.com
MBOP520714MEPFBUS5	Fernanda	Peña	Reyes	1952-07-14	F	O+	5598063533	paciente1926@example.com
EKCB871213MJSIMD53	María	Sánchez	Gómez	1987-12-13	F	O+	5551513320	paciente1927@example.com
ZEJA501101MPJCUGV9	Claudia	Hernández	Delgado	1950-11-01	F	AB+	5533903638	paciente1928@example.com
SKQA160829MWAAZRT1	Paola	Díaz	Estrada	2016-08-29	F	AB+	5567501468	\N
SIYU050716HLLQWVS6	Alejandro	Castillo	Martínez	2005-07-16	M	B+	5501819023	\N
TAMX760812HATDPYW0	Roberto	Ruiz	Herrera	1976-08-12	M	AB-	5519267750	\N
UQUJ650421HGXTVNW6	Mario	Castillo	Cruz	1965-04-21	M	\N	5587202048	paciente1932@example.com
VKHJ550629HPMYJCQ4	Mario	Martínez	Aguilar	1955-06-29	M	A+	5571974531	paciente1933@example.com
BBEU390712MTANXSW4	Silvia	Mendoza	Salazar	1939-07-12	F	AB-	5556427294	\N
SQFI230707XKBUQDQ6	Jorge	López	Peña	2023-07-07	Intersex	B+	5523607417	\N
KGVV950818MCGIXC26	María	Flores	Flores	1995-08-18	F	A+	5580954175	\N
BLYR700825HIRFRD23	Carlos	Aguilar	Vargas	1970-08-25	M	A-	5596910829	paciente1937@example.com
BZMJ521115XMIXNPY4	Iván	Alvarado	Ramírez	1952-11-15	Intersex	AB-	5556250845	\N
ZSSS030704XELOASK8	Miguel	Cordero	Gutiérrez	2003-07-04	Intersex	AB+	5528551438	paciente1939@example.com
VXRY090130HNKSDRH9	Ricardo	Ramos	Reyes	2009-01-30	M	\N	\N	paciente1940@example.com
KGAN490618XPHAXV83	Beatriz	Vázquez	López	1949-06-18	Intersex	O+	5584016776	paciente1941@example.com
XAKA140913XPDSOBW7	Karla	González	Cordero	2014-09-13	Intersex	B+	5545406914	\N
JHDY680103MWUKXZX6	Carmen	Alvarado	Salazar	1968-01-03	F	AB-	5559792962	paciente1943@example.com
HPYB400916HGVUTCC5	Jorge	Guzmán	Torres	1940-09-16	M	AB+	5551413430	paciente1944@example.com
SYQO400727MMZWRC10	Rosa	Cordero	Cruz	1940-07-27	F	B-	5519170242	paciente1945@example.com
HRBC840330MGCQIGS1	Diana	Reyes	Vázquez	1984-03-30	F	A-	5571682611	\N
OGIO230625MRPZYHW4	Karla	Aguilar	Flores	2023-06-25	F	O-	5555647311	paciente1947@example.com
HPUX890820XAARUQR3	Patricia	Chávez	Castillo	1989-08-20	Intersex	\N	5514857816	paciente1948@example.com
VZIC451121MQVTBYI4	María	Herrera	Hernández	1945-11-21	F	B+	5528826173	\N
GCIS501115MGWCQCM7	Guadalupe	Fuentes	Alvarado	1950-11-15	F	A+	5593804503	\N
CMJP670107XNISFX43	Laura	Jiménez	Sánchez	1967-01-07	Intersex	\N	5568133722	paciente1951@example.com
LGVS930206XFLWQRP0	Teresa	Salazar	González	1993-02-06	Intersex	A+	\N	paciente1952@example.com
JCXP800721HYQOMAJ8	Fernando	Hernández	Reyes	1980-07-21	M	AB-	5507264881	\N
RCFQ820810XQVHOTO9	Juan	Reyes	Romero	1982-08-10	Intersex	\N	5593082278	\N
YNSQ031002MXEHYFC7	Silvia	Ruiz	Chávez	2003-10-02	F	A+	5586115623	paciente1955@example.com
SIMP641021XBCIWCJ8	Gerardo	Rojas	González	1964-10-21	Intersex	O+	5571208362	\N
ORUR060714MNWCPHI7	Gabriela	Medina	Gómez	2006-07-14	F	AB-	5506395136	paciente1957@example.com
CWNS990725XRIUHNZ3	Carlos	Alvarado	Guzmán	1999-07-25	Intersex	A-	5556184535	paciente1958@example.com
EWTI750330MKQHNC88	Miriam	Rojas	Mendoza	1975-03-30	F	A-	5548923960	\N
MPUB940319MEDPZQL9	Mónica	Chávez	\N	1994-03-19	F	B-	5598816103	paciente1960@example.com
ZQXA051001MJGPICK6	Claudia	Flores	García	2005-10-01	F	\N	5586551086	paciente1961@example.com
PXXQ471228HGTZGVF3	Andrés	Delgado	García	1947-12-28	M	A+	5502759425	paciente1962@example.com
KPJQ930101HMGUERE0	Mario	Castillo	Mendoza	1993-01-01	M	AB-	5505605573	paciente1963@example.com
AYAX890605XNMDNZE5	Silvia	Ortiz	Cabrera	1989-06-05	Intersex	A-	5576602445	paciente1964@example.com
GHYW990603MMTOKOV5	Miriam	Delgado	Pérez	1999-06-03	F	B+	5506834260	paciente1965@example.com
TWSN971125HSMMXB81	Diego	Herrera	Solís	1997-11-25	M	\N	5558804140	\N
EZXM160416HDSHOTD2	Manuel	Herrera	Ramos	2016-04-16	M	A+	5593094431	paciente1967@example.com
OTTT960206HABPFKZ6	Pablo	Morales	Chávez	1996-02-06	M	\N	5530636578	paciente1968@example.com
ZBJD151212MHMPOPY7	Miriam	González	Mendoza	2015-12-12	F	B-	5532249673	paciente1969@example.com
DZEA730620XTJKIVB2	Emilio	Guzmán	Vargas	1973-06-20	Intersex	\N	5544388269	paciente1970@example.com
PIYR910111XQNQTSZ9	Javier	Sánchez	Aguilar	1991-01-11	Intersex	O+	5578639141	paciente1971@example.com
TJTB600916HVJZJI34	Ricardo	Delgado	\N	1960-09-16	M	A+	5572544527	paciente1972@example.com
UFRP510711HIBOKCP9	Juan	Estrada	Contreras	1951-07-11	M	O-	5560378280	\N
ARUU650203MLRPPOA7	Rosa	Estrada	Sánchez	1965-02-03	F	B-	\N	\N
FKMO690528XTPWYJZ3	Daniela	Peña	Estrada	1969-05-28	Intersex	O-	5577186266	paciente1975@example.com
HZHY441024XRMGZRH3	Silvia	Herrera	Castillo	1944-10-24	Intersex	O+	5526249864	\N
POAY741113MKHMJIP4	Fernanda	Castillo	Díaz	1974-11-13	F	B-	5521762080	paciente1977@example.com
QFRA430523XAZVSFB5	Eduardo	Herrera	Torres	1943-05-23	Intersex	A-	5550456869	paciente1978@example.com
CZKE081109HZJAIDU7	Juan	Pérez	Vázquez	2008-11-09	M	B-	5542768612	paciente1979@example.com
HHHK530730XNTJEAF8	Diana	Cabrera	Morales	1953-07-30	Intersex	B+	5557661629	paciente1980@example.com
CAGC000630XRJCUU53	Teresa	Mendoza	Romero	2000-06-30	Intersex	A+	5552346554	paciente1981@example.com
XNOV000730HFNIJVD1	Miguel	Hernández	Fuentes	2000-07-30	M	\N	5589143535	paciente1982@example.com
RVNZ140628XXUAPW61	Arturo	Gómez	Alvarado	2014-06-28	Intersex	A-	5584751340	paciente1983@example.com
LWRE240131MVIBYLU4	Teresa	Pérez	Chávez	2024-01-31	F	AB+	5512069061	\N
EKHZ860419XAHDKRR6	Iván	Delgado	Solís	1986-04-19	Intersex	B+	5594428054	paciente1985@example.com
SLBP160205HRPHAKM9	Daniel	Flores	Vázquez	2016-02-05	M	O+	5534329262	\N
LXME620428MQJTPLY5	Lucía	Mendoza	Mendoza	1962-04-28	F	AB-	5533939943	\N
QLYO800620XROQFZ70	Daniela	Ruiz	Fuentes	1980-06-20	Intersex	B-	5583978301	paciente1988@example.com
YVQJ481101XMYZUWB7	Diego	Mendoza	Delgado	1948-11-01	Intersex	B+	5562567032	paciente1989@example.com
OKBZ790119XSRBVEC7	Lucía	Solís	Ruiz	1979-01-19	Intersex	B-	5520469074	\N
PPGT030309HFBEJUQ4	Óscar	Castillo	Fuentes	2003-03-09	M	O+	5531971890	\N
FTVU440213HCXMTZQ2	Juan	Morales	Rojas	1944-02-13	M	AB+	\N	paciente1992@example.com
APWS361030MHLFOK05	Daniela	Romero	González	1936-10-30	F	A+	5508313001	paciente1993@example.com
FSBB960201HPJCZXY6	Óscar	Herrera	Pérez	1996-02-01	M	B+	5508604283	\N
XIIP910621MDBMBZZ0	Patricia	Vázquez	Gutiérrez	1991-06-21	F	AB+	5537788921	\N
TAQV530526XIPTZRC1	Antonio	López	Flores	1953-05-26	Intersex	O-	5556476585	paciente1996@example.com
ZXHM050712MUOXKUR7	Karla	Delgado	\N	2005-07-12	F	O-	5509999378	\N
BRAJ560729XKGGIGB4	Beatriz	Castillo	Vázquez	1956-07-29	Intersex	\N	5570002675	paciente1998@example.com
ZJZW861015MCNGQEV1	Sofía	Morales	Peña	1986-10-15	F	O-	5523035821	paciente1999@example.com
YBZX761204HIRUUA88	Roberto	Jiménez	Martínez	1976-12-04	M	AB+	5511258044	paciente2000@example.com
PECD421220HEODWM71	Juan	Castillo	Contreras	1942-12-20	M	O+	5517663521	paciente2001@example.com
CAOY150618MAMRNQ14	Paola	Morales	Vargas	2015-06-18	F	AB+	5541473594	paciente2002@example.com
FKFK380201XOOMRS57	Hugo	Morales	Ortiz	1938-02-01	Intersex	A-	5595166032	paciente2003@example.com
IVXA161012XTLWUB21	Raúl	Guzmán	Martínez	2016-10-12	Intersex	B-	5519963230	paciente2004@example.com
CWCL880309MUUTWLO3	Paola	Cruz	Delgado	1988-03-09	F	\N	5516290628	paciente2005@example.com
BVZG900125XASRBLF8	Jorge	Chávez	Romero	1990-01-25	Intersex	A-	5534936356	paciente2006@example.com
YHJP430412XEJWID17	Laura	Rojas	Solís	1943-04-12	Intersex	AB+	5587430964	paciente2007@example.com
HXJQ780506HPATXUL9	Andrés	Solís	Castillo	1978-05-06	M	B-	5528908454	paciente2008@example.com
DFKQ050916HDEVYR36	Roberto	Ramírez	Vázquez	2005-09-16	M	AB+	5504197447	paciente2009@example.com
QZKY891002XDNSFC45	Eduardo	Ramírez	Peña	1989-10-02	Intersex	O-	5535284547	\N
LZOI230904XVKWQB56	Diana	Chávez	\N	2023-09-04	Intersex	AB+	5578413831	\N
LTJR080209MFUZEIX2	Guadalupe	Rojas	Reyes	2008-02-09	F	B+	5588160353	paciente2012@example.com
IDDU530420MYSUDBG4	Daniela	Ruiz	Rodríguez	1953-04-20	F	AB-	5591298358	\N
PCEO840802XPWDKM65	Yolanda	García	Ramírez	1984-08-02	Intersex	A-	5590917447	paciente2014@example.com
AZZY080626MRTXFFC6	María	Herrera	\N	2008-06-26	F	B+	5599658402	paciente2015@example.com
NUKR520117HOEQAFP8	Sergio	Romero	Ramírez	1952-01-17	M	AB+	5526008059	paciente2016@example.com
AAWH791108XAAKGO82	Carmen	Sánchez	Salazar	1979-11-08	Intersex	\N	5587220307	\N
FGWS410613XOMUMFH5	Miguel	Alvarado	Flores	1941-06-13	Intersex	B+	\N	paciente2018@example.com
AYVE851014XOXETVK9	Miguel	Delgado	Hernández	1985-10-14	Intersex	B+	5528635834	paciente2019@example.com
URPU560715XUITKLF0	Leticia	Aguilar	Delgado	1956-07-15	Intersex	A+	5533558857	paciente2020@example.com
UGUQ891107HTDNCVB5	Mario	Medina	Torres	1989-11-07	M	B-	5587530296	\N
ZVTJ371003XCNOSKK0	Adriana	Estrada	Hernández	1937-10-03	Intersex	A+	5589145481	paciente2022@example.com
IKZQ790908XJRXPIQ0	Gabriela	Sánchez	Flores	1979-09-08	Intersex	O+	5526288658	paciente2023@example.com
UVAL750923MOZACS54	Lucía	Gómez	Hernández	1975-09-23	F	A-	5557529255	paciente2024@example.com
AWWR801110XINTXAA1	Silvia	Mendoza	Romero	1980-11-10	Intersex	B-	5581236242	\N
ELDS250427XWBMUOI4	Daniela	Ortiz	López	2025-04-27	Intersex	B+	5509577248	paciente2026@example.com
VRGK410120MOEVRTB9	Karla	Aguilar	Hernández	1941-01-20	F	O-	5500634741	paciente2027@example.com
FGAK111204MYSPLOP3	Araceli	Ramírez	\N	2011-12-04	F	AB+	5528765755	paciente2028@example.com
RLAX470128MNYMIQ48	Rosa	Romero	Aguilar	1947-01-28	F	A+	5548713000	\N
HHJO490813MTQLESQ8	Mónica	Castillo	Ramos	1949-08-13	F	B+	5504145056	\N
DCQD670715HSMUDG87	Raúl	López	Ramos	1967-07-15	M	B-	5555942298	paciente2031@example.com
JCTV120215XTOOXCF8	Roberto	Reyes	Cordero	2012-02-15	Intersex	O+	5567743604	paciente2032@example.com
ODIH111023HVNSYI44	Diego	Delgado	Estrada	2011-10-23	M	A-	5547688938	paciente2033@example.com
PZOM660119MJXKQVD8	Cecilia	Pérez	Herrera	1966-01-19	F	B+	5596521790	paciente2034@example.com
NALK130913HWPJBE84	Diego	Chávez	González	2013-09-13	M	B-	5587695591	paciente2035@example.com
HOGD790325MZQWWHW9	Rosa	Pérez	Rojas	1979-03-25	F	B+	5534592325	paciente2036@example.com
PCDY500904HMFZWOR3	Rodrigo	Gómez	Chávez	1950-09-04	M	B-	5549286327	paciente2037@example.com
BEQX440929HCBMAY56	Francisco	Rodríguez	Solís	1944-09-29	M	A-	5543346026	paciente2038@example.com
MUFS620104HZRVPBK5	Antonio	Mendoza	González	1962-01-04	M	A+	\N	paciente2039@example.com
LDPE401008HUGVMQX0	Alejandro	Solís	Jiménez	1940-10-08	M	B+	5548526023	paciente2040@example.com
KXLZ220720XHBYMCH3	María	Cruz	Torres	2022-07-20	Intersex	O+	\N	paciente2041@example.com
UFGI491114XBQPBYX6	Araceli	Estrada	Mendoza	1949-11-14	Intersex	\N	5533555638	paciente2042@example.com
GTSY020510XOJQZM90	Miguel	Herrera	Salazar	2002-05-10	Intersex	O+	5557338079	paciente2043@example.com
JAJI650416HOLADOU0	Roberto	Solís	Cabrera	1965-04-16	M	B-	5565589906	paciente2044@example.com
GFJF110116MBIHABZ3	Yolanda	Delgado	Ramírez	2011-01-16	F	O-	5506971363	paciente2045@example.com
BERM501222HDEEGF96	Gerardo	Pérez	Cruz	1950-12-22	M	O-	5524542249	\N
WBAA560419MDGEOQK8	Adriana	Martínez	Ramírez	1956-04-19	F	A+	5535097913	paciente2047@example.com
PNFS680829HIXWQI07	Andrés	Chávez	Sánchez	1968-08-29	M	AB+	5589779536	\N
BTBM840110MHHMBE53	María	Salazar	Cordero	1984-01-10	F	O-	5556726173	paciente2049@example.com
RSPW651006XOOGRXL4	Manuel	Ortiz	Estrada	1965-10-06	Intersex	A-	5521462922	\N
QKFX080129HFGKTAY2	Arturo	Jiménez	Pérez	2008-01-29	M	AB-	5594014412	paciente2051@example.com
LMOV521225HAQVUSO9	Jorge	Delgado	Torres	1952-12-25	M	A-	5550462933	paciente2052@example.com
KRZX480901MHGWQO69	Mónica	Sánchez	Morales	1948-09-01	F	B-	5519053094	paciente2053@example.com
FLZP621231MEHFXWM0	Sofía	Cabrera	Medina	1962-12-31	F	O+	5586186948	paciente2054@example.com
LFXT580301MDIRHXX6	Lucía	Contreras	Solís	1958-03-01	F	B-	\N	paciente2055@example.com
VAXF840822MKEVVLQ1	Silvia	Ramírez	Ramírez	1984-08-22	F	O-	5505562412	paciente2056@example.com
ZUSI230523MBXKSMT7	Karla	Romero	Medina	2023-05-23	F	O+	5564245320	paciente2057@example.com
CJHJ681112MBWVYG41	Yolanda	Jiménez	Romero	1968-11-12	F	B-	5543109156	paciente2058@example.com
XCXF040220XFLFXYZ4	Araceli	Martínez	Mendoza	2004-02-20	Intersex	AB-	5587067644	\N
VXAO370731MQCXBXE0	Cecilia	Jiménez	\N	1937-07-31	F	O-	5548056942	\N
AAII670301XSCBVYD7	Ana	Guzmán	Delgado	1967-03-01	Intersex	A+	5514920499	\N
ECBO180122XBVIVGE0	Emilio	Ortiz	Torres	2018-01-22	Intersex	B-	5503158878	paciente2062@example.com
ZLUD390106MIDIQHW1	Daniela	García	Vargas	1939-01-06	F	B-	5595142770	paciente2063@example.com
KDDC160505HWNFXPG4	Ricardo	Jiménez	Sánchez	2016-05-05	M	A-	5593410616	paciente2064@example.com
KLGD081224HWBPGPE2	Óscar	Torres	Rojas	2008-12-24	M	A+	\N	\N
XXFJ961213XARQNXC9	Luis	Fuentes	Gutiérrez	1996-12-13	Intersex	AB+	5525336010	paciente2066@example.com
CSDY550727XWIYBA61	Elena	Cordero	Reyes	1955-07-27	Intersex	A+	5597192288	paciente2067@example.com
ITEZ480406MLIUGJV0	Diana	González	Delgado	1948-04-06	F	A+	5542738696	paciente2068@example.com
CYFS951001MUXEWOJ4	Elena	González	López	1995-10-01	F	A-	\N	paciente2069@example.com
OQCA841114MPAQWEQ0	Paola	Peña	Aguilar	1984-11-14	F	\N	5535133157	paciente2070@example.com
CWMU910303HFACOEU1	Javier	Gómez	Alvarado	1991-03-03	M	A+	5560869611	paciente2071@example.com
TAXS040406HFVUVPZ7	Javier	Díaz	\N	2004-04-06	M	A-	5508633399	paciente2072@example.com
PNAZ680127MWKLAQB0	Guadalupe	Castillo	Castillo	1968-01-27	F	B-	5509083069	\N
LNJJ940316HZCSSXS1	Iván	Delgado	López	1994-03-16	M	A+	5561605029	paciente2074@example.com
DYUQ730804XDXJTRN6	Gabriela	López	Pérez	1973-08-04	Intersex	AB-	5590321774	paciente2075@example.com
KLAW860513XVZBIG55	Jorge	Sánchez	Alvarado	1986-05-13	Intersex	A-	5515752295	\N
SBGN401017XPJRNOX6	Raúl	Salazar	Morales	1940-10-17	Intersex	AB-	5535153474	\N
ORBY200825HWAGPRF0	Raúl	García	Flores	2020-08-25	M	O-	\N	paciente2078@example.com
DYMA440526HTVTAS35	Arturo	Cruz	Torres	1944-05-26	M	AB-	5585166190	paciente2079@example.com
IHZS210607MJXVWME6	Mónica	Gutiérrez	Estrada	2021-06-07	F	A+	5527726105	\N
XFQU240102XJZNLXV9	Cecilia	López	Aguilar	2024-01-02	Intersex	A+	5589568864	paciente2081@example.com
ILGT850521XCRBFH84	Claudia	Vázquez	Delgado	1985-05-21	Intersex	\N	5514443373	paciente2082@example.com
KOKH791018XYXOTJ26	Sofía	López	Hernández	1979-10-18	Intersex	A-	5534290024	paciente2083@example.com
GJMX110825HVCKCZK1	Óscar	Rojas	Ramos	2011-08-25	M	AB+	5508960106	paciente2084@example.com
QVFW850929MJEXLNX8	Yolanda	Chávez	Peña	1985-09-29	F	A+	5538540445	\N
GXIM780617HMTYAQH4	Mario	Cabrera	Morales	1978-06-17	M	B+	5560296532	paciente2086@example.com
GAPA660411XOTZDTC4	Yolanda	Jiménez	Ruiz	1966-04-11	Intersex	\N	5586015083	paciente2087@example.com
TQET090825HUXILIF8	Adrián	Díaz	González	2009-08-25	M	A-	5578814742	paciente2088@example.com
GTLV210817HBUWZB28	Sergio	Gutiérrez	Ramírez	2021-08-17	M	AB+	5555005357	paciente2089@example.com
MOGG060102XMCIFI44	Alejandra	Aguilar	Cordero	2006-01-02	Intersex	O-	5516329566	paciente2090@example.com
WIUH390719XNJRKC28	Javier	Medina	Flores	1939-07-19	Intersex	A+	5557730614	paciente2091@example.com
CTMJ570110MAXBBXJ5	María	Pérez	Torres	1957-01-10	F	AB+	5535962783	paciente2092@example.com
AEHJ020508XPYDJLH3	María	Guzmán	Ramos	2002-05-08	Intersex	AB-	5502826565	\N
OLYI090913HKVIAHT9	Adrián	Aguilar	Aguilar	2009-09-13	M	\N	5593975955	\N
BSIO640317XBKIIPZ5	Andrés	Solís	Gómez	1964-03-17	Intersex	\N	5539018769	\N
KXEQ770411MOCLYW73	Guadalupe	Díaz	Medina	1977-04-11	F	B+	5543029973	paciente2096@example.com
TYIR111004MYAJWN68	Mónica	Gómez	Hernández	2011-10-04	F	AB+	5598908763	paciente2097@example.com
ZODD860503MLOROG48	Lucía	Gómez	Gutiérrez	1986-05-03	F	O-	5561621736	paciente2098@example.com
JAWU200130HGCSWDZ6	Antonio	Herrera	Morales	2020-01-30	M	AB+	5516246988	paciente2099@example.com
XCQE100413XFJOSUL2	Rosa	Alvarado	Castillo	2010-04-13	Intersex	B+	5586707167	\N
KORL130203MWFGKE60	Rosa	Cabrera	Peña	2013-02-03	F	O+	5534137345	\N
KQFF470302MCRDSKF7	Paola	Rodríguez	Ruiz	1947-03-02	F	O-	5507067769	\N
JKHR441102HGGMJFW5	Francisco	Rodríguez	Castillo	1944-11-02	M	O+	5553321012	paciente2103@example.com
JSSV190719MTLSYY27	Miriam	Castillo	Estrada	2019-07-19	F	O+	5570568258	\N
JLMZ960226HGZMPT68	Luis	Díaz	Vázquez	1996-02-26	M	A-	5563644498	paciente2105@example.com
EZNO580423HYGSEUB6	Hugo	Castillo	Morales	1958-04-23	M	O+	5594299211	paciente2106@example.com
YZUK680212HBNTVP82	Alejandro	Vargas	Vázquez	1968-02-12	M	O+	5538721120	\N
YTBD730111HLAYVYX9	Rodrigo	Delgado	Morales	1973-01-11	M	B-	5576168068	\N
KVWI250310HNQACZM1	Juan	Gutiérrez	Martínez	2025-03-10	M	B+	5536057432	\N
UXUU700301HTESCY49	Carlos	Ruiz	Ramos	1970-03-01	M	O-	5590913641	paciente2110@example.com
SJRU371222MGZMASB1	Alejandra	Cabrera	Mendoza	1937-12-22	F	AB+	5501153609	paciente2111@example.com
ITPG661215HEBASNC1	Andrés	Gutiérrez	Morales	1966-12-15	M	B-	5530532562	paciente2112@example.com
WRAZ670915XJTPBI04	Verónica	Fuentes	Salazar	1967-09-15	Intersex	\N	5555516932	paciente2113@example.com
OYZV450828HZJDCUN5	Emilio	Ramos	Solís	1945-08-28	M	A-	5503891667	paciente2114@example.com
KVQM431002HQWBIWM9	Andrés	Mendoza	Medina	1943-10-02	M	B+	5500889258	paciente2115@example.com
RBGP610803MAGOPGF2	Paola	Medina	Estrada	1961-08-03	F	O+	5588694853	paciente2116@example.com
ZGIA181009MXSLWUH4	Mónica	Herrera	Salazar	2018-10-09	F	O+	5518136170	\N
YXEV601022MGVIQDA9	Rosa	Ruiz	Rodríguez	1960-10-22	F	B+	5525539625	paciente2118@example.com
WYWY660330MXSROBE0	Ana	Díaz	Cruz	1966-03-30	F	A-	5515294176	\N
IYWB110809HTMXKYI6	Mario	Gutiérrez	Jiménez	2011-08-09	M	O-	5566948100	\N
NOSM140928HKLUMU33	Iván	Vázquez	Martínez	2014-09-28	M	A+	5536841434	\N
IVTU820128HBKGQVA5	Jorge	Medina	\N	1982-01-28	M	B-	\N	paciente2122@example.com
RHME860816XKOPFCB8	Javier	Flores	González	1986-08-16	Intersex	AB-	5541059157	paciente2123@example.com
RJSL170726XWZLFT14	Ana	Pérez	Ramos	2017-07-26	Intersex	A-	5522173284	\N
BVFA771006XETCUOL6	María	Cordero	Cabrera	1977-10-06	Intersex	B-	5534204578	paciente2125@example.com
XLHB130606HGBEICO0	Carlos	Ortiz	Aguilar	2013-06-06	M	O+	5531464421	\N
LKVT390317MEXEPPB2	Cecilia	Guzmán	Martínez	1939-03-17	F	AB+	\N	paciente2127@example.com
SXQO701013MWFLMV14	Fernanda	Peña	Guzmán	1970-10-13	F	O-	\N	paciente2128@example.com
MOFW691119MOWMGG08	Miriam	Alvarado	Peña	1969-11-19	F	O+	5571194750	paciente2129@example.com
EZPZ191024MAXJEEX9	Cecilia	Gómez	Rodríguez	2019-10-24	F	A-	5523814331	paciente2130@example.com
VPJV461025HJNSPB51	Fernando	Castillo	Peña	1946-10-25	M	O-	5589511157	paciente2131@example.com
DKUL810510MQMAFMT2	Patricia	Reyes	Morales	1981-05-10	F	A-	5524588469	paciente2132@example.com
LAQV810228MALUWOE1	Ana	Díaz	Salazar	1981-02-28	F	AB-	5544002748	paciente2133@example.com
GMMN710330HBJJRYZ7	Alejandro	Gutiérrez	Vargas	1971-03-30	M	O-	5581618277	paciente2134@example.com
OQXJ880409MLWEOHP1	Leticia	Vargas	Delgado	1988-04-09	F	\N	5581567541	paciente2135@example.com
KVOT940302MOUZAX39	Mónica	Solís	Solís	1994-03-02	F	O+	5570455300	\N
LSFD100420HUFSURW6	Carlos	Torres	Guzmán	2010-04-20	M	AB-	5540555251	paciente2137@example.com
UMJE110928MYXIGOT2	Cecilia	Fuentes	Chávez	2011-09-28	F	\N	5520220410	paciente2138@example.com
FWBV950312XDXIQO00	Pablo	López	Aguilar	1995-03-12	Intersex	AB+	5537250093	paciente2139@example.com
ZFBL080326HXANXLC6	Rodrigo	Cabrera	Peña	2008-03-26	M	AB+	5515884452	\N
BZVF531207MBRSMPZ0	Silvia	Torres	Martínez	1953-12-07	F	B+	\N	paciente2141@example.com
WOKD141227HTMPSZL9	Antonio	Gómez	Mendoza	2014-12-27	M	AB+	\N	paciente2142@example.com
FFBP010621MBJGCZC7	Adriana	Pérez	Vázquez	2001-06-21	F	AB-	5528749958	paciente2143@example.com
XMBC770324XPYMWU48	Pablo	Rojas	Flores	1977-03-24	Intersex	AB-	5588011130	paciente2144@example.com
HLFE780323HGOPKBR4	Hugo	Delgado	Vázquez	1978-03-23	M	\N	5563244896	paciente2145@example.com
DMXX880324MLKUJE39	Guadalupe	Díaz	Flores	1988-03-24	F	A-	5599702146	\N
BETN190315MVYUULQ4	Teresa	López	Aguilar	2019-03-15	F	O-	5504377029	paciente2147@example.com
NYFH961126MOFYIMR5	Araceli	López	Vázquez	1996-11-26	F	AB+	\N	paciente2148@example.com
MKYM221204MXHFFVZ7	Yolanda	Pérez	Delgado	2022-12-04	F	O-	5517851259	paciente2149@example.com
MTJE181025XYEETEW3	Adrián	Gómez	Delgado	2018-10-25	Intersex	\N	5587576176	paciente2150@example.com
QQHN500427MNAPSRN3	Verónica	Flores	Mendoza	1950-04-27	F	B+	\N	\N
LUSF150828HMNQMM70	Raúl	Medina	Solís	2015-08-28	M	\N	5579565300	\N
WNVA070823HIPATE90	Raúl	Mendoza	\N	2007-08-23	M	A-	5571421374	paciente2153@example.com
EVNX690220HWQTISU4	Raúl	Cabrera	Gómez	1969-02-20	M	A+	5562933698	\N
ZTLT180126MQDUVNE8	María	Guzmán	Medina	2018-01-26	F	O+	5580988040	paciente2155@example.com
JKEF551220HPLTIEY7	Roberto	Gómez	Díaz	1955-12-20	M	A-	5572221553	\N
YFSO081127HILDCWZ5	Gerardo	Rodríguez	Delgado	2008-11-27	M	O-	5586249513	\N
OKEU510618MSMMXJ41	Daniela	García	Ramos	1951-06-18	F	O-	5532072391	paciente2158@example.com
LBYN420816HGNSWV65	Javier	Torres	Ramos	1942-08-16	M	O-	5576559991	paciente2159@example.com
XFEG200323XMIJSWW1	Gerardo	Romero	Castillo	2020-03-23	Intersex	B+	5504342491	paciente2160@example.com
YIWI830818HEFEDFT2	Fernando	Morales	Contreras	1983-08-18	M	O-	5597381903	\N
FSLR660519HHXRKA63	Carlos	Contreras	López	1966-05-19	M	A-	5510453513	paciente2162@example.com
CWOC050715MTVUCMO3	Diana	Morales	Ortiz	2005-07-15	F	B-	5515433825	paciente2163@example.com
VEBM631123MRESUSQ5	Carmen	Romero	Cruz	1963-11-23	F	\N	5528457186	paciente2164@example.com
CNXF380720XLJTTGG4	Francisco	Cabrera	Medina	1938-07-20	Intersex	B-	5565133861	paciente2165@example.com
DNAK870124MIHHOVB7	Karla	Ortiz	Pérez	1987-01-24	F	A-	5512747069	paciente2166@example.com
QYTJ541130MAVVMT22	Adriana	González	Contreras	1954-11-30	F	AB+	5520418629	\N
UOKX760321XWRMWI54	Silvia	Rodríguez	Vargas	1976-03-21	Intersex	O+	5519255317	paciente2168@example.com
DJWH861005MRXIBH32	Carmen	García	Rodríguez	1986-10-05	F	AB+	5545769094	\N
NVXB080206HGQKUKK8	Eduardo	Hernández	Castillo	2008-02-06	M	\N	5513299678	\N
SDTO700501MYONHQX8	Claudia	Ruiz	Mendoza	1970-05-01	F	AB+	5592254376	\N
ZDZN840503MLGUKTV5	Verónica	Medina	González	1984-05-03	F	A-	5550698958	paciente2172@example.com
ZBTS550808HXOWEQV5	Andrés	Torres	Reyes	1955-08-08	M	B+	5593943149	paciente2173@example.com
BSMO601211MMEJERX7	Verónica	González	Gutiérrez	1960-12-11	F	B+	\N	\N
ZAGL420608MIONMZO0	Verónica	Rojas	Contreras	1942-06-08	F	AB-	5579975109	\N
JAPF691226XZHIZNG5	Sofía	Ruiz	Rodríguez	1969-12-26	Intersex	O+	5517082922	\N
AAFS700412HWLBCZF4	Emilio	Chávez	Vázquez	1970-04-12	M	AB-	5572990555	\N
TPLP030202MWYJKM84	Rosa	Morales	Martínez	2003-02-02	F	B+	5563333884	paciente2178@example.com
WJRG070225MZBREJF3	Alejandra	González	López	2007-02-25	F	O+	5506449035	paciente2179@example.com
PVPX390223XUGGJWO0	Raúl	Ortiz	Sánchez	1939-02-23	Intersex	AB-	5521821606	paciente2180@example.com
UVQD840508XVCVZA80	Ricardo	Jiménez	Aguilar	1984-05-08	Intersex	A+	5538836970	paciente2181@example.com
ZLNJ040324HIVCCTM5	Pablo	Ruiz	Chávez	2004-03-24	M	B+	5572863996	\N
TEBH381128HCPULTE4	Hugo	Flores	Torres	1938-11-28	M	B-	\N	\N
PEQM561201XTHTKHF0	Juan	Cordero	Mendoza	1956-12-01	Intersex	AB+	5573338276	paciente2184@example.com
VBFW770409MJSMMQK3	Leticia	Vázquez	Ortiz	1977-04-09	F	\N	5555201015	paciente2185@example.com
TEAO810830MIBLDZ97	Beatriz	Gutiérrez	Gutiérrez	1981-08-30	F	O+	5522177599	\N
QHSC720306MAGFAWR1	Beatriz	Torres	Solís	1972-03-06	F	O+	5572810297	\N
DENG460517MOBUBP13	Leticia	Vargas	Ruiz	1946-05-17	F	A-	5522517666	paciente2188@example.com
JNFD811110XGGJLSW8	Gabriela	Gómez	Flores	1981-11-10	Intersex	A+	5556562192	paciente2189@example.com
XSJJ450503XCYJPLN7	Óscar	Estrada	\N	1945-05-03	Intersex	AB+	5578256485	paciente2190@example.com
VKVP450211MPXAKD96	Paola	Alvarado	Ruiz	1945-02-11	F	B-	5506799645	\N
EKNQ700614MOAJFNQ6	Silvia	Cordero	\N	1970-06-14	F	AB-	5508046606	\N
JDNE610702XYOKAZK0	Cecilia	Gómez	López	1961-07-02	Intersex	A+	5521238029	paciente2193@example.com
EPMH371126XKXDJQ34	Daniel	Torres	Aguilar	1937-11-26	Intersex	AB-	5551295458	paciente2194@example.com
HKQV361205XJSTUTE6	Patricia	Chávez	Solís	1936-12-05	Intersex	B-	5559522875	\N
VJYS810311HOHYCDF4	Daniel	López	Pérez	1981-03-11	M	AB+	5560989105	paciente2196@example.com
DTUO681004MUIBAWX9	Lucía	Chávez	Aguilar	1968-10-04	F	AB-	5583445942	\N
JCQF800130XRUNKIC7	Andrés	Flores	\N	1980-01-30	Intersex	\N	5555054151	paciente2198@example.com
OAOZ570819XSMVAVZ1	Fernando	Contreras	Vargas	1957-08-19	Intersex	AB+	5513512848	\N
FPOX770618XBWNSTI2	Óscar	Mendoza	Mendoza	1977-06-18	Intersex	AB+	5515694906	paciente2200@example.com
AFWH231230XLCVEAQ5	Sofía	Gómez	Sánchez	2023-12-30	Intersex	AB+	5557349438	paciente2201@example.com
SQWX930728XISWCH87	Fernanda	Alvarado	Guzmán	1993-07-28	Intersex	\N	5501881113	\N
GDIH070114MFICUOA7	Teresa	Chávez	Flores	2007-01-14	F	O-	5587963387	paciente2203@example.com
VFFX080707XBQEFBT4	Sofía	López	González	2008-07-07	Intersex	\N	5535197881	paciente2204@example.com
JEVK531109MTSAAWL8	Silvia	Ruiz	López	1953-11-09	F	B+	5541701831	\N
BKXV050817MPSFKWF7	Lucía	Díaz	López	2005-08-17	F	A-	5558136822	\N
WPTN391222XRLJMFF1	Leticia	Ramos	Peña	1939-12-22	Intersex	AB+	5500620821	paciente2207@example.com
JXUU861202MKVGMEI1	María	Contreras	Aguilar	1986-12-02	F	A-	5550113449	paciente2208@example.com
SCQJ131104XQSSILR9	Leticia	Delgado	Delgado	2013-11-04	Intersex	B+	5572547204	paciente2209@example.com
HSIS881013MAIMKDS4	Patricia	Rodríguez	Mendoza	1988-10-13	F	B+	5557481452	paciente2210@example.com
ZMJM651216XKARTHB4	Leticia	Medina	Fuentes	1965-12-16	Intersex	A-	5578421391	\N
IQHT950320MGPPPE21	Miriam	Estrada	Rojas	1995-03-20	F	B-	5522412503	paciente2212@example.com
PEFH991126XOEBOJE9	Fernando	Díaz	Gómez	1999-11-26	Intersex	AB-	5570063239	paciente2213@example.com
OGHL410802XFDAQK73	Verónica	Solís	Rojas	1941-08-02	Intersex	AB-	5582632189	\N
LYQS781015MWWSQWF8	Araceli	Rodríguez	Salazar	1978-10-15	F	O-	5599428178	\N
GGVS021104HXUKKGT3	Gerardo	Cordero	\N	2002-11-04	M	A-	5571972040	paciente2216@example.com
YGUY001119XBATUC33	Daniela	Vázquez	Cruz	2000-11-19	Intersex	O-	5532430872	paciente2217@example.com
PDEC421213MFLPTZ89	Rosa	Reyes	Martínez	1942-12-13	F	AB+	5510241982	paciente2218@example.com
BOMS091127HSUCLE83	Alejandro	Ortiz	Mendoza	2009-11-27	M	O-	\N	paciente2219@example.com
MLBD870702MRBBLIS0	Paola	Medina	Rodríguez	1987-07-02	F	A+	5560123162	paciente2220@example.com
AGMN220921MYRLPJP9	Sofía	Pérez	\N	2022-09-21	F	AB-	5538471845	paciente2221@example.com
SZCR100215MFGNGPI5	Adriana	Hernández	Rodríguez	2010-02-15	F	O-	\N	paciente2222@example.com
EMEH210103XOALBM34	Luis	Vázquez	Pérez	2021-01-03	Intersex	\N	5525229254	paciente2223@example.com
CNTC521129MJLLTBN6	Alejandra	Díaz	Jiménez	1952-11-29	F	B-	5542372466	paciente2224@example.com
CPJU901006MOSAIZW5	Diana	Ramírez	Guzmán	1990-10-06	F	A+	5542059642	paciente2225@example.com
PCTU050226XMBWUGS8	Mario	Fuentes	Díaz	2005-02-26	Intersex	AB-	5531160156	paciente2226@example.com
CDYX420729HUXVKIL4	Mario	Cabrera	Gómez	1942-07-29	M	O+	\N	\N
ZBWQ701201XNRAQZ63	Arturo	Vázquez	Contreras	1970-12-01	Intersex	B-	5555836454	paciente2228@example.com
YWPI560625MELXJFD4	Sofía	Peña	Cabrera	1956-06-25	F	A-	5527568497	paciente2229@example.com
UNZP781111XFYKHB61	Óscar	Hernández	Vargas	1978-11-11	Intersex	B-	5586789451	\N
JNPC530828XUWUSTJ7	Yolanda	Jiménez	Flores	1953-08-28	Intersex	B-	5571002959	paciente2231@example.com
PLOB490923HLGFBSP6	Ricardo	González	Salazar	1949-09-23	M	O-	5501446419	paciente2232@example.com
VBGN190516HPKQAMO2	Iván	Cabrera	Ortiz	2019-05-16	M	\N	5540117130	paciente2233@example.com
INOS780411XBROPZO7	Guadalupe	Martínez	Rodríguez	1978-04-11	Intersex	A-	5516927592	paciente2234@example.com
MUTU381006MOPJBA30	Guadalupe	Pérez	\N	1938-10-06	F	O-	5525661806	\N
APBA220122XDAEYEI1	Araceli	Ramos	Contreras	2022-01-22	Intersex	A+	5583905101	paciente2236@example.com
GZIX741207HSDAZM36	Gerardo	Fuentes	Aguilar	1974-12-07	M	\N	5510149411	paciente2237@example.com
DSMI930310MYESKQY1	Adriana	Gómez	Cruz	1993-03-10	F	AB+	5511702544	paciente2238@example.com
IXFW620523XCQVZEU4	Gerardo	Chávez	Flores	1962-05-23	Intersex	\N	\N	paciente2239@example.com
FJEI461011MUYENGP5	Teresa	Ramos	\N	1946-10-11	F	A+	5575487713	\N
ZUEA700705HHDYQN26	José	Castillo	Vázquez	1970-07-05	M	AB-	5582287807	paciente2241@example.com
NHBW701027XSMNMO12	Carlos	López	Gutiérrez	1970-10-27	Intersex	AB+	\N	\N
TTCU491227XBIZWPH6	Mónica	Alvarado	Gutiérrez	1949-12-27	Intersex	B+	5595458446	paciente2243@example.com
DLGI850507MFOQXSN2	Miriam	Sánchez	Solís	1985-05-07	F	\N	5573227665	\N
JYTY480621XZJNWJV4	Patricia	Solís	Rojas	1948-06-21	Intersex	O+	5500214366	paciente2245@example.com
RFGE760110XHJZKXP3	Daniel	Ruiz	Morales	1976-01-10	Intersex	B-	5582289657	paciente2246@example.com
ZHWT380606MRADGH36	Teresa	Solís	García	1938-06-06	F	O-	5515770141	\N
EGCL500801HHTIFRE1	Eduardo	Herrera	Aguilar	1950-08-01	M	B-	5565091639	paciente2248@example.com
XTYZ520224XYEDZLE0	Rodrigo	Martínez	Vargas	1952-02-24	Intersex	\N	5500944300	\N
MSJE950809MOUNUG90	Adriana	Ramírez	Aguilar	1995-08-09	F	\N	5532676311	paciente2250@example.com
TQPC480816HIDIFNS2	Rodrigo	Hernández	Jiménez	1948-08-16	M	A-	\N	paciente2251@example.com
GQXG410512MXQXCN54	Diana	Aguilar	Ortiz	1941-05-12	F	A+	5595405847	\N
ZQSP131002XZFUJK39	Cecilia	Delgado	Ramos	2013-10-02	Intersex	\N	5582245540	paciente2253@example.com
JUST150815MMDDYP28	Patricia	Sánchez	\N	2015-08-15	F	B-	5553905798	paciente2254@example.com
SKZH040625HXABXVI5	Rodrigo	Alvarado	Vázquez	2004-06-25	M	B-	5595256377	paciente2255@example.com
LQXP971018HZBDHDH1	Carlos	Gómez	Flores	1997-10-18	M	AB-	5573358362	paciente2256@example.com
NSJJ950403XHRPRPE7	Alejandra	Gómez	Pérez	1995-04-03	Intersex	O-	5593589105	paciente2257@example.com
PGTN610101MZIGVYM1	Elena	Gómez	Flores	1961-01-01	F	AB+	\N	\N
VRVX871230XWPRJE47	Mónica	Peña	Salazar	1987-12-30	Intersex	B-	5536720975	\N
XRKX140320MMQKSIS1	Fernanda	Peña	Cordero	2014-03-20	F	AB+	5593311156	paciente2260@example.com
MXED100622XQBMWWA3	Patricia	Chávez	Martínez	2010-06-22	Intersex	AB+	5535185229	paciente2261@example.com
BOXZ630513MHZTQOF4	Leticia	Ruiz	Morales	1963-05-13	F	\N	5554430074	paciente2262@example.com
JDUJ430306XNXZLD63	Silvia	Vargas	Guzmán	1943-03-06	Intersex	O-	5532533630	paciente2263@example.com
BOBF890704XKAOXM16	Iván	Contreras	Aguilar	1989-07-04	Intersex	O+	5595085261	paciente2264@example.com
XGEM480817MYIPIDQ1	Rosa	Peña	Ruiz	1948-08-17	F	A+	5504396848	paciente2265@example.com
CRVV460816MEAQPDY3	Silvia	Aguilar	García	1946-08-16	F	\N	5519392719	\N
TRPT400309XEDNKAG8	Claudia	Jiménez	Rodríguez	1940-03-09	Intersex	O-	5557601808	paciente2267@example.com
EJTZ881027MCKEVQO2	Lucía	Chávez	Ramírez	1988-10-27	F	\N	5566517731	\N
DHKE030902XWZXPV12	Teresa	Contreras	Cabrera	2003-09-02	Intersex	B-	5537651182	paciente2269@example.com
DOFP720403MDYKIRM6	Cecilia	Ramos	Vázquez	1972-04-03	F	A+	5534135033	\N
UQOK880607HOJUXJ15	Iván	Guzmán	Delgado	1988-06-07	M	B+	5582187398	paciente2271@example.com
RPPI791222HBYLBGE5	Gerardo	Ramírez	Chávez	1979-12-22	M	O-	5565086569	paciente2272@example.com
PPCH990609MJCFKXP8	Miriam	Jiménez	Díaz	1999-06-09	F	A-	5510657299	paciente2273@example.com
WYBN400730MPUBHTO3	Leticia	Aguilar	Flores	1940-07-30	F	AB+	5577441084	\N
FWBA790209MGVIBTP5	Araceli	Sánchez	Sánchez	1979-02-09	F	\N	5517320310	paciente2275@example.com
QIPQ500224MZQPWU38	Gabriela	Alvarado	Rodríguez	1950-02-24	F	\N	5545879579	paciente2276@example.com
JNCU500222HTBMSWL3	Manuel	Estrada	Estrada	1950-02-22	M	B-	\N	paciente2277@example.com
QMMQ650729XNRVTS74	Beatriz	Vázquez	Rojas	1965-07-29	Intersex	A+	\N	\N
KEID210412MDIYFB26	Carmen	Ramos	Jiménez	2021-04-12	F	B-	5533529495	paciente2279@example.com
WCAR480429HIZUVSK9	Antonio	Solís	Romero	1948-04-29	M	AB-	\N	paciente2280@example.com
EWYS190621HONPMEH3	Arturo	Alvarado	Castillo	2019-06-21	M	B-	5556143153	paciente2281@example.com
USSW750820XLHCFBC8	Alejandra	Morales	Gutiérrez	1975-08-20	Intersex	B-	5504002417	\N
PXHG540215MCGJUET1	Miriam	Torres	Reyes	1954-02-15	F	B+	5571897621	paciente2283@example.com
FDBD710115MPEPIRI1	Teresa	Ortiz	Cordero	1971-01-15	F	B-	5575079631	\N
MCTN730204MWUUKCZ6	Lucía	Hernández	Díaz	1973-02-04	F	A+	5545706586	paciente2285@example.com
YOOD630409MVODFCM9	Verónica	Vázquez	Mendoza	1963-04-09	F	O-	5570700227	paciente2286@example.com
FOQJ950709MGAWAH87	Beatriz	Flores	Gutiérrez	1995-07-09	F	\N	5506465949	\N
UQPW711025XITWGWL0	Emilio	Fuentes	Gutiérrez	1971-10-25	Intersex	A-	5522686870	paciente2288@example.com
LZJK780127HPWWMKN0	Raúl	Mendoza	Rojas	1978-01-27	M	A+	5564308132	\N
EFNM181201MJYHWZX0	Karla	Mendoza	\N	2018-12-01	F	B+	5555731492	paciente2290@example.com
ONAG810829MREZVQD7	Daniela	Gómez	Torres	1981-08-29	F	O-	\N	\N
DUOU010405MSHTTM49	Rosa	Herrera	Alvarado	2001-04-05	F	A-	5539338338	paciente2292@example.com
SZQE781127MLQDOG96	Elena	Medina	Castillo	1978-11-27	F	\N	5565223507	paciente2293@example.com
PHXU761226XLEDST70	Mónica	Solís	Guzmán	1976-12-26	Intersex	AB+	5549603342	paciente2294@example.com
EXEN840220XVUNFRF0	Rosa	Ruiz	Castillo	1984-02-20	Intersex	AB-	5577867397	\N
INQZ860616HSSHGBX3	Andrés	López	Cabrera	1986-06-16	M	AB-	5562426103	\N
DQRI940428MYTDTR06	Elena	Guzmán	Aguilar	1994-04-28	F	O-	5594063572	\N
YEZM830119MVWQKBA7	Yolanda	Vázquez	Ruiz	1983-01-19	F	A+	5543858009	paciente2298@example.com
ZWIU110416XZKWAKE4	Araceli	Medina	Cabrera	2011-04-16	Intersex	O+	5573597543	paciente2299@example.com
MDWB750108MPPXST27	Adriana	Aguilar	Peña	1975-01-08	F	A+	5526461533	paciente2300@example.com
YLXB840613HPNZTP19	Miguel	Rojas	\N	1984-06-13	M	A-	5505145386	paciente2301@example.com
CEYB451024XPKABAZ9	José	Sánchez	Herrera	1945-10-24	Intersex	O-	5558593922	paciente2302@example.com
GFED090506MJXRTJR1	Alejandra	Ruiz	Ramos	2009-05-06	F	A-	5599517699	\N
KSBP730513HALXVV19	Antonio	Salazar	Alvarado	1973-05-13	M	B-	5506361128	paciente2304@example.com
GAVM850123MSZTHQJ1	Guadalupe	Medina	González	1985-01-23	F	B+	5587899996	\N
JBLE760303XCQLBKY0	Raúl	García	Gómez	1976-03-03	Intersex	\N	5519126048	paciente2306@example.com
RCRI411015XIATHR15	Claudia	Romero	Peña	1941-10-15	Intersex	B+	5592705487	paciente2307@example.com
AZXB050719MLMASUT4	Guadalupe	Ramos	Cruz	2005-07-19	F	AB+	5550123506	paciente2308@example.com
LALT491019MAQLUL36	Yolanda	Aguilar	Hernández	1949-10-19	F	B-	5593793919	paciente2309@example.com
SBWG500129MKECWZY0	Adriana	Contreras	Cabrera	1950-01-29	F	O-	\N	paciente2310@example.com
IVUH081207MFCDCUD2	Paola	González	Gutiérrez	2008-12-07	F	AB+	5523773813	paciente2311@example.com
DILF031127HHPRYZA3	José	Peña	Fuentes	2003-11-27	M	B+	5532874256	paciente2312@example.com
VKRB580822XBBWLRW3	Pablo	Romero	López	1958-08-22	Intersex	\N	5575015438	paciente2313@example.com
UBPO750707XTWZITG4	Lucía	Ramos	Rodríguez	1975-07-07	Intersex	\N	5515144661	paciente2314@example.com
BANL170517XNEMMN88	Mónica	Ramos	Contreras	2017-05-17	Intersex	B-	5555363776	paciente2315@example.com
VHIJ100809XYZEHZ91	Gabriela	Ruiz	López	2010-08-09	Intersex	AB+	5566484918	paciente2316@example.com
HMGW790519HKRBVLN3	Manuel	Aguilar	Salazar	1979-05-19	M	O-	5513135611	paciente2317@example.com
JJOS081125HZGOFXL3	Jorge	Rojas	Guzmán	2008-11-25	M	O-	5561968225	paciente2318@example.com
GDGU660523MWYKWV54	Lucía	Herrera	Díaz	1966-05-23	F	O+	5547407397	\N
KOPS890312XSZBMD63	Emilio	Rodríguez	Ruiz	1989-03-12	Intersex	B+	5551180954	paciente2320@example.com
EQNH430112HJRIAC11	Daniel	Ramírez	Mendoza	1943-01-12	M	AB-	\N	paciente2321@example.com
JKGH980610XPWLFAG5	Gerardo	Torres	Sánchez	1998-06-10	Intersex	AB+	5546164157	\N
GICU171014MPQCATA7	Daniela	Herrera	Peña	2017-10-14	F	O-	5571451495	\N
GRPG560324XMRBOFZ6	Beatriz	Cordero	Fuentes	1956-03-24	Intersex	O-	5580843881	paciente2324@example.com
FGUA610922XTTBOAT6	Andrés	Herrera	Contreras	1961-09-22	Intersex	B+	5503006045	paciente2325@example.com
QPHG180327HBAFPUY3	Hugo	Peña	Medina	2018-03-27	M	A+	5572237369	paciente2326@example.com
BKSB910214HIOHLGU2	Alejandro	Vázquez	Cordero	1991-02-14	M	A+	5554930539	paciente2327@example.com
VVLZ080407HTSNJE00	Gerardo	Gutiérrez	Rodríguez	2008-04-07	M	AB+	5509897274	paciente2328@example.com
MJCZ150621XCTTCWM6	Óscar	Pérez	Reyes	2015-06-21	Intersex	B-	5502542600	paciente2329@example.com
GQIG100925XLOTTG89	Silvia	Cordero	Gómez	2010-09-25	Intersex	B-	5545892251	paciente2330@example.com
TOOL010611MMLKDF68	Yolanda	Rojas	Estrada	2001-06-11	F	B-	5538367665	paciente2331@example.com
EUCH100912HHUYWQ55	Francisco	Pérez	Pérez	2010-09-12	M	A-	5542144835	\N
WUHT780707MNQGRWI5	Beatriz	Contreras	Medina	1978-07-07	F	A+	5543093535	\N
MNAZ541120HNRXSUJ4	Eduardo	González	Ortiz	1954-11-20	M	AB-	5557561080	paciente2334@example.com
DWEG090819HSKLDFG6	Juan	Vázquez	Flores	2009-08-19	M	\N	5532854142	paciente2335@example.com
XEDJ590103MIKGPDV0	Leticia	Jiménez	Romero	1959-01-03	F	B+	5596787788	paciente2336@example.com
GFNR160923HJFGFWZ3	Hugo	Sánchez	Estrada	2016-09-23	M	B-	5546903369	paciente2337@example.com
HFGW841201HRDLJKV2	Juan	Ramos	Cabrera	1984-12-01	M	AB-	5587626023	paciente2338@example.com
YTRN701102MQTCTXX0	María	Delgado	Peña	1970-11-02	F	AB-	5567969999	\N
USJR460303XVOIMDL3	Francisco	Cabrera	Sánchez	1946-03-03	Intersex	O-	5500241551	paciente2340@example.com
KGGF061031MPBEQYZ6	Rosa	Castillo	Vargas	2006-10-31	F	AB+	5585843116	\N
WTIO980527HGZTMXX4	Juan	Castillo	Pérez	1998-05-27	M	A-	\N	paciente2342@example.com
BVYE640914MOKSNB98	Paola	González	Vázquez	1964-09-14	F	B-	5597935843	\N
KFXD560925HFLWRNC6	Francisco	Rodríguez	Díaz	1956-09-25	M	A+	5509818040	paciente2344@example.com
ZJXD140808XJALZB95	Rosa	Peña	Chávez	2014-08-08	Intersex	O+	5534742963	paciente2345@example.com
OEKW980715MIWHWSL4	Ana	Gómez	Romero	1998-07-15	F	B-	5560424081	paciente2346@example.com
SWWX420521XZMQUKL7	Alejandra	Díaz	Reyes	1942-05-21	Intersex	AB+	5520918812	\N
YRBT551027MZPAFA39	Fernanda	Sánchez	Flores	1955-10-27	F	O+	5535159117	paciente2348@example.com
LGHP650726HTPARMD4	Antonio	Sánchez	Ramírez	1965-07-26	M	A-	5575872537	\N
AAGF050511HKMSZNR7	Juan	Sánchez	Reyes	2005-05-11	M	B+	5513311519	paciente2350@example.com
ENUN110729HGCLJGB9	Andrés	Ortiz	Gutiérrez	2011-07-29	M	O+	5549131565	\N
JNWG891008XKCXJKK2	Gerardo	Alvarado	Vázquez	1989-10-08	Intersex	\N	5523253485	paciente2352@example.com
WITN060929XLOOKRP3	Mónica	Vargas	Cabrera	2006-09-29	Intersex	B-	5597064064	\N
EJIO220125HQGAOKA1	Adrián	Cordero	Díaz	2022-01-25	M	AB+	5570349141	paciente2354@example.com
MGNJ690508XFOEXCL6	Iván	Ramírez	Estrada	1969-05-08	Intersex	B+	5543676879	paciente2355@example.com
FMTQ481226MNWGAZF3	Lucía	Gutiérrez	Solís	1948-12-26	F	A-	5579882170	\N
CJTJ910320MTDRLDT7	Lucía	Guzmán	Cabrera	1991-03-20	F	B-	5516038495	paciente2357@example.com
FFQO460924HSKWMCT1	Roberto	Martínez	Medina	1946-09-24	M	O+	5566159293	\N
KZBN800617MSAGBWO4	Karla	Herrera	Salazar	1980-06-17	F	AB-	5511202730	paciente2359@example.com
LUSK520809XWDWVEJ0	Alejandro	Jiménez	Solís	1952-08-09	Intersex	AB-	5530335823	\N
HUYT391108XSPYXPP8	Gabriela	Ruiz	Sánchez	1939-11-08	Intersex	AB-	5578767823	paciente2361@example.com
MZYN560816XKDJIVQ8	Verónica	Ortiz	Delgado	1956-08-16	Intersex	AB+	5543062068	\N
UDSQ700814XWOEBF61	Daniela	Salazar	Cabrera	1970-08-14	Intersex	O-	5508433914	paciente2363@example.com
UOSN621114XHGAUKA7	Paola	Salazar	González	1962-11-14	Intersex	B+	5550443271	paciente2364@example.com
AEWQ390310XIUIYD01	Ricardo	Cabrera	Cordero	1939-03-10	Intersex	AB+	5562408851	paciente2365@example.com
DGPA800507XXKPWVS1	Sofía	Alvarado	Reyes	1980-05-07	Intersex	O+	5562265941	paciente2366@example.com
ZNHK180326HPQCZD04	Eduardo	Fuentes	Ruiz	2018-03-26	M	B+	5568471329	\N
DKQY670711HVKVDD95	Gerardo	Hernández	Estrada	1967-07-11	M	\N	\N	\N
YXLH080728HKUZSM62	Carlos	Ortiz	Ramírez	2008-07-28	M	\N	5514081235	paciente2369@example.com
EODM210503HRSFOQ98	Roberto	Rojas	Castillo	2021-05-03	M	B+	5587181938	\N
CAUY380413MXWIPHA8	Lucía	Vargas	Ruiz	1938-04-13	F	O+	5582131148	\N
HAIY590714XJJMSO89	Leticia	Pérez	Gutiérrez	1959-07-14	Intersex	B+	5559634900	paciente2372@example.com
HILA050615XBIDTLF1	Mario	Romero	Estrada	2005-06-15	Intersex	A-	5530766170	paciente2373@example.com
NJZW490118HRVEZUB9	Roberto	Castillo	Díaz	1949-01-18	M	\N	5584818186	paciente2374@example.com
IBKL450414XOEJPY32	Alejandro	Jiménez	Torres	1945-04-14	Intersex	O-	5596362091	paciente2375@example.com
DPXW400426XFGCTAE7	Javier	Delgado	Ortiz	1940-04-26	Intersex	O+	5566863721	paciente2376@example.com
IXXY790830MUBZZJ40	Carmen	Salazar	Ruiz	1979-08-30	F	B-	5512656564	\N
KOYZ170315MDCDEB50	Alejandra	Castillo	Contreras	2017-03-15	F	O-	5505893596	paciente2378@example.com
LXKE090516XLONCLB3	Lucía	Gómez	Romero	2009-05-16	Intersex	A-	5598480861	paciente2379@example.com
AIGI580415XEFSTV58	Silvia	Solís	Morales	1958-04-15	Intersex	B-	5510133989	paciente2380@example.com
PNLR030722HJXVSVB1	Daniel	García	Hernández	2003-07-22	M	B+	\N	paciente2381@example.com
RPBV850510MXZTBTU9	Diana	García	Ruiz	1985-05-10	F	O+	5579904636	paciente2382@example.com
YGYQ790601HNIQYRM6	Gerardo	Estrada	Sánchez	1979-06-01	M	A+	5561636771	paciente2383@example.com
VSWJ610707XVZFWMG5	Adrián	Chávez	Romero	1961-07-07	Intersex	B+	5597881412	\N
LBZR220723HZPKKBU6	Pablo	Vargas	Guzmán	2022-07-23	M	A+	5581888678	paciente2385@example.com
SGQO150811XBOIWCT2	Rodrigo	Martínez	Cabrera	2015-08-11	Intersex	O+	5549843828	paciente2386@example.com
FJPR900917HNVXGZW7	Adrián	Gutiérrez	\N	1990-09-17	M	A+	5527330890	\N
JZHY801117MFCXBTU4	Beatriz	Ortiz	Cordero	1980-11-17	F	AB+	5517730790	paciente2388@example.com
ZQZI670331HMONCOB9	Iván	Cabrera	Solís	1967-03-31	M	B-	5503562576	\N
ALOY780627HSWKLAB0	Rodrigo	Solís	Cruz	1978-06-27	M	B+	5515663057	paciente2390@example.com
FDOK231015MRSFRGB5	Sofía	Alvarado	Gómez	2023-10-15	F	A-	5513760720	paciente2391@example.com
YEHU080525HOPLNP49	Miguel	Díaz	Estrada	2008-05-25	M	B+	5568532414	paciente2392@example.com
RXBP800220HOLPUJ15	Fernando	Cordero	Estrada	1980-02-20	M	\N	5578564519	\N
VEUT770616HVRLCMW2	Sergio	Cabrera	Aguilar	1977-06-16	M	A+	5573511877	paciente2394@example.com
PVPO750708HJONYG21	Alejandro	Solís	Ortiz	1975-07-08	M	O+	5588727796	paciente2395@example.com
MOVW650822MZJXFAV0	Lucía	Fuentes	Herrera	1965-08-22	F	B-	5546221634	paciente2396@example.com
DLHC560627MECJCVO8	Ana	Fuentes	Chávez	1956-06-27	F	A+	5587908686	paciente2397@example.com
BZZD530408HPAZYXW9	Adrián	Solís	Romero	1953-04-08	M	A-	5570155226	paciente2398@example.com
EWVX950912XTLWPR23	Alejandro	Torres	Mendoza	1995-09-12	Intersex	B-	5583202271	\N
XITQ180511XBBXYRQ7	Jorge	Medina	Cruz	2018-05-11	Intersex	B-	5555773432	paciente2400@example.com
WCRZ660423HUHNMSQ9	Mario	Estrada	Ramírez	1966-04-23	M	\N	5598084698	paciente2401@example.com
KQIY450830MKNEPDM7	Claudia	Ramírez	Contreras	1945-08-30	F	O+	5544698459	paciente2402@example.com
ASJO891202XQGBNE14	Rosa	Martínez	Aguilar	1989-12-02	Intersex	AB+	5558899872	paciente2403@example.com
EXQV180516MIZEVBL7	Beatriz	Gutiérrez	Reyes	2018-05-16	F	B+	5590981122	\N
VQLC671101HGMQIBU4	Ricardo	Cordero	Ramírez	1967-11-01	M	O-	5552370087	paciente2405@example.com
FFXN070416MAPHJY38	Ana	Peña	López	2007-04-16	F	B+	5567484643	\N
VZLZ761112HIHOWN43	Emilio	Vázquez	Jiménez	1976-11-12	M	O+	5585821964	paciente2407@example.com
GCEV010521XVCELL68	Gabriela	Romero	Ramírez	2001-05-21	Intersex	\N	5592307814	\N
BOPT440922MWVXXUL4	Karla	Martínez	Vargas	1944-09-22	F	B+	5554759711	\N
DVBE061026HJFMZJU9	Eduardo	Romero	Rojas	2006-10-26	M	AB+	5594684583	paciente2410@example.com
LRVL481111HQWPEMM2	Pablo	Cabrera	\N	1948-11-11	M	AB-	5527192642	\N
FQRA520913HPHNNXT9	Jorge	Reyes	Vargas	1952-09-13	M	AB-	\N	paciente2412@example.com
VUDS591123MMVUIHP5	Silvia	Peña	\N	1959-11-23	F	AB+	5595021118	paciente2413@example.com
EFEB470704XLHEXFC8	Luis	García	\N	1947-07-04	Intersex	A-	5556089804	paciente2414@example.com
CJPR480307HFIZOLG1	Diego	Vargas	García	1948-03-07	M	AB-	5506650688	paciente2415@example.com
OGDN090503XAHLBET5	Rodrigo	Contreras	López	2009-05-03	Intersex	O+	5532705241	paciente2416@example.com
KNJM590124MRNMOMQ6	Teresa	Torres	Solís	1959-01-24	F	O-	5584000013	paciente2417@example.com
XDAY811110MPHQZFM2	Mónica	Morales	Díaz	1981-11-10	F	A+	5583376223	paciente2418@example.com
PPML150205MORNNCC0	Alejandra	López	Díaz	2015-02-05	F	O+	\N	paciente2419@example.com
UXIP110222HTYHTGN4	Diego	Sánchez	Aguilar	2011-02-22	M	\N	5514026963	\N
UAQP210612MLPYKOV1	Miriam	Ruiz	Herrera	2021-06-12	F	A-	5538237084	\N
GURC651104MHQLWVT1	Elena	Solís	Rodríguez	1965-11-04	F	\N	5529326457	\N
BCBN660605MLGMBLS9	Yolanda	Vargas	Rojas	1966-06-05	F	AB-	\N	paciente2423@example.com
MFUU111005HPOKNYA6	Luis	Solís	\N	2011-10-05	M	O+	5586960956	paciente2424@example.com
CWAP140208HKQNJHX8	Luis	Salazar	Cabrera	2014-02-08	M	A-	\N	paciente2425@example.com
EQUS731110HNSDQVZ1	Francisco	Aguilar	Torres	1973-11-10	M	AB-	5568634549	paciente2426@example.com
YSYS530220MVEKYK73	Lucía	Flores	Romero	1953-02-20	F	O+	\N	paciente2427@example.com
OLMU560109MHIXJTG0	Elena	Hernández	Salazar	1956-01-09	F	\N	5534883192	paciente2428@example.com
ZGJB800502HPSVUZM2	Adrián	Vargas	Vargas	1980-05-02	M	\N	\N	paciente2429@example.com
VDDA850312MHJBFB53	Lucía	Guzmán	Rojas	1985-03-12	F	AB+	\N	paciente2430@example.com
CQIU700917MQAAZBB0	Beatriz	Torres	Solís	1970-09-17	F	O-	5502148904	paciente2431@example.com
FDLV740715HURXCSJ7	Luis	Reyes	Cordero	1974-07-15	M	AB-	5544376456	\N
DLWU451209XRXGGMV9	Araceli	Gutiérrez	Cabrera	1945-12-09	Intersex	AB-	5509148719	\N
QEXM051001XLNDSP89	Mónica	García	Jiménez	2005-10-01	Intersex	AB+	5512666991	paciente2434@example.com
OVAV471002XQZUNWY5	Beatriz	Cabrera	Contreras	1947-10-02	Intersex	AB-	5548659775	paciente2435@example.com
ABOK800403MBXNQEM3	Paola	Alvarado	Solís	1980-04-03	F	AB-	5539347412	paciente2436@example.com
OHUR210120XLIMAXX2	Ana	Castillo	Vargas	2021-01-20	Intersex	O-	5532133058	paciente2437@example.com
QAFW800303XYVFSVW5	Verónica	Delgado	Solís	1980-03-03	Intersex	AB-	5530888370	paciente2438@example.com
XANE550606XGVVUCW4	Adriana	González	Estrada	1955-06-06	Intersex	A-	5549197470	paciente2439@example.com
OYYF620824MJTQUKY3	Elena	Castillo	Sánchez	1962-08-24	F	B+	5550941626	paciente2440@example.com
RVPB110111HCWHEDX6	Alejandro	García	Aguilar	2011-01-11	M	AB+	5519187171	\N
WBPZ110702MCQTRVB2	Miriam	Peña	Estrada	2011-07-02	F	A+	\N	\N
GJMD220808XUCPHJF7	Adriana	Cordero	Chávez	2022-08-08	Intersex	B+	5546554512	paciente2443@example.com
ZYJX880703HTCLUNZ3	Adrián	Ramos	González	1988-07-03	M	O+	5563386486	paciente2444@example.com
ZKUA090824HCSCNLO6	Sergio	Ortiz	Chávez	2009-08-24	M	B+	5566967781	paciente2445@example.com
IIRN120422HIYSCVU3	Alejandro	González	Ramos	2012-04-22	M	B-	5590435184	\N
XMLD680804MYGEOCD0	Claudia	Estrada	Torres	1968-08-04	F	B+	5591264384	paciente2447@example.com
FUAL531122XBTDMGP9	Juan	Peña	Cabrera	1953-11-22	Intersex	A+	5562593286	paciente2448@example.com
WJSX100804XDEQYXN0	Cecilia	Sánchez	Estrada	2010-08-04	Intersex	O+	5538183924	paciente2449@example.com
DVWS891108MNAPTZF1	Paola	Cabrera	Vargas	1989-11-08	F	AB-	5523359133	paciente2450@example.com
WYRO100915HXEWJLB4	Mario	Mendoza	Alvarado	2010-09-15	M	O+	5514771682	paciente2451@example.com
JJMR140315XFDMGMI9	Patricia	Gómez	Cordero	2014-03-15	Intersex	AB-	\N	paciente2452@example.com
OHEW680304XFGEEIK6	Daniel	Cordero	Solís	1968-03-04	Intersex	A-	5583681254	\N
PLTA000810MIIOJWF7	Patricia	Herrera	Fuentes	2000-08-10	F	AB+	5544105794	paciente2454@example.com
FSHU060411HEIJIV83	Roberto	Chávez	Ruiz	2006-04-11	M	B+	5519955089	paciente2455@example.com
DXKV550521MOANNFW0	Carmen	Torres	Fuentes	1955-05-21	F	O-	5522043771	\N
SEND030413MLFQYVP0	Elena	Guzmán	Herrera	2003-04-13	F	B-	5582080820	paciente2457@example.com
FFBS450317XELFUDA9	Ana	García	Medina	1945-03-17	Intersex	B+	5535479130	paciente2458@example.com
FKCA240923MAZVFF49	Yolanda	Delgado	Delgado	2024-09-23	F	\N	5525799883	paciente2459@example.com
ZBHF870120XFJBRA37	Karla	Torres	Flores	1987-01-20	Intersex	O+	\N	paciente2460@example.com
MRKE210428XJMAQQ99	Francisco	Rojas	Ruiz	2021-04-28	Intersex	B-	5520851512	\N
SSTW390412XOWJSIH1	Emilio	Aguilar	Martínez	1939-04-12	Intersex	AB-	5590364873	paciente2462@example.com
DEKT580107XSNQIQN4	Iván	Peña	Martínez	1958-01-07	Intersex	A-	5597867154	paciente2463@example.com
YKVT631105XTYKZPF9	Carmen	Gómez	Cabrera	1963-11-05	Intersex	B+	5570071910	\N
EDUP691001HFGIAKF5	Antonio	Castillo	Ruiz	1969-10-01	M	B-	5586631438	paciente2465@example.com
DDWQ480927MYQTZKQ9	Laura	González	Cruz	1948-09-27	F	O-	5565951733	paciente2466@example.com
CGZO050923MIAYXAF9	Daniela	Gutiérrez	Díaz	2005-09-23	F	\N	\N	\N
IIHF090626HMLYISU1	José	Romero	Flores	2009-06-26	M	\N	5581978551	paciente2468@example.com
SRZB891015XUGILTQ8	Antonio	Ruiz	Reyes	1989-10-15	Intersex	A-	\N	paciente2469@example.com
CBAN461206XSKMTRF9	Javier	Hernández	Estrada	1946-12-06	Intersex	\N	5533167926	paciente2470@example.com
AKSS940810MSAUNIB8	María	Reyes	Vargas	1994-08-10	F	O-	\N	paciente2471@example.com
DAZZ920802HKTFARY5	Daniel	Rodríguez	Aguilar	1992-08-02	M	A-	5549455839	\N
SHIO021006XQDZEY08	Rodrigo	Alvarado	Ramos	2002-10-06	Intersex	\N	5510786320	\N
UYQD810924MOXNEHL5	Guadalupe	Solís	Martínez	1981-09-24	F	B-	5581191277	paciente2474@example.com
IJEI800816MMONZWB0	Yolanda	Rodríguez	Vargas	1980-08-16	F	B+	5525976571	\N
VZLC741006MTMCISB1	Gabriela	Ruiz	Vargas	1974-10-06	F	B+	\N	paciente2476@example.com
SNFU971024HXLEDNW3	Ricardo	Gutiérrez	Gutiérrez	1997-10-24	M	\N	5597390766	paciente2477@example.com
FAHD990118MYKPSS50	Sofía	Cruz	Cordero	1999-01-18	F	AB+	5558112450	paciente2478@example.com
VZTN211130MXQBDSI2	Elena	Jiménez	Chávez	2021-11-30	F	AB-	5566239352	paciente2479@example.com
NKKQ100308HCGEZNG3	Luis	Contreras	Vargas	2010-03-08	M	B-	5542701823	\N
KVHB101103HIXMPXT0	Óscar	Solís	Hernández	2010-11-03	M	AB-	\N	paciente2481@example.com
CKMJ570716XWQHKNL8	Cecilia	Mendoza	Sánchez	1957-07-16	Intersex	AB-	5518483364	paciente2482@example.com
ILQO880705HYCMMGN0	Eduardo	Cruz	Delgado	1988-07-05	M	A-	5521688070	\N
PIZV950729HCEZYLG2	Diego	Pérez	Ramos	1995-07-29	M	O-	5533401791	paciente2484@example.com
NXMS450526MYWMELM6	Mónica	Ramos	Guzmán	1945-05-26	F	AB-	5517120345	paciente2485@example.com
MLZT950302MXFGABI2	Miriam	Díaz	Vargas	1995-03-02	F	B+	5523716643	paciente2486@example.com
CZTT430720XTOUXFE1	Rosa	Morales	Ruiz	1943-07-20	Intersex	O-	5592709930	paciente2487@example.com
WWZD681028MXYCPYP1	Daniela	Solís	Hernández	1968-10-28	F	O+	\N	paciente2488@example.com
KFUB520209HJSKMN86	José	Torres	Hernández	1952-02-09	M	B-	\N	\N
EOYW090612XYQHSFA2	Iván	Vázquez	Solís	2009-06-12	Intersex	B-	5524488807	paciente2490@example.com
MKJG540622MSLTFRG4	Teresa	Alvarado	Guzmán	1954-06-22	F	AB+	5512453474	paciente2491@example.com
XQIV220906XZORVD92	Carmen	González	Castillo	2022-09-06	Intersex	A+	5544944748	paciente2492@example.com
KCWI980918MFDULOI9	Carmen	Castillo	Gutiérrez	1998-09-18	F	O-	5560713391	\N
MDYE660331XGXTLKQ5	Alejandro	Vargas	Ortiz	1966-03-31	Intersex	A+	5591372067	paciente2494@example.com
AHTT750509XXGIMRZ2	Fernando	Hernández	Contreras	1975-05-09	Intersex	O+	5553919193	paciente2495@example.com
XGXK500430HAOHTQT8	Arturo	Cabrera	Medina	1950-04-30	M	B-	5550681511	\N
FCPW890324HYMFVOL4	Sergio	Medina	Solís	1989-03-24	M	A-	5514456514	paciente2497@example.com
IMXG990306MHRIKKS5	Alejandra	Vázquez	González	1999-03-06	F	O+	\N	paciente2498@example.com
QJRD670909HGCEBLP0	Luis	Peña	Herrera	1967-09-09	M	\N	5593092220	\N
ZSOB890305MZVMQG92	Araceli	González	Alvarado	1989-03-05	F	\N	5567400097	paciente2500@example.com
LVTL090211MSAXDEF3	Miriam	Ortiz	Romero	2009-02-11	F	B-	5530125343	paciente2501@example.com
NPUK200320MNJJAGF4	Fernanda	Alvarado	Contreras	2020-03-20	F	\N	5511945720	paciente2502@example.com
MZXX160910MUYYRKW5	Sofía	Chávez	Flores	2016-09-10	F	O+	5594505836	\N
GSEZ740103HXRURX06	Miguel	Salazar	Delgado	1974-01-03	M	\N	5501065285	\N
VGXN100125MDIYDNO7	Diana	Morales	\N	2010-01-25	F	O+	5527420050	\N
THTO740804XPXRQCD4	Daniel	García	Vargas	1974-08-04	Intersex	\N	5515905424	paciente2506@example.com
YJPD160504MIAVQY77	Rosa	Ortiz	Gutiérrez	2016-05-04	F	AB-	5551569922	paciente2507@example.com
UCMR220913XQJVAJ46	Roberto	Contreras	Delgado	2022-09-13	Intersex	A-	5599479141	paciente2508@example.com
EOMP980824XOIDNKP7	Lucía	Cabrera	Medina	1998-08-24	Intersex	B+	5567856371	paciente2509@example.com
MZQL170408HSZLEJE7	Roberto	González	Sánchez	2017-04-08	M	O-	5574782563	\N
CAFV140928XZRQGWH4	Fernando	Gómez	García	2014-09-28	Intersex	O-	5501120174	paciente2511@example.com
NDSZ740921XIEGYQD2	Verónica	Pérez	Guzmán	1974-09-21	Intersex	O-	5558247080	paciente2512@example.com
LOIX550307HGNWJFV4	Daniel	Gómez	Cordero	1955-03-07	M	A+	5570269154	paciente2513@example.com
YWFS820503MOEEZYP1	Teresa	Solís	García	1982-05-03	F	\N	5508633445	\N
UAWG450728MQXKMW60	Sofía	López	Cabrera	1945-07-28	F	A+	5540278362	paciente2515@example.com
VVJZ151224XOTBIJ35	Araceli	Díaz	Ortiz	2015-12-24	Intersex	O-	5579260608	paciente2516@example.com
VUFT240702HPRANU48	Antonio	Herrera	Martínez	2024-07-02	M	A+	5565530922	\N
TAGZ891219HKRGYFJ3	Carlos	Ramírez	Rodríguez	1989-12-19	M	A+	5534424160	paciente2518@example.com
RSUT571014XIRVFVK3	Laura	Cordero	Torres	1957-10-14	Intersex	A-	5584661999	paciente2519@example.com
EDHU080131HHOYWKL1	Arturo	Rodríguez	Castillo	2008-01-31	M	B+	5554472270	paciente2520@example.com
PZIY700412MIFFVK23	Rosa	Peña	Solís	1970-04-12	F	O+	5548508374	paciente2521@example.com
VAUZ891102HRHAUO53	Rodrigo	Hernández	Hernández	1989-11-02	M	AB+	5567585987	paciente2522@example.com
HKHQ050609HGPYSBL3	Rodrigo	Chávez	Jiménez	2005-06-09	M	\N	5594056947	paciente2523@example.com
EXVB141228HOTUMER8	Andrés	Flores	Herrera	2014-12-28	M	O+	5595224275	paciente2524@example.com
BCPX120303MWACDOU5	Miriam	Reyes	Vargas	2012-03-03	F	B-	5577473510	paciente2525@example.com
TZTZ630908MQSBZW51	Miriam	Gutiérrez	Torres	1963-09-08	F	AB+	5578803024	paciente2526@example.com
ARGH371221XJDRPZH5	Beatriz	Ramírez	García	1937-12-21	Intersex	B-	5503930380	\N
XHDE860304MWSLZWB4	Mónica	Vázquez	Reyes	1986-03-04	F	\N	5581987599	paciente2528@example.com
PQBT470405HSEQHZ86	Iván	Gómez	Ramírez	1947-04-05	M	A-	5510620467	paciente2529@example.com
MSCS200113HYIRMPC7	Adrián	López	Fuentes	2020-01-13	M	AB+	5586444911	paciente2530@example.com
YFKK860326HOHAXD60	Juan	Rodríguez	Flores	1986-03-26	M	\N	5558423022	paciente2531@example.com
DVLF110718MPYXVEP1	Carmen	Gómez	Mendoza	2011-07-18	F	O-	5534166382	paciente2532@example.com
OOOD131128MUSQWI00	Beatriz	Mendoza	Vargas	2013-11-28	F	B-	5546574096	paciente2533@example.com
UTQP550824HDNWJYZ2	Alejandro	Cordero	Alvarado	1955-08-24	M	A+	5577360539	\N
BPWP230824XRHDQF03	Araceli	González	García	2023-08-24	Intersex	AB-	5519870322	paciente2535@example.com
VEFP690901XIUJLIW4	Ana	Pérez	Jiménez	1969-09-01	Intersex	B+	5527879244	paciente2536@example.com
JANM841111XRMOSYQ2	Rosa	Contreras	González	1984-11-11	Intersex	O+	5561376982	\N
GARP481114MQYPSAE2	Ana	Salazar	Estrada	1948-11-14	F	\N	5521263581	paciente2538@example.com
FWKY100513MXDTGGU6	Ana	López	Aguilar	2010-05-13	F	A+	5584437282	paciente2539@example.com
FLWE471217XBBIHFC9	Arturo	Martínez	Rodríguez	1947-12-17	Intersex	O-	5581247966	paciente2540@example.com
DPFT380731XXIBTTN7	Adrián	Medina	Morales	1938-07-31	Intersex	B-	\N	paciente2541@example.com
UDWT590822XXMPSTG8	Patricia	Torres	Gutiérrez	1959-08-22	Intersex	B+	5519208496	paciente2542@example.com
LMRJ220322XYVLUZN4	Hugo	Pérez	Torres	2022-03-22	Intersex	O+	5510752879	paciente2543@example.com
EFKT210629HHWZDVK2	Miguel	Ramos	Chávez	2021-06-29	M	AB-	5544955030	paciente2544@example.com
OEHT830817MMOVPQM9	Elena	Ramírez	Alvarado	1983-08-17	F	O+	5551638066	\N
SBOG630606MOXEFTH7	Teresa	Gutiérrez	\N	1963-06-06	F	AB+	5503614544	\N
MKAV930403XKXQIRT1	Eduardo	Estrada	Peña	1993-04-03	Intersex	B+	5528356022	paciente2547@example.com
JQUM560513HGNTHRC5	Eduardo	González	Rojas	1956-05-13	M	\N	5507043517	paciente2548@example.com
BRVI461013HKMGUCQ7	Luis	Vargas	González	1946-10-13	M	AB+	5526508899	paciente2549@example.com
TVPR721007MQCNWN60	Rosa	Chávez	Guzmán	1972-10-07	F	AB+	5519888744	paciente2550@example.com
QYKJ850218HKOJPV30	Pablo	Gómez	Solís	1985-02-18	M	AB+	\N	paciente2551@example.com
GJRZ650823MLNJYXO2	Diana	Ramos	Medina	1965-08-23	F	AB-	5541156527	paciente2552@example.com
MMYT110321HSRCRBX2	Adrián	Cordero	Aguilar	2011-03-21	M	AB-	5592008546	\N
MVMU220326HJSYGFP7	Fernando	Díaz	Romero	2022-03-26	M	B-	5583883331	\N
KSVF791116HQZUFXA6	Óscar	Cruz	Ortiz	1979-11-16	M	AB+	5534797109	\N
AGFX220320HNMNCO90	Diego	Fuentes	García	2022-03-20	M	\N	5564499162	paciente2556@example.com
XTYJ480405XYFLBYF2	Guadalupe	Romero	Cruz	1948-04-05	Intersex	A+	5591535375	paciente2557@example.com
MXMD480313HMFJETM3	Raúl	González	Contreras	1948-03-13	M	\N	\N	paciente2558@example.com
OOYJ150515HJMARHS8	Gerardo	Guzmán	López	2015-05-15	M	AB+	5517507831	paciente2559@example.com
TPMF010409HDPJCUB3	Antonio	Sánchez	Jiménez	2001-04-09	M	AB-	5541648668	paciente2560@example.com
GUEO650410XQMBFZ74	Eduardo	Morales	Contreras	1965-04-10	Intersex	AB+	5555501219	paciente2561@example.com
SLEK610808XGKSLHA1	Lucía	Pérez	Delgado	1961-08-08	Intersex	AB+	5597059445	paciente2562@example.com
CAEB560808XUYGQR40	Claudia	Rodríguez	Cruz	1956-08-08	Intersex	AB-	\N	paciente2563@example.com
EDZA191003XBJNRP45	Diego	Martínez	Ramírez	2019-10-03	Intersex	A+	\N	paciente2564@example.com
LVKW100104XNWQMEL2	Daniel	Salazar	Gutiérrez	2010-01-04	Intersex	O+	5554417105	paciente2565@example.com
GWZU700210MNYSBOA6	Paola	Vázquez	Cruz	1970-02-10	F	B+	5572358389	paciente2566@example.com
EBJO680916XPABJQM0	Leticia	Ramos	Mendoza	1968-09-16	Intersex	AB-	5573255382	paciente2567@example.com
MYZF630325XEKBNZN4	Andrés	Vázquez	Cruz	1963-03-25	Intersex	\N	5532301464	paciente2568@example.com
TKXJ540705MCRKWFD3	Beatriz	Martínez	Hernández	1954-07-05	F	AB-	5501044330	paciente2569@example.com
ZHIB730113HVSNWAD8	Daniel	Fuentes	Delgado	1973-01-13	M	AB-	5568486558	paciente2570@example.com
MQLO860412HKLWNYS4	Jorge	Ruiz	Contreras	1986-04-12	M	A+	5577501932	paciente2571@example.com
IEFY710112HFCNMBW2	Iván	Romero	Gutiérrez	1971-01-12	M	A-	5514987142	paciente2572@example.com
POTH460907XDFIBJP8	Araceli	Jiménez	Contreras	1946-09-07	Intersex	AB+	5536231755	\N
OUNG370727XBYWNK85	Adrián	Morales	Guzmán	1937-07-27	Intersex	\N	5565469915	paciente2574@example.com
HWPY680419XQKQDIT2	Claudia	Rojas	Martínez	1968-04-19	Intersex	\N	5536876190	paciente2575@example.com
YLLZ400919HDBPJZ81	Ricardo	Castillo	Ruiz	1940-09-19	M	\N	5596115889	\N
OACX720725MFNQGUH5	Ana	Medina	Ramírez	1972-07-25	F	AB+	5542060511	paciente2577@example.com
HKYE011126MMRZEXE9	Daniela	Peña	\N	2001-11-26	F	B+	5519023271	\N
TEDF921213XHZBZGT8	María	Reyes	Vargas	1992-12-13	Intersex	O+	5543172104	paciente2579@example.com
MYXO630831MAUCSR58	Claudia	González	Herrera	1963-08-31	F	A-	5554459318	\N
SSPG250602HIDHLUB5	Miguel	Ruiz	Vargas	2025-06-02	M	B+	5576471862	paciente2581@example.com
CJKH080927MYTJRUA7	Claudia	Romero	Sánchez	2008-09-27	F	A+	5578458458	paciente2582@example.com
MVAE371113HDRBNY17	Miguel	Flores	Guzmán	1937-11-13	M	A+	5579344451	paciente2583@example.com
ECXA680405XYRGANN4	Luis	Castillo	Gutiérrez	1968-04-05	Intersex	B+	5571084257	paciente2584@example.com
HKGW370705MISOEJ76	Mónica	Gómez	Contreras	1937-07-05	F	\N	5583225350	\N
SAGH680507HQIPDH40	Sergio	Vargas	Castillo	1968-05-07	M	B-	5577522212	paciente2586@example.com
GVIE120402HBGHVR43	Juan	Gutiérrez	\N	2012-04-02	M	\N	5535002156	\N
YGNK680429HQMXTJE9	Roberto	Aguilar	Díaz	1968-04-29	M	AB-	5551344553	paciente2588@example.com
KSJE490303XRGCQU88	Gerardo	Rojas	Rojas	1949-03-03	Intersex	AB+	5566334280	paciente2589@example.com
FJTZ791205HOOAYLQ9	Ricardo	Torres	Aguilar	1979-12-05	M	O-	\N	paciente2590@example.com
UIPM920607XLDFNPR9	Arturo	López	Alvarado	1992-06-07	Intersex	O+	5535138345	paciente2591@example.com
NKDK960724XWREEWN0	Fernando	Jiménez	Estrada	1996-07-24	Intersex	B+	5505967656	\N
JIDJ560429MMPZSMN8	Silvia	Salazar	Jiménez	1956-04-29	F	A+	5529149373	paciente2593@example.com
HCYX411129XCWMWV66	Sofía	Flores	Herrera	1941-11-29	Intersex	AB-	5547868732	\N
IIDV700516HREMYT51	Javier	Pérez	Castillo	1970-05-16	M	\N	5570153987	\N
ZYSS730609HJWWTRU1	Eduardo	Díaz	González	1973-06-09	M	O-	5542614227	paciente2596@example.com
VKZQ780928MSUYGU30	Sofía	Pérez	Flores	1978-09-28	F	\N	5535743189	paciente2597@example.com
FIMB420529HYDERUW4	José	Gutiérrez	Delgado	1942-05-29	M	AB-	5563150810	paciente2598@example.com
SLVO590804MTAGKIC6	Karla	Hernández	Ramírez	1959-08-04	F	B+	5582359848	paciente2599@example.com
ZNJY610426MQWJCFF2	Fernanda	Peña	Fuentes	1961-04-26	F	A-	5560593706	\N
ZGMC611110HDHQZR40	Antonio	Ramos	Díaz	1961-11-10	M	B-	5562984754	paciente2601@example.com
DIMS881015HTIQHZ65	Rodrigo	Hernández	Torres	1988-10-15	M	AB+	5516685867	paciente2602@example.com
TOYK980316MZGTGBO6	Rosa	Estrada	Ramírez	1998-03-16	F	O-	5599326038	paciente2603@example.com
XOUZ920610XJEXGM83	Elena	Castillo	Solís	1992-06-10	Intersex	AB-	5503717186	paciente2604@example.com
DWEB550702XINKJKY5	Juan	Contreras	Castillo	1955-07-02	Intersex	AB+	5563638139	\N
BJYF480628XDBHPT92	Lucía	Ramírez	Vázquez	1948-06-28	Intersex	O+	5587937012	\N
XGXP521126MUPWXLA1	Beatriz	Vargas	Cabrera	1952-11-26	F	A+	5599292013	\N
IWAV460731HRKBXPS9	Rodrigo	Ortiz	Guzmán	1946-07-31	M	O-	5513928236	paciente2608@example.com
NRHC560517XHRAWAN3	Andrés	Peña	Cruz	1956-05-17	Intersex	\N	5536736140	\N
NCVX460102XKRDQDE0	Emilio	González	Mendoza	1946-01-02	Intersex	AB+	5599429223	\N
VQSG610912XUUEBCC8	Guadalupe	Medina	Ramos	1961-09-12	Intersex	\N	5507232274	paciente2611@example.com
YJID690904MAQRGJR4	Rosa	Reyes	Pérez	1969-09-04	F	A+	5574249417	paciente2612@example.com
GSEQ111022XVUGCBE5	Arturo	Guzmán	López	2011-10-22	Intersex	AB-	5591043979	paciente2613@example.com
VXEJ230319HELBKTY3	Adrián	Reyes	Pérez	2023-03-19	M	O-	\N	paciente2614@example.com
ROZZ401117HOZNVR01	Fernando	Salazar	González	1940-11-17	M	AB-	5587296204	\N
CBCW690512XJCBXA72	Guadalupe	Mendoza	Fuentes	1969-05-12	Intersex	B-	5523065117	paciente2616@example.com
EZQQ460213HABJTNB5	Diego	Chávez	Chávez	1946-02-13	M	B+	5505084951	paciente2617@example.com
JPGA570801HQORROV2	Adrián	Torres	Hernández	1957-08-01	M	AB+	5528441333	paciente2618@example.com
GPXP200522XAAEHGU8	Carlos	Gómez	González	2020-05-22	Intersex	A+	5506274157	paciente2619@example.com
BIDM900620XDJHKIO4	Beatriz	Herrera	Medina	1990-06-20	Intersex	O-	5589245574	paciente2620@example.com
IAGB200903XVVWKRF8	Daniel	Jiménez	Jiménez	2020-09-03	Intersex	O-	5585350629	\N
TITC530816XSUYIYP7	Fernanda	López	Estrada	1953-08-16	Intersex	A-	5512938655	paciente2622@example.com
URAL241111XGRWJY59	Hugo	Hernández	Ramírez	2024-11-11	Intersex	A+	5551324651	paciente2623@example.com
UFBD150729XXIBXO63	Rodrigo	Estrada	Alvarado	2015-07-29	Intersex	B+	\N	paciente2624@example.com
UBDX871215MARXZXO1	Carmen	González	Cordero	1987-12-15	F	AB-	5549963215	paciente2625@example.com
KGDP480402XKERMDL2	Silvia	Reyes	Contreras	1948-04-02	Intersex	B+	5500259375	paciente2626@example.com
FERP210909HXIAVQ55	Javier	Jiménez	Solís	2021-09-09	M	AB-	5584235180	paciente2627@example.com
JSER680906HWQJCMO4	Pablo	Alvarado	Sánchez	1968-09-06	M	B+	5592796939	paciente2628@example.com
ZLXU501004HOAZILM3	José	Ruiz	Pérez	1950-10-04	M	O+	5549481598	paciente2629@example.com
HHVP990815HGDIUAJ9	Iván	Aguilar	Ortiz	1999-08-15	M	O+	5500810391	\N
SORZ380429XNFCNGQ8	Andrés	García	Mendoza	1938-04-29	Intersex	B+	5543053447	paciente2631@example.com
EQUR751225MRDMCH31	María	Medina	Jiménez	1975-12-25	F	B-	5580732714	paciente2632@example.com
QNGY860924MUWYROL0	Alejandra	Ortiz	Gutiérrez	1986-09-24	F	A-	5523832270	paciente2633@example.com
FMLK230310MRKTFIX8	Adriana	Ramírez	Ortiz	2023-03-10	F	O+	5531081854	paciente2634@example.com
HVQQ030110XWFPHPR9	Juan	Chávez	Pérez	2003-01-10	Intersex	O+	5544718132	\N
NDHG381002HLIOGZP7	Fernando	Cruz	Ortiz	1938-10-02	M	O+	5555563481	paciente2636@example.com
DRBX660226HOISEEM9	Diego	Cordero	Contreras	1966-02-26	M	AB+	5528514190	paciente2637@example.com
LNLS010119HUYTELB7	Gerardo	Vargas	Vargas	2001-01-19	M	AB+	5537364353	paciente2638@example.com
BUBT801219HKQGZAQ2	Carlos	Ortiz	Hernández	1980-12-19	M	\N	5563231026	paciente2639@example.com
GMMP710816MHKEDMB8	Paola	Ortiz	Ortiz	1971-08-16	F	A-	5528974093	paciente2640@example.com
WMIP630925XZZTGLO9	Adriana	Vázquez	Peña	1963-09-25	Intersex	B-	5521542626	paciente2641@example.com
FNXP450927HBCGNCF6	Arturo	Fuentes	Cordero	1945-09-27	M	AB+	5522177594	paciente2642@example.com
YIKH230729MHOXZM39	Mónica	Rojas	Gómez	2023-07-29	F	O-	5527624396	paciente2643@example.com
OSQF370223HGWGUY99	Gerardo	Castillo	López	1937-02-23	M	O-	5573563921	\N
USQP910515MOHKXVH0	Elena	Rodríguez	Cruz	1991-05-15	F	B-	5597344685	paciente2645@example.com
IOYV650120HYSFSHZ1	Juan	Peña	Peña	1965-01-20	M	AB+	5529087929	paciente2646@example.com
XPON600114MHTMMHX2	Adriana	Cordero	Alvarado	1960-01-14	F	AB-	5500755040	paciente2647@example.com
QSBD550908MCOKEZ82	Laura	Morales	Jiménez	1955-09-08	F	O+	5579077988	paciente2648@example.com
CNNI620519HBFRUAI8	Adrián	Herrera	Romero	1962-05-19	M	O+	5524466165	\N
FMLP890109XBJGRZ73	Miriam	Mendoza	Castillo	1989-01-09	Intersex	A-	5523840991	\N
ISRL561230MOOJFON5	Araceli	Estrada	Castillo	1956-12-30	F	\N	5507054720	paciente2651@example.com
KZES640111HNOWTI41	Fernando	Díaz	Aguilar	1964-01-11	M	\N	5516680731	paciente2652@example.com
PMMV830625HBBFFAB3	José	Pérez	Cabrera	1983-06-25	M	AB+	5523822355	\N
KUWM380722HFUUDEB2	Andrés	Gutiérrez	Torres	1938-07-22	M	B-	5509411396	paciente2654@example.com
YMKN851105MWTRHNT9	Verónica	Ramos	Rodríguez	1985-11-05	F	B-	\N	paciente2655@example.com
PLVP530302HEBXVXM1	Fernando	Cruz	Peña	1953-03-02	M	B+	5506143288	paciente2656@example.com
VSAN711208XTSXXRH8	Claudia	Peña	López	1971-12-08	Intersex	A+	5571044907	\N
TBMW391210HRQOQK80	Antonio	Alvarado	Fuentes	1939-12-10	M	A-	5527790538	paciente2658@example.com
GXYI950227MFSOUBO9	Ana	Medina	Peña	1995-02-27	F	AB-	5573380041	\N
VUTJ600508HUJDZAQ2	Jorge	Cordero	Romero	1960-05-08	M	A-	5500865862	paciente2660@example.com
CTHJ780927XFCCJOS6	Roberto	Jiménez	Rojas	1978-09-27	Intersex	AB-	5573251415	paciente2661@example.com
HEDX000819HSOSEI46	Sergio	Morales	Gómez	2000-08-19	M	O-	5503530056	paciente2662@example.com
BMSP010604MZKIDHL6	Laura	Vargas	Vázquez	2001-06-04	F	A-	5501508922	paciente2663@example.com
HGOA570217HIVKZWC3	Juan	Delgado	González	1957-02-17	M	\N	5507294306	\N
LDTO740416MVVERXV5	Claudia	Díaz	Ramírez	1974-04-16	F	\N	5593160278	paciente2665@example.com
NYLX520809XMXDEQD6	Paola	Ortiz	Vargas	1952-08-09	Intersex	B-	5521109531	paciente2666@example.com
RVKT610527HOYDGIE1	Ricardo	Aguilar	Guzmán	1961-05-27	M	A+	5588104238	paciente2667@example.com
KWLJ891026MLBZQKU4	Cecilia	Gómez	Peña	1989-10-26	F	\N	5559806904	\N
SJTU731102XRJYIAZ0	María	Medina	Estrada	1973-11-02	Intersex	A+	5590959405	paciente2669@example.com
FAZY240130HPOPGB88	Carlos	Cabrera	Peña	2024-01-30	M	O-	5502933367	paciente2670@example.com
HRJD940112MWYEWOG3	Patricia	Cabrera	Ramírez	1994-01-12	F	A+	5532588840	paciente2671@example.com
DEVD130608HCXYKJR4	Fernando	Gómez	Gómez	2013-06-08	M	\N	5502461016	paciente2672@example.com
PPVS451121HXPHATV1	Mario	García	Reyes	1945-11-21	M	B+	5560737204	\N
ADFC980709XORKNWN4	Eduardo	Gutiérrez	\N	1998-07-09	Intersex	A-	5545501290	\N
NNOO770821HLMJMT63	Adrián	Flores	Alvarado	1977-08-21	M	AB+	5520948168	paciente2675@example.com
WQPB250802HCYJMD67	Luis	Delgado	Estrada	2025-08-02	M	O+	5527392467	paciente2676@example.com
FKYA000807HQZQXFP2	Luis	Gutiérrez	Aguilar	2000-08-07	M	B+	5596964773	paciente2677@example.com
WFTF610927HUCHHET0	Raúl	Flores	Delgado	1961-09-27	M	AB+	\N	paciente2678@example.com
SEOI900313XLALXW09	Sofía	Ortiz	Ruiz	1990-03-13	Intersex	B-	5526169134	paciente2679@example.com
YKRB110924XFKMFC24	Silvia	Herrera	González	2011-09-24	Intersex	AB-	5544042414	\N
MBIM190606XJHAXA22	Emilio	Chávez	Alvarado	2019-06-06	Intersex	B+	5566053139	paciente2681@example.com
ZXTZ910830XHPPXPL4	Fernando	Contreras	Aguilar	1991-08-30	Intersex	A+	5527841287	paciente2682@example.com
IWST110607HROOTSS8	Miguel	Medina	Rodríguez	2011-06-07	M	O-	5506812756	paciente2683@example.com
PGEK870729XZQMQI71	José	Ortiz	Salazar	1987-07-29	Intersex	O+	5524716569	\N
FAKI190701XDLZEQB7	Cecilia	Fuentes	Chávez	2019-07-01	Intersex	\N	5547701696	paciente2685@example.com
EPAM910815HLYHVRE3	Mario	Cruz	Morales	1991-08-15	M	AB-	5556235435	paciente2686@example.com
RZSZ930630HNHWRLX2	Jorge	Delgado	Gutiérrez	1993-06-30	M	B+	5505004510	paciente2687@example.com
QBSK751104XSFUIG61	Gerardo	Romero	\N	1975-11-04	Intersex	B-	5583225702	\N
RTVW110427MFQCIT69	Elena	Aguilar	López	2011-04-27	F	AB+	5569178154	paciente2689@example.com
YCKH590426XRHHMMT4	Karla	Morales	Pérez	1959-04-26	Intersex	A-	5543034267	paciente2690@example.com
CDYK600130MLMRUC00	Carmen	Ramos	Alvarado	1960-01-30	F	AB+	5505787660	paciente2691@example.com
TMDJ650131XXUPHA24	Miguel	Guzmán	Flores	1965-01-31	Intersex	\N	5527972730	\N
MLZZ980524XZEDPJX6	Yolanda	Peña	Delgado	1998-05-24	Intersex	B-	5588438684	paciente2693@example.com
QIDJ900804HLOSLL33	Iván	Salazar	\N	1990-08-04	M	\N	5556799728	\N
ZUHF370103MZPMGTF6	Ana	Morales	Ramírez	1937-01-03	F	B+	5573976876	paciente2695@example.com
PLHI650401MBSNDU25	Gabriela	Rojas	Pérez	1965-04-01	F	O-	\N	paciente2696@example.com
BEDB880925MSDMZF19	Claudia	Ortiz	Hernández	1988-09-25	F	AB+	5567278332	paciente2697@example.com
SNZQ191123HFJGNS61	Roberto	Vázquez	Morales	2019-11-23	M	A+	5506789726	paciente2698@example.com
WOZA601002MCFTRGQ5	Daniela	Delgado	Gutiérrez	1960-10-02	F	B+	\N	paciente2699@example.com
BANU940326MWVMLF95	Fernanda	Martínez	Rodríguez	1994-03-26	F	A-	\N	\N
ZKTF771031MEEEXBB6	Paola	Cordero	Castillo	1977-10-31	F	B-	5597741442	paciente2701@example.com
EAWM401205HXROFC50	Arturo	García	Ortiz	1940-12-05	M	B+	5566870817	paciente2702@example.com
EHBI151227HMWKQHZ5	Carlos	Pérez	Guzmán	2015-12-27	M	\N	\N	paciente2703@example.com
RVDH930816XNZNWFK2	Rosa	Rodríguez	Romero	1993-08-16	Intersex	O+	5510213050	paciente2704@example.com
RGJQ820328MRCWIMA8	Leticia	Reyes	Torres	1982-03-28	F	A+	5574079434	paciente2705@example.com
MCTM870325HFCHFHL9	Hugo	Contreras	Aguilar	1987-03-25	M	B-	\N	paciente2706@example.com
ZDMK130829XZQWAR32	María	Aguilar	Morales	2013-08-29	Intersex	AB+	5505119388	\N
UQCM950202XVPFTCP0	Carlos	Estrada	\N	1995-02-02	Intersex	B+	5501859052	paciente2708@example.com
NPFF940329HIDFQMV0	Luis	Salazar	Castillo	1994-03-29	M	A-	5584101959	paciente2709@example.com
FWII730324XZIAWXZ6	Paola	Gómez	Torres	1973-03-24	Intersex	O-	5592220976	paciente2710@example.com
XRFL081110MZKWSDS3	Leticia	Fuentes	Salazar	2008-11-10	F	A+	5517245605	\N
DZOQ880808HAQPDGV3	Juan	Herrera	Salazar	1988-08-08	M	\N	5573242057	\N
FKPA730830HPXFZPK9	Fernando	Mendoza	Mendoza	1973-08-30	M	O+	5569981172	paciente2713@example.com
CMPC601014XMWPFPD2	Sergio	Guzmán	Alvarado	1960-10-14	Intersex	A+	5510262108	\N
SCJW550427XHUDSH84	Fernando	Gómez	\N	1955-04-27	Intersex	O-	5531189230	paciente2715@example.com
RQPF741018HQOOCGC4	Luis	Jiménez	Cruz	1974-10-18	M	A+	5587680900	paciente2716@example.com
WOOX110818MBTOQZX2	Leticia	Contreras	Ortiz	2011-08-18	F	B-	5599138541	\N
VUKZ770719XWDZSLQ4	Adrián	Solís	Torres	1977-07-19	Intersex	A+	5534402588	paciente2718@example.com
UDOD120130MAQVOI85	Ana	García	Estrada	2012-01-30	F	A-	\N	paciente2719@example.com
ARXO630212XVEKIP57	Cecilia	Estrada	Castillo	1963-02-12	Intersex	B-	5588176835	\N
VDZN240913MEDTQS44	Paola	Herrera	Sánchez	2024-09-13	F	B+	5531681516	\N
UIIK210704HDTWMJL3	Iván	Peña	\N	2021-07-04	M	O+	5561901748	paciente2722@example.com
ODTG500130MBMWUZS7	Verónica	Chávez	Romero	1950-01-30	F	A-	5508753589	paciente2723@example.com
TXLD651128HHGHCW09	Rodrigo	Díaz	Ramos	1965-11-28	M	B-	5532324693	paciente2724@example.com
GVPZ540906HPPZFYD4	Fernando	Peña	Herrera	1954-09-06	M	A-	5571888427	paciente2725@example.com
LLXG000614XZTFQIB3	Gerardo	Peña	Romero	2000-06-14	Intersex	B+	5596454406	paciente2726@example.com
QGMS110401XHAURAE1	Adriana	Gutiérrez	Vázquez	2011-04-01	Intersex	\N	5513983020	paciente2727@example.com
FVGR460327MNVDNXD1	Daniela	Solís	Vargas	1946-03-27	F	\N	5519136406	paciente2728@example.com
JBJU791019XPPHLBP1	Luis	Mendoza	González	1979-10-19	Intersex	\N	5549741632	\N
HNNV520114XAFHKEF7	Óscar	Ruiz	Jiménez	1952-01-14	Intersex	A+	5511828913	\N
CTAL850123XUQCIO00	Óscar	González	\N	1985-01-23	Intersex	B-	5533094797	paciente2731@example.com
ZUMZ020425XIKQETU4	Laura	Ramos	Morales	2002-04-25	Intersex	AB+	5573330030	\N
JUFL040808HHXUBDI8	Roberto	Castillo	Cruz	2004-08-08	M	O-	5500112952	\N
VJDJ591128XMLNNUP7	Rosa	Medina	Rojas	1959-11-28	Intersex	O+	5543737514	\N
XFEE870504HVRWJOZ6	Diego	Chávez	Torres	1987-05-04	M	O+	\N	paciente2735@example.com
EMDT670929XHLRDLG4	José	Cabrera	Pérez	1967-09-29	Intersex	O-	5559400489	paciente2736@example.com
LIVI750319MTKMXW37	Daniela	García	Aguilar	1975-03-19	F	B-	5512340015	\N
LAPN170915XFSWZIK0	Juan	Ortiz	\N	2017-09-15	Intersex	O-	5517220943	\N
CVTR390303HULOOX67	José	Herrera	Gutiérrez	1939-03-03	M	A-	5537230735	paciente2739@example.com
OISP851106XQSLGXX2	Fernando	Aguilar	Medina	1985-11-06	Intersex	B-	5535599515	\N
RPEJ040319MHARQJ96	Adriana	Romero	Ortiz	2004-03-19	F	O+	5541442509	paciente2741@example.com
WPSV951216MBDKLA78	Silvia	Morales	Rojas	1995-12-16	F	O+	5539584545	\N
LHPB901104MIPNXQD9	Araceli	Cordero	Estrada	1990-11-04	F	\N	5568350518	\N
UPVB020401MDIFSKB3	María	Gómez	Mendoza	2002-04-01	F	A-	5536834021	\N
UUYU220116MJMAMLM4	Sofía	Gutiérrez	Herrera	2022-01-16	F	A-	\N	paciente2745@example.com
BLXK920104MPOGXSC4	Claudia	Gutiérrez	Romero	1992-01-04	F	B-	5543623319	paciente2746@example.com
DDVB751202HGRPPG90	Luis	Cruz	López	1975-12-02	M	O+	5578981968	paciente2747@example.com
VQJG800116MGCNKB83	María	Romero	Alvarado	1980-01-16	F	A-	5512724901	paciente2748@example.com
IMTQ050131MTQIPVP8	Guadalupe	Mendoza	Estrada	2005-01-31	F	B+	5553725801	paciente2749@example.com
JSNE781224MABGFHC2	Beatriz	Jiménez	Mendoza	1978-12-24	F	O+	5592686017	\N
DURC940924MWOVMCT2	Alejandra	Mendoza	Hernández	1994-09-24	F	AB+	5524436770	paciente2751@example.com
BUFU220215XMITDGU9	Teresa	Pérez	Medina	2022-02-15	Intersex	AB-	5589564252	paciente2752@example.com
CALY411113XHOFLNW6	Fernando	Pérez	Delgado	1941-11-13	Intersex	A-	5573434889	\N
FAZC030330HZEOOMB6	José	Martínez	Flores	2003-03-30	M	AB+	5525957874	\N
CPXF100126HZPIYUJ1	Miguel	Medina	Ortiz	2010-01-26	M	B+	\N	paciente2755@example.com
VCGN490719MPDNCU08	Yolanda	Guzmán	Cabrera	1949-07-19	F	B+	5589912638	paciente2756@example.com
UZLA940420HSOHYGM0	Sergio	Estrada	Gutiérrez	1994-04-20	M	\N	5538242985	paciente2757@example.com
HIJJ660121MMGZVJY4	Guadalupe	Ortiz	Solís	1966-01-21	F	AB-	5565913110	\N
CLYS780201MLRRCFM6	Patricia	Flores	Solís	1978-02-01	F	\N	5560882323	paciente2759@example.com
FFKX620105HISVZJX7	Luis	Reyes	Ramos	1962-01-05	M	O+	5576810132	\N
JCIF161111HHOLOIV4	Diego	Guzmán	Medina	2016-11-11	M	B-	5517330165	paciente2761@example.com
QCLX850625MSCNMZW5	Leticia	Medina	Mendoza	1985-06-25	F	O-	5528642136	\N
FFVE431229HTZWZJV3	Raúl	Pérez	Guzmán	1943-12-29	M	O-	5551644180	paciente2763@example.com
XHQX960726MZZAVVR2	Yolanda	García	\N	1996-07-26	F	O+	5579619909	paciente2764@example.com
CHDD630508XRPAVQ38	Cecilia	Delgado	Cabrera	1963-05-08	Intersex	O-	5549167165	paciente2765@example.com
PZRR870215HKDXNRL0	Hugo	Cabrera	Alvarado	1987-02-15	M	A-	5552857940	\N
QZSR891211MKCDRRF1	Gabriela	Pérez	Martínez	1989-12-11	F	AB+	5578734808	paciente2767@example.com
NOLO480311HVDWMSU4	Iván	Torres	Castillo	1948-03-11	M	O+	5513426839	paciente2768@example.com
HUUT170317XLOABD18	Gerardo	Delgado	Contreras	2017-03-17	Intersex	B+	5522402387	paciente2769@example.com
DJXO770716XMBIASZ2	Gabriela	Morales	\N	1977-07-16	Intersex	AB+	5592259537	paciente2770@example.com
LGFW481125HOEOZEC6	Diego	García	Salazar	1948-11-25	M	AB+	5549059730	\N
ZWBQ920221MYWQGAZ8	Lucía	Reyes	Torres	1992-02-21	F	A+	5581704967	\N
SCNG440202MOWTQYB0	Patricia	Vargas	Pérez	1944-02-02	F	B+	5572028882	paciente2773@example.com
YROP250630XBCKVFT2	Mario	Cabrera	Rojas	2025-06-30	Intersex	B+	5510299321	\N
BBSF520615HXKYVXQ2	Roberto	Guzmán	Torres	1952-06-15	M	AB-	\N	paciente2775@example.com
HYIG200418HAODJR93	Carlos	Medina	Fuentes	2020-04-18	M	O+	5545082759	paciente2776@example.com
TPIQ170119XRVWZJ07	Pablo	Herrera	Salazar	2017-01-19	Intersex	B+	5522328642	paciente2777@example.com
WXWZ170505HPJEML88	Manuel	Romero	Contreras	2017-05-05	M	B+	5566124501	\N
WDRD010621XDWNBOZ2	Luis	Rodríguez	Solís	2001-06-21	Intersex	O-	\N	paciente2779@example.com
XFCM890126MRIPFXB2	Teresa	Cordero	Flores	1989-01-26	F	O+	5514109244	\N
ZNQW941115XMJESZZ1	Iván	Gutiérrez	\N	1994-11-15	Intersex	AB-	5547273188	paciente2781@example.com
AGOJ121227HJXLPCE6	Fernando	Hernández	Aguilar	2012-12-27	M	AB-	5521421140	paciente2782@example.com
MJTE660317XSAPBG73	Teresa	González	Alvarado	1966-03-17	Intersex	B+	5513424706	paciente2783@example.com
WOZY970708MDNXJBB4	Lucía	Cabrera	Ramírez	1997-07-08	F	\N	5595241434	paciente2784@example.com
MGTP430707XCQBCEC6	Paola	Mendoza	Romero	1943-07-07	Intersex	A-	5575997949	paciente2785@example.com
NPMM660714MOZISWF3	Karla	Ruiz	Aguilar	1966-07-14	F	B+	5516940324	paciente2786@example.com
LGWE590202HVJXJWI1	Carlos	Alvarado	Torres	1959-02-02	M	B+	5500498359	\N
RGNL391201HCYJMSD5	Ricardo	Medina	Peña	1939-12-01	M	O-	5537653979	paciente2788@example.com
ICAR570119HBPLBSV0	Ricardo	Contreras	Vázquez	1957-01-19	M	A-	5545136402	paciente2789@example.com
BVVR631223XKSKAGG2	Leticia	Gutiérrez	Cruz	1963-12-23	Intersex	O-	5595995924	\N
ZGMZ961016XBDRCD40	Mario	Sánchez	Ramos	1996-10-16	Intersex	A-	5503253836	\N
CUNK110927MCJRDCG4	Mónica	Peña	Delgado	2011-09-27	F	AB+	5526117370	\N
BGLK940501MUSTMOO1	Claudia	Fuentes	Torres	1994-05-01	F	A-	5521312434	paciente2793@example.com
GWZM151004MFCKHSR4	Fernanda	Aguilar	Estrada	2015-10-04	F	O+	5501461205	paciente2794@example.com
OLHT411211XGNBAPS8	Javier	Estrada	Torres	1941-12-11	Intersex	O-	5535333694	\N
VLML850707MREKKI63	Sofía	Sánchez	García	1985-07-07	F	\N	5561235879	\N
XTBP620920MESIVV75	María	Guzmán	López	1962-09-20	F	AB+	5536667313	paciente2797@example.com
GRSO030729XKJPADF2	Pablo	Gómez	Castillo	2003-07-29	Intersex	O-	5559393942	paciente2798@example.com
QDYL460304HNLXTYY0	Arturo	Cruz	Fuentes	1946-03-04	M	B+	\N	paciente2799@example.com
IRCG910327MHKPQFJ4	Gabriela	Gutiérrez	Martínez	1991-03-27	F	B+	5535068843	paciente2800@example.com
AMWE901021HNGRWEO9	Daniel	Jiménez	Peña	1990-10-21	M	O-	5594787454	paciente2801@example.com
URNQ670706MMLSFPT8	Miriam	García	Sánchez	1967-07-06	F	O-	5529645482	paciente2802@example.com
TXSI141028HDXHMJT7	Daniel	Ruiz	Solís	2014-10-28	M	AB-	5511884401	paciente2803@example.com
VSZM171103MDPUEL68	Beatriz	García	Morales	2017-11-03	F	A+	5584427180	\N
TSLD471214MFDUVPT4	Teresa	Pérez	Fuentes	1947-12-14	F	AB-	5563651837	\N
DUWF570324MLAMZQL1	Guadalupe	Flores	Contreras	1957-03-24	F	A+	\N	paciente2806@example.com
VOTV690402MKCTZV12	Rosa	Sánchez	Peña	1969-04-02	F	B+	5540558972	\N
VTQZ370214MQKYLFK9	Teresa	González	Cabrera	1937-02-14	F	A+	5570259845	paciente2808@example.com
JXQX961126MOFZZSH2	Alejandra	Ortiz	López	1996-11-26	F	\N	5596733537	\N
UCOC250603XTXLLP13	Diego	Vázquez	Hernández	2025-06-03	Intersex	A+	5551662156	paciente2810@example.com
JPBH810302MUAGNMP8	Mónica	Salazar	Vázquez	1981-03-02	F	AB+	5502687175	paciente2811@example.com
URNK780123MRKFFQ67	María	Ramos	González	1978-01-23	F	AB+	5572746003	paciente2812@example.com
ZQOA100403HHLCPCR9	José	Mendoza	Salazar	2010-04-03	M	AB-	5500970644	\N
ZJND050320XDKKUKL4	María	González	Chávez	2005-03-20	Intersex	O+	5578201581	\N
LGDC720526HYNUTKH5	Mario	Medina	Jiménez	1972-05-26	M	A+	5534508960	paciente2815@example.com
YMMZ811208MOAVRBY0	Carmen	González	Vázquez	1981-12-08	F	AB+	\N	paciente2816@example.com
CRHF170303HRXIAWG4	Iván	Romero	Ruiz	2017-03-03	M	B+	\N	paciente2817@example.com
HDOG961130MXEJNDW5	Claudia	Herrera	Morales	1996-11-30	F	A+	5511341481	\N
RWHK920720XUFPHRN9	Verónica	Cabrera	Aguilar	1992-07-20	Intersex	AB+	5585606945	paciente2819@example.com
GCTL490418XPSVSNV9	Alejandra	Díaz	Estrada	1949-04-18	Intersex	O-	5539449493	\N
QIIT481020XUXBXZK3	Karla	Salazar	Contreras	1948-10-20	Intersex	O+	5571465028	paciente2821@example.com
TCBQ501027HCZRWT81	Luis	Medina	Romero	1950-10-27	M	A-	5501104708	paciente2822@example.com
VELM560328MPECWCV1	Mónica	Torres	Jiménez	1956-03-28	F	O-	\N	\N
ECNK680505XLCJZNL0	Daniela	Ramírez	Herrera	1968-05-05	Intersex	O+	\N	paciente2824@example.com
NJXZ680216XDJHOOK2	Elena	Herrera	Guzmán	1968-02-16	Intersex	A+	5556931493	paciente2825@example.com
EONW070921XCSVTXC3	Verónica	González	Rojas	2007-09-21	Intersex	AB-	5573110253	paciente2826@example.com
RKDW410619XLVCUJR0	Óscar	Delgado	Ramos	1941-06-19	Intersex	O+	5567239798	paciente2827@example.com
YXYB170206HOMYYVC5	Carlos	Herrera	Cruz	2017-02-06	M	B-	5587042537	paciente2828@example.com
LISM131227MMAPZAL8	Silvia	Romero	Reyes	2013-12-27	F	AB-	5572380571	paciente2829@example.com
MQUY650611HWFPHIK8	Roberto	Alvarado	Aguilar	1965-06-11	M	O+	5542685446	paciente2830@example.com
QSKQ800429XTTZHEE9	Sofía	Solís	Castillo	1980-04-29	Intersex	O-	5533044217	paciente2831@example.com
LXAJ030225HJNFIAT4	Manuel	Fuentes	Romero	2003-02-25	M	O-	5531664170	\N
OIZE380219HDEXBNZ0	Antonio	Vargas	Torres	1938-02-19	M	B-	5580856902	paciente2833@example.com
QQAO801022XZEIEB45	Adriana	Rodríguez	Hernández	1980-10-22	Intersex	A-	\N	paciente2834@example.com
TNYM501112XOHITK76	Mario	Contreras	Aguilar	1950-11-12	Intersex	O+	\N	paciente2835@example.com
YISC961017HWJWMLE6	Juan	Herrera	Salazar	1996-10-17	M	AB-	5592127195	\N
VSNQ200505HHWWXZ42	Raúl	Sánchez	Guzmán	2020-05-05	M	O+	5564854713	\N
NGIR620710XCHABJP6	Óscar	Salazar	Delgado	1962-07-10	Intersex	A+	5569153930	paciente2838@example.com
JAIN101128HMCACB11	Adrián	Fuentes	Aguilar	2010-11-28	M	B-	5516189329	paciente2839@example.com
DJLA560503MVCRCR48	Alejandra	Morales	Aguilar	1956-05-03	F	B-	5537436125	\N
TVCE390405HJCKWFE2	Gerardo	Aguilar	Herrera	1939-04-05	M	O-	5593387300	paciente2841@example.com
OTZW721111HLOHOX35	Pablo	Reyes	Medina	1972-11-11	M	AB+	5541089452	\N
AGPM581219HISJWCM3	Gerardo	Ramos	Díaz	1958-12-19	M	O+	5584552255	\N
KCIC800111XHYMXGJ5	Paola	Torres	Flores	1980-01-11	Intersex	B-	5561333305	paciente2844@example.com
UWHP650713XEGWNPD8	Yolanda	Jiménez	Sánchez	1965-07-13	Intersex	A+	5513522111	\N
PSSG800321XHGBTUE3	Juan	Cabrera	Hernández	1980-03-21	Intersex	\N	5591986020	paciente2846@example.com
DRDI680910XHGYKU76	Manuel	Salazar	Medina	1968-09-10	Intersex	A+	5535880588	paciente2847@example.com
NRPS840917MBFIJNQ4	Paola	Delgado	López	1984-09-17	F	A+	5559864840	paciente2848@example.com
SBZP120915XLIEZEQ8	Eduardo	Guzmán	\N	2012-09-15	Intersex	\N	\N	paciente2849@example.com
MGUV510927MTYDKTZ5	Elena	Cabrera	Vázquez	1951-09-27	F	\N	5581403484	paciente2850@example.com
GUYF520615MNGGIL20	Alejandra	Reyes	Cabrera	1952-06-15	F	\N	5517596614	paciente2851@example.com
SBQW411130MTZWLPH0	Fernanda	Mendoza	Díaz	1941-11-30	F	AB-	\N	\N
GUKS660823MNAMLQV5	Yolanda	García	Flores	1966-08-23	F	A+	5595094436	\N
VWWV771105XMXYCRG7	Javier	Fuentes	Ortiz	1977-11-05	Intersex	B+	5557682636	paciente2854@example.com
SVPH800326XUZBHNW9	José	Solís	\N	1980-03-26	Intersex	O+	5546743340	paciente2855@example.com
ADWV541130XGGGYJO1	Adrián	Hernández	Ramos	1954-11-30	Intersex	AB-	5574963188	paciente2856@example.com
DVBD450702XKXQKEY3	Arturo	Martínez	Castillo	1945-07-02	Intersex	A+	5510785778	paciente2857@example.com
JEAX500619MWCCQNZ8	Daniela	Cruz	Mendoza	1950-06-19	F	A+	5563401881	\N
CQWE760602MOCULZG3	Carmen	Vargas	Rodríguez	1976-06-02	F	O-	5582882763	\N
DRZW591128XZQMURM5	Arturo	Alvarado	Vargas	1959-11-28	Intersex	B+	5537457147	\N
WUTR140815MAOCEHM6	Lucía	Contreras	Morales	2014-08-15	F	AB-	5521554237	\N
VDIW010601XKRRNCN6	Adriana	Vargas	Martínez	2001-06-01	Intersex	B+	5535906328	paciente2862@example.com
BAJE000130MCZAZV59	Beatriz	Ramos	Medina	2000-01-30	F	\N	5576019666	paciente2863@example.com
RVGM810621XUWBYW59	Fernando	Delgado	Gómez	1981-06-21	Intersex	\N	5597892079	paciente2864@example.com
YGME160114HIAQXGF9	Iván	Reyes	García	2016-01-14	M	B-	5526467445	paciente2865@example.com
XKAL430817HJUMOX78	Rodrigo	Gómez	Cordero	1943-08-17	M	B+	5580595474	\N
JZHV050807HODJFWS3	Miguel	Fuentes	Cruz	2005-08-07	M	\N	5501372492	paciente2867@example.com
TYNK890731MPHQVKO7	Leticia	López	Cabrera	1989-07-31	F	B-	5512207215	paciente2868@example.com
AFFE910408XIPUBHK1	Patricia	Solís	Ramos	1991-04-08	Intersex	A-	5537800684	\N
HRLK740523XLBOUSM2	Emilio	Díaz	Cruz	1974-05-23	Intersex	O+	\N	paciente2870@example.com
VZWS011001XDHBUMG0	Alejandro	Ramírez	Gutiérrez	2001-10-01	Intersex	\N	5570419364	\N
DQEF381112MFJDHVK9	Mónica	Rodríguez	Rodríguez	1938-11-12	F	B-	\N	\N
YZDG610112HSSUVE85	Jorge	Morales	Flores	1961-01-12	M	\N	5542735022	\N
WYCT210113MSKHVEF0	Carmen	Peña	Pérez	2021-01-13	F	B-	5584281435	paciente2874@example.com
SOTZ690906XRCPNHB1	Sofía	Peña	Sánchez	1969-09-06	Intersex	O-	5543167014	\N
EANI781204HVLMEUB0	Adrián	Gutiérrez	Salazar	1978-12-04	M	\N	5527365293	paciente2876@example.com
XUKM210216HLNWXOG6	Eduardo	Solís	Ramírez	2021-02-16	M	AB-	5512794401	\N
UXFJ030626MYUSOZC7	Silvia	Vargas	Morales	2003-06-26	F	A-	\N	paciente2878@example.com
DSFB510703XWVEWE85	Ana	Guzmán	Alvarado	1951-07-03	Intersex	B+	\N	\N
QVIK550404MVBDKZ12	Beatriz	Pérez	Aguilar	1955-04-04	F	A+	5584819060	\N
CJPB760616XKVXNJ31	Elena	Peña	Vargas	1976-06-16	Intersex	AB-	5512698153	\N
TUEN231111MTOQQUM3	Adriana	Morales	Vázquez	2023-11-11	F	O-	\N	paciente2882@example.com
LMIK680131HTQAGIQ0	Arturo	Ramos	López	1968-01-31	M	B-	5556595197	paciente2883@example.com
JYWV030319XUVJWWI0	Raúl	Estrada	López	2003-03-19	Intersex	B-	5554912831	paciente2884@example.com
IEFQ990515MHETUSV8	Araceli	Cabrera	Delgado	1999-05-15	F	AB-	5542796304	paciente2885@example.com
ZJOR390208MUVMWJE6	Leticia	Cordero	Cabrera	1939-02-08	F	A-	5528105925	\N
FHDC910718HNMLLMO6	Carlos	Medina	Ortiz	1991-07-18	M	A-	\N	paciente2887@example.com
BCLM490321MJAOVUX5	Leticia	Morales	Delgado	1949-03-21	F	AB+	5514673592	paciente2888@example.com
YPOI920903HWDVMD15	Rodrigo	Peña	Cruz	1992-09-03	M	AB+	5557640633	paciente2889@example.com
BNSN180307MOSMTHL4	Rosa	Castillo	Sánchez	2018-03-07	F	AB+	5534436928	paciente2890@example.com
PTYJ070329HOOUJC53	Eduardo	Romero	Herrera	2007-03-29	M	A-	5560107867	paciente2891@example.com
GKRW220617XYDNVXX4	Luis	Mendoza	Ramos	2022-06-17	Intersex	\N	5506184648	paciente2892@example.com
OMJN481217MZAGMGK4	Fernanda	García	Mendoza	1948-12-17	F	A+	5566227192	\N
NNOH371030HTBMVYC7	Fernando	Aguilar	Ramos	1937-10-30	M	A+	5572365761	paciente2894@example.com
DNIA690501MFFMDWI3	Miriam	Alvarado	Guzmán	1969-05-01	F	B+	5594572449	paciente2895@example.com
DJZQ871026MUCASTV7	Daniela	Díaz	Gómez	1987-10-26	F	\N	5583380703	paciente2896@example.com
PAKG381007XHUVBRV1	Antonio	Ruiz	Romero	1938-10-07	Intersex	\N	5560696249	paciente2897@example.com
BGAR200115XSOLQMN8	Rodrigo	Romero	Pérez	2020-01-15	Intersex	O+	5504416166	paciente2898@example.com
KJQL070916XGSNCUA4	Francisco	Morales	Castillo	2007-09-16	Intersex	\N	5588057498	paciente2899@example.com
XBFJ550731MYSHQOE3	Sofía	Herrera	Torres	1955-07-31	F	\N	5527935444	paciente2900@example.com
XOZG480816XUBDSXU2	Yolanda	Peña	\N	1948-08-16	Intersex	AB+	\N	\N
JLXU510411MMNHNGD5	Carmen	Vargas	Flores	1951-04-11	F	O-	5516379963	paciente2902@example.com
RLMR470629MUHMSYV7	Adriana	Morales	Morales	1947-06-29	F	O+	5501503431	paciente2903@example.com
FDHI890524MGHLOCL0	Patricia	Peña	Chávez	1989-05-24	F	B-	5592138606	paciente2904@example.com
BEIL850614XMJZWKO1	Gabriela	Vargas	Medina	1985-06-14	Intersex	O+	5590700960	paciente2905@example.com
KZSY440131MHILUPE6	Karla	Gutiérrez	Cordero	1944-01-31	F	O-	5556336061	\N
CFGA060816XHMPFN64	Daniela	Pérez	Flores	2006-08-16	Intersex	AB-	5508169035	\N
EQXT891027XKXQXAR2	Elena	Díaz	López	1989-10-27	Intersex	B+	5585116883	paciente2908@example.com
MPRL681208HQOHGZQ6	Emilio	González	Reyes	1968-12-08	M	AB+	5576682930	paciente2909@example.com
QOZP441209XJNIHQV0	Guadalupe	Vázquez	Reyes	1944-12-09	Intersex	\N	5525704455	\N
PUIF400627XDBSIH80	Raúl	Mendoza	Fuentes	1940-06-27	Intersex	B-	5579489830	paciente2911@example.com
YWOL230302XZWHSH95	Silvia	Alvarado	Fuentes	2023-03-02	Intersex	AB+	5560042709	paciente2912@example.com
USJU470106XGVYGZ60	Emilio	Ramos	Herrera	1947-01-06	Intersex	B-	5563471678	\N
ZWJI640407MLZESFX8	Cecilia	Salazar	Solís	1964-04-07	F	A+	5591480874	paciente2914@example.com
YWBL161219HQPMYQZ9	Carlos	Cordero	Morales	2016-12-19	M	B+	5518416571	\N
YVWD390306XAKMNGI6	Guadalupe	Salazar	Gutiérrez	1939-03-06	Intersex	A+	5563025786	paciente2916@example.com
OGNY900826HAHEDDK4	Ricardo	Guzmán	Romero	1990-08-26	M	B-	5515479984	paciente2917@example.com
TTNQ191015XGWFPX02	Paola	Rodríguez	Ruiz	2019-10-15	Intersex	\N	5508237105	paciente2918@example.com
AIOW800108HHEPZFI4	Jorge	Morales	Estrada	1980-01-08	M	A-	5575811625	paciente2919@example.com
CDIV920911XOOODMM1	Gabriela	Vargas	Medina	1992-09-11	Intersex	B-	5538096278	paciente2920@example.com
FRHV741217HWIYYWR0	Luis	Herrera	González	1974-12-17	M	A+	5508358897	\N
YQZK490514XYRJFAT9	Fernando	Mendoza	Hernández	1949-05-14	Intersex	B-	5592876756	paciente2922@example.com
CJKU790511HGYSEVT1	Gerardo	Herrera	Salazar	1979-05-11	M	A-	5537332640	paciente2923@example.com
BYEA740720XQJEZOO5	Alejandra	Gutiérrez	Salazar	1974-07-20	Intersex	O-	5521578644	paciente2924@example.com
ZKEV240810HQOABDD6	Daniel	Alvarado	Flores	2024-08-10	M	A+	5565212256	\N
TEXB500711MNNLIL06	Adriana	Contreras	Cruz	1950-07-11	F	AB-	\N	\N
LWLP741218HYLHQQI5	Sergio	Hernández	Hernández	1974-12-18	M	AB-	5537117185	paciente2927@example.com
XPRC610503XQRPZK61	Sofía	Castillo	González	1961-05-03	Intersex	B-	5518623937	paciente2928@example.com
PCLM930128HFYDABB4	Arturo	Cordero	Cabrera	1993-01-28	M	AB-	5519406568	paciente2929@example.com
ARNC430127XJNGSCD2	Luis	Hernández	Vargas	1943-01-27	Intersex	AB-	5523783762	paciente2930@example.com
EMVA380729HXLNWWK9	Rodrigo	Díaz	Pérez	1938-07-29	M	A+	5592362013	\N
AEWS050305HQMEQDF8	Alejandro	Medina	Alvarado	2005-03-05	M	O+	5596885359	\N
PXJO030506XQQWQET5	Iván	Medina	Alvarado	2003-05-06	Intersex	O-	5578133917	\N
FWWO700324HKJCYG77	Javier	Herrera	Jiménez	1970-03-24	M	O+	5554405475	paciente2934@example.com
TBZP370325HBZFXUT9	Manuel	Sánchez	Romero	1937-03-25	M	O-	5510717878	paciente2935@example.com
AAIY430819MKYJKPS2	Beatriz	Ruiz	Aguilar	1943-08-19	F	AB-	5537373269	paciente2936@example.com
PXDF740827HFMSKCS3	Sergio	Cruz	Díaz	1974-08-27	M	AB+	5500912585	\N
AQSL431228MHQZWT40	Diana	Hernández	Rojas	1943-12-28	F	AB+	5501374896	paciente2938@example.com
PMTE440714XIMCAKP1	Lucía	Ramírez	Jiménez	1944-07-14	Intersex	\N	5544794050	paciente2939@example.com
ANYB710616XHKNUZK7	Óscar	Rodríguez	Díaz	1971-06-16	Intersex	O+	5510500917	paciente2940@example.com
DOPX751107XIARTR74	Alejandra	Mendoza	Cruz	1975-11-07	Intersex	AB-	5553115451	paciente2941@example.com
EQRH780421HMZOAB34	Rodrigo	Reyes	Delgado	1978-04-21	M	O-	5588682875	paciente2942@example.com
YVGB681113HVOKWL48	Daniel	Fuentes	Gómez	1968-11-13	M	AB+	5516584130	\N
MFAN990707XUNPFT63	Fernando	Flores	Romero	1999-07-07	Intersex	AB+	5594102829	paciente2944@example.com
JYTU860829XXEYRBO1	Silvia	Medina	Gómez	1986-08-29	Intersex	B-	5522658177	\N
NHNQ080118XDEHAKO2	Sofía	Gómez	Herrera	2008-01-18	Intersex	B-	5500118123	paciente2946@example.com
BCUE661004MFCEIUM6	Claudia	Herrera	Salazar	1966-10-04	F	B-	5510107452	paciente2947@example.com
SCCT721120HUXODK60	Rodrigo	Ruiz	López	1972-11-20	M	\N	5511150412	paciente2948@example.com
FQOY150721XYKBQFZ7	Beatriz	Ramos	González	2015-07-21	Intersex	O+	5509738079	paciente2949@example.com
CBIL711118MDJDIM88	Teresa	Reyes	Rodríguez	1971-11-18	F	O-	5556109583	paciente2950@example.com
FOKH191114MNXFJPD5	Elena	Reyes	Estrada	2019-11-14	F	A+	5534750917	paciente2951@example.com
IBUU911126MVLQKQ91	Diana	Romero	Cordero	1991-11-26	F	O-	5557717077	paciente2952@example.com
BZWM190505MDBJFYC3	Araceli	Alvarado	Contreras	2019-05-05	F	O+	5553868281	paciente2953@example.com
URMD831106MNTABQU3	Elena	Martínez	\N	1983-11-06	F	B+	5555074814	\N
TFMM581116MFNYGTW1	Adriana	Delgado	Romero	1958-11-16	F	\N	5538334941	paciente2955@example.com
OOPV110616MOCGLR01	Araceli	Gómez	Peña	2011-06-16	F	AB+	\N	\N
QOCZ810719HRPVTZ38	Carlos	Reyes	Solís	1981-07-19	M	A+	5530907725	paciente2957@example.com
NFUK481204HASYINY6	Emilio	Hernández	García	1948-12-04	M	O+	5506890255	paciente2958@example.com
RIAO680625XVAIDSB2	Laura	Estrada	Contreras	1968-06-25	Intersex	B+	5561772379	paciente2959@example.com
HZGY441209HBDVSFV1	Juan	Cabrera	Ramos	1944-12-09	M	\N	5547048550	\N
IPDL620204HMLBGPG5	Antonio	Vargas	Ortiz	1962-02-04	M	O+	\N	\N
BCEB121002XEWZDKJ6	Sergio	Medina	Fuentes	2012-10-02	Intersex	A+	\N	paciente2962@example.com
WZPK921230XVODXY66	Teresa	Alvarado	Cabrera	1992-12-30	Intersex	AB-	5500697365	paciente2963@example.com
WEVG721109XDULDDA8	Mario	Cordero	Torres	1972-11-09	Intersex	O-	5583135719	\N
NLQQ820427XCQZQZP7	Roberto	Romero	Sánchez	1982-04-27	Intersex	AB+	5561712550	paciente2965@example.com
ZVPR150409MFNIBZ93	Elena	Torres	Peña	2015-04-09	F	B+	5544340288	paciente2966@example.com
OODP791116MKNMXVP5	Silvia	Estrada	Hernández	1979-11-16	F	AB-	5538186832	\N
JHOA960324MDDEMZL8	Diana	Vázquez	Castillo	1996-03-24	F	AB-	5524976193	paciente2968@example.com
DHDA211028XWTRNEQ5	Guadalupe	Guzmán	Aguilar	2021-10-28	Intersex	A-	\N	\N
MKEF560622MODWAM74	Beatriz	Rojas	Ramírez	1956-06-22	F	AB+	5565658404	\N
OISO060613XGNJLN51	Diana	Delgado	Hernández	2006-06-13	Intersex	A+	5524987641	paciente2971@example.com
CWTC391023MHSMQHD2	Leticia	Ramírez	Reyes	1939-10-23	F	\N	5576722071	paciente2972@example.com
UWHG521003XNNQYSS9	Miguel	Vázquez	Martínez	1952-10-03	Intersex	B+	5578367744	paciente2973@example.com
KLIS440416HYNRIPK7	Manuel	Ramos	Cabrera	1944-04-16	M	AB+	\N	\N
PCMS151102XSJIJF93	Eduardo	Fuentes	Rojas	2015-11-02	Intersex	AB+	5524700429	paciente2975@example.com
DFBB400707MOHCMRC8	Alejandra	Díaz	Guzmán	1940-07-07	F	O+	5582423997	paciente2976@example.com
TSSR140501MHSDRPV9	Miriam	Guzmán	Morales	2014-05-01	F	O+	5584194824	paciente2977@example.com
AHXI781201MMOBWA11	Lucía	Sánchez	Herrera	1978-12-01	F	AB+	5584738106	\N
BREE920509HMCMHJC5	Adrián	Vargas	Salazar	1992-05-09	M	B+	5598590175	paciente2979@example.com
AJSV930331MHKORDS1	Guadalupe	García	Mendoza	1993-03-31	F	A+	5570153387	paciente2980@example.com
TDEH100818HQVDXC97	Hugo	Fuentes	Delgado	2010-08-18	M	B+	5500743262	paciente2981@example.com
PMBX660625XUGKMPI9	Alejandra	Torres	Jiménez	1966-06-25	Intersex	B+	5524722264	paciente2982@example.com
XHFU980527HMBYVVN2	Arturo	Reyes	Jiménez	1998-05-27	M	A+	5575617583	paciente2983@example.com
TZQZ230620MWCXZQF9	Lucía	González	Jiménez	2023-06-20	F	A+	5524129635	paciente2984@example.com
EAYT050418MHSPYI90	Sofía	Flores	Medina	2005-04-18	F	O+	5592936778	paciente2985@example.com
JIXJ971010HEZTUOO7	Alejandro	Ruiz	Estrada	1997-10-10	M	A+	5532334833	paciente2986@example.com
RKCH810719MTGCDMV3	Sofía	Vargas	Jiménez	1981-07-19	F	O-	5564569675	paciente2987@example.com
LTUC170504HURHHZO3	Eduardo	Guzmán	Guzmán	2017-05-04	M	B-	5555013584	\N
HOGV180926HEAVUUI2	Iván	Reyes	Pérez	2018-09-26	M	O+	\N	paciente2989@example.com
NYBZ690225HMRMUR06	Emilio	Fuentes	Ramírez	1969-02-25	M	A-	\N	paciente2990@example.com
RNZH390618XTXTQOU6	Gabriela	Romero	Fuentes	1939-06-18	Intersex	\N	5592995911	paciente2991@example.com
QGKA070211HSHEOLM2	Andrés	Herrera	Cordero	2007-02-11	M	AB+	5586320130	paciente2992@example.com
WMTC711111MDVRMMT1	Beatriz	Morales	Reyes	1971-11-11	F	O-	5564465923	paciente2993@example.com
ABQA730413MAJOAGL2	Teresa	Guzmán	Alvarado	1973-04-13	F	AB+	\N	\N
SCGW431110XITOHDB5	Ana	Fuentes	Morales	1943-11-10	Intersex	A-	5589312904	paciente2995@example.com
XNDN040515XBYCAV52	Javier	Flores	Cruz	2004-05-15	Intersex	\N	5538212101	paciente2996@example.com
ZQJS811006HPVAJVJ0	José	Romero	Estrada	1981-10-06	M	AB-	5576631009	paciente2997@example.com
EEGM001003MKXZHF41	Claudia	González	Solís	2000-10-03	F	B+	5572507623	\N
SVIJ220311HIQHCPS9	Gerardo	Contreras	Mendoza	2022-03-11	M	A-	5501616876	\N
VKPL120207HRIQHMN9	Adrián	Rojas	Flores	2012-02-07	M	O-	5501389881	\N
VGHV100311XKQNEGR2	Óscar	Vargas	Ramírez	2010-03-11	Intersex	A+	5542264101	\N
MMZK930223MYOONAZ1	Carmen	Cruz	García	1993-02-23	F	A+	5517434210	paciente3002@example.com
GWSA460624HHWDNT04	Andrés	Fuentes	Cabrera	1946-06-24	M	AB+	5580268748	paciente3003@example.com
WWND660321XEIPZZY8	Alejandra	Rodríguez	Alvarado	1966-03-21	Intersex	B-	5597664692	paciente3004@example.com
FPOW760520MJNTYI82	Teresa	Solís	Gómez	1976-05-20	F	B-	5557634478	paciente3005@example.com
HLFX791031HXVQCH52	Juan	Rodríguez	Aguilar	1979-10-31	M	B+	5504653521	paciente3006@example.com
MZPO130902XSRGBZD2	Carlos	Ramos	Guzmán	2013-09-02	Intersex	O+	5543307790	paciente3007@example.com
GFHQ460825XRJBSTV5	Jorge	Ramírez	Mendoza	1946-08-25	Intersex	B-	\N	paciente3008@example.com
GCTR910408HLJIXRD6	Raúl	Sánchez	Hernández	1991-04-08	M	AB+	5564629065	\N
IPGP470906MBIFZUE4	Ana	Ramírez	Chávez	1947-09-06	F	O-	5538778700	\N
UTGZ890328XKUPMHN8	Hugo	Díaz	Hernández	1989-03-28	Intersex	O-	5554336062	\N
PBOH690322MPHMNRC3	Daniela	Hernández	López	1969-03-22	F	O-	5597607904	paciente3012@example.com
SYHX950830XCSSISM4	Diego	Martínez	\N	1995-08-30	Intersex	B+	5591615902	paciente3013@example.com
FEKK661120MKOJYDQ5	Teresa	Salazar	Romero	1966-11-20	F	O+	5590660363	\N
CNSG470117XDHGHMM4	Sofía	Pérez	Aguilar	1947-01-17	Intersex	B-	5528043326	\N
JSIN890520MDZKFU66	Leticia	Mendoza	Rodríguez	1989-05-20	F	\N	5591567407	paciente3016@example.com
TWAN630617XAVXRDI5	Arturo	Cabrera	Cordero	1963-06-17	Intersex	AB-	5560298224	paciente3017@example.com
NPLT210214XMKBZZB0	Yolanda	Vargas	Guzmán	2021-02-14	Intersex	A+	5597976470	paciente3018@example.com
KMCE890715XJNNEK09	Verónica	Romero	Pérez	1989-07-15	Intersex	B-	\N	paciente3019@example.com
FMDZ230206HZIFEQS7	Fernando	Ramírez	Solís	2023-02-06	M	B+	5578513681	paciente3020@example.com
KVRB041205XBXUUE22	Juan	Cordero	Aguilar	2004-12-05	Intersex	O-	5541121290	paciente3021@example.com
CSGM990808MUUXFMN1	Rosa	Medina	Medina	1999-08-08	F	A-	5549460781	paciente3022@example.com
SVHR160103HKFEFTN1	Andrés	Ramos	Ramírez	2016-01-03	M	O-	5523115479	paciente3023@example.com
UVSY600119XRVQVHF2	Rosa	García	Peña	1960-01-19	Intersex	O+	5505395432	paciente3024@example.com
TVYS501204MGROWQ64	Sofía	Cordero	Ramírez	1950-12-04	F	A-	\N	paciente3025@example.com
NIFO850406XGAASFD1	Yolanda	Pérez	Herrera	1985-04-06	Intersex	\N	5570698329	\N
QACY500217MNRZBOP2	Guadalupe	Pérez	Gómez	1950-02-17	F	\N	5597507721	paciente3027@example.com
BVKN680119XLLHIAD2	Gabriela	Martínez	Ruiz	1968-01-19	Intersex	AB+	5571617277	paciente3028@example.com
GVCW470101XUUUNDE8	Gabriela	Cabrera	Torres	1947-01-01	Intersex	AB+	5514218592	paciente3029@example.com
EFSI710508HNZRTOZ1	Juan	Martínez	Díaz	1971-05-08	M	AB+	5511857001	paciente3030@example.com
ORWN050108XMKLVZ41	Ricardo	Hernández	Guzmán	2005-01-08	Intersex	B-	5557290341	paciente3031@example.com
PVVU380421XWUUHU42	Emilio	Chávez	Aguilar	1938-04-21	Intersex	AB-	5590635931	\N
TTTD230107HFTSQFR8	Iván	Mendoza	López	2023-01-07	M	AB+	\N	paciente3033@example.com
OOWC230520HBSCFBQ5	José	Morales	Herrera	2023-05-20	M	A-	5595963845	\N
NMFG700215XXVBAG23	Javier	Castillo	Sánchez	1970-02-15	Intersex	AB+	5557081518	paciente3035@example.com
GYNQ050607XFNCJWT6	José	Contreras	Fuentes	2005-06-07	Intersex	B+	5555753100	paciente3036@example.com
OJFP620704MKOCIQE2	Yolanda	Alvarado	Estrada	1962-07-04	F	B-	5591653979	\N
UNNQ760411MJSFOZK5	Mónica	García	Ramos	1976-04-11	F	B+	5528324023	\N
FXSJ130703XGTODXU0	Elena	Delgado	González	2013-07-03	Intersex	O-	\N	paciente3039@example.com
EVWS660407XBBSJBH7	Raúl	Cabrera	Gutiérrez	1966-04-07	Intersex	AB-	5549192832	\N
NWWO610711MAVZFJE1	Leticia	Rodríguez	Delgado	1961-07-11	F	AB+	5593478776	\N
AWOE431001MDYXPRL1	Mónica	Aguilar	Vázquez	1943-10-01	F	A+	5500684642	paciente3042@example.com
VLQX080815HOGDCCN5	Manuel	Mendoza	Aguilar	2008-08-15	M	B+	5525867456	paciente3043@example.com
RDXL440310MMCGNQL3	Gabriela	Jiménez	Flores	1944-03-10	F	A-	5529046084	paciente3044@example.com
JYQB131012XYWDQP41	Mario	Gutiérrez	\N	2013-10-12	Intersex	AB-	5508481527	paciente3045@example.com
KWAO810622HUXGYNF3	Luis	Ruiz	Flores	1981-06-22	M	A+	\N	\N
MFUQ080503MDUWXS39	Leticia	Reyes	Flores	2008-05-03	F	O-	5513073661	paciente3047@example.com
OSNZ731106XTOQCML6	Paola	Castillo	Sánchez	1973-11-06	Intersex	AB+	5541682659	paciente3048@example.com
EOCV530207HXECZLH9	Sergio	Vázquez	Sánchez	1953-02-07	M	AB-	5509627316	paciente3049@example.com
NPQN121009MXCOQIA5	Silvia	Peña	Torres	2012-10-09	F	B+	5512061268	paciente3050@example.com
VQOP700329HDWWLQI7	Raúl	García	Díaz	1970-03-29	M	\N	5525983399	\N
IFDK880103MCCXEWZ1	Araceli	Delgado	Medina	1988-01-03	F	O+	5512827756	paciente3052@example.com
GPNW620907MUUOHZK6	Claudia	Estrada	Salazar	1962-09-07	F	B+	5526677301	\N
VTVI820226HHJBOCZ2	Emilio	Morales	Ramírez	1982-02-26	M	AB-	5547848605	paciente3054@example.com
MYBX890908HETWPET5	Antonio	Pérez	Castillo	1989-09-08	M	O-	5556099014	paciente3055@example.com
KSXL690709HVAGUMN2	Roberto	Salazar	Alvarado	1969-07-09	M	AB+	5537505432	paciente3056@example.com
IMWF750628XJBMWQN7	Emilio	García	Guzmán	1975-06-28	Intersex	B-	5545870230	paciente3057@example.com
ANOJ590405HDLQMPU2	Juan	Ramos	López	1959-04-05	M	B+	5587415507	paciente3058@example.com
YSFD030710MJRZDSZ4	Mónica	Gutiérrez	Solís	2003-07-10	F	A+	5504365451	paciente3059@example.com
WEEN091107HVKWNPK6	Iván	Alvarado	Solís	2009-11-07	M	AB+	5534178148	paciente3060@example.com
XURM930522HDJNTEH1	Javier	Peña	Aguilar	1993-05-22	M	A-	5568757412	paciente3061@example.com
IIJP641119XZCRMSS1	Ana	Guzmán	García	1964-11-19	Intersex	A-	5504080862	paciente3062@example.com
PDJF681029XOBSGCF2	Silvia	Jiménez	Chávez	1968-10-29	Intersex	O-	5595353241	\N
RKMN870718MZYYBYA2	Daniela	Castillo	López	1987-07-18	F	\N	5541111201	paciente3064@example.com
ZIXE920804HOWOVCR1	Pablo	Aguilar	Ramos	1992-08-04	M	O+	5552887646	paciente3065@example.com
ITWK640705XEMAKWG8	Juan	Peña	\N	1964-07-05	Intersex	B-	5564137281	\N
MHNN771125HQBFTKX4	Francisco	González	Salazar	1977-11-25	M	\N	5599752657	\N
GZZE000412HTUBWRF1	Eduardo	Romero	Ortiz	2000-04-12	M	AB+	\N	paciente3068@example.com
KXZX601014MUNCGMF5	Verónica	Peña	Cabrera	1960-10-14	F	O-	\N	paciente3069@example.com
EDZE640311HATNTQY0	Raúl	Torres	Cabrera	1964-03-11	M	O+	5577571555	paciente3070@example.com
JNWT880531XCXJKO65	Roberto	Cabrera	Rojas	1988-05-31	Intersex	O+	5519809599	paciente3071@example.com
EMMY060607HEXWKXG0	Eduardo	Aguilar	\N	2006-06-07	M	A-	\N	paciente3072@example.com
AFIN050519HPPNVT08	Arturo	Contreras	Reyes	2005-05-19	M	\N	5570641080	paciente3073@example.com
ESTX661127XNPFFJ75	Fernanda	González	\N	1966-11-27	Intersex	B-	5570343491	paciente3074@example.com
KPUB690707HKRHUHT9	Hugo	Hernández	Cordero	1969-07-07	M	B+	5574750636	paciente3075@example.com
MXGM800324MSUVHIF1	Claudia	Cabrera	Gómez	1980-03-24	F	B-	5564165064	\N
XMSN580506HLDIQEY8	Emilio	Martínez	Hernández	1958-05-06	M	A+	5556393009	paciente3077@example.com
PPDL170717HLWGNPP1	Mario	Cruz	González	2017-07-17	M	AB-	5521152192	paciente3078@example.com
PBPG730108XTTLLDO1	Mónica	Reyes	Cabrera	1973-01-08	Intersex	O+	5598688635	paciente3079@example.com
PLMY540427HOJKHO50	Miguel	Jiménez	\N	1954-04-27	M	AB+	5522563851	paciente3080@example.com
JIEX180615HGRCJKR0	Carlos	Cruz	Peña	2018-06-15	M	A-	5541546422	paciente3081@example.com
UAPJ090418XICVDJ76	Alejandro	Ramírez	Peña	2009-04-18	Intersex	A+	5578328453	paciente3082@example.com
NZBI861019HWAWYZB9	Gerardo	Cabrera	Solís	1986-10-19	M	\N	5536870172	\N
ZOYJ671003MIZBBBU4	Miriam	Pérez	Torres	1967-10-03	F	A-	5522264923	\N
LBHQ650630HSGJPNR9	Manuel	Solís	Solís	1965-06-30	M	B-	5532537742	\N
IHYL760716MDJLJXZ2	Beatriz	Vargas	Ortiz	1976-07-16	F	AB+	\N	paciente3086@example.com
SSDX950527XUQSYBO4	Rodrigo	Ruiz	Medina	1995-05-27	Intersex	AB-	5544995853	paciente3087@example.com
RGEX530707HCFDYNG7	Carlos	González	Hernández	1953-07-07	M	AB+	5519731029	paciente3088@example.com
ZEUQ420214HDABOJ88	Francisco	Rodríguez	Chávez	1942-02-14	M	\N	5505484043	paciente3089@example.com
NKQU890113XCKGTHY2	Leticia	Hernández	Aguilar	1989-01-13	Intersex	A+	5533936469	paciente3090@example.com
SEAL630509XJQRQLD7	Daniela	Gutiérrez	Mendoza	1963-05-09	Intersex	A-	5579162907	paciente3091@example.com
EBTT061124HUMNEOI5	Fernando	Estrada	Gómez	2006-11-24	M	O+	5512008407	paciente3092@example.com
VJQK140505XSTHCP65	Ana	Flores	Guzmán	2014-05-05	Intersex	\N	5573405386	paciente3093@example.com
GPUG650209XOSMPE90	Pablo	Vargas	García	1965-02-09	Intersex	A-	5519994650	\N
UTIT080125HXOBRHT0	Ricardo	Guzmán	Gómez	2008-01-25	M	AB+	5529536441	\N
KSXS990605MIDQRHY8	Carmen	Rojas	Solís	1999-06-05	F	O+	5588093207	paciente3096@example.com
LLEK830119MWHTCUL5	Gabriela	Herrera	González	1983-01-19	F	B-	5550030897	paciente3097@example.com
QPBG830716XHEZDUV8	María	Romero	Gómez	1983-07-16	Intersex	A-	5530392858	paciente3098@example.com
AJQV910327MTQQHHZ2	Karla	Díaz	Solís	1991-03-27	F	\N	5517506094	paciente3099@example.com
VVMV240805MTUWLCO1	Ana	Fuentes	Herrera	2024-08-05	F	O-	5542967307	\N
MJMC380418XBXORWG2	Rosa	Aguilar	Fuentes	1938-04-18	Intersex	AB-	5594917655	paciente3101@example.com
NWEP191125XBJTDJH8	Verónica	Medina	Estrada	2019-11-25	Intersex	B-	5523338316	paciente3102@example.com
VJUP430212XBXVSVQ1	Carlos	López	Ramírez	1943-02-12	Intersex	B-	5530745529	\N
ALPU680423HBRGSVI2	Francisco	Ruiz	Flores	1968-04-23	M	AB+	5503078371	paciente3104@example.com
YXMD010110MEULUZ59	Carmen	Torres	Estrada	2001-01-10	F	\N	5512331603	\N
HVCC890811XJAFXDW3	Gabriela	Estrada	Mendoza	1989-08-11	Intersex	O+	5504027617	paciente3106@example.com
HHEH721111XILIEVJ3	Francisco	Flores	Medina	1972-11-11	Intersex	O-	5578162142	paciente3107@example.com
NECW821117MIDNGKD2	Cecilia	Alvarado	Martínez	1982-11-17	F	O-	5510611410	paciente3108@example.com
AAVS090110MIYCWER4	Gabriela	Chávez	Medina	2009-01-10	F	B-	5519465370	paciente3109@example.com
QHZF530128HUHFYXP6	Rodrigo	Medina	Estrada	1953-01-28	M	AB-	5509895342	paciente3110@example.com
RCVF801029HDLLYLI4	Raúl	Hernández	Chávez	1980-10-29	M	\N	5530871301	paciente3111@example.com
WFCV160611XEMDBSA6	Laura	Martínez	González	2016-06-11	Intersex	O-	\N	paciente3112@example.com
WTPO480728XQAGJSM1	Claudia	Aguilar	Romero	1948-07-28	Intersex	AB+	5593483557	paciente3113@example.com
PODK180404HKNJQSY4	Javier	Ramos	Rojas	2018-04-04	M	A-	5546963181	paciente3114@example.com
GWUU700605XFMGIGD9	Mónica	Peña	Delgado	1970-06-05	Intersex	A+	5504824015	\N
VQTO190908MHXGWUL4	Beatriz	Vázquez	Hernández	2019-09-08	F	AB-	\N	paciente3116@example.com
WMYP621123MHTBGDY9	Elena	Delgado	Estrada	1962-11-23	F	AB-	5581885840	paciente3117@example.com
UOWG931203MIMTYQ17	Adriana	Pérez	Salazar	1993-12-03	F	B-	5597015422	paciente3118@example.com
POUZ920229XZFBBXU3	Guadalupe	López	Mendoza	1992-02-29	Intersex	AB+	5589089643	paciente3119@example.com
DRPP221119XNOWCFR4	Silvia	Reyes	Gómez	2022-11-19	Intersex	O-	5553091270	paciente3120@example.com
NUZY380625HEPEII30	Mario	Aguilar	Hernández	1938-06-25	M	AB+	5550716239	\N
WUOK951127MONVQDH2	Patricia	Alvarado	Mendoza	1995-11-27	F	O+	\N	paciente3122@example.com
XVIA210517MPZXIGN8	Lucía	Chávez	Reyes	2021-05-17	F	AB-	5570759335	paciente3123@example.com
REHW030402HERSAD41	Manuel	Flores	Gutiérrez	2003-04-02	M	O+	5578118689	paciente3124@example.com
IGIU560923XKYPWWE2	Fernando	Delgado	Ramos	1956-09-23	Intersex	\N	5538405887	paciente3125@example.com
GZDR741101MUOHEHM5	Yolanda	Peña	Pérez	1974-11-01	F	O-	5550962334	\N
RXTR410123XHHGGO77	Rodrigo	Cabrera	Reyes	1941-01-23	Intersex	A-	5535805829	paciente3127@example.com
QCJQ580825XRAKTKE5	Laura	Estrada	Cabrera	1958-08-25	Intersex	B-	5546422730	\N
QPBJ530717HEQUBI89	Roberto	Ortiz	Díaz	1953-07-17	M	O-	5594476337	paciente3129@example.com
OZBD551012XHAGONA4	Claudia	Reyes	Torres	1955-10-12	Intersex	O-	5517997057	paciente3130@example.com
XFPX210120XCHNFFU5	Mario	Vázquez	Medina	2021-01-20	Intersex	AB-	5519032221	\N
XCRM431224XNAPATT1	Ana	Medina	Cordero	1943-12-24	Intersex	B-	5572416858	paciente3132@example.com
MSQV600809XCUBLGT0	Arturo	Ruiz	Vázquez	1960-08-09	Intersex	B-	5574923081	paciente3133@example.com
LMLC010628MHSVAPK6	Diana	Peña	Jiménez	2001-06-28	F	AB-	5553396259	paciente3134@example.com
FPDK610829HFEOHPK2	Sergio	Salazar	Cordero	1961-08-29	M	AB+	5586171681	\N
PQDA550307XYLEJUU0	Diana	Morales	Rodríguez	1955-03-07	Intersex	A-	5583542113	paciente3136@example.com
MCJI540901XJABKO59	Teresa	Solís	Peña	1954-09-01	Intersex	\N	5515227911	\N
LYHA890430MFUAAN86	Gabriela	Alvarado	López	1989-04-30	F	B-	5532042042	\N
JQKB410728MCGMPES5	Karla	García	Herrera	1941-07-28	F	O+	5532008587	paciente3139@example.com
JIVM710517HJHDAEH2	Mario	Cabrera	Aguilar	1971-05-17	M	O+	5565835717	paciente3140@example.com
OSSP100423MTGIRGL9	Patricia	García	Estrada	2010-04-23	F	B+	5574268901	paciente3141@example.com
LBHU850328HCNUZW61	Carlos	Contreras	Díaz	1985-03-28	M	B-	5566409680	\N
DWTO670507HXBVJOZ5	José	Vázquez	Herrera	1967-05-07	M	B-	5540888850	\N
AJCR070508MZAQUJ92	Verónica	González	Cabrera	2007-05-08	F	AB+	\N	paciente3144@example.com
HRJH801209MEFDLYZ3	Verónica	Hernández	Salazar	1980-12-09	F	B+	5597682523	paciente3145@example.com
FZUT620801MTLKZOW5	Beatriz	Ortiz	Vázquez	1962-08-01	F	A-	5583506541	\N
IIHE680427XSPSEWA2	Miriam	Martínez	Guzmán	1968-04-27	Intersex	A+	5512370322	paciente3147@example.com
XNAB650304XULEBNH0	Mónica	Guzmán	Gómez	1965-03-04	Intersex	\N	5506977753	paciente3148@example.com
PGMX820414HJEDORV7	Javier	Castillo	Solís	1982-04-14	M	A+	5580436917	paciente3149@example.com
BYUR440329MNTCSC70	Leticia	Gómez	Salazar	1944-03-29	F	\N	5574552753	paciente3150@example.com
BFXG430626HHMYFRY4	Mario	Martínez	Sánchez	1943-06-26	M	O-	\N	paciente3151@example.com
RTHV401113HXCVHW14	Raúl	Guzmán	Reyes	1940-11-13	M	O+	5565716889	paciente3152@example.com
BCRL181222XLIALY54	Sofía	Jiménez	Martínez	2018-12-22	Intersex	B+	5503817174	paciente3153@example.com
FHEQ701015XLGHPHZ2	Leticia	Martínez	Guzmán	1970-10-15	Intersex	A-	\N	paciente3154@example.com
OFMN620902MTHDRWX8	Fernanda	Cruz	Hernández	1962-09-02	F	B-	5518625395	paciente3155@example.com
JFEI810807HGXJSBM4	Daniel	Torres	Fuentes	1981-08-07	M	A+	5592634448	\N
UQTM950624MACTHU37	Laura	Martínez	Gutiérrez	1995-06-24	F	A+	5575668073	paciente3157@example.com
DOQA840206XNLKBF14	Karla	Contreras	Martínez	1984-02-06	Intersex	AB-	5531464202	\N
MYOL870209MQCWGJO4	Fernanda	Ruiz	Cabrera	1987-02-09	F	B+	5576236966	paciente3159@example.com
ILTP500607MPYNPXQ0	Elena	Alvarado	García	1950-06-07	F	B+	5506925191	\N
EOVR700610XDUGMEQ8	Rodrigo	Alvarado	Gómez	1970-06-10	Intersex	O+	5546779338	\N
MVFV750618MMGVDIF3	Carmen	Hernández	Contreras	1975-06-18	F	B-	5503978514	paciente3162@example.com
MPPH230720HNRKFVP7	José	González	Delgado	2023-07-20	M	B+	5576115584	paciente3163@example.com
JAAQ470503XDCBLEF2	Silvia	Guzmán	Medina	1947-05-03	Intersex	B+	\N	paciente3164@example.com
ZDTR621021MMYMJLM3	Diana	Romero	Aguilar	1962-10-21	F	\N	5533107476	\N
ULHH080820HSNICIT1	Luis	López	Contreras	2008-08-20	M	A+	5557988027	paciente3166@example.com
FLCE960114HATQOLV4	Andrés	Estrada	Morales	1996-01-14	M	AB+	5500475870	paciente3167@example.com
OBGI750504HDDMGR01	Miguel	Herrera	\N	1975-05-04	M	O+	\N	paciente3168@example.com
ZORA130510HBZXKNC8	Carlos	Mendoza	Solís	2013-05-10	M	\N	5584196284	paciente3169@example.com
AXLP700129XSFHFVE8	Arturo	Torres	Aguilar	1970-01-29	Intersex	A-	5576853893	\N
OYRM180426MHDRUSL7	Patricia	Díaz	Ruiz	2018-04-26	F	\N	5585687967	paciente3171@example.com
MRQZ930321MBXQKX06	Miriam	Estrada	Peña	1993-03-21	F	B-	5563487864	paciente3172@example.com
CQJZ670610XEVXZMT1	Juan	Sánchez	Sánchez	1967-06-10	Intersex	O+	5505835957	paciente3173@example.com
FXOH911221XVRFOMB6	Juan	Fuentes	Ramírez	1991-12-21	Intersex	AB-	\N	\N
UTFM600409HDDTWRD9	Adrián	Peña	Guzmán	1960-04-09	M	B-	5506993232	paciente3175@example.com
IXBC640216MYSXPGH1	Paola	Reyes	Ramos	1964-02-16	F	O-	5502722163	paciente3176@example.com
HRSE490508MVOHHIB9	Gabriela	Solís	Estrada	1949-05-08	F	B-	5535469232	paciente3177@example.com
XNMH361120MSAOIEY6	Patricia	Torres	Delgado	1936-11-20	F	A-	5591228002	paciente3178@example.com
TZYV231028XGCJCOP3	María	Hernández	Romero	2023-10-28	Intersex	AB+	5539338189	\N
CWZV940323XKFHYQV8	Javier	Cordero	Vargas	1994-03-23	Intersex	AB-	5506713223	paciente3180@example.com
HJMJ160509XJHTAWF5	Elena	Martínez	Reyes	2016-05-09	Intersex	A-	5558332650	paciente3181@example.com
JUZR800528HTHUMJV9	Carlos	Gómez	González	1980-05-28	M	O+	5500679913	\N
LMCE910418XDVPJPI6	Elena	López	Martínez	1991-04-18	Intersex	AB-	5540688772	paciente3183@example.com
TWPW760613MBOGXJI1	Cecilia	Morales	Aguilar	1976-06-13	F	\N	5508931698	\N
LHWJ590208HEVUAK06	Rodrigo	Rojas	Delgado	1959-02-08	M	\N	\N	paciente3185@example.com
MLFT390704MYVWRAX3	Carmen	Flores	Chávez	1939-07-04	F	O+	5561004605	\N
BTZZ250611HRXPFMR6	Carlos	Cabrera	Ramos	2025-06-11	M	A+	5567520593	paciente3187@example.com
PXFH920812XSPIFI34	Diana	Ramos	Pérez	1992-08-12	Intersex	A+	5589199597	paciente3188@example.com
VLMG871003MXDZMAN2	Alejandra	Pérez	Ortiz	1987-10-03	F	\N	5589489789	paciente3189@example.com
WLEQ630905XREQAV72	Carmen	Rojas	Jiménez	1963-09-05	Intersex	A-	\N	\N
EBAU940525XEYSYW79	Carmen	López	Cruz	1994-05-25	Intersex	O+	5569808782	paciente3191@example.com
SOVQ730211HXKUBY11	Alejandro	Aguilar	García	1973-02-11	M	AB+	\N	\N
XRWQ660427HVWUCNL6	Carlos	Contreras	Fuentes	1966-04-27	M	AB+	5598742233	paciente3193@example.com
CCOS891115XXYKJTX7	Lucía	Ortiz	Gutiérrez	1989-11-15	Intersex	O-	5517049441	paciente3194@example.com
VURY640126HGCHED71	Roberto	Sánchez	González	1964-01-26	M	AB+	5504915610	paciente3195@example.com
VLCN791005MJXBUNS0	Patricia	Alvarado	Aguilar	1979-10-05	F	O+	5544512827	paciente3196@example.com
RCDN700107HNZYJZ42	Andrés	Torres	Fuentes	1970-01-07	M	B+	5532595748	paciente3197@example.com
SSYG940309HHILZRL3	Gerardo	Jiménez	Rojas	1994-03-09	M	\N	5587169467	paciente3198@example.com
TUFJ580602MUZONQC7	Elena	Peña	Ramírez	1958-06-02	F	A+	5597513154	paciente3199@example.com
GVNA160531MNETJWR4	Paola	Cordero	Cruz	2016-05-31	F	AB-	5527245576	paciente3200@example.com
JQSH690922XVGWHMN9	Patricia	Rojas	Rodríguez	1969-09-22	Intersex	AB+	5514471599	paciente3201@example.com
KTLW010323MTMCIB37	Lucía	González	Solís	2001-03-23	F	B+	\N	paciente3202@example.com
AKHL511214HETHFE36	Emilio	Cruz	Torres	1951-12-14	M	AB-	5505721864	paciente3203@example.com
MTCO510720XZISSHR5	Sergio	Ramírez	Pérez	1951-07-20	Intersex	A+	5591805547	\N
PHZW780406XAUEZS02	Carmen	Romero	Salazar	1978-04-06	Intersex	O+	5563364097	paciente3205@example.com
ZRRF581005XYYNHDB9	Carmen	Flores	Flores	1958-10-05	Intersex	AB+	5572540774	paciente3206@example.com
QEAI480324XGFQCE37	Rosa	González	Romero	1948-03-24	Intersex	A-	5577427894	\N
OLQZ130422XCIAWMU0	Daniela	Salazar	Díaz	2013-04-22	Intersex	B-	5595316470	paciente3208@example.com
GWIB950520XPUUUGL8	Arturo	Salazar	Contreras	1995-05-20	Intersex	B+	5588932281	paciente3209@example.com
RDSI411010MBGGIS47	Ana	López	Cruz	1941-10-10	F	B-	5593367835	paciente3210@example.com
PUQD881210MGQVZEO1	Alejandra	Díaz	Fuentes	1988-12-10	F	O-	5576475833	paciente3211@example.com
QFFO440710MAMVUS47	Adriana	Herrera	Flores	1944-07-10	F	AB-	5508429850	paciente3212@example.com
CVBX770514MVINZHY3	Guadalupe	Solís	Alvarado	1977-05-14	F	A+	5515461214	paciente3213@example.com
UNVO670227HGDVSIH9	Rodrigo	Gómez	Fuentes	1967-02-27	M	B+	5526511858	\N
UYUF960829HDVWXU80	José	Gómez	Pérez	1996-08-29	M	AB+	\N	paciente3215@example.com
JXHK610210XXXTPZO0	Manuel	Hernández	Salazar	1961-02-10	Intersex	\N	\N	paciente3216@example.com
WKRJ880525HLNGFVQ5	Raúl	Morales	Rodríguez	1988-05-25	M	B+	5553606568	\N
QYLV711015MFDOWPL9	Mónica	Solís	\N	1971-10-15	F	AB+	5529234671	paciente3218@example.com
OJHA130223MVOMXVY7	Daniela	González	Morales	2013-02-23	F	B+	5501847669	paciente3219@example.com
OCEI230819XBRIVPY5	Rodrigo	Morales	Aguilar	2023-08-19	Intersex	A+	5556224718	\N
UJUH530602XODBJWU8	Cecilia	Herrera	González	1953-06-02	Intersex	A+	5596007507	paciente3221@example.com
COQA110420XNNPOJ61	Adrián	Ramos	Cruz	2011-04-20	Intersex	\N	5530163684	\N
RSDH180519MKKTYX15	Araceli	Reyes	Alvarado	2018-05-19	F	AB-	5528781841	paciente3223@example.com
BFMY800117MPBZTJ01	Fernanda	Gómez	Reyes	1980-01-17	F	\N	5571641814	paciente3224@example.com
VHNG730301HYEEQAK9	Alejandro	Cabrera	Cruz	1973-03-01	M	AB-	5580134720	paciente3225@example.com
PLCT901228MNLGOM30	Paola	Reyes	Alvarado	1990-12-28	F	A-	5527499143	paciente3226@example.com
HARU941226HGGMYBG4	Andrés	Vargas	García	1994-12-26	M	AB+	5571511888	paciente3227@example.com
FJXQ590326XTCHMBT3	Eduardo	Rojas	Flores	1959-03-26	Intersex	AB-	5557663940	paciente3228@example.com
IWQF550313XPOLSJ29	Alejandro	Rojas	Medina	1955-03-13	Intersex	A+	5570192467	paciente3229@example.com
PDWC030831MTGKDOB8	Paola	Peña	Vázquez	2003-08-31	F	AB-	5565081703	paciente3230@example.com
ERDN991130MSIKHZ84	Fernanda	González	Flores	1999-11-30	F	B-	5527244753	paciente3231@example.com
XEVB631221XCJQETK3	Verónica	Vargas	Delgado	1963-12-21	Intersex	AB-	5525996865	\N
LKQM890902MLDCLAP5	María	Sánchez	Pérez	1989-09-02	F	B-	5518006605	paciente3233@example.com
DGNA680512XBRZIXN8	Silvia	Guzmán	Gómez	1968-05-12	Intersex	O+	5563993782	paciente3234@example.com
TVTX240714HPVQOFE9	Fernando	Delgado	Sánchez	2024-07-14	M	O-	5530916516	paciente3235@example.com
KPVB071117HATGKQ21	Alejandro	Guzmán	Chávez	2007-11-17	M	AB-	5520055501	paciente3236@example.com
UKFS200817MTYIEHI5	Rosa	Delgado	\N	2020-08-17	F	B-	5533492321	paciente3237@example.com
QVUG960115XHWAGME3	Andrés	Morales	Cruz	1996-01-15	Intersex	A+	5576904744	paciente3238@example.com
XQDD681216XAXOUX90	Carmen	Jiménez	\N	1968-12-16	Intersex	\N	5567845334	paciente3239@example.com
JHOB791010HYCVCQC3	Rodrigo	Reyes	Contreras	1979-10-10	M	A-	5561363750	paciente3240@example.com
ZZDM161227MHZXVY48	Guadalupe	Jiménez	Mendoza	2016-12-27	F	B+	5557362530	\N
OHFE100805XMTTEOI8	Sofía	Ramírez	García	2010-08-05	Intersex	AB-	\N	\N
PKCC610707MAYFSHQ0	Diana	García	\N	1961-07-07	F	AB+	5578956459	paciente3243@example.com
GBHF191229XSEZRJT2	Fernanda	Pérez	Vargas	2019-12-29	Intersex	A+	5584332133	paciente3244@example.com
KMAG691231HAYETGA9	Óscar	Hernández	Flores	1969-12-31	M	B-	5572020752	\N
CQNA060923XNWFHUH4	Eduardo	Chávez	Estrada	2006-09-23	Intersex	A-	5544373053	paciente3246@example.com
ABXS040717XPMYHYL5	Emilio	Ramírez	Romero	2004-07-17	Intersex	A+	5539767488	\N
PLYM050105XTJCZJP1	Francisco	Díaz	García	2005-01-05	Intersex	B+	\N	\N
TLHW110324XYGXOD69	Verónica	Guzmán	Gutiérrez	2011-03-24	Intersex	B+	5528408885	paciente3249@example.com
KECE551213HYBBJUF6	Arturo	García	Fuentes	1955-12-13	M	B+	5551559648	paciente3250@example.com
AHTL840307HXBXVR98	Francisco	Ramírez	Herrera	1984-03-07	M	\N	5535940216	paciente3251@example.com
UMGV950104XWMEEIS6	Luis	Alvarado	Jiménez	1995-01-04	Intersex	A+	5555615772	paciente3252@example.com
OIWR131120HJOTVF30	Ricardo	Ruiz	Guzmán	2013-11-20	M	B-	5544617353	paciente3253@example.com
XVAN810107MXWPJAE2	Miriam	Medina	Ortiz	1981-01-07	F	AB+	\N	paciente3254@example.com
OYCD380324MANJQBJ3	Cecilia	Hernández	\N	1938-03-24	F	A+	5586998008	paciente3255@example.com
JMVK710717HICWCFR2	Manuel	Herrera	Solís	1971-07-17	M	A+	5506913821	paciente3256@example.com
CRNN640121HOQEGZ07	Rodrigo	Peña	Cruz	1964-01-21	M	B-	5576594863	paciente3257@example.com
SXOD951007MCYQTPI4	Leticia	Cordero	Ruiz	1995-10-07	F	\N	5587063378	paciente3258@example.com
GFMX610108MQDHNCV9	Karla	Cruz	Vargas	1961-01-08	F	A-	5507620282	paciente3259@example.com
KWTN370208XFXICUP2	Juan	Guzmán	Delgado	1937-02-08	Intersex	B+	5512314142	\N
YKXY391101MVZDIHT3	Rosa	Cruz	Torres	1939-11-01	F	\N	5550086992	paciente3261@example.com
SJYT930616MYZVYE83	Ana	Hernández	González	1993-06-16	F	B+	5528352706	\N
PMJE510126MHMTDPC3	Cecilia	Cordero	Estrada	1951-01-26	F	A+	5523417792	paciente3263@example.com
FJKT921224XMATADK7	Jorge	Rodríguez	López	1992-12-24	Intersex	O-	5509840270	paciente3264@example.com
DCYZ100625XTYTPD48	Javier	Morales	Ruiz	2010-06-25	Intersex	AB+	5556156368	paciente3265@example.com
AJYK670903MMSMAY02	Mónica	Aguilar	Ramos	1967-09-03	F	\N	5567492818	paciente3266@example.com
WNHL430821MYJGDHP1	Ana	González	Morales	1943-08-21	F	O-	5570645478	paciente3267@example.com
AISP500707HTWCAHC3	Mario	Cabrera	Cabrera	1950-07-07	M	A-	5599161850	\N
JATG020825MYAWYK47	Fernanda	Vargas	Alvarado	2002-08-25	F	AB+	5514069260	\N
PIBR370112MQVKDOT4	Patricia	Salazar	Ruiz	1937-01-12	F	B+	5513882582	paciente3270@example.com
GHRY840626XBMYDP49	Iván	Ramos	Jiménez	1984-06-26	Intersex	\N	5543810063	\N
OZMD230326MIAVIQ18	Teresa	Solís	Ruiz	2023-03-26	F	AB-	5569073382	paciente3272@example.com
DITX160201HQTEDVY8	Andrés	Gómez	Peña	2016-02-01	M	B-	5598947939	paciente3273@example.com
MTAU440817XNUDAT10	Sergio	Aguilar	Torres	1944-08-17	Intersex	A-	5582238223	paciente3274@example.com
WBKT840106MEYUKAE8	Alejandra	Chávez	Ramírez	1984-01-06	F	\N	5506965776	paciente3275@example.com
DGAQ830608XUIQGT52	Teresa	Contreras	Medina	1983-06-08	Intersex	O+	5566329568	paciente3276@example.com
YHMO570531MUANXC55	Sofía	Vargas	Delgado	1957-05-31	F	O+	\N	paciente3277@example.com
RRAC070507XLGCLAA5	Leticia	Gutiérrez	Torres	2007-05-07	Intersex	\N	5534858425	paciente3278@example.com
QJGZ401028HOMADY73	Alejandro	González	Vargas	1940-10-28	M	A+	5579816953	paciente3279@example.com
SGYV570706MNBIYWL5	Patricia	Torres	Romero	1957-07-06	F	O+	5501939589	paciente3280@example.com
FIJZ610729XLPWJHT2	Elena	Medina	Reyes	1961-07-29	Intersex	B-	5512286952	paciente3281@example.com
BNER380509XMRZLEG0	Sergio	Solís	Rodríguez	1938-05-09	Intersex	O+	5535901325	paciente3282@example.com
CZIQ540211MEEIYGB2	María	Cordero	Ortiz	1954-02-11	F	B-	5588855739	paciente3283@example.com
RLLB250124XEVMFYX9	Guadalupe	Díaz	Castillo	2025-01-24	Intersex	O-	5535395956	paciente3284@example.com
HNWP200319HTRZQTN7	Sergio	Flores	Guzmán	2020-03-19	M	A-	5501527737	\N
RPRS010124XALESD84	Cecilia	Pérez	Gutiérrez	2001-01-24	Intersex	B+	\N	\N
EKOG791209HDGAFFB3	Ricardo	Chávez	Contreras	1979-12-09	M	AB-	5535405334	paciente3287@example.com
XLVB770105HWNBTXO3	Pablo	Rodríguez	Contreras	1977-01-05	M	AB-	\N	paciente3288@example.com
WXCX620114MJMKIRG9	Rosa	Chávez	Ramírez	1962-01-14	F	A-	5520615250	\N
OSKA611103HJOUWBA6	Sergio	Guzmán	Medina	1961-11-03	M	A+	5501775917	paciente3290@example.com
FGSZ711125XHNAWJR7	Sofía	Delgado	\N	1971-11-25	Intersex	O+	5506605796	paciente3291@example.com
CXDF030822HXKSQFI1	Raúl	Vázquez	Salazar	2003-08-22	M	\N	5587016244	\N
PAHI060608HARVJT48	Roberto	Estrada	Pérez	2006-06-08	M	B-	5550274393	paciente3293@example.com
XMLI640527XKSIRA02	Leticia	Sánchez	Rodríguez	1964-05-27	Intersex	O+	5552795860	paciente3294@example.com
WHZA660104MEBZNY92	Guadalupe	Estrada	Solís	1966-01-04	F	A+	\N	\N
GISO150927XQKOKEO2	Daniel	Ramos	Salazar	2015-09-27	Intersex	AB+	5503821186	\N
KCHB540802MSYUSTZ2	Carmen	López	Mendoza	1954-08-02	F	B+	5564977070	\N
EPIE960201MDMSDSW7	Fernanda	Gómez	Ruiz	1996-02-01	F	B-	5541904549	\N
EJBU710209MTQQMZ16	Gabriela	Rojas	Cruz	1971-02-09	F	O-	5518700749	paciente3299@example.com
RBEB170716XGDLLN37	Mónica	García	\N	2017-07-16	Intersex	B-	5563592444	paciente3300@example.com
OQQS980327MDZKZLP9	Araceli	Martínez	Chávez	1998-03-27	F	\N	5575142580	paciente3301@example.com
GYPX550903MGZNAAG4	Patricia	Flores	García	1955-09-03	F	B-	5532329142	paciente3302@example.com
SKHQ610410HJGAPC64	Alejandro	Rodríguez	Vázquez	1961-04-10	M	AB+	5590351490	paciente3303@example.com
GMXB740903HZLWPED7	Adrián	Jiménez	Reyes	1974-09-03	M	A-	\N	paciente3304@example.com
FHQN640528XLREMHB1	Silvia	Romero	Romero	1964-05-28	Intersex	AB+	5580303879	paciente3305@example.com
XLJY250119MPLLCKZ9	Verónica	Castillo	Ortiz	2025-01-19	F	\N	5522991812	paciente3306@example.com
OPWA180227XCSWQF57	José	Estrada	Cabrera	2018-02-27	Intersex	O-	5556785876	paciente3307@example.com
IJDL600627HMLOJG45	Luis	Vargas	Ortiz	1960-06-27	M	\N	5581328180	paciente3308@example.com
IKOG651107HKFMIB21	Andrés	Mendoza	Díaz	1965-11-07	M	B+	5591310465	\N
IZGC961210MUFSBH72	Guadalupe	Torres	Torres	1996-12-10	F	AB+	5529472992	paciente3310@example.com
BTLD670103HCGVTCL2	Francisco	Vargas	\N	1967-01-03	M	A+	5561584251	\N
HDRK110815XQGCWYN2	Silvia	Guzmán	Gómez	2011-08-15	Intersex	AB-	5503409718	\N
UYOU120918XIQXDR33	Rodrigo	Gutiérrez	Castillo	2012-09-18	Intersex	O-	5585297642	paciente3313@example.com
KDSE760526XMCPWVW8	Arturo	Cordero	Aguilar	1976-05-26	Intersex	AB+	5527429003	paciente3314@example.com
CDDD791025HPBJAJ58	Roberto	Sánchez	\N	1979-10-25	M	AB-	5548052170	\N
CNVH690511MDNESK61	Adriana	Cabrera	Hernández	1969-05-11	F	O+	5577196767	paciente3316@example.com
IRKR890524MVXYQRS4	Ana	Castillo	Hernández	1989-05-24	F	B+	5545049886	\N
DFNK970516MFPNNOP1	Adriana	Medina	Ortiz	1997-05-16	F	B-	5554178321	\N
AMGJ920710MKQVKN57	Elena	Rodríguez	Herrera	1992-07-10	F	O-	\N	paciente3319@example.com
FJFG980731MLTFQQ40	Rosa	Salazar	Reyes	1998-07-31	F	O+	5551362725	paciente3320@example.com
IAWR690625MIXQOIJ6	Laura	Medina	González	1969-06-25	F	O-	5547121627	paciente3321@example.com
BAND380215XDUVTZO6	Roberto	Reyes	Gómez	1938-02-15	Intersex	\N	5529748023	\N
IVLT690321MNHZRG74	Verónica	Reyes	Herrera	1969-03-21	F	AB+	\N	\N
KKND970425HGZTNYD4	Roberto	Peña	Sánchez	1997-04-25	M	AB-	5510424258	\N
ZZKP031029MCONRZX3	Rosa	Delgado	Morales	2003-10-29	F	\N	5549940847	paciente3325@example.com
ATEP791119HOXCJAB4	Raúl	Peña	Cruz	1979-11-19	M	AB+	5508798173	paciente3326@example.com
ILFD120520XMJFUBF1	Laura	Ramos	Ramos	2012-05-20	Intersex	\N	\N	\N
RUKE690307XCXCUEH5	Diana	Cordero	Torres	1969-03-07	Intersex	B+	5533381798	\N
OAMT831106MUBWZKO3	Daniela	Delgado	Rodríguez	1983-11-06	F	AB-	\N	\N
ZZWN781101XXKCIUN6	Raúl	Aguilar	Peña	1978-11-01	Intersex	B+	5596905452	\N
FKRZ140802HIAJZP00	Pablo	Delgado	Guzmán	2014-08-02	M	\N	5530735460	\N
PZNQ681028MLYMIIJ5	Silvia	Contreras	Hernández	1968-10-28	F	B-	5533488695	paciente3332@example.com
TONI660118XMLGCW55	Carlos	García	García	1966-01-18	Intersex	B-	5527423341	paciente3333@example.com
PAHO680810HKFMTZ08	Javier	Reyes	Reyes	1968-08-10	M	B-	5539169139	\N
MMCM820415XGTQIQG1	Cecilia	Estrada	Ramírez	1982-04-15	Intersex	AB-	5525125748	\N
BUMH681113MTQDUQA8	Carmen	Vázquez	Alvarado	1968-11-13	F	B-	5520609939	paciente3336@example.com
XISY740511MYGKYAZ1	Guadalupe	Hernández	Salazar	1974-05-11	F	AB-	5538207511	\N
NWRD720915XAHFBEK4	Teresa	Alvarado	Vargas	1972-09-15	Intersex	O+	\N	\N
KYWJ430912HGCEIU07	Javier	Pérez	Solís	1943-09-12	M	B+	\N	\N
RDJC850701XDSLQOO6	Daniel	García	Reyes	1985-07-01	Intersex	O+	5563405130	\N
OSDQ081212MFHHDN51	Verónica	Jiménez	Vázquez	2008-12-12	F	AB+	5599681754	paciente3341@example.com
HHLE610709HVDKMBJ3	Manuel	Ortiz	Cordero	1961-07-09	M	A+	5574687927	\N
WLWZ070108MXSOTO80	Sofía	González	Hernández	2007-01-08	F	\N	5541786793	paciente3343@example.com
XTSV590705HKZPFAI0	Fernando	Estrada	Gutiérrez	1959-07-05	M	A-	5521048114	paciente3344@example.com
ZSXH490904XHCGQNM4	Alejandra	Pérez	Fuentes	1949-09-04	Intersex	A+	5552493710	paciente3345@example.com
KWDA430510HHUAZC04	Sergio	Castillo	Salazar	1943-05-10	M	O+	5503976211	paciente3346@example.com
QSCD031017XJUQECH2	Juan	Alvarado	Díaz	2003-10-17	Intersex	O+	5544185016	paciente3347@example.com
TLPX710610XKMQCCO4	Daniel	Pérez	Martínez	1971-06-10	Intersex	A-	\N	\N
HTEX730408HQUEYFN5	Andrés	Jiménez	Torres	1973-04-08	M	AB+	5572624719	paciente3349@example.com
VOXG851202HARPWEQ0	Daniel	Rodríguez	Flores	1985-12-02	M	A-	5580025406	paciente3350@example.com
LCPE871102XPXPWKO2	Alejandra	Aguilar	Contreras	1987-11-02	Intersex	O-	5536556441	\N
AGRF700524HIAHBSK2	José	Martínez	Mendoza	1970-05-24	M	\N	5543644566	\N
SKRB870626XXJYTIB6	Cecilia	Cordero	\N	1987-06-26	Intersex	AB+	5544651571	paciente3353@example.com
EQQG370513XZISVE84	Manuel	Jiménez	García	1937-05-13	Intersex	B+	5507429828	\N
BACA230113XKNQSP49	Guadalupe	Delgado	Díaz	2023-01-13	Intersex	O+	5564964422	paciente3355@example.com
ZFWQ710416HNSPSZ39	Emilio	Castillo	Herrera	1971-04-16	M	A-	5585963572	\N
LWOS220930XJRCKOU8	Roberto	Pérez	Castillo	2022-09-30	Intersex	O-	5501544751	\N
RIQB630309MWBEZAO2	Paola	Reyes	Cabrera	1963-03-09	F	\N	5507896178	paciente3358@example.com
VBTW920408HDZLXL23	Pablo	Cruz	Ramírez	1992-04-08	M	A+	5522326017	paciente3359@example.com
YGFB790112MTSUCER2	Patricia	Castillo	Herrera	1979-01-12	F	A-	5539061845	paciente3360@example.com
GAEW820918XWGVXSS8	María	Cruz	Ruiz	1982-09-18	Intersex	B+	5571467339	paciente3361@example.com
DQGF220306HPIAZGH6	Andrés	Cruz	Vargas	2022-03-06	M	B+	5574341881	paciente3362@example.com
VYLC510104MLBEDQZ4	Yolanda	Solís	Alvarado	1951-01-04	F	B-	5521941517	paciente3363@example.com
ARLJ701229HAUZHBM2	Arturo	Romero	Cordero	1970-12-29	M	B-	5555995397	\N
UNWY250617XJEATFJ5	Silvia	Chávez	Martínez	2025-06-17	Intersex	AB-	5596707106	paciente3365@example.com
HUZA620825HHEFGVK3	Adrián	Rodríguez	Pérez	1962-08-25	M	B-	5533745365	paciente3366@example.com
FCMH490214HQFIKSY2	Roberto	Guzmán	Rodríguez	1949-02-14	M	A+	5539724843	paciente3367@example.com
WBZO910828XSGSCAW1	Elena	Hernández	Delgado	1991-08-28	Intersex	B-	5571081653	paciente3368@example.com
LUGU560428MEBWTF93	Silvia	Fuentes	González	1956-04-28	F	B-	5524950152	paciente3369@example.com
QNDU020221XKOVOZN2	Patricia	García	Romero	2002-02-21	Intersex	B+	5596492896	\N
ADFW800129XNMSXTM0	Gabriela	Cordero	Romero	1980-01-29	Intersex	O+	5576424944	\N
GEKL451014XCFMMZE7	Eduardo	Fuentes	Medina	1945-10-14	Intersex	\N	5572972136	paciente3372@example.com
ESMH370302HCNLBDL4	Javier	Castillo	Flores	1937-03-02	M	O+	5503417609	paciente3373@example.com
QMJA060423HIOAIEC8	Adrián	Rojas	Peña	2006-04-23	M	AB+	5547863594	\N
TJDK901217XHVKIGH8	Karla	González	Ramírez	1990-12-17	Intersex	AB-	5505098221	paciente3375@example.com
FIAW100303HYQJUA54	Rodrigo	Mendoza	Jiménez	2010-03-03	M	A-	5541623252	paciente3376@example.com
GGEE400903MPNAGSL1	Gabriela	Martínez	Sánchez	1940-09-03	F	O-	5565806438	paciente3377@example.com
NMWH800401MDQVAK63	Diana	González	Delgado	1980-04-01	F	O+	5569046350	paciente3378@example.com
THOO950605HLHGLTQ0	Rodrigo	Rodríguez	Fuentes	1995-06-05	M	B-	5533243350	paciente3379@example.com
XQTA060304XFKIPXF2	Teresa	Ortiz	Reyes	2006-03-04	Intersex	AB-	5506644856	paciente3380@example.com
XQLW900103XKDEPYD1	Karla	Aguilar	Flores	1990-01-03	Intersex	O-	5536063705	paciente3381@example.com
CIFH690831MWRNCJU0	Daniela	Ramos	Díaz	1969-08-31	F	B+	5582258140	\N
VJXJ220815HXFVRD04	Carlos	Sánchez	Ruiz	2022-08-15	M	B-	5508106355	\N
ILKN620219MLRFJP08	Carmen	Cruz	Ortiz	1962-02-19	F	A+	5558459722	\N
NQJV130307HSNPOP11	Carlos	Pérez	Martínez	2013-03-07	M	A+	\N	paciente3385@example.com
LVYO940804MTJXHDM6	Fernanda	Reyes	Ramos	1994-08-04	F	AB+	5511625352	\N
FSUC900119XRPUSG35	Miriam	Jiménez	Salazar	1990-01-19	Intersex	A-	5572751315	paciente3387@example.com
QSIP490217MVOVRKT0	Patricia	Martínez	Vázquez	1949-02-17	F	AB-	5553934112	paciente3388@example.com
RKBM520524MSMOWEA6	Gabriela	Romero	Cordero	1952-05-24	F	B+	5505503750	\N
BIPQ581017XOVCEH42	Emilio	García	Rojas	1958-10-17	Intersex	\N	5535768564	\N
SUSB490115MTKJPC57	Sofía	Vázquez	Peña	1949-01-15	F	B+	5516867448	paciente3391@example.com
AARA861216MIJGLX83	Laura	Ramos	Cordero	1986-12-16	F	B-	5510067076	\N
ABUZ051024XWOUGIF5	Daniela	Torres	Mendoza	2005-10-24	Intersex	A+	5521281330	paciente3393@example.com
BRPW480121MLYGOJG2	Adriana	Herrera	Salazar	1948-01-21	F	AB+	\N	paciente3394@example.com
CQSU910211MVIEYAY2	Cecilia	Vargas	Medina	1991-02-11	F	B+	5578202825	paciente3395@example.com
GZRJ970807MQBHAFW1	Sofía	Chávez	Martínez	1997-08-07	F	B-	5516195467	\N
LVBO760916XCYCGQM5	José	Ortiz	Rodríguez	1976-09-16	Intersex	O-	5535476584	paciente3397@example.com
JYWX460308XONFANO4	Elena	Salazar	Chávez	1946-03-08	Intersex	\N	5573702197	paciente3398@example.com
XCPF980709HZVFLLH4	Raúl	Torres	Romero	1998-07-09	M	B-	5585018299	paciente3399@example.com
BFMH151214HSVBAVG9	Andrés	Pérez	\N	2015-12-14	M	O+	5539488340	paciente3400@example.com
PCRO661106XFZTPBM4	Luis	Alvarado	Vargas	1966-11-06	Intersex	B-	\N	paciente3401@example.com
IMVY030417XSJUGT44	Ana	Flores	Flores	2003-04-17	Intersex	A+	5577983042	\N
FCGW040319MBCSGRY8	Claudia	Medina	Morales	2004-03-19	F	A+	5572356119	paciente3403@example.com
ESOR901202HREHLKN1	Fernando	Rodríguez	Chávez	1990-12-02	M	\N	5544469048	paciente3404@example.com
NRUQ161117MBDPOCD8	Fernanda	Morales	Rojas	2016-11-17	F	AB+	5565406500	\N
BPOD570421MIECWAU4	Fernanda	Gutiérrez	Gutiérrez	1957-04-21	F	A-	5513718349	paciente3406@example.com
DBWR701127XBOORL65	Adriana	Cabrera	Cruz	1970-11-27	Intersex	O-	5528921769	paciente3407@example.com
PQNE020407HNINZCZ1	Adrián	Jiménez	Reyes	2002-04-07	M	B-	5501860503	paciente3408@example.com
PRYM661128HCDWIA36	Mario	Peña	\N	1966-11-28	M	AB-	\N	paciente3409@example.com
MGPJ131219XVNZJMJ2	Adrián	Martínez	\N	2013-12-19	Intersex	B-	\N	paciente3410@example.com
SXHX500731MRXGXVU9	Daniela	Flores	Salazar	1950-07-31	F	A-	\N	paciente3411@example.com
SELP721022MKDDOCQ4	Silvia	Vargas	González	1972-10-22	F	O+	5542875673	paciente3412@example.com
MMAF840105HOTCVE01	Rodrigo	Rodríguez	Sánchez	1984-01-05	M	B-	5598569103	paciente3413@example.com
GJUK031229HGYSGD44	Manuel	Salazar	Hernández	2003-12-29	M	A+	5565981157	paciente3414@example.com
VOVQ501209XUTKHOJ8	Silvia	Pérez	Aguilar	1950-12-09	Intersex	O+	5539682481	paciente3415@example.com
CCVK060318XXQFKB84	Beatriz	Gómez	Rodríguez	2006-03-18	Intersex	A-	5521121828	paciente3416@example.com
OBUV461004HKJHGFF2	Daniel	Rodríguez	Gutiérrez	1946-10-04	M	B-	5554324439	\N
AKXA151120HRSRWVR0	Sergio	Medina	Cordero	2015-11-20	M	\N	5516723369	\N
CKZG920308HJUGLN49	Rodrigo	López	Medina	1992-03-08	M	B+	\N	\N
ILKN851114XGZPRYC1	José	Peña	Rodríguez	1985-11-14	Intersex	\N	5515130063	\N
SSFM420910XZEVZHY1	Emilio	Rodríguez	Cordero	1942-09-10	Intersex	\N	5557977642	\N
SWAU430922XUJOLLK3	Paola	Medina	Vargas	1943-09-22	Intersex	O+	5535012329	\N
ITHI530511HDULVQJ2	Pablo	Rodríguez	Flores	1953-05-11	M	O-	5515110880	paciente3423@example.com
ZLTZ890317XWHKMDR0	Claudia	Ramos	Aguilar	1989-03-17	Intersex	O+	5514528606	paciente3424@example.com
PXAP020323HITVXKL2	Pablo	Pérez	Gutiérrez	2002-03-23	M	B+	5594989763	paciente3425@example.com
CWNK991025MVROAXE5	María	Hernández	Cabrera	1999-10-25	F	A+	5550635416	paciente3426@example.com
KMOY980607XLUSQVE8	Hugo	Jiménez	\N	1998-06-07	Intersex	AB+	5524335085	\N
UWDM421116HENXZT75	Miguel	Contreras	Medina	1942-11-16	M	A+	5505660599	paciente3428@example.com
SOYI191219XMLMGU72	Roberto	Cruz	Cordero	2019-12-19	Intersex	B-	5502876197	paciente3429@example.com
ZDAE750304MUBRPWT0	Carmen	Fuentes	Medina	1975-03-04	F	A+	5599365003	\N
KQIE110618HFAQUMW2	Javier	Chávez	Salazar	2011-06-18	M	O+	5548602563	paciente3431@example.com
SBVT901205XOEOHF65	Jorge	Pérez	Solís	1990-12-05	Intersex	B-	5577974840	paciente3432@example.com
TQEO380905HENZAMV7	Gerardo	Gómez	Pérez	1938-09-05	M	AB+	5599672824	\N
BIFQ800419XRPQVTK5	Karla	Peña	Castillo	1980-04-19	Intersex	\N	5572419541	paciente3434@example.com
MOFZ740824MRSELP15	Ana	Guzmán	Castillo	1974-08-24	F	B-	5514659983	\N
FDRS050318HHDULVP0	Juan	Estrada	Ruiz	2005-03-18	M	B-	5565483388	\N
LCQV100306MNTOXK06	Laura	Estrada	Ortiz	2010-03-06	F	AB-	5575240975	paciente3437@example.com
IPIV050204HVSLBBT4	Pablo	Reyes	Cabrera	2005-02-04	M	O-	5550060307	paciente3438@example.com
MHIQ571126XMCKXNU8	Paola	Estrada	Reyes	1957-11-26	Intersex	\N	5593404869	paciente3439@example.com
OQPA240405HHVGBYF4	Javier	Torres	Guzmán	2024-04-05	M	O-	5526060682	paciente3440@example.com
UMPA010320XYKPZJK0	Jorge	Guzmán	Romero	2001-03-20	Intersex	B-	\N	\N
UENA780503HWMFBDH9	Mario	García	González	1978-05-03	M	O+	5588709090	paciente3442@example.com
NHWI491122HLMJKBQ0	Antonio	Cruz	Solís	1949-11-22	M	AB-	5542592202	\N
PNIV230530HHKSGEX6	Andrés	Cordero	Ramírez	2023-05-30	M	O-	5583701577	paciente3444@example.com
DJWK120202HXSQJV74	Óscar	Romero	Alvarado	2012-02-02	M	AB-	5569361756	paciente3445@example.com
YIVD461124HLKVACS5	Hugo	Solís	González	1946-11-24	M	AB-	\N	\N
HOKS680329HCDUFQ01	Diego	Rodríguez	Morales	1968-03-29	M	A-	5588395570	\N
XWXL700126HSJFLWP5	Carlos	Alvarado	Peña	1970-01-26	M	A+	5537094206	paciente3448@example.com
IARA390826XXSSKRJ8	Adriana	Chávez	Díaz	1939-08-26	Intersex	A+	5554963083	paciente3449@example.com
RQHG150724XRUSKHT9	María	Guzmán	Ramos	2015-07-24	Intersex	O-	5526398649	\N
OKKJ240824MLGRRFJ3	Mónica	Delgado	Rojas	2024-08-24	F	B+	\N	\N
PJGQ961220HENPQE92	Gerardo	Medina	Cabrera	1996-12-20	M	AB-	5587680798	paciente3452@example.com
JNSF151218HSTHGU66	Emilio	Ruiz	Jiménez	2015-12-18	M	A-	5587236362	paciente3453@example.com
SRCD540416XUILPL77	Paola	Medina	Cordero	1954-04-16	Intersex	A-	5568805074	paciente3454@example.com
QXOX380727HCZAUBB3	Ricardo	Gómez	González	1938-07-27	M	O+	5535275172	paciente3455@example.com
YWQH810727HNYBWVC2	Miguel	Díaz	Salazar	1981-07-27	M	\N	5555828146	paciente3456@example.com
CRSD221214MGQRPYI1	Yolanda	Flores	Guzmán	2022-12-14	F	AB-	5583606966	paciente3457@example.com
SJTH810707XCOGGEI0	Silvia	Díaz	Fuentes	1981-07-07	Intersex	AB+	5548072743	paciente3458@example.com
ZYEQ481129XPXIWHS2	Daniela	Mendoza	Vázquez	1948-11-29	Intersex	O+	5550240905	\N
OZHL481224XATFUML5	Fernando	Ortiz	Morales	1948-12-24	Intersex	A+	5575154188	paciente3460@example.com
CGNY121205XUCGTSK3	Eduardo	Medina	Hernández	2012-12-05	Intersex	A+	5598744512	\N
RNNA521024MOWMJJI0	Cecilia	García	Vargas	1952-10-24	F	AB-	\N	paciente3462@example.com
XHHC110930HFRTSQU1	Óscar	Mendoza	Peña	2011-09-30	M	O-	5560542311	paciente3463@example.com
QTIM390122MMWPJMU5	Patricia	Ruiz	Díaz	1939-01-22	F	O+	5551943425	\N
XYCC930115HLJZSI25	Óscar	Chávez	Fuentes	1993-01-15	M	O+	5565342542	paciente3465@example.com
AFSP871212XUXWXJ90	Verónica	Martínez	Cruz	1987-12-12	Intersex	B-	5568733520	\N
BVTO180206XNGBFQ16	Mónica	Contreras	Pérez	2018-02-06	Intersex	B-	5581898579	paciente3467@example.com
RRFU891031XHRWZLW1	Mario	Flores	Herrera	1989-10-31	Intersex	B-	5593466730	paciente3468@example.com
CFXP780421XYEPWI10	José	Torres	García	1978-04-21	Intersex	O+	\N	\N
XZCA141206MXQIRLV7	Daniela	Romero	Solís	2014-12-06	F	A-	5538124014	paciente3470@example.com
CKTD870119MADJKF21	Silvia	Castillo	Torres	1987-01-19	F	AB-	5504311387	paciente3471@example.com
XNWD250628HPHKWL51	Adrián	Cabrera	Solís	2025-06-28	M	AB-	5521664016	paciente3472@example.com
IOTY930625MPERXVB8	Silvia	Ramos	Torres	1993-06-25	F	A-	5559561689	paciente3473@example.com
JRDY160328XVBFPAP6	Roberto	Rojas	Martínez	2016-03-28	Intersex	B+	5557610527	\N
GKJP430918XPRVBDU2	Yolanda	Rojas	Gutiérrez	1943-09-18	Intersex	AB+	5507486993	paciente3475@example.com
IOTD571215XWVMMKF4	Roberto	Cabrera	Salazar	1957-12-15	Intersex	B+	5503231248	paciente3476@example.com
IEVK811128XQSDLZY5	Claudia	Sánchez	Flores	1981-11-28	Intersex	B+	5582737204	\N
IDQK100906XAJQSBA6	Lucía	Delgado	Díaz	2010-09-06	Intersex	O+	5508762408	paciente3478@example.com
VSFP221218XGHQKE99	Fernando	Vázquez	Hernández	2022-12-18	Intersex	A+	5570267218	\N
HXDP810902MKHZMH28	Araceli	González	Vargas	1981-09-02	F	AB+	5503618439	paciente3480@example.com
GGNS661225XCSKOD48	Ricardo	Flores	Medina	1966-12-25	Intersex	A-	\N	paciente3481@example.com
KRTM180604HRSVPJ72	Óscar	Mendoza	Torres	2018-06-04	M	\N	5583318390	paciente3482@example.com
UEAR040329HGWNDXY2	Adrián	Pérez	Rojas	2004-03-29	M	A+	5594731109	paciente3483@example.com
DCGH890411HNFRRVX7	Juan	Ortiz	Sánchez	1989-04-11	M	O+	5589671965	\N
VNNT101118MQBZGE23	Cecilia	Reyes	García	2010-11-18	F	AB+	5529091374	\N
OLVZ661027HMPGYKC8	Javier	Vázquez	González	1966-10-27	M	A+	5504730192	\N
QFID380220XRGUGL07	Juan	Vargas	Medina	1938-02-20	Intersex	A+	\N	paciente3487@example.com
WPHX010617XIXEOFL0	Miguel	Cordero	Rodríguez	2001-06-17	Intersex	\N	5558090151	paciente3488@example.com
NEEA800619MNRNPH04	Lucía	Fuentes	Delgado	1980-06-19	F	A-	5594152359	paciente3489@example.com
BCMW681218HYMLDLE7	Óscar	Hernández	Cabrera	1968-12-18	M	B+	5523436664	paciente3490@example.com
UAGH540128XLAIMQD1	Fernanda	Ortiz	Ramos	1954-01-28	Intersex	B-	5576509603	\N
ZGYW660114MTUNHEL9	Araceli	Medina	Estrada	1966-01-14	F	O-	5557634339	paciente3492@example.com
NDTH220526MOWVXOD6	Ana	Gómez	Jiménez	2022-05-26	F	O-	5578018716	paciente3493@example.com
CBKK670609XMPYVFQ2	Adriana	Cabrera	Díaz	1967-06-09	Intersex	AB-	5520784271	paciente3494@example.com
MZJR460922XNOXYDQ3	Miguel	Morales	Ramos	1946-09-22	Intersex	AB+	5589361759	paciente3495@example.com
ELDQ200524XRFRDMC2	Ana	Solís	García	2020-05-24	Intersex	B-	5534411022	\N
SEEQ690108HTGOAX52	Daniel	Ramírez	Martínez	1969-01-08	M	AB+	5529330023	\N
BMEE241226XIDPJX76	Óscar	Flores	Díaz	2024-12-26	Intersex	O+	\N	\N
OWNT030402XAUFSAL7	Daniela	Medina	Flores	2003-04-02	Intersex	AB+	5599045082	\N
TEOR601227XFVTPFV3	Araceli	Flores	Alvarado	1960-12-27	Intersex	\N	5574537401	paciente3500@example.com
RLNJ430930MGEUANV9	Elena	Díaz	López	1943-09-30	F	A-	5548382790	paciente3501@example.com
VRXK020204MIDGEH16	Beatriz	Gutiérrez	Reyes	2002-02-04	F	O-	5552308197	\N
EYAI951107XLYEIED5	Roberto	Solís	Gutiérrez	1995-11-07	Intersex	A+	5573889076	paciente3503@example.com
MHVZ621020HVTKJWC0	Carlos	Solís	Guzmán	1962-10-20	M	A+	5502678869	paciente3504@example.com
WFPG230301HUAYVH72	Raúl	García	Rojas	2023-03-01	M	O+	\N	paciente3505@example.com
RBBS200404HFRFDYA3	Daniel	García	Sánchez	2020-04-04	M	\N	5587815141	paciente3506@example.com
BZCZ380301XMFXJEW5	Diana	Flores	Ortiz	1938-03-01	Intersex	B-	5587097915	paciente3507@example.com
EWQH401120HPCWLQ45	Jorge	Hernández	Morales	1940-11-20	M	B+	5596324246	paciente3508@example.com
EFAT011016MAADXJO1	Paola	Gómez	Medina	2001-10-16	F	O+	5560970670	\N
LBQW060601HZALIFN3	José	Flores	Peña	2006-06-01	M	B-	5515181342	paciente3510@example.com
XHSX860213XSAKHOG5	Ana	Sánchez	Díaz	1986-02-13	Intersex	B-	5528768418	paciente3511@example.com
WGME530315MIHUJVH9	Patricia	Salazar	Sánchez	1953-03-15	F	O-	5539593295	paciente3512@example.com
YUMH010909MVECRF20	Diana	Martínez	Chávez	2001-09-09	F	O+	5562686108	paciente3513@example.com
PPTQ680511MSQSMVK8	Gabriela	Guzmán	López	1968-05-11	F	AB+	5543339898	paciente3514@example.com
UMWF740722HLFLXK90	Ricardo	Salazar	Gutiérrez	1974-07-22	M	A-	5553953131	\N
PKCO660511HIHYZCL6	Luis	Gutiérrez	Ramos	1966-05-11	M	A+	\N	paciente3516@example.com
FNUL850314MJFKQV16	Beatriz	Reyes	Mendoza	1985-03-14	F	O+	5594611608	\N
JURM931206HDUYXZV0	Raúl	Gutiérrez	Flores	1993-12-06	M	\N	5511080306	paciente3518@example.com
ROBH840316MUODGYH1	Gabriela	Guzmán	Chávez	1984-03-16	F	B+	5571003666	paciente3519@example.com
QRCY700302HLSIWVV6	Fernando	Vázquez	Guzmán	1970-03-02	M	O+	5555991524	\N
ZUDK911221XGUVMIR3	Óscar	Hernández	Rodríguez	1991-12-21	Intersex	O-	5530030045	paciente3521@example.com
KATM070719HQRXQV93	Diego	López	Flores	2007-07-19	M	O-	\N	paciente3522@example.com
IIIC770216HVYEDTE7	Iván	Medina	Romero	1977-02-16	M	O+	5521789426	paciente3523@example.com
GVSA610130HFTDKJI5	Miguel	García	\N	1961-01-30	M	B+	5583981121	\N
VIVI090102XEWGMAJ5	Guadalupe	García	Pérez	2009-01-02	Intersex	AB+	5522917123	paciente3525@example.com
KJAT510702HGIHMW68	Mario	Estrada	Chávez	1951-07-02	M	AB+	5548030665	paciente3526@example.com
UTBH601001MQVPKUV6	Lucía	Cabrera	Martínez	1960-10-01	F	AB-	5513428233	paciente3527@example.com
JFPE170826MXZALCM9	Adriana	Martínez	Guzmán	2017-08-26	F	B-	5514916111	\N
CTMF680229MHYEUM86	Patricia	Chávez	Romero	1968-02-29	F	A+	5537727690	paciente3529@example.com
QGDA660713MGIJNTR3	Teresa	García	Ortiz	1966-07-13	F	O+	5549820976	paciente3530@example.com
AYCU501010HFEMTSW1	Sergio	Medina	Peña	1950-10-10	M	O+	5562944205	\N
KPDZ590923HERPLWN3	Emilio	Morales	\N	1959-09-23	M	B+	5580136049	\N
IXWX950720MRFODR90	Miriam	Ramírez	Gómez	1995-07-20	F	B+	5569229625	paciente3533@example.com
APVE371214XDPNTUX9	Carmen	Gutiérrez	Solís	1937-12-14	Intersex	O+	5504431974	paciente3534@example.com
BPAB700112MTOJBOP3	Adriana	Cordero	Mendoza	1970-01-12	F	AB-	5510909331	paciente3535@example.com
KSCI640403XWMTHMY6	Ana	Reyes	Herrera	1964-04-03	Intersex	A-	5589009180	paciente3536@example.com
YULD720911HIUCTPN4	Óscar	Flores	Herrera	1972-09-11	M	\N	5571775450	paciente3537@example.com
AJYP760708XPWSBYD1	Rodrigo	Castillo	Alvarado	1976-07-08	Intersex	A-	5585978719	paciente3538@example.com
PBXK380702HSJMMSY1	Antonio	Peña	Sánchez	1938-07-02	M	B+	5579793892	paciente3539@example.com
LESV600211MLXIUBB5	Rosa	Pérez	Reyes	1960-02-11	F	B+	5504214316	paciente3540@example.com
TIAG560515MMVXIBI9	Laura	Salazar	Delgado	1956-05-15	F	\N	5568783326	\N
QTIP950707HESDKLG5	José	Jiménez	Fuentes	1995-07-07	M	A+	5583623081	paciente3542@example.com
PNCE410330MIEBJIE5	Patricia	Castillo	\N	1941-03-30	F	AB+	5520727999	paciente3543@example.com
ZYDW201002MQTQSFY6	Silvia	Peña	Solís	2020-10-02	F	A+	5593674086	paciente3544@example.com
KYWP730620XAHJSGW5	Luis	Martínez	Gómez	1973-06-20	Intersex	A-	5576079876	paciente3545@example.com
TLFB140816XSQJMWP4	Raúl	Romero	Peña	2014-08-16	Intersex	AB-	5541546334	paciente3546@example.com
RAFS091111XCJGSIJ0	Antonio	Peña	\N	2009-11-11	Intersex	AB-	5501559720	paciente3547@example.com
EXNU710630MRAOLBD9	Patricia	Flores	Pérez	1971-06-30	F	AB+	5583388806	paciente3548@example.com
QVTU820528MXTVCV22	Adriana	Morales	Medina	1982-05-28	F	A-	5552881513	paciente3549@example.com
FGZS230818XZPOAIO1	Ricardo	Medina	Martínez	2023-08-18	Intersex	A-	5551638883	\N
LOKI220206XWTRZCH1	Gabriela	Vargas	Sánchez	2022-02-06	Intersex	\N	\N	paciente3551@example.com
RUTD740819MWDEQDT7	Daniela	García	Fuentes	1974-08-19	F	O-	5584011540	paciente3552@example.com
SBBO500525HBKKGA12	Francisco	Ramos	Alvarado	1950-05-25	M	AB-	5518698683	\N
VIXT701121MEWPVJX3	Paola	Alvarado	Hernández	1970-11-21	F	AB-	5569682606	paciente3554@example.com
ULRR700515XVXGBHO5	Miriam	Martínez	Vargas	1970-05-15	Intersex	O+	\N	\N
QKKB510802MGRIVOF0	Fernanda	López	\N	1951-08-02	F	AB+	5597317367	paciente3556@example.com
ATJL611106HSOLVDP0	Antonio	Pérez	Sánchez	1961-11-06	M	O-	5573081634	paciente3557@example.com
OYFZ560703HKUOZOL6	José	Ramos	\N	1956-07-03	M	O-	5558436127	\N
GJQE990918MEQAZQV7	Elena	Ruiz	Cruz	1999-09-18	F	AB+	5523623916	paciente3559@example.com
RVXZ971119HKKZYFV6	Rodrigo	Ramos	Cruz	1997-11-19	M	\N	5508806357	paciente3560@example.com
ZLJC211107XHOXFRL9	Ana	Solís	Cruz	2021-11-07	Intersex	O-	5516431695	paciente3561@example.com
ICYV781114XCZNBFD1	Verónica	Hernández	Romero	1978-11-14	Intersex	A+	5512584723	paciente3562@example.com
UNSQ570522MAWEFKC9	Rosa	Ortiz	Jiménez	1957-05-22	F	O-	5578137421	paciente3563@example.com
LEDB710705HYIMZAV9	Ricardo	Guzmán	\N	1971-07-05	M	\N	5526110447	paciente3564@example.com
YIGJ740525MALBCH08	Lucía	Rodríguez	Ortiz	1974-05-25	F	O-	5545754523	paciente3565@example.com
ALLE921227XICDAQ51	Mónica	Contreras	Chávez	1992-12-27	Intersex	B-	5599229346	paciente3566@example.com
HLIZ760124XLWTSK32	Mario	Flores	Ortiz	1976-01-24	Intersex	AB+	5585500230	paciente3567@example.com
OYRF640513XRMMCS62	Adrián	Flores	Aguilar	1964-05-13	Intersex	\N	5504062094	paciente3568@example.com
HWYA510723HDZVGBH1	Pablo	Ortiz	Cruz	1951-07-23	M	A-	5533988684	paciente3569@example.com
IXQD390114MLVHSZF2	Daniela	Herrera	Morales	1939-01-14	F	A+	5519043605	paciente3570@example.com
XIIX630115HYVZMYQ4	Alejandro	Reyes	Gutiérrez	1963-01-15	M	A+	5510670990	paciente3571@example.com
ZUCK560405HDURODC4	Óscar	López	Romero	1956-04-05	M	O+	5544646389	paciente3572@example.com
JXIX400703HUTPSBV7	Miguel	Herrera	González	1940-07-03	M	A-	5505416318	paciente3573@example.com
ANVV570312HSFDKGB0	Mario	Vargas	López	1957-03-12	M	B-	5567481798	paciente3574@example.com
HSHP461111HLYUVX61	Francisco	Solís	López	1946-11-11	M	A-	5512170994	\N
IDBF070314MTANDMG8	Araceli	Contreras	González	2007-03-14	F	B-	5510670769	paciente3576@example.com
EPZD140918HPPHZFZ8	Jorge	Chávez	Peña	2014-09-18	M	B-	5578105289	\N
QLLE190217MVKNOM58	Leticia	Salazar	Jiménez	2019-02-17	F	AB-	5505411669	paciente3578@example.com
UKEY390429HJENTY09	Adrián	Ruiz	Martínez	1939-04-29	M	AB+	5576869900	paciente3579@example.com
AIDY891030XHPSWU14	Eduardo	Medina	Sánchez	1989-10-30	Intersex	O+	5597038341	\N
YUPB820403HCRHAV48	Mario	Rodríguez	Ruiz	1982-04-03	M	B+	5508245609	\N
GBEZ410421HZEGSYP5	Adrián	Cruz	\N	1941-04-21	M	B+	\N	paciente3582@example.com
IPFU390313HORCEZH9	Antonio	Morales	Torres	1939-03-13	M	AB+	5557351549	paciente3583@example.com
IPCE881212XIGJXXZ8	Gerardo	Alvarado	Alvarado	1988-12-12	Intersex	A-	5554975157	paciente3584@example.com
NUSP120618HUHMBNO0	José	Chávez	Jiménez	2012-06-18	M	O-	5598210959	\N
XWMR690920XHIKDC11	Raúl	Jiménez	Ramos	1969-09-20	Intersex	O+	5565151382	paciente3586@example.com
YKQR910929HHIXTTY0	Jorge	Romero	Morales	1991-09-29	M	B-	5504882526	paciente3587@example.com
QQLC531015MLQMSJC9	Lucía	Estrada	Morales	1953-10-15	F	B+	5571882991	paciente3588@example.com
LILW161111XQXAVU11	José	Rojas	Romero	2016-11-11	Intersex	\N	5501365122	\N
HMJU160422MOFVZK95	Claudia	Mendoza	Estrada	2016-04-22	F	AB+	5521228985	\N
BDUZ031010MSIFMOO6	Leticia	Torres	Torres	2003-10-10	F	A-	5551531043	\N
BFKT560619HBJOLJ46	Manuel	Chávez	López	1956-06-19	M	O-	5535951846	paciente3592@example.com
CEOD830420XTTEPFT1	Francisco	Guzmán	Gutiérrez	1983-04-20	Intersex	\N	5583333065	paciente3593@example.com
LKEW040113XEAWEE29	Gabriela	Vargas	González	2004-01-13	Intersex	AB+	\N	paciente3594@example.com
BRLY771102XXKWCOL9	Juan	López	Gómez	1977-11-02	Intersex	B+	5598331198	paciente3595@example.com
VKUM130430XZIAXMB5	Raúl	Mendoza	Mendoza	2013-04-30	Intersex	AB+	5532900889	paciente3596@example.com
FPKA640519HYYNWH02	Pablo	Cabrera	Rojas	1964-05-19	M	A+	5522505386	paciente3597@example.com
QWIE011124HBSICQR4	Luis	Ramírez	Salazar	2001-11-24	M	B+	5520424579	paciente3598@example.com
FWCD400907MUQBQYK9	Claudia	Pérez	Peña	1940-09-07	F	A-	5580743857	paciente3599@example.com
NKDK660819XLNUOHM7	Luis	Jiménez	Pérez	1966-08-19	Intersex	AB+	\N	paciente3600@example.com
WWPX470416HNUKUX53	Pablo	Vargas	Salazar	1947-04-16	M	A+	5505705021	\N
VYGM791121HWQFKYE7	Ricardo	García	Mendoza	1979-11-21	M	O+	5545526746	paciente3602@example.com
RGOF110403HCGAFV53	Manuel	Gutiérrez	Ramírez	2011-04-03	M	A+	5504484000	\N
FPXZ520219HTEQCPJ7	Manuel	Ortiz	Gómez	1952-02-19	M	A+	5533477204	paciente3604@example.com
ZEUR910502XEKVLST8	Cecilia	Torres	Rojas	1991-05-02	Intersex	B+	5575965598	paciente3605@example.com
HAAQ390222XZYVZOF0	Elena	Cabrera	Rodríguez	1939-02-22	Intersex	AB+	5559169318	\N
JSKM650419MWMVVKZ6	Diana	Díaz	Aguilar	1965-04-19	F	O+	5507624513	paciente3607@example.com
XHJW840609XQKPZTT9	Emilio	Sánchez	Cruz	1984-06-09	Intersex	B+	\N	paciente3608@example.com
UKHO730803XBLPZLR9	Andrés	Flores	Díaz	1973-08-03	Intersex	B+	\N	paciente3609@example.com
EFXT100317MKCXRXX8	Mónica	Estrada	García	2010-03-17	F	AB-	5581165508	paciente3610@example.com
TSDZ871117MLOIRYB0	Teresa	Hernández	Vargas	1987-11-17	F	B+	5569080267	paciente3611@example.com
HJEY551228HPITOQS7	Jorge	Torres	Estrada	1955-12-28	M	B-	5581551562	paciente3612@example.com
STKZ130317MXWWEBR3	Teresa	Peña	Rojas	2013-03-17	F	O+	\N	\N
TTUY920711HXPWXF64	Emilio	Romero	Rojas	1992-07-11	M	AB+	5558576050	paciente3614@example.com
LWGX830609MTFSVC88	Paola	Mendoza	Cabrera	1983-06-09	F	O-	5505484652	paciente3615@example.com
QBLR930513HGBOMRI0	Iván	Fuentes	Morales	1993-05-13	M	B-	5526024421	\N
XOIH111203XWZWNRT8	Sergio	Medina	Aguilar	2011-12-03	Intersex	B-	\N	\N
KXKX050420HAIJWXB5	Iván	Gutiérrez	Gómez	2005-04-20	M	AB-	5510620802	\N
LQQN400114XWBJTUZ0	Francisco	Hernández	Cruz	1940-01-14	Intersex	A+	5550920119	paciente3619@example.com
QYWE130316MPBEWMH2	Alejandra	Flores	Rojas	2013-03-16	F	B-	5579760402	paciente3620@example.com
BQVI240928XSLEKIC0	Carmen	Vázquez	Sánchez	2024-09-28	Intersex	A-	5518893457	paciente3621@example.com
OTEM430430MWYVXSE1	Silvia	Gutiérrez	Delgado	1943-04-30	F	AB+	5516466632	paciente3622@example.com
OQUY720319HOMRWES5	Hugo	Pérez	Ramírez	1972-03-19	M	\N	5585166263	paciente3623@example.com
JALI100321MZDNRGM1	Gabriela	Medina	Ramos	2010-03-21	F	B+	5547238032	paciente3624@example.com
JCYF820407MIHEAXV8	Alejandra	Gutiérrez	Flores	1982-04-07	F	A+	\N	paciente3625@example.com
MVND120419XVXHMU36	Diana	García	Cordero	2012-04-19	Intersex	A-	5585285295	paciente3626@example.com
HXFX151114HPXTMQV5	Francisco	Rodríguez	Martínez	2015-11-14	M	AB+	5521177800	\N
GTAZ390413HHBMJZH6	Diego	Hernández	Cabrera	1939-04-13	M	AB-	5502149290	paciente3628@example.com
OOVE231222XLVAEDC9	Yolanda	Morales	Rodríguez	2023-12-22	Intersex	\N	5593060843	paciente3629@example.com
GZSY450509HICVUD67	Emilio	Peña	Mendoza	1945-05-09	M	A+	5529331756	paciente3630@example.com
SMUT930227HZLULJE7	Fernando	Morales	Sánchez	1993-02-27	M	\N	\N	paciente3631@example.com
XWNF140816MLHDNIB2	Alejandra	Rojas	Torres	2014-08-16	F	A-	5593045741	paciente3632@example.com
PSYA830226XKIEKZO1	Lucía	Salazar	Reyes	1983-02-26	Intersex	AB-	5527772178	paciente3633@example.com
EYMK800215MABUGCK3	Diana	Cruz	Contreras	1980-02-15	F	B-	5583662539	paciente3634@example.com
KGAE721214HCKKSLL2	Javier	Vázquez	Vázquez	1972-12-14	M	A-	5593159105	paciente3635@example.com
ZSPZ820423XEFQDB99	Rosa	Ramos	\N	1982-04-23	Intersex	O-	5587089850	\N
DDXH701105HEBHMAZ0	Antonio	Herrera	Solís	1970-11-05	M	A-	5549612690	paciente3637@example.com
WJJZ030522XNTMTAH0	Ana	Hernández	Estrada	2003-05-22	Intersex	A+	5593798044	paciente3638@example.com
TISF461003HGKTWWK0	José	Rojas	Pérez	1946-10-03	M	A+	5530499780	paciente3639@example.com
ADDC060126HUNPAZW1	Carlos	Gutiérrez	Díaz	2006-01-26	M	A+	5507535354	paciente3640@example.com
YPLL420621HRITDE92	Rodrigo	Reyes	Vázquez	1942-06-21	M	AB+	5542491485	paciente3641@example.com
UZRK961026MIXOHT99	Laura	Medina	Castillo	1996-10-26	F	A-	5516127924	\N
KAOD510827HNRSEGJ1	Adrián	Medina	González	1951-08-27	M	AB-	5546753015	paciente3643@example.com
DIHV500206HAEYOWZ7	Ricardo	Ruiz	López	1950-02-06	M	O-	5524404283	\N
BQZJ180603HEZTOT07	José	López	Díaz	2018-06-03	M	AB+	5563331325	paciente3645@example.com
XWJA180423HWKLDNI9	Luis	Gómez	Díaz	2018-04-23	M	AB-	5529161693	paciente3646@example.com
IROU900319MWQFBPV2	Silvia	Romero	Gutiérrez	1990-03-19	F	O+	5570464837	\N
VDPI080901MZQDWN34	Claudia	Hernández	Romero	2008-09-01	F	A-	5521827259	paciente3648@example.com
GUDP471110MZRJWC14	Adriana	Ortiz	Chávez	1947-11-10	F	AB-	5556091575	\N
IYER660422HFHIEW92	Eduardo	Contreras	Sánchez	1966-04-22	M	O+	5588622353	paciente3650@example.com
WRNR111002XPWSVPN2	Eduardo	Cruz	Cordero	2011-10-02	Intersex	B-	5589609939	\N
JIHE031013MXQBYDQ0	Elena	Mendoza	Estrada	2003-10-13	F	B+	5577901715	paciente3652@example.com
LHVM201120XEHNVA26	Adriana	Torres	Chávez	2020-11-20	Intersex	\N	5563740685	paciente3653@example.com
PEJR960406MTKMWMU4	Daniela	Mendoza	González	1996-04-06	F	AB+	5598997930	paciente3654@example.com
BXYW880422HLVFEW01	Diego	García	Romero	1988-04-22	M	A+	5571305206	\N
CXYO670923HXAMNSO5	Rodrigo	Cabrera	Peña	1967-09-23	M	B+	5591021140	paciente3656@example.com
PGQG891005HHTWSOA4	Ricardo	Chávez	Rodríguez	1989-10-05	M	\N	5563277036	\N
PKEK600413XONZRPW2	Sergio	Cruz	Cordero	1960-04-13	Intersex	AB+	5579797525	paciente3658@example.com
DNQI501122HWTWKS92	Sergio	Pérez	Estrada	1950-11-22	M	AB+	5549459053	paciente3659@example.com
STBI010618MTUKWDE4	Carmen	Cordero	Cordero	2001-06-18	F	O-	5510898726	paciente3660@example.com
GPGS170108HEMWMNX9	Eduardo	Peña	Vargas	2017-01-08	M	\N	\N	paciente3661@example.com
XHWD810425MYFYZUV4	Miriam	García	Díaz	1981-04-25	F	AB-	\N	paciente3662@example.com
JBBE810424MRMPIXG6	Silvia	Solís	Romero	1981-04-24	F	O+	5531985047	paciente3663@example.com
FRUF160501HYJBQE97	Diego	Ramos	Romero	2016-05-01	M	A+	5540647088	paciente3664@example.com
APWG660208MAZEPWX8	Gabriela	Cabrera	Romero	1966-02-08	F	AB-	5532050009	paciente3665@example.com
XAPK870427MIZYLIL2	Lucía	Vázquez	Estrada	1987-04-27	F	A-	5560694347	\N
DKES110812XWSLSMF7	Diego	Delgado	Jiménez	2011-08-12	Intersex	O+	5585481882	paciente3667@example.com
CWFL030403XJPEJNN3	Lucía	Solís	Delgado	2003-04-03	Intersex	O+	5545840943	\N
NNWJ480410XPVBKJ41	Daniel	Reyes	Alvarado	1948-04-10	Intersex	AB+	5506957071	\N
PQKF800214XPWEXIT0	Ana	Martínez	Cordero	1980-02-14	Intersex	AB+	5535171711	paciente3670@example.com
EHMX851204HCGEUY80	Miguel	González	Sánchez	1985-12-04	M	O+	\N	\N
WPIT680618MLAGGI07	Teresa	Gutiérrez	Herrera	1968-06-18	F	O+	5573641402	\N
ATIQ581217XJWUMC90	Iván	Alvarado	Gómez	1958-12-17	Intersex	A+	5523988437	paciente3673@example.com
UCRW430228HKCWPKP0	Carlos	González	Solís	1943-02-28	M	AB-	5504868182	\N
EKBN590915MSRUHFE4	Ana	Ramírez	Estrada	1959-09-15	F	B+	5568631468	paciente3675@example.com
NWNS141123HKKGTEF8	Alejandro	Pérez	Mendoza	2014-11-23	M	O-	5512464880	paciente3676@example.com
BZOP801205XHASRHK2	Carmen	Fuentes	Hernández	1980-12-05	Intersex	A+	5510215234	paciente3677@example.com
HEFK741209XOCOOTF8	Andrés	Sánchez	Rodríguez	1974-12-09	Intersex	B-	\N	paciente3678@example.com
MAPD060408XJSWQOC3	Adrián	Rojas	Martínez	2006-04-08	Intersex	AB-	5584457676	paciente3679@example.com
DWTF650327HTTZGFL3	Rodrigo	Ortiz	Vázquez	1965-03-27	M	B+	5580005067	\N
KNQQ630321MVBZCB53	Lucía	Castillo	Fuentes	1963-03-21	F	B+	5529045057	\N
NEVL930731XXSOEEN7	Emilio	Solís	Hernández	1993-07-31	Intersex	O+	5514428845	paciente3682@example.com
MYVY720102HBTDGGA7	Luis	Alvarado	\N	1972-01-02	M	AB-	5562928750	paciente3683@example.com
JRLZ130217MVWQBEU7	Adriana	Cruz	Herrera	2013-02-17	F	AB+	5585893972	paciente3684@example.com
OFRW180110HRKVLC89	Javier	Estrada	Gutiérrez	2018-01-10	M	B-	5539453452	\N
DCWC881122XBXLLT39	Elena	Mendoza	Ortiz	1988-11-22	Intersex	B+	5534132426	paciente3686@example.com
GMKD590103HTLNKWR5	Arturo	Peña	Estrada	1959-01-03	M	AB+	5535661973	paciente3687@example.com
UXVK661020XOAPOTQ9	Gerardo	Torres	Castillo	1966-10-20	Intersex	O-	5503258663	paciente3688@example.com
ASCE821227HWNNWOH7	Luis	Romero	Herrera	1982-12-27	M	A-	5533797130	paciente3689@example.com
GGEN171026HSBCRPM6	Óscar	Guzmán	Ruiz	2017-10-26	M	A-	5527420860	\N
CMUJ511007HIUOTN78	Andrés	Sánchez	Gutiérrez	1951-10-07	M	A+	5593231748	paciente3691@example.com
EZAY920211XGDJOLT8	Ana	Guzmán	Sánchez	1992-02-11	Intersex	\N	\N	paciente3692@example.com
MZNT590823MJPDQZN4	Gabriela	Rojas	Reyes	1959-08-23	F	B+	5585647255	\N
MAKS970726XYFGGQI5	Diego	Chávez	Mendoza	1997-07-26	Intersex	O-	5591306831	paciente3694@example.com
BHIC950103XGKTBPC6	Eduardo	Estrada	Herrera	1995-01-03	Intersex	AB-	\N	\N
MFDP600101HBAQPY61	Diego	Mendoza	Salazar	1960-01-01	M	A-	5599111182	paciente3696@example.com
UQEP921015MHIYLT76	Teresa	Fuentes	Hernández	1992-10-15	F	B-	5589892085	paciente3697@example.com
GUDN431003HZHBPXP3	Alejandro	Chávez	García	1943-10-03	M	B-	5598575122	paciente3698@example.com
QJQE730217MWREVIF0	Leticia	Morales	Cordero	1973-02-17	F	B+	5507101563	\N
WUPM940707HUIJTGL2	Arturo	López	Guzmán	1994-07-07	M	A-	5574232893	\N
BNSJ770305XIBNGOI1	Luis	Gutiérrez	Salazar	1977-03-05	Intersex	A-	5515928224	paciente3701@example.com
ODNT711202HTCOKLS1	Arturo	Flores	Aguilar	1971-12-02	M	A-	5581511300	\N
DDZI590426XZIZHJI4	Hugo	Salazar	Estrada	1959-04-26	Intersex	B+	\N	paciente3703@example.com
MMGS511006MAOGQOV6	Laura	Morales	Gutiérrez	1951-10-06	F	B-	5519112949	\N
JVDT390908XYPLAE68	Luis	González	Ramírez	1939-09-08	Intersex	AB-	5581745498	paciente3705@example.com
POVO860320MRYGFC76	Daniela	Gómez	Ruiz	1986-03-20	F	AB-	5537265683	paciente3706@example.com
LLTC560203HKCPVRJ7	Juan	Ortiz	Castillo	1956-02-03	M	A-	5550214217	\N
HWOE140124XEIEQEM4	Mónica	Herrera	Herrera	2014-01-24	Intersex	B+	5529071223	\N
EHZE380410MJRUIIQ4	Claudia	García	Guzmán	1938-04-10	F	O+	5513748870	paciente3709@example.com
OXFK930829MYESUIT9	Carmen	Herrera	\N	1993-08-29	F	A-	\N	paciente3710@example.com
ZXEC501004XLGVFQL3	Laura	Flores	Morales	1950-10-04	Intersex	A-	5501861626	paciente3711@example.com
QOEU840902MCCHUZ94	Fernanda	Hernández	López	1984-09-02	F	AB-	5504022749	\N
VFZT790906XXLLHMO1	Beatriz	Hernández	Jiménez	1979-09-06	Intersex	B-	5573703885	paciente3713@example.com
GGMY070604HANGLSB6	Óscar	Romero	\N	2007-06-04	M	AB-	5502317508	\N
FESN861011MLEFDZH9	Adriana	Ramos	Rodríguez	1986-10-11	F	\N	5544713341	paciente3715@example.com
RMBM570824HFKGNZE3	Andrés	Rodríguez	Aguilar	1957-08-24	M	\N	\N	paciente3716@example.com
POCC801206MASBVSP3	Rosa	Vargas	Aguilar	1980-12-06	F	A+	\N	paciente3717@example.com
CMTL060821XNERKSF6	Pablo	Gómez	Guzmán	2006-08-21	Intersex	O-	5520910036	paciente3718@example.com
PHHP420115MOTTYZ29	Elena	López	Gómez	1942-01-15	F	A-	\N	paciente3719@example.com
PJUQ960820XKQMQK87	Carmen	Peña	Castillo	1996-08-20	Intersex	A-	5557443387	paciente3720@example.com
IESG570910HSTVZDF9	Adrián	Morales	Rodríguez	1957-09-10	M	AB+	5586211375	paciente3721@example.com
MPTO220918MVFGRJJ8	Rosa	Fuentes	Gómez	2022-09-18	F	O-	5569549001	paciente3722@example.com
FDZS161005HEIUJMN3	Mario	Jiménez	García	2016-10-05	M	O+	5573995992	paciente3723@example.com
TFYC531229XHEQGTC6	Andrés	López	Jiménez	1953-12-29	Intersex	\N	5500515639	\N
TJSE710227HXBWCGM0	Emilio	Reyes	Jiménez	1971-02-27	M	A-	5542289951	paciente3725@example.com
MKAW420720XSJWRJ04	Ricardo	Ortiz	Mendoza	1942-07-20	Intersex	B-	5599033654	paciente3726@example.com
OSPL981007HNJUHE43	Óscar	Ramos	Reyes	1998-10-07	M	A-	5599960432	\N
AIYG610326MPSNYLB8	Laura	Pérez	Contreras	1961-03-26	F	B+	5572417490	paciente3728@example.com
DPVD761208MVNJEB54	Elena	Flores	Estrada	1976-12-08	F	A-	5551777842	paciente3729@example.com
QRPR670508HOCCSM44	Iván	Salazar	Ramos	1967-05-08	M	AB-	5575316279	paciente3730@example.com
XLLC720411MKZJBHJ8	Diana	Aguilar	Peña	1972-04-11	F	A+	5524753666	paciente3731@example.com
DWJZ881228HLKILCH7	Jorge	Salazar	Gutiérrez	1988-12-28	M	B-	5595839821	paciente3732@example.com
JMEW871217MTLMOFN0	María	Delgado	Solís	1987-12-17	F	\N	5544364493	paciente3733@example.com
PXWN450928MRRYGQR9	Silvia	García	Medina	1945-09-28	F	O-	5571576289	paciente3734@example.com
VCZY600708HQNEWMQ7	Roberto	Reyes	Ramos	1960-07-08	M	AB-	5580936766	\N
HWDT101022MHTBFBB1	Verónica	Hernández	Martínez	2010-10-22	F	B+	5516244400	paciente3736@example.com
FJEJ840813HHBLMS00	Sergio	Ramírez	Gutiérrez	1984-08-13	M	B-	5508230067	paciente3737@example.com
KKKM731005HIFEMA81	Hugo	Medina	Morales	1973-10-05	M	AB-	5597011908	\N
YUBL730824MCLQJQ78	Karla	Estrada	Gutiérrez	1973-08-24	F	A+	5581202725	paciente3739@example.com
NQSK160324XBYMLOM1	Yolanda	Sánchez	Díaz	2016-03-24	Intersex	A-	5551552974	paciente3740@example.com
TBFG671206XGWMRE97	Pablo	Romero	Sánchez	1967-12-06	Intersex	\N	5508970794	paciente3741@example.com
LUBR840220HMHTEP36	Ricardo	Ramírez	Rojas	1984-02-20	M	\N	5531124098	paciente3742@example.com
NQTS891212MKPAJDG8	Carmen	García	Reyes	1989-12-12	F	B-	5564231642	paciente3743@example.com
VXCY900111HAVVROU9	Andrés	Alvarado	Gutiérrez	1990-01-11	M	\N	5578638124	\N
EWYV760415MWIQHPV1	Miriam	Delgado	Aguilar	1976-04-15	F	AB+	\N	paciente3745@example.com
VGKC380719XSVLOHC0	Alejandra	Ortiz	\N	1938-07-19	Intersex	AB-	5552483483	paciente3746@example.com
KHGJ971213HWTXKNJ4	Luis	Gutiérrez	Castillo	1997-12-13	M	O+	5585986468	paciente3747@example.com
VEER440424MFJQPJM2	Rosa	García	Ruiz	1944-04-24	F	A-	5529825995	paciente3748@example.com
QXIY911227HBAYVAY7	Carlos	Díaz	López	1991-12-27	M	B+	5519912011	paciente3749@example.com
WBXL470818MLXMIDA3	Lucía	Cruz	Gómez	1947-08-18	F	AB-	\N	paciente3750@example.com
FDAZ130125XKNCVFG9	María	López	Peña	2013-01-25	Intersex	AB-	5525470788	\N
OEVL010427XDEWDEB8	Yolanda	Delgado	Ortiz	2001-04-27	Intersex	AB+	5555099070	\N
OCMG980719MIIDKDO6	Claudia	García	Fuentes	1998-07-19	F	O-	5524036012	paciente3753@example.com
DPNB420209XFVIAEZ3	Eduardo	Contreras	\N	1942-02-09	Intersex	B-	5588795529	paciente3754@example.com
NTNP190923HBRGEH87	Juan	Castillo	Estrada	2019-09-23	M	\N	5550834001	paciente3755@example.com
HURC240824HMBMAGJ6	Manuel	Vargas	López	2024-08-24	M	O-	5544337495	paciente3756@example.com
PHIP101205XBOEJNL5	Lucía	Cabrera	Medina	2010-12-05	Intersex	AB-	5596862055	\N
QHKF250110MGGSCT76	Patricia	Medina	Aguilar	2025-01-10	F	A+	5577028748	paciente3758@example.com
YDZG031218XCVZSOG2	Silvia	Gómez	Gómez	2003-12-18	Intersex	A-	\N	paciente3759@example.com
JSMW850630XJMRJU17	Iván	Morales	Rodríguez	1985-06-30	Intersex	O-	5547143951	paciente3760@example.com
YAKH011102MSIOOEM1	Laura	Cordero	Flores	2001-11-02	F	A-	5536143456	paciente3761@example.com
CKGS390907XLWPHWA3	Elena	Aguilar	Cordero	1939-09-07	Intersex	A-	5516046290	paciente3762@example.com
IEPK570329HLUXFMP5	Andrés	Ramos	González	1957-03-29	M	B+	\N	paciente3763@example.com
HFIT881116MHRUVXR5	Carmen	Martínez	Reyes	1988-11-16	F	AB-	\N	paciente3764@example.com
REKB730204MINCMD41	Miriam	Cabrera	Ortiz	1973-02-04	F	A-	5514711856	\N
VWNU890226XCGDFDI9	José	Romero	Hernández	1989-02-26	Intersex	\N	5574668351	paciente3766@example.com
DCSE611005HMGGTYM0	Miguel	Morales	Alvarado	1961-10-05	M	O+	5558228300	paciente3767@example.com
RNSL180601MKSUVNF6	Fernanda	Jiménez	Herrera	2018-06-01	F	\N	5514908899	paciente3768@example.com
UARW590113HFVOGX13	Luis	Flores	Morales	1959-01-13	M	AB+	5575696542	\N
KAUJ460125MJNKZXY7	Elena	Cruz	Cordero	1946-01-25	F	O+	5562998858	paciente3770@example.com
JSCI781014XJDMQMB5	Miguel	Castillo	Ruiz	1978-10-14	Intersex	A+	5573499850	\N
WSXB010727XATCKXQ2	Fernando	Medina	Torres	2001-07-27	Intersex	A+	\N	paciente3772@example.com
IQOJ830619MWZLGIA1	Claudia	Flores	García	1983-06-19	F	O+	5574902573	paciente3773@example.com
BJMN530218MOJNJTP2	Silvia	Contreras	Fuentes	1953-02-18	F	B-	5549987427	paciente3774@example.com
XFZH840113HTQVKQ39	Mario	González	Peña	1984-01-13	M	\N	\N	paciente3775@example.com
LHBH750418MJNRNW23	Sofía	Chávez	Herrera	1975-04-18	F	O+	5500095365	paciente3776@example.com
FNQY540709MPMCWE68	Paola	Morales	Estrada	1954-07-09	F	B+	5542533602	paciente3777@example.com
PKPR810125MPGLSIS6	Teresa	Martínez	Medina	1981-01-25	F	A-	5528535746	\N
KWTU050601HMKLEQ60	Fernando	Romero	Rojas	2005-06-01	M	O+	5576966671	paciente3779@example.com
OXLS580808XEKZOT37	Alejandra	Morales	Solís	1958-08-08	Intersex	AB+	5580002731	\N
EKKR380127HKPTSEX2	Gerardo	Romero	González	1938-01-27	M	A-	5502119906	\N
IOVO000307MJTFVZC5	Teresa	Vargas	Cabrera	2000-03-07	F	O+	5582736921	paciente3782@example.com
XOCZ610930HAQMMSR7	Iván	Alvarado	Guzmán	1961-09-30	M	A-	5502839278	\N
YQNS830524MAUGAUB4	Rosa	Delgado	Gómez	1983-05-24	F	B-	\N	paciente3784@example.com
XNXO430121MCMCHPC1	Carmen	Peña	Rodríguez	1943-01-21	F	\N	5511073552	paciente3785@example.com
XWCA851229XLVWGV68	Arturo	Mendoza	Cruz	1985-12-29	Intersex	A-	5598778941	paciente3786@example.com
QNRJ231009MONEKWZ7	Paola	Delgado	Herrera	2023-10-09	F	A+	5533461789	\N
BGPR110827MNIDDRS7	Paola	Pérez	Cordero	2011-08-27	F	B+	5579938868	\N
IMTR110412MOCUNRW5	Elena	Romero	Salazar	2011-04-12	F	O-	5531277315	paciente3789@example.com
AIGM421014HUDXESG5	Pablo	Fuentes	Estrada	1942-10-14	M	O-	5539451285	paciente3790@example.com
TQCX410121XPTZDZH5	Miguel	Morales	Medina	1941-01-21	Intersex	\N	5548343067	paciente3791@example.com
QRTD720704HGWTUS59	Roberto	Rojas	Reyes	1972-07-04	M	AB+	5578997243	paciente3792@example.com
XOKE861014HGXXLZ03	Manuel	Solís	Vázquez	1986-10-14	M	AB-	5589733561	paciente3793@example.com
PCSL990804XHLGBX37	Araceli	García	Cruz	1999-08-04	Intersex	A+	5518716345	paciente3794@example.com
QHSS011201XZWYPJH3	Cecilia	Rojas	Medina	2001-12-01	Intersex	B-	5523469297	paciente3795@example.com
PDBC000809HBHQHUN3	Sergio	Hernández	Ramírez	2000-08-09	M	O-	\N	paciente3796@example.com
IKFP501202MUNVTNY2	Araceli	Estrada	Torres	1950-12-02	F	B+	5523766378	paciente3797@example.com
NNPD370106HEUGWP86	Luis	Jiménez	\N	1937-01-06	M	\N	5533836454	paciente3798@example.com
IRVU930418XDNMDI77	Manuel	Vargas	Estrada	1993-04-18	Intersex	O-	\N	paciente3799@example.com
TEJU120609HLTBSI42	Rodrigo	Peña	Solís	2012-06-09	M	O-	5556325258	paciente3800@example.com
CEVJ140124XBEGQDQ0	Ana	Mendoza	Medina	2014-01-24	Intersex	B+	5509873133	\N
WRAS560129HMHUZI69	Hugo	Ramos	Romero	1956-01-29	M	A-	5559455701	paciente3802@example.com
ZSXQ060924XWXOIXV7	Adrián	Flores	Ruiz	2006-09-24	Intersex	A-	5564149286	\N
CVFS240327HABFXVF0	Carlos	Salazar	Pérez	2024-03-27	M	AB-	5536690205	\N
FDFW540103XLERLLL0	Cecilia	Solís	Herrera	1954-01-03	Intersex	A+	5581352833	paciente3805@example.com
PRNP370211HTMWGXD2	Javier	Ramos	Cordero	1937-02-11	M	A-	5559886000	\N
EWJZ930707MDUKBO05	Lucía	Castillo	Morales	1993-07-07	F	A+	5533570191	paciente3807@example.com
WLDL890704HEOBDUJ7	Daniel	Ramírez	Hernández	1989-07-04	M	B+	\N	\N
NIEI410916XTWXKJ56	Teresa	Alvarado	Contreras	1941-09-16	Intersex	AB-	\N	\N
DXVH101118HVELRQB7	Emilio	Gutiérrez	Cruz	2010-11-18	M	AB+	\N	\N
LYHU660204XMMDEYF1	Alejandro	Guzmán	\N	1966-02-04	Intersex	A+	5579281480	\N
QOIO580915XJYIDUI4	Ana	Morales	Ramos	1958-09-15	Intersex	O+	5584288335	paciente3812@example.com
YFPX661217XAFIUWX2	Miriam	González	Fuentes	1966-12-17	Intersex	\N	5523446332	\N
CPEV470702HHSMHUF9	Andrés	Torres	González	1947-07-02	M	O+	5510762378	paciente3814@example.com
UBCN470906MPJZHBJ1	Karla	Sánchez	Cordero	1947-09-06	F	A+	5566326739	paciente3815@example.com
WMJW790128XNIDEM03	Gabriela	Ortiz	Cruz	1979-01-28	Intersex	O+	5568328233	\N
SUHG580522MKWZIM91	Paola	Jiménez	Ortiz	1958-05-22	F	AB-	5555795878	\N
MURX720525MLAPLM03	Rosa	Cordero	Hernández	1972-05-25	F	\N	5523388410	paciente3818@example.com
AWIT510106HLNVNBN5	Sergio	Cabrera	Fuentes	1951-01-06	M	AB+	5538025557	paciente3819@example.com
EVTL080530HDIVNOT7	Raúl	Delgado	Castillo	2008-05-30	M	O+	5537561904	\N
YJXC590509MNWUPI34	Cecilia	Cordero	Ramírez	1959-05-09	F	\N	5595839604	paciente3821@example.com
DRDJ500502HQLBND97	Pablo	Sánchez	González	1950-05-02	M	AB+	5540608824	paciente3822@example.com
PRZG700914XYAUZWF7	Cecilia	Ramírez	Flores	1970-09-14	Intersex	A+	5593989085	paciente3823@example.com
OPBL640907MLVZBG31	Yolanda	Jiménez	Rojas	1964-09-07	F	\N	\N	paciente3824@example.com
NVKW870519XSAKGI45	Gerardo	Cruz	Guzmán	1987-05-19	Intersex	AB-	5551015984	paciente3825@example.com
GFCO130714MSDIWVA1	Mónica	Ramos	Romero	2013-07-14	F	\N	5543571617	\N
EBES421027HILKVJ19	Andrés	Guzmán	Rojas	1942-10-27	M	AB-	5514244839	\N
BRTM060513XCVEUNS4	Mario	Mendoza	Flores	2006-05-13	Intersex	AB+	5551737234	\N
KNKR111115HINMWZM7	Arturo	Cruz	Peña	2011-11-15	M	AB+	5528742594	\N
RCLQ400319HAQYISR7	Rodrigo	Mendoza	Sánchez	1940-03-19	M	AB+	5527387248	paciente3830@example.com
NSHH500921HPLVUZM6	Ricardo	Delgado	Sánchez	1950-09-21	M	O-	5526995376	paciente3831@example.com
IUZD710813XFFSKXS7	Manuel	Ortiz	Pérez	1971-08-13	Intersex	O+	5589931926	paciente3832@example.com
YSQF760210XCOIYJQ5	Diana	Estrada	Flores	1976-02-10	Intersex	\N	5567392112	\N
CAET200517MFODREI9	Ana	Herrera	Martínez	2020-05-17	F	O+	5544675075	\N
PDIC030204MCMPGZ14	Fernanda	González	Ramírez	2003-02-04	F	B-	\N	paciente3835@example.com
DOYO370516MMXSMSN9	Ana	Gutiérrez	Sánchez	1937-05-16	F	O-	5598983973	paciente3836@example.com
DGBW981025HIYLAI34	Sergio	Vázquez	Guzmán	1998-10-25	M	B+	5543837390	paciente3837@example.com
WKYZ880403XVSDUB11	José	Rojas	Vázquez	1988-04-03	Intersex	\N	5554969447	paciente3838@example.com
HYLT520702HKKDBOK5	Raúl	Cordero	Flores	1952-07-02	M	B+	5557027892	paciente3839@example.com
FQTV140204XQSSFWR2	Manuel	Sánchez	Aguilar	2014-02-04	Intersex	\N	\N	paciente3840@example.com
ZNDO991119XLSFNKN8	Lucía	López	Medina	1999-11-19	Intersex	AB-	5588858828	\N
ODQK460316XZAVQWF4	Adriana	Castillo	Cruz	1946-03-16	Intersex	AB+	5558080579	\N
URFT680306HQCCQMK4	Antonio	Cordero	Gómez	1968-03-06	M	A-	5511803865	\N
UKUK890613HZPKDRQ2	Roberto	Solís	Aguilar	1989-06-13	M	A-	5514900666	\N
NAYE480402XEGPWPQ5	Alejandro	Ramírez	Sánchez	1948-04-02	Intersex	O+	5549522249	paciente3845@example.com
FEAL971101XVQLSF57	Gerardo	Contreras	Cordero	1997-11-01	Intersex	B-	5513093732	paciente3846@example.com
JBYF611102XVENQB81	María	Flores	Pérez	1961-11-02	Intersex	B+	5535506665	\N
AKPU400619MDDYHF22	Silvia	Sánchez	Contreras	1940-06-19	F	A-	5566257832	paciente3848@example.com
MKKE531105XBYDGGK0	Gerardo	Herrera	Ruiz	1953-11-05	Intersex	B-	5537194020	paciente3849@example.com
DTCB810319HDNIUMC8	Jorge	Guzmán	Guzmán	1981-03-19	M	A+	5582192726	paciente3850@example.com
XFPN680505MPHGUBK2	Alejandra	Mendoza	Reyes	1968-05-05	F	A-	5584851116	\N
DNJT560729XIYFAE28	Elena	Herrera	Ramírez	1956-07-29	Intersex	O-	5532524485	paciente3852@example.com
ZCLU400211HWWKNPF9	Raúl	Gómez	Ramírez	1940-02-11	M	A+	5512484417	\N
SMCR490206XSAPWRM1	Iván	Ortiz	Morales	1949-02-06	Intersex	B-	5549937269	paciente3854@example.com
GFAK460109HQKGYPQ8	Diego	Cabrera	Sánchez	1946-01-09	M	B-	5548276423	paciente3855@example.com
JXOF150802MAARBTF2	Silvia	Vázquez	Estrada	2015-08-02	F	B-	5578210567	paciente3856@example.com
MKEL880129XNXPAKX3	Sergio	Vázquez	López	1988-01-29	Intersex	B+	5535650267	\N
ZXIA820812HJISTF41	Rodrigo	Díaz	Ramos	1982-08-12	M	O-	\N	paciente3858@example.com
SVRB370527HICVYQ05	Raúl	Cabrera	Vargas	1937-05-27	M	AB+	5585648800	paciente3859@example.com
BKGF440110XDLWYTY3	Alejandro	Chávez	Peña	1944-01-10	Intersex	AB+	\N	\N
CPCS611227XJSIZKI8	Paola	Ramírez	Ruiz	1961-12-27	Intersex	A-	5515338960	\N
OVKG081201XIZSWYU8	Luis	Mendoza	Ramírez	2008-12-01	Intersex	AB-	5574436322	paciente3862@example.com
MOPQ400110XWDPUVO2	Juan	Jiménez	Ortiz	1940-01-10	Intersex	A+	5557114187	\N
JEMK790703MSOTQZT3	Diana	Rojas	Contreras	1979-07-03	F	AB+	5501711142	\N
YYUO601216XEYYMBO4	Silvia	Salazar	Jiménez	1960-12-16	Intersex	AB+	5517890236	paciente3865@example.com
HNSS531017HNTDXO97	Óscar	Delgado	Alvarado	1953-10-17	M	O+	\N	paciente3866@example.com
EECT031130XPJAEQJ3	Javier	Ramos	Herrera	2003-11-30	Intersex	O-	5543035901	paciente3867@example.com
BLBF690324XKHRCFA4	Miguel	Martínez	Sánchez	1969-03-24	Intersex	B+	5597955936	paciente3868@example.com
YFYC450615MQVYARU9	Alejandra	Torres	Chávez	1945-06-15	F	B-	5548634871	paciente3869@example.com
VARW900615HDBTSQT5	Daniel	Ramos	López	1990-06-15	M	A+	5576198802	\N
XQIE180914HIGKXAQ8	Adrián	Guzmán	Díaz	2018-09-14	M	O-	5548539683	\N
HIOH680820MPEKYO23	Silvia	Flores	Peña	1968-08-20	F	O+	5585561908	\N
PTPO760724HFMFKU56	Óscar	Gutiérrez	Ramos	1976-07-24	M	A+	5578248918	\N
IYEB100504MBTFVW09	Alejandra	Mendoza	Vargas	2010-05-04	F	B-	5507077188	\N
OSWG120626XLMEKLF6	Óscar	Fuentes	Flores	2012-06-26	Intersex	B-	5534967097	\N
EZQC570327XDADRZC1	Fernando	Solís	Pérez	1957-03-27	Intersex	A-	5580520635	paciente3876@example.com
WRSA030116XFCOZOL0	Javier	Reyes	López	2003-01-16	Intersex	AB-	5547227643	paciente3877@example.com
XOKD561215HSRWWWI8	Raúl	Gómez	Jiménez	1956-12-15	M	AB-	\N	paciente3878@example.com
SPRP780619XEZZMD19	Óscar	Estrada	Morales	1978-06-19	Intersex	AB-	5516877541	\N
UISI860110MTOXTCZ1	Diana	Rojas	Delgado	1986-01-10	F	AB-	5502763090	\N
LEGC990415XSDGIVN7	Teresa	Ruiz	García	1999-04-15	Intersex	B-	5574676654	\N
BOBP941112XGDQCJR2	Patricia	Castillo	Ortiz	1994-11-12	Intersex	O-	\N	paciente3882@example.com
MPJJ170826XGMWCTO5	Elena	López	Solís	2017-08-26	Intersex	A-	5582406858	paciente3883@example.com
CVGK600221XYEZYIZ2	Sofía	Vázquez	Herrera	1960-02-21	Intersex	B+	5502177025	paciente3884@example.com
YOSD810130HATTFVI0	Javier	Reyes	Delgado	1981-01-30	M	\N	5595825174	paciente3885@example.com
GXJN930913MAKRXVG1	Sofía	Mendoza	Flores	1993-09-13	F	B-	5561377534	\N
LZHW461216MMRLRNR3	Leticia	Peña	Cruz	1946-12-16	F	A-	5545939207	paciente3887@example.com
ANHK001221XDMATQT1	Cecilia	Morales	Cordero	2000-12-21	Intersex	B+	5548303860	paciente3888@example.com
ECQI150323MBPMMPP9	Miriam	Mendoza	Fuentes	2015-03-23	F	O+	5507824336	paciente3889@example.com
XGBF870803HLRHMXY8	Adrián	Castillo	\N	1987-08-03	M	A+	5506383466	\N
OMOS780811MQTOUNT4	Gabriela	Peña	Jiménez	1978-08-11	F	A-	5525475608	\N
FJDJ100727MUCTRWG0	Teresa	Jiménez	Castillo	2010-07-27	F	A+	5578537335	\N
GVRZ501210HEOQDI09	Gerardo	García	Cruz	1950-12-10	M	AB+	5567149838	paciente3893@example.com
QVUP400221XWYYGQE2	Patricia	Guzmán	Cordero	1940-02-21	Intersex	B+	5576024912	paciente3894@example.com
MYRC660524MNNJAC54	Silvia	Martínez	Estrada	1966-05-24	F	\N	5590130287	paciente3895@example.com
BZNU671009XVOWCJ17	Yolanda	Jiménez	Flores	1967-10-09	Intersex	O+	5512869132	\N
WQJH090615MWRNGFJ2	Diana	Ramos	Ruiz	2009-06-15	F	O-	5505075780	\N
MIER560205XQOSOBX3	Sofía	Delgado	Flores	1956-02-05	Intersex	A+	5586679016	paciente3898@example.com
MEEF831001XCIYOVF1	Gerardo	Rodríguez	Díaz	1983-10-01	Intersex	B-	5565330677	paciente3899@example.com
XKLN830112XQVEKIK7	Carmen	Chávez	Torres	1983-01-12	Intersex	AB-	5518551687	paciente3900@example.com
ILNJ761020HUQWBHX6	José	González	Díaz	1976-10-20	M	AB-	5511564058	paciente3901@example.com
GRMD411101MVQDOYP1	Verónica	Flores	Ruiz	1941-11-01	F	B+	5509020681	paciente3902@example.com
VOZD691006MVHYPG98	Teresa	Sánchez	Herrera	1969-10-06	F	AB-	5540024324	\N
ZRBX030513MRCURCO7	Guadalupe	Díaz	Rodríguez	2003-05-13	F	AB-	5524174226	paciente3904@example.com
BDAE490601MCYUYDO3	Mónica	Salazar	Sánchez	1949-06-01	F	B+	5578142663	\N
PKLV790918MHKVKT58	Alejandra	Cabrera	Torres	1979-09-18	F	AB-	5599632386	paciente3906@example.com
EEIJ690321MCXOLG17	Verónica	Cabrera	Torres	1969-03-21	F	AB-	5562102735	paciente3907@example.com
EJPL200428HNPUZA47	Juan	Vargas	Delgado	2020-04-28	M	O+	5514745501	paciente3908@example.com
IVOY531122XTSHDRR5	Verónica	Solís	Vázquez	1953-11-22	Intersex	AB-	5531706783	paciente3909@example.com
NQXX740608MOSTXYI8	Yolanda	Alvarado	Castillo	1974-06-08	F	AB+	5508253900	paciente3910@example.com
WAIB851028HISEFFQ0	Luis	Aguilar	Cordero	1985-10-28	M	AB+	5566064064	paciente3911@example.com
GQAA890320MGGDGY45	Rosa	Salazar	Alvarado	1989-03-20	F	\N	5580776775	paciente3912@example.com
QLKE811119HSNIQVN9	Francisco	Solís	Delgado	1981-11-19	M	\N	5561139554	\N
VFKL890830HWRBZQE7	Ricardo	Díaz	Pérez	1989-08-30	M	\N	5577288736	\N
LGLR070930HHTTKEU8	Gerardo	González	\N	2007-09-30	M	O+	\N	paciente3915@example.com
YBSR550828XXUMHGE6	Diego	Morales	López	1955-08-28	Intersex	AB+	5559373501	\N
WTKQ170314HYVPGAH9	Arturo	López	\N	2017-03-14	M	A+	5541892348	\N
WDKC960629HKUFQLS8	Manuel	Contreras	Cordero	1996-06-29	M	B-	5571196902	\N
UDXW681101HRHSJX55	Arturo	Alvarado	González	1968-11-01	M	A+	5512904240	paciente3919@example.com
DNJJ780412HHGUPGB9	Raúl	Ortiz	Peña	1978-04-12	M	O+	\N	\N
XHTB480623HIDAUID6	Andrés	Estrada	Pérez	1948-06-23	M	A-	5547673009	\N
RWLG970815MBQTNOQ6	Fernanda	González	González	1997-08-15	F	A-	\N	paciente3922@example.com
GXNE631204XDTAGNE6	Daniel	Ramos	Cordero	1963-12-04	Intersex	B-	5584412632	paciente3923@example.com
YXNG380920XIKSMF13	Emilio	Gómez	Solís	1938-09-20	Intersex	B-	5535227748	paciente3924@example.com
YSYN420722MKJLWXK5	Daniela	Castillo	López	1942-07-22	F	B+	5551764249	\N
PNCA530614MBVKTI82	Adriana	Salazar	Fuentes	1953-06-14	F	AB-	5569087131	paciente3926@example.com
ZAQF120203MBYWVVZ4	Patricia	Medina	Hernández	2012-02-03	F	AB+	5528836857	paciente3927@example.com
IHTG250106HYTYRRF8	Rodrigo	Pérez	Herrera	2025-01-06	M	AB+	5567504464	paciente3928@example.com
BOVQ401130HBYFRF33	Iván	Hernández	Gómez	1940-11-30	M	\N	\N	paciente3929@example.com
HPOJ951128XOWMTGB4	Elena	Medina	Cabrera	1995-11-28	Intersex	B-	5505837849	paciente3930@example.com
JELC470409XQQNUQD5	Diego	López	Mendoza	1947-04-09	Intersex	B-	\N	paciente3931@example.com
YVAX661220XYTDRCS9	Arturo	Jiménez	Mendoza	1966-12-20	Intersex	\N	5535026528	paciente3932@example.com
HAXV850704XWOXOP91	Araceli	López	Peña	1985-07-04	Intersex	O+	5581305754	\N
MECX710529HZXGSFM8	Francisco	Rodríguez	Delgado	1971-05-29	M	O-	5514243294	paciente3934@example.com
ANJK380527HGHRJLK4	Óscar	Peña	Gutiérrez	1938-05-27	M	AB-	5599419735	paciente3935@example.com
QLGH440218HEGYZZG9	Javier	Fuentes	Gómez	1944-02-18	M	B-	5515487897	\N
TAVM200602MDIGKYY3	Gabriela	Aguilar	Torres	2020-06-02	F	O-	5508232111	paciente3937@example.com
UQNU640831HCUDJC03	Arturo	Gómez	Ortiz	1964-08-31	M	B-	5557884145	paciente3938@example.com
ROQU941101XUKPMPE6	Adrián	Ortiz	Ruiz	1994-11-01	Intersex	A-	5547798733	\N
LHBU461210HWJKGOD7	Daniel	Vargas	Vargas	1946-12-10	M	B+	5571314396	paciente3940@example.com
YFVV430610MOUTXHC7	Ana	Cabrera	Herrera	1943-06-10	F	B-	\N	paciente3941@example.com
JVZD860524MIDPJKB1	Diana	Hernández	Solís	1986-05-24	F	O-	5559593185	paciente3942@example.com
CMII520715XZORKRT4	Miguel	Estrada	Chávez	1952-07-15	Intersex	A-	5562108974	paciente3943@example.com
QXJX211008MXRVDHV1	Diana	Gutiérrez	Flores	2021-10-08	F	O+	5571867308	paciente3944@example.com
UFIC700617XLCHZJC1	Gerardo	Gómez	Jiménez	1970-06-17	Intersex	AB-	5571364125	paciente3945@example.com
QDVW240212MMIRPW43	Laura	Herrera	Ramos	2024-02-12	F	AB-	5565179385	paciente3946@example.com
JVOA520712XIYMKOF7	Alejandro	Mendoza	Contreras	1952-07-12	Intersex	A-	5577157872	paciente3947@example.com
RZSW530119HRYCTFB9	José	Castillo	\N	1953-01-19	M	A-	5596355325	paciente3948@example.com
XEEC441110XEUIZI04	Araceli	Herrera	García	1944-11-10	Intersex	O-	5516694594	paciente3949@example.com
SDWJ730513XVLIWYI2	Juan	Guzmán	Vázquez	1973-05-13	Intersex	\N	5543476296	\N
MBRG700909XQSECN12	Mario	Sánchez	Reyes	1970-09-09	Intersex	A+	5541656738	paciente3951@example.com
CAMF860813XDOVKNL6	Diego	Salazar	Chávez	1986-08-13	Intersex	A+	5583312467	paciente3952@example.com
RRSA480306MZAVQJN8	Paola	Morales	Cabrera	1948-03-06	F	B+	5515969813	paciente3953@example.com
IGVF930502HSSAGEV3	Hugo	González	Cabrera	1993-05-02	M	AB+	5543805158	paciente3954@example.com
ZHYJ550703XBJWNNW0	Elena	Gómez	Herrera	1955-07-03	Intersex	B+	5538282326	paciente3955@example.com
FUPD930904HOONOJ16	Javier	Aguilar	Pérez	1993-09-04	M	A+	5503566094	\N
LBBI531205MPTNENI5	Teresa	Rojas	Mendoza	1953-12-05	F	AB-	5597616829	paciente3957@example.com
ERCA450226XQODPUZ8	Carmen	Salazar	Cabrera	1945-02-26	Intersex	A+	5556588680	\N
IVDX421229MCVHMHF7	Adriana	Díaz	Rodríguez	1942-12-29	F	AB-	5560183578	\N
RPBC470525HILANL90	Gerardo	Contreras	\N	1947-05-25	M	B+	5595755526	paciente3960@example.com
LOAZ470618MYTTCTD7	Fernanda	Torres	Chávez	1947-06-18	F	\N	5551743881	paciente3961@example.com
KMYG720729XVZUSJQ5	Juan	Torres	García	1972-07-29	Intersex	A-	5521784151	paciente3962@example.com
LSNG500902MCVGNXR3	Daniela	Rodríguez	Rojas	1950-09-02	F	AB+	5519764039	paciente3963@example.com
ULZC630405HJXXEDQ5	Miguel	Contreras	Vargas	1963-04-05	M	B+	5516896552	\N
ZIEC740301MOAAVBG8	Verónica	López	Alvarado	1974-03-01	F	\N	5547578621	paciente3965@example.com
HYMB890120XFASXNI8	Juan	Herrera	Solís	1989-01-20	Intersex	AB+	5560440999	paciente3966@example.com
DRLD861106MMQQUNL0	Sofía	Vargas	Hernández	1986-11-06	F	B+	5578815814	\N
KEXL580323HOLVXNC7	Javier	Salazar	Aguilar	1958-03-23	M	\N	5539448048	paciente3968@example.com
COTW371217MQKOKXN9	María	Chávez	Contreras	1937-12-17	F	B+	5543152082	paciente3969@example.com
EKCY760103XNXFRCZ7	Carlos	Cordero	Delgado	1976-01-03	Intersex	A+	5579664100	\N
FBVP410608XUHCAQN7	Sergio	Torres	Peña	1941-06-08	Intersex	O+	5589053779	paciente3971@example.com
MLER470913XJJKJBY4	Patricia	Chávez	Peña	1947-09-13	Intersex	AB-	5568979903	\N
KAAA731110HDYLWUY9	Adrián	Herrera	Sánchez	1973-11-10	M	A-	5541989320	paciente3973@example.com
KSKK570701XFHMNF04	Araceli	Cabrera	Alvarado	1957-07-01	Intersex	A-	5571578993	paciente3974@example.com
XDOQ130924HQFTGVE4	Francisco	Herrera	Castillo	2013-09-24	M	B+	5579476932	paciente3975@example.com
JYTA450424MTELVEI8	Verónica	Aguilar	\N	1945-04-24	F	O+	5509880253	paciente3976@example.com
YVDE860113HIJSPP87	Antonio	Gutiérrez	Ortiz	1986-01-13	M	A+	5556550528	\N
INIY120410HLFFBHS8	Manuel	Ortiz	Gutiérrez	2012-04-10	M	O+	5533185437	paciente3978@example.com
ZUSJ961231HZKRVG85	Emilio	Solís	Flores	1996-12-31	M	A+	\N	paciente3979@example.com
MAFY810623MYJJBCG4	Miriam	Peña	Castillo	1981-06-23	F	A-	5505488037	\N
JJCX750816HLXBLM92	Raúl	Salazar	Vargas	1975-08-16	M	\N	5560748529	paciente3981@example.com
WRHS110623MFJPXFB8	Beatriz	Mendoza	Cruz	2011-06-23	F	O-	5575525893	paciente3982@example.com
HOJD560924MWCVDFG3	Verónica	Ramos	Gómez	1956-09-24	F	B-	5511673749	paciente3983@example.com
DKIY100110HJEHRTO4	Diego	Solís	López	2010-01-10	M	AB-	5543740278	paciente3984@example.com
ZEFO711110HKDLRTV5	Roberto	Solís	Martínez	1971-11-10	M	A+	5530451424	paciente3985@example.com
STMI520907MZCFISX6	Claudia	Guzmán	Delgado	1952-09-07	F	\N	5519111291	paciente3986@example.com
CYCO150528MVEGZI16	Yolanda	Cruz	Díaz	2015-05-28	F	O+	5509013171	paciente3987@example.com
GZCH530221MWIOTEG9	Ana	Herrera	Romero	1953-02-21	F	O+	5528717185	paciente3988@example.com
UTXQ470518MCLWHFC1	Miriam	Guzmán	Fuentes	1947-05-18	F	O+	5535583106	\N
DNYS660121HJBISMP6	Jorge	Medina	Estrada	1966-01-21	M	B-	5508829031	paciente3990@example.com
SUDM200307XMMNKXD8	Emilio	García	Estrada	2020-03-07	Intersex	B-	5524555381	paciente3991@example.com
MKRL930315XDHPTPK7	Luis	Díaz	Medina	1993-03-15	Intersex	B-	5558143023	paciente3992@example.com
EPIY740918XZMVXNK1	Carmen	Ortiz	Delgado	1974-09-18	Intersex	AB+	5578555760	paciente3993@example.com
TAET060807MMIBQEG8	Elena	Peña	Aguilar	2006-08-07	F	B+	5558064599	paciente3994@example.com
QPTQ690729HQUFGLH9	Javier	Herrera	Sánchez	1969-07-29	M	AB+	5509586050	paciente3995@example.com
UVDE731112MFLDKPV3	Rosa	Rodríguez	Contreras	1973-11-12	F	\N	\N	paciente3996@example.com
EQSD560526MXBIDXG0	Elena	Medina	Hernández	1956-05-26	F	AB-	5529362584	paciente3997@example.com
SGHO560615HGFMBRA8	Iván	Ortiz	\N	1956-06-15	M	A+	5523885656	paciente3998@example.com
EWVM200524MGYYMYV8	Lucía	Herrera	Ramírez	2020-05-24	F	O+	\N	paciente3999@example.com
LRVW750908MJCNLUH1	Elena	Estrada	Romero	1975-09-08	F	AB+	5539931973	paciente4000@example.com
TPPO040127HWBJFLH9	Juan	Medina	Peña	2004-01-27	M	B-	5503069569	\N
DJKD411026MQPGMLG5	Teresa	Rojas	Cordero	1941-10-26	F	\N	5543459202	paciente4002@example.com
FING201018HGQHFQD2	Antonio	Ortiz	Cruz	2020-10-18	M	\N	5535394117	\N
QPKR930503MMUFRK44	Leticia	González	Gutiérrez	1993-05-03	F	A-	5516478961	\N
WGHS000405HRSXSRC9	Rodrigo	Alvarado	Rojas	2000-04-05	M	O+	5504331599	paciente4005@example.com
ERCK890420XTHGYM68	Ana	Guzmán	\N	1989-04-20	Intersex	A-	\N	paciente4006@example.com
CMMQ000823HZCVXHV7	Rodrigo	Romero	Romero	2000-08-23	M	AB+	5511979218	\N
OJLZ770802HHLCQX28	Iván	Romero	\N	1977-08-02	M	AB+	5558477267	paciente4008@example.com
TBUK750615HGGFKK55	Francisco	Chávez	Medina	1975-06-15	M	AB-	5588769704	\N
QTBF660403HWHWPYC2	Jorge	Gutiérrez	Ramos	1966-04-03	M	B+	\N	paciente4010@example.com
QKSE820430XQWXVM96	Antonio	Medina	Fuentes	1982-04-30	Intersex	AB-	5514916968	paciente4011@example.com
RKDA751024HCUDRYR2	Luis	Mendoza	Cabrera	1975-10-24	M	B-	5564051795	paciente4012@example.com
SLED921111HJMEBT55	Luis	Peña	Guzmán	1992-11-11	M	O-	5577664007	\N
WLZO490210HEWRFQU9	Jorge	Cruz	Fuentes	1949-02-10	M	AB-	5515785504	paciente4014@example.com
YWKA841226XTZJEWG6	Carlos	Ortiz	Fuentes	1984-12-26	Intersex	A+	\N	paciente4015@example.com
PKTZ430408MHBVAMH7	Karla	Estrada	Pérez	1943-04-08	F	AB-	5594445170	\N
TCDK520915HRYIGWC1	Roberto	Medina	Reyes	1952-09-15	M	A-	5534874227	\N
JWDJ120922XHSQIAH0	Yolanda	Estrada	Chávez	2012-09-22	Intersex	B+	5588074488	\N
WUQM380905XFRYWFU0	Eduardo	Contreras	Vargas	1938-09-05	Intersex	B+	5514529999	\N
GQWR890302HNXUSW64	José	Hernández	Martínez	1989-03-02	M	AB-	5551865614	\N
ZMAA230630HKGFLR44	Gerardo	Chávez	Torres	2023-06-30	M	\N	5597121069	paciente4021@example.com
SORG031016XUICFU20	Diana	Vázquez	Vargas	2003-10-16	Intersex	\N	5545730711	\N
OVHR941216HOHVGJE7	Ricardo	Cruz	Aguilar	1994-12-16	M	A+	5505046578	\N
GCEW160630MJBDHXL6	Leticia	Aguilar	Vargas	2016-06-30	F	B-	5533978503	paciente4024@example.com
YUIT530916MTVFBQY7	Verónica	Reyes	Mendoza	1953-09-16	F	B-	\N	paciente4025@example.com
WSDY920709HKHFPNN9	Óscar	Gutiérrez	Alvarado	1992-07-09	M	B-	5585142370	\N
XHQI510405XHWNMCE3	Hugo	Mendoza	Rodríguez	1951-04-05	Intersex	B-	5588457750	paciente4027@example.com
RYTA691102XYBCDC81	Mónica	Contreras	Peña	1969-11-02	Intersex	B-	5552858930	paciente4028@example.com
PPSR800505HBRPJK03	José	Vargas	López	1980-05-05	M	B+	5537283009	\N
UDNB440317HEEEOYR2	Fernando	Vázquez	Aguilar	1944-03-17	M	O-	5527710501	paciente4030@example.com
ECGW170811XVRGBQP3	Teresa	Jiménez	Chávez	2017-08-11	Intersex	A-	5546226424	\N
FLTD530129HJWIPH93	Gerardo	Rodríguez	Díaz	1953-01-29	M	A-	5536707628	\N
KEJU240112XJARUJ57	Daniela	Delgado	Romero	2024-01-12	Intersex	O-	\N	\N
NRPV421024MPRDDNR9	Diana	Rojas	Fuentes	1942-10-24	F	O+	5548389665	\N
BOFW060603MROEOYW7	Araceli	Cordero	Castillo	2006-06-03	F	A-	5582913133	paciente4035@example.com
MXEF000426HFEKIJY3	Sergio	Cabrera	Rojas	2000-04-26	M	AB+	5539266919	paciente4036@example.com
ZJCK090530XYWTRIR9	Pablo	Morales	García	2009-05-30	Intersex	AB+	5594847167	paciente4037@example.com
NJUR680625MHZXAT68	Silvia	Ortiz	Mendoza	1968-06-25	F	O+	5555064033	paciente4038@example.com
YJVU391214MBRLWSV5	Cecilia	Aguilar	Alvarado	1939-12-14	F	O-	5595722816	paciente4039@example.com
EMOC960820XNSOORE9	Óscar	Peña	López	1996-08-20	Intersex	AB-	5531481247	paciente4040@example.com
AWEB650720XMKCKOI0	Rodrigo	Alvarado	\N	1965-07-20	Intersex	A+	5519053626	\N
BLUG711024MMELNVZ5	Adriana	Salazar	Alvarado	1971-10-24	F	B+	5519011707	paciente4042@example.com
IHVX880109HWSSNBZ7	Hugo	Rodríguez	Guzmán	1988-01-09	M	B-	5575071297	paciente4043@example.com
HEUZ160215HFZQPLQ2	Eduardo	Fuentes	Guzmán	2016-02-15	M	\N	5500567418	paciente4044@example.com
BIIR960517XGSCPGC0	Claudia	Gutiérrez	López	1996-05-17	Intersex	\N	5557879704	\N
IGEC740124MLWTNN82	Paola	Torres	Peña	1974-01-24	F	A+	5530739370	paciente4046@example.com
KRJU820613HSTAUB44	Manuel	Salazar	Romero	1982-06-13	M	A-	5579270855	\N
JHJI200902HRJMNXH1	Roberto	Castillo	Ruiz	2020-09-02	M	AB-	5516230248	paciente4048@example.com
WFBE060923XWPEXXW7	Beatriz	Medina	Pérez	2006-09-23	Intersex	B-	5562554831	paciente4049@example.com
DDPT470630HMRYLDT5	Iván	Ramírez	López	1947-06-30	M	O+	5585491248	paciente4050@example.com
MHDI950411XGOOAVG4	Yolanda	Hernández	Rodríguez	1995-04-11	Intersex	A-	5592044635	paciente4051@example.com
TWSF810525HBOPBL57	Luis	Pérez	Sánchez	1981-05-25	M	A+	5575333565	paciente4052@example.com
EXQR370513HWZIKFY9	Daniel	Gutiérrez	Sánchez	1937-05-13	M	A-	5594726970	paciente4053@example.com
HGUW820315XGRUCWY9	Eduardo	Contreras	Fuentes	1982-03-15	Intersex	AB-	5507838865	paciente4054@example.com
KJMW070504XMULEE79	Mónica	Peña	Solís	2007-05-04	Intersex	AB-	5533968860	\N
SQFT480218HSXOWN21	Mario	Ramos	Cordero	1948-02-18	M	B+	5598963277	paciente4056@example.com
RUGY530914MIRIAGZ2	María	Ramos	López	1953-09-14	F	\N	5555444792	paciente4057@example.com
SQDE781123XVCDWRU8	María	García	Castillo	1978-11-23	Intersex	\N	5539295786	paciente4058@example.com
VUEK941015MMGBQAD0	Leticia	Martínez	Estrada	1994-10-15	F	O+	5581074126	paciente4059@example.com
EQBO190216HVUETWT4	José	Peña	Jiménez	2019-02-16	M	AB-	5522696407	paciente4060@example.com
HIKW891029XLKYJZ40	Gerardo	Jiménez	Medina	1989-10-29	Intersex	AB+	5578054071	paciente4061@example.com
ADCP741128XWNECK68	Laura	Peña	Rojas	1974-11-28	Intersex	AB-	5545033152	\N
BRUV120618MCFVPXT9	Verónica	Chávez	Gómez	2012-06-18	F	A-	5590011284	paciente4063@example.com
WIMX020522HPPUWUX2	Emilio	Rojas	Jiménez	2002-05-22	M	AB+	5590826815	\N
TQRB880514HWISWC91	Javier	Gómez	Delgado	1988-05-14	M	AB-	5500159197	paciente4065@example.com
IPUX651030MQECOVN8	Gabriela	Díaz	Solís	1965-10-30	F	O-	5550564202	\N
LEWK730824MFVSFYS2	Gabriela	Cruz	Ramos	1973-08-24	F	O+	5590425843	\N
RBPP480317XEEIIDR6	Claudia	Pérez	Guzmán	1948-03-17	Intersex	A-	5578845930	paciente4068@example.com
WKEL780331MPFIZTJ5	Teresa	Delgado	Mendoza	1978-03-31	F	\N	5540069646	paciente4069@example.com
HXOA610315HCYUJCV5	Emilio	Romero	Ramírez	1961-03-15	M	O-	5551775786	\N
QOMM640519HFMTBSF1	Antonio	Mendoza	Cordero	1964-05-19	M	AB+	5523625378	paciente4071@example.com
GYVX690731HDVYYYZ8	Mario	Vargas	Solís	1969-07-31	M	\N	5578033231	paciente4072@example.com
PBKR181004XZAGBPG4	Hugo	Fuentes	Cabrera	2018-10-04	Intersex	AB+	\N	\N
CYCU990212XCYHSPO0	Iván	Medina	Díaz	1999-02-12	Intersex	A-	5510519681	paciente4074@example.com
OWMI241121XHZXEMN1	Carmen	Alvarado	Sánchez	2024-11-21	Intersex	B+	5538224429	paciente4075@example.com
YFJA211228HTPKFXZ0	Eduardo	Reyes	Rodríguez	2021-12-28	M	AB+	5554311309	paciente4076@example.com
CTYI481108HFFQLEL0	Sergio	Guzmán	Solís	1948-11-08	M	B+	5530062305	\N
GJXL811030MOWGXUS6	Araceli	Vargas	Guzmán	1981-10-30	F	B-	5567499883	paciente4078@example.com
OHON850515MMANFLN7	Diana	Pérez	Sánchez	1985-05-15	F	AB-	5557441539	paciente4079@example.com
ZJQT211010MSIAUC95	Araceli	López	Romero	2021-10-10	F	O-	5549687368	paciente4080@example.com
QTVC171211XXHJTXM1	Karla	Estrada	Aguilar	2017-12-11	Intersex	AB+	5555031093	paciente4081@example.com
OTPH080718XXYMYP79	Ana	Gómez	Aguilar	2008-07-18	Intersex	\N	5501962231	\N
AIII010617HUJAOEF1	Carlos	Gómez	Reyes	2001-06-17	M	O-	5559667956	\N
CSGZ211026HMGGSK55	Andrés	Morales	Reyes	2021-10-26	M	AB-	5597761276	paciente4084@example.com
BZSN250130MTBAIC61	Miriam	Estrada	Rodríguez	2025-01-30	F	A-	5520666102	paciente4085@example.com
ZXQU650419HQYSHI27	Luis	Vargas	Sánchez	1965-04-19	M	A-	\N	\N
XQKS250313XPHPBMH2	Juan	Castillo	Jiménez	2025-03-13	Intersex	B+	5551951322	paciente4087@example.com
RADP450830MUXXBUW6	Daniela	Ramos	\N	1945-08-30	F	B+	5504578847	\N
IWLW210719XDKQFX94	Fernando	Ruiz	García	2021-07-19	Intersex	A-	5556858697	paciente4089@example.com
QTDC850404MOXJKNG8	Mónica	Jiménez	\N	1985-04-04	F	B-	\N	\N
UXON940502MYREKJE3	Guadalupe	Díaz	Gutiérrez	1994-05-02	F	A+	\N	paciente4091@example.com
RXJG461116HTWHTL28	Raúl	Guzmán	González	1946-11-16	M	B+	5550547674	paciente4092@example.com
NPQE550730XGNFVP94	Hugo	Vázquez	Medina	1955-07-30	Intersex	A+	5574051717	paciente4093@example.com
NDGQ080603XDJFAVD2	Beatriz	Jiménez	Salazar	2008-06-03	Intersex	\N	5534036275	paciente4094@example.com
THEN140522XOIWKZJ0	Iván	Cruz	Ortiz	2014-05-22	Intersex	\N	5507598173	\N
XAYG991127HNBGNA82	Fernando	Martínez	Ramírez	1999-11-27	M	AB-	5557584987	paciente4096@example.com
BVWS531206MGDTTUO8	Carmen	Solís	González	1953-12-06	F	AB+	5552313358	paciente4097@example.com
RKUY041002HAIIZRY0	Roberto	Medina	Martínez	2004-10-02	M	O-	\N	paciente4098@example.com
VYFD971016HTSURUN9	Miguel	Peña	Hernández	1997-10-16	M	AB+	5507331256	paciente4099@example.com
EDIY910407MBEISS78	Ana	Torres	López	1991-04-07	F	A-	5542171152	\N
ZLUF170825HOPMLXW9	Jorge	Fuentes	Ortiz	2017-08-25	M	A+	5553242547	paciente4101@example.com
TYRT091023MNVDQOU2	Paola	Aguilar	Delgado	2009-10-23	F	\N	5528170262	\N
VHCN511107XOEBRH98	Iván	Ramírez	Ortiz	1951-11-07	Intersex	\N	5561086226	paciente4103@example.com
XNNT550627MIEKBLV6	Teresa	Pérez	García	1955-06-27	F	A+	5555933841	paciente4104@example.com
XVXZ940915MUDKLUM8	Verónica	Sánchez	Medina	1994-09-15	F	\N	5569753847	paciente4105@example.com
NNCD591001MWGDXPY1	Alejandra	Cabrera	Rojas	1959-10-01	F	B-	5586504870	paciente4106@example.com
BDAN000220XOXWMIW4	Mario	Flores	Solís	2000-02-20	Intersex	O+	5502018732	paciente4107@example.com
BUXT690830MBLYUH60	Diana	Castillo	Salazar	1969-08-30	F	B-	5546503240	paciente4108@example.com
RQZV211104HKUIXUL3	José	Guzmán	Jiménez	2021-11-04	M	B+	5598376389	paciente4109@example.com
WGWV690524MYMKJP24	Guadalupe	Herrera	Rojas	1969-05-24	F	AB+	5511084399	\N
PLDI790402HMABEKM0	Fernando	Solís	Ruiz	1979-04-02	M	O+	5558403449	paciente4111@example.com
DOOJ250613HTLAGKR4	Rodrigo	Cabrera	Torres	2025-06-13	M	A+	5530581355	\N
ARTX250208HGRVOLU9	Diego	Romero	Díaz	2025-02-08	M	\N	5568066643	\N
PROU120525MGMFYD94	Claudia	Herrera	López	2012-05-25	F	\N	\N	paciente4114@example.com
RXZS441019MDCNMD43	Alejandra	Chávez	Ortiz	1944-10-19	F	B+	5574221991	\N
PDUX210809HBEUBYJ3	Eduardo	García	Vargas	2021-08-09	M	B+	5550961830	\N
RTXT150127XTYHFRQ0	Emilio	Gómez	Salazar	2015-01-27	Intersex	O+	5582693132	paciente4117@example.com
UBVF200528MELSWD03	Carmen	Rodríguez	Rodríguez	2020-05-28	F	A-	5545342105	paciente4118@example.com
RHDB701123XHBXVLJ7	Leticia	Estrada	González	1970-11-23	Intersex	O+	5541844043	paciente4119@example.com
XYBK390812HYUYYUX5	Raúl	Ruiz	Díaz	1939-08-12	M	\N	5544526465	\N
IDTD470312HUNERQT4	Gerardo	Vázquez	Reyes	1947-03-12	M	\N	5575314808	\N
GETN050201HCSXHAA2	Pablo	Castillo	Solís	2005-02-01	M	O+	5506473958	\N
JCXC020111XOBYOFP0	Patricia	Rodríguez	Guzmán	2002-01-11	Intersex	\N	5594666298	\N
UYIG791227XIUCPNV0	Adrián	Medina	Ruiz	1979-12-27	Intersex	A-	5529193051	\N
QYZI560619HZIZNKI4	Andrés	Herrera	Delgado	1956-06-19	M	\N	5565234304	\N
LMSC750228HAGLFJG5	Miguel	Ruiz	Cruz	1975-02-28	M	B+	5599581850	\N
CNGI161212HPADMYX4	Arturo	Vázquez	Flores	2016-12-12	M	O-	5584293631	paciente4127@example.com
DJUC241014MDDBTJ69	Cecilia	Pérez	Vázquez	2024-10-14	F	O+	5567985864	paciente4128@example.com
JYXB770717XIFUDC03	Carlos	Rojas	Sánchez	1977-07-17	Intersex	A-	5501663313	paciente4129@example.com
SRJI810420HURSTQM5	Gerardo	Guzmán	González	1981-04-20	M	\N	5544853124	paciente4130@example.com
VNJY531223MYRUVT30	Yolanda	Mendoza	Rodríguez	1953-12-23	F	B+	5540014913	\N
MEDM370717HHCKOO01	Daniel	Solís	Flores	1937-07-17	M	B-	5535513649	\N
LESX580624HUNOUFT3	Carlos	Aguilar	Ortiz	1958-06-24	M	B+	5501492791	paciente4133@example.com
JVEQ540610HTAMMSC4	Rodrigo	Aguilar	Rojas	1954-06-10	M	AB+	5564304497	paciente4134@example.com
DKOM671008XBNPZVA0	Diego	Cordero	Contreras	1967-10-08	Intersex	O-	5580024318	paciente4135@example.com
ULWG600529HGJHMKS7	José	Peña	Flores	1960-05-29	M	O+	5516236595	paciente4136@example.com
WVZV000929XYNQYXX7	Gabriela	Cabrera	González	2000-09-29	Intersex	B+	5545288250	paciente4137@example.com
MOQB601214HVSEFOM5	Diego	Vázquez	Solís	1960-12-14	M	B-	5597729898	paciente4138@example.com
VWPJ530424MNRVMH64	Daniela	Delgado	Morales	1953-04-24	F	O+	5537285839	\N
WMBP030919HVGUPOF5	Adrián	Vázquez	García	2003-09-19	M	O+	5538064900	paciente4140@example.com
GRHW080110HBJBJPT1	Arturo	Herrera	Rojas	2008-01-10	M	AB+	5523652893	paciente4141@example.com
IJLR440109HFLUUOR2	Antonio	Chávez	Vargas	1944-01-09	M	A-	5572043934	paciente4142@example.com
SIMR160810HPQOWDP9	José	Jiménez	Mendoza	2016-08-10	M	B-	5538543366	paciente4143@example.com
XATM100518XNOUFD12	Alejandra	González	Reyes	2010-05-18	Intersex	B-	5585788434	paciente4144@example.com
UNCB800203XKVOENU2	Iván	García	Hernández	1980-02-03	Intersex	\N	5546159654	\N
LNUQ870408HRMUOH72	Rodrigo	Martínez	García	1987-04-08	M	A+	5559993312	paciente4146@example.com
HYAV090928XAKCNZ05	Beatriz	Reyes	Ruiz	2009-09-28	Intersex	A+	5543194657	\N
QJMF640331XIXHWZH4	Gabriela	Herrera	Ortiz	1964-03-31	Intersex	A-	5503411462	paciente4148@example.com
ZQAV120523XTIZTGA5	Lucía	Ramos	Rodríguez	2012-05-23	Intersex	B-	5500946748	\N
LZGH370224MSKVCL34	Laura	Pérez	Contreras	1937-02-24	F	AB+	\N	paciente4150@example.com
GCFI770222MNULGXA7	Araceli	Medina	\N	1977-02-22	F	A+	5529955215	paciente4151@example.com
SOUK760508HLLSNQQ1	Adrián	Jiménez	Salazar	1976-05-08	M	A-	5528887569	paciente4152@example.com
ZWMT560514XEBERUM5	José	Salazar	Chávez	1956-05-14	Intersex	A+	5576756673	paciente4153@example.com
DIZO831204MTZMRKF9	Cecilia	Fuentes	Sánchez	1983-12-04	F	O+	5551520350	paciente4154@example.com
PQIJ861011HSYNICH3	Gerardo	Castillo	Martínez	1986-10-11	M	B-	5589270069	paciente4155@example.com
JKAO120207HMFJRMR4	Luis	Estrada	Hernández	2012-02-07	M	\N	5559517743	\N
FANH461016HIQGFHT8	Luis	Peña	Hernández	1946-10-16	M	AB+	5515213867	paciente4157@example.com
QLXT980705HAZOCH94	Óscar	Vargas	Torres	1998-07-05	M	B-	5584586162	paciente4158@example.com
TYGX800102XHWBUWQ4	Javier	Jiménez	Salazar	1980-01-02	Intersex	\N	\N	paciente4159@example.com
EGXU491219XQVUVM33	Gabriela	Chávez	Sánchez	1949-12-19	Intersex	AB-	5500860780	\N
DFZV080219XYKUDY37	Luis	Vázquez	Aguilar	2008-02-19	Intersex	AB+	5536713908	paciente4161@example.com
BDEY001218XQFPGCX4	Carlos	Herrera	Cruz	2000-12-18	Intersex	A+	\N	\N
OZBF450909XVIIXLJ0	Patricia	Contreras	Chávez	1945-09-09	Intersex	\N	5581854805	paciente4163@example.com
NQLA170608HKEYSHV4	Mario	Peña	Ramos	2017-06-08	M	O-	\N	paciente4164@example.com
FLOI140428HMKUIUQ8	Sergio	Cruz	Medina	2014-04-28	M	O+	5544680234	\N
XEYV860609HNBDQRA3	Jorge	Romero	Cordero	1986-06-09	M	\N	5514590970	paciente4166@example.com
CJSJ630905XJDCDMQ9	Manuel	Ortiz	Salazar	1963-09-05	Intersex	AB+	5594897096	paciente4167@example.com
BAUV201201XQAPHLC1	Gerardo	Chávez	Peña	2020-12-01	Intersex	B-	5534842981	paciente4168@example.com
TASA230608XODOBEB2	Adriana	Rojas	Delgado	2023-06-08	Intersex	\N	\N	paciente4169@example.com
ATDC781227HSZDJQ93	Emilio	Reyes	Guzmán	1978-12-27	M	AB-	5535671949	paciente4170@example.com
XANT600613MBRRJAM8	Alejandra	Romero	Pérez	1960-06-13	F	AB-	5535966235	paciente4171@example.com
RGOP560821MTEXSK44	Karla	Peña	Jiménez	1956-08-21	F	O+	5579376028	paciente4172@example.com
BEZI231202MZMCJCJ2	Miriam	Cruz	Medina	2023-12-02	F	B-	5504849511	\N
QPRI621106MCZQLM38	Silvia	Castillo	Ramírez	1962-11-06	F	\N	5532162392	paciente4174@example.com
IIVG390824XQBOOJQ2	Carmen	Rojas	Torres	1939-08-24	Intersex	O-	5550479476	\N
VKQK700429XGENMEW2	Francisco	Ruiz	Rojas	1970-04-29	Intersex	\N	5516944424	paciente4176@example.com
QJMC820409MDYGQIU1	Silvia	Romero	Ramos	1982-04-09	F	A-	5502999030	\N
NFLZ930104XALPLUJ1	Rosa	Guzmán	Estrada	1993-01-04	Intersex	B+	5542106646	paciente4178@example.com
OMYY381005HANWTJI0	Sergio	Castillo	\N	1938-10-05	M	A+	5525885238	\N
RUJP740210MUIADRD7	Miriam	Ortiz	Vargas	1974-02-10	F	AB+	5513010356	paciente4180@example.com
TFGM600508MDDZUN37	Teresa	Solís	Torres	1960-05-08	F	B+	5573133411	paciente4181@example.com
XLSP951122HHEYVQZ8	Miguel	Contreras	Reyes	1995-11-22	M	AB-	\N	paciente4182@example.com
GTSD800516MEBMVCV5	Beatriz	Hernández	Díaz	1980-05-16	F	\N	5528377522	paciente4183@example.com
XKYD180610MSEPUKR1	Fernanda	Ruiz	Ruiz	2018-06-10	F	O+	5558588346	\N
YCCD730519MYMQRAL8	Miriam	Fuentes	Sánchez	1973-05-19	F	O-	5595425043	paciente4185@example.com
CXYJ810530HRSBQBQ9	Fernando	Ramírez	\N	1981-05-30	M	B+	5595343306	paciente4186@example.com
HNXX580326MSEGRFK0	Guadalupe	Díaz	Cruz	1958-03-26	F	B-	\N	paciente4187@example.com
NXYR020320XGAZKH48	Carlos	Cruz	Peña	2002-03-20	Intersex	B+	5598668198	paciente4188@example.com
IVNN550816MKSYGLK3	Miriam	Herrera	Alvarado	1955-08-16	F	\N	5512122701	paciente4189@example.com
HPVW851024XXZGTHL5	Alejandro	Cordero	Ramos	1985-10-24	Intersex	O+	\N	paciente4190@example.com
SNXP421012HUXAHDA5	Jorge	Guzmán	Rodríguez	1942-10-12	M	A-	5518098205	paciente4191@example.com
HCEQ950813HIOXTIP3	Hugo	Morales	Rojas	1995-08-13	M	O-	5521664445	paciente4192@example.com
QPQX821207XHABLPW2	Adrián	Torres	González	1982-12-07	Intersex	B-	5583649289	paciente4193@example.com
HAAP670107MZVFDRK6	Araceli	Salazar	Alvarado	1967-01-07	F	B-	5553821810	paciente4194@example.com
IVZH450503XFCIOJO5	Emilio	Ortiz	Peña	1945-05-03	Intersex	B+	5510975877	paciente4195@example.com
SMZA820721XROBTSN5	Karla	Alvarado	Herrera	1982-07-21	Intersex	B+	5576293177	\N
ZNNS610211MJDNFBP1	Patricia	Reyes	Peña	1961-02-11	F	B-	5515731430	paciente4197@example.com
ALVA930308MHKCYQN8	Laura	Aguilar	\N	1993-03-08	F	AB+	\N	paciente4198@example.com
FUER130701HYHERUA0	José	Salazar	Salazar	2013-07-01	M	AB+	5564245819	paciente4199@example.com
FVYE990830HUXFNDZ7	Daniel	Castillo	Cruz	1999-08-30	M	A-	5560538944	paciente4200@example.com
JXYC960930MHFGOCW3	Teresa	Cordero	\N	1996-09-30	F	B-	5579539455	paciente4201@example.com
UXDY630425HKJPZHY5	Javier	Solís	Chávez	1963-04-25	M	A-	\N	\N
KIMC040402MEQALUT3	Fernanda	Ramos	García	2004-04-02	F	O-	5532255600	\N
HNIH400509HOIQYEZ2	Manuel	Ramos	Salazar	1940-05-09	M	A-	5598618891	paciente4204@example.com
CEZI551012XOAIXGG2	Leticia	Castillo	Estrada	1955-10-12	Intersex	B+	5502140991	paciente4205@example.com
ODAW480827XCTCZZU4	Paola	Cruz	Pérez	1948-08-27	Intersex	O+	5524806420	paciente4206@example.com
VFAV070115XBWFNQN9	Verónica	Salazar	Morales	2007-01-15	Intersex	AB-	5507349538	paciente4207@example.com
CYYV171208HLBXMJ25	Carlos	Reyes	Alvarado	2017-12-08	M	AB+	5561396110	paciente4208@example.com
HJBU841224MHNDZV74	Beatriz	Solís	Torres	1984-12-24	F	O+	5548546008	\N
GEZA250208HYOPXFZ1	Arturo	Ortiz	Chávez	2025-02-08	M	B-	5584933147	paciente4210@example.com
HJRN761229XUGVAC78	Javier	Castillo	Fuentes	1976-12-29	Intersex	B+	5502528431	\N
XBHL520723XFYSJOL3	Rodrigo	Díaz	Jiménez	1952-07-23	Intersex	O+	\N	paciente4212@example.com
KFJZ370514MIFGHVF1	Verónica	Medina	Flores	1937-05-14	F	A-	5573421769	paciente4213@example.com
VRUI700531XLFEAK49	Leticia	Guzmán	Estrada	1970-05-31	Intersex	\N	5584554273	\N
ZAQC510310XUQZHF71	Antonio	Romero	Solís	1951-03-10	Intersex	B-	5572676879	paciente4215@example.com
EUOS610514MZPEQRJ4	Fernanda	López	Pérez	1961-05-14	F	AB+	5585932109	paciente4216@example.com
ADPR761006METUFN68	Fernanda	Chávez	Aguilar	1976-10-06	F	\N	5555196578	\N
YGDI471207XWAIDKP5	Gabriela	Sánchez	Cruz	1947-12-07	Intersex	B+	5513702689	paciente4218@example.com
FBTH760529HLOJJC71	Juan	Martínez	Ramos	1976-05-29	M	B+	5595071415	paciente4219@example.com
CDRO131220HZEQWY84	Emilio	Torres	Contreras	2013-12-20	M	A-	5597903565	\N
PZPU250527MQWJYAO1	Yolanda	Estrada	Alvarado	2025-05-27	F	O+	5595325085	paciente4221@example.com
NSNM130130MREXJYR7	Lucía	Ramírez	Vargas	2013-01-30	F	B+	5525976924	paciente4222@example.com
NECF121217MBJAPRT4	Rosa	Díaz	Ramos	2012-12-17	F	A-	5500315391	\N
ZOMH071021MCKQNZB4	Guadalupe	Salazar	\N	2007-10-21	F	B-	\N	\N
RVHJ160429HRVHBQY3	Carlos	Pérez	Contreras	2016-04-29	M	AB-	\N	paciente4225@example.com
AOTI820126HCIYEQL4	Miguel	Alvarado	Solís	1982-01-26	M	\N	5514468204	paciente4226@example.com
TITQ810829HAVAUNW9	Mario	Fuentes	\N	1981-08-29	M	B-	5547957651	paciente4227@example.com
ECAP050709XUAXHFS7	Diego	Hernández	Rodríguez	2005-07-09	Intersex	A+	5512246394	paciente4228@example.com
THKA420310HERVLAG4	Javier	Ortiz	Alvarado	1942-03-10	M	AB+	5577353686	paciente4229@example.com
BFPO690529MYLXSCF0	Carmen	Estrada	Vargas	1969-05-29	F	AB-	5548351670	\N
QYNV920908HTWKSXR6	Hugo	Rojas	Romero	1992-09-08	M	AB-	5538522197	paciente4231@example.com
CTYB831019MNIKOWD0	Beatriz	Mendoza	Hernández	1983-10-19	F	A+	5529566805	\N
ZSXJ660808XQOZPXY1	Adriana	Gutiérrez	Chávez	1966-08-08	Intersex	A+	5585314000	\N
LCOC230226MHMJIKL3	Leticia	Alvarado	Alvarado	2023-02-26	F	AB+	5599798512	\N
TKWN940823HTFZHC73	Iván	Flores	Ramos	1994-08-23	M	O-	5542560351	paciente4235@example.com
IUVQ800920HNANCVV0	Raúl	Vázquez	Rodríguez	1980-09-20	M	B+	5548743900	paciente4236@example.com
IBXS160308HNIMMIL4	Rodrigo	Hernández	Estrada	2016-03-08	M	B+	5582754307	paciente4237@example.com
UDYL801203HOISSYZ4	Manuel	Solís	Gutiérrez	1980-12-03	M	AB-	5536611761	\N
VIUY640831HBISQVY1	Mario	Flores	Peña	1964-08-31	M	O-	5524789146	paciente4239@example.com
UFIB510201XACXEBJ9	Javier	Aguilar	Peña	1951-02-01	Intersex	\N	5555481726	paciente4240@example.com
JBIO070319XFCCPIX6	Sergio	González	Cabrera	2007-03-19	Intersex	O+	5567140620	paciente4241@example.com
RMIR650317XTODZIP9	Gerardo	Solís	Vargas	1965-03-17	Intersex	AB+	5500986780	paciente4242@example.com
YTAF990919HLPKCB91	Luis	Reyes	Morales	1999-09-19	M	A-	5590154056	\N
PKGT740828XRSLJO09	Fernanda	Chávez	Rodríguez	1974-08-28	Intersex	O+	5515863195	paciente4244@example.com
NFVF200602HIRYCHI9	Antonio	Ramos	Delgado	2020-06-02	M	B+	5587276511	paciente4245@example.com
YWGD661120HUAMVLK6	Jorge	López	Rojas	1966-11-20	M	AB-	5576391710	\N
EQMW900103HIPUTFM1	Alejandro	González	\N	1990-01-03	M	AB-	5561147882	paciente4247@example.com
EMJG000926MTVNTIW9	Elena	Rodríguez	Alvarado	2000-09-26	F	O-	5516131489	paciente4248@example.com
MFHA020104HXDYXZN7	Adrián	Cabrera	Sánchez	2002-01-04	M	O-	5593276652	paciente4249@example.com
JXXJ570918XBDWIWM6	Rodrigo	Reyes	\N	1957-09-18	Intersex	AB+	5546902466	paciente4250@example.com
SOCX740311XQSHHDQ7	Javier	Solís	Ramírez	1974-03-11	Intersex	A+	5552488071	paciente4251@example.com
SCQK121118XCMQMEH2	Diana	Castillo	Gutiérrez	2012-11-18	Intersex	B+	5508159732	\N
CKSI710120XFSMRTS5	Fernanda	Cordero	Sánchez	1971-01-20	Intersex	AB-	5599872607	\N
KEYR481012MKCWYGI9	Leticia	Martínez	Vargas	1948-10-12	F	O+	5571373884	paciente4254@example.com
KRJT040410MPVWFX47	Rosa	Morales	Torres	2004-04-10	F	O-	5550948326	\N
PYYT480530MJMRLOY7	Fernanda	Torres	Fuentes	1948-05-30	F	\N	5534058290	paciente4256@example.com
FEOG070118MVYLSYS7	Guadalupe	Gutiérrez	Herrera	2007-01-18	F	O-	5555340109	paciente4257@example.com
STVV851207XAOWGPB7	Pablo	Romero	Torres	1985-12-07	Intersex	B+	5548750029	paciente4258@example.com
BJFX740927HCVMQKF6	Diego	Estrada	Ramos	1974-09-27	M	A-	5572089791	paciente4259@example.com
LVMT980719XVHTRZI1	Patricia	Reyes	Alvarado	1998-07-19	Intersex	AB+	\N	paciente4260@example.com
FIEW570627XVOUZZ81	Claudia	Ramos	Herrera	1957-06-27	Intersex	O+	5500075371	paciente4261@example.com
BXHN510205MFMZIIO3	Verónica	Flores	Estrada	1951-02-05	F	A+	5578855749	\N
OGAV591115MEGNBHG6	Beatriz	Cruz	Contreras	1959-11-15	F	B-	\N	paciente4263@example.com
WEUB710702MYKCVP31	Sofía	González	Cabrera	1971-07-02	F	\N	5574944231	paciente4264@example.com
HDTD380610HWWVSX25	Luis	Díaz	Guzmán	1938-06-10	M	AB+	5532670456	paciente4265@example.com
MKIO790423XZWZEEN0	Mario	Romero	Ortiz	1979-04-23	Intersex	A-	\N	paciente4266@example.com
BLNP810115XNQBFZB3	Sergio	Salazar	Salazar	1981-01-15	Intersex	B+	5523312278	\N
WBGJ430825HIJQUB37	José	Salazar	Contreras	1943-08-25	M	A-	5534536535	paciente4268@example.com
GRSA641109XLBKFM66	Rosa	Chávez	Medina	1964-11-09	Intersex	AB+	5565640600	paciente4269@example.com
YYBX460722XAUXYNO9	Fernando	Martínez	Gutiérrez	1946-07-22	Intersex	A+	5548403133	paciente4270@example.com
IFZQ391012MKCOUPX6	Lucía	Contreras	Salazar	1939-10-12	F	B-	5558846918	\N
BLFI600617MKOYTKF7	Mónica	Alvarado	Medina	1960-06-17	F	O+	5549527616	paciente4272@example.com
IFNW860726HZKCSV36	Miguel	Gómez	Castillo	1986-07-26	M	A+	\N	paciente4273@example.com
HKAK450821XZPAKSG7	Elena	Ramírez	Romero	1945-08-21	Intersex	\N	5566342833	\N
PXWG110320XPDCSC62	Elena	Medina	Alvarado	2011-03-20	Intersex	O+	5560454096	paciente4275@example.com
YCGJ191127XRFNLXV1	Eduardo	Vázquez	Hernández	2019-11-27	Intersex	A+	5578348195	paciente4276@example.com
TAGK230331MYVLZXK9	Carmen	Castillo	Guzmán	2023-03-31	F	AB-	5596501772	paciente4277@example.com
NTYD670723HDHDQY83	Arturo	Vázquez	Guzmán	1967-07-23	M	A-	5589427838	paciente4278@example.com
NDID891203MRWBCH54	Yolanda	Gutiérrez	Guzmán	1989-12-03	F	A+	5587116714	paciente4279@example.com
SKTO210402HKNQKWT2	Rodrigo	Vargas	Rodríguez	2021-04-02	M	O+	5571249443	paciente4280@example.com
UVNA760528MZSPQI63	Yolanda	Torres	Cabrera	1976-05-28	F	\N	5592428112	paciente4281@example.com
EQQO761017XOPRXPM1	Emilio	Flores	Vázquez	1976-10-17	Intersex	A-	5503574339	paciente4282@example.com
SOQQ470513HMHAIA34	Emilio	Cordero	Morales	1947-05-13	M	O-	5588866318	\N
ZVBH650720MJSIMOC2	Gabriela	Romero	Reyes	1965-07-20	F	AB-	5506704803	paciente4284@example.com
TAZH861019MKXLMIE6	Leticia	Morales	García	1986-10-19	F	AB-	5509069122	paciente4285@example.com
ENGC660529XACZHZ68	Gabriela	Herrera	\N	1966-05-29	Intersex	O+	5562966292	\N
OLLL880112XHRGPUN5	Francisco	Solís	Castillo	1988-01-12	Intersex	AB-	5598734689	paciente4287@example.com
YEDY450829HWIOSZU9	Andrés	Rodríguez	Ramos	1945-08-29	M	A-	5593830385	paciente4288@example.com
VIZE700727MDDZIXV8	Karla	Cruz	Mendoza	1970-07-27	F	B-	5597804818	paciente4289@example.com
QYCR170123XCIBOUI9	Miriam	García	López	2017-01-23	Intersex	B+	5583181007	paciente4290@example.com
GSYU030511MQODIBZ1	Lucía	Rojas	Guzmán	2003-05-11	F	\N	5522032544	\N
PNXH620404HDDVKCP6	Antonio	Rojas	Rojas	1962-04-04	M	AB+	5530679133	paciente4292@example.com
CQXJ660515HOMDFJC6	Iván	Ortiz	Jiménez	1966-05-15	M	A+	5537895404	paciente4293@example.com
YBQE460712MRWJDQ99	Paola	Delgado	Flores	1946-07-12	F	B+	5595847136	paciente4294@example.com
EQCX150713MCPGVCA5	Mónica	Solís	Salazar	2015-07-13	F	A+	5515627831	paciente4295@example.com
FMIP710222HMUTNKD3	Pablo	Díaz	Solís	1971-02-22	M	O+	\N	paciente4296@example.com
LKVT700203HXPOUDQ3	Sergio	Solís	Martínez	1970-02-03	M	AB+	5517159120	\N
ICGV830803MTPJNMO4	Gabriela	Ortiz	Ramírez	1983-08-03	F	AB+	5590575207	paciente4298@example.com
VCHI160226MGHURCM2	Elena	Cordero	Morales	2016-02-26	F	O+	5560762650	paciente4299@example.com
AXMZ990107XSOFFL32	Juan	Vázquez	Fuentes	1999-01-07	Intersex	A-	5521072642	paciente4300@example.com
VTNI560802MOPCMKN5	Verónica	Chávez	López	1956-08-02	F	B+	5546994805	paciente4301@example.com
QCPO801229HBTPMGL9	Mario	Medina	Salazar	1980-12-29	M	A+	5532351423	paciente4302@example.com
JAQW090411XMHEQGG6	Óscar	Gutiérrez	Reyes	2009-04-11	Intersex	\N	5568827086	paciente4303@example.com
XHNB600125XQBMBRO1	Rodrigo	López	González	1960-01-25	Intersex	AB-	5527448998	paciente4304@example.com
JQWJ670408MFNFXLB4	Diana	Salazar	Reyes	1967-04-08	F	O-	5555657610	paciente4305@example.com
BTAM740903HTLKILY3	Arturo	Herrera	Alvarado	1974-09-03	M	A-	5552615982	paciente4306@example.com
NEKB461202HNMRBGY0	Iván	Hernández	Cordero	1946-12-02	M	A+	5516353732	\N
WIPN250706MYMTUIU9	Verónica	Estrada	Martínez	2025-07-06	F	A+	5580873090	paciente4308@example.com
ZDIK080929MIUNCLL2	Verónica	Vázquez	Aguilar	2008-09-29	F	B-	5551967577	paciente4309@example.com
YUDY110209MAAUYA12	Mónica	Medina	Díaz	2011-02-09	F	O-	5582358636	\N
IWQZ671228XTBJISV2	Mario	Salazar	Pérez	1967-12-28	Intersex	AB+	5564570269	\N
LIDE211028MPHGJLD5	Araceli	Medina	Torres	2021-10-28	F	AB+	5553847623	paciente4312@example.com
UBOD911218HHKPTVY6	Arturo	Medina	Peña	1991-12-18	M	B+	5569513947	paciente4313@example.com
OZRP850405XUHOCVX2	Andrés	Jiménez	Aguilar	1985-04-05	Intersex	AB-	5500627727	\N
IPWX540813XCFNPH05	Raúl	Chávez	Delgado	1954-08-13	Intersex	O+	5533140749	paciente4315@example.com
EBFV860809HDXFHAA8	José	Alvarado	Flores	1986-08-09	M	AB+	5508858306	paciente4316@example.com
MQLW070917MGBUEVQ1	Fernanda	Reyes	Mendoza	2007-09-17	F	\N	5557236403	\N
DSWO580815MKKKUJA4	Paola	Chávez	Estrada	1958-08-15	F	AB-	5563905652	paciente4318@example.com
GIEA001022HOLOPMY1	Roberto	Morales	Hernández	2000-10-22	M	A-	\N	\N
OPGC910307MZRRIEJ4	Cecilia	García	Chávez	1991-03-07	F	AB-	5530692905	paciente4320@example.com
XLWR750531MFSIGRC0	Gabriela	Morales	Flores	1975-05-31	F	A+	5512603542	paciente4321@example.com
QZBC970810XGEMIJ53	Araceli	Salazar	Peña	1997-08-10	Intersex	\N	5509748653	paciente4322@example.com
FOTT431023HYGMMFW4	Jorge	Salazar	Mendoza	1943-10-23	M	\N	5501031748	paciente4323@example.com
XORM430918HHZAOQE8	Manuel	Pérez	Contreras	1943-09-18	M	O+	5597338143	paciente4324@example.com
XCCK940912XLZEICW7	Rosa	Estrada	Vázquez	1994-09-12	Intersex	AB-	5558530922	paciente4325@example.com
HVQD670608MYIJYTM2	Sofía	Cordero	Solís	1967-06-08	F	\N	5555791805	\N
FEFX150611HSLUTGV6	Raúl	Salazar	Cordero	2015-06-11	M	B+	5505614104	paciente4327@example.com
CVIN860618XQIXVPL8	Gerardo	Medina	Ramos	1986-06-18	Intersex	AB+	5581219673	paciente4328@example.com
GPVO910828MFPGAZG4	Laura	Cruz	Solís	1991-08-28	F	O+	5507085176	paciente4329@example.com
AEPU181008MOSRQZV3	Miriam	Pérez	Castillo	2018-10-08	F	A-	5561938107	paciente4330@example.com
NWWD710625HEXAZV59	Gerardo	Medina	Contreras	1971-06-25	M	B-	5509321418	paciente4331@example.com
WTBD830718XPWJAH22	Patricia	Ortiz	Estrada	1983-07-18	Intersex	A+	5521543800	paciente4332@example.com
WOYT940514HQSDJN95	Pablo	Cabrera	Romero	1994-05-14	M	AB+	5592260421	paciente4333@example.com
IRND170405MEODHXB5	Diana	Díaz	López	2017-04-05	F	A-	5561771353	paciente4334@example.com
USLS560523XJUMTMJ9	Adriana	Estrada	Aguilar	1956-05-23	Intersex	A+	5505807365	paciente4335@example.com
WPWI210310HTSVCYH5	Arturo	Cordero	Torres	2021-03-10	M	B-	5501599736	paciente4336@example.com
PBXD671006HUZTFYX0	Pablo	Chávez	Martínez	1967-10-06	M	B-	5586610916	paciente4337@example.com
VWQB740418MZLAJZT2	Cecilia	Solís	Morales	1974-04-18	F	O-	5551203626	paciente4338@example.com
NSIU031204HFAOLJJ5	Francisco	Aguilar	Ortiz	2003-12-04	M	B-	5549324156	paciente4339@example.com
AAPH861113HRRTZKB1	Gerardo	Contreras	Ramos	1986-11-13	M	\N	5551051193	\N
CULQ150811XWEEQEU8	Daniel	Chávez	\N	2015-08-11	Intersex	B-	5570298071	paciente4341@example.com
EQLU420531XWVMEKU8	Rodrigo	Romero	\N	1942-05-31	Intersex	O-	5536661880	\N
ZTLK481121XEDEEDV5	Cecilia	Contreras	Mendoza	1948-11-21	Intersex	AB+	5514404568	paciente4343@example.com
NFMT960723MDJFXFJ7	Leticia	Rojas	Contreras	1996-07-23	F	O-	\N	paciente4344@example.com
QHDC690621MBRDFGR8	Fernanda	Vargas	Ramos	1969-06-21	F	A-	5536451186	paciente4345@example.com
ARXV430109XBPTJM01	Alejandra	Pérez	Alvarado	1943-01-09	Intersex	A-	\N	\N
CGKA091121HMIPEVB9	Pablo	Ruiz	Solís	2009-11-21	M	B-	5560121330	paciente4347@example.com
TLTH160307MGPELCN3	Lucía	Pérez	Mendoza	2016-03-07	F	\N	5539975468	\N
LOGH140226HIBKGHA2	Arturo	Ramos	Sánchez	2014-02-26	M	AB+	5526650937	\N
CPPE761210HVEAZCA3	Juan	Rodríguez	Salazar	1976-12-10	M	A+	5531110397	\N
YJNU621028HSUJPWE3	Emilio	Estrada	Alvarado	1962-10-28	M	O+	5520610283	\N
VDMX461003MIWRGDL3	Cecilia	García	Solís	1946-10-03	F	O+	5512587811	paciente4352@example.com
UDEE510823HMBVNWG4	Ricardo	Gómez	Alvarado	1951-08-23	M	A+	5586414582	\N
OGHG750629HAOOGOX3	Mario	Fuentes	Flores	1975-06-29	M	B+	5574640230	paciente4354@example.com
FJEQ150620MGKYUTQ6	Cecilia	Gutiérrez	Ramírez	2015-06-20	F	O-	\N	paciente4355@example.com
MPNS041229XWDEHL29	Antonio	Díaz	\N	2004-12-29	Intersex	O-	5503316759	\N
SXQM390202HOZVSKF4	Juan	Rojas	García	1939-02-02	M	A-	5516585577	paciente4357@example.com
BVOC390125MPFXCL06	Elena	Sánchez	Aguilar	1939-01-25	F	A-	5562795493	\N
ZOCA750725HEPXAIN9	Hugo	Alvarado	Ortiz	1975-07-25	M	AB+	5541177449	\N
BOKS500618HTDDZAD0	Emilio	Reyes	Romero	1950-06-18	M	O-	5583702562	\N
UBJH140312XWQSULD0	Patricia	Jiménez	Castillo	2014-03-12	Intersex	B-	5531658712	\N
EPCX461028HHEATBT6	Carlos	Ramírez	Vázquez	1946-10-28	M	AB+	5512963115	paciente4362@example.com
NPRE140203MCILUM34	Laura	Guzmán	Romero	2014-02-03	F	AB-	5502615861	paciente4363@example.com
PMUC190808MVGOSR86	Ana	Reyes	Vargas	2019-08-08	F	AB-	5549597378	paciente4364@example.com
DPTT481024HMGSCC59	Roberto	Ruiz	Sánchez	1948-10-24	M	A+	5538883402	paciente4365@example.com
AQZM780126MTFOHEH0	Rosa	Aguilar	Vázquez	1978-01-26	F	\N	5577424435	paciente4366@example.com
SIBM800817MEOSHBV7	Gabriela	Medina	\N	1980-08-17	F	AB+	5588733462	\N
YYFF841204XHDXUGA4	Pablo	Díaz	Fuentes	1984-12-04	Intersex	O+	\N	paciente4368@example.com
TGKZ880614HAJTLG14	Jorge	Peña	Herrera	1988-06-14	M	O+	5552703203	paciente4369@example.com
HSRH891121XYQIWFS8	Elena	González	Ramírez	1989-11-21	Intersex	O-	5508954135	paciente4370@example.com
ARLB170616MBBXTD56	Patricia	Flores	Medina	2017-06-16	F	B-	5541050319	paciente4371@example.com
ARPR661218HXEEHQV5	Gerardo	Pérez	Contreras	1966-12-18	M	B+	5576847675	paciente4372@example.com
IOAS000814HIJJFPQ0	Iván	Solís	Morales	2000-08-14	M	AB-	5544410619	\N
EEEB620711XWHXRP17	Cecilia	Solís	González	1962-07-11	Intersex	A-	5542918461	\N
XLVX981122HDXJXB05	Daniel	Rodríguez	Ramírez	1998-11-22	M	A-	5529266731	paciente4375@example.com
PYIJ081026XHCXTOX4	Miriam	Solís	Gutiérrez	2008-10-26	Intersex	A+	5572801870	paciente4376@example.com
CDLY660807XQOBOTF4	Eduardo	Medina	Jiménez	1966-08-07	Intersex	\N	5539829810	paciente4377@example.com
DLSH431024XQKBSRE8	Pablo	López	Solís	1943-10-24	Intersex	O-	5569645337	\N
GJGZ050227MICDYU62	Silvia	Guzmán	Jiménez	2005-02-27	F	B-	5514864022	paciente4379@example.com
UEAX410514MJQOFQ24	Cecilia	Medina	Cruz	1941-05-14	F	A-	5543586213	paciente4380@example.com
BXPD490108XUORBS98	Alejandra	Díaz	Salazar	1949-01-08	Intersex	AB+	5598541732	paciente4381@example.com
ZNDO800619MKUKNKE7	Cecilia	Flores	Morales	1980-06-19	F	A-	5594262061	paciente4382@example.com
AYLQ101229MYIOXWA8	Carmen	Jiménez	Mendoza	2010-12-29	F	B-	5512447884	\N
ZGKG680501HKGFIJQ9	Hugo	Ramos	Contreras	1968-05-01	M	A+	5557978612	paciente4384@example.com
FUFL590222MMEIMW57	María	Hernández	Ramírez	1959-02-22	F	B-	\N	paciente4385@example.com
VEDD810413MNFWJXR2	Adriana	García	González	1981-04-13	F	O-	5596176000	paciente4386@example.com
SGNV560807HMVNMMI6	Iván	Fuentes	Morales	1956-08-07	M	O+	5595588371	paciente4387@example.com
GPPU930820HSPHJD34	Ricardo	Solís	Díaz	1993-08-20	M	O+	5515929121	\N
AZIG380928XEBRAWQ6	Iván	Medina	Rojas	1938-09-28	Intersex	\N	5599009886	paciente4389@example.com
ULSQ380928MVIBXW41	Beatriz	Morales	Díaz	1938-09-28	F	AB-	5524769389	paciente4390@example.com
SKMZ090220HIFMUFS5	José	García	Chávez	2009-02-20	M	\N	5534761540	\N
HJDR990831HVFJLG98	Arturo	Medina	\N	1999-08-31	M	O+	5572243390	paciente4392@example.com
DAZC050815MFXKCE93	Diana	Gutiérrez	Flores	2005-08-15	F	A-	5507900302	\N
MMHX170121XWZEIC60	Ricardo	Contreras	Vázquez	2017-01-21	Intersex	\N	\N	paciente4394@example.com
XCLE440703MHLQRE60	Paola	Salazar	Gutiérrez	1944-07-03	F	A-	\N	paciente4395@example.com
MTGD850919HJAEORQ9	Arturo	Guzmán	Pérez	1985-09-19	M	O-	5593372974	paciente4396@example.com
NEYS540908XJEXBI56	Sergio	Ruiz	Cordero	1954-09-08	Intersex	A-	5511205144	paciente4397@example.com
PRRL840112XOCADE23	Alejandra	Cabrera	Ramírez	1984-01-12	Intersex	AB-	5564516788	paciente4398@example.com
OBCH470111HUCLAV80	Eduardo	Sánchez	Peña	1947-01-11	M	AB+	5572974127	paciente4399@example.com
FHFE411206XWGBSU30	Manuel	Gómez	Ortiz	1941-12-06	Intersex	O-	5568213342	paciente4400@example.com
EYEG610310MSQFPBB6	Mónica	Jiménez	Romero	1961-03-10	F	AB+	5543972422	paciente4401@example.com
TBPK660808HZEFOPV8	Adrián	Ortiz	Flores	1966-08-08	M	\N	5571436539	\N
RJXB781209MIYJNL15	Teresa	Guzmán	Ramírez	1978-12-09	F	B+	5536792089	paciente4403@example.com
APKP440515MZSCUR82	Fernanda	Rodríguez	Sánchez	1944-05-15	F	AB+	5517013635	\N
FFYT640227HOQFRA35	Alejandro	Cordero	Ruiz	1964-02-27	M	A-	5594827168	paciente4405@example.com
MNGZ380723HDQISRO4	Antonio	Jiménez	Rodríguez	1938-07-23	M	O-	5557081775	paciente4406@example.com
PYTV460427HUXSXIU5	Manuel	Vázquez	Ortiz	1946-04-27	M	A-	\N	paciente4407@example.com
ABWL760406XNHIOIP8	María	Romero	Reyes	1976-04-06	Intersex	A+	5582599785	paciente4408@example.com
KRYP560623MUTZAZR8	Alejandra	Martínez	Rodríguez	1956-06-23	F	O+	5506792449	paciente4409@example.com
AKTB130911HJMRXJC8	Andrés	Ramírez	Salazar	2013-09-11	M	B+	5594347479	paciente4410@example.com
NEJK791221MQGCVJC9	Silvia	Rojas	Romero	1979-12-21	F	O-	5571472703	paciente4411@example.com
XRUH721116XKGHNEJ9	Roberto	Delgado	Solís	1972-11-16	Intersex	AB+	5550637932	paciente4412@example.com
DWZX020913XRJLQXZ2	Hugo	Mendoza	López	2002-09-13	Intersex	A-	5539677434	paciente4413@example.com
PUAC190430XNJKFX43	Francisco	Cordero	Vargas	2019-04-30	Intersex	B-	5590133436	paciente4414@example.com
BAJA930126MDOOWN35	Gabriela	Ruiz	Torres	1993-01-26	F	A+	5503499411	paciente4415@example.com
RUID210323XAXRMPJ4	Claudia	Flores	Gutiérrez	2021-03-23	Intersex	O+	5505465878	paciente4416@example.com
CSHX440609MESRNGL7	Cecilia	Vargas	Chávez	1944-06-09	F	A-	5512982988	\N
GONX690917HTOAQNO2	Gerardo	Díaz	Estrada	1969-09-17	M	B-	5575849319	paciente4418@example.com
IZDU500622MUPFEE93	Adriana	Aguilar	Rodríguez	1950-06-22	F	O+	5567828853	paciente4419@example.com
ZJSW560227XMFHUJA2	Leticia	Reyes	Rodríguez	1956-02-27	Intersex	O-	5566719342	paciente4420@example.com
VFFS691103XIHEFW31	Emilio	Ramírez	Ramírez	1969-11-03	Intersex	O-	5523578148	\N
JYAK630501XQEPVTE4	Carlos	Gómez	Mendoza	1963-05-01	Intersex	O+	5518690563	paciente4422@example.com
LENK090623MIMBMPL6	María	Martínez	Mendoza	2009-06-23	F	\N	5533458096	paciente4423@example.com
PLKB500116MUGOZMT7	Adriana	García	Castillo	1950-01-16	F	\N	5513390074	paciente4424@example.com
KANU460813XXRGLQ47	Pablo	Cabrera	Hernández	1946-08-13	Intersex	AB+	5516198640	paciente4425@example.com
ICKD630823HAMCFYV2	Raúl	Romero	López	1963-08-23	M	O+	5505799341	paciente4426@example.com
CIKP970302HWSKMBW6	Luis	Ortiz	Fuentes	1997-03-02	M	O+	5577118824	paciente4427@example.com
LWHF090727HEAMUDQ1	Diego	Chávez	Sánchez	2009-07-27	M	AB-	5537144214	paciente4428@example.com
EUXQ600401HHWIQNM5	Juan	Estrada	Hernández	1960-04-01	M	B-	5575437295	paciente4429@example.com
FDXC610301HXDZXWZ9	Iván	Flores	Chávez	1961-03-01	M	AB-	5536654080	\N
NQJC090415MRXXNXB5	Claudia	Medina	Ramos	2009-04-15	F	A-	5509058481	\N
YKNK880323XNMMHGC8	Silvia	Cordero	Ruiz	1988-03-23	Intersex	O+	5554373167	paciente4432@example.com
MIMA600624XWMFKWE0	Adrián	Chávez	Gutiérrez	1960-06-24	Intersex	B+	5528017454	paciente4433@example.com
UPGU740619MADFGYE9	Fernanda	Gómez	Fuentes	1974-06-19	F	B-	5566269795	paciente4434@example.com
SMUE000801HDYSPNW8	Iván	Aguilar	Romero	2000-08-01	M	\N	5508125113	\N
BSIC371225XMRJBME5	Adriana	Rojas	Rojas	1937-12-25	Intersex	AB-	5563561906	\N
MZKD220907XDNQYAO1	Patricia	Morales	García	2022-09-07	Intersex	B+	5537592612	paciente4437@example.com
VAUN100908HGHDKVD6	Alejandro	López	Salazar	2010-09-08	M	AB-	5564207121	\N
DYFZ460421HOAQHS31	Emilio	Solís	Contreras	1946-04-21	M	B-	5548713408	paciente4439@example.com
GWJT180117XYLLEEX7	Adrián	Ruiz	Solís	2018-01-17	Intersex	AB+	5550074491	\N
SWBK470127HOIDYON2	Antonio	Solís	Pérez	1947-01-27	M	O-	5544098741	paciente4441@example.com
KENS250328MRXDJR77	Laura	Estrada	Estrada	2025-03-28	F	O-	5569562514	paciente4442@example.com
MHCO540808XPOWDQF3	Adriana	Gómez	Peña	1954-08-08	Intersex	O+	5512126834	\N
VBBL870722XVQPYVT9	Teresa	Sánchez	Alvarado	1987-07-22	Intersex	B+	5531102903	paciente4444@example.com
PJDT510617XXVXRH67	Yolanda	Díaz	\N	1951-06-17	Intersex	AB-	5531879878	paciente4445@example.com
RVLU501226HRVFCB12	Carlos	Vázquez	Vargas	1950-12-26	M	AB+	\N	paciente4446@example.com
TFVM650709MAEZVMK4	Patricia	Ortiz	\N	1965-07-09	F	\N	5572495806	paciente4447@example.com
GCVK060514MJDHSZM8	Claudia	García	Solís	2006-05-14	F	B-	\N	\N
SDYL490815XWPKDIA4	Guadalupe	García	Gutiérrez	1949-08-15	Intersex	B+	5553760067	paciente4449@example.com
LNFC361102HEMDGOF6	Francisco	García	Mendoza	1936-11-02	M	B+	\N	\N
OABZ940813MBZOCD19	Elena	Contreras	Morales	1994-08-13	F	O-	5541878614	paciente4451@example.com
ADBI521108XOLPLGE4	Fernando	Pérez	Alvarado	1952-11-08	Intersex	A-	5517110658	\N
ERFQ651109MSPZYK65	Araceli	Ramírez	Contreras	1965-11-09	F	B-	\N	\N
QWQP411031XBXWSGR6	Ricardo	Díaz	Díaz	1941-10-31	Intersex	AB-	5548469093	paciente4454@example.com
BLOX100404MWAIFO87	Lucía	Reyes	Castillo	2010-04-04	F	AB-	5512781613	paciente4455@example.com
GTSB520206MZDVOQX5	Rosa	Fuentes	Rodríguez	1952-02-06	F	AB+	5572007120	paciente4456@example.com
EKJS150707HNADXGP4	Antonio	Reyes	Ortiz	2015-07-07	M	\N	5536819098	paciente4457@example.com
OCSW880906MWIYPCJ5	Leticia	Alvarado	Cabrera	1988-09-06	F	O+	5537009111	paciente4458@example.com
NFRJ000419MBMDMVN2	Claudia	Guzmán	Ramos	2000-04-19	F	\N	5539677572	paciente4459@example.com
VDJS840122XWSXCRG6	Araceli	Ruiz	Martínez	1984-01-22	Intersex	A+	\N	paciente4460@example.com
ZZVD050717XJCXAJY8	Cecilia	Reyes	Cruz	2005-07-17	Intersex	AB-	5556122066	paciente4461@example.com
KAIV900128MMOMLKC5	Ana	Chávez	Mendoza	1990-01-28	F	AB+	\N	paciente4462@example.com
RHAT980422HESAPN41	Francisco	Aguilar	Guzmán	1998-04-22	M	B+	5562351182	paciente4463@example.com
ZKRD971125HTYKVF27	Jorge	Díaz	Salazar	1997-11-25	M	O-	5531517678	paciente4464@example.com
GFOL931029HSEHLCS0	Antonio	Ruiz	Jiménez	1993-10-29	M	A-	5597878514	paciente4465@example.com
FQGQ970907HMZMIU30	Hugo	Medina	Salazar	1997-09-07	M	\N	5536794339	paciente4466@example.com
CJJS050416XBRCOFI5	Hugo	Aguilar	Cruz	2005-04-16	Intersex	\N	\N	\N
TNFG151105XVNJSKY9	Paola	Rojas	Medina	2015-11-05	Intersex	O-	5578401366	\N
MZAM071111HMBFPKR5	Pablo	Alvarado	Vázquez	2007-11-11	M	B+	5553379805	paciente4469@example.com
TKPU860907HROEGA34	Juan	Solís	Pérez	1986-09-07	M	B+	5598305122	\N
RCLT660612HFCQDM47	Adrián	Fuentes	Vargas	1966-06-12	M	B-	5557464157	\N
NWJQ180411XUYTVLO5	José	Medina	Morales	2018-04-11	Intersex	A-	5503874871	paciente4472@example.com
EBBZ510306MKGHDNS0	Sofía	Castillo	Martínez	1951-03-06	F	O+	5579658914	paciente4473@example.com
ISTU821105MHQGOS28	Sofía	Pérez	Rodríguez	1982-11-05	F	B-	5508470797	paciente4474@example.com
EOXM650618HTLSWYU3	José	Ortiz	Ruiz	1965-06-18	M	B+	5510744303	paciente4475@example.com
CQID221209HRMWJFJ3	José	Salazar	Torres	2022-12-09	M	B-	5560539624	paciente4476@example.com
TJQO101121XDENYHS2	Guadalupe	Chávez	Medina	2010-11-21	Intersex	AB+	5524371408	\N
CRSF640806XSADKYQ4	Paola	Romero	Reyes	1964-08-06	Intersex	O+	\N	\N
WBGB380728HVBXMUQ6	Ricardo	Ramírez	Chávez	1938-07-28	M	B+	5573135809	paciente4479@example.com
UFXM830603MQCCWDB4	Miriam	Ramos	Aguilar	1983-06-03	F	O-	5517490646	\N
TBQJ170228XRLGTHE3	Diana	Pérez	García	2017-02-28	Intersex	\N	5557179436	paciente4481@example.com
OTDQ080404HAFKBUI2	Miguel	Reyes	Jiménez	2008-04-04	M	AB+	5528264813	paciente4482@example.com
UISW580318HUMQKNT4	Emilio	Cruz	García	1958-03-18	M	O-	5522071084	\N
RJYQ380331MQWDLTD6	Sofía	Salazar	Cruz	1938-03-31	F	O-	5592214264	paciente4484@example.com
HCID480729XBQUQU58	Adrián	Romero	Contreras	1948-07-29	Intersex	A-	5561884524	\N
HMQA390902XCPBRG87	Daniela	Chávez	Gutiérrez	1939-09-02	Intersex	AB-	5504085321	paciente4486@example.com
LIMA700718MPMUXRJ3	Karla	Ruiz	Castillo	1970-07-18	F	O-	5545761102	paciente4487@example.com
RJCH000910HXFNTOE7	Eduardo	Pérez	Castillo	2000-09-10	M	A-	5585864271	paciente4488@example.com
TJHM040131MMKDCEI7	Yolanda	López	Cordero	2004-01-31	F	B+	5519874062	\N
WRCR580528HLKMSKT5	Hugo	Rojas	Reyes	1958-05-28	M	AB-	5575261422	\N
HBOE511128XEWBOAW3	Ana	Gómez	Rojas	1951-11-28	Intersex	B+	5502634960	paciente4491@example.com
JUCF400629XCYBYZO1	Laura	Cordero	Delgado	1940-06-29	Intersex	B-	5583161539	paciente4492@example.com
OYWP070220XTNJIZM9	Roberto	Hernández	Flores	2007-02-20	Intersex	O-	5592371703	paciente4493@example.com
SHDT690913XMZIBPY0	José	Guzmán	Delgado	1969-09-13	Intersex	O-	5500438528	paciente4494@example.com
VPAJ631213HHYYTD29	Alejandro	Sánchez	Ramírez	1963-12-13	M	\N	5503231109	\N
SLMK620611MWMGLS52	Elena	Salazar	Gómez	1962-06-11	F	A-	5523689297	paciente4496@example.com
MJPX760926MCUJUTQ9	Daniela	Delgado	Herrera	1976-09-26	F	AB-	5569237601	paciente4497@example.com
GPRW560624MAIRSA22	Adriana	Torres	Jiménez	1956-06-24	F	A-	5522868351	paciente4498@example.com
NHJJ920805HGYCFD19	Óscar	Torres	Flores	1992-08-05	M	O+	5579396906	paciente4499@example.com
WPMF240326XKSTYNL1	Fernanda	Cruz	Martínez	2024-03-26	Intersex	B+	5561425194	paciente4500@example.com
VRGM601222MGGHCTP3	Miriam	Rojas	Aguilar	1960-12-22	F	A-	5524660937	paciente4501@example.com
DKLW660628HBNPLUK0	Diego	Salazar	Hernández	1966-06-28	M	O-	5586032144	paciente4502@example.com
QWMS381204MBWMKFK7	Alejandra	Torres	Estrada	1938-12-04	F	A+	\N	\N
CILK120306XNNJIXX7	Fernanda	González	Pérez	2012-03-06	Intersex	AB-	5508050804	paciente4504@example.com
GCKR090520XSTQGVI2	Iván	Díaz	Ramos	2009-05-20	Intersex	B+	5584973866	paciente4505@example.com
TJVX830922MLATURW4	Beatriz	Martínez	López	1983-09-22	F	O-	5579561957	\N
AYEW011025XMWMVY56	Leticia	Guzmán	Estrada	2001-10-25	Intersex	B-	5588538053	paciente4507@example.com
QRFP490625MNQRDLA8	Claudia	Cruz	Cordero	1949-06-25	F	\N	5500299907	paciente4508@example.com
OXEP680406MHLRNOT2	Elena	Ramírez	Hernández	1968-04-06	F	\N	5558869150	paciente4509@example.com
PCXF040804HRHPTBC0	José	Cabrera	Solís	2004-08-04	M	A+	5536379358	paciente4510@example.com
OEKT040317XQISIYG9	Daniel	Torres	Torres	2004-03-17	Intersex	A+	5589285027	paciente4511@example.com
WXBM880915XOYQHOC3	Karla	Estrada	Hernández	1988-09-15	Intersex	A-	5568767122	\N
UBOL061220HAXULZ40	Daniel	Ramírez	López	2006-12-20	M	A+	5560790298	\N
AJZW891201XSBDZRK6	Leticia	Pérez	Pérez	1989-12-01	Intersex	B-	\N	\N
GJGI460523XODZVDN5	Claudia	González	Fuentes	1946-05-23	Intersex	O-	5559274681	paciente4515@example.com
CLPZ851120HCIAMTK4	Miguel	Alvarado	Vázquez	1985-11-20	M	AB-	5523517359	paciente4516@example.com
OMUG540408HCXGCB85	Manuel	Ortiz	Morales	1954-04-08	M	B-	5549917654	paciente4517@example.com
REHD920807XNKRNI30	Andrés	González	Vargas	1992-08-07	Intersex	A+	5516804743	paciente4518@example.com
RBLJ410722XYUVMHV4	Yolanda	Ortiz	Aguilar	1941-07-22	Intersex	O-	5505386377	\N
SCVJ610729HNTNQLE2	Rodrigo	Estrada	Flores	1961-07-29	M	AB+	5539086943	paciente4520@example.com
LWKF110910HYZRIWC0	Raúl	Torres	\N	2011-09-10	M	A-	5553244576	paciente4521@example.com
MBPP900830XGQNMOM7	Miriam	Reyes	Pérez	1990-08-30	Intersex	\N	5568671971	paciente4522@example.com
YZFW560612HNPPFF46	José	Estrada	Jiménez	1956-06-12	M	AB-	5523290756	paciente4523@example.com
KPOJ931208XIOMWT01	Miriam	Salazar	Cabrera	1993-12-08	Intersex	O+	5592109830	paciente4524@example.com
JTMR250512HPUXBQO6	Manuel	Ruiz	\N	2025-05-12	M	O-	5522270026	\N
FTKB051207MWMVIMB0	Silvia	Ruiz	Gutiérrez	2005-12-07	F	O-	5551660728	paciente4526@example.com
HBSQ520215XHNNUJF6	Patricia	Cordero	Medina	1952-02-15	Intersex	B-	\N	paciente4527@example.com
YLOL770706MCOCJLK2	Sofía	Castillo	Reyes	1977-07-06	F	B+	\N	\N
SZAU440319XKGSAJC0	Adriana	Sánchez	Hernández	1944-03-19	Intersex	B+	5541817693	paciente4529@example.com
BZMK221126XQNWQVL3	Teresa	Vázquez	Solís	2022-11-26	Intersex	A-	5579206380	paciente4530@example.com
TBBM111011MIHVUY94	Silvia	Romero	Rojas	2011-10-11	F	A+	5539639163	paciente4531@example.com
KEPM240111XQGOUHV4	Ana	Medina	Vargas	2024-01-11	Intersex	\N	5566914255	paciente4532@example.com
EZWQ730314MZKVHG97	Cecilia	Chávez	Estrada	1973-03-14	F	AB+	5575824083	\N
MMBK080816MLVUGO62	Rosa	Ramos	Delgado	2008-08-16	F	O-	5595071627	paciente4534@example.com
LPQS211202MLUQUXQ2	Gabriela	Rojas	Cabrera	2021-12-02	F	B-	5549672696	\N
KBQY240712XVWHHKB4	Francisco	Gómez	Fuentes	2024-07-12	Intersex	A+	5553868351	\N
SGOZ530404HWLMHQ95	Rodrigo	Vázquez	Ruiz	1953-04-04	M	AB+	5553193556	paciente4537@example.com
ZVOR380910XFGMRCP1	Lucía	Flores	Guzmán	1938-09-10	Intersex	B+	5520424939	paciente4538@example.com
TABA030320MMVBUGJ2	Rosa	Torres	Herrera	2003-03-20	F	AB+	5593145662	paciente4539@example.com
UMJX160721XMXKHUA1	Eduardo	Solís	Ruiz	2016-07-21	Intersex	A-	5544047751	paciente4540@example.com
KELH790523XYBFCN43	Óscar	Romero	Salazar	1979-05-23	Intersex	\N	5547677839	\N
HWZT200725XBDBGUS9	Fernando	Herrera	Díaz	2020-07-25	Intersex	O+	5555906188	paciente4542@example.com
LUHX681224MBHHNP93	Yolanda	Ramírez	Solís	1968-12-24	F	A+	5591661268	paciente4543@example.com
WXGX740320HERXVGK5	Óscar	Fuentes	Gutiérrez	1974-03-20	M	B-	5544456935	paciente4544@example.com
XNOR101120MROTNW01	Mónica	González	Morales	2010-11-20	F	O-	5514444104	paciente4545@example.com
HOMM870630XCXIIW79	Emilio	Herrera	Martínez	1987-06-30	Intersex	O+	5593793013	paciente4546@example.com
NYSX160105XTJHSC75	Araceli	Rodríguez	Contreras	2016-01-05	Intersex	AB+	5574847586	paciente4547@example.com
NYKP680420HAWEEJV8	Arturo	Rojas	Martínez	1968-04-20	M	B-	5571305976	\N
GGJD140807XFGXWCW0	Sofía	López	Mendoza	2014-08-07	Intersex	A-	5577474673	paciente4549@example.com
YEBM080410XMHCZZ47	Emilio	Martínez	\N	2008-04-10	Intersex	O-	5528044241	paciente4550@example.com
QZSL501104HKGYJK55	Gerardo	Rojas	Peña	1950-11-04	M	AB+	5534822778	paciente4551@example.com
GGME071018HIYQSBA0	Alejandro	Herrera	Jiménez	2007-10-18	M	O-	5509387614	paciente4552@example.com
VGUH590211HSTLVHR1	Jorge	Ramírez	Castillo	1959-02-11	M	O+	5545550145	\N
GYBA690101XFEZSAD7	Lucía	Rojas	Cordero	1969-01-01	Intersex	AB-	5565550446	paciente4554@example.com
TTSK891112HPWLHQC2	Mario	García	Morales	1989-11-12	M	O-	5520280213	\N
NEQT900607MYEOSUP0	Mónica	García	Rodríguez	1990-06-07	F	\N	\N	paciente4556@example.com
YNDZ751219MWHVBQU8	Alejandra	Ruiz	\N	1975-12-19	F	B-	\N	\N
BWST100620XZXBOF38	Leticia	Vargas	Cabrera	2010-06-20	Intersex	O+	5508525946	\N
SMFJ860818XGYIDHQ9	Laura	Cabrera	Gutiérrez	1986-08-18	Intersex	A+	5554959528	paciente4559@example.com
WXHJ140121HAFZZR39	Luis	Alvarado	Ramírez	2014-01-21	M	B-	5563759953	\N
MWYC810605XGNCOH09	Gerardo	Aguilar	Castillo	1981-06-05	Intersex	AB+	5503568742	paciente4561@example.com
JGCC240318HVWHBCJ1	Miguel	Delgado	Morales	2024-03-18	M	B-	5500179225	paciente4562@example.com
QPZI181117XETIWZ98	Diego	Romero	Díaz	2018-11-17	Intersex	O+	5506858069	paciente4563@example.com
PTLQ710910MYFVHET7	Adriana	Gutiérrez	Mendoza	1971-09-10	F	O-	\N	\N
VBOU761004HSZJRZM5	Óscar	Vargas	García	1976-10-04	M	B-	5581066612	paciente4565@example.com
WASW090327HVZMGUU8	Diego	Aguilar	Jiménez	2009-03-27	M	AB-	5592129591	paciente4566@example.com
RTVR720429HTALUFG5	Emilio	Jiménez	Cabrera	1972-04-29	M	A+	5574192291	paciente4567@example.com
ZROQ720612MOKREZ23	Cecilia	Alvarado	Pérez	1972-06-12	F	B-	5523261002	paciente4568@example.com
JXFL580109HYWDBXH1	Francisco	Sánchez	Gutiérrez	1958-01-09	M	O+	5500537098	paciente4569@example.com
TFYR610505XQGEEU73	Fernanda	Sánchez	Ramírez	1961-05-05	Intersex	AB-	5512207073	\N
FQGO900219XTMPLMZ3	Guadalupe	González	Contreras	1990-02-19	Intersex	AB-	5573354724	\N
ARVK161023XNXXUR76	Mónica	González	Peña	2016-10-23	Intersex	O-	5555351359	\N
WQTS790123HNQIEZ55	Sergio	Castillo	Estrada	1979-01-23	M	\N	5566234496	paciente4573@example.com
CYQW480826HPALPA71	Miguel	Contreras	Aguilar	1948-08-26	M	O+	5534342966	paciente4574@example.com
DQEC960906HXVMIYJ0	Miguel	Sánchez	Fuentes	1996-09-06	M	O+	\N	paciente4575@example.com
ZTOF910806XRZATTX7	Patricia	Vargas	Fuentes	1991-08-06	Intersex	\N	5501035304	paciente4576@example.com
PDMJ711113MPTZXTA9	Daniela	Delgado	Morales	1971-11-13	F	AB-	5523502913	paciente4577@example.com
FWSC731029HJSNOHN1	Óscar	Hernández	Vázquez	1973-10-29	M	O+	5509621594	paciente4578@example.com
UTKM160320HHSYZG66	Ricardo	Herrera	Delgado	2016-03-20	M	B-	5504869129	\N
DHLT150902MDUMDGZ5	Miriam	Fuentes	Gómez	2015-09-02	F	AB-	\N	paciente4580@example.com
ZTFT640111XQIORGV0	Yolanda	Ortiz	Flores	1964-01-11	Intersex	O-	5593933615	paciente4581@example.com
WVXX670802MPCNEVU6	Verónica	Alvarado	Cordero	1967-08-02	F	A+	5565781657	paciente4582@example.com
UEIB800817MXUEVXG0	Carmen	Medina	\N	1980-08-17	F	O-	5523702669	paciente4583@example.com
KFVU900916XXZDWG15	Leticia	Sánchez	Flores	1990-09-16	Intersex	A+	5539435684	paciente4584@example.com
KQIY181117HHKRUVH4	Roberto	Ruiz	Aguilar	2018-11-17	M	O-	5582436758	\N
WEDA180113MFBUPJP2	Daniela	Flores	Rojas	2018-01-13	F	O-	\N	paciente4586@example.com
ILIJ891211XDDWFYV1	Luis	Sánchez	Rodríguez	1989-12-11	Intersex	AB-	5584175022	paciente4587@example.com
EHLX950210XWTXWGK2	Sergio	Rodríguez	Cabrera	1995-02-10	Intersex	O+	5532400721	\N
UFPA990723XFASJKV7	Araceli	Vargas	Chávez	1999-07-23	Intersex	B+	5539904331	paciente4589@example.com
FZOK920904XHEXBMG3	Manuel	Martínez	Herrera	1992-09-04	Intersex	B+	5592713397	paciente4590@example.com
HDCL930608MSPJTP96	Guadalupe	Flores	Ortiz	1993-06-08	F	AB+	5539132614	paciente4591@example.com
HJLC780715HESDUTU8	Andrés	Flores	García	1978-07-15	M	AB-	\N	paciente4592@example.com
IFEK860101MRKGSNP5	Claudia	Aguilar	Gómez	1986-01-01	F	O+	5599835570	paciente4593@example.com
EQMR400408XGVRIGK4	Mario	Torres	Chávez	1940-04-08	Intersex	AB-	5561143438	\N
UIJV650310MINRVY31	María	Romero	Guzmán	1965-03-10	F	AB-	5509552980	paciente4595@example.com
FCOU070509MASDDP48	Araceli	Peña	Mendoza	2007-05-09	F	AB+	5549646588	paciente4596@example.com
LRKO810505XBZXIAK6	Andrés	Estrada	Gutiérrez	1981-05-05	Intersex	B+	5569025855	paciente4597@example.com
SKJA121027HCOTWLX9	Eduardo	González	Sánchez	2012-10-27	M	\N	5598343702	\N
TNXH930111HGBBZH24	Juan	Ruiz	Reyes	1993-01-11	M	O-	5571477809	paciente4599@example.com
YFUQ151205HZPBJOM2	Iván	Hernández	Salazar	2015-12-05	M	O+	5524263632	paciente4600@example.com
TZVH910714XPDWXVK1	Javier	Contreras	García	1991-07-14	Intersex	\N	5553841273	\N
KDQY570114MAWYIS13	Diana	Morales	Rodríguez	1957-01-14	F	AB-	5527002100	paciente4602@example.com
XFMX400121MFNNYK08	Elena	Martínez	Herrera	1940-01-21	F	O+	5528503885	paciente4603@example.com
MKGI841029HPHQHLL1	Fernando	Guzmán	González	1984-10-29	M	B+	5580471883	\N
YYFO180911HIPBVKS0	Iván	Rodríguez	\N	2018-09-11	M	\N	5567062154	\N
YOZM710430XDRKPUS3	Araceli	Ortiz	Guzmán	1971-04-30	Intersex	\N	5562502845	\N
CUFI790730XHRVGCG4	Silvia	Pérez	Reyes	1979-07-30	Intersex	O-	\N	paciente4607@example.com
IXVC490605MWZZYW46	Karla	Herrera	Delgado	1949-06-05	F	B-	5504827215	paciente4608@example.com
ADCN611212HRECROQ0	Daniel	Solís	Medina	1961-12-12	M	AB+	5549220735	paciente4609@example.com
UESI640308MSJLDGE9	Fernanda	Ramírez	\N	1964-03-08	F	\N	5548470717	\N
ADGX610126HSSIXPZ5	Hugo	Gómez	Castillo	1961-01-26	M	\N	5576210520	paciente4611@example.com
NDGR721103HOYHVXS3	Diego	García	Romero	1972-11-03	M	B-	5511023477	paciente4612@example.com
FGZQ540326MRDUGSN7	Paola	Ramírez	Hernández	1954-03-26	F	A+	5598187632	paciente4613@example.com
XIIB481002XTGANZR8	Francisco	Hernández	Pérez	1948-10-02	Intersex	A+	5521484634	paciente4614@example.com
JYMV940318MHHBPE43	Carmen	Guzmán	Flores	1994-03-18	F	O-	5556966146	paciente4615@example.com
FVMZ391030XNUXUUD5	Yolanda	Ruiz	Torres	1939-10-30	Intersex	A-	5592033009	paciente4616@example.com
ZDKP890611XJJHXII8	Cecilia	Fuentes	Delgado	1989-06-11	Intersex	\N	\N	paciente4617@example.com
QWXU730327HFADBPI2	Arturo	Gutiérrez	Gómez	1973-03-27	M	\N	5516488789	paciente4618@example.com
ZFLG221212HKHTNKS0	Antonio	Cordero	Gómez	2022-12-12	M	A+	5586560741	paciente4619@example.com
NSQI380704XCTYRZV5	Jorge	Solís	Ortiz	1938-07-04	Intersex	A-	5531750095	paciente4620@example.com
VCSG231013HTIGJTP8	Diego	Torres	Fuentes	2023-10-13	M	AB-	5534439159	\N
NJKP020328MLFWNXK1	Paola	Ruiz	Peña	2002-03-28	F	A-	5587960204	\N
VTDW150907MZNJZY13	Cecilia	Herrera	Hernández	2015-09-07	F	O-	5528331090	paciente4623@example.com
UIVU130225XTASFUE8	Manuel	Delgado	Sánchez	2013-02-25	Intersex	O+	\N	\N
ZDES190215HXBWIOK7	Antonio	Ramírez	Morales	2019-02-15	M	O+	\N	paciente4625@example.com
FLVA480722HLHAHIZ5	Pablo	Medina	Morales	1948-07-22	M	\N	5550243604	\N
RNYZ220113HBZYBJU1	Antonio	Vargas	Torres	2022-01-13	M	A+	5564978443	paciente4627@example.com
ELYS560313MIJLFR29	Yolanda	Sánchez	\N	1956-03-13	F	O-	5581341579	\N
PWDM010904HUPDCBC7	Daniel	Pérez	Salazar	2001-09-04	M	\N	5592180439	paciente4629@example.com
NSGI850926MGDPLEO0	Silvia	Flores	Sánchez	1985-09-26	F	A-	5552602486	paciente4630@example.com
JYXN571205MEHFZVF6	Adriana	Ruiz	Morales	1957-12-05	F	\N	5524197533	paciente4631@example.com
HTXI401122XEZHLAN3	Cecilia	Díaz	\N	1940-11-22	Intersex	A-	5564181623	\N
UVUM791122XRTCBYA8	Ricardo	Vargas	\N	1979-11-22	Intersex	AB-	5524299906	\N
FZUH720130XUFUKDH2	Diana	Romero	Jiménez	1972-01-30	Intersex	AB+	5533174301	paciente4634@example.com
CXWP961101XXJKRB44	Mónica	González	Romero	1996-11-01	Intersex	O-	5549273055	paciente4635@example.com
UEDR200906HDXFSSX7	Andrés	Ortiz	Romero	2020-09-06	M	\N	5590016780	paciente4636@example.com
YEHY681120MYRDYF47	Claudia	Estrada	Castillo	1968-11-20	F	\N	5501688972	paciente4637@example.com
MMFN051212MFROGJS8	Gabriela	Fuentes	Pérez	2005-12-12	F	AB-	5521982112	\N
MVAE131003XKGFZI94	Hugo	Delgado	Rodríguez	2013-10-03	Intersex	O+	5591470926	paciente4639@example.com
GVPT411222HMDWHL58	Roberto	Díaz	Cruz	1941-12-22	M	A+	5518329411	\N
ZTQX421229XTASJTW1	Emilio	Herrera	Solís	1942-12-29	Intersex	AB+	5504050922	paciente4641@example.com
YJLU030506MHBAIPC3	Verónica	Fuentes	Alvarado	2003-05-06	F	O-	5541644433	paciente4642@example.com
XBZZ860404MRIWKAR3	Elena	Gutiérrez	Alvarado	1986-04-04	F	AB-	5571256981	\N
KHYD520809XQEJWN40	Arturo	Guzmán	Fuentes	1952-08-09	Intersex	O-	5581354321	paciente4644@example.com
BOTK940804HNPYLU36	Emilio	Ramírez	Sánchez	1994-08-04	M	O-	5520135834	\N
DSUK890209XUFKIL77	Ana	Cruz	Estrada	1989-02-09	Intersex	A+	5536227679	\N
ICGG410715XDOSXJ12	Claudia	López	Ramos	1941-07-15	Intersex	A-	5536369050	paciente4647@example.com
JOJM230705HHTKFIZ6	Manuel	Díaz	Cruz	2023-07-05	M	A-	5516038080	paciente4648@example.com
FOII080313MTPULBH4	Cecilia	Chávez	Vázquez	2008-03-13	F	\N	5518809790	paciente4649@example.com
XYLO030622HIAAUDI2	Alejandro	Reyes	Rojas	2003-06-22	M	AB+	5530019298	paciente4650@example.com
WEBB790916XLKARLZ9	Luis	Peña	Salazar	1979-09-16	Intersex	O-	5559462613	\N
VRCM391012HFDPHXB0	Fernando	Herrera	García	1939-10-12	M	A+	5534625384	\N
DAYF021216MMQAHHC7	Daniela	Ramos	Hernández	2002-12-16	F	AB+	5550087233	paciente4653@example.com
URAX620627XCIGCFJ2	Claudia	Mendoza	Fuentes	1962-06-27	Intersex	\N	5519826425	paciente4654@example.com
GTUQ900710MWWOPWG5	Patricia	Díaz	Herrera	1990-07-10	F	AB+	5500180356	paciente4655@example.com
ASHW000925XRHLEPU6	Elena	Cruz	Gómez	2000-09-25	Intersex	O-	5539796727	paciente4656@example.com
YIZQ111024MYOZQCM5	Ana	Gómez	Castillo	2011-10-24	F	AB-	5556370082	paciente4657@example.com
FZNX900809HGUHNLN8	Francisco	Fuentes	Delgado	1990-08-09	M	B+	5573362342	paciente4658@example.com
XAMI870901XOXKGEW5	Teresa	Cruz	Alvarado	1987-09-01	Intersex	AB-	5524079365	\N
WLUK440416XBLYSFC6	Mónica	Delgado	Fuentes	1944-04-16	Intersex	A-	5506791042	paciente4660@example.com
GWEZ820915MDWMEY92	Alejandra	Rojas	Salazar	1982-09-15	F	A-	\N	paciente4661@example.com
ROCI751230XYFDTFO6	Luis	Jiménez	Peña	1975-12-30	Intersex	B+	5560458945	\N
OZQZ921213HZZWQI31	Javier	Díaz	Jiménez	1992-12-13	M	B-	5541597054	paciente4663@example.com
LUHH610310HWKNNWX7	Manuel	Ruiz	Gutiérrez	1961-03-10	M	A+	5525626585	paciente4664@example.com
VBQC900704MARKOZ98	Carmen	Cruz	Ramos	1990-07-04	F	O+	\N	paciente4665@example.com
TTMC180718XOVNJIP2	Ana	Medina	Díaz	2018-07-18	Intersex	O+	5558244898	paciente4666@example.com
KIXR550804MLBMOV61	Carmen	Díaz	Salazar	1955-08-04	F	B+	5564945992	\N
BNCL450523XVHZIHO6	Iván	Estrada	Sánchez	1945-05-23	Intersex	AB+	5512881079	\N
PSJM160129XVYLFZL5	Arturo	Medina	Gutiérrez	2016-01-29	Intersex	AB+	5595230530	paciente4669@example.com
FKVV811004HJMMEFO0	Jorge	Rojas	\N	1981-10-04	M	\N	5515892507	\N
VOKE711130HGLYOSY5	Francisco	Estrada	Ramos	1971-11-30	M	A-	\N	paciente4671@example.com
OXIB670812XTHMWAL4	Adrián	Hernández	Ruiz	1967-08-12	Intersex	A+	\N	\N
GMJB121225MNXGQNN6	Lucía	López	Aguilar	2012-12-25	F	O+	5574707670	\N
VFPX460817HONYDG66	Juan	Ramos	Pérez	1946-08-17	M	AB-	5538358655	paciente4674@example.com
VKWK770828HBKNHLO0	Pablo	Ramírez	Díaz	1977-08-28	M	AB+	5573841107	\N
JYCX561127MCPDHSM8	Patricia	Delgado	Aguilar	1956-11-27	F	AB+	5508582592	paciente4676@example.com
CNXD790109HVRFVGN2	Pablo	Herrera	Cruz	1979-01-09	M	B+	5594600785	\N
ICDT220831HAKAPQN1	Ricardo	Contreras	Mendoza	2022-08-31	M	A+	5522396687	paciente4678@example.com
PQNR600318XBRVQW78	Fernando	Romero	Sánchez	1960-03-18	Intersex	A+	5590052238	paciente4679@example.com
OIPM080406MENNCQT0	Ana	Flores	Romero	2008-04-06	F	AB-	5508737116	\N
OAAQ111101MYPQAGL4	Laura	Reyes	Cordero	2011-11-01	F	O+	5597162834	paciente4681@example.com
ETCI490704MZNPFNA8	Alejandra	Gutiérrez	García	1949-07-04	F	\N	5516072238	paciente4682@example.com
ZKEX600518XBUVTW61	Mario	López	Peña	1960-05-18	Intersex	O-	5549001871	\N
MCRD860512XRFQWWM1	Antonio	Gómez	Cordero	1986-05-12	Intersex	O+	5519398103	paciente4684@example.com
VPOA960411MPHHACL8	Gabriela	Sánchez	González	1996-04-11	F	AB-	5529131031	paciente4685@example.com
NGBX801002HWVTUHZ4	Óscar	Estrada	Hernández	1980-10-02	M	B-	5585693440	paciente4686@example.com
WRTH630422XZDSESM1	Óscar	Fuentes	Rodríguez	1963-04-22	Intersex	\N	5530359940	paciente4687@example.com
NMBG530320XHHSOVA5	Francisco	Cruz	Rodríguez	1953-03-20	Intersex	\N	5515653123	\N
DIVW520227MUWIDNO0	Paola	Guzmán	García	1952-02-27	F	AB-	5512321275	paciente4689@example.com
IJQP451211HUVVGPL2	Diego	Cabrera	Ramírez	1945-12-11	M	AB-	5501559005	\N
WRDN591020MOPVZEB8	Daniela	Cordero	López	1959-10-20	F	O+	5549271672	paciente4691@example.com
SKUG210522MTGITFN0	Silvia	Sánchez	Aguilar	2021-05-22	F	AB+	5546733167	paciente4692@example.com
JMND440919XHHXSE02	Claudia	Fuentes	Fuentes	1944-09-19	Intersex	\N	5583789526	\N
FWLE590513HICMCMY3	Óscar	Mendoza	Mendoza	1959-05-13	M	\N	5539517451	paciente4694@example.com
UGGI840311MJDNRG28	Rosa	González	Alvarado	1984-03-11	F	A+	5549527971	paciente4695@example.com
CHHD370228XAHGOHO6	Cecilia	Morales	Morales	1937-02-28	Intersex	O-	5534316917	paciente4696@example.com
KBDC941008HRYVLE87	Daniel	Fuentes	Flores	1994-10-08	M	AB-	5538253077	paciente4697@example.com
NXRI451209XHDCUIA6	Diego	García	Flores	1945-12-09	Intersex	O+	5579323670	paciente4698@example.com
DUUL950808HCXGITD7	Fernando	Solís	Martínez	1995-08-08	M	A+	5525514690	paciente4699@example.com
GXTZ390121MTMDGHG7	Ana	Ramos	Reyes	1939-01-21	F	A+	5539719022	paciente4700@example.com
IUNA761015HBNBGAA8	Francisco	Morales	Díaz	1976-10-15	M	AB+	5586499927	paciente4701@example.com
WRDQ630205MLYVMBG8	Patricia	Cordero	Estrada	1963-02-05	F	B+	5506925652	paciente4702@example.com
VKDI820530XWOFYN58	Roberto	García	Aguilar	1982-05-30	Intersex	O+	5522097688	\N
WDQX840401HBGVLXG6	Daniel	Martínez	González	1984-04-01	M	B+	5554653399	\N
GWDA630730MFLVDC23	María	Vázquez	Cordero	1963-07-30	F	B-	5577124920	paciente4705@example.com
TLAJ940212XCRCBV55	Óscar	Chávez	Gutiérrez	1994-02-12	Intersex	B+	5587098378	\N
HOHQ710430HVUZBHP8	Daniel	Fuentes	Martínez	1971-04-30	M	A-	5532790332	paciente4707@example.com
TCBA990129MRTDJVX8	Lucía	Vázquez	López	1999-01-29	F	A+	5508606427	paciente4708@example.com
DFYP991004MAFZUEW7	Silvia	Díaz	González	1999-10-04	F	A+	5565590276	paciente4709@example.com
QBRJ960722HWZQTD42	Mario	Cordero	Medina	1996-07-22	M	\N	5545518814	paciente4710@example.com
TCWX111005XUCUPCD7	Miguel	Morales	Salazar	2011-10-05	Intersex	A-	\N	paciente4711@example.com
UHSR400702MCPDIZ14	Lucía	Mendoza	Rodríguez	1940-07-02	F	A+	\N	\N
QRVQ940402MEEOXVD7	Beatriz	Gutiérrez	Torres	1994-04-02	F	A-	5532722203	paciente4713@example.com
KJVX110408XJSDOSK2	Laura	Contreras	Vargas	2011-04-08	Intersex	\N	\N	paciente4714@example.com
JOKX140625HOIATNH6	Alejandro	Ruiz	Castillo	2014-06-25	M	\N	5577564346	paciente4715@example.com
GIZU011218HNRILN96	Sergio	Flores	García	2001-12-18	M	O+	5504274998	paciente4716@example.com
RWZA790727HIZUBIX0	Óscar	Jiménez	Martínez	1979-07-27	M	AB+	5536324203	paciente4717@example.com
XNUK190808MPNFZQU7	Laura	Torres	López	2019-08-08	F	AB-	5538134164	\N
CTGU510617HFZRVZQ4	Fernando	Ruiz	Guzmán	1951-06-17	M	A-	5578596831	paciente4719@example.com
DYBC561103MJTRZYI0	Elena	Flores	Salazar	1956-11-03	F	A+	5507895651	paciente4720@example.com
VGZI520309XVELKIM9	Lucía	Mendoza	Aguilar	1952-03-09	Intersex	B+	\N	paciente4721@example.com
ZIXM180613MRFCEJN2	Verónica	Herrera	Martínez	2018-06-13	F	O+	5531738802	paciente4722@example.com
ETFH140706HVBBHVG9	Pablo	Rojas	Cabrera	2014-07-06	M	O-	\N	paciente4723@example.com
MPYN980613MDMUIPJ9	Cecilia	Mendoza	González	1998-06-13	F	B-	5593842640	\N
OJFA180531XPLFKMP6	Teresa	Guzmán	Peña	2018-05-31	Intersex	A-	5503106213	paciente4725@example.com
NMFF540702XSANHVT7	Carlos	Cabrera	Solís	1954-07-02	Intersex	O+	5536352776	\N
UOCH200703METXVPV3	Mónica	Estrada	Cabrera	2020-07-03	F	A-	5536105084	paciente4727@example.com
LCBR070222MNVRHV85	Guadalupe	Aguilar	Gutiérrez	2007-02-22	F	\N	5512990650	\N
FURQ710615MNNWBTV6	Leticia	Solís	Salazar	1971-06-15	F	A+	5583499566	paciente4729@example.com
RBXK390726MVVQBUM7	Claudia	Guzmán	Jiménez	1939-07-26	F	AB+	5507834348	\N
AHOD060423XFKZWRS5	Fernando	Díaz	Herrera	2006-04-23	Intersex	B+	5513742028	\N
VRUY790925HZJHRHL1	Diego	Solís	López	1979-09-25	M	A-	5531910752	paciente4732@example.com
RJPQ780412MVDWKQZ8	Elena	Peña	Cruz	1978-04-12	F	B-	5521726082	\N
XXFW530821XYHDAO64	Óscar	Estrada	Cabrera	1953-08-21	Intersex	AB+	5595617182	\N
PWSP661223HXZICH23	Raúl	Vázquez	Ramírez	1966-12-23	M	O-	5577067561	paciente4735@example.com
JLVE761013XDCFTJR3	Luis	Ortiz	Chávez	1976-10-13	Intersex	B-	5506217488	paciente4736@example.com
MYXB451027XXJULNW0	Juan	Peña	Rojas	1945-10-27	Intersex	O-	5585731968	paciente4737@example.com
LBQZ640521MEVGOW83	Miriam	Martínez	Díaz	1964-05-21	F	\N	5526353256	paciente4738@example.com
GZBS860426MACWTXE3	Elena	Cabrera	Sánchez	1986-04-26	F	B+	5580036915	paciente4739@example.com
MUVC810903HKCRVCP3	Gerardo	Alvarado	Alvarado	1981-09-03	M	O-	5543474659	\N
CFRV490705HRNCYI80	Luis	Romero	Medina	1949-07-05	M	A+	5598545749	paciente4741@example.com
ZQBV760626XYFLJIR0	Javier	Contreras	Reyes	1976-06-26	Intersex	\N	5591977555	paciente4742@example.com
ISAS221216MATLSJS4	Beatriz	Guzmán	Ramírez	2022-12-16	F	B+	5505655519	paciente4743@example.com
XDGV050328HABPRDX2	Emilio	Rojas	Ramírez	2005-03-28	M	AB-	5587022685	\N
IQWT470823HXBWEMJ1	Raúl	Guzmán	Jiménez	1947-08-23	M	\N	\N	paciente4745@example.com
AUPP420201XRNKVG96	Adriana	Flores	Gutiérrez	1942-02-01	Intersex	A-	5545895496	paciente4746@example.com
IPYE540419MJVEEWF3	María	Herrera	Castillo	1954-04-19	F	O-	5555090230	paciente4747@example.com
NRJE150825XNBIAR35	Iván	García	Estrada	2015-08-25	Intersex	A-	5565989643	\N
OSGM441111MHKYYJ30	Carmen	Cabrera	González	1944-11-11	F	B+	\N	\N
RFZM040125HNYIMFF2	Daniel	Ramírez	Flores	2004-01-25	M	B+	5550784902	paciente4750@example.com
NCYE440221XDJGBAK8	Pablo	Mendoza	Guzmán	1944-02-21	Intersex	A-	5566862381	\N
UQQF420826MZIDIZG3	Sofía	Fuentes	Martínez	1942-08-26	F	AB+	5598790454	paciente4752@example.com
PJPU890601HJFPMRX5	Raúl	Reyes	Pérez	1989-06-01	M	O-	5561244658	\N
DGKF611020MZVMJEW9	Elena	Cruz	Solís	1961-10-20	F	O-	5543397480	paciente4754@example.com
BMTC630731XVQIYHS5	Rosa	Rojas	García	1963-07-31	Intersex	O-	5529687729	\N
OMMY080515XEOOEQY4	Yolanda	Herrera	Torres	2008-05-15	Intersex	O+	5593223492	paciente4756@example.com
CDRV540315XVQVHES5	Francisco	Vázquez	Torres	1954-03-15	Intersex	A+	5556284088	paciente4757@example.com
KTZL871013XSXGBB19	Daniel	Rojas	Ortiz	1987-10-13	Intersex	\N	5558871381	\N
UFGH630907HNKKXB61	Arturo	Ortiz	Estrada	1963-09-07	M	B-	5513016725	\N
WQZG190313MNKDXL12	Leticia	Jiménez	Morales	2019-03-13	F	A-	5587070336	paciente4760@example.com
JOWE581029HRYVMLA1	Hugo	Díaz	Cabrera	1958-10-29	M	\N	5505354525	paciente4761@example.com
OLCI060923MDAKXQ52	Verónica	Flores	Delgado	2006-09-23	F	B-	5590743389	\N
SGST141231MEXACKD4	Alejandra	Cordero	Morales	2014-12-31	F	O-	5515068498	paciente4763@example.com
SXLD980105XFSIZWL2	Cecilia	Cordero	Rodríguez	1998-01-05	Intersex	AB+	5591986264	\N
KKXB881229XVSHZI78	Daniela	Estrada	Flores	1988-12-29	Intersex	A+	5518467072	paciente4765@example.com
CFVC200923XNCAMA15	Teresa	Rojas	Ortiz	2020-09-23	Intersex	B-	5588406942	paciente4766@example.com
AKTP381201HAQQCFN6	Javier	Pérez	González	1938-12-01	M	A+	5545276106	paciente4767@example.com
ZARQ200814HWGSXTM4	Diego	Herrera	Herrera	2020-08-14	M	B+	5529992335	\N
BWHF520508MFKNYJ73	Adriana	Herrera	Pérez	1952-05-08	F	AB+	5537164061	\N
DOXP950430MZUYKPV2	Beatriz	Ruiz	Ruiz	1995-04-30	F	B-	5565618222	paciente4770@example.com
PGXH870428XGTCEFL4	Francisco	García	Morales	1987-04-28	Intersex	AB+	5571811007	\N
LXUX700817MWHWNR20	Silvia	Pérez	Guzmán	1970-08-17	F	A+	5589777976	paciente4772@example.com
WHUT961104HLEPJKA3	Iván	Ramos	Rojas	1996-11-04	M	AB+	5553243845	paciente4773@example.com
BUZH670618HSLIQGL4	Emilio	Aguilar	Guzmán	1967-06-18	M	A+	5567908211	\N
JMYE470304HONBFRA4	Daniel	Vázquez	Sánchez	1947-03-04	M	A-	5506638177	paciente4775@example.com
LYCQ020908MUSCNR07	Araceli	Martínez	Pérez	2002-09-08	F	AB+	5532562928	paciente4776@example.com
AHTU900614HWJTFZU8	Antonio	Rojas	López	1990-06-14	M	A-	5591807320	paciente4777@example.com
IQRV180701XJXVNNB6	Verónica	Martínez	Contreras	2018-07-01	Intersex	O-	5524056876	\N
LIVV910728MNHXSMA9	Paola	Gutiérrez	García	1991-07-28	F	AB-	5525521427	paciente4779@example.com
XPDB211119MTUPFQQ1	Laura	Cruz	García	2021-11-19	F	AB-	5528053243	paciente4780@example.com
UPDS940929HMWRND26	Manuel	Castillo	Guzmán	1994-09-29	M	AB-	\N	paciente4781@example.com
EZJZ440301XWWNPZZ5	Alejandra	Rodríguez	Vázquez	1944-03-01	Intersex	\N	\N	paciente4782@example.com
ILUJ970421XQZOWTJ5	Claudia	Ortiz	Peña	1997-04-21	Intersex	A-	5514112478	paciente4783@example.com
UGPQ130504MCDJCVG1	Silvia	Mendoza	Vargas	2013-05-04	F	B-	5540635087	paciente4784@example.com
TLHU791108XLKKPAU9	Emilio	Salazar	Alvarado	1979-11-08	Intersex	A-	5530936760	paciente4785@example.com
JAGM530113HVWZRUN4	Fernando	Salazar	Peña	1953-01-13	M	AB+	5591627308	\N
PCIL890509HEOHEV01	Adrián	Flores	Peña	1989-05-09	M	B+	\N	paciente4787@example.com
JKZE370606HPBXWNJ4	Fernando	Morales	Vázquez	1937-06-06	M	A-	5536533390	paciente4788@example.com
NFDH980827HTHMFD09	Andrés	Castillo	Pérez	1998-08-27	M	B-	5556390334	paciente4789@example.com
AZAK010215MPGWLPN7	Mónica	Ramos	Gómez	2001-02-15	F	B-	5507951527	\N
QAOP380715XGLRIX07	Ana	Flores	Reyes	1938-07-15	Intersex	AB-	5557601886	paciente4791@example.com
CLAU951222MLQTYHW0	Elena	Gómez	Romero	1995-12-22	F	A-	5511477668	paciente4792@example.com
POEW091224MFCIIJN8	Leticia	Torres	Solís	2009-12-24	F	AB-	5575162547	paciente4793@example.com
SSRU700420HDJSLWL9	Daniel	Peña	Fuentes	1970-04-20	M	A+	5519604176	paciente4794@example.com
AANT430218MYMWFN65	Laura	Ramos	López	1943-02-18	F	B-	\N	paciente4795@example.com
FFZZ810512MECNNKS8	Ana	García	Alvarado	1981-05-12	F	AB-	5546581596	paciente4796@example.com
ZXLM451129XFFKJOC7	Daniel	Peña	Martínez	1945-11-29	Intersex	B-	5583525789	\N
UKQE410919MUCZYIN0	Lucía	Flores	Cabrera	1941-09-19	F	\N	5569341742	paciente4798@example.com
RVNW700517MFORNFF5	Silvia	Flores	Rodríguez	1970-05-17	F	\N	5514745737	\N
ZYBD160120HZAXDBA7	Emilio	Vargas	Vázquez	2016-01-20	M	O-	5513113567	paciente4800@example.com
VEBI050722MEROAHY6	Ana	González	Jiménez	2005-07-22	F	A-	5566205256	\N
HUTP450109XEQBNUF5	Claudia	Castillo	Ramos	1945-01-09	Intersex	O-	5566128550	\N
TVQE800718MYIYBZR2	Guadalupe	Romero	Solís	1980-07-18	F	B-	5514974634	paciente4803@example.com
KELF741026MUKNAQ64	Adriana	Ramos	Ortiz	1974-10-26	F	AB-	5507117633	paciente4804@example.com
LCKS191202XJPERIF2	Gerardo	Rodríguez	Cordero	2019-12-02	Intersex	B-	5585530019	paciente4805@example.com
BKQT470227MJLLYC00	Claudia	Vargas	Martínez	1947-02-27	F	O-	\N	paciente4806@example.com
QFGF380913XWRODLW5	Silvia	Díaz	Vázquez	1938-09-13	Intersex	B+	5575847019	paciente4807@example.com
AWTA731028XYVJGH50	Lucía	Salazar	López	1973-10-28	Intersex	AB+	5597872821	paciente4808@example.com
WHMO380321MZNCDV59	Paola	Peña	Reyes	1938-03-21	F	AB+	5576671571	paciente4809@example.com
DORZ210826XQHPKR55	Adrián	Sánchez	Cruz	2021-08-26	Intersex	B+	5561902279	\N
WQKD790110XRQLCGY3	Diego	Guzmán	Gutiérrez	1979-01-10	Intersex	AB+	5521379693	paciente4811@example.com
KLZN370910HHMSGI49	Raúl	Guzmán	Chávez	1937-09-10	M	B+	5533367026	\N
HKFG470518HUGCTA52	Diego	Rojas	Hernández	1947-05-18	M	AB-	\N	paciente4813@example.com
JRAH741031HPGMCAF8	Gerardo	Reyes	Medina	1974-10-31	M	O+	5562260819	paciente4814@example.com
DQNZ921021XOYMMPT9	Leticia	Delgado	Salazar	1992-10-21	Intersex	B-	5549859827	paciente4815@example.com
VWRH871220XFWMRRZ2	Sergio	Ramírez	Vargas	1987-12-20	Intersex	O-	5546110650	paciente4816@example.com
VMTN100817XOPJKNU8	Patricia	Gómez	Contreras	2010-08-17	Intersex	AB+	5533563483	paciente4817@example.com
SWTO870817XXCOJLA3	Rosa	Mendoza	Morales	1987-08-17	Intersex	A-	5571772669	\N
UNYD950304MLTSQVC3	Leticia	Aguilar	Hernández	1995-03-04	F	AB-	5523039311	\N
TVLV820430MRZEWYW2	Carmen	Torres	Rodríguez	1982-04-30	F	A+	5599118400	paciente4820@example.com
JNIR581124MUDQMX74	Patricia	López	Morales	1958-11-24	F	A+	5556379973	paciente4821@example.com
ATXY470410HNLMRMU1	Diego	Ruiz	Ramos	1947-04-10	M	\N	5524723238	paciente4822@example.com
TQBM721107MQECGEX5	Karla	Alvarado	Jiménez	1972-11-07	F	O-	5570915931	paciente4823@example.com
BQLA770428MPTBZUB8	Teresa	Solís	Contreras	1977-04-28	F	B+	5557221969	\N
AFLC141106XQKQFZO7	Araceli	Rodríguez	Flores	2014-11-06	Intersex	O-	5558467842	paciente4825@example.com
QEKB710826MOKHFA81	Verónica	Pérez	Solís	1971-08-26	F	B-	5593734013	paciente4826@example.com
ZNLF070123MWBWKXP9	Karla	Ortiz	Ramos	2007-01-23	F	O+	5545804709	\N
TOLK730504XSLYUCI1	Patricia	Delgado	Chávez	1973-05-04	Intersex	A+	5569820254	\N
BCYK800913HMCMXYQ1	Antonio	Pérez	Rojas	1980-09-13	M	A-	\N	paciente4829@example.com
DXJZ120715XEPPRCC8	Fernanda	López	Medina	2012-07-15	Intersex	B+	5584251683	paciente4830@example.com
MVIU941025HWFGFJX4	José	Salazar	Castillo	1994-10-25	M	B-	5519135454	\N
QJXR121215MSGLSS65	Patricia	Castillo	Reyes	2012-12-15	F	O-	\N	\N
MKXP130116MTGPFWG8	Ana	Sánchez	Vargas	2013-01-16	F	AB-	5573595084	paciente4833@example.com
NMTM991120XBDPJAY6	Mónica	Jiménez	Aguilar	1999-11-20	Intersex	AB+	5534629791	paciente4834@example.com
CPXX590714XOURRW00	Rosa	Torres	Estrada	1959-07-14	Intersex	O+	5591617861	\N
NSFZ180427XGVQCED4	Arturo	Delgado	Díaz	2018-04-27	Intersex	A+	5540801748	paciente4836@example.com
QDHE630606XOUJUV70	Miriam	Vázquez	Cruz	1963-06-06	Intersex	AB-	5504637475	\N
LIBY250128XCLAGLP9	Roberto	Chávez	Romero	2025-01-28	Intersex	B+	5533841949	paciente4838@example.com
JZLC840716MLUTRMV7	Claudia	Rojas	Hernández	1984-07-16	F	A-	5579985147	paciente4839@example.com
KCND890603HNNBCUM0	Jorge	Gómez	Aguilar	1989-06-03	M	AB+	5503048210	\N
CRSF720105MUPVPL29	Leticia	Herrera	Delgado	1972-01-05	F	O+	5560320991	paciente4841@example.com
IMBV920101HSEHQKW3	Luis	Ramos	Ramos	1992-01-01	M	A+	5522864414	paciente4842@example.com
MNSK391120XZVAQJG8	Roberto	Cabrera	Torres	1939-11-20	Intersex	B+	5536064380	paciente4843@example.com
GJAA761108HYHYARP0	Sergio	Gutiérrez	Martínez	1976-11-08	M	O+	5509895625	paciente4844@example.com
KKGC630315XTBLLT81	Leticia	Torres	Gutiérrez	1963-03-15	Intersex	\N	5553444859	\N
SLSC010124HNSNAU64	Sergio	Ramírez	Solís	2001-01-24	M	O-	\N	paciente4846@example.com
AKFE971109MLOELSE3	Mónica	Cordero	Guzmán	1997-11-09	F	O+	5503752994	paciente4847@example.com
EYNY050209MFHXUOE2	Alejandra	Herrera	Chávez	2005-02-09	F	AB-	5519993695	paciente4848@example.com
NPSL731212MMCLCBA1	Laura	Alvarado	Chávez	1973-12-12	F	O+	5584879307	\N
MRZD380320XBHFIPF7	Fernando	Guzmán	Contreras	1938-03-20	Intersex	A-	5565860882	\N
FLUO721022MOZHJPU8	Araceli	Sánchez	Hernández	1972-10-22	F	O-	5597237183	paciente4851@example.com
PNSD771110MOITOZA6	Verónica	Herrera	\N	1977-11-10	F	B-	5579612422	paciente4852@example.com
DVMC200916HJQYCD46	Iván	Estrada	Pérez	2020-09-16	M	B+	5527630965	\N
LQDZ990223MOUXTO72	Beatriz	López	Alvarado	1999-02-23	F	A+	5514061231	\N
AHQS440120HPOHZDK6	Alejandro	Pérez	Reyes	1944-01-20	M	B-	\N	paciente4855@example.com
HDEZ601230XEKLUKG1	Hugo	Ortiz	\N	1960-12-30	Intersex	AB-	5531727206	paciente4856@example.com
JSPG471211XQNGNED2	Yolanda	Ruiz	Peña	1947-12-11	Intersex	AB+	\N	paciente4857@example.com
KFVR420413MGDXROC4	Paola	Cordero	Cruz	1942-04-13	F	B-	\N	\N
YIPM050407MHGXJOW9	Miriam	Ortiz	Hernández	2005-04-07	F	B+	5593331696	paciente4859@example.com
PBAV111114HBRMOMT3	Javier	Gómez	Chávez	2011-11-14	M	AB+	5548825951	paciente4860@example.com
USXD770809HDBVKSP0	Hugo	González	\N	1977-08-09	M	AB-	5530162988	paciente4861@example.com
XOLW240122MLQZWJ65	Paola	Díaz	Vázquez	2024-01-22	F	A+	5513870425	paciente4862@example.com
TOQO611031XEVEGK69	Araceli	Chávez	López	1961-10-31	Intersex	O-	5509265119	\N
WOUZ941223HYAGYHB0	Manuel	Mendoza	Pérez	1994-12-23	M	B+	5545678975	\N
HOWF481213MONMGS25	María	Vázquez	Martínez	1948-12-13	F	\N	5520689479	\N
POGO670619XJVUKZH2	Daniel	García	Fuentes	1967-06-19	Intersex	O+	5521091491	paciente4866@example.com
UXOI961113MXWSFEI0	Miriam	Cordero	Rojas	1996-11-13	F	O+	5584416864	paciente4867@example.com
NPFS460412MCYKLI67	Araceli	Torres	Aguilar	1946-04-12	F	A+	5592467375	paciente4868@example.com
PWKA500913MQQEIML1	Karla	Estrada	Díaz	1950-09-13	F	AB+	5570083118	paciente4869@example.com
CWPK440905HKYUWDO4	Jorge	Guzmán	Reyes	1944-09-05	M	\N	5567699417	paciente4870@example.com
ONIA720708MPQEVSP6	Leticia	Hernández	Vázquez	1972-07-08	F	AB+	5513409502	paciente4871@example.com
HRTM520908XWSZNV76	Miguel	Fuentes	Gómez	1952-09-08	Intersex	O-	5592064232	paciente4872@example.com
NZRA890903XTNUJV76	Carlos	Salazar	Sánchez	1989-09-03	Intersex	O+	5539322349	paciente4873@example.com
QYWH240803XIVZPB70	Ricardo	Vargas	Cabrera	2024-08-03	Intersex	B+	5598602034	paciente4874@example.com
KXMQ211025HXEDUWH0	Manuel	Gómez	Vázquez	2021-10-25	M	A+	5503808691	paciente4875@example.com
MJBW580726MEFBQFV7	Gabriela	Delgado	Morales	1958-07-26	F	O-	\N	paciente4876@example.com
EMPZ380626MWKUHMI4	Verónica	Reyes	Pérez	1938-06-26	F	\N	5584856128	paciente4877@example.com
BNNG460623MKZLIFB1	Silvia	Estrada	Castillo	1946-06-23	F	O-	5538992146	paciente4878@example.com
SDGJ070714HFVHDKN0	Daniel	Sánchez	Medina	2007-07-14	M	AB+	5584323120	\N
MELT510724XOVIADU1	Adrián	Jiménez	Ortiz	1951-07-24	Intersex	AB-	5543562825	paciente4880@example.com
KNGB040223MXDJUUW1	Leticia	Díaz	\N	2004-02-23	F	AB+	5598767468	\N
WYCJ920327XLTGXAE8	Mónica	Peña	Ramírez	1992-03-27	Intersex	B+	5588242110	paciente4882@example.com
DXSK880529HMGHWMR5	Miguel	Fuentes	Reyes	1988-05-29	M	B+	5550924314	paciente4883@example.com
UVCV690710XMFLCAQ1	Jorge	Salazar	Ramos	1969-07-10	Intersex	A+	5574144022	\N
DSEW150211HDLEBAA9	Hugo	Hernández	Rodríguez	2015-02-11	M	O-	5565685468	\N
PDFP410201MOUMOF41	Yolanda	Guzmán	Estrada	1941-02-01	F	O+	5578853768	\N
MEFB971031MPUNSG47	Beatriz	González	Medina	1997-10-31	F	B+	5542099723	paciente4887@example.com
IMOR770127XMXSDHQ0	Araceli	Chávez	Vargas	1977-01-27	Intersex	\N	5522410902	\N
KWOQ200707HQHWZV95	Mario	Alvarado	López	2020-07-07	M	O+	5540940872	\N
SARR531203MXRFLB16	Beatriz	Aguilar	Mendoza	1953-12-03	F	O+	5596467826	paciente4890@example.com
ZDOY001108HIKLGSN4	Iván	Rojas	Delgado	2000-11-08	M	B-	5514337415	paciente4891@example.com
OQOJ020221HQOMGEQ2	Arturo	Rodríguez	Romero	2002-02-21	M	B+	5549388279	paciente4892@example.com
YLJF060902HIZTLLJ6	José	Sánchez	Ortiz	2006-09-02	M	B+	5546833971	\N
RRCN950408HNLTRC64	Luis	Romero	Reyes	1995-04-08	M	AB-	5571085554	\N
NOTC770905XRGTMHQ1	Fernanda	Contreras	Ortiz	1977-09-05	Intersex	AB+	5576226799	\N
QVSR171214HHVCCOR1	Óscar	Castillo	Romero	2017-12-14	M	O+	5543392608	paciente4896@example.com
SADW250104HWBRCMP6	Fernando	Rojas	Guzmán	2025-01-04	M	O+	5505249383	paciente4897@example.com
LQXN170725HFVKDBH3	Andrés	García	Flores	2017-07-25	M	A+	\N	paciente4898@example.com
GEZP400303XTBWUPD7	Araceli	Ruiz	Solís	1940-03-03	Intersex	O-	5558223370	\N
ZVPZ250724XDVADLV5	Juan	Estrada	Fuentes	2025-07-24	Intersex	O-	5559703721	paciente4900@example.com
TLVT530128XJNAMYS1	Javier	García	Ramírez	1953-01-28	Intersex	A-	5575521550	paciente4901@example.com
TUVP421022HCSQITU1	Sergio	Vargas	Aguilar	1942-10-22	M	A-	5513063368	paciente4902@example.com
MVHY640113HAYIIWY1	Óscar	Peña	Delgado	1964-01-13	M	B-	5563702770	\N
YSON780125HDQIPYS6	Arturo	Rodríguez	Flores	1978-01-25	M	O-	5527505036	paciente4904@example.com
BCPN080822XLBDZF70	Roberto	Aguilar	Flores	2008-08-22	Intersex	AB-	5572121227	paciente4905@example.com
OWHS870628HAVIZDN1	Ricardo	Pérez	Cruz	1987-06-28	M	A+	5546174696	paciente4906@example.com
NMCX730306MKJMEF78	María	Vázquez	Alvarado	1973-03-06	F	B-	5514129275	paciente4907@example.com
LROV550420MSBCGGW0	Laura	Pérez	Estrada	1955-04-20	F	AB+	5564235913	paciente4908@example.com
JEOT190429MPHBPCU7	Karla	Salazar	Rojas	2019-04-29	F	B+	5596934453	paciente4909@example.com
CADK761013HXLDMHT1	Diego	Martínez	Morales	1976-10-13	M	B-	5512342296	\N
NAKA190810XOICWLA7	Mónica	Flores	Ramos	2019-08-10	Intersex	A+	5595428758	\N
WEYU390728XBPWCAP1	Carmen	Reyes	Ortiz	1939-07-28	Intersex	B+	5506539039	\N
HYRJ680529XJLPVBU5	Hugo	Peña	Hernández	1968-05-29	Intersex	\N	5593516750	\N
ROGV001015MIXGEVS9	Daniela	Pérez	Aguilar	2000-10-15	F	A+	5538892500	paciente4914@example.com
VIKU180824HPQUSMO2	Manuel	Romero	Contreras	2018-08-24	M	O+	5571504162	paciente4915@example.com
KGZT450801HQHCVZW0	Adrián	Flores	Chávez	1945-08-01	M	O+	5576312042	paciente4916@example.com
MQWI380509XNTMELF2	Iván	Contreras	Chávez	1938-05-09	Intersex	O-	5502405162	paciente4917@example.com
LTGE720511HRDSAYR6	Emilio	Cruz	Rodríguez	1972-05-11	M	AB+	5528790231	\N
LWML830203XPWAEHF6	Leticia	Mendoza	Contreras	1983-02-03	Intersex	A+	5529831235	paciente4919@example.com
RVCC480415XSOTPZV0	Yolanda	Ruiz	Hernández	1948-04-15	Intersex	AB-	5580859973	paciente4920@example.com
UDNP990425XXESUQE3	Laura	Ramírez	Solís	1999-04-25	Intersex	B+	\N	paciente4921@example.com
JEGM540215MOLZYW60	Karla	Gómez	Vargas	1954-02-15	F	B-	5520419797	paciente4922@example.com
AQLE670203MRCSXZS6	Daniela	García	González	1967-02-03	F	B-	5502161437	paciente4923@example.com
LEKT670611XNGVCP01	Francisco	Gómez	Delgado	1967-06-11	Intersex	AB+	5514831578	\N
ITBB970921XHZRTDC7	Iván	Ramírez	Castillo	1997-09-21	Intersex	B+	5579596147	paciente4925@example.com
XSUA560623MEHHALK1	Elena	Pérez	Alvarado	1956-06-23	F	AB-	5558322077	paciente4926@example.com
ELPX641110XBFMLRB1	Daniel	Medina	González	1964-11-10	Intersex	AB-	5586387853	paciente4927@example.com
ZIYR131005XDTNNRT2	Alejandra	López	Cabrera	2013-10-05	Intersex	A+	5512235630	paciente4928@example.com
AMZG720630MQXBXME7	Lucía	Mendoza	Rojas	1972-06-30	F	A-	5591198332	paciente4929@example.com
HNYR120922XQZGCE68	Carmen	Herrera	Cordero	2012-09-22	Intersex	A+	5598320440	paciente4930@example.com
RNRT021002HUNRHZK9	Diego	Gutiérrez	Ortiz	2002-10-02	M	A+	5571348814	paciente4931@example.com
VFEZ020123XXGRSG07	Paola	Ortiz	Vázquez	2002-01-23	Intersex	O+	5536904260	paciente4932@example.com
IIYO800928MVHCIN92	Paola	Flores	Romero	1980-09-28	F	B-	5506563200	\N
TUDY640203MIPSYB91	Araceli	Ruiz	Hernández	1964-02-03	F	B-	5593920922	paciente4934@example.com
EHEV111229MXHLUTK7	Ana	Vargas	Torres	2011-12-29	F	O-	5500533005	paciente4935@example.com
QYWY081021XKVBSSI9	Pablo	Jiménez	Gómez	2008-10-21	Intersex	O+	\N	paciente4936@example.com
RBNE770915MKFSCQ27	Silvia	Alvarado	Contreras	1977-09-15	F	A-	5520377032	paciente4937@example.com
WOLS860214HLPOAJ73	Raúl	García	Romero	1986-02-14	M	A+	\N	paciente4938@example.com
TCFX650626HMNEMUC7	Miguel	Reyes	Reyes	1965-06-26	M	A+	5531068154	paciente4939@example.com
LVEU660323XUYXUXM7	Daniel	Díaz	Díaz	1966-03-23	Intersex	AB+	5568318971	\N
HJZX940701HIIBSEN0	Roberto	Mendoza	Alvarado	1994-07-01	M	O-	5527089300	paciente4941@example.com
MDOO430509MAXIKR05	Patricia	Ortiz	Contreras	1943-05-09	F	A+	5546026093	\N
IPAR070607XJPIRYP4	Ricardo	Pérez	Morales	2007-06-07	Intersex	O-	5587474749	\N
TBQS090829XXRXIDX7	Mario	Sánchez	Reyes	2009-08-29	Intersex	O-	5583424110	paciente4944@example.com
QRZP091018MEIRANW6	Elena	Herrera	Fuentes	2009-10-18	F	AB+	5568409380	\N
QGIJ600105XBTGFLE4	Eduardo	Alvarado	Sánchez	1960-01-05	Intersex	B-	5502090542	\N
XDEU020220HOQAXS42	José	Contreras	Rodríguez	2002-02-20	M	\N	5590620327	\N
YESS870627MBGXSJ81	Adriana	Torres	Reyes	1987-06-27	F	O-	5529764072	paciente4948@example.com
HGCV920925XKJZCSQ4	Hugo	Rodríguez	Fuentes	1992-09-25	Intersex	AB+	5581301008	\N
HNGU201013XOAGYV01	Emilio	Fuentes	Cabrera	2020-10-13	Intersex	AB+	5535936629	\N
AURA470227XEZWYZC8	Fernanda	Solís	Díaz	1947-02-27	Intersex	B-	5525456847	paciente4951@example.com
WQWA840205XFYVZOK4	Carmen	Rodríguez	Flores	1984-02-05	Intersex	O-	5587562256	paciente4952@example.com
MPPJ480629HWQVODE0	Manuel	Ramírez	Cruz	1948-06-29	M	B-	5530858243	\N
MGQE790520MLJGML45	Lucía	Medina	Pérez	1979-05-20	F	O-	\N	paciente4954@example.com
RJEA441211HTEFZUF3	Roberto	Peña	Aguilar	1944-12-11	M	AB+	\N	paciente4955@example.com
EHPU210426XETKGIN2	Adrián	Peña	Guzmán	2021-04-26	Intersex	A+	5547639445	paciente4956@example.com
PSMP881110XTFPEL64	Ricardo	Aguilar	Medina	1988-11-10	Intersex	\N	5517755622	paciente4957@example.com
UDRR020304XAKAKQM8	Mario	González	Rojas	2002-03-04	Intersex	O-	5521894179	paciente4958@example.com
HNTV900203MAOMNUM6	Rosa	Pérez	Salazar	1990-02-03	F	O-	5532714583	paciente4959@example.com
IKJN190425HANVBO14	Javier	Contreras	Chávez	2019-04-25	M	O+	5579189449	paciente4960@example.com
WIRZ431025HZFDHKS9	Sergio	Martínez	Ramos	1943-10-25	M	AB-	5559935384	paciente4961@example.com
WXKK500705MKVTFFE4	Beatriz	Pérez	Solís	1950-07-05	F	AB+	5528781162	paciente4962@example.com
ZSDG570302XLBQHFM2	Carmen	Fuentes	Cordero	1957-03-02	Intersex	A-	5591661074	paciente4963@example.com
NDZC241021MBIYVW96	Claudia	Peña	Ramírez	2024-10-21	F	B-	5529578775	paciente4964@example.com
LKUW091016MBRJYHK3	Laura	Medina	García	2009-10-16	F	B+	5597275556	paciente4965@example.com
CWUN730208XCPBZRR6	Paola	Hernández	Hernández	1973-02-08	Intersex	O+	5556758094	paciente4966@example.com
TKSB070928HOVKJWF1	Hugo	Martínez	Morales	2007-09-28	M	\N	5524102464	\N
TBUI680814HCTBXEX1	Manuel	Peña	Solís	1968-08-14	M	O-	5524413616	paciente4968@example.com
FAYV490408MPWXRZP2	Rosa	Cordero	Guzmán	1949-04-08	F	B+	5535611617	\N
DQYH750201XQORHGK6	Ana	Contreras	Pérez	1975-02-01	Intersex	\N	5563773060	paciente4970@example.com
QNAV131102MJOOHE55	Miriam	Sánchez	Cabrera	2013-11-02	F	A+	5582095097	paciente4971@example.com
QBSR960215XUPBUOE9	Araceli	Peña	García	1996-02-15	Intersex	O-	5558834524	paciente4972@example.com
ECAQ471105MFZDSDS3	Daniela	Contreras	Ramos	1947-11-05	F	\N	5520896719	\N
ZEMR150502XSOZZKP9	Adriana	Rodríguez	Delgado	2015-05-02	Intersex	B-	5527086582	paciente4974@example.com
NSLD820715XSJTDS04	Fernando	Reyes	Romero	1982-07-15	Intersex	\N	5519159778	\N
OYGO700522XLZBOAA7	Arturo	Castillo	Salazar	1970-05-22	Intersex	\N	5519759923	paciente4976@example.com
NGSH800604MCFJROB9	Daniela	Ramos	Fuentes	1980-06-04	F	AB-	5506881479	paciente4977@example.com
FYMJ670131XPHRVN78	Daniel	Morales	Rodríguez	1967-01-31	Intersex	O+	5526180790	paciente4978@example.com
UBCO521119MVKDNOY8	Karla	Gutiérrez	Rodríguez	1952-11-19	F	A-	5526903591	\N
HQQE480726HSFNKOH6	Alejandro	Pérez	García	1948-07-26	M	A+	\N	\N
UOJM400126MTNDYAU9	Araceli	Hernández	Salazar	1940-01-26	F	O-	5576772705	paciente4981@example.com
KIRG250507XOZYJMC6	Rosa	Alvarado	Cruz	2025-05-07	Intersex	B+	5564059044	\N
ECKV730405XENBUMT4	Lucía	Reyes	Aguilar	1973-04-05	Intersex	O-	5520346843	paciente4983@example.com
XCUM850820XYBIQAX7	Araceli	Delgado	Rojas	1985-08-20	Intersex	A-	5584454812	paciente4984@example.com
EPES771121HAQSFSB3	Hugo	Chávez	Delgado	1977-11-21	M	O-	5581355810	paciente4985@example.com
QAWH770905HFZULJK8	Gerardo	Cabrera	Cabrera	1977-09-05	M	AB+	5544494766	paciente4986@example.com
HJOB700925MSOLCEQ1	Verónica	Ramos	Rojas	1970-09-25	F	AB-	5594245092	\N
KAXW770420HEZJODX2	Luis	Peña	Ramírez	1977-04-20	M	AB-	5563668709	paciente4988@example.com
ZTIP080224HFBONSX3	Manuel	Ruiz	\N	2008-02-24	M	AB+	5592228987	paciente4989@example.com
HZMO211015HLUQQCN5	Emilio	Aguilar	Guzmán	2021-10-15	M	A+	5559076595	paciente4990@example.com
WQJU731026XTZPAJ40	Carlos	Hernández	Vázquez	1973-10-26	Intersex	A-	5505294191	paciente4991@example.com
OAUR690906MZFUWB08	Alejandra	Fuentes	Gómez	1969-09-06	F	O+	5563662131	\N
LMVA190605MLMSRPO5	Ana	Romero	Flores	2019-06-05	F	A+	5509014897	paciente4993@example.com
JYPK740610MZNHWH67	Rosa	Díaz	Delgado	1974-06-10	F	A-	5523569910	paciente4994@example.com
MFTF920227HYDEECD6	Raúl	Cruz	Torres	1992-02-27	M	B+	5596270464	paciente4995@example.com
HKZR851005MVNLWRL3	Rosa	Ramírez	Medina	1985-10-05	F	AB+	5506277789	\N
KMEH770918HDXCML19	Javier	Fuentes	Estrada	1977-09-18	M	B-	\N	\N
SSZC670331MOSCYMQ6	Paola	Cabrera	Solís	1967-03-31	F	B+	5511256738	paciente4998@example.com
KTHS861008MVUNEC63	Paola	Gutiérrez	Contreras	1986-10-08	F	B-	5524916161	paciente4999@example.com
TFIL050918MOMJYSK2	Daniela	Herrera	Ramírez	2005-09-18	F	A+	\N	paciente5000@example.com
\.

COMMIT;
