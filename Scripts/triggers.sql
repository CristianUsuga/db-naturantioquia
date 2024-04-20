prompt +----------------------------------+
prompt |      Creación de Triggers       |
prompt |       en la Base de Datos        |
prompt |          naturantioquia          |
prompt +----------------------------------+

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla roles           
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_rol START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_asignar_id_rol
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
    IF :new.id_rol IS NULL THEN
        SELECT secuencia_id_rol.NEXTVAL INTO :new.id_rol FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  DEPARTAMENTOS          
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_departamento START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_asignar_id_departamento
BEFORE INSERT ON DEPARTAMENTOS
FOR EACH ROW
BEGIN
    IF :new.id_departamento IS NULL THEN
        SELECT secuencia_id_departamento.NEXTVAL INTO :new.id_departamento FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CIUDADES          
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_ciudad START WITH 1 INCREMENT BY 1;


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

CREATE SEQUENCE secuencia_id_barrio START WITH 1 INCREMENT BY 1;

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

CREATE SEQUENCE secuencia_id_direccion START WITH 1 INCREMENT BY 1;

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

CREATE SEQUENCE secuencia_id_formulario START WITH 1 INCREMENT BY 1;

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

CREATE OR REPLACE TRIGGER trg_Validacion_Borrado_Formularios
BEFORE DELETE
ON Formularios
FOR EACH ROW
DECLARE
    v_cantidad_hijos NUMBER;
    -- Excepciones
    ex_modulo_con_hijos EXCEPTION;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad_hijos
    FROM Formularios
    WHERE ID_PADRE = :old.ID_FORMULARIO;

    IF v_cantidad_hijos > 0 AND :old.MODULO = 1 THEN
        RAISE ex_modulo_con_hijos;
    END IF;
    IF :old.NODO_PRINCIPAL = 1 THEN
        DBMS_OUTPUT.PUT_LINE('El formulario que se está eliminando es un nodo principal.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El formulario que se está eliminando es solo un módulo.');
    END IF;

    EXCEPTION
        WHEN ex_modulo_con_hijos THEN
        RAISE_APPLICATION_ERROR(-20005, 'No se puede eliminar un módulo que tiene hijos');
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   FORMULARIOS         
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_perfil START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_perfil
BEFORE INSERT ON PERFILES
FOR EACH ROW
BEGIN
    IF :NEW.ID_PERFIL IS NULL THEN
        SELECT secuencia_id_perfil.NEXTVAL INTO :NEW.ID_PERFIL FROM dual;
    END IF;
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


CREATE SEQUENCE secuencia_id_seguimiento START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_seguimiento
BEFORE INSERT ON SEGUIMIENTOS
FOR EACH ROW
BEGIN
    IF :NEW.ID_SEGUIMIENTO IS NULL THEN
        SELECT secuencia_id_seguimiento.NEXTVAL INTO :NEW.ID_SEGUIMIENTO FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla PRIORIDADES           
prompt +-------------------------------------------------------------+


CREATE SEQUENCE secuencia_id_prioridad START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_prioridad
BEFORE INSERT ON PRIORIDADES
FOR EACH ROW
BEGIN
    IF :NEW.ID_PRIORIDAD IS NULL THEN
        SELECT secuencia_id_prioridad.NEXTVAL INTO :NEW.ID_PRIORIDAD FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ID_TIPO_TRANSPORTISTA    
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_tipo_transportista START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_transportista
BEFORE INSERT ON TIPO_TRANSPORTISTA
FOR EACH ROW
BEGIN
    IF :NEW.ID_TIPO_TRANSPORTISTA IS NULL THEN
        SELECT secuencia_id_tipo_transportista.NEXTVAL INTO :NEW.ID_TIPO_TRANSPORTISTA FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla ESTADOS_LABORATORIOS    
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_estado_lab START WITH 1 INCREMENT BY 1 NOCACHE;


CREATE OR REPLACE TRIGGER trg_insert_estado_lab
BEFORE INSERT ON ESTADOS_LABORATORIOS
FOR EACH ROW
BEGIN
    IF :NEW.ID_ESTADO_LAB IS NULL THEN
        SELECT secuencia_id_estado_lab.NEXTVAL INTO :NEW.ID_ESTADO_LAB FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla TIPOS_MOVIMIENTOS    
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_t_movimiento START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_t_movimiento
BEFORE INSERT ON TIPOS_MOVIMIENTOS
FOR EACH ROW
BEGIN
    IF :NEW.ID_T_MOVIMIENTO IS NULL THEN
        SELECT secuencia_id_t_movimiento.NEXTVAL INTO :NEW.ID_T_MOVIMIENTO FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  TIPO_DESCUENTO   
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_tipo_desc START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_desc
BEFORE INSERT ON TIPO_DESCUENTO
FOR EACH ROW
BEGIN
    IF :NEW.ID_TIPO_DESC IS NULL THEN
        SELECT secuencia_id_tipo_desc.NEXTVAL INTO :NEW.ID_TIPO_DESC FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla   TIPO_VALOR
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_tipo_valor START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_tipo_valor
BEFORE INSERT ON TIPO_VALOR
FOR EACH ROW
BEGIN
    IF :NEW.ID_TIPO_VALOR IS NULL THEN
        SELECT secuencia_id_tipo_valor.NEXTVAL INTO :NEW.ID_TIPO_VALOR FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  CATEGORIAS
prompt +-------------------------------------------------------------+

CREATE SEQUENCE secuencia_id_categoria START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE OR REPLACE TRIGGER trg_insert_categoria
BEFORE INSERT ON CATEGORIAS
FOR EACH ROW
BEGIN
    IF :NEW.ID_CATEGORIA IS NULL THEN
        SELECT secuencia_id_categoria.NEXTVAL INTO :NEW.ID_CATEGORIA FROM dual;
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  LABORATORIOS
prompt +-------------------------------------------------------------+

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
  IF :NEW.ID_LABORATORIO IS NULL THEN
    SELECT SEQ_ID_LABORATORIO.NEXTVAL INTO :NEW.ID_LABORATORIO FROM dual;
  END IF;

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

  IF :NEW.ID_TRANSPORTISTA IS NULL THEN
    SELECT seq_ID_TRANSPORTISTA.NEXTVAL INTO :NEW.ID_TRANSPORTISTA FROM dual;
  END IF;


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

-- Crear la secuencia para ID_PRODUCTO
CREATE SEQUENCE seq_id_producto START WITH 1 INCREMENT BY 1;

-- Crear el trigger para la tabla PRODUCTOS
CREATE OR REPLACE TRIGGER trg_validacion_productos
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
DECLARE
  -- Variables de excepción
  ex_laboratorio_inactivo EXCEPTION;

  -- Variable para almacenar el estado del laboratorio
  v_estado_laboratorio INTEGER;

  -- Variables para control de stock
  v_cantidad_actual INTEGER;
BEGIN
  -- Obtener el estado del laboratorio relacionado con el producto
  SELECT ESTADO_LABORATORIO INTO v_estado_laboratorio
  FROM LABORATORIOS
  WHERE ID_LABORATORIO = :NEW.ID_LABORATORIOS;

  -- Verificar si el laboratorio está activo
  IF v_estado_laboratorio != 1 THEN
    RAISE ex_laboratorio_inactivo;
  END IF;

  -- Asignar la fecha de creación y actualización automáticamente
  :NEW.FECHA_CREACION := SYSDATE;
  :NEW.FECHA_ACTUALIZACION := SYSDATE;

  -- Asignar el ID_PRODUCTO utilizando la secuencia
  :NEW.ID_PRODUCTO := seq_id_producto.NEXTVAL;

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

CREATE SEQUENCE seq_id_producto START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_validacion_productos
BEFORE INSERT OR UPDATE ON PRODUCTOS
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


--
CREATE OR REPLACE TRIGGER verificar_stock_minimo
AFTER INSERT OR UPDATE ON MOVIMIENTOS_INVENTARIO
FOR EACH ROW
DECLARE
    v_stock_actual INTEGER;
    v_stock_minimo INTEGER;
BEGIN

    SELECT cantidad_actual INTO v_stock_actual
    FROM PRODUCTOS
    WHERE id_producto = :NEW.id_producto;

    SELECT stock_minimo INTO v_stock_minimo
    FROM PRODUCTOS
    WHERE id_producto = :NEW.id_producto;

    IF v_stock_actual <= v_stock_minimo THEN
        DBMS_OUTPUT.PUT_LINE('¡Alerta! Se requiere realizar un pedido de reposición para el producto con ID: ' || :NEW.id_producto);

    END IF;
END;
/

--

CREATE OR REPLACE TRIGGER trg_cancelar_pedido
BEFORE UPDATE ON PEDIDOS
FOR EACH ROW
DECLARE
    v_cantidad_entregada NUMBER;
BEGIN

    IF :NEW.SEGUIMIENTO = 'Cancelado' AND :OLD.SEGUIMIENTO != 'Cancelado' THEN
    
        SELECT COUNT(*) INTO v_cantidad_entregada
        FROM DETALLE_PEDIDOS
        WHERE ID_PEDIDOS = :NEW.ID_PEDIDOS AND CANTIDAD_ENTREGADA > 0;


        IF v_cantidad_entregada = 0 THEN
            DBMS_OUTPUT.PUT_LINE('El pedido ha sido cancelado.');
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No se puede cancelar el pedido porque ya se han entregado unidades.');
        END IF;
    END IF;
END;
/

--

CREATE OR REPLACE TRIGGER actualizar_detalle_pedidos
BEFORE UPDATE ON DETALLE_PEDIDOS
FOR EACH ROW
DECLARE
    v_cantidad_solicitada NUMBER;
BEGIN

    SELECT CANTIDAD
    INTO v_cantidad_solicitada
    FROM DETALLE_PEDIDOS
    WHERE ID_PEDIDOS = :NEW.ID_PEDIDOS;

    IF :NEW.CANTIDAD_ENTREGADA > v_cantidad_solicitada THEN
        RAISE_APPLICATION_ERROR(-20002, 'La cantidad entregada no puede ser mayor que la cantidad solicitada.');
    END IF;

    IF :NEW.CANTIDAD_ENTREGADA IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'La cantidad entregada no puede ser NULL.');
    END IF;
    
    IF :NEW.CANTIDAD_ENTREGADA IS NOT NULL THEN
        IF :NEW.CANTIDAD_ENTREGADA = v_cantidad_solicitada THEN
            UPDATE PEDIDOS
            SET SEGUIMIENTO = 1, FECHA_ENTREGA = SYSDATE
            WHERE ID_PEDIDOS = :NEW.ID_PEDIDOS;
        END IF;
    END IF;

END;
/


