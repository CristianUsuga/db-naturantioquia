
prompt +-------------------------------------------------+
prompt |        Datos de la Tabla ESTADOS_USUARIOS       |
prompt +-------------------------------------------------+
INSERT INTO ESTADOS_USUARIOS (ID_ESTADO_USUARIOS, NOMBRE_ESTADO)
VALUES (1, 'Activo');

INSERT INTO ESTADOS_USUARIOS (ID_ESTADO_USUARIOS, NOMBRE_ESTADO)
VALUES (2, 'Inactivo');

INSERT INTO ESTADOS_USUARIOS (ID_ESTADO_USUARIOS, NOMBRE_ESTADO)
VALUES (3, 'Bloqueado');



prompt +-------------------------------------------------+
prompt |        Datos de la Tabla TIPOS_DOCUMENTOS       |
prompt +-------------------------------------------------+

INSERT INTO TIPOS_DOCUMENTOS (ID_DOCUMENTO, NOMBRE_DOCUMENTO)
VALUES (1, 'Tarjeta de Identidad');

INSERT INTO TIPOS_DOCUMENTOS (ID_DOCUMENTO, NOMBRE_DOCUMENTO)
VALUES (2, 'Cédula de Ciudadanía');

INSERT INTO TIPOS_DOCUMENTOS (ID_DOCUMENTO, NOMBRE_DOCUMENTO)
VALUES (3, 'Cédula de Extranjería');

prompt +-------------------------------------------------+
prompt |        Datos de la Tabla ROLES      |
prompt +-------------------------------------------------+



prompt +-------------------------------------------------+
prompt |        Datos de la Tabla SEXOS       |
prompt +-------------------------------------------------+
INSERT INTO SEXOS (ID_SEXO, NOMBRE_SEXO)
VALUES (1, 'Masculino');

INSERT INTO SEXOS (ID_SEXO, NOMBRE_SEXO)
VALUES (2, 'Femenino');

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
prompt |    Datos de la Tabla  ESTADOS_LABORATORIOS      |
prompt +-------------------------------------------------+


INSERT INTO "US_NATURANTIOQUIA"."ESTADOS_LABORATORIOS" (ID_ESTADO_LAB, NOMBRE_EST_LAB) VALUES ('1', 'Activo')
INSERT INTO "US_NATURANTIOQUIA"."ESTADOS_LABORATORIOS" (ID_ESTADO_LAB, NOMBRE_EST_LAB) VALUES ('2', 'Desativado')


prompt +-------------------------------------------------+
prompt |        Datos de la Tabla        |
prompt +-------------------------------------------------+

