#!/usr/bin/env sh
# Formato "custom" (-Fc): permite restaurar con pg_restore, tablas
# individuales o en paralelo; más flexible que un dump de texto plano.
set -eu
cd "$(dirname "$0")/.."

[ -f .env ] || { echo "Falta .env" >&2; exit 1; }
set -a
. ./.env
set +a

COMPOSE="docker compose -f docker/docker-compose.yml --env-file .env"
DB="${POSTGRES_DB:-lis_laboratorio}"
USER="${POSTGRES_USER:?POSTGRES_USER no definido en .env}"

mkdir -p backups
stamp=$(date -u +%Y%m%dT%H%M%SZ)
out="backups/${DB}_${stamp}.dump"

$COMPOSE exec -T db pg_dump -U "$USER" -d "$DB" -Fc > "$out"
echo "Respaldo escrito en $out"
