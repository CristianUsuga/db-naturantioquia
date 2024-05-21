CREATE OR REPLACE TRIGGER trg_insertar_pedido
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    v_fecha_actual DATE := TRUNC(SYSDATE);
    v_fecha_entrega DATE;
    ex_pedido_historico EXCEPTION;
    ex_pedido_antiguo EXCEPTION;
BEGIN
    -- Verificar si la fecha de creación se ha ingresado
    IF :NEW.FECHA_CREACION IS NULL THEN
        -- Si no se ingresó la fecha de creación, lanzar una excepción y establecer la fecha actual
        RAISE ex_pedido_antiguo;
        :NEW.FECHA_CREACION := v_fecha_actual;
    ELSE
        -- Si se ingresó la fecha de creación, verificar las condiciones
        IF :NEW.FECHA_CREACION >= v_fecha_actual THEN
            -- Si la fecha de creación es igual o superior a la fecha actual
            IF TO_CHAR(:NEW.FECHA_CREACION, 'HH24:MI') >= '12:00' THEN
                -- Si la fecha de creación es después del mediodía
                -- Establecer la fecha de entrega para el día siguiente
                v_fecha_entrega := :NEW.FECHA_CREACION + 1;
            ELSE
                -- Si la fecha de creación es antes del mediodía
                -- Verificar si la dirección indica que es de la ciudad de Medellín
                IF EXISTS (SELECT 1 FROM USUARIOS_DIRECCIONES WHERE ID_USUARIO = :NEW.ID_USUARIO AND ID_DIRECCION IN (SELECT ID_DIRECCION FROM DIRECCIONES WHERE CIUDAD = 1)) THEN
                    -- Establecer la fecha de entrega para el mismo día
                    v_fecha_entrega := :NEW.FECHA_CREACION;
                ELSE
                    -- Establecer la fecha de entrega para el día siguiente
                    v_fecha_entrega := :NEW.FECHA_CREACION + 1;
                END IF;
            END IF;
        ELSE
            -- Si la fecha de creación es anterior a la fecha actual
            -- Verificar si la dirección indica que es de la ciudad de Medellín
            IF EXISTS (SELECT 1 FROM USUARIOS_DIRECCIONES WHERE ID_USUARIO = :NEW.ID_USUARIO AND ID_DIRECCION IN (SELECT ID_DIRECCION FROM DIRECCIONES WHERE CIUDAD = 1)) THEN
                -- Establecer la fecha de entrega para el día siguiente
                v_fecha_entrega := v_fecha_actual + 1;
            ELSE
                -- Establecer la fecha de entrega para 5 días después
                v_fecha_entrega := v_fecha_actual + 5;
            END IF;
        END IF;
        
        -- Verificar si la fecha de entrega es un sábado después del mediodía
        IF TO_CHAR(v_fecha_entrega, 'D') = 7 AND TO_CHAR(v_fecha_entrega, 'HH24:MI') >= '12:00' THEN
            -- Si es sábado después del mediodía, establecer la fecha de entrega para el lunes
            v_fecha_entrega := v_fecha_entrega + 2;
            -- Lanzar una excepción para notificar al encargado
            RAISE ex_pedido_historico;
            DBMS_OUTPUT.PUT_LINE('Comuníquese con el encargado para coordinar la entrega.');
        END IF;
    END IF;
    
    -- Asignar la fecha de entrega calculada al pedido
    :NEW.FECHA_ENTREGA := v_fecha_entrega;
    
    EXCEPTION
        WHEN ex_pedido_historico THEN
            -- Manejar la excepción para pedidos históricos
            -- Guardar la información en la base de datos
            NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            DBMS_OUTPUT.PUT_LINE('El pedido es histórico. Guardando información...');
        WHEN ex_pedido_antiguo THEN
            -- Manejar la excepción para pedidos antiguos sin fecha de creación
            -- Guardar la información en la base de datos
            NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            DBMS_OUTPUT.PUT_LINE('El pedido no tiene registro de fecha de creación. Guardando información...');
END;
/






CREATE OR REPLACE TRIGGER trg_insertar_pedido
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    v_fecha_actual DATE := TRUNC(SYSDATE);
    v_fecha_entrega DATE;
    ex_pedido_historico EXCEPTION;
    ex_pedido_antiguo EXCEPTION;
    v_ciudad_usuario INTEGER;
BEGIN
    SELECT seq_id_pedidos.NEXTVAL INTO :NEW.ID_PEDIDOS FROM DUAL;
    
    -- Verificar si la fecha de creación se ha ingresado
    IF :NEW.FECHA_CREACION IS NULL THEN
        -- Si no se ingresó la fecha de creación, lanzar una excepción y establecer la fecha actual
        RAISE ex_pedido_antiguo;
        :NEW.FECHA_CREACION := v_fecha_actual;
    ELSE
        -- Si se ingresó la fecha de creación, verificar las condiciones
        IF :NEW.FECHA_CREACION >= v_fecha_actual THEN
            -- Si la fecha de creación es igual o superior a la fecha actual
            IF TO_CHAR(:NEW.FECHA_CREACION, 'HH24:MI') >= '12:00' THEN
                -- Si la fecha de creación es después del mediodía
                -- Establecer la fecha de entrega para el día siguiente
                v_fecha_entrega := :NEW.FECHA_CREACION + 1;
            ELSE
                -- Si la fecha de creación es antes del mediodía
                -- Verificar si la dirección indica que es de la ciudad de Medellín
                SELECT COUNT(*) INTO v_ciudad_usuario
                FROM USUARIOS_DIRECCIONES UD
                JOIN DIRECCIONES D ON UD.ID_DIRECCION = D.ID_DIRECCION
                WHERE UD.ID_USUARIO = :NEW.ID_USUARIO
                AND D.CIUDAD = 1; -- Medellín

                IF v_ciudad_usuario > 0 THEN
                    -- Establecer la fecha de entrega para el mismo día
                    v_fecha_entrega := :NEW.FECHA_CREACION;
                ELSE
                    -- Establecer la fecha de entrega para el día siguiente
                    v_fecha_entrega := :NEW.FECHA_CREACION + 1;
                END IF;
            END IF;
        ELSE
            -- Si la fecha de creación es anterior a la fecha actual
            -- Verificar si la dirección indica que es de la ciudad de Medellín
            SELECT COUNT(*) INTO v_ciudad_usuario
            FROM USUARIOS_DIRECCIONES UD
            JOIN DIRECCIONES D ON UD.ID_DIRECCION = D.ID_DIRECCION
            WHERE UD.ID_USUARIO = :NEW.ID_USUARIO
            AND D.CIUDAD = 1; -- Medellín

            IF v_ciudad_usuario > 0 THEN
                -- Establecer la fecha de entrega para el día siguiente
                v_fecha_entrega := v_fecha_actual + 1;
            ELSE
                -- Establecer la fecha de entrega para 5 días después
                v_fecha_entrega := v_fecha_actual + 5;
            END IF;
        END IF;
        
        -- Verificar si la fecha de entrega es un sábado después del mediodía
        IF TO_CHAR(v_fecha_entrega, 'D') = 7 AND TO_CHAR(v_fecha_entrega, 'HH24:MI') >= '12:00' THEN
            -- Si es sábado después del mediodía, establecer la fecha de entrega para el lunes
            v_fecha_entrega := v_fecha_entrega + 2;
            -- Lanzar una excepción para notificar al encargado
            RAISE ex_pedido_historico;
            DBMS_OUTPUT.PUT_LINE('Comuníquese con el encargado para coordinar la entrega.');
        END IF;
    END IF;
    
    -- Asignar la fecha de entrega calculada al pedido
    :NEW.FECHA_ENTREGA := v_fecha_entrega;
    
    EXCEPTION
        WHEN ex_pedido_historico THEN
            -- Manejar la excepción para pedidos históricos
            -- Asignar el valor a SEGUIMIENTO para indicar que el pedido histórico ha sido completado
            :NEW.SEGUIMIENTO := 9; -- Completado
            -- Guardar la información en la base de datos
            NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            -- Imprimir mensaje para comunicarse con el encargado
            DBMS_OUTPUT.PUT_LINE('Pedido histórico completado y guardado.');
        WHEN ex_pedido_antiguo THEN
            -- Manejar la excepción para pedidos antiguos sin fecha de creación
            -- Guardar la información en la base de datos
            NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            DBMS_OUTPUT.PUT_LINE('El pedido no tiene registro de fecha de creación. Guardando información...');
END;
/





-------------------real hasta la muerte

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
    
    -- Generar el próximo valor de la secuencia para ID_PEDIDOS
    SELECT seq_id_pedidos.NEXTVAL INTO :NEW.ID_PEDIDOS FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('ID_PEDIDOS generado: ' || :NEW.ID_PEDIDOS);
    
    -- Asignar valores predeterminados si no se ingresaron
    :NEW.TOTAL :=  0;
    IF :NEW.DESCUENTO IS NULL THEN
        :NEW.DESCUENTO := 0;
    END IF;
    
    -- Verificar si se ingresó la prioridad
    IF :NEW.PRIORIDAD IS NULL THEN
        -- Si no se ingresó la prioridad, asignar la prioridad por defecto (4 - Bajo)
        :NEW.PRIORIDAD := 4;
        DBMS_OUTPUT.PUT_LINE('No se puede tener una prioridad vacía. Se asigna por defecto: 4 (Bajo)');
    END IF;
    
    -- Verificar si es un pedido histórico
    IF :NEW.FECHA_CREACION IS NULL OR :NEW.FECHA_CREACION < v_fecha_actual THEN
        IF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA IS NULL THEN
            -- Si FECHA_CREACION y FECHA_ENTREGA son NULL, lanzar una excepción
            RAISE ex_pedido_sin_fecha_creacion;
        ELSIF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA < v_fecha_actual THEN
            -- Si FECHA_CREACION es NULL y FECHA_ENTREGA es anterior a la fecha actual, es un pedido histórico entregado
            :NEW.SEGUIMIENTO := NVL(:NEW.SEGUIMIENTO, 9); -- Cambia SEGUIMIENTO a 9 si es NULL
            NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            DBMS_OUTPUT.PUT_LINE('Pedido histórico completado y guardado.');
        ELSIF :NEW.FECHA_CREACION IS NULL AND :NEW.FECHA_ENTREGA >= v_fecha_actual THEN
            -- Si FECHA_CREACION es NULL y FECHA_ENTREGA es igual o posterior a la fecha actual, es un pedido histórico pendiente
            RAISE ex_pedido_historico_pendiente;
        ELSIF :NEW.FECHA_CREACION < v_fecha_actual AND :NEW.FECHA_ENTREGA < v_fecha_actual THEN
            -- Si FECHA_CREACION y FECHA_ENTREGA son anteriores a la fecha actual
            IF :NEW.SEGUIMIENTO NOT IN (9,8,7,6) THEN
                -- Si SEGUIMIENTO no es válido, asignar SEGUIMIENTO a 9 (Completado)
                :NEW.SEGUIMIENTO := 9;
                NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            ELSE
                -- Si SEGUIMIENTO es válido, guardar el registro
                NULL; -- Aquí pondrías el código para guardar la información en la base de datos
            END IF;
        ELSE
            -- Si ninguna de las condiciones anteriores se cumple, lanzar una excepción
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
            -- Si la dirección del usuario no está en Medellín
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
        -- Manejar la excepción para pedidos sin fecha de creación ni fecha de entrega
        DBMS_OUTPUT.PUT_LINE('No se puede crear un registro de pedido sin fecha de creación ni fecha de entrega. Por favor, contacte con el programador.');
    WHEN ex_pedido_historico_entregado THEN
        -- Manejar la excepción para pedidos históricos entregados
        DBMS_OUTPUT.PUT_LINE('Pedido histórico completado y guardado.');
    WHEN ex_pedido_historico_pendiente THEN
        -- Manejar la excepción para pedidos históricos pendientes
        DBMS_OUTPUT.PUT_LINE('Pedido histórico pendiente. Por favor, agéndelo.');
    WHEN ex_prioridad_vacia THEN
        -- Manejar la excepción para prioridad vacía
        :NEW.PRIORIDAD := 4;
        DBMS_OUTPUT.PUT_LINE('No se puede tener una prioridad vacía. Se asigna por defecto: 4 (Bajo)');
    WHEN OTHERS THEN
        -- Manejar otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error con código: ' || SQLCODE || '. Mensaje de error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Por favor, contacte con el programador.');
END;
/
