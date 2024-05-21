
--ELIMINAR PRODUCTO CUANDO TENEMOS PRODUCTOS.
CREATE OR REPLACE TRIGGER trg_evitar_eliminacion_producto
AFTER DELETE ON PRODUCTOS
FOR EACH ROW
DECLARE
  ex_cantidad_actual_mayor EXCEPTION;
  v_cantidad_actual PRODUCTOS.CANTIDAD_ACTUAL%TYPE;
BEGIN
  -- Obtener la cantidad actual del producto
  SELECT CANTIDAD_ACTUAL
  INTO v_cantidad_actual
  FROM PRODUCTOS
  WHERE ID_PRODUCTO = :OLD.ID_PRODUCTO;

  -- Verificar si la cantidad actual es mayor a 1
  IF v_cantidad_actual > 1 THEN
    RAISE ex_cantidad_actual_mayor;
  END IF;

  EXCEPTION
    WHEN ex_cantidad_actual_mayor THEN
      RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el producto porque la cantidad actual es mayor a 1.');
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Tabla  LOTES_PRODUCTOS fallidos
prompt +-------------------------------------------------------------+
---aaaaaaaaaa    llave encontrada, pero no funciona.
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
---old

---> Actualizar cantidad
CREATE OR REPLACE TRIGGER trg_actualizar_cantidad_producto
AFTER UPDATE OF CANTIDAD ON LOTES_PRODUCTOS
FOR EACH ROW
DECLARE
    v_diferencia_cantidad NUMBER;
    v_dias_para_vencer NUMBER;
    v_lotes_a_vencer NUMBER := 0;
BEGIN

    v_diferencia_cantidad := :NEW.CANTIDAD - :OLD.CANTIDAD;

    UPDATE PRODUCTOS
    SET CANTIDAD_ACTUAL = CANTIDAD_ACTUAL + v_diferencia_cantidad
    WHERE ID_PRODUCTO = :NEW.ID_PRODUCTO;

  --Notificación de vecha.
    v_dias_para_vencer := ROUND(TO_DATE(:NEW.FECHA_VENCIMIENTO) - SYSDATE);

    IF TO_DATE(:NEW.FECHA_VENCIMIENTO) < SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('El lote ha vencido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Días para vencer: ' || v_dias_para_vencer);
    END IF;
END;
/

prompt +-------------------------------------------------------------+
prompt |            Triggers de la  Camila
prompt +-------------------------------------------------------------+
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