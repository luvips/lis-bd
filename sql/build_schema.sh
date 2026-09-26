#!/usr/bin/env sh
# Fase 9: consolida 00-07 en schema.sql (sin el bloque que crea/conecta la base).
# Uso: sh sql/build_schema.sh   (desde lis-laboratorio/)
set -eu
cd "$(dirname "$0")"
{
    echo "-- ============================================================================="
    echo "-- LIS Laboratorio Clínico — schema.sql (Fase 9, GENERADO: no editar a mano)"
    echo "-- Consolidado de 00_setup.sql a 07_triggers.sql. Regenerar con sql/build_schema.sh"
    echo "-- Ejecutar contra una base vacía:"
    echo "--   createdb lis_laboratorio && psql -d lis_laboratorio -f sql/schema.sql"
    echo "-- ============================================================================="
    for f in 00_setup.sql 01_enums.sql 02_catalogo.sql 03_clinico.sql 04_comercial.sql \
             05_secuencias.sql 06_indices.sql 07_triggers.sql; do
        echo
        echo "-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $f"
        sed '/@@BOOTSTRAP_BEGIN/,/@@BOOTSTRAP_END/d' "$f"
    done
} > schema.sql
echo "schema.sql generado"
