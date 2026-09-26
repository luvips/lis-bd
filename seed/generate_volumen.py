#!/usr/bin/env python3
# =============================================================================
# LIS Laboratorio Clínico — Generador de seed de volumen
#
# El laboratorio inicia operaciones con ~5,000 pacientes, 50 médicos,
# 100 tipos de estudio, 10 técnicos y 15 equipos. Este script genera un
# .sql (seed/03_volumen.sql por defecto) con esos volúmenes; no se conecta
# a la base directamente (nada de psycopg2/Faker: solo librería estándar),
# así que corre igual en tu máquina, en CI o en la EC2 sin instalar nada.
# El archivo resultante se carga exactamente como los otros seed:
#
#   python seed/generate_volumen.py
#   docker compose -f docker/docker-compose.yml --env-file .env exec -T db \
#     psql -U lis_admin -d lis_laboratorio -v ON_ERROR_STOP=1 < seed/03_volumen.sql
#
# Es un seed APARTE de seed/01_catalogo.sql (10 estudios reales, con
# analitos y rangos clínicamente sensatos, pensado para demos/documentación)
# y de seed/02_demo_transacciones.sql. Este es para llenar la base a la
# escala inicial real y correr ahí las pruebas de volumen (tests/volumen/,
# EXPLAIN ANALYZE, concurrencia) — los 100 "estudios" son sintéticos
# (nombre/categoría/precio al azar, 1-3 analitos genéricos cada uno), no
# un catálogo clínico. Usa prefijos "VOL-" en todos los códigos/cédulas/
# números de serie para no chocar con seed/01_catalogo.sql si se cargan
# los dos en la misma base.
#
# Solo genera catálogo/roster (paciente, medico, estudio + su detalle,
# personal, equipo): "el laboratorio inicia operaciones" es el momento
# ANTES de la primera solicitud, no incluye solicitudes ni muestras.
#
# Reproducible: mismo --seed -> mismo archivo, byte a byte.
# =============================================================================
import argparse
import datetime
import random
import sys

# ---- Datos base para generar nombres/lugares plausibles sin dependencias ---
NOMBRES_M = [
    "José", "Juan", "Luis", "Carlos", "Miguel", "Jorge", "Francisco", "Antonio",
    "Alejandro", "Manuel", "Ricardo", "Eduardo", "Roberto", "Fernando", "Sergio",
    "Raúl", "Arturo", "Javier", "Daniel", "Andrés", "Óscar", "Hugo", "Iván",
    "Rodrigo", "Gerardo", "Pablo", "Emilio", "Diego", "Mario", "Adrián",
]
NOMBRES_F = [
    "María", "Guadalupe", "Ana", "Laura", "Patricia", "Verónica", "Claudia",
    "Adriana", "Mónica", "Gabriela", "Alejandra", "Sofía", "Fernanda", "Daniela",
    "Karla", "Paola", "Rosa", "Elena", "Silvia", "Teresa", "Cecilia", "Lucía",
    "Miriam", "Diana", "Beatriz", "Carmen", "Leticia", "Yolanda", "Araceli",
]
APELLIDOS = [
    "García", "Martínez", "López", "Hernández", "González", "Pérez", "Rodríguez",
    "Sánchez", "Ramírez", "Cruz", "Flores", "Gómez", "Morales", "Vázquez",
    "Jiménez", "Reyes", "Torres", "Díaz", "Ortiz", "Gutiérrez", "Chávez",
    "Ramos", "Ruiz", "Mendoza", "Aguilar", "Castillo", "Romero", "Alvarado",
    "Vargas", "Contreras", "Guzmán", "Rojas", "Medina", "Herrera", "Fuentes",
    "Salazar", "Cabrera", "Delgado", "Estrada", "Peña", "Solís", "Cordero",
]
ESPECIALIDADES = [
    "Medicina General", "Medicina Interna", "Ginecología", "Pediatría",
    "Endocrinología", "Cardiología", "Nefrología", "Reumatología",
    "Gastroenterología", "Dermatología", "Geriatría", "Oncología",
    None, None,  # varios médicos sin especialidad registrada (nullable real)
]
INSTITUCIONES = [
    "Consultorio particular", "Hospital General", "Clínica del Valle",
    "Centro Médico ABC", "IMSS", "ISSSTE", None, None,
]
FABRICANTES = ["Roche", "Sysmex", "Abbott", "Siemens", "Beckman Coulter", "Mindray", "Binder"]
UBICACIONES = [
    "Área de Hematología", "Área de Química Clínica", "Área de Inmunología",
    "Área de Uroanálisis", "Área de Microbiología", "Almacén", "Piso 2",
]
CATEGORIAS = [
    "Hematologia", "Quimica_Clinica", "Microbiologia", "Inmunologia",
    "Endocrinologia", "Uroanalisis",
]
TIPOS_MUESTRA = [
    "sangre_venosa", "sangre_capilar", "orina", "heces", "esputo", "tejido", "otro",
]
UNIDADES = ["mg/dL", "g/dL", "U/L", "mIU/mL", "ng/mL", "%", "x10^3/uL", "mmol/L"]


def sql_str(s):
    """Escapa un string para un literal SQL ('...'); None -> NULL."""
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def copy_escape(s):
    """Escapa un valor para el formato de texto de COPY (tabs, saltos, backslash)."""
    if s is None:
        return "\\N"
    return (
        s.replace("\\", "\\\\")
        .replace("\t", "\\t")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
    )


def gen_curp(rng, fecha_nacimiento, sexo_letra, usados):
    letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    while True:
        curp = (
            "".join(rng.choice(letras) for _ in range(4))
            + fecha_nacimiento.strftime("%y%m%d")
            + sexo_letra
            + "".join(rng.choice(letras) for _ in range(5))
            + rng.choice(letras + "0123456789")
            + str(rng.randint(0, 9))
        )
        if curp not in usados:
            usados.add(curp)
            return curp


def gen_fecha_nacimiento(rng, hoy):
    dias = rng.randint(365, 90 * 365)  # entre 1 y 90 años
    return hoy - datetime.timedelta(days=dias)


def gen_telefono(rng):
    return "55" + "".join(str(rng.randint(0, 9)) for _ in range(8))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--pacientes", type=int, default=5000)
    ap.add_argument("--medicos", type=int, default=50)
    ap.add_argument("--estudios", type=int, default=100)
    ap.add_argument("--tecnicos", type=int, default=10)
    ap.add_argument("--equipos", type=int, default=15)
    ap.add_argument("--seed", type=int, default=42, help="Semilla para reproducibilidad")
    ap.add_argument("--out", default="seed/03_volumen.sql")
    args = ap.parse_args()

    rng = random.Random(args.seed)
    hoy = datetime.date.today()
    curps_usados = set()

    out = sys.stdout if args.out == "-" else open(args.out, "w", encoding="utf-8", newline="\n")
    w = out.write

    w("-- =============================================================================\n")
    w("-- LIS Laboratorio Clínico — Seed 3: Volumen inicial de operación\n")
    w(f"-- GENERADO por seed/generate_volumen.py --seed {args.seed}. No editar a mano:\n")
    w("-- regenerar con el mismo comando para reproducir exactamente este archivo.\n")
    w(f"-- {args.pacientes} pacientes, {args.medicos} médicos, {args.estudios} estudios "
      f"sintéticos, {args.tecnicos} técnicos, {args.equipos} equipos.\n")
    w("-- Independiente de seed/01_catalogo.sql (prefijos VOL- en todos los códigos);\n")
    w("-- puede cargarse solo, antes o después. Se ejecuta como lis_admin.\n")
    w("-- =============================================================================\n")
    w("\\set ON_ERROR_STOP on\n\\encoding UTF8\nBEGIN;\nSET search_path = lis, public;\n")
    w("DO $$ BEGIN PERFORM 'lis'::regnamespace; END $$;\n\n")

    # ---- EQUIPO -------------------------------------------------------------
    w(f"-- {args.equipos} equipos\n")
    w("INSERT INTO equipo (numero_serie, nombre_modelo, fabricante, ubicacion, "
      "fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento) VALUES\n")
    filas = []
    for i in range(1, args.equipos + 1):
        fab = rng.choice(FABRICANTES)
        modelo = f"{fab} Modelo-{rng.randint(100, 999)}"
        ubic = rng.choice(UBICACIONES)
        f_ult = hoy - datetime.timedelta(days=rng.randint(1, 200))
        f_prox = hoy + datetime.timedelta(days=rng.randint(30, 200))
        filas.append(
            f"    ('VOL-EQ-{i:03d}', {sql_str(modelo)}, {sql_str(fab)}, {sql_str(ubic)}, "
            f"'{f_ult.isoformat()}', '{f_prox.isoformat()}')"
        )
    w(",\n".join(filas) + ";\n\n")

    # ---- MEDICO ---------------------------------------------------------------
    w(f"-- {args.medicos} médicos\n")
    w("INSERT INTO medico (cedula_profesional, nombre, apellido_paterno, apellido_materno, "
      "especialidad, institucion, telefono) VALUES\n")
    filas = []
    for i in range(1, args.medicos + 1):
        sexo = rng.choice(["M", "F"])
        nombre = rng.choice(NOMBRES_M if sexo == "M" else NOMBRES_F)
        ap_p, ap_m = rng.choice(APELLIDOS), rng.choice(APELLIDOS)
        esp = rng.choice(ESPECIALIDADES)
        inst = rng.choice(INSTITUCIONES)
        tel = gen_telefono(rng)
        filas.append(
            f"    ('VOL-MED-{i:05d}', {sql_str(nombre)}, {sql_str(ap_p)}, {sql_str(ap_m)}, "
            f"{sql_str(esp)}, {sql_str(inst)}, {sql_str(tel)})"
        )
    w(",\n".join(filas) + ";\n\n")

    # ---- PERSONAL (técnicos) -------------------------------------------------
    w(f"-- {args.tecnicos} técnicos de laboratorio\n")
    w("INSERT INTO personal (numero_empleado, nombre, apellido_paterno, apellido_materno, rol) VALUES\n")
    filas = []
    for i in range(1, args.tecnicos + 1):
        sexo = rng.choice(["M", "F"])
        nombre = rng.choice(NOMBRES_M if sexo == "M" else NOMBRES_F)
        ap_p, ap_m = rng.choice(APELLIDOS), rng.choice(APELLIDOS)
        filas.append(
            f"    ('VOL-TEC-{i:03d}', {sql_str(nombre)}, {sql_str(ap_p)}, {sql_str(ap_m)}, "
            "'tecnico_laboratorio')"
        )
    w(",\n".join(filas) + ";\n\n")

    # ---- ESTUDIO (sintético) + su detalle -----------------------------------
    w(f"-- {args.estudios} estudios sintéticos (catálogo real: seed/01_catalogo.sql)\n")
    w("INSERT INTO estudio (codigo, nombre, categoria, tiempo_procesamiento_estimado, "
      "requiere_ayuno, precio) VALUES\n")
    filas = []
    estudios = []  # (codigo, num_parametros, categoria) para las tablas de detalle
    for i in range(1, args.estudios + 1):
        cat = rng.choice(CATEGORIAS)
        codigo = f"VOL-{i:03d}"
        nombre = f"Estudio Sintético {cat.replace('_', ' ')} #{i:03d}"
        minutos = rng.choice([20, 30, 45, 60, 90, 120])
        ayuno = rng.random() < 0.2
        precio = round(rng.uniform(80, 600), 2)
        n_parametros = rng.randint(1, 3)
        estudios.append((codigo, n_parametros, cat))
        filas.append(
            f"    ({sql_str(codigo)}, {sql_str(nombre)}, {sql_str(cat)}::categoria_estudio, "
            f"'{minutos} minutes', {str(ayuno).upper()}, {precio})"
        )
    w(",\n".join(filas) + ";\n\n")

    w("-- Un tipo de muestra aceptado por estudio\n")
    w("INSERT INTO estudio_tipo_muestra (estudio_id, tipo_muestra, es_preferida)\n")
    w("SELECT e.id, v.tipo_muestra, TRUE FROM estudio e\n")
    w("JOIN (VALUES\n")
    filas = [f"    ({sql_str(cod)}, {sql_str(rng.choice(TIPOS_MUESTRA))}::tipo_muestra)" for cod, _, _ in estudios]
    w(",\n".join(filas) + "\n")
    w(") AS v(codigo, tipo_muestra) ON e.codigo = v.codigo;\n\n")

    w("-- 1 equipo por estudio (de los generados arriba)\n")
    w("INSERT INTO estudio_equipo (estudio_id, equipo_id, es_equipo_primario)\n")
    w("SELECT e.id, eq.id, TRUE FROM estudio e\n")
    w("JOIN (VALUES\n")
    filas = [
        f"    ({sql_str(cod)}, 'VOL-EQ-{rng.randint(1, args.equipos):03d}')"
        for cod, _, _ in estudios
    ]
    w(",\n".join(filas) + "\n")
    w(") AS v(codigo, numero_serie) ON e.codigo = v.codigo\n")
    w("JOIN equipo eq ON eq.numero_serie = v.numero_serie;\n\n")

    w("-- 1-3 analitos genéricos por estudio, con un rango de referencia numérico\n")
    w("INSERT INTO parametro_estudio (estudio_id, nombre, unidad_medida, orden)\n")
    w("SELECT e.id, v.nombre, v.unidad, v.orden FROM estudio e\n")
    w("JOIN (VALUES\n")
    filas = []
    for cod, n_param, _ in estudios:
        for k in range(1, n_param + 1):
            filas.append(
                f"    ({sql_str(cod)}, 'Analito {k}', {sql_str(rng.choice(UNIDADES))}, {k})"
            )
    w(",\n".join(filas) + "\n")
    w(") AS v(codigo, nombre, unidad, orden) ON e.codigo = v.codigo;\n\n")

    w("INSERT INTO valor_referencia (parametro_estudio_id, valor_minimo, valor_maximo)\n")
    w("SELECT pe.id, v.minimo, v.maximo\n")
    w("FROM parametro_estudio pe JOIN estudio e ON e.id = pe.estudio_id\n")
    w("JOIN (VALUES\n")
    filas = []
    for cod, n_param, _ in estudios:
        for k in range(1, n_param + 1):
            minimo = round(rng.uniform(0, 50), 1)
            maximo = round(minimo + rng.uniform(10, 100), 1)
            filas.append(f"    ({sql_str(cod)}, 'Analito {k}', {minimo}, {maximo})")
    w(",\n".join(filas) + "\n")
    w(") AS v(codigo, nombre, minimo, maximo) ON e.codigo = v.codigo AND pe.nombre = v.nombre;\n\n")

    # ---- PACIENTE (COPY, es la tabla grande) --------------------------------
    w(f"-- {args.pacientes} pacientes, vía COPY (mucho más rápido que INSERT para este volumen)\n")
    w("COPY paciente (curp, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, "
      "sexo_biologico, tipo_sanguineo, telefono, correo) FROM stdin;\n")
    tipos_sangre = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-", None]
    for i in range(1, args.pacientes + 1):
        sexo, letra_curp = rng.choice([("M", "H"), ("F", "M"), ("Intersex", "X")])
        nombre = rng.choice(NOMBRES_M if sexo == "M" else NOMBRES_F if sexo == "F" else NOMBRES_M + NOMBRES_F)
        ap_p, ap_m = rng.choice(APELLIDOS), rng.choice(APELLIDOS) if rng.random() > 0.05 else None
        f_nac = gen_fecha_nacimiento(rng, hoy)
        curp = gen_curp(rng, f_nac, letra_curp, curps_usados)
        tipo_sangre = rng.choice(tipos_sangre)
        tel = gen_telefono(rng) if rng.random() > 0.1 else None
        correo = f"paciente{i}@example.com" if rng.random() > 0.3 else None
        linea = "\t".join([
            copy_escape(curp),
            copy_escape(nombre),
            copy_escape(ap_p),
            copy_escape(ap_m),
            f_nac.isoformat(),
            sexo,
            copy_escape(tipo_sangre),
            copy_escape(tel),
            copy_escape(correo),
        ])
        w(linea + "\n")
    w("\\.\n\n")

    w("COMMIT;\n")
    if out is not sys.stdout:
        out.close()
        print(f"Escrito {args.out}: {args.pacientes} pacientes, {args.medicos} médicos, "
              f"{args.estudios} estudios, {args.tecnicos} técnicos, {args.equipos} equipos.",
              file=sys.stderr)


if __name__ == "__main__":
    main()
