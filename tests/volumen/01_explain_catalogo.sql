-- =============================================================================
-- LIS Laboratorio Clínico — Volumen 1: EXPLAIN (ANALYZE, BUFFERS) sobre catálogo
-- Depende de: seed/03_volumen.sql ya cargado (5,000 pacientes, 50 médicos,
-- 100 estudios, 10 técnicos, 15 equipos; seed/01_catalogo.sql también puede
-- estar cargado, no interfiere).
--
-- No es una prueba pasa/falla como tests/triggers/ (el tiempo varía de una
-- corrida a otra): es un script que se lee, siguiendo la regla 15 ("EXPLAIN
-- ANALYZE antes de aceptar una query como 'final' en rutas de alto
-- volumen"). Cada bloque documenta qué patrón de consulta prueba y qué se
-- observó la última vez que corrió (regla 33: revisar antes de optimizar a
-- ciegas — aquí no hace falta optimizar nada todavía).
--
-- Uso:
--   docker compose -f docker/docker-compose.yml --env-file .env exec db \
--     psql -U lis_admin -d lis_laboratorio -f /dev/stdin < tests/volumen/01_explain_catalogo.sql
--   (o, con el helper del proyecto: cat este archivo | make psql, o
--    "docker compose ... exec -T db psql -U lis_admin -d lis_laboratorio"
--    con este archivo como stdin)
--
-- Alcance: el volumen que existe hoy es de CATÁLOGO/ROSTER (paciente,
-- medico, estudio, personal, equipo), no de operación (solicitud, muestra,
-- procesamiento siguen en la escala pequeña de seed/02_demo_transacciones.sql,
-- 5 solicitudes). Probar la ruta clínica a volumen real (miles de
-- solicitudes, concurrencia de pagos) requiere generar esas transacciones
-- primero — pendiente, ver README "Pendiente, fuera del alcance de este plan".
-- =============================================================================
\set ON_ERROR_STOP on
\encoding UTF8
SET search_path = lis, public;

\echo '=== 1. Búsqueda de paciente por CURP (UNIQUE, uq_paciente_curp) ==='
-- Observado (5,015 pacientes): Index Scan using uq_paciente_curp para el
-- WHERE curp = ..., Execution Time total ~0.91 ms — pero casi todo ese
-- tiempo es el InitPlan que elige un CURP al azar para la prueba (Seq Scan
-- + Sort sobre las 5,015 filas, ~0.76 ms) y no representa el patrón real:
-- en producción el CURP lo escribe recepción, no se elige con random().
-- El índice UNIQUE que ya exige la regla de negocio (CURP no se repite)
-- resuelve gratis el patrón de búsqueda más común de admisión: localizar a
-- un paciente que ya existe, sin ningún índice adicional que mantener.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, nombre, apellido_paterno, apellido_materno
FROM paciente
WHERE curp = (SELECT curp FROM paciente ORDER BY random() LIMIT 1);

\echo '=== 2. Pacientes activos (sin índice) ==='
-- Observado: Seq Scan, Execution Time ~0.72 ms sobre 5,015 filas. No hay
-- índice parcial (WHERE activo) como el de equipo/cuenta, y no hace falta:
-- casi todas las filas están activas (baja selectividad), así que un índice
-- no ayudaría — sería más grande que el Seq Scan que ya de por sí es rápido
-- a esta escala (regla 20/21: índices por patrón de consulta real, no
-- especulativos; un WHERE activo solo se indexa cuando el subconjunto es
-- realmente pequeño, como en equipo.estado_operativo).
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) FROM paciente WHERE activo;

\echo '=== 3. Estudios de una categoría (tabla chica: 110 filas) ==='
-- Observado: Seq Scan, Execution Time ~0.07 ms. A 100-110 filas, Postgres
-- descarta correctamente cualquier índice: leer la tabla completa es más
-- barato que ir y volver por un índice. No se crea un índice sobre
-- estudio.categoria por la misma razón que el punto 2.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, nombre, precio FROM estudio WHERE categoria = 'Quimica_Clinica' AND activo;

\echo '=== 4. Analitos y rangos de un estudio (cadena de FK) ==='
-- Observado: Hash Join (parametro_estudio vía Seq Scan, 245 filas — tabla
-- chica, correcto no indexarla) + Index Scan using
-- idx_valor_referencia_parametro para el último salto. Execution Time
-- total ~0.16 ms (igual que en el punto 1, el InitPlan que elige el
-- estudio al azar es solo para variar la prueba, no representa el patrón
-- real). Confirma que el índice de la FK de valor_referencia
-- (sql/06_indices.sql, necesario porque el GiST del EXCLUDE es parcial y no
-- la cubre) sí se usa en el patrón de consulta para el que se creó: "los
-- rangos de referencia de este analito".
EXPLAIN (ANALYZE, BUFFERS)
SELECT e.nombre, pe.nombre, vr.valor_minimo, vr.valor_maximo
FROM estudio e
JOIN parametro_estudio pe ON pe.estudio_id = e.id
JOIN valor_referencia vr ON vr.parametro_estudio_id = pe.id
WHERE e.codigo = (SELECT codigo FROM estudio ORDER BY random() LIMIT 1);

\echo '=== 5. Búsqueda de paciente por apellido, prefijo (sin índice) ==='
-- Observado: Seq Scan, Execution Time ~0.35 ms sobre 5,015 filas, ~130
-- coincidencias con un apellido común. Sigue siendo rápido a esta escala.
-- Si en producción real (decenas/cientos de miles de pacientes) este
-- patrón de búsqueda de recepción resulta frecuente, un índice btree sobre
-- apellido_paterno (con text_pattern_ops si el locale no es "C") sí
-- ayudaría a un LIKE 'prefijo%' — pendiente hasta confirmar el patrón real
-- de uso (regla 20), no se crea especulativamente.
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, nombre, apellido_paterno, curp
FROM paciente
WHERE apellido_paterno LIKE 'García%';
