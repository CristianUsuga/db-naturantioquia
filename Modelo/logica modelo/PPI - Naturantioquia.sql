DROP TABLE actualizaciones_pedidos CASCADE CONSTRAINTS;

DROP TABLE barrios CASCADE CONSTRAINTS;

DROP TABLE categorias CASCADE CONSTRAINTS;

DROP TABLE categorias_productos CASCADE CONSTRAINTS;

DROP TABLE ciudades CASCADE CONSTRAINTS;

DROP TABLE departamentos CASCADE CONSTRAINTS;

DROP TABLE detalle_pedidos CASCADE CONSTRAINTS;

DROP TABLE direcciones CASCADE CONSTRAINTS;

DROP TABLE estados_laboratorios CASCADE CONSTRAINTS;

DROP TABLE estados_usuarios CASCADE CONSTRAINTS;

DROP TABLE formularios CASCADE CONSTRAINTS;

DROP TABLE imagenes CASCADE CONSTRAINTS;

DROP TABLE imagenes_productos CASCADE CONSTRAINTS;

DROP TABLE laboratorios CASCADE CONSTRAINTS;

DROP TABLE pedidos CASCADE CONSTRAINTS;

DROP TABLE perfiles CASCADE CONSTRAINTS;

DROP TABLE perfiles_formularios CASCADE CONSTRAINTS;

DROP TABLE prioridades CASCADE CONSTRAINTS;

DROP TABLE productos CASCADE CONSTRAINTS;

DROP TABLE roles CASCADE CONSTRAINTS;

DROP TABLE secciones_envios CASCADE CONSTRAINTS;

DROP TABLE seguimientos CASCADE CONSTRAINTS;

DROP TABLE sexos CASCADE CONSTRAINTS;

DROP TABLE tipo_transportista CASCADE CONSTRAINTS;

DROP TABLE tipos_documentos CASCADE CONSTRAINTS;

DROP TABLE transportistas CASCADE CONSTRAINTS;

DROP TABLE usuarios CASCADE CONSTRAINTS;

DROP TABLE usuarios_direcciones CASCADE CONSTRAINTS;


CREATE TABLE actualizaciones_pedidos (
    id_pedido          INTEGER ,
    id_actualizaciones INTEGER ,
    notas              VARCHAR2(255) 
);



CREATE TABLE barrios (
    id_departamento INTEGER ,
    id_ciudad       INTEGER ,
    id_barrio       INTEGER ,
    nombre_barrio   VARCHAR2(50) 
);


CREATE TABLE categorias (
    id_categoria     INTEGER ,
    nombre_categoria VARCHAR2(50) 
);



CREATE TABLE categorias_productos (
    id_categoria INTEGER ,
    id_producto  INTEGER 
);


CREATE TABLE ciudades (
    id_departamento INTEGER ,
    id_ciudad       INTEGER ,
    nombre_ciudad   VARCHAR2(50) 
);

CREATE TABLE departamentos (
    id_departamento     INTEGER ,
    nombre_departamento VARCHAR2(60) 
);


CREATE TABLE detalle_pedidos (
    id_producto        INTEGER ,
    id_pedidos         INTEGER ,
    cantidad           INTEGER ,
    descuento          NUMBER(4, 2) ,
    cantidad_entregada INTEGER 
);



CREATE TABLE direcciones (
    id_direccion          INTEGER ,
    descripcion_direccion VARCHAR2(150) ,
    departamento          INTEGER ,
    ciudad                INTEGER ,
    barrio                INTEGER 
);


CREATE TABLE estados_laboratorios (
    id_estado_lab  INTEGER ,
    nombre_est_lab VARCHAR2(15) 
);


CREATE TABLE estados_usuarios (
    id_estado_usuarios INTEGER ,
    nombre_estado      VARCHAR2(10) 
);

CREATE TABLE formularios (
    id_formulario     INTEGER ,
    nombre_formulario VARCHAR2(50) 
);



CREATE TABLE imagenes (
    id_imagen        INTEGER ,
    nombre_imagen    VARCHAR2(100) ,
    ubicacion_imagen VARCHAR2(400) 
);


CREATE TABLE imagenes_productos (
    id_producto INTEGER ,
    id_imagen   INTEGER 
);



CREATE TABLE laboratorios (
    id_laboratorio     INTEGER ,
    nombre_laboratorio VARCHAR2(100) ,
    correo             VARCHAR2(100) ,
    telefono           INTEGER,
    celular            INTEGER ,
    estado_laboratorio INTEGER 
);


CREATE TABLE pedidos (
    id_pedidos      INTEGER ,
    fecha_creacion  DATE ,
    fecha_concluido DATE ,
    descuento       NUMBER(4, 2) ,
    total           NUMBER(10, 2),
    prioridad       INTEGER ,
    seguimiento     INTEGER ,
    id_usuario      INTEGER ,
    id_direccion    INTEGER 
);



CREATE TABLE perfiles (
    id_perfil     INTEGER ,
    nombre_perfil VARCHAR2(50) ,
    roles_id      INTEGER 
);



CREATE TABLE perfiles_formularios (
    id_perfil     INTEGER ,
    id_formulario INTEGER ,
    insertar      NUMBER(1) ,
    actualizar    NUMBER(1) ,
    eliminar      NUMBER(1) ,
    ver           NUMBER(1) 
);


CREATE TABLE prioridades (
    id_prioridad       INTEGER ,
    nombre_prioridades VARCHAR2(20) 
);


CREATE TABLE productos (
    id_producto          INTEGER ,
    nombre_producto      VARCHAR2(50) ,
    descripcion_producto VARCHAR2(200) ,
    precio               NUMBER(8, 2) ,
    stock                INTEGER ,
    fecha_creacion       DATE ,
    fecha_actualizacion  DATE ,
    id_laboratorios      INTEGER 
);



CREATE TABLE roles (
    id_rol INTEGER ,
    rol    VARCHAR2(20) 
);


CREATE TABLE secciones_envios (
    id_producto      INTEGER ,
    id_pedido        INTEGER ,
    id_seccion       INTEGER ,
    des_seccion      VARCHAR2(200) ,
    fecha_asignacion DATE ,
    fecha_entrega    DATE,
    id_transportista INTEGER 
);


CREATE TABLE seguimientos (
    id_seguimiento     INTEGER ,
    nombre_seguimiento VARCHAR2(20) 
);



CREATE TABLE sexos (
    id_sexo     INTEGER ,
    nombre_sexo VARCHAR2(20) 
);


CREATE TABLE tipo_transportista (
    id_tipo_transportista     INTEGER ,
    nombre_tipo_transportista VARCHAR2(50) 
);


CREATE TABLE tipos_documentos (
    id_documento     INTEGER ,
    nombre_documento VARCHAR2(50) 
);



CREATE TABLE transportistas (
    id_transportista INTEGER ,
    nombre           VARCHAR2(150) ,
    celular          INTEGER ,
    telefono         INTEGER,
    correo           VARCHAR2(100) ,
    tipo             INTEGER 
);


CREATE TABLE usuarios (
    documento_usuario        INTEGER ,
    nombre_usuario           VARCHAR2(100) ,
    primer_apellido_usuario  VARCHAR2(50) ,
    segundo_apellido_usuario VARCHAR2(50),
    correo_usuario           VARCHAR2(100) ,
    password_usuario         VARCHAR2(100) ,
    fecha_nacimiento_usuario DATE ,
    celular_usuario          NUMBER(10) ,
    telefono_usuario         NUMBER(10),
    tipo_documento           INTEGER ,
    estado_usuario           INTEGER ,
    sexo_usuario             INTEGER ,
    rol_usuario              INTEGER 
);


CREATE TABLE usuarios_direcciones (
    id_usuario   INTEGER ,
    id_direccion INTEGER 
);
