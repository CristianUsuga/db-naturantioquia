SET SERVEROUTPUT ON

DECLARE
   sql_stmt VARCHAR2(200);
BEGIN
   FOR tab IN (SELECT table_name FROM all_tables WHERE owner = 'USER_NATURANTIOQUIA') LOOP
      sql_stmt := 'DROP TABLE USER_NATURANTIOQUIA.' || tab.table_name || ' CASCADE CONSTRAINTS';
      BEGIN
         EXECUTE IMMEDIATE sql_stmt;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al eliminar la tabla ' || tab.table_name || ': ' || SQLERRM);
      END;
   END LOOP;
END;
/
