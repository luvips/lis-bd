# LIS Laboratorio Clínico — DDL PostgreSQL

Implementación del plan [`plans/plan-ddl-lis.md`](../plans/plan-ddl-lis.md) a partir del
[Diccionario de Datos](../context/) y de las reglas de [`.claude/rules/`](../.claude/rules/).
24 tablas, 19 ENUM y 11 triggers de negocio en el schema `lis`. El plan original tenía 7 triggers. El octavo, `trg_copiar_numero_repeticion_muestra`, se agregó después en el diccionario. El noveno al undécimo (`trg_validar_parametro_resultado`, `trg_validar_reasignacion_procesamiento`, `trg_validar_reasignacion_resultado`) se agregaron en la revisión del núcleo clínico.

Requiere PostgreSQL ≥ 13 (probado en 18.1) y la extensión `btree_gist`, incluida en contrib, que `00_setup.sql` instala. En PG 18 `gen_uuid_v7()` envuelve el
`uuidv7()` nativo. En versiones anteriores usa una implementación PL/pgSQL sin extensiones.

## Ejecución

Paso a paso, una fase por archivo:

```sh
psql -U postgres -f sql/00_setup.sql                 # crea la base lis_laboratorio y el schema lis
for f in sql/0[1-7]_*.sql; do psql -d lis_laboratorio -f "$f"; done
```

Con el consolidado de la Fase 9 contra una base vacía:

```sh
createdb lis_laboratorio
psql -d lis_laboratorio -f sql/schema.sql
```

Pruebas y validación. Todas usan `BEGIN … ROLLBACK`, así que no dejan datos:

```sh
for f in tests/triggers/0*.sql; do psql -d lis_laboratorio -f "$f"; done
psql -d lis_laboratorio -f sql/08_validacion.sql
```

Roles de aplicación (mínimo privilegio, ver sección "Roles y permisos") y sus pruebas:

```sh
psql -d lis_laboratorio -f sql/09_roles.sql       # requiere APP_*_PASSWORD en el entorno
psql -d lis_laboratorio -f tests/roles/01_permisos.sql
```

Cada aserción imprime `OK - …`. Los errores provocados a propósito aparecen como
`[error esperado SQLSTATE: …]`. Un fallo real aborta con `FALLO - …` y psql sale con código 3.

`schema.sql` se genera con `sh sql/build_schema.sh`, así que no se edita a mano.
Cada archivo de fase lleva al final un bloque `-- DOWN` comentado para revertirla.

## Docker

La imagen hornea `sql/schema.sql` (no lo monta como volumen): lo que se construye es
exactamente lo que corre en la EC2, sin depender de que el host tenga el repo en la
ruta correcta. Postgres solo ejecuta `docker-entrypoint-initdb.d/` la primera vez que
arranca con el volumen de datos vacío.

```sh
cp .env.example .env      # ajustar POSTGRES_PASSWORD antes de levantar nada
make build                # o: docker compose -f docker/docker-compose.yml --env-file .env build
make up                   # levanta db; en local expone 5432 (docker-compose.override.yml)
make test                 # triggers + validación + permisos de rol (130 aserciones)
make seed                 # catálogo + 5 solicitudes de demo (ver sección Seed)
make psql                 # abre una sesión psql en el contenedor (como lis_admin)
make backup               # pg_dump -Fc a backups/<db>_<fecha>.dump
make down                 # detiene el contenedor; conserva el volumen de datos
```

La imagen ejecuta dos scripts de inicialización, en este orden, la primera vez que
arranca con el volumen vacío: `01-schema.sql` (`sql/schema.sql`) y `02-roles.sql`
(`sql/09_roles.sql`, ver "Roles y permisos"). Este último lee `APP_*_PASSWORD` del
entorno del contenedor (`\getenv`, regla 30): `docker-compose.yml` exige esas cinco
variables igual que ya exige `POSTGRES_PASSWORD`, así que faltan solo si `.env` está
incompleto.

`docker/docker-compose.yml` es la base y **no publica el puerto 5432** (regla 29,
mínimo privilegio de red): en la EC2 solo otros contenedores de la misma red de
compose llegan a `db:5432`. `docker-compose.override.yml` solo existe para desarrollo
local y expone el puerto; se combina automáticamente cuando ambos archivos están en
el mismo directorio y se listan con `-f`, como hace `make`.

**Desplegar en la EC2** (mínimo viable, sin registry):

```sh
git clone <repo> && cd lis-laboratorio
cp .env.example .env && vi .env     # POSTGRES_PASSWORD real, nunca el de ejemplo
make build && make up
```

El volumen nombrado `lis_laboratorio_pgdata` persiste en el EBS de la instancia. Para
que sobreviva a reemplazar la instancia, monta el EBS en la ruta del volumen de Docker
o usa `scripts/backup.sh` por cron y sube el `.dump` a S3. Si más adelante quieres
builds reproducibles fuera de la instancia (CI → ECR → `docker compose pull` en la
EC2), es un paso natural después; no se monta aquí porque no hay pipeline de CI en
este repo todavía.

**Seguridad:** el Security Group de la EC2 no necesita abrir el 5432 a Internet; el
puerto solo se publica en el override de desarrollo. `.env` está en `.gitignore`
(regla 30) — nunca se versiona la contraseña real.

## Roles y permisos

`sql/09_roles.sql` (Fase 10, no se consolida en `schema.sql`, igual que
`08_validacion.sql`) divide el acceso como lo haría un LIS real: un rol de
grupo por módulo de la operación, más una cuenta de conexión por rol. **La
aplicación nunca se conecta con `lis_admin`** (`POSTGRES_USER`): ese usuario
es superusuario por el propio bootstrap de la imagen de Postgres y solo
existe para desplegar el esquema.

| Rol de grupo | Cuenta de conexión | Puede | No puede |
|---|---|---|---|
| `lis_recepcion` | `app_recepcion` | Alta de pacientes/médicos, abrir solicitudes, anotar observaciones | Progresar el estado de un estudio, cobrar, ver lo clínico |
| `lis_laboratorio` | `app_laboratorio` | Tomar muestra, procesar, capturar y corregir resultados | Abrir solicitudes, liberar resultados, cambiar equipos, cobrar |
| `lis_supervisor` | `app_supervisor` | Todo lo de `lis_laboratorio` (lo hereda) + liberar resultados (`es_definitivo`), cambiar estado de equipos, cancelar estudios | Cobrar |
| `lis_caja` | `app_caja` | Cuentas, líneas de cobro, pagos, descuentos | Tocar columnas calculadas (`saldo_pendiente`...), editar un pago ya capturado, lo clínico |
| `lis_reporting` | `app_reporting` | `SELECT` en todo el schema (incluye tablas futuras, vía `ALTER DEFAULT PRIVILEGES`) | Escribir absolutamente nada |

Ningún rol tiene `DELETE`: nada se borra físicamente (catálogos usan `activo`,
lo demás es historial/append). Donde una tabla mezcla columnas que el rol
captura a mano con columnas que mantiene un trigger o un `DEFAULT`
(`solicitud.estado_global`, `cuenta.subtotal/total/saldo_pendiente`,
`resultado_valor.numero_version`...), el `GRANT` es por columna: el rol
puede `UPDATE` las suyas, no las calculadas.

**Decisión clave — `SECURITY DEFINER`:** los triggers que escriben en una
tabla *distinta* de la que dispara el evento (recalcular `solicitud.estado_global`
desde `detalle_solicitud`, recalcular `cuenta` desde `detalle_cuenta`/`pago`,
anular una línea de cobro o descartar un tubo al cancelar, versionar en
`historial_resultado_valor`) se marcan `SECURITY DEFINER`, dueño `lis_admin`.
Así, por ejemplo, `lis_caja` puede insertar en `detalle_cuenta` y el trigger
recalcula `cuenta.subtotal` con los privilegios de `lis_admin`, sin que
`lis_caja` necesite `UPDATE` directo sobre esa columna. Sin esto, cada rol
necesitaría privilegios de escritura sobre columnas de otras tablas que
nunca debería tocar a mano — justo lo que la separación de roles busca
evitar. Las funciones ya declaraban `SET search_path = lis, pg_temp` desde
la Fase 7, el requisito de seguridad para que un `SECURITY DEFINER` no sea
inyectable vía `search_path`.

`tests/roles/01_permisos.sql` prueba el límite de cada rol con `SET ROLE`
(un superusuario puede asumir cualquier rol sin ser miembro): al menos una
operación legítima que debe funcionar y una que debe rechazarse con `42501`
por rol, incluida la prueba de que los triggers `SECURITY DEFINER` corren
sin que el rol tenga privilegio directo sobre la tabla que el trigger toca.

## Seed

`seed/01_catalogo.sql` (10 estudios con sus analitos y rangos de referencia,
3 paquetes, 5 equipos, 8 personal, 6 médicos, 15 pacientes) y
`seed/02_demo_transacciones.sql` (5 solicitudes que recorren distintos
caminos del modelo) se cargan aparte, con `make seed`, **nunca horneados en
la imagen**: la seed cambia independiente del esquema y no todo entorno
quiere las mismas 5 solicitudes de demostración (`make seed-catalogo` carga
solo el catálogo). Ambos corren como `lis_admin`: insertan en catálogo
(`estudio`, `valor_referencia`...), donde ningún rol de aplicación tiene
`INSERT`.

Ningún archivo usa un UUID a mano: cada referencia entre filas se resuelve
por clave natural (`codigo`, `cedula_profesional`, `curp`, `numero_empleado`,
`numero_serie`) con una subconsulta, así que se lee como catálogo real y no
como una lista de UUID sin contexto.

Las 5 solicitudes de demo, cada una mostrando un camino distinto:

| # | Paciente | Qué muestra |
|---|---|---|
| A | Javier Romero | Flujo completo de punta a punta: BH suelto, pagado, `entregada` |
| B | María López | Paquete prenatal EN PROGRESO: 2 de 4 estudios completados (`parcialmente_completada`), uno sin muestra tomada, pago parcial |
| C | Carlos Hernández | Repetición por muestra hemolizada (`requiere_repeticion` → segundo intento), cuenta sin ningún pago |
| D | Ana Sofía Vázquez | Un tubo compartido entre dos estudios; se cancela uno después de tomar la muestra y el tubo sigue vivo porque el otro estudio lo sigue usando |
| E | Miriam Estrada | Cultivo con antibiograma: 6 analitos cualitativos (`valor_texto` con S/I/R) en un solo resultado |

### Volumen inicial de operación

El laboratorio inicia operaciones con ~5,000 pacientes, 50 médicos, 100 tipos
de estudio, 10 técnicos y 15 equipos. `seed/generate_volumen.py` genera ese
volumen como `seed/03_volumen.sql` (ya generado y versionado, igual que
`sql/schema.sql`: "no editar a mano", se regenera con el mismo comando).
Sin dependencias externas (nada de `pip install`; solo librería estándar de
Python 3), así que corre igual en la EC2 que en cualquier máquina:

```sh
python seed/generate_volumen.py     # regenera seed/03_volumen.sql (~5,800 líneas)
make seed-volumen                   # lo carga contra el contenedor
```

Es un seed **aparte** de `01_catalogo.sql`/`02_demo_transacciones.sql`, no un
reemplazo: los 100 "estudios" son sintéticos (nombre/categoría/precio al
azar, 1-3 analitos genéricos cada uno), pensados para llenar la base a
escala real y correr ahí las pruebas de volumen (`tests/volumen/`,
`EXPLAIN ANALYZE`, concurrencia), no para documentación clínica. Usa
prefijos `VOL-` en todo código/cédula/número de serie, así que puede
cargarse junto con el catálogo pequeño sin chocar. Los 5,000 pacientes se
cargan con `COPY` (regla 8.2: más rápido que `INSERT` para este volumen);
todo lo demás, con `INSERT` de varias filas. `--seed` controla la semilla
aleatoria: la misma semilla reproduce el archivo byte a byte.

**`tests/volumen/01_explain_catalogo.sql`** corre `EXPLAIN (ANALYZE, BUFFERS)`
sobre este volumen (regla 15) y documenta lo observado: la búsqueda de un
paciente por CURP usa el índice `UNIQUE` sin necesitar nada adicional
(~0.3 ms); un filtro de baja selectividad como `paciente WHERE activo` sigue
siendo un `Seq Scan` correcto y rápido a esta escala (regla 20/21: no se
indexa lo que no lo necesita); y la cadena `estudio → parametro_estudio →
valor_referencia` sí usa `idx_valor_referencia_parametro`. El volumen
cargado hoy es de catálogo/roster, no de operación: las tablas clínicas
(`solicitud`, `muestra`, `procesamiento`) siguen en la escala pequeña de
`02_demo_transacciones.sql` — probar esa ruta a volumen real (y la
concurrencia de pagos) sigue pendiente, ver más abajo.

**Nota sobre el orden:** correr `sql/08_validacion.sql` (o `make test`)
*después* de cargar cualquier seed puede fallar una aserción que cuenta
filas globales (ej. "1 paciente alérgico a penicilina"), porque esa cuenta
ya no da 1 con datos de seed en la tabla. Por diseño, la validación
estructural corre contra el esquema recién creado, antes de sembrar nada
(`make test` antes de `make seed`, como en los ejemplos de arriba); no es
un fallo del esquema, es la validación asumiendo una base sin datos previos.

## Estructura

| Ruta | Contenido |
|---|---|
| `sql/00_setup.sql` … `07_triggers.sql` | Fases 0-7 del plan, cada una en su propia transacción |
| `sql/08_validacion.sql` | Fase 8: cobertura de índices en FK, flujo end-to-end y RESTRICT en catálogos |
| `sql/schema.sql` | Fase 9: consolidado ejecutable de 00-07 |
| `sql/09_roles.sql` | Fase 10: roles de aplicación (ver "Roles y permisos"); no se consolida en `schema.sql` |
| `tests/_helpers.sql` | Aserciones `pg_temp.chk` y `pg_temp.espera_error` |
| `tests/triggers/` | Una prueba aislada por trigger, más `_fixtures.sql` |
| `tests/roles/` | Prueba el límite de cada rol de `sql/09_roles.sql` con `SET ROLE` |
| `tests/volumen/01_explain_catalogo.sql` | `EXPLAIN (ANALYZE, BUFFERS)` sobre el catálogo a escala real (ver "Volumen inicial de operación") |
| `tests/constraints/`, `docs/` | Reservadas para etapas posteriores |
| `seed/01_catalogo.sql`, `seed/02_demo_transacciones.sql` | Datos de catálogo y 5 solicitudes de demo (ver "Seed") |
| `seed/generate_volumen.py`, `seed/03_volumen.sql` | Volumen inicial de operación (5,000 pacientes...); el `.py` genera el `.sql` |
| `docker/Dockerfile`, `docker/docker-compose.yml`, `docker/docker-compose.override.yml` | Imagen y orquestación (ver sección Docker) |
| `scripts/run-tests.sh`, `scripts/backup.sh`, `scripts/seed.sh` | Automatizan `make test`, `make backup` y `make seed` contra el contenedor |
| `Makefile`, `.env.example` | Atajos de operación y plantilla de variables de entorno |

## Decisiones tomadas

- **Núcleo clínico** (revisión 2026-09-25):
  - Un estudio tiene analitos (`parametro_estudio`), y cada analito tiene rangos con vigencia (`valor_referencia`).
  - Un tubo (`muestra`) pertenece a la solicitud y sirve a varios estudios (`muestra_detalle_solicitud`).
  - Cada corrida (`procesamiento`) procesa un tubo para un estudio y produce un `resultado` (1:1) con un `resultado_valor` por analito.
  - Dos FK compuestas impiden procesar un tubo no vinculado al estudio y usar el rango de otro analito.
  - `trg_validar_parametro_resultado` impide capturar un analito de otro estudio (Hemoglobina en una corrida de glucosa). Se usó un trigger porque una FK compuesta exigiría copiar `estudio_id` en tres tablas.
  - `trg_validar_reasignacion_procesamiento` y `trg_validar_reasignacion_resultado` cierran el hueco simétrico: reasignar `procesamiento.detalle_solicitud_id` o `resultado.procesamiento_id` a otro estudio después de capturar valores también se rechaza, no solo la captura inicial.
  - Un `EXCLUDE USING gist` impide rangos activos traslapados. El sexo se compara como conjunto con `fn_rango_sexo()`, así que un rango para ambos sexos (NULL) choca con uno de `F`. Un valor explícito `'ambos'` no lo resolvería, porque `'ambos' = 'F'` también es falso.
  - En `valor_referencia`, `activo` y la vigencia son datos distintos. La vigencia (`vigente_desde`/`vigente_hasta`) dice en qué periodo aplica un rango válido. `activo = FALSE` anula un rango capturado por error y lo saca del `EXCLUDE`, para que su corrección no choque con él. Ninguna combinación de ambos se contradice.
- **UUID v7**: la función `gen_uuid_v7()` es el `DEFAULT` de las 24 PK. Todo el DDL la usa en vez de `uuidv7()` para que el esquema funcione igual en cualquier versión.
- **Schema `lis`**: permite dar privilegios por schema. El `search_path` de la base queda como `lis, public`.
- **Folios** (`SOL-YYYY-NNNNNN`, `CTA-YYYY-NNNNNN`): usan una secuencia **continua** que no se reinicia cada año. `nextval()` no bloquea y nunca repite número. El año del prefijo es solo informativo. Puede haber huecos, porque un rollback consume el número.
- **`estado_global` de la solicitud**: el diccionario no define la regla, así que se usa esta, en orden de prioridad. Si todos los detalles están cancelados, la solicitud queda `cancelada`, un valor agregado al ENUM `estado_solicitud`. Si no, se evalúan solo los detalles no cancelados:
  1. Si todos están completados, la solicitud queda `completada`.
  2. Si alguno está completado, queda `parcialmente_completada`.
  3. Si alguno está en procesamiento o requiere repetición, queda `en_procesamiento`.
  4. Si a alguno ya se le tomó muestra, queda `en_toma_de_muestra`.
  5. Si no aplica nada de lo anterior, queda `recibida`.

  El estado `entregada` se asigna a mano y el trigger no lo regresa a `completada`. `cancelada` no es un estado final: si después se agrega un detalle no cancelado, la solicitud se recalcula.
- **Correcciones de resultado**: el trigger toma quién corrige y el motivo de `SET LOCAL lis.personal_id` y `SET LOCAL lis.motivo_modificacion`, porque `historial_resultado_valor` exige ambos datos. Sin ellos, la corrección se rechaza. Cada analito se versiona por separado. Un antibiograma se registra como un parámetro por antibiótico con `valor_texto` S/I/R.
- **Sobrepago**: si se anula un estudio que ya estaba pagado, `saldo_pendiente` queda en 0 y se emite un `WARNING`. Ningún trigger genera un movimiento de devolución. `saldo_pendiente` es un campo desnormalizado: el sobrepago real se puede reconstruir a partir de `pago` y de `detalle_cuenta.anulado`. `CHECK (saldo_pendiente >= 0)` se mantiene para detectar errores de cálculo en otros triggers. Hacer la devolución es un proceso manual y queda fuera de alcance.
- **`trg_validar_saldo_pago`**: además de `INSERT`, se dispara en `UPDATE` de monto, estado o cuenta. Así no se puede reactivar un pago cancelado por encima del saldo.
- **Índices**: no se crean índices duplicados (regla 23). Una FK que ya es el prefijo de un `UNIQUE` o de un índice compuesto no recibe índice propio, y `08_validacion.sql` comprueba que ninguna FK quede sin cubrir. No hay índices GIN: los JSONB consultables se normalizaron. Un índice parcial solo cubre una FK si su predicado es `col IS NOT NULL`. No se usa `CONCURRENTLY` porque las tablas están vacías en el despliegue inicial.

## Desviaciones respecto al plan, el diccionario o las reglas (a revisar)

1. **Nombres en singular** (`paciente`, no `pacientes`). La regla 1 pide plural, pero el diccionario y el plan son la fuente de verdad del dominio.
2. **PK UUID en lugar de `BIGINT IDENTITY`**: se siguen el diccionario y la excepción que admite la propia regla 2. `VARCHAR(n)` ya no es desviación. La regla 3 se corrigió para aceptarlo cuando `n` sale de un estándar o de una regla de negocio. El origen de cada `n` queda en un `COMMENT`: correo 254 por RFC 5321, teléfono 20 por E.164 y nombres 100.
3. **`activo BOOLEAN`** en los catálogos, incluidos `valor_referencia`, `parametro_estudio` y `antecedente_paciente`. Se omite en:
   - `equipo`: ya tiene `estado_operativo`, y un equipo cuenta como activo mientras `estado_operativo <> 'dado_de_baja'`. Tener las dos columnas permitiría combinaciones contradictorias.
   - `estudio_equipo`, `estudio_tipo_muestra` y `paquete_estudio`: son relaciones N:M de las que no depende ningún historial. Cuando un vínculo deja de aplicar, se borra con `DELETE`.
4. **Índice `(estado, fecha_solicitud)` en `detalle_solicitud`**: esa tabla no tiene `fecha_solicitud`, así que el índice se creó sobre `(estado, creado_en)`.
5. **No se creó el índice `(muestra_id, numero_version DESC)`** que pedía el plan original: `UNIQUE(resultado_id, parametro_estudio_id)` en `resultado_valor` ya resuelve el valor vigente de cada analito.
6. **CHECK añadidos que no están en el diccionario**:
   - `valor_minimo <= valor_maximo`, al menos un límite, `vigente_hasta > vigente_desde` y el `EXCLUDE` anti-traslape en `valor_referencia`.
   - Formato de CURP (RENAPO) y de correo (contiene `@`) en `paciente` y `medico`.
   - `fecha_fin >= fecha_inicio` en `procesamiento`.
   - `estado_anterior <> estado_nuevo` en `estado_equipo`.
   - `version >= 1` en `historial_resultado_valor`.

## Pendiente, fuera del alcance de este plan

- Trigger genérico para `actualizado_en` en `paciente`, `medico` y `estudio`. Hoy solo `resultado` lo mantiene.
- Registro automático en `estado_equipo` cuando cambia `equipo.estado_operativo`.
- Recalcular la cuenta cuando se cambia `cuenta.descuento_total` directamente.
- Decidir si se prohíbe agregar estudios a una solicitud `cancelada` y obligar a abrir una solicitud nueva. Requeriría un trigger `BEFORE INSERT` en `detalle_solicitud`. No es urgente: solo se implementaría si ese caso aparece en la operación real. Mientras tanto, la solicitud se recalcula.
- El flujo de devolución de un sobrepago, que hoy es manual, y un reporte de saldo a favor calculado a partir de `pago` y `detalle_cuenta`.
- `autovacuum` explícito por tabla para `cuenta`, `detalle_solicitud` y `solicitud` (regla 34). Los roles de aplicación con mínimo privilegio ya se resolvieron: `sql/09_roles.sql`.
- La prueba de concurrencia de pagos, que se hará en `tests/volumen/`.
- Ninguno conocido en la validación de analitos: la captura inicial (`trg_validar_parametro_resultado`) y la reasignación posterior (`trg_validar_reasignacion_procesamiento`, `trg_validar_reasignacion_resultado`) quedan cubiertas.
