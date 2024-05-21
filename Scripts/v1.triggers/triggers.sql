prompt +----------------------------------+
prompt |      Creación de Triggers       |
prompt |       en la Base de Datos        |
prompt |          naturantioquia          |
prompt +----------------------------------+

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ESTADOS_USUARIOS           
prompt +-------------------------------------------------------------+

DROP SEQUENCE SEQ_ID_ESTADO_USUARIOS;

CREATE SEQUENCE SEQ_ID_ESTADO_USUARIOS START WITH 4 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_INSERT_ESTADO_USUARIO
BEFORE INSERT ON ESTADOS_USUARIOS
FOR EACH ROW
BEGIN
    SELECT SEQ_ID_ESTADO_USUARIOS.NEXTVAL INTO :NEW.ID_ESTADO_USUARIOS FROM DUAL;
END;
/



prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla roles           
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_rol;
CREATE SEQUENCE secuencia_id_rol START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_asignar_id_rol
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
    SELECT secuencia_id_rol.NEXTVAL INTO :new.id_rol FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  DEPARTAMENTOS          
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_departamento;
CREATE SEQUENCE secuencia_id_departamento START WITH 1 INCREMENT BY 1  NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_asignar_id_departamento
BEFORE INSERT ON DEPARTAMENTOS
FOR EACH ROW
BEGIN
    SELECT secuencia_id_departamento.NEXTVAL INTO :new.id_departamento FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CIUDADES          
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_ciudad;
CREATE SEQUENCE secuencia_id_ciudad START WITH 1 INCREMENT BY 1  NOCACHE NOCYCLE;


CREATE OR REPLACE TRIGGER trg_ciudades_asignar_secuencia
BEFORE INSERT ON CIUDADES
FOR EACH ROW
BEGIN
    SELECT secuencia_id_ciudad.NEXTVAL INTO :new.id_ciudad FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   BARRIOS         
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_barrio;
CREATE SEQUENCE secuencia_id_barrio START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_barrios_asignar_insert
BEFORE INSERT ON BARRIOS
FOR EACH ROW
BEGIN
    SELECT secuencia_id_barrio.NEXTVAL INTO :new.id_barrio FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   DIRECCIONES         
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_direccion;
CREATE SEQUENCE secuencia_id_direccion START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_direcciones_before_insert
BEFORE INSERT ON DIRECCIONES
FOR EACH ROW
BEGIN
    SELECT secuencia_id_direccion.NEXTVAL INTO :new.id_direccion FROM dual;
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   FORMULARIOS         
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_formulario;
CREATE SEQUENCE secuencia_id_formulario START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_Validacion_Formularios
BEFORE INSERT
ON Formularios
FOR EACH ROW
DECLARE
    -- Variables para validar nodos principales
    v_nodo_principal_nuevo NUMBER(1);
    v_cantidad_nodos_principales NUMBER(1);
    -- Variables para validar ID padre
    v_padre_es_modulo NUMBER;
    -- Excepciones
    ex_nodo_principal_duplicado EXCEPTION;
    ex_nodo_principal_sin_padre EXCEPTION;
    ex_padre_no_es_modulo EXCEPTION;
BEGIN
    SELECT secuencia_id_formulario.NEXTVAL INTO :new.ID_FORMULARIO FROM dual;

  -- nodo principal debe ser modulo
  IF :new.NODO_PRINCIPAL = 1 THEN
    :new.MODULO := 1;
  END IF;

  -- Validar nodo principal único
  SELECT COUNT(*)
  INTO v_cantidad_nodos_principales
  FROM Formularios
  WHERE Nodo_Principal = 1;

  v_nodo_principal_nuevo := :new.Nodo_Principal;

  IF v_cantidad_nodos_principales > 0 AND v_nodo_principal_nuevo = 1 THEN
    RAISE ex_nodo_principal_duplicado;
  END IF;

  -- Validar ID padre para nodo principal
  IF v_nodo_principal_nuevo = 1 THEN
    IF :new.Id_Padre IS NOT NULL THEN
      RAISE ex_nodo_principal_sin_padre;
    END IF;
  ELSE
    -- Validar ID padre no nulo
    IF :new.Id_Padre IS NULL THEN
      RAISE ex_nodo_principal_sin_padre;
    ELSE
      -- Validar que el padre sea un módulo
      SELECT MODULO
      INTO v_padre_es_modulo
      FROM Formularios
      WHERE ID_FORMULARIO = :new.Id_Padre;

      IF v_padre_es_modulo <> 1 THEN
        RAISE ex_padre_no_es_modulo;
      END IF;
    END IF;
  END IF;

  -- Manejo de excepciones
  EXCEPTION
    WHEN ex_nodo_principal_duplicado THEN
      RAISE_APPLICATION_ERROR(-20001, 'Ya existe un nodo principal en la tabla Formularios');
    WHEN ex_nodo_principal_sin_padre THEN
      RAISE_APPLICATION_ERROR(-20002, 'El nodo principal no puede tener un padre si no es el nodo principal');
    WHEN ex_padre_no_es_modulo THEN
      RAISE_APPLICATION_ERROR(-20003, 'El ID padre debe ser un módulo (Modulo = 1)');
END;
/
------> UPDATE
CREATE OR REPLACE TRIGGER trg_Validacion_Formularios_update
BEFORE UPDATE
ON Formularios
FOR EACH ROW
DECLARE
    -- Variables para validar nodos principales
    v_nodo_principal_nuevo NUMBER(1);
    -- Variables para validar ID padre
    v_padre_es_modulo NUMBER;
    -- Excepciones
    ex_padre_no_es_modulo EXCEPTION;
BEGIN
    IF UPDATING THEN
        IF :new.NODO_PRINCIPAL = 1 THEN
            :new.MODULO := 1;
        END IF;

        IF :new.NODO_PRINCIPAL <> 1 AND :new.Id_Padre IS NOT NULL THEN
        -- Validar que el padre sea un módulo solo si tiene un padre
        SELECT MODULO
        INTO v_padre_es_modulo
        FROM Formularios
        WHERE ID_FORMULARIO = :new.Id_Padre;

        IF v_padre_es_modulo <> 1 THEN
            RAISE ex_padre_no_es_modulo;
        END IF;
        END IF;
    END IF;
    EXCEPTION
        WHEN ex_padre_no_es_modulo THEN
    RAISE_APPLICATION_ERROR(-20003, 'El ID padre debe ser un módulo (Modulo = 1)');
END;
/
----> DELETE

CREATE OR REPLACE TRIGGER trg_Validacion_After_Delete_Formularios
AFTER DELETE
ON Formularios
FOR EACH ROW
DECLARE
    v_tipo_formulario VARCHAR2(50);
BEGIN
    IF :old.NODO_PRINCIPAL = 1 THEN
        v_tipo_formulario := 'Nodo Principal';
    ELSIF :old.MODULO = 1 THEN
        v_tipo_formulario := 'Módulo';
    ELSE
        v_tipo_formulario := 'Archivo';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Se ha eliminado un ' || v_tipo_formulario || ': ' || :old.NOMBRE_FORMULARIO);
END;
/



prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   PERFILES         
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_perfil;
CREATE SEQUENCE secuencia_id_perfil START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_insert_perfil
BEFORE INSERT ON PERFILES
FOR EACH ROW
BEGIN
        SELECT secuencia_id_perfil.NEXTVAL INTO :NEW.ID_PERFIL FROM dual;
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla USUARIOS           
prompt +-------------------------------------------------------------+

CREATE OR REPLACE TRIGGER trg_Validacion_Usuario
BEFORE INSERT OR UPDATE
ON USUARIOS
FOR EACH ROW
DECLARE
  ex_documento_invalido EXCEPTION;
  
  ex_nombre_usuario_nulo EXCEPTION;

  ex_primer_apellido_nulo EXCEPTION;
  
  ex_segundo_apellido_invalido EXCEPTION;

  ex_correo_invalido EXCEPTION;

  ex_contrasena_invalida EXCEPTION;

  ex_fecha_nacimiento_invalida EXCEPTION;
  
  ex_celular_invalido EXCEPTION;
  
  ex_telefono_invalido EXCEPTION;
BEGIN
  -- Validar número de documento
  IF LENGTH(:NEW.DOCUMENTO_USUARIO) < 7 OR LENGTH(:NEW.DOCUMENTO_USUARIO) > 10 OR
     NOT REGEXP_LIKE(:NEW.DOCUMENTO_USUARIO, '^[0-9]+$') THEN
    RAISE ex_documento_invalido;
  END IF;

  -- Validar nombre de usuario
  IF :NEW.NOMBRE_USUARIO IS NULL THEN
    RAISE ex_nombre_usuario_nulo;
  ELSE
    :NEW.NOMBRE_USUARIO := TRIM(UPPER(:NEW.NOMBRE_USUARIO));
  END IF;

  -- Validar primer apellido
  IF :NEW.PRIMER_APELLIDO_USUARIO IS NULL THEN
    RAISE ex_primer_apellido_nulo;
  ELSE
    :NEW.PRIMER_APELLIDO_USUARIO := TRIM(UPPER(:NEW.PRIMER_APELLIDO_USUARIO));
  END IF;

  -- Validar segundo apellido si está presente
  IF :NEW.SEGUNDO_APELLIDO_USUARIO IS NOT NULL THEN
    IF LENGTH(:NEW.SEGUNDO_APELLIDO_USUARIO) > 40 OR
       NOT REGEXP_LIKE(:NEW.SEGUNDO_APELLIDO_USUARIO, '^[a-zA-Z ]+$') THEN
      RAISE ex_segundo_apellido_invalido;
    ELSE
      :NEW.SEGUNDO_APELLIDO_USUARIO := TRIM(UPPER(:NEW.SEGUNDO_APELLIDO_USUARIO));
    END IF;
  END IF;

  -- Validar correo electrónico
  IF :NEW.CORREO_USUARIO IS NULL OR
     NOT REGEXP_LIKE(:NEW.CORREO_USUARIO, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
    RAISE ex_correo_invalido;
  END IF;

  -- Validar contraseña
  IF LENGTH(:NEW.PASSWORD_USUARIO) <= 8 OR
     NOT REGEXP_LIKE(:NEW.PASSWORD_USUARIO, '.*[A-Z]+.*[0-9]+.*') THEN
    RAISE ex_contrasena_invalida;
  END IF;

  -- Validar fecha de nacimiento
  IF :NEW.FECHA_NACIMIENTO_USUARIO IS NOT NULL THEN
    IF (:NEW.FECHA_NACIMIENTO_USUARIO < (SYSDATE - 160*365) OR :NEW.FECHA_NACIMIENTO_USUARIO > (SYSDATE - 14*365)) THEN
      RAISE ex_fecha_nacimiento_invalida;
    END IF;
  END IF;

  -- Validar número de celular
  IF :NEW.CELULAR_USUARIO IS NOT NULL THEN
    IF LENGTH(:NEW.CELULAR_USUARIO) <> 10 OR
       SUBSTR(:NEW.CELULAR_USUARIO, 1, 1) <> '3' OR
       NOT REGEXP_LIKE(:NEW.CELULAR_USUARIO, '^[0-9]+$') THEN
      RAISE ex_celular_invalido;
    ELSE
      :NEW.CELULAR_USUARIO := TRIM(:NEW.CELULAR_USUARIO);
    END IF;
  END IF;

  -- Validar número de teléfono
  IF :NEW.TELEFONO_USUARIO IS NOT NULL THEN
    IF LENGTH(:NEW.TELEFONO_USUARIO) > 0 THEN
      IF LENGTH(:NEW.TELEFONO_USUARIO) <> 10 OR
         SUBSTR(:NEW.TELEFONO_USUARIO, 1, 2) <> '60' OR
         NOT REGEXP_LIKE(:NEW.TELEFONO_USUARIO, '^[0-9]+$') THEN
        RAISE ex_telefono_invalido;
      END IF;
    END IF;
  END IF;
  
  -- Manejo de excepciones
  EXCEPTION
    WHEN ex_documento_invalido THEN
      RAISE_APPLICATION_ERROR(-20006, 'El número de documento no es válido en Colombia.');
    WHEN ex_nombre_usuario_nulo THEN
      RAISE_APPLICATION_ERROR(-20007, 'El nombre de usuario no puede estar en blanco.');
    WHEN ex_primer_apellido_nulo THEN
      RAISE_APPLICATION_ERROR(-20008, 'El primer apellido no puede estar en blanco.');
    WHEN ex_segundo_apellido_invalido THEN
      RAISE_APPLICATION_ERROR(-20009, 'El segundo apellido no es válido.');
    WHEN ex_correo_invalido THEN
      RAISE_APPLICATION_ERROR(-20010, 'El correo electrónico no es válido.');
    WHEN ex_contrasena_invalida THEN
      RAISE_APPLICATION_ERROR(-20011, 'La contraseña no cumple con los requisitos de seguridad. 8 caracteres, contener al menos una letra mayúscula y un número.');
    WHEN ex_fecha_nacimiento_invalida THEN
      RAISE_APPLICATION_ERROR(-20012, 'La fecha de nacimiento no cumple con los requisitos.(14 años)');
    WHEN ex_celular_invalido THEN
      RAISE_APPLICATION_ERROR(-20013, 'El número de celular no es válido. Inicia con 3');
    WHEN ex_telefono_invalido THEN
      RAISE_APPLICATION_ERROR(-20014, 'El número de teléfono no válido. 60 + área + teléfono fijo.');
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla SEGUIMIENTOS           
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_seguimiento;
CREATE SEQUENCE secuencia_id_seguimiento START WITH 11 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_seguimiento
BEFORE INSERT ON SEGUIMIENTOS
FOR EACH ROW
BEGIN
        SELECT secuencia_id_seguimiento.NEXTVAL INTO :NEW.ID_SEGUIMIENTO FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla PRIORIDADES           
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_prioridad;
CREATE SEQUENCE secuencia_id_prioridad START WITH 5 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_prioridad
BEFORE INSERT ON PRIORIDADES
FOR EACH ROW
BEGIN
    SELECT secuencia_id_prioridad.NEXTVAL INTO :NEW.ID_PRIORIDAD FROM dual;

END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ID_TIPO_TRANSPORTISTA    
prompt +-------------------------------------------------------------+

DROP SEQUENCE secuencia_id_tipo_transportista;
CREATE SEQUENCE secuencia_id_tipo_transportista START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_transportista
BEFORE INSERT ON TIPO_TRANSPORTISTA
FOR EACH ROW
BEGIN
    SELECT secuencia_id_tipo_transportista.NEXTVAL INTO :NEW.ID_TIPO_TRANSPORTISTA FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ESTADOS_LABORATORIOS    
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_estado_lab;
CREATE SEQUENCE secuencia_id_estado_lab START WITH 3 INCREMENT BY 1 NOCACHE;


CREATE OR REPLACE TRIGGER trg_insert_estado_lab
BEFORE INSERT ON ESTADOS_LABORATORIOS
FOR EACH ROW
BEGIN
        SELECT secuencia_id_estado_lab.NEXTVAL INTO :NEW.ID_ESTADO_LAB FROM dual;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_MOVIMIENTOS    
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_t_movimiento;
CREATE SEQUENCE secuencia_id_t_movimiento START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_t_movimiento
BEFORE INSERT ON TIPOS_MOVIMIENTOS
FOR EACH ROW
BEGIN
    
    SELECT secuencia_id_t_movimiento.NEXTVAL INTO :NEW.ID_T_MOVIMIENTO FROM dual;
   
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  TIPO_DESCUENTO   
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_tipo_desc;
CREATE SEQUENCE secuencia_id_tipo_desc START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_desc
BEFORE INSERT ON TIPO_DESCUENTO
FOR EACH ROW
BEGIN
   
  SELECT secuencia_id_tipo_desc.NEXTVAL INTO :NEW.ID_TIPO_DESC FROM dual;

END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   TIPO_VALOR
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_tipo_valor;
CREATE SEQUENCE secuencia_id_tipo_valor START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_valor
BEFORE INSERT ON TIPO_VALOR
FOR EACH ROW
BEGIN
    SELECT secuencia_id_tipo_valor.NEXTVAL INTO :NEW.ID_TIPO_VALOR FROM dual;

END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CATEGORIAS
prompt +-------------------------------------------------------------+
DROP SEQUENCE secuencia_id_categoria;
CREATE SEQUENCE secuencia_id_categoria START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_categoria
BEFORE INSERT ON CATEGORIAS
FOR EACH ROW
BEGIN
 
   SELECT secuencia_id_categoria.NEXTVAL INTO :NEW.ID_CATEGORIA FROM dual;

END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  LABORATORIOS
prompt +-------------------------------------------------------------+
DROP SEQUENCE SEQ_ID_LABORATORIO;
CREATE SEQUENCE SEQ_ID_LABORATORIO START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_Validacion_Laboratorios
BEFORE INSERT OR UPDATE
ON LABORATORIOS
FOR EACH ROW
DECLARE
  ex_correo_invalido EXCEPTION;
  ex_telefono_invalido EXCEPTION;
  ex_celular_invalido EXCEPTION;
BEGIN
    SELECT SEQ_ID_LABORATORIO.NEXTVAL INTO :NEW.ID_LABORATORIO FROM dual;

  IF :NEW.CORREO IS NULL OR
     NOT REGEXP_LIKE(:NEW.CORREO, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
    RAISE ex_correo_invalido;
  END IF;

  IF :NEW.TELEFONO IS NOT NULL THEN
    IF LENGTH(:NEW.TELEFONO) > 0 THEN
      IF LENGTH(:NEW.TELEFONO) <> 10 OR
         SUBSTR(:NEW.TELEFONO, 1, 2) <> '60' OR
         NOT REGEXP_LIKE(:NEW.TELEFONO, '^[0-9]+$') THEN
        RAISE ex_telefono_invalido;
      END IF;
    END IF;
  END IF;
  
  IF :NEW.CELULAR IS NOT NULL THEN
    IF LENGTH(:NEW.CELULAR) <> 10 OR
       SUBSTR(:NEW.CELULAR, 1, 1) <> '3' OR
       NOT REGEXP_LIKE(:NEW.CELULAR, '^[0-9]+$') THEN
      RAISE ex_celular_invalido;
    END IF;
  END IF;

  EXCEPTION
    WHEN ex_correo_invalido THEN
      RAISE_APPLICATION_ERROR(-20015, 'El correo electrónico no es válido.');
    WHEN ex_telefono_invalido THEN
      RAISE_APPLICATION_ERROR(-20016, 'El número de teléfono no válido.');
    WHEN ex_celular_invalido THEN
      RAISE_APPLICATION_ERROR(-20017, 'El número de celular no es válido.');
END;
/

---> Actualizar laboratorios

CREATE OR REPLACE TRIGGER trg_Validacion_Laboratorios
BEFORE UPDATE
ON LABORATORIOS
FOR EACH ROW
DECLARE

  ex_correo_invalido EXCEPTION;
  ex_telefono_invalido EXCEPTION;
  ex_celular_invalido EXCEPTION;
BEGIN
  
  IF :NEW.CORREO IS NULL OR
     NOT REGEXP_LIKE(:NEW.CORREO, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
    RAISE ex_correo_invalido;
  END IF;

  IF :NEW.TELEFONO IS NOT NULL THEN
    IF LENGTH(:NEW.TELEFONO) > 0 THEN
      IF LENGTH(:NEW.TELEFONO) <> 10 OR
         SUBSTR(:NEW.TELEFONO, 1, 2) <> '60' OR
         NOT REGEXP_LIKE(:NEW.TELEFONO, '^[0-9]+$') THEN
        RAISE ex_telefono_invalido;
      END IF;
    END IF;
  END IF;
  
  IF :NEW.CELULAR IS NOT NULL THEN
    IF LENGTH(:NEW.CELULAR) <> 10 OR
       SUBSTR(:NEW.CELULAR, 1, 1) <> '3' OR
       NOT REGEXP_LIKE(:NEW.CELULAR, '^[0-9]+$') THEN
      RAISE ex_celular_invalido;
    END IF;
  END IF;

  EXCEPTION
    WHEN ex_correo_invalido THEN
      RAISE_APPLICATION_ERROR(-20015, 'El correo electrónico no es válido.');
    WHEN ex_telefono_invalido THEN
      RAISE_APPLICATION_ERROR(-20016, 'El número de teléfono no válido.');
    WHEN ex_celular_invalido THEN
      RAISE_APPLICATION_ERROR(-20017, 'El número de celular no es válido.');
END;
/

---> Eliminar laboratorios

CREATE OR REPLACE TRIGGER trg_Validacion_Eliminacion_Laboratorios
BEFORE DELETE
ON LABORATORIOS
FOR EACH ROW
DECLARE
 
  v_num_productos NUMBER;
  
  ex_laboratorio_presente EXCEPTION;
BEGIN
  -- Contar el número de productos del laboratorio actual en la tabla productos
  SELECT COUNT(*)
  INTO v_num_productos
  FROM PRODUCTOS
  WHERE ID_LABORATORIOS = :OLD.ID_LABORATORIO;

  -- Si hay productos del laboratorio en la tabla productos
  IF v_num_productos > 0 THEN
    RAISE ex_laboratorio_presente;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Hay ' || v_num_productos || ' productos del laboratorio ' || :OLD.NOMBRE_LABORATORIO || ' en la tabla productos.');
  END IF;

  EXCEPTION
    WHEN ex_laboratorio_presente THEN
      RAISE_APPLICATION_ERROR(-20018, 'No se puede eliminar el laboratorio porque está presente en la tabla productos.');
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  TRANSPORTISTAS
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_ID_TRANSPORTISTA;
CREATE SEQUENCE seq_ID_TRANSPORTISTA
START WITH 1
INCREMENT BY 1;


CREATE OR REPLACE TRIGGER trg_Validacion_Transportistas
BEFORE INSERT OR UPDATE ON TRANSPORTISTAS
FOR EACH ROW
DECLARE

  ex_correo_invalido EXCEPTION;

  ex_celular_invalido EXCEPTION;
  

  ex_telefono_invalido EXCEPTION;
BEGIN

  
  SELECT seq_ID_TRANSPORTISTA.NEXTVAL INTO :NEW.ID_TRANSPORTISTA FROM dual;



  IF :NEW.CORREO IS NULL OR
     NOT REGEXP_LIKE(:NEW.CORREO, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
    RAISE ex_correo_invalido;
  END IF;

  IF :NEW.CELULAR IS NULL OR
     LENGTH(:NEW.CELULAR) <> 10 OR
     NOT REGEXP_LIKE(:NEW.CELULAR, '^[0-9]+$') THEN
    RAISE ex_celular_invalido;
  END IF;
  
  IF :NEW.TELEFONO IS NOT NULL THEN
    IF LENGTH(:NEW.TELEFONO) > 0 THEN
      IF LENGTH(:NEW.TELEFONO) <> 10 OR
         NOT REGEXP_LIKE(:NEW.TELEFONO, '^[0-9]+$') THEN
        RAISE ex_telefono_invalido;
      END IF;
    END IF;
  END IF;


  EXCEPTION
    WHEN ex_correo_invalido THEN
      RAISE_APPLICATION_ERROR(-20020, 'El correo electrónico no es válido.');
    WHEN ex_celular_invalido THEN
      RAISE_APPLICATION_ERROR(-20021, 'El número de celular no es válido.');
    WHEN ex_telefono_invalido THEN
      RAISE_APPLICATION_ERROR(-20022, 'El número de teléfono no válido.');
END;
/

----> Actualizar Transportistas

CREATE OR REPLACE TRIGGER trg_Validacion_Transportistas
BEFORE UPDATE ON TRANSPORTISTAS
FOR EACH ROW
DECLARE
  ex_correo_invalido EXCEPTION;
  ex_celular_invalido EXCEPTION;
  ex_telefono_invalido EXCEPTION;
BEGIN

  IF :NEW.CORREO IS NULL OR
     NOT REGEXP_LIKE(:NEW.CORREO, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
    RAISE ex_correo_invalido;
  END IF;

  IF :NEW.CELULAR IS NULL OR
     LENGTH(:NEW.CELULAR) <> 10 OR
     NOT REGEXP_LIKE(:NEW.CELULAR, '^[0-9]+$') THEN
    RAISE ex_celular_invalido;
  END IF;
  
  IF :NEW.TELEFONO IS NOT NULL THEN
    IF LENGTH(:NEW.TELEFONO) > 0 THEN
      IF LENGTH(:NEW.TELEFONO) <> 10 OR
         NOT REGEXP_LIKE(:NEW.TELEFONO, '^[0-9]+$') THEN
        RAISE ex_telefono_invalido;
      END IF;
    END IF;
  END IF;


  EXCEPTION
    WHEN ex_correo_invalido THEN
      RAISE_APPLICATION_ERROR(-20020, 'El correo electrónico no es válido.');
    WHEN ex_celular_invalido THEN
      RAISE_APPLICATION_ERROR(-20021, 'El número de celular no es válido.');
    WHEN ex_telefono_invalido THEN
      RAISE_APPLICATION_ERROR(-20022, 'El número de teléfono no válido.');
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  PRODUCTOS
prompt +-------------------------------------------------------------+

DROP SEQUENCE seq_id_producto;
CREATE SEQUENCE seq_id_producto START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE TRIGGER trg_validacion_productos_insert
BEFORE INSERT ON PRODUCTOS
FOR EACH ROW
DECLARE
  ex_laboratorio_inactivo EXCEPTION;
  v_estado_laboratorio INTEGER;
  v_cantidad_actual INTEGER;
BEGIN
  :NEW.ID_PRODUCTO := seq_id_producto.NEXTVAL;
  SELECT ESTADO_LABORATORIO INTO v_estado_laboratorio
  FROM LABORATORIOS
  WHERE ID_LABORATORIO = :NEW.ID_LABORATORIOS;

  IF v_estado_laboratorio != 1 THEN
    RAISE ex_laboratorio_inactivo;
  END IF;
  :NEW.CANTIDAD_ACTUAL :=0;
  :NEW.FECHA_ACTUALIZACION := SYSDATE;
  

  -- Avisar por consola si hay más productos de los del stock máximo
  IF :NEW.CANTIDAD_ACTUAL > :NEW.STOCK_MAXIMO THEN
    DBMS_OUTPUT.PUT_LINE('ADVERTENCIA: Exceso de stock máximo para el producto ' || :NEW.NOMBRE_PRODUCTO);
  END IF;

  -- Avisar por consola si hay poca cantidad de productos
  IF :NEW.CANTIDAD_ACTUAL < :NEW.STOCK_MINIMO THEN
    DBMS_OUTPUT.PUT_LINE('ADVERTENCIA: Poca cantidad de productos para el producto ' || :NEW.NOMBRE_PRODUCTO);
  END IF;

  EXCEPTION
    WHEN ex_laboratorio_inactivo THEN
      RAISE_APPLICATION_ERROR(-20023, 'No se puede agregar el producto porque el laboratorio asociado está desactivado.');
END;
/

----> actualizar


CREATE OR REPLACE TRIGGER trg_validacion_productos_update
BEFORE UPDATE ON PRODUCTOS
FOR EACH ROW
DECLARE
  ex_laboratorio_inactivo EXCEPTION;

  v_estado_laboratorio INTEGER;

  v_cantidad_actual INTEGER;
BEGIN
  SELECT ESTADO_LABORATORIO INTO v_estado_laboratorio
  FROM LABORATORIOS
  WHERE ID_LABORATORIO = :NEW.ID_LABORATORIOS;

  IF v_estado_laboratorio != 1 THEN
    RAISE ex_laboratorio_inactivo;
  END IF;

  :NEW.FECHA_ACTUALIZACION := SYSDATE;

  IF :NEW.CANTIDAD_ACTUAL > :NEW.STOCK_MAXIMO THEN
    DBMS_OUTPUT.PUT_LINE('ADVERTENCIA: Exceso de stock máximo para el producto ' || :NEW.NOMBRE_PRODUCTO);
  END IF;

  IF :NEW.CANTIDAD_ACTUAL < :NEW.STOCK_MINIMO THEN
    DBMS_OUTPUT.PUT_LINE('ADVERTENCIA: Poca cantidad de productos para el producto ' || :NEW.NOMBRE_PRODUCTO);
  END IF;

  EXCEPTION
    WHEN ex_laboratorio_inactivo THEN
      RAISE_APPLICATION_ERROR(-20023, 'No se puede agregar el producto porque el laboratorio asociado está desactivado.');
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  LOTES_PRODUCTOS
prompt +-------------------------------------------------------------+

Drop SEQUENCE seq_id_lote;
CREATE SEQUENCE seq_id_lote START WITH 1 INCREMENT BY 1;

-- Crear el trigger para la tabla LOTES_PRODUCTOS
CREATE OR REPLACE TRIGGER trg_validacion_lotes_productos
BEFORE INSERT ON LOTES_PRODUCTOS
FOR EACH ROW
DECLARE
  ex_cantidad_invalida EXCEPTION;
  ex_fecha_vencimiento_invalida EXCEPTION;
BEGIN
  SELECT seq_id_lote.NEXTVAL INTO :NEW.ID_LOTE FROM dual;
  -- Verificar si la cantidad es negativa o menor o igual a cero
  IF :NEW.CANTIDAD <= 0 THEN
    RAISE ex_cantidad_invalida;
  END IF;

  -- Verificar si la fecha de vencimiento es menor que el día actual + 1 día
  IF :NEW.FECHA_VENCIMIENTO <= SYSDATE + 1 THEN
    RAISE ex_fecha_vencimiento_invalida;
  END IF;

  EXCEPTION
    WHEN ex_cantidad_invalida THEN
      RAISE_APPLICATION_ERROR(-20001, 'La cantidad en el lote no puede ser negativa o igual a cero.');
    WHEN ex_fecha_vencimiento_invalida THEN
      RAISE_APPLICATION_ERROR(-20002, 'La fecha de vencimiento debe ser al menos un día después del día actual.');
END;
/

----> Insertar after

CREATE OR REPLACE TRIGGER actualizar_cantidad_producto
AFTER INSERT ON LOTES_PRODUCTOS
FOR EACH ROW
DECLARE
    v_producto_existente NUMBER;
BEGIN
    -- Verificar si el producto existe en la tabla PRODUCTOS
    SELECT COUNT(*) INTO v_producto_existente
    FROM PRODUCTOS
    WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO;

    -- Si el producto existe, actualizar la cantidad actual
    IF v_producto_existente > 0 THEN
        UPDATE PRODUCTOS
        SET CANTIDAD_ACTUAL = CANTIDAD_ACTUAL + :NEW.CANTIDAD
        WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO;
        
        DBMS_OUTPUT.PUT_LINE('Cantidad actualizada para el producto ' || :NEW.ID_PRODUCTO || ' por ' || :NEW.CANTIDAD);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El producto ' || :NEW.ID_PRODUCTO || ' no existe en la tabla PRODUCTOS');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_actualizar_cantidad_producto
BEFORE UPDATE OF CANTIDAD ON LOTES_PRODUCTOS
FOR EACH ROW
DECLARE
    v_diferencia_cantidad NUMBER;
    v_dias_para_vencer NUMBER;
    ex_cantidad_invalida EXCEPTION;
BEGIN
    -- Calcular la diferencia entre la cantidad anterior y la nueva en el lote
    v_diferencia_cantidad := :NEW.CANTIDAD - :OLD.CANTIDAD;

    -- Verificar si la nueva cantidad es negativa o si se intenta quitar más de la cantidad existente
    IF v_diferencia_cantidad < 0 OR (:OLD.CANTIDAD + v_diferencia_cantidad) < 0 THEN
        -- Si es negativa o se intenta quitar más de la cantidad existente, lanzar una excepción
        RAISE ex_cantidad_invalida;
    END IF;

    -- Actualizar la cantidad actual en la tabla PRODUCTOS solo si no hay excepciones
    BEGIN
        UPDATE PRODUCTOS
        SET CANTIDAD_ACTUAL = CANTIDAD_ACTUAL + v_diferencia_cantidad
        WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO;

        -- Calcular la cantidad de días para que el lote se venza
        v_dias_para_vencer := ROUND(TO_DATE(:NEW.FECHA_VENCIMIENTO) - SYSDATE);

        -- Verificar si el lote ya ha vencido
        IF TO_DATE(:NEW.FECHA_VENCIMIENTO) < SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('El lote ha vencido.');
        ELSE
            -- Imprimir la cantidad de días para vencer si el lote aún no ha vencido
            DBMS_OUTPUT.PUT_LINE('Días para vencer: ' || v_dias_para_vencer);
        END IF;
    EXCEPTION
        WHEN ex_cantidad_invalida THEN
            DBMS_OUTPUT.PUT_LINE('No se puede ingresar una cantidad negativa o quitar más de la cantidad existente.');
            :NEW.CANTIDAD := 0; -- Establecer la nueva cantidad en cero
    END;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20025, 'Error durante la actualización de la cantidad del lote: ' || SQLERRM);
END;
/


---> eliminar 

CREATE OR REPLACE TRIGGER trg_eliminar_cantidad_lotes
AFTER DELETE ON LOTES_PRODUCTOS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET CANTIDAD_ACTUAL = CANTIDAD_ACTUAL - :OLD.CANTIDAD
    WHERE ID_PRODUCTO = :OLD.ID_PRODUCTO;
END;
/



prompt +-------------------------------------------------------------+
prompt |       Triggers de la  Tabla  MOVIMIENTOS_INVENTARIO ⏰
prompt +-------------------------------------------------------------+

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  IMAGENES_PRODUCTOS
prompt +-------------------------------------------------------------+

Drop SEQUENCE SEQ_ID_IMG_PRODUCTO;
CREATE SEQUENCE SEQ_ID_IMG_PRODUCTO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_INSERT_ID_IMG_PRODUCTO
BEFORE INSERT ON IMAGENES_PRODUCTOS
FOR EACH ROW
BEGIN
    SELECT SEQ_ID_IMG_PRODUCTO.NEXTVAL INTO :NEW.ID_IMAGEN FROM DUAL;
END;
/


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  PEDIDOS
prompt +-------------------------------------------------------------+

Drop SEQUENCE seq_id_pedidos;
CREATE SEQUENCE seq_id_pedidos START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE OR REPLACE TRIGGER trg_insertar_pedido
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    v_fecha_actual DATE := TRUNC(SYSDATE);
    v_fecha_entrega DATE;
    v_ciudad_usuario INTEGER;
    v_ciudad_medellin INTEGER;
    
    -- Variables de excepción
    ex_pedido_sin_fecha_creacion EXCEPTION;
    ex_pedido_historico_entregado EXCEPTION;
    ex_pedido_historico_pendiente EXCEPTION;
    ex_pedido_historico_sin_fecha_entrega EXCEPTION;
    ex_prioridad_vacia EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando inserción de pedido...');
    
    SELECT seq_id_pedidos.NEXTVAL INTO :NEW.ID_PEDIDOS FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('ID_PEDIDOS generado: ' || :NEW.ID_PEDIDOS);
    
    :NEW.TOTAL :=  0;
    IF :NEW.DESCUENTO IS NULL THEN
        :NEW.DESCUENTO := 0;
    END IF;
    
    IF :NEW.PRIORIDAD IS NULL THEN

        :NEW.PRIORIDAD := 4;
        DBMS_OUTPUT.PUT_LINE('No se puede tener una prioridad vacía. Se asigna por defecto: 4 (Bajo)');
    END IF;
    
    -- Verificar si es un pedido histórico
    IF :NEW.FECHA_CREACION IS NULL OR :NEW.FECHA_CREACION < v_fecha_actual THEN
        IF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA IS NULL THEN
            RAISE ex_pedido_sin_fecha_creacion;
        ELSIF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA < v_fecha_actual THEN
            :NEW.SEGUIMIENTO := NVL(:NEW.SEGUIMIENTO, 9); -- Cambia SEGUIMIENTO a 9 si es NULL
            NULL; 
            DBMS_OUTPUT.PUT_LINE('Pedido histórico completado y guardado.');
        ELSIF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA >= v_fecha_actual THEN
            RAISE ex_pedido_historico_pendiente;
        ELSIF :NEW.FECHA_CREACION < v_fecha_actual AND :NEW.FECHA_ENTREGA < v_fecha_actual THEN
            IF :NEW.SEGUIMIENTO NOT IN (9,8,7,6) THEN
                -- Si SEGUIMIENTO no es válido, asignar SEGUIMIENTO a 9 (Completado)
                :NEW.SEGUIMIENTO := 9;
                NULL;
            ELSE
                NULL;
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No se pudo determinar el tipo de pedido.');
        END IF;
    ELSIF :NEW.FECHA_CREACION >= v_fecha_actual THEN
        -- Si es un pedido nuevo
        -- Verificar si la dirección del usuario no está en Medellín
        SELECT COUNT(*) INTO v_ciudad_usuario
        FROM DIRECCIONES D
        WHERE D.ID_DIRECCION = :NEW.ID_DIRECCION
        AND D.CIUDAD != 1; -- No Medellín

        IF v_ciudad_usuario > 0 THEN
            -- Calcular la fecha de entrega en 5 días
            v_fecha_entrega := v_fecha_actual + CASE 
                                                  WHEN TO_CHAR(v_fecha_actual, 'HH24:MI') < '12:00' THEN 5 -- Entrega en 5 días si es antes del mediodía
                                                  ELSE 6 -- Entrega en 6 días si es después del mediodía
                                              END;
            DBMS_OUTPUT.PUT_LINE('Entrega dentro de 5 días para otra ciudad.');
        ELSE
            -- Si la dirección del usuario está en Medellín
            -- Verificar la hora de creación del pedido
            IF TO_CHAR(:NEW.FECHA_CREACION, 'HH24:MI') < '12:00' THEN
                -- Si la hora de creación es antes del mediodía, la entrega será hoy
                v_fecha_entrega := TRUNC(v_fecha_actual); -- Entrega el mismo día
                DBMS_OUTPUT.PUT_LINE('Entrega para hoy en Medellín.');
            ELSE
                -- Si la hora de creación es después del mediodía, la entrega será mañana
                v_fecha_entrega := TRUNC(v_fecha_actual) + INTERVAL '1' DAY; -- Entrega al día siguiente
                DBMS_OUTPUT.PUT_LINE('Entrega para mañana en Medellín.');
            END IF;
        END IF;  
        
        -- Verificar si la fecha de entrega es un sábado después del mediodía
        IF TO_CHAR(v_fecha_entrega, 'D') = 7 AND TO_CHAR(v_fecha_entrega, 'HH24:MI') >= '12:00' THEN
            -- Si es sábado después del mediodía, establecer la fecha de entrega para el lunes
            v_fecha_entrega := v_fecha_entrega + 2;
            DBMS_OUTPUT.PUT_LINE('Comuníquese con el encargado para coordinar la entrega.');
        END IF;
        
        -- Asignar la fecha de entrega calculada al pedido
        :NEW.FECHA_ENTREGA := v_fecha_entrega;
    ELSE
        -- Si ninguna de las condiciones anteriores se cumple, lanzar una excepción
        RAISE_APPLICATION_ERROR(-20003, 'No se pudo determinar el tipo de pedido.');
    END IF;
    
EXCEPTION
    WHEN ex_pedido_sin_fecha_creacion THEN
        DBMS_OUTPUT.PUT_LINE('No se puede crear un registro de pedido sin fecha de creación ni fecha de entrega. Por favor, contacte con el programador.');
    WHEN ex_pedido_historico_entregado THEN
        DBMS_OUTPUT.PUT_LINE('Pedido histórico completado y guardado.');
    WHEN ex_pedido_historico_pendiente THEN
        DBMS_OUTPUT.PUT_LINE('Pedido histórico pendiente. Por favor, agéndelo.');
    WHEN ex_prioridad_vacia THEN
        :NEW.PRIORIDAD := 4;
        DBMS_OUTPUT.PUT_LINE('No se puede tener una prioridad vacía. Se asigna por defecto: 4 (Bajo)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error con código: ' || SQLCODE || '. Mensaje de error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Por favor, contacte con el programador.');
END;
/



prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  
prompt +-------------------------------------------------------------+


prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  
prompt +-------------------------------------------------------------+

---------------------------------------------------------------------------------------------------------------------------------------------Las was de camila---------------




