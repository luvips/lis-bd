#!/usr/bin/env sh
# Carga seed/01_catalogo.sql y seed/02_demo_transacciones.sql contra el
# servicio "db" ya levantado. Corre como lis_admin (dueño del esquema):
# la seed es catálogo y datos de demo, no algo que un rol de aplicación
# (sql/09_roles.sql) inserte en operación normal.
#
# No se hornea en la imagen (no está en docker-entrypoint-initdb.d/): la
# seed cambia independiente del esquema y no siempre se quiere en todos los
# entornos (por ejemplo, producción real querría solo 01_catalogo.sql, sin
# las 5 solicitudes de demostración de 02_demo_transacciones.sql).
#
# Uso:
#   ./scripts/seed.sh              # catálogo + demo
#   ./scripts/seed.sh catalogo     # solo el catálogo
#   ./scripts/seed.sh volumen      # solo seed/03_volumen.sql (5,000 pacientes,
#                                  # 50 médicos, 100 estudios, 10 técnicos, 15
#                                  # equipos; regenerarlo primero si no existe:
#                                  # python seed/generate_volumen.py)
set -eu
cd "$(dirname "$0")/.."

[ -f .env ] || { echo "Falta .env (copia .env.example y ajusta credenciales)" >&2; exit 1; }
set -a
. ./.env
set +a

COMPOSE="docker compose -f docker/docker-compose.yml --env-file .env"
DB="${POSTGRES_DB:-lis_laboratorio}"
USER="${POSTGRES_USER:?POSTGRES_USER no definido en .env}"

load() {
    echo "== $1 =="
    $COMPOSE exec -T db psql -U "$USER" -d "$DB" -v ON_ERROR_STOP=1 < "$1"
}

if [ "${1:-}" = "volumen" ]; then
    [ -f seed/03_volumen.sql ] || { echo "Falta seed/03_volumen.sql: correr antes 'python seed/generate_volumen.py'" >&2; exit 1; }
    load seed/03_volumen.sql
else
    load seed/01_catalogo.sql
    if [ "${1:-}" != "catalogo" ]; then
        load seed/02_demo_transacciones.sql
    fi
fi
echo "Seed cargada."
