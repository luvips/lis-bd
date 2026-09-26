.PHONY: build up down restart logs ps psql test backup down-v

COMPOSE = docker compose -f docker/docker-compose.yml --env-file .env

build: ## Construye la imagen (hornea sql/schema.sql adentro)
	$(COMPOSE) build

up: ## Levanta db en segundo plano (local: expone 5432 vía override; EC2: no)
	$(COMPOSE) up -d --build

down: ## Detiene y quita el contenedor; conserva el volumen de datos
	$(COMPOSE) down

down-v: ## Como down, pero además borra el volumen de datos (destructivo)
	$(COMPOSE) down -v

restart:
	$(COMPOSE) restart db

logs: ## Sigue los logs de Postgres
	$(COMPOSE) logs -f db

ps:
	$(COMPOSE) ps

psql: ## Abre una sesión psql dentro del contenedor
	$(COMPOSE) exec db sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'

test: ## Corre triggers + validación + roles (requiere "make up")
	./scripts/run-tests.sh

seed: ## Carga seed/01_catalogo.sql + seed/02_demo_transacciones.sql
	./scripts/seed.sh

seed-catalogo: ## Solo seed/01_catalogo.sql, sin las solicitudes de demo
	./scripts/seed.sh catalogo

seed-volumen: ## Carga seed/03_volumen.sql (regenerarlo antes si hace falta, ver README)
	./scripts/seed.sh volumen

backup: ## pg_dump a backups/<db>_<fecha>.dump
	./scripts/backup.sh
