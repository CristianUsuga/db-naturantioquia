CREATE OR REPLACE PACKAGE paquete_validaciones AS
    FUNCTION validar_numero_documento(p_documento IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_nombre_usuario(p_nombre_usuario IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_primer_apellido(p_primer_apellido IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_segundo_apellido(p_segundo_apellido IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_correo_electronico(p_correo IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_contrasena(p_contrasena IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_fecha_nacimiento(p_fecha_nacimiento IN DATE) RETURN BOOLEAN;
    FUNCTION validar_celular(p_celular IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_telefono(p_telefono IN VARCHAR2) RETURN BOOLEAN;
END paquete_validaciones;
/

CREATE OR REPLACE PACKAGE BODY paquete_validaciones AS
  FUNCTION validar_numero_documento(p_documento IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF LENGTH(p_documento) < 7 OR LENGTH(p_documento) > 10 OR NOT REGEXP_LIKE(p_documento, '^[0-9]+$') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_numero_documento;
  
  FUNCTION validar_nombre_usuario(p_nombre_usuario IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_nombre_usuario IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_nombre_usuario;
  
  FUNCTION validar_primer_apellido(p_primer_apellido IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_primer_apellido IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_primer_apellido;
  
  FUNCTION validar_segundo_apellido(p_segundo_apellido IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_segundo_apellido IS NOT NULL THEN
      IF LENGTH(p_segundo_apellido) > 40 OR NOT REGEXP_LIKE(p_segundo_apellido, '^[a-zA-Z ]+$') THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_segundo_apellido;
  
  FUNCTION validar_correo_electronico(p_correo IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_correo IS NULL OR NOT REGEXP_LIKE(p_correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_correo_electronico;
  
  FUNCTION validar_contrasena(p_contrasena IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF LENGTH(p_contrasena) <= 8 OR NOT REGEXP_LIKE(p_contrasena, '.*[A-Z]+.*[0-9]+.*') THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END validar_contrasena;
  
  FUNCTION validar_fecha_nacimiento(p_fecha_nacimiento IN DATE) RETURN BOOLEAN IS
  BEGIN
    IF p_fecha_nacimiento IS NOT NULL THEN
      IF (p_fecha_nacimiento < (SYSDATE - 160*365) OR p_fecha_nacimiento > (SYSDATE - 14*365)) THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_fecha_nacimiento;
  
  FUNCTION validar_celular(p_celular IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_celular IS NOT NULL THEN
      IF LENGTH(p_celular) <> 10 OR SUBSTR(p_celular, 1, 1) <> '3' OR NOT REGEXP_LIKE(p_celular, '^[0-9]+$') THEN
        RETURN FALSE;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_celular;
  
  FUNCTION validar_telefono(p_telefono IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    IF p_telefono IS NOT NULL THEN
      IF LENGTH(p_telefono) > 0 THEN
        IF LENGTH(p_telefono) <> 10 OR SUBSTR(p_telefono, 1, 2) <> '60' OR NOT REGEXP_LIKE(p_telefono, '^[0-9]+$') THEN
          RETURN FALSE;
        END IF;
      END IF;
    END IF;
    RETURN TRUE;
  END validar_telefono;
END paquete_validaciones;
/


---paquete_pedidos
CREATE OR REPLACE PACKAGE paquete_pedidos AS
  PROCEDURE imprimir_pedidos_prioritarios;
  PROCEDURE imprimir_pedidos_prioritarios_fecha_actual;
  PROCEDURE imprimir_pedidos_por_estado(p_estado_id IN NUMBER);
END paquete_pedidos;
/

CREATE OR REPLACE PACKAGE BODY paquete_pedidos AS
  PROCEDURE imprimir_pedidos_prioritarios AS
  BEGIN
    FOR pedido IN (
      SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL, PR.NOMBRE_PRIORIDADES
      FROM PEDIDOS P
      INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.ID_PRIORIDAD
      ORDER BY P.PRIORIDAD DESC
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                           ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                           ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                           ', Descuento: ' || pedido.DESCUENTO ||
                           ', Total: ' || pedido.TOTAL ||
                           ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES);
    END LOOP;
  END imprimir_pedidos_prioritarios;

  PROCEDURE imprimir_pedidos_prioritarios_fecha_actual AS
  BEGIN
    FOR pedido IN (
      SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL, PR.NOMBRE_PRIORIDADES
      FROM PEDIDOS P
      INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.ID_PRIORIDAD
      WHERE TRUNC(P.FECHA_CREACION) = TRUNC(SYSDATE)
      ORDER BY P.PRIORIDAD DESC
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                           ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                           ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                           ', Descuento: ' || pedido.DESCUENTO ||
                           ', Total: ' || pedido.TOTAL ||
                           ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES);
    END LOOP;
  END imprimir_pedidos_prioritarios_fecha_actual;

  PROCEDURE imprimir_pedidos_por_estado(p_estado_id IN NUMBER) AS
  BEGIN
    FOR pedido IN (
      SELECT P.ID_PEDIDOS, P.FECHA_CREACION, P.FECHA_ENTREGA, P.DESCUENTO, P.TOTAL, PR.NOMBRE_PRIORIDADES, S.NOMBRE_SEGUIMIENTO
      FROM PEDIDOS P
      INNER JOIN PRIORIDADES PR ON P.PRIORIDAD = PR.ID_PRIORIDAD
      INNER JOIN SEGUIMIENTOS S ON P.SEGUIMIENTO = S.ID_SEGUIMIENTO
      WHERE P.SEGUIMIENTO = p_estado_id
      ORDER BY P.FECHA_CREACION DESC
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('ID Pedido: ' || pedido.ID_PEDIDOS ||
                           ', Fecha Creación: ' || pedido.FECHA_CREACION ||
                           ', Fecha Entrega: ' || pedido.FECHA_ENTREGA ||
                           ', Descuento: ' || pedido.DESCUENTO ||
                           ', Total: ' || pedido.TOTAL ||
                           ', Prioridad: ' || pedido.NOMBRE_PRIORIDADES ||
                           ', Estado: ' || pedido.NOMBRE_SEGUIMIENTO);
    END LOOP;
  END imprimir_pedidos_por_estado;
END paquete_pedidos;
/



----paquete_productos

CREATE OR REPLACE PACKAGE paquete_productos AS
  PROCEDURE actualizar_cantidad_actual_producto;
  PROCEDURE cantidad_productos_a_vencer (
    p_id_producto IN INTEGER,
    p_fecha_actual IN DATE
  );
  PROCEDURE eliminar_cantidad_lote_y_actualizar_producto (
    p_id_lote IN INTEGER,
    p_cantidad_eliminar IN INTEGER
  );
END paquete_productos;
/

CREATE OR REPLACE PACKAGE BODY paquete_productos AS
  PROCEDURE actualizar_cantidad_actual_producto AS
  BEGIN
    FOR producto_rec IN (SELECT p.ID_PRODUCTO, SUM(lp.CANTIDAD) AS TOTAL_CANTIDAD
                         FROM PRODUCTOS p
                         LEFT JOIN LOTES_PRODUCTOS lp ON p.ID_PRODUCTO = lp.ID_PRODUCTO
                         GROUP BY p.ID_PRODUCTO)
    LOOP
      UPDATE PRODUCTOS
      SET CANTIDAD_ACTUAL = producto_rec.TOTAL_CANTIDAD
      WHERE ID_PRODUCTO = producto_rec.ID_PRODUCTO;
    END LOOP;
    COMMIT;
  END actualizar_cantidad_actual_producto;

  PROCEDURE cantidad_productos_a_vencer (
      p_id_producto IN INTEGER,
      p_fecha_actual IN DATE
  ) AS
    v_cantidad_a_vencer INTEGER := 0;
  BEGIN
    SELECT SUM(lp.CANTIDAD)
    INTO v_cantidad_a_vencer
    FROM LOTES_PRODUCTOS lp
    WHERE lp.ID_PRODUCTO = p_id_producto
    AND lp.FECHA_VENCIMIENTO <= p_fecha_actual;

    DBMS_OUTPUT.PUT_LINE('La cantidad de productos a vencer para el producto con ID ' || p_id_producto ||
                         ' es: ' || v_cantidad_a_vencer);
  END cantidad_productos_a_vencer;

  PROCEDURE eliminar_cantidad_lote_y_actualizar_producto (
      p_id_lote IN INTEGER,
      p_cantidad_eliminar IN INTEGER
  ) AS
    v_id_producto LOTES_PRODUCTOS.ID_PRODUCTO%TYPE;
    v_cantidad_actual_producto PRODUCTOS.CANTIDAD_ACTUAL%TYPE;
  BEGIN
    -- Obtener el ID_PRODUCTO y CANTIDAD de lote
    SELECT ID_PRODUCTO, CANTIDAD
    INTO v_id_producto, p_cantidad_eliminar
    FROM LOTES_PRODUCTOS
    WHERE ID_LOTE = p_id_lote;

    -- Obtener la cantidad actual del producto
    SELECT CANTIDAD_ACTUAL
    INTO v_cantidad_actual_producto
    FROM PRODUCTOS
    WHERE ID_PRODUCTO = v_id


