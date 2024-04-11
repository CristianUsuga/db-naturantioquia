
--Primary key


ALTER TABLE actualizaciones_pedidos
    ADD CONSTRAINT actualizaciones_pedidos_pk PRIMARY KEY (id_pedido, id_actualizaciones);


ALTER TABLE barrios
    ADD CONSTRAINT barrios_pk PRIMARY KEY (id_departamento, id_ciudad, id_barrio);

ALTER TABLE categorias
    ADD CONSTRAINT categorias_pk PRIMARY KEY (id_categoria);

ALTER TABLE categorias_productos
    ADD CONSTRAINT categorias_productos_pk PRIMARY KEY (id_categoria, id_producto);

ALTER TABLE ciudades
    ADD CONSTRAINT ciudades_pk PRIMARY KEY (id_departamento, id_ciudad);

ALTER TABLE departamentos
    ADD CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento);

ALTER TABLE detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pk PRIMARY KEY (id_producto, id_pedidos);

ALTER TABLE direcciones
    ADD CONSTRAINT direcciones_pk PRIMARY KEY (id_direccion);

ALTER TABLE estados_laboratorios
    ADD CONSTRAINT estados_laboratorios_pk PRIMARY KEY (id_estado_lab);

ALTER TABLE estados_usuarios
    ADD CONSTRAINT estados_usuarios_pk PRIMARY KEY (id_estado_usuarios);

ALTER TABLE formularios
    ADD CONSTRAINT formularios_pk PRIMARY KEY (id_formulario);

ALTER TABLE imagenes
    ADD CONSTRAINT imagenes_pk PRIMARY KEY (id_imagen);

ALTER TABLE imagenes_productos
ADD CONSTRAINT imagenes_productos_pk PRIMARY KEY (id_producto, id_imagen);

ALTER TABLE laboratorios
    ADD CONSTRAINT laboratorios_pk PRIMARY KEY (id_laboratorio);

ALTER TABLE pedidos
    ADD CONSTRAINT pedidos_pk PRIMARY KEY (id_pedidos);

ALTER TABLE perfiles
ADD CONSTRAINT perfiles_pk PRIMARY KEY (id_perfil);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT perfiles_formularios_pk PRIMARY KEY (id_perfil, id_formulario);

ALTER TABLE prioridades
ADD CONSTRAINT prioridades_pk PRIMARY KEY (id_prioridad);

ALTER TABLE productos
ADD CONSTRAINT productos_pk PRIMARY KEY (id_producto);

ALTER TABLE roles
ADD CONSTRAINT roles_pk PRIMARY KEY (id_rol);

ALTER TABLE secciones_envios
ADD CONSTRAINT secciones_envios_pk PRIMARY KEY (id_producto, id_pedido, id_seccion);

ALTER TABLE seguimientos ADD CONSTRAINT seguimientos_pk PRIMARY KEY ( id_seguimiento );


ALTER TABLE sexos ADD CONSTRAINT sexos_pk PRIMARY KEY ( id_sexo );

ALTER TABLE tipo_transportista ADD CONSTRAINT tipo_transportista_pk PRIMARY KEY ( id_tipo_transportista );

ALTER TABLE tipos_documentos ADD CONSTRAINT tipos_documentos_pk PRIMARY KEY ( id_documento );

ALTER TABLE transportistas
ADD CONSTRAINT transportistas_id_pk PRIMARY KEY (id_transportista);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_documento_pk PRIMARY KEY (documento_usuario);


ALTER TABLE usuarios_direcciones
ADD CONSTRAINT usuarios_direcciones_pk PRIMARY KEY (id_usuario, id_direccion);



--actualizaciones_pedidos



ALTER TABLE actualizaciones_pedidos
    ADD CONSTRAINT actualizaciones_pedidos_id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedidos);

ALTER TABLE actualizaciones_pedidos
    ADD CONSTRAINT actualizaciones_pedidos_nn_notas CHECK (notas IS NOT NULL);




--barrios
    



ALTER TABLE barrios
    ADD CONSTRAINT nombre_barrio_nn CHECK (nombre_barrio IS NOT NULL);


ALTER TABLE barrios
    ADD CONSTRAINT barrios_ciudades_fk FOREIGN KEY ( id_departamento, id_ciudad ) REFERENCES ciudades ( id_departamento,id_ciudad );

--Categorias



ALTER TABLE categorias
    ADD CONSTRAINT nombre_categoria_nn CHECK (nombre_categoria IS NOT NULL);


--categorias_productos


ALTER TABLE categorias_productos
    ADD CONSTRAINT categorias_productos_categorias_fk FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria);

ALTER TABLE categorias_productos 
ADD CONSTRAINT categorias_productos_productos_fk FOREIGN KEY (id_producto) REFERENCES productos(id_producto);


--ciudades


ALTER TABLE ciudades
    ADD CONSTRAINT ciudades_departamentos_fk FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento);

ALTER TABLE ciudades
ADD CONSTRAINT nombre_ciudad_nn CHECK (nombre_ciudad IS NOT NULL);

--departamentos



ALTER TABLE departamentos
    ADD CONSTRAINT nombre_departamento_nn CHECK (nombre_departamento IS NOT NULL);

--detalle_pedidos


ALTER TABLE detalle_pedidos
    ADD CONSTRAINT cantidad_nn CHECK (cantidad IS NOT NULL);

ALTER TABLE detalle_pedidos
    ADD CONSTRAINT descuento_nn CHECK (descuento IS NOT NULL);

ALTER TABLE detalle_pedidos
    ADD CONSTRAINT cantidad_entregada_nn CHECK (cantidad_entregada IS NOT NULL);

ALTER TABLE detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pedidos_fk FOREIGN KEY (id_pedidos) REFERENCES pedidos(id_pedidos);

ALTER TABLE detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_productos_fk FOREIGN KEY (id_producto) REFERENCES productos(id_producto);

--direcciones


ALTER TABLE direcciones
    ADD CONSTRAINT id_direccion_nn CHECK (id_direccion IS NOT NULL);

ALTER TABLE direcciones
    ADD CONSTRAINT descripcion_direccion_nn CHECK (descripcion_direccion IS NOT NULL);

ALTER TABLE direcciones
    ADD CONSTRAINT departamento_nn CHECK (departamento IS NOT NULL);

ALTER TABLE direcciones
    ADD CONSTRAINT ciudad_nn CHECK (ciudad IS NOT NULL);

ALTER TABLE direcciones
    ADD CONSTRAINT barrio_nn CHECK (barrio IS NOT NULL);

ALTER TABLE direcciones
    ADD CONSTRAINT direcciones_barrios_fk FOREIGN KEY (departamento, ciudad, barrio) REFERENCES barrios(id_departamento, id_ciudad, id_barrio);

--estados_laboratorios



ALTER TABLE estados_laboratorios
    ADD CONSTRAINT nombre_est_lab_nn CHECK (nombre_est_lab IS NOT NULL);


--estados_usuarios



ALTER TABLE estados_usuarios
ADD CONSTRAINT nombre_estado_nn CHECK (nombre_estado IS NOT NULL);


--formularios



ALTER TABLE formularios
    ADD CONSTRAINT nombre_formulario_nn CHECK (nombre_formulario IS NOT NULL);


--imagenes



ALTER TABLE imagenes
    ADD CONSTRAINT nombre_imagen_nn CHECK (nombre_imagen IS NOT NULL);

ALTER TABLE imagenes
    ADD CONSTRAINT ubicacion_imagen_nn CHECK (ubicacion_imagen IS NOT NULL);


--imagenes_productos


ALTER TABLE imagenes_productos
ADD CONSTRAINT imagenes_productos_imagenes_fk FOREIGN KEY (id_imagen) REFERENCES imagenes (id_imagen);

ALTER TABLE imagenes_productos
ADD CONSTRAINT imagenes_productos_productos_fk FOREIGN KEY (id_producto) REFERENCES productos (id_producto);


--laboratorios


ALTER TABLE laboratorios
    ADD CONSTRAINT id_laboratorio_nn CHECK (id_laboratorio IS NOT NULL);

ALTER TABLE laboratorios
    ADD CONSTRAINT nombre_laboratorio_nn CHECK (nombre_laboratorio IS NOT NULL);

ALTER TABLE laboratorios
    ADD CONSTRAINT correo_nn CHECK (correo IS NOT NULL);

ALTER TABLE laboratorios
    ADD CONSTRAINT celular_nn CHECK (celular IS NOT NULL);

ALTER TABLE laboratorios
    ADD CONSTRAINT estado_laboratorio_nn CHECK (estado_laboratorio IS NOT NULL);

ALTER TABLE laboratorios
    ADD CONSTRAINT laboratorios_estados_laboratorios_fk FOREIGN KEY (estado_laboratorio) REFERENCES estados_laboratorios(id_estado_lab);


---pedidos



ALTER TABLE pedidos
ADD CONSTRAINT id_pedidos_nn CHECK (id_pedidos IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT fecha_creacion_nn CHECK (fecha_creacion IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT fecha_concluido_nn CHECK (fecha_concluido IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT ped_descuento_nn CHECK (descuento IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT prioridad_nn CHECK (prioridad IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT seguimiento_nn CHECK (seguimiento IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT id_usuario_nn CHECK (id_usuario IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT ped_id_direccion_nn CHECK (id_direccion IS NOT NULL);

ALTER TABLE pedidos
ADD CONSTRAINT pedidos_prioridades_fk FOREIGN KEY (prioridad)
REFERENCES prioridades(id_prioridad);

ALTER TABLE pedidos
ADD CONSTRAINT pedidos_seguimientos_fk FOREIGN KEY (seguimiento)
REFERENCES seguimientos(id_seguimiento);

ALTER TABLE pedidos
ADD CONSTRAINT pedidos_usuarios_direcciones_fk FOREIGN KEY (id_usuario, id_direccion)
REFERENCES usuarios_direcciones(id_usuario, id_direccion);

-- perfiles


ALTER TABLE perfiles
ADD CONSTRAINT nombre_perfil_nn CHECK (nombre_perfil IS NOT NULL);

ALTER TABLE perfiles
ADD CONSTRAINT roles_id_nn CHECK (roles_id IS NOT NULL);

ALTER TABLE perfiles
ADD CONSTRAINT perfiles_roles_fk FOREIGN KEY (roles_id) REFERENCES roles(id_rol);

--perfiles_formularios


ALTER TABLE perfiles_formularios
ADD CONSTRAINT id_formulario_not_null CHECK (id_formulario IS NOT NULL);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT insertar_not_null CHECK (insertar IS NOT NULL);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT actualizar_not_null CHECK (actualizar IS NOT NULL);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT eliminar_not_null CHECK (eliminar IS NOT NULL);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT ver_not_null CHECK (ver IS NOT NULL);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT insertar_boolean CHECK (insertar IN (0, 1));

ALTER TABLE perfiles_formularios
ADD CONSTRAINT actualizar_boolean CHECK (actualizar IN (0, 1));

ALTER TABLE perfiles_formularios
ADD CONSTRAINT eliminar_boolean CHECK (eliminar IN (0, 1));

ALTER TABLE perfiles_formularios
ADD CONSTRAINT ver_boolean CHECK (ver IN (0, 1));


ALTER TABLE perfiles_formularios
ADD CONSTRAINT perfiles_formularios_formularios_fk FOREIGN KEY (id_formulario) REFERENCES formularios (id_formulario);

ALTER TABLE perfiles_formularios
ADD CONSTRAINT perfiles_formularios_perfiles_fk FOREIGN KEY (id_perfil) REFERENCES perfiles (id_perfil);

--prioridades


ALTER TABLE prioridades
ADD CONSTRAINT nombre_prioridades_nn CHECK (nombre_prioridades IS NOT NULL);

--productos


ALTER TABLE productos
ADD CONSTRAINT nombre_producto_not_null CHECK (nombre_producto IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT descripcion_producto_not_null CHECK (descripcion_producto IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT precio_not_null CHECK (precio IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT stock_not_null CHECK (stock IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT fecha_creacion_not_null CHECK (fecha_creacion IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT fecha_actualizacion_not_null CHECK (fecha_actualizacion IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT id_laboratorios_not_null CHECK (id_laboratorios IS NOT NULL);

ALTER TABLE productos
ADD CONSTRAINT productos_laboratorios_fk FOREIGN KEY (id_laboratorios)
REFERENCES laboratorios (id_laboratorio);

--roles


ALTER TABLE roles
ADD CONSTRAINT rol_not_null CHECK (rol IS NOT NULL);

-- secciones_envios


ALTER TABLE secciones_envios
ADD CONSTRAINT des_seccion_not_null CHECK (des_seccion IS NOT NULL);

ALTER TABLE secciones_envios
ADD CONSTRAINT fecha_asignacion_not_null CHECK (fecha_asignacion IS NOT NULL);

ALTER TABLE secciones_envios
ADD CONSTRAINT secciones_envios_detalle_pedidos_fk FOREIGN KEY (id_producto, id_pedido)
REFERENCES detalle_pedidos (id_producto, id_pedidos);

ALTER TABLE secciones_envios
ADD CONSTRAINT secciones_envios_transportistas_fk FOREIGN KEY (id_transportista)
REFERENCES transportistas (id_transportista);

-- seguimientos

ALTER TABLE seguimientos
    ADD CONSTRAINT seguimientos_nombre_nn CHECK (nombre_seguimiento IS NOT NULL);

--sexos



ALTER TABLE sexos
ADD CONSTRAINT sexos_nombre_check CHECK (nombre_sexo IS NOT NULL);

-- tipo_transportista 

ALTER TABLE tipo_transportista
ADD CONSTRAINT tipo_transportista_nombre_nn CHECK (nombre_tipo_transportista IS NOT NULL);

--tipos_documentos


ALTER TABLE tipos_documentos
ADD CONSTRAINT tipos_documentos_nombre_nn CHECK (nombre_documento IS NOT NULL);

--transportistas




ALTER TABLE transportistas
ADD CONSTRAINT transportistas_nombre_nn CHECK (nombre IS NOT NULL);

ALTER TABLE transportistas
ADD CONSTRAINT transportistas_celular_nn CHECK (celular IS NOT NULL);

ALTER TABLE transportistas
ADD CONSTRAINT transportistas_correo_nn CHECK (correo IS NOT NULL);

ALTER TABLE transportistas
ADD CONSTRAINT transportistas_tipo_fk FOREIGN KEY (tipo)
REFERENCES tipo_transportista (id_tipo_transportista);

-- usuarios



ALTER TABLE usuarios
ADD CONSTRAINT usuarios_nombre__nn CHECK (nombre_usuario IS NOT NULL);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_primer_apellido_nnk CHECK (primer_apellido_usuario IS NOT NULL);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_correo_nn CHECK (correo_usuario IS NOT NULL);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_password_nn CHECK (password_usuario IS NOT NULL);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_fecha_nacimiento_nn CHECK (fecha_nacimiento_usuario IS NOT NULL);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_celular_nn CHECK (celular_usuario IS NOT NULL);


ALTER TABLE usuarios
ADD CONSTRAINT usuarios_estados_usuarios_fk FOREIGN KEY (estado_usuario)
REFERENCES estados_usuarios (id_estado_usuarios);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_roles_fk FOREIGN KEY (rol_usuario)
REFERENCES roles (id_rol);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_sexos_fk FOREIGN KEY (sexo_usuario)
REFERENCES sexos (id_sexo);

ALTER TABLE usuarios
ADD CONSTRAINT usuarios_tipos_documentos_fk FOREIGN KEY (tipo_documento)
REFERENCES tipos_documentos (id_documento);


--usuarios_direcciones



ALTER TABLE usuarios_direcciones
ADD CONSTRAINT usuarios_direcciones_direcciones_fk FOREIGN KEY (id_direccion)
REFERENCES direcciones (id_direccion);

ALTER TABLE usuarios_direcciones
ADD CONSTRAINT usuarios_direcciones_usuarios_fk FOREIGN KEY (id_usuario)
REFERENCES usuarios (documento_usuario);

