-- Limpiar pantalla
CLEAR SCREEN;

-- Imprimir título de creación de tablas
prompt +---------------------------------------------------+
prompt |       Creación de Tablas para Naturantioquia      |
prompt +---------------------------------------------------+


prompt +-----------------------------------------------------+
prompt |          Eliminación de Tablas Existente            |
prompt +-----------------------------------------------------+
DROP TABLE ESTADOS_USUARIOS;
prompt --> ESTADOS_USUARIOS eliminada si existía previamente.
DROP TABLE TIPOS_DOCUMENTOS;
prompt --> TIPOS_DOCUMENTOS eliminada si existía previamente.
DROP TABLE ROLES;
prompt --> ROLES eliminada si existía previamente.
DROP TABLE SEXOS;
prompt --> SEXOS eliminada si existía previamente.
DROP TABLE DEPARTAMENTOS;
prompt --> DEPARTAMENTOS eliminada si existía previamente.
DROP TABLE CIUDADES;
prompt --> CIUDADES eliminada si existía previamente.
DROP TABLE BARRIOS;
prompt --> BARRIOS eliminada si existía previamente.
DROP TABLE DIRECCIONES;
prompt --> DIRECCIONES eliminada si existía previamente.
DROP TABLE FORMULARIOS;
prompt --> FORMULARIOS eliminada si existía previamente.
DROP TABLE PERFILES;
prompt --> PERFILES eliminada si existía previamente.
DROP TABLE PERFILES_FORMULARIOS;
prompt --> PERFILES_FORMULARIOS eliminada si existía previamente.
DROP TABLE USUARIOS;
prompt --> USUARIOS eliminada si existía previamente.
DROP TABLE SEGUIMIENTOS;
prompt --> SEGUIMIENTOS eliminada si existía previamente.
DROP TABLE PRIORIDADES;
prompt --> PRIORIDADES eliminada si existía previamente.
DROP TABLE TIPO_TRANSPORTISTA;
prompt --> TIPO_TRANSPORTISTA eliminada si existía previamente.
DROP TABLE ESTADOS_LABORATORIOS;
prompt --> ESTADOS_LABORATORIOS eliminada si existía previamente.
DROP TABLE LABORATORIOS;
prompt --> LABORATORIOS eliminada si existía previamente.
DROP TABLE TIPOS_MOVIMIENTOS;
prompt --> TIPOS_MOVIMIENTOS eliminada si existía previamente.
DROP TABLE TIPO_DESCUENTO;
prompt --> TIPO_DESCUENTO eliminada si existía previamente.
DROP TABLE TIPO_VALOR;
prompt --> TIPO_VALOR eliminada si existía previamente.
DROP TABLE CATEGORIAS;
prompt --> CATEGORIAS eliminada si existía previamente.
DROP TABLE TRANSPORTISTAS;
prompt --> TRANSPORTISTAS eliminada si existía previamente.
DROP TABLE PRODUCTOS;
prompt --> PRODUCTOS eliminada si existía previamente.
DROP TABLE LOTES_PRODUCTOS;
prompt --> LOTES_PRODUCTOS eliminada si existía previamente.
DROP TABLE MOVIMIENTOS_INVENTARIO;
prompt --> MOVIMIENTOS_INVENTARIO eliminada si existía previamente.
DROP TABLE IMAGENES_PRODUCTOS;
prompt --> IMAGENES_PRODUCTOS eliminada si existía previamente.
DROP TABLE USUARIOS_DIRECCIONES;
prompt --> USUARIOS_DIRECCIONES eliminada si existía previamente.
DROP TABLE PEDIDOS;
prompt --> PEDIDOS eliminada si existía previamente.
DROP TABLE CATEGORIAS_PRODUCTOS;
prompt --> CATEGORIAS_PRODUCTOS eliminada si existía previamente.
DROP TABLE DETALLE_PEDIDOS;
prompt --> DETALLE_PEDIDOS eliminada si existía previamente.
DROP TABLE SECCIONES_ENVIOS;
prompt --> SECCIONES_ENVIOS eliminada si existía previamente.
DROP TABLE DESCUENTOS;
prompt --> DESCUENTOS eliminada si existía previamente.
DROP TABLE DESCUENTOS_PRODUCTOS;
prompt --> DESCUENTOS_PRODUCTOS eliminada si existía previamente.

-- Creación de las primeras dos tablas
prompt +-------------------------------------------------+
prompt |        Creación de Tablas          |
prompt +-------------------------------------------------+


---------------------------------------ESTADOS_USUARIOS----------------------------------------------------------------
CREATE TABLE ESTADOS_USUARIOS (
    ID_ESTADO_USUARIOS INTEGER,
    NOMBRE_ESTADO NVARCHAR2(10)
);
prompt --> Tabla ESTADOS_USUARIOS creada correctamente.

------------------------------------------TIPOS_DOCUMENTOS-------------------------------------------------------------
CREATE TABLE TIPOS_DOCUMENTOS 
(
  ID_DOCUMENTO INTEGER 
, NOMBRE_DOCUMENTO VARCHAR2(50) 
);
prompt --> Tabla TIPOS_DOCUMENTOS creada correctamente.

------------------------------------------ROLES-------------------------------------------------------------
CREATE TABLE ROLES 
(
  ID_ROL INTEGER 
, ROL VARCHAR2(20) 
);
prompt --> Tabla ROLES creada correctamente.

------------------------------------------SEXOS-------------------------------------------------------------
CREATE TABLE SEXOS 
(
  ID_SEXO INTEGER 
, NOMBRE_SEXO VARCHAR2(20) 
);
prompt --> Tabla SEXOS creada correctamente.

------------------------------------------DEPARTAMENTOS-------------------------------------------------------------
CREATE TABLE DEPARTAMENTOS 
(
  ID_DEPARTAMENTO INTEGER 
, NOMBRE_DEPARTAMENTO VARCHAR2(60) 
);
prompt --> Tabla DEPARTAMENTOS creada correctamente.

------------------------------------------CIUDADES-------------------------------------------------------------
CREATE TABLE CIUDADES 
(
  ID_DEPARTAMENTO INTEGER 
, ID_CIUDAD INTEGER 
, NOMBRE_CIUDAD VARCHAR2(50) 
);
prompt --> Tabla CIUDADES creada correctamente.

-----------------------------------------------BARRIOS--------------------------------------------------------
CREATE TABLE BARRIOS 
(
  ID_DEPARTAMENTO INTEGER 
, ID_CIUDAD INTEGER 
, ID_BARRIO INTEGER 
, NOMBRE_BARRIO VARCHAR2(50) 
);
prompt --> Tabla BARRIOS creada correctamente.

-----------------------------------------------DIRECCIONES--------------------------------------------------------
CREATE TABLE DIRECCIONES 
(
  ID_DIRECCION INTEGER 
, DESCRIPCION_DIRECCION VARCHAR2(150) 
, DEPARTAMENTO INTEGER 
, CIUDAD INTEGER 
, BARRIO INTEGER 
);
prompt --> Tabla DIRECCIONES creada correctamente.

-----------------------------------------------FORMULARIOS--------------------------------------------------------
CREATE TABLE FORMULARIOS 
(
  ID_FORMULARIO INTEGER 
, NOMBRE_FORMULARIO VARCHAR2(50) 
, NODO_PRINCIPAL NUMBER(1) 
, MODULO NUMBER(1) 
, ID_PADRE INTEGER 
, ORDEN INTEGER 
, URL VARCHAR2(100) 
);
prompt --> Tabla FORMULARIOS creada correctamente.

-----------------------------------------------PERFILES--------------------------------------------------------
CREATE TABLE PERFILES 
(
  ID_PERFIL INTEGER 
, NOMBRE_PERFIL VARCHAR2(50) 
, ROLES_ID INTEGER 
);
prompt --> Tabla PERFILES creada correctamente.

-----------------------------------------------PERFILES_FORMULARIOS--------------------------------------------------------
CREATE TABLE PERFILES_FORMULARIOS 
(
  ID_PERFIL INTEGER 
, ID_FORMULARIO INTEGER 
, INSERTAR NUMBER(1) 
, ACTUALIZAR NUMBER(1) 
, ELIMINAR NUMBER(1) 
);
prompt --> Tabla PERFILES_FORMULARIOS creada correctamente.


-----------------------------------------------USUARIOS--------------------------------------------------------
CREATE TABLE USUARIOS 
(
  DOCUMENTO_USUARIO INTEGER 
, NOMBRE_USUARIO VARCHAR2(100) 
, PRIMER_APELLIDO_USUARIO VARCHAR2(50) 
, SEGUNDO_APELLIDO_USUARIO VARCHAR2(50) 
, CORREO_USUARIO VARCHAR2(100) 
, PASSWORD_USUARIO VARCHAR2(100) 
, FECHA_NACIMIENTO_USUARIO DATE 
, CELULAR_USUARIO NUMBER(10) 
, TELEFONO_USUARIO NUMBER(10) 
, TIPO_DOCUMENTO INTEGER 
, ESTADO_USUARIO INTEGER 
, SEXO_USUARIO INTEGER 
, ROL_USUARIO INTEGER 
);
prompt --> Tabla USUARIOS creada correctamente.

-----------------------------------------------SEGUIMIENTOS--------------------------------------------------------
CREATE TABLE SEGUIMIENTOS 
(
  ID_SEGUIMIENTO INTEGER 
, NOMBRE_SEGUIMIENTO VARCHAR2(20) 
);
prompt --> Tabla SEGUIMIENTOS creada correctamente.

-----------------------------------------------PRIORIDADES--------------------------------------------------------
CREATE TABLE PRIORIDADES 
(
  ID_PRIORIDAD INTEGER 
, NOMBRE_PRIORIDADES VARCHAR2(20) 
);
prompt --> Tabla PRIORIDADES creada correctamente.

-----------------------------------------------TIPO_TRANSPORTISTA--------------------------------------------------------
CREATE TABLE TIPO_TRANSPORTISTA 
(
  ID_TIPO_TRANSPORTISTA INTEGER 
, NOMBRE_PRIORIDADES VARCHAR2(50) 
);
prompt --> Tabla TIPO_TRANSPORTISTA creada correctamente.

-----------------------------------------------ESTADOS_LABORATORIOS--------------------------------------------------------
CREATE TABLE ESTADOS_LABORATORIOS 
(
  ID_ESTADO_LAB INTEGER 
, NOMBRE_EST_LAB VARCHAR2(50) 
);
prompt --> Tabla ESTADOS_LABORATORIOS creada correctamente.

-----------------------------------------------TIPOS_MOVIMIENTOS--------------------------------------------------------
CREATE TABLE TIPOS_MOVIMIENTOS 
(
  ID_T_MOVIMIENTO INTEGER 
, NOMBRE_T_MOVIMIENTO VARCHAR2(10) 
);
prompt --> Tabla TIPOS_MOVIMIENTOS creada correctamente.

-----------------------------------------------TIPO_DESCUENTO--------------------------------------------------------
CREATE TABLE TIPO_DESCUENTO 
(
  ID_TIPO_DESC INTEGER 
, NOMBRE_TIPO_DESC VARCHAR2(15) 
);
prompt --> Tabla TIPO_DESCUENTO creada correctamente.
-----------------------------------------------TIPO_VALOR--------------------------------------------------------
CREATE TABLE TIPO_VALOR 
(
  ID_TIPO_VALOR INTEGER 
, NOMBRE_TIPO_VALOR VARCHAR2(10) 
);
prompt --> Tabla TIPO_VALOR creada correctamente.

-----------------------------------------------CATEGORIAS--------------------------------------------------------
CREATE TABLE CATEGORIAS 
(
  ID_CATEGORIA INTEGER 
, NOMBRE_CATEGORIA VARCHAR2(50) 
);
prompt --> Tabla CATEGORIAS creada correctamente.
-----------------------------------------------LABORATORIOS--------------------------------------------------------
CREATE TABLE LABORATORIOS 
(
  ID_LABORATORIO INTEGER 
, NOMBRE_LABORATORIO VARCHAR2(100) 
, CORREO VARCHAR2(100) 
, TELEFONO INTEGER 
, CELULAR INTEGER 
, ESTADO_LABORATORIO INTEGER 
);
prompt --> Tabla LABORATORIOS creada correctamente.

-----------------------------------------------TRANSPORTISTAS--------------------------------------------------------
CREATE TABLE TRANSPORTISTAS 
(
  ID_TRANSPORTISTA INTEGER 
, NOMBRE VARCHAR2(150) 
, CELULAR INTEGER 
, TELEFONO INTEGER 
, CORREO VARCHAR2(100) 
, TIPO INTEGER 
);
prompt --> Tabla TRANSPORTISTAS creada correctamente.

-----------------------------------------------PRODUCTOS--------------------------------------------------------
CREATE TABLE PRODUCTOS 
(
  ID_PRODUCTO INTEGER 
, NOMBRE_PRODUCTO VARCHAR2(50) 
, DESCRIPCION_PRODUCTO VARCHAR2(200) 
, PRECIO NUMBER(10,2) 
, STOCK_MINIMO INTEGER 
, STOCK_MAXIMO INTEGER 
, CANTIDAD_ACTUAL INTEGER 
, FECHA_CREACION DATE 
, FECHA_ACTUALIZACION DATE 
, ID_LABORATORIOS INTEGER 
);
prompt --> Tabla PRODUCTOS creada correctamente.

-----------------------------------------------LOTES_PRODUCTOS--------------------------------------------------------
CREATE TABLE LOTES_PRODUCTOS 
(
  ID_LOTE INTEGER 
, CANTIDAD INTEGER 
, FECHA_VENCIMIENTO DATE 
, ID_PRODUCTO INTEGER 
);
prompt --> Tabla LOTES_PRODUCTOS creada correctamente.

-----------------------------------------------MOVIMIENTOS_INVENTARIO--------------------------------------------------------
CREATE TABLE MOVIMIENTOS_INVENTARIO 
(
  ID_MOVIMIENTO INTEGER 
, ID_PRODUCTO INTEGER 
, ID_LOTE INTEGER 
, CANTIDAD INTEGER 
, FECHA_MOVIMIENTO DATE 
, NOTAS VARCHAR2(250) 
, TIPO_MOVIMIENTO INTEGER 
);
prompt --> Tabla MOVIMIENTOS_INVENTARIO creada correctamente.

------------------------------------------------IMAGENES_PRODUCTOS--------------------------------------------------------
CREATE TABLE IMAGENES_PRODUCTOS 
(
  ID_PRODUCTO INTEGER 
, ID_IMAGEN INTEGER 
, NOMBRE_IMAGEN VARCHAR2(100) 
, UBICACION_IMAGEN VARCHAR2(400) 
);
prompt --> Tabla IMAGENES_PRODUCTOS creada correctamente.

------------------------------------------------USUARIOS_DIRECCIONES--------------------------------------------------------

CREATE TABLE USUARIOS_DIRECCIONES 
(
  ID_USUARIO INTEGER 
, ID_DIRECCION INTEGER 
);
prompt --> Tabla USUARIOS_DIRECCIONES creada correctamente.

------------------------------------------------PEDIDOS--------------------------------------------------------
CREATE TABLE PEDIDOS 
(
  ID_PEDIDOS INTEGER 
, FECHA_CREACION DATE 
, FECHA_ENTREGA DATE 
, DESCUENTO NUMBER(4,2) 
, TOTAL NUMBER(10,2) 
, PRIORIDAD INTEGER 
, SEGUIMIENTO INTEGER 
, ID_USUARIO INTEGER 
, ID_DIRECCION INTEGER 
);
prompt --> Tabla PEDIDOS creada correctamente.

------------------------------------------------CATEGORIAS_PRODUCTOS--------------------------------------------------------
CREATE TABLE CATEGORIAS_PRODUCTOS 
(
  ID_CATEGORIA INTEGER 
, ID_PRODUCTO INTEGER 
);
prompt --> Tabla CATEGORIAS_PRODUCTOS creada correctamente.

------------------------------------------------DETALLE_PEDIDOS--------------------------------------------------------
CREATE TABLE DETALLE_PEDIDOS 
(
  ID_PRODUCTO INTEGER 
, ID_PEDIDOS INTEGER 
, CANTIDAD INTEGER 
, DESCUENTO NUMBER(4,2) 
, PRECIO_UNITARIO NUMBER(10,2) 
, CANTIDAD_ENTREGADA INTEGER 
, DESCUENTO_APLICADO NUMBER(10,2) 
);
prompt --> Tabla DETALLE_PEDIDOS creada correctamente.

------------------------------------------------SECCIONES_ENVIOS--------------------------------------------------------
CREATE TABLE SECCIONES_ENVIOS 
(
  ID_SECCION INTEGER 
, DES_SECCION VARCHAR2(200) 
, CANTIDAD_ENTREGADA INTEGER 
, FECHA_ASIGNACION DATE 
, FECHA_ENTREGA DATE 
, ID_TRANSPORTISTA INTEGER 
, ID_PRODUCTO INTEGER 
, ID_PEDIDO INTEGER 
);
prompt --> Tabla SECCIONES_ENVIOS creada correctamente.

------------------------------------------------DESCUENTOS--------------------------------------------------------
CREATE TABLE DESCUENTOS 
(
  ID_DESCUENTO INTEGER 
, NOMBRE_DESCUENTO VARCHAR2(100) 
, DESCRIPCION VARCHAR2(255) 
, FECHA_INICIO DATE 
, FECHA_FIN DATE 
, VALOR_DESCUENTO NUMBER(10,2) 
, CANTIDAD_MINIMA INTEGER 
, TOPE_DESCUENTO INTEGER 
, ACTIVO NUMBER(1) 
, TIPO_DESCUENTO INTEGER 
, TIPO_VALOR INTEGER 
, ID_CATEGORIA INTEGER 
);
prompt --> Tabla DESCUENTOS creada correctamente.

------------------------------------------------DESCUENTOS_PRODUCTOS--------------------------------------------------------
CREATE TABLE DESCUENTOS_PRODUCTOS 
(
  ID_DESCUENTO INTEGER 
, ID_PRODUCTO INTEGER 
);
prompt --> Tabla DESCUENTOS_PRODUCTOS creada correctamente.