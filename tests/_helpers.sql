-- =============================================================================
-- Helpers de aserción para pruebas. Se incluyen con \ir DENTRO de una
-- transacción: al hacer ROLLBACK desaparecen junto con los datos de prueba.
--   SELECT pg_temp.chk(condicion, 'descripción');
--   SELECT pg_temp.espera_error($$ sentencia $$, 'sqlstate', 'descripción');
-- Cada aserción imprime una línea "OK - ..." (evidencia) o aborta con
-- "FALLO - ..." (psql sale con código 3 por ON_ERROR_STOP).
-- =============================================================================
\pset tuples_only on
\pset format unaligned

CREATE FUNCTION pg_temp.chk(p_ok boolean, p_msg text)
RETURNS text
LANGUAGE plpgsql AS $$
BEGIN
    IF p_ok IS NOT TRUE THEN
        RAISE EXCEPTION 'FALLO - %', p_msg;
    END IF;
    RETURN 'OK    - ' || p_msg;
END
$$;

CREATE FUNCTION pg_temp.espera_error(p_sql text, p_sqlstate text, p_msg text)
RETURNS text
LANGUAGE plpgsql AS $$
BEGIN
    BEGIN
        EXECUTE p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLSTATE <> p_sqlstate THEN
            RAISE EXCEPTION 'FALLO - % (se esperaba SQLSTATE %, se obtuvo %: %)',
                            p_msg, p_sqlstate, SQLSTATE, SQLERRM;
        END IF;
        RETURN format('OK    - %s [error esperado %s: %s]', p_msg, SQLSTATE, SQLERRM);
    END;
    RAISE EXCEPTION 'FALLO - % (se esperaba error %, la sentencia tuvo éxito)', p_msg, p_sqlstate;
END
$$;
