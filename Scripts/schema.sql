
CLEAR SCREEN;

prompt +----------------------------------+
prompt |   Script de Creación de Esquema |
prompt |    en la Base de Datos           |
prompt |          naturantioquia          |
prompt +----------------------------------+

connect system/sqlOracleDB2

show con_name

ALTER SESSION SET CONTAINER=CDB$ROOT;
ALTER DATABASE OPEN;

DROP TABLESPACE ts_naturantioquia INCLUDING CONTENTS and DATAFILES;

CREATE TABLESPACE ts_naturantioquia LOGGING
DATAFILE 'C:\Oracle\PPI\datos\DF_naturantioquia.dbf' size 1M;

alter session set "_ORACLE_SCRIPT"=true; 


drop user us_naturantioquia cascade;

CREATE user us_naturantioquia profile default 
identified by 123
default tablespace ts_naturantioquia 
temporary tablespace temp 
account unlock;     


grant connect, resource,dba to us_naturantioquia; 
prompt Privilegios asignados correctamente al nuevo usuario.

connect us_naturantioquia/123
prompt Conectado como usuario us_naturantioquia.

show user
