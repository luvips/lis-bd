#!/usr/bin/env sh
# Levanta un contenedor cliente efímero con sql/ y tests/ montados de solo
# lectura (en vez de ejecutar dentro de "db") para que \ir en cada script
# resuelva las rutas relativas igual que en local.
set -eu
cd "$(dirname "$0")/.."

# Git Bash/MSYS en Windows reescribe rutas que empiezan con "/" como si
# fueran del host antes de pasarlas a docker (p. ej. "/checks/x" se vuelve
# "C:/Program Files/Git/checks/x"). Esta variable lo desactiva; en Linux
# (EC2) no existe MSYS y la variable simplemente no hace nada.
export MSYS_NO_PATHCONV=1

[ -f .env ] || { echo "Falta .env (copia .env.example y ajusta credenciales)" >&2; exit 1; }
set -a
. ./.env
set +a

COMPOSE="docker compose -f docker/docker-compose.yml --env-file .env"
DB="${POSTGRES_DB:-lis_laboratorio}"
USER="${POSTGRES_USER:?POSTGRES_USER no definido en .env}"

echo "Esperando a que db esté lista..."
$COMPOSE exec db pg_isready -U "$USER" -d "$DB" >/dev/null

run_file() {
    $COMPOSE run --rm \
        -e PGPASSWORD="$POSTGRES_PASSWORD" \
        -v "$(pwd)/sql:/checks/sql:ro" \
        -v "$(pwd)/tests:/checks/tests:ro" \
        --entrypoint psql \
        db -h db -U "$USER" -d "$DB" -v ON_ERROR_STOP=1 -f "/checks/$1"
}

total_ok=0
fallo=0
# [0-9]* excluye _fixtures.sql y _helpers.sql: no tienen su propio
# BEGIN...ROLLBACK (se incluyen con \ir dentro de cada test) y dejarían
# datos permanentes si se ejecutaran sueltos.
for f in tests/triggers/[0-9]*.sql sql/08_validacion.sql tests/roles/[0-9]*.sql; do
    echo "== $f =="
    if out=$(run_file "$f" 2>&1); then
        n=$(printf '%s\n' "$out" | grep -c '^OK' || true)
        printf '%s\n' "$out" | grep '^OK'
        total_ok=$((total_ok + n))
    else
        echo "$out"
        fallo=1
    fi
done

echo
echo "Total de aserciones OK: $total_ok"
[ "$fallo" -eq 0 ] || { echo "Hubo fallos." >&2; exit 1; }
