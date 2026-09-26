# syntax=docker/dockerfile:1
#
# docker-entrypoint-initdb.d/ solo se ejecuta la primera vez que el
# contenedor arranca con el volumen de datos vacío (ver postgres:18 upstream).
# sql/schema.sql ya es el consolidado sin el bloque de creación de base
# (@@BOOTSTRAP_BEGIN/END, ver sql/build_schema.sh): POSTGRES_DB crea la base
# antes de que esto corra, así que el script debe empezar directo en
# "CREATE SCHEMA lis".
FROM postgres:18-alpine

LABEL org.opencontainers.image.title="lis-laboratorio-db" \
      org.opencontainers.image.description="PostgreSQL del LIS Laboratorio Clínico (schema lis, 24 tablas / 19 ENUM / 11 triggers)"

COPY sql/schema.sql /docker-entrypoint-initdb.d/01-schema.sql

# Roles de aplicación (mínimo privilegio). Va aparte de schema.sql, igual
# que 08_validacion.sql: es una fase de seguridad, no de esquema. Lee las
# contraseñas de APP_*_PASSWORD (environment: en docker-compose.yml), nunca
# las hardcodea (regla 30).
COPY sql/09_roles.sql /docker-entrypoint-initdb.d/02-roles.sql
