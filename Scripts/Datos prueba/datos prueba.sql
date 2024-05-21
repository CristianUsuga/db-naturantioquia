prompt +-------------------------------------------------+
prompt |        Datos de la Tabla ROLES      |
prompt +-------------------------------------------------+

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla DEPARTAMENTOS       |
prompt +-------------------------------------------------+

INSERT INTO DEPARTAMENTOS (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO)
VALUES (1, 'Antioquia');

INSERT INTO DEPARTAMENTOS (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO)
VALUES (2, 'Cundinamarca');

INSERT INTO DEPARTAMENTOS (ID_DEPARTAMENTO, NOMBRE_DEPARTAMENTO)
VALUES (3, 'Santander');

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla CIUDADES       |
prompt +-------------------------------------------------+

-- Ingresar municipios de Antioquia
INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (1, 'Medellín');

INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (1, 'Bello');

INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (1, 'Itagüí');

INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (1, 'Envigado');

-- Ingresar municipios de Cundinamarca
INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (2,  'Bogotá');

INSERT INTO CIUDADES (ID_DEPARTAMENTO, NOMBRE_CIUDAD)
VALUES (2, 'Soacha');


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla BARRIOS       |
prompt +-------------------------------------------------+
INSERT INTO "US_NATURANTIOQUIA"."BARRIOS" (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO) VALUES ('2', '2', 'Sevilla');


--  barrios de Medellín
INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Popular');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Santa Cruz');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Aranjuez');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Castilla');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Doce de Octubre');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Robledo');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Villa Hermosa');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Buenos Aires');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'La Candelaria');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Laureles-Estadio');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'La América');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'San Javier');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'El Poblado');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Guayabal');

INSERT INTO BARRIOS (ID_DEPARTAMENTO, ID_CIUDAD, NOMBRE_BARRIO)
VALUES (1, 1, 'Belén');

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla DIRECCIONES       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."DIRECCIONES" (DESCRIPCION_DIRECCION, DEPARTAMENTO, CIUDAD, BARRIO) VALUES ('al aldo del señor', '1', '1', '1');


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla Formularios       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."FORMULARIOS" (ID_FORMULARIO, NOMBRE_FORMULARIO, NODO_PRINCIPAL, ORDEN, URL) VALUES ('5', 'Main', '1', '1', 'l.kdp')

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla PERFILES       |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."FORMULARIOS" (ID_FORMULARIO, NOMBRE_FORMULARIO, NODO_PRINCIPAL, ORDEN, URL) VALUES ('5', 'Main', '1', '1', 'l.kdp');

--hijo
INSERT INTO "US_NATURANTIOQUIA"."FORMULARIOS" (NOMBRE_FORMULARIO, NODO_PRINCIPAL, MODULO, ID_PADRE, ORDEN, URL) VALUES ('Pedidos', '0', '1', '2', '2', 'jsp.png');


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla LABORATORIOS       |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURANTIOQUIA"."LABORATORIOS" (NOMBRE_LABORATORIO, CORREO, TELEFONO, CELULAR, ESTADO_LABORATORIO) VALUES ('Laboratorio Aleman', 'labo@lobo.com', '6046045247', '3008020156', '1');
INSERT INTO "US_NATURANTIOQUIA"."LABORATORIOS" (NOMBRE_LABORATORIO, CORREO, TELEFONO, CELULAR, ESTADO_LABORATORIO) VALUES ('lob 2', 'lab2@lab2.com', '6046026647', '3023366841', '2');

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla    PRODUCTOS    |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURANTIOQUIA"."PRODUCTOS" (NOMBRE_PRODUCTO, DESCRIPCION_PRODUCTO, PRECIO, STOCK_MINIMO, STOCK_MAXIMO, CANTIDAD_ACTUAL, ID_LABORATORIOS) VALUES ('vitamina', 'D', '50000', '45', '10', '15', '1');


prompt +-------------------------------------------------+
prompt |  Datos de la Tabla    LOTES_PRODUCTOSPRODUCTOS    |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."LOTES_PRODUCTOS" (CANTIDAD, FECHA_VENCIMIENTO, ID_PRODUCTO) VALUES ('5', TO_DATE('2024-04-28 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), '9');


prompt +-------------------------------------------------+
prompt |      Datos de la Tabla  IMAGENES_PRODUCTOS      |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."IMAGENES_PRODUCTOS" (ID_PRODUCTO, ID_IMAGEN, NOMBRE_IMAGEN, UBICACION_IMAGEN) VALUES ('1', '80', 'lucas', 'lucas/perfil.png');
INSERT INTO "US_NATURANTIOQUIA"."IMAGENES_PRODUCTOS" (ID_PRODUCTO, ID_IMAGEN, NOMBRE_IMAGEN, UBICACION_IMAGEN) VALUES ('9', '5', 'litio', 'litio.png');


prompt +-------------------------------------------------+
prompt |          Datos de la Tabla USUARIOS             |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURANTIOQUIA"."USUARIOS" (DOCUMENTO_USUARIO, NOMBRE_USUARIO, PRIMER_APELLIDO_USUARIO, SEGUNDO_APELLIDO_USUARIO, CORREO_USUARIO, PASSWORD_USUARIO, FECHA_NACIMIENTO_USUARIO, CELULAR_USUARIO, TELEFONO_USUARIO, TIPO_DOCUMENTO, ESTADO_USUARIO, SEXO_USUARIO, ROL_USUARIO) VALUES ('1192738137', 'Cristian', 'Usuga', 'Higuita', 'cristian@hotmail.com', 'Password1', TO_DATE('2002-12-11 06:01:40', 'YYYY-MM-DD HH24:MI:SS'), '3008020156', '6046045247', '1', '1', '1', '1');

prompt +-------------------------------------------------+
prompt |      Datos de la Tabla USUARIOS_DIRECCIONES      |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."USUARIOS_DIRECCIONES" (ID_USUARIO, ID_DIRECCION) VALUES ('1192738137', '1');



prompt +-------------------------------------------------+
prompt |      Datos de la Tabla  PEDIDOS     |
prompt +-------------------------------------------------+

INSERT INTO "US_NATURANTIOQUIA"."PEDIDOS" (FECHA_CREACION, DESCUENTO, TOTAL, PRIORIDAD, SEGUIMIENTO, ID_USUARIO, ID_DIRECCION) VALUES (TO_DATE('2024-05-07 07:14:46', 'YYYY-MM-DD HH24:MI:SS'), '0', '0', '1', '1', '1192738137', '1');

prompt +-------------------------------------------------+
prompt |      Datos de la Tabla       |
prompt +-------------------------------------------------+