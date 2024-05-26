/*  

-- Equipo: GRUPO GENERICO
-- Fecha de entrega: 27.05.2023
-- TP ANUAL GDD 2023 1C

-- Ciclo lectivo: 2023
-- Descripción: Migración de Tablas Maestras - Creación Inicial

*/


USE [GD1C2024]
GO

PRINT '------ MONSTERS INC ------';
GO
PRINT '--- COMENZANDO MIGRACION  ---';
GO

/* DROPS */
DECLARE @DropConstraints NVARCHAR(max) = ''

SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'

                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)

FROM sys.foreign_keys

EXECUTE sp_executesql @DropConstraints;

PRINT '--- CONSTRAINTS DROPEADOS CORRECTAMENTE ---';

GO

/* DROPS PROCEDURES */
DECLARE @DropProcedures NVARCHAR(max) = ''

SELECT @DropProcedures += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.procedures;

EXECUTE sp_executesql @DropProcedures;

PRINT '--- PROCEDURES DROPEADOS CORRECTAMENTE ---';

GO

PRINT '--- FUNCTIONS DROPEADOS CORRECTAMENTE ---';

GO

/* DROP TABLES */

DECLARE @DropTables NVARCHAR(max) = ''

SELECT @DropTables += 'DROP TABLE MONSTERS_INC. ' + QUOTENAME(TABLE_NAME)

FROM INFORMATION_SCHEMA.TABLES

WHERE TABLE_SCHEMA = 'MONSTERS_INC' and TABLE_TYPE = 'BASE TABLE'

EXECUTE sp_executesql @DropTables;

PRINT '--- TABLAS DROPEADAS CORRECTAMENTE ---';

GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'MONSTERS_INC')
    DROP SCHEMA MONSTERS_INC
GO

CREATE SCHEMA MONSTERS_INC;
GO

PRINT '--- SCHEMA MONSTERS INC CREADO CORRECTAMENTE  ---';

/* SUBCATEGORIA */
CREATE TABLE [MONSTERS_INC].[Subcategoria]
(
    [subc_id] numeric(18) NOT NULL IDENTITY,
    [subc_descripcion] nvarchar(50),
    [subc_categoria_mayor] NUMERIC(18) NOT NULL
);

/* CATEGORIA MAYOR */
CREATE TABLE [MONSTERS_INC].[Categoria_Mayor]
(
    [catm_id] numeric(18) identity NOT NULL,
    [catm_descripcion] nvarchar(50)
);

/* PRODUCTO */
CREATE TABLE [MONSTERS_INC].[Producto]
(
    [prod_id] numeric(18) NOT NULL IDENTITY,
    [prod_subcategoria] numeric(18) NOT NULL,
    [prod_nombre] nvarchar(50),
    [prod_descripcion] nvarchar(50),
    [prod_precio] decimal(18,2),
	[prod_marca] nvarchar(50)
);

/* PROMOCION POR PRODUCTO */
CREATE TABLE [MONSTERS_INC].[Promocion_Por_Producto]
(
    [prom_prod_promocion] numeric(18) NOT NULL,
    [prom_prod_producto] numeric(18) NOT NULL
);

/* PROMOCION */
CREATE TABLE [MONSTERS_INC].[Promocion]
(
    [prom_id] numeric(18) NOT NULL IDENTITY,
    [prom_descripcion] nvarchar(255),
	[prom_fecha_inicio] datetime,
	[prom_fecha_fin] datetime,
	[prom_regla] numeric(18) NOT NULL
);

/* REGLA */
CREATE TABLE [MONSTERS_INC].[Regla]
(
    [reg_id] numeric(18) IDENTITY NOT NULL,
    [reg_descripcion] nvarchar(255) NULL,
	[reg_descuento] decimal(18,0),
    [reg_cantidad_aplicable] decimal(18,0),
    [reg_cantidad_descuento] decimal(18,0),
    [reg_cantidad_max] decimal(18,0),
    [reg_misma_marca] bit,
    [reg_mismo_producto] bit
);


/* SUPERMERCADO */
CREATE TABLE [MONSTERS_INC].[Supermercado]
(
    [super_id] numeric(18) IDENTITY NOT NULL,
    [super_nombre] nvarchar(4) NOT NULL,
    [super_razon_social] nvarchar(23) NOT NULL,
    [super_cuit] nvarchar(13) NOT NULL,
    [super_iibb] nvarchar(14) NOT NULL,
    [super_domicilio] nvarchar(30) NOT NULL,
	[super_localodad] numeric(18) NOT NULL,
	[super_fecha_inicio_actividad] date NOT NULL,
	[super_condicion_fiscal] nvarchar(25) NOT NULL
);

/* SUCURSAL */
CREATE TABLE [MONSTERS_INC].[Sucursal]
(
    [sucu_id] numeric(18) IDENTITY NOT NULL,
    [sucu_numero] nvarchar(17) NOT NULL,
	[sucu_direccion] nvarchar(50) NOT NULL,
	[sucu_localidad] numeric(18) NOT NULL,
	[sucu_supermercado] numeric(18) NOT NULL
);

/* ITEM_TICKET */
CREATE TABLE [MONSTERS_INC].[Item_Ticket]
(
    [item_tick_id] numeric(18) IDENTITY NOT NULL,
    [item_tick_ticket] numeric(18),
	[item_tick_promocion] numeric(18),
    [item_tick_producto] numeric(18),
    [item_tick_cantidad] decimal(18,0),
    [item_tick_total] decimal(18,2),
    [item_tick_descuento_aplicado] decimal(18,2)
);

/* CAJA */
CREATE TABLE [MONSTERS_INC].[Caja]
(
    [caja_id] numeric(18) IDENTITY NOT NULL,
    [caja_tipo] nvarchar(10),
	[caja_sucursal] numeric(18)
);

/* TIPO COMPROBANTE */
CREATE TABLE [MONSTERS_INC].[Tipo_Comprobante]
(
    [tipo_comp_id] numeric(18) NOT NULL IDENTITY,
    [tipo_comp_detalle] char(1)
);

/* DESCUENTO MEDIO PAGO */
CREATE TABLE [MONSTERS_INC].[Descuento_Medio_Pago]
(
    [desc_id] numeric(18) IDENTITY NOT NULL,
    [desc_descripcion] nvarchar(100),
    [desc_medio_pago] numeric(18),
    [desc_fecha_inicio] datetime,
	[desc_fecha_fin] datetime,
	[desc_porcentaje] decimal(18,0),
	[desc_tope] decimal(18,0)
);

/* DESCUENTO MEDIO PAGO APLICADO */
CREATE TABLE [MONSTERS_INC].[Descuento_Medio_Pago_Aplicado]
(
    [desc_apli_id] numeric(18) IDENTITY NOT NULL,
    [desc_apli_pago] numeric(18) IDENTITY NOT NULL,
    [desc_apli_cod_descuento_mp] numeric(18) IDENTITY NOT NULL,
    [desc_apli_descuento_aplicado] decimal(18,2)
);

/* MEDIO PAGO */
CREATE TABLE [MONSTERS_INC].[Medio_Pago]
(
    [medio_pago_id] numeric(18) NOT NULL IDENTITY,
    [medio_pago_tipo] nvarchar(50),
    [medio_pago_nombre] nvarchar(50)
);

/* TARJETA */
CREATE TABLE [MONSTERS_INC].[Tarjeta]
(
    [tarj_id] numeric(18) NOT NULL IDENTITY,
    [tarj_numero] nvarchar(50),
    [tarj_vencimiento_tarjeta] datetime
);

/* DETALLE PAGO */
CREATE TABLE [MONSTERS_INC].[Detalle_Pago]
(
    [deta_id] numeric(18) NOT NULL IDENTITY,
    [deta_cliente] numeric(18) NOT NULL,
    [deta_tarjeta] numeric(18) NOT NULL
);

/* PAGO */
CREATE TABLE [MONSTERS_INC].[Pago]
(
    [pago_id] numeric(18) NOT NULL IDENTITY,
    [pago_fecha] datetime,
    [pago_medio_pago] numeric(18) NOT NULL,
	[pago_detalle] numeric(18),
	[pago_importe] decimal(18,2),
	[pago_ticket] numeric(18)
);

/* ESTADO */
CREATE TABLE [MONSTERS_INC].[Estado]
(
    [esta_id] numeric(18) NOT NULL IDENTITY,
    [esta_descripcion] nvarchar(255),
);

/* ENTREGA */
CREATE TABLE [MONSTERS_INC].[Entrega]
(
    [entr_id] numeric(18) NOT NULL IDENTITY,
    [entr_fecha_hora_entrega] datetime
);

/* ENVIO */
CREATE TABLE [MONSTERS_INC].[Envio]
(
    [envi_id] numeric(18) NOT NULL IDENTITY,
    [envi_ticket_id] numeric(18) NOT NULL,
    [envi_fecha] datetime,
	[envi_hora_inicio] datetime,
	[envi_hora_fin] datetime,
	[envi_cliente] numeric(18) NOT NULL,
	[envi_costo] numeric(18),
	[envi_estado] numeric(18) NOT NULL,
	[envi_entrega] numeric(18)
);

/* CLIENTE */
CREATE TABLE [MONSTERS_INC].[Cliente]
(
    [clie_id] numeric(18) NOT NULL IDENTITY,
    [clie_dni] numeric(18),
    [clie_nombre] nvarchar(50),
	[clie_apellido] nvarchar(50),
	[clie_domicilio] nvarchar(50),
	[clie_localidad] numeric(18),
	[clie_fecha_nacimiento] datetime,
	[clie_fecha_registro] datetime,
	[clie_mail] nvarchar(50),
	[clie_telefono] numeric(18)
);

/* LOCALIDAD */
CREATE TABLE [MONSTERS_INC].[Localidad]
(
    [loca_id] numeric(18) NOT NULL IDENTITY,
    [loca_nombre] nvarchar(50),
	[loca_provincia] numeric(18) NOT NULL 
);

/* PROVINCIA */
CREATE TABLE [MONSTERS_INC].[Provincia]
(
    [prov_id] numeric(18) NOT NULL IDENTITY,
    [prov_nombre] nvarchar(50)
);

/* EMPLEADO */
CREATE TABLE [MONSTERS_INC].[Empleado]
(
    [empl_id] numeric(18) NOT NULL IDENTITY,
    [empl_sucursal] numeric(18) NOT NULL,
    [empl_nombre] nvarchar(50),
	[empl_apellido] nvarchar(50),
	[empl_dni] numeric(18),
	[empl_fecha_registro] datetime,
	[empl_telefono] numeric(18),
	[empl_mail] nvarchar(50),
	[empl_fecha_nacimiento] datetime
);

/* TICKET */
CREATE TABLE [MONSTERS_INC].[Ticket]
(
    [tick_id] numeric(18) NOT NULL IDENTITY,
    [tick_fecha_hora] datetime,
	[tick_caja] numeric(18) NOT NULL,
	[tick_empleado] numeric(18) NOT NULL,
	[tick_tipo_comprobante] numeric(18) NOT NULL,
	[tick_total_productos] decimal(18,2),
	[tick_total_descuento] decimal(18,2),
	[tick_total_descuento_mp] decimal(18,2),
	[tick_total_envio] decimal(18,2),
	[tick_total] decimal(18,2)
);

/* TIPO PAQUETE */
CREATE TABLE [GRUPO_GENERICO].[Tipo_Paquete]
(
    [tipo_paquete_id] nvarchar(50) NOT NULL,
    [tipo_paquete_alto_max] decimal(18,2),
    [tipo_paquete_ancho_max] decimal(18,2),
    [tipo_paquete_largo_max] decimal(18,2),
    [tipo_paquete_peso_max] decimal(18,2),
    [tipo_paquete_precio] decimal(18,2)
);

/* ENVIO MENSAJERIA */
CREATE TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
(
    [env_mensajeria_id] numeric(18) NOT NULL,
    [env_mensajeria_usuario_id] numeric(18) NOT NULL,
    [env_mensajeria_tipo_paquete] nvarchar(50),
    [env_mensajeria_dir_orig] nvarchar(255),
    [env_mensajeria_dir_dest] nvarchar(255),
    [env_mensajeria_localidad_id] numeric(18) NOT NULL,
    [env_mensajeria_valor_asegurado] decimal(18,2),
    [env_mensajeria_precio_envio] decimal(18,2),
    [env_mensajeria_precio_seguro] decimal(18,2),
    [env_mensajeria_propina] decimal(18,2),
    [env_mensajeria_total] decimal(18,2),
    [env_mensajeria_observ] nvarchar(255),
    [env_mensajeria_fecha] datetime,
    [env_mensajeria_fecha_entrega] datetime,
    [env_mensajeria_tiempo_estimado] decimal(18,2),
    [env_mensajeria_calificacion] decimal(18),
    [env_mensajeria_estado_id] numeric(18),
    [env_mensajeria_km] decimal(18,2),
    [env_mensajeria_repartidor] numeric(18) NOT NULL,
    [env_mensajeria_medio_pago] numeric(18) NOT NULL
);

/* ENVIO MENSAJERIA ESTADO */
CREATE TABLE [GRUPO_GENERICO].[Env_mensajeria_estado]
(
    [env_mensajeria_est_id] numeric(18) NOT NULL identity,
    [env_mensajeria_est_descripcion] nvarchar(255)
);

/* TIPO TARJETA */
CREATE TABLE [GRUPO_GENERICO].[Tipo_Tarjeta]
(
    [tipo_tarjeta_id] numeric(8) NOT NULL identity,
    [tipo_tarjeta_nombre] nvarchar(30)
);

/* MARCA TARJETA */
CREATE TABLE [GRUPO_GENERICO].[Marca_Tarjeta]
(
    [marca_tarjeta_id] numeric(8) NOT NULL identity,
    [marca_tarjeta_nombre] nvarchar(30)
);

/* MEDIO PAGO*/
CREATE TABLE [GRUPO_GENERICO].[Medio_Pago]
(
    [medio_pago_id] numeric(18) NOT NULL identity,
    [medio_pago_tipo_id] numeric(18) NOT NULL,
    [medio_pago_tarjeta] numeric(18) NULL
);

/* TIPO MEDIO PAGO */
CREATE TABLE [GRUPO_GENERICO].[Tipo_Medio_Pago]
(
    [tipo_medio_pago_id] numeric(18) NOT NULL IDENTITY,
    [tipo_medio_pago_nombre] nvarchar(30)
);

/* TARJETA */
CREATE TABLE [GRUPO_GENERICO].[Tarjeta]
(
    [tarjeta_id] numeric(18) NOT NULL identity,
    [tarjeta_tipo] numeric(8) NULL,
    [tarjeta_marca] numeric(8) NOT NULL,
    [tarjeta_numero] nvarchar(50),
    [tarjeta_usuario_id] numeric(18) NOT NULL,
    [tarjeta_nombre] nvarchar(50)
);

/* USUARIO */
CREATE TABLE [GRUPO_GENERICO].[Usuario]
(
    [us_id] numeric(18) NOT NULL identity,
    [us_nombre] nvarchar(255),
    [us_apellido] nvarchar(255),
    [us_dni] decimal (18),
    [us_telefono] decimal(18),
    [us_mail] nvarchar(255),
    [us_fecha_registro] datetime2(3),
    [us_fecha_nacimiento] date
);

/* CUPON */
CREATE TABLE [GRUPO_GENERICO].[Cupon]
(
    [cup_numero] numeric(18) NOT NULL,
    [cup_usuario_id] numeric(18) NOT NULL,
    [cup_fecha_alta] datetime,
    [cup_fecha_vencimiento] datetime,
    [cup_monto] decimal(18,2),
    [cup_tipo] numeric(18)
);

/* PEDIDO CUPON */
CREATE TABLE [GRUPO_GENERICO].[Pedido_Cupon]
(
    [ped_cup_cupon_numero] numeric(18) NOT NULL,
    [ped_cup_pedido_numero] numeric(18) NOT NULL,
    [ped_cup_fecha_hora_uso] datetime
);

/* CUPON TIPO  */
CREATE TABLE [GRUPO_GENERICO].[Cupon_Tipo]
(
    [cupon_tipo_id] numeric(18) IDENTITY NOT NULL,
    [cupon_tipo_nombre] nvarchar(50)
);

/* CUPON RECLAMO */
CREATE TABLE [GRUPO_GENERICO].[Cupon_Reclamo]
(
    [cup_rec_numero] numeric(18) NOT NULL,
    [cup_rec_cupon_numero] numeric(18) NOT NULL
);

/* RECLAMO */
CREATE TABLE [GRUPO_GENERICO].[Reclamo]
(
    [reclamo_nro] NUMERIC(18) NOT NULL,
    [reclamo_usuario_id] NUMERIC(18),
    [reclamo_pedido_id] NUMERIC(18),
    [reclamo_tipo_id] NUMERIC(18),
    [reclamo_operador_id] NUMERIC(18),
    [reclamo_estado_id] NUMERIC(18),
    [reclamo_cupon_id] NUMERIC(18),
    [reclamo_descripcion] NVARCHAR(255),
    [reclamo_fecha] DATETIME,
    [reclamo_fecha_solucion] DATETIME,
    [reclamo_solucion] NVARCHAR(255),
    [reclamo_calificacion] DECIMAL(18)
);


/* RECLAMO ESTADO */
CREATE TABLE [GRUPO_GENERICO].[Reclamo_Estado]
(
    [reclamo_estado_id] NUMERIC(18) IDENTITY NOT NULL,
    [reclamo_estado_nombre] NVARCHAR(50)
);


/* RECLAMO TIPO */
CREATE TABLE [GRUPO_GENERICO].[Reclamo_Tipo]
(
    [reclamo_tipo_id] NUMERIC(18) IDENTITY NOT NULL,
    [reclamo_tipo_nombre] NVARCHAR(50)
);


/* OPERADOR RECLAMO */
CREATE TABLE [GRUPO_GENERICO].[Operador_Reclamo]
(
    [operador_rec_id] NUMERIC(18) IDENTITY NOT NULL,
    [operador_rec_nombre] NVARCHAR(255),
    [operador_rec_apellido] NVARCHAR(255),
    [operador_rec_dni] NUMERIC(18),
    [operador_rec_telefono] NUMERIC(18),
    [operador_rec_direccion] NVARCHAR(255),
    [operador_rec_mail] NVARCHAR(255),
    [operador_rec_fecha_nac] DATE
);

/* LOCAL */
CREATE TABLE [GRUPO_GENERICO].[Local]
(
    [local_id] NUMERIC(18) IDENTITY NOT NULL,
    [local_nom] NVARCHAR(100),
    [local_tip] NUMERIC(8) NOT NULL,
    [local_categ] NUMERIC(8) NULL,
    [local_localidad_id] NUMERIC(18) NOT NULL,
    [local_direc] NVARCHAR(255),
    [local_descrip] NVARCHAR(255)
);


/* CATEGORIA LOCAL */
CREATE TABLE [GRUPO_GENERICO].[Categoria_Local]
(
    [cat_id] NUMERIC(8) IDENTITY NOT NULL,
    [cat_nombre] NVARCHAR(50),
    [cat_tipo] NUMERIC(8) NOT NULL
);


/* TIPO LOCAL */
CREATE TABLE [GRUPO_GENERICO].[Tipo_Local]
(
    [tipo_id] NUMERIC(8) IDENTITY NOT NULL,
    [tipo_nombre] NVARCHAR(50)
);


/* HORARIO DIA LOCAL */
CREATE TABLE [GRUPO_GENERICO].[Horario_Dia_Local]
(
    [hordialoc_id] NUMERIC(18) NOT NULL IDENTITY,
    [hordialoc_local_id] NUMERIC(18) NOT NULL,
    [hordialoc_dia] NUMERIC(18) NOT NULL,
    [hordialoc_hora_apertura] DECIMAL(18),
    [hordialoc_hora_cierre] DECIMAL(18)
);

/* CONSTRAINT GENERATION - PRIMARY KEYS */

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT [PK_Pedido] PRIMARY KEY CLUSTERED ([ped_numero] ASC)

ALTER TABLE [GRUPO_GENERICO].[Marca_Tarjeta]
    ADD CONSTRAINT [PK_Marca_Tarjeta] PRIMARY KEY CLUSTERED ([marca_tarjeta_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tarjeta]
    ADD CONSTRAINT [PK_Tarjeta] PRIMARY KEY CLUSTERED ([tarjeta_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tipo_Tarjeta]
    ADD CONSTRAINT [PK_Tipo_Tarjeta] PRIMARY KEY CLUSTERED ([tipo_tarjeta_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [PK_Envio_Mensajeria] PRIMARY KEY CLUSTERED ([env_mensajeria_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Direccion]
    ADD CONSTRAINT [PK_Direccion] PRIMARY KEY CLUSTERED ([dir_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Localidad]
    ADD CONSTRAINT [PK_Localidad] PRIMARY KEY CLUSTERED ([localidad_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Provincia] 
    ADD CONSTRAINT [PK_Provincia] PRIMARY KEY CLUSTERED ([provincia_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tipo_Movilidad] 
    ADD CONSTRAINT [PK_Tipo_Movilidad] PRIMARY KEY CLUSTERED ([tipo_movilidad_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Repartidor] 
    ADD CONSTRAINT [PK_Repartidor] PRIMARY KEY CLUSTERED ([rep_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Rep_Localidad_Activa]
    ADD CONSTRAINT PK_Rep_Localidad_Activa PRIMARY KEY CLUSTERED ([rep_localidad_act_loc_id] ASC, [rep_localidad_act_rep_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Envio]
    ADD CONSTRAINT PK_Envio PRIMARY KEY CLUSTERED ([env_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Pedido_Estado]
    ADD CONSTRAINT PK_Pedido_Estado PRIMARY KEY CLUSTERED ([pedido_estado_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Producto]
    ADD CONSTRAINT PK_Producto_ProductoID PRIMARY KEY CLUSTERED ([prod_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Dia]
    ADD CONSTRAINT PK_Dia_ID PRIMARY KEY CLUSTERED ([dia_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Producto_local]
    ADD CONSTRAINT PK_Producto_Local_ProductoID PRIMARY KEY CLUSTERED ([prod_loc_producto_id] ASC, [prod_loc_local_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Item_Pedido]
    ADD CONSTRAINT PK_Item_Pedido_PedidoNumero PRIMARY KEY ([item_ped_id] ASC,[item_ped_pedido_numero] ASC,[item_ped_prod_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Medio_Pago] 
    ADD CONSTRAINT [PK_Medio_Pago_Id] PRIMARY KEY CLUSTERED ([medio_pago_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Usuario] 
    ADD CONSTRAINT [PK_Us_Id] PRIMARY KEY CLUSTERED ([us_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Cupon] 
    ADD CONSTRAINT [PK_Cupon_Numero] PRIMARY KEY CLUSTERED ([cup_numero] ASC);

ALTER TABLE [GRUPO_GENERICO].[Pedido_Cupon] 
    ADD CONSTRAINT [PK_Ped_Cup_Cupon_Numero] PRIMARY KEY CLUSTERED ([ped_cup_cupon_numero] ASC, [ped_cup_pedido_numero] ASC);

ALTER TABLE [GRUPO_GENERICO].[Cupon_Tipo] 
    ADD CONSTRAINT [PK_Cupon_Tipo_Id] PRIMARY KEY CLUSTERED ([cupon_tipo_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Cupon_Reclamo] 
    ADD CONSTRAINT [PK_Cup_Rec_Cupon_Numero] PRIMARY KEY CLUSTERED ([cup_rec_numero] ASC);

ALTER TABLE [GRUPO_GENERICO].[Reclamo_Estado] 
    ADD CONSTRAINT [PK_Reclamo_Estado] PRIMARY KEY CLUSTERED ([reclamo_estado_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Reclamo_Tipo] 
    ADD CONSTRAINT [PK_Reclamo_Tipo] PRIMARY KEY CLUSTERED ([reclamo_tipo_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Operador_Reclamo] 
    ADD CONSTRAINT [PK_Operador_Reclamo] PRIMARY KEY CLUSTERED ([operador_rec_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tipo_Local] 
    ADD CONSTRAINT [PK_Tipo_Local] PRIMARY KEY CLUSTERED ([tipo_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Horario_Dia_Local] 
    ADD CONSTRAINT [PK_Horario_Dia_Local] PRIMARY KEY CLUSTERED ([hordialoc_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [PK_Reclamo] PRIMARY KEY CLUSTERED ([reclamo_nro] ASC);

ALTER TABLE [GRUPO_GENERICO].[Local] 
    ADD CONSTRAINT [PK_Local] PRIMARY KEY CLUSTERED ([local_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Categoria_Local] 
    ADD CONSTRAINT [PK_Categoria_Local] PRIMARY KEY CLUSTERED ([cat_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tipo_Paquete]
    ADD CONSTRAINT [PK_Tipo_Paquete] PRIMARY KEY CLUSTERED ([tipo_paquete_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Tipo_Medio_Pago]
    ADD CONSTRAINT [PK_Tipo_Medio_Pago] PRIMARY KEY CLUSTERED ([tipo_medio_pago_id] ASC);

ALTER TABLE [GRUPO_GENERICO].[Env_mensajeria_estado]
    ADD CONSTRAINT [PK_Env_Mensajeria_Estado] PRIMARY KEY CLUSTERED ([env_mensajeria_est_id] ASC);

/* CONSTRAINT GENERATION - FOREIGN KEYS */

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_env_mensajeria_localidad_id] FOREIGN KEY ([env_mensajeria_localidad_id])
    REFERENCES [GRUPO_GENERICO].[Localidad]([localidad_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_env_mensajeria_repartidor] FOREIGN KEY ([env_mensajeria_repartidor])
    REFERENCES [GRUPO_GENERICO].[Repartidor]([rep_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_env_mensajeria_medio_pago] FOREIGN KEY ([env_mensajeria_medio_pago])
    REFERENCES [GRUPO_GENERICO].[Medio_Pago]([medio_pago_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_env_mensajeria_usuario_id] FOREIGN KEY ([env_mensajeria_usuario_id])
    REFERENCES [GRUPO_GENERICO].[Usuario]([us_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_env_mensajeria_tipo_paquete] FOREIGN KEY ([env_mensajeria_tipo_paquete])
    REFERENCES [GRUPO_GENERICO].[Tipo_Paquete]([tipo_paquete_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio_Mensajeria]
    ADD CONSTRAINT [FK_Envio_Mensajeria_Estado_Id] FOREIGN KEY ([env_mensajeria_estado_id])
    REFERENCES [GRUPO_GENERICO].[Env_mensajeria_estado](env_mensajeria_est_id);

ALTER TABLE [GRUPO_GENERICO].[Direccion]
    ADD CONSTRAINT [FK_Direccion_dir_localidad_ID] FOREIGN KEY ([dir_localidad_id])
    REFERENCES [GRUPO_GENERICO].[Localidad]([localidad_id]);

ALTER TABLE [GRUPO_GENERICO].[Repartidor] 
    ADD CONSTRAINT [FK_Repartidor_Movilidad] FOREIGN KEY ([rep_tipo_movilidad_id])
    REFERENCES [GRUPO_GENERICO].[Tipo_Movilidad]([tipo_movilidad_id]);

ALTER TABLE [GRUPO_GENERICO].[Rep_Localidad_Activa]
    ADD CONSTRAINT [FK_Rep_Localidad_Activa_Localidad] FOREIGN KEY ([rep_localidad_act_loc_id])
    REFERENCES [GRUPO_GENERICO].[Localidad]([localidad_id]);

ALTER TABLE [GRUPO_GENERICO].[Rep_Localidad_Activa]
    ADD CONSTRAINT [FK_Rep_Localidad_Activa_Repartidor] FOREIGN KEY ([rep_localidad_act_rep_id])
    REFERENCES [GRUPO_GENERICO].[Repartidor]([rep_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio]
    ADD CONSTRAINT FK_Envio_Direccion FOREIGN KEY ([env_dir_id]) 
    REFERENCES [GRUPO_GENERICO].[Direccion]([dir_id]);

ALTER TABLE [GRUPO_GENERICO].[Envio]
    ADD CONSTRAINT FK_Envio_Repartidor FOREIGN KEY ([env_repartidor]) 
    REFERENCES [GRUPO_GENERICO].[Repartidor]([rep_id]);

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT FK_Pedido_Usuario FOREIGN KEY ([ped_usuario]) 
    REFERENCES [GRUPO_GENERICO].[Usuario]([us_id]);

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT FK_Pedido_Local FOREIGN KEY ([ped_local]) 
    REFERENCES [GRUPO_GENERICO].[Local]([local_id]);

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT FK_Pedido_MedPago FOREIGN KEY ([ped_med_pago]) 
    REFERENCES [GRUPO_GENERICO].[Medio_Pago]([medio_pago_id]);

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT FK_Pedido_Envio FOREIGN KEY ([ped_envio]) 
    REFERENCES [GRUPO_GENERICO].[Envio]([env_id]);

ALTER TABLE [GRUPO_GENERICO].[Pedido]
    ADD CONSTRAINT FK_Pedido_Estado FOREIGN KEY ([ped_estado_id]) 
    REFERENCES [GRUPO_GENERICO].[Pedido_Estado]([pedido_estado_id]);

ALTER TABLE [GRUPO_GENERICO].[Producto_local]
    ADD CONSTRAINT FK_Producto_Local_Producto FOREIGN KEY ([prod_loc_producto_id]) 
    REFERENCES [GRUPO_GENERICO].[Producto]([prod_id]);

ALTER TABLE [GRUPO_GENERICO].[Producto_local]
    ADD CONSTRAINT FK_Producto_Local_Local FOREIGN KEY ([prod_loc_local_id]) 
    REFERENCES [GRUPO_GENERICO].[Local]([local_id]);

ALTER TABLE [GRUPO_GENERICO].[Item_Pedido]
    ADD CONSTRAINT FK_Item_Pedido_Pedido FOREIGN KEY ([item_ped_pedido_numero])
    REFERENCES [GRUPO_GENERICO].[Pedido]([ped_numero]);

ALTER TABLE [GRUPO_GENERICO].[Item_Pedido]
    ADD CONSTRAINT FK_Item_Pedido_Producto FOREIGN KEY ([item_ped_prod_id],[item_ped_local_id]) 
    REFERENCES [GRUPO_GENERICO].[Producto_Local]([prod_loc_producto_id], [prod_loc_local_id]);

ALTER TABLE [GRUPO_GENERICO].[Medio_Pago] 
    ADD CONSTRAINT [FK_Medio_Pago_Tipo] FOREIGN KEY (medio_pago_tipo_id) 
    REFERENCES [GRUPO_GENERICO].[Tipo_Medio_Pago]([tipo_medio_pago_id])

ALTER TABLE [GRUPO_GENERICO].[Medio_Pago] 
    ADD CONSTRAINT [FK_Medio_Pago_Tarjeta] FOREIGN KEY (medio_pago_tarjeta) 
    REFERENCES [GRUPO_GENERICO].[Tarjeta]([tarjeta_id])

ALTER TABLE [GRUPO_GENERICO].[Tarjeta] 
    ADD CONSTRAINT [FK_Tarjeta_Tipo] FOREIGN KEY (tarjeta_tipo) 
    REFERENCES [GRUPO_GENERICO].[Tipo_Tarjeta]([tipo_tarjeta_id])

ALTER TABLE [GRUPO_GENERICO].[Tarjeta] 
    ADD CONSTRAINT [FK_Tarjeta_Marca] FOREIGN KEY (tarjeta_marca) 
    REFERENCES [GRUPO_GENERICO].[Marca_Tarjeta]([marca_tarjeta_id])

ALTER TABLE [GRUPO_GENERICO].[Tarjeta] 
    ADD CONSTRAINT [FK_Tarjeta_Usuario] FOREIGN KEY (tarjeta_usuario_id) 
    REFERENCES [GRUPO_GENERICO].[Usuario]([us_id])

ALTER TABLE [GRUPO_GENERICO].[Cupon] 
    ADD CONSTRAINT [FK_Cupon_Usuario] FOREIGN KEY (cup_usuario_id) 
    REFERENCES [GRUPO_GENERICO].[Usuario]([us_id])

ALTER TABLE [GRUPO_GENERICO].[Cupon] 
    ADD CONSTRAINT [FK_Cupon_Tipo] FOREIGN KEY (cup_tipo) 
    REFERENCES [GRUPO_GENERICO].[Cupon_Tipo]([cupon_tipo_id])

ALTER TABLE [GRUPO_GENERICO].[Pedido_Cupon] 
    ADD CONSTRAINT [FK_Ped_Cup_Cupon_Numero] FOREIGN KEY (ped_cup_cupon_numero) 
    REFERENCES [GRUPO_GENERICO].[Cupon]([cup_numero])

ALTER TABLE [GRUPO_GENERICO].[Pedido_Cupon] 
    ADD CONSTRAINT [FK_Ped_Cup_Pedido_Numero] FOREIGN KEY (ped_cup_pedido_numero) 
    REFERENCES [GRUPO_GENERICO].[Pedido]([ped_numero])

ALTER TABLE [GRUPO_GENERICO].[Cupon_Reclamo] 
    ADD CONSTRAINT [FK_Cup_Rec_Cupon_Numero] FOREIGN KEY (cup_rec_cupon_numero) 
    REFERENCES [GRUPO_GENERICO].[Cupon]([cup_numero])

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Usuario] FOREIGN KEY ([reclamo_usuario_id]) 
    REFERENCES [GRUPO_GENERICO].[Usuario]([us_id]);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Pedido] FOREIGN KEY ([reclamo_pedido_id]) 
    REFERENCES [GRUPO_GENERICO].[Pedido]([ped_numero]);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Tipo] FOREIGN KEY ([reclamo_tipo_id]) 
    REFERENCES [GRUPO_GENERICO].[Reclamo_Tipo]([reclamo_tipo_id]);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Operador] FOREIGN KEY ([reclamo_operador_id]) 
    REFERENCES [GRUPO_GENERICO].[Operador_Reclamo]([operador_rec_id]);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Estado] FOREIGN KEY ([reclamo_estado_id]) 
    REFERENCES [GRUPO_GENERICO].[Reclamo_Estado]([reclamo_estado_id]);

ALTER TABLE [GRUPO_GENERICO].[Reclamo] 
    ADD CONSTRAINT [FK_Reclamo_Cupon] FOREIGN KEY ([reclamo_cupon_id]) 
    REFERENCES [GRUPO_GENERICO].[Cupon_Reclamo]([cup_rec_numero]);

ALTER TABLE [GRUPO_GENERICO].[Local] 
    ADD CONSTRAINT [FK_Local_Tipo_Local] FOREIGN KEY ([local_tip]) 
    REFERENCES [GRUPO_GENERICO].[Tipo_Local]([tipo_id]);

ALTER TABLE [GRUPO_GENERICO].[Local] 
    ADD CONSTRAINT [FK_Local_Categoria_Local] FOREIGN KEY ([local_categ]) 
    REFERENCES [GRUPO_GENERICO].[Categoria_Local]([cat_id]);

ALTER TABLE [GRUPO_GENERICO].[Local] 
    ADD CONSTRAINT [FK_Local_Localidad] FOREIGN KEY ([local_localidad_id]) 
    REFERENCES [GRUPO_GENERICO].[Localidad]([localidad_id]);

ALTER TABLE [GRUPO_GENERICO].[Categoria_Local] 
    ADD CONSTRAINT [FK_Categoria_Local_Tipo_Local] FOREIGN KEY ([cat_tipo]) 
    REFERENCES [GRUPO_GENERICO].[Tipo_Local]([tipo_id]);

ALTER TABLE [GRUPO_GENERICO].[Horario_Dia_Local] 
    ADD CONSTRAINT [FK_Horario_Dia_Local_Local] FOREIGN KEY ([hordialoc_local_id]) 
    REFERENCES [GRUPO_GENERICO].[Local]([local_id]);

ALTER TABLE [GRUPO_GENERICO].[Horario_Dia_Local] 
    ADD CONSTRAINT [FK_Horario_Dia_Local_Dia] FOREIGN KEY ([hordialoc_dia]) 
    REFERENCES [GRUPO_GENERICO].[Dia]([dia_id]);

ALTER TABLE [GRUPO_GENERICO].[Localidad] 
    ADD CONSTRAINT [FK_Localidad_Provincia] FOREIGN KEY ([localidad_provincia_id]) 
    REFERENCES [GRUPO_GENERICO].[Provincia]([provincia_id]);


PRINT '--- TABLAS CREADAS CORRECTAMENTE ---';
GO

/* --- MIGRACION DE DATOS ---*/

/* DATOS TIPO MOVILIDAD */


CREATE PROCEDURE [GRUPO_GENERICO].Migrar_Tipo_Movilidad
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].[Tipo_Movilidad]
        (tipo_movilidad_descripcion, tipo_movilidad_nombre)
    SELECT DISTINCT M.REPARTIDOR_TIPO_MOVILIDAD, M.REPARTIDOR_TIPO_MOVILIDAD
    FROM gd_esquema.Maestra AS M
    WHERE M.REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL
END
GO

/* DATOS PROVINCIAS */

CREATE PROCEDURE [GRUPO_GENERICO].Migrar_Provincia
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].[Provincia]
        (provincia_nombre)
    SELECT DISTINCT provincia_nombre
    from(
        SELECT LOCAL_PROVINCIA as provincia_nombre
            FROM gd_esquema.Maestra
            where LOCAL_PROVINCIA IS NOT NULL
        UNION
            SELECT DIRECCION_USUARIO_PROVINCIA as provincia_nombre
            from gd_esquema.Maestra
            where DIRECCION_USUARIO_PROVINCIA IS NOT NULL
        UNION
            SELECT ENVIO_MENSAJERIA_PROVINCIA as provincia_nombre
            FROM gd_esquema.Maestra
            where ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
    ) as subquery;

END
GO

/* DATOS PEDIDO ESTADO */

CREATE PROCEDURE [GRUPO_GENERICO].Migrar_Pedido_Estado
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].Pedido_Estado
        (pedido_estado_nombre)
    SELECT DISTINCT M.PEDIDO_ESTADO
    FROM gd_esquema.Maestra AS M
    WHERE M.PEDIDO_ESTADO IS NOT NULL
END
GO

/* DATOS PRODUCTOS */

CREATE PROCEDURE [GRUPO_GENERICO].Migrar_Producto
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].Producto
        (prod_id, prod_nombre, prod_descripcion)
    SELECT DISTINCT M.PRODUCTO_LOCAL_CODIGO, M.PRODUCTO_LOCAL_NOMBRE, M.PRODUCTO_LOCAL_DESCRIPCION
    FROM gd_esquema.Maestra AS M
    WHERE M.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO

/* DATOS DIAS */

CREATE PROCEDURE [GRUPO_GENERICO].Migrar_dia
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].Dia
        (dia_nombre)
    SELECT DISTINCT HORARIO_LOCAL_DIA
    from gd_esquema.Maestra
    WHERE HORARIO_LOCAL_DIA IS NOT NULL
END
GO

/* LOCALIDAD */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Localidad
AS
BEGIN
    INSERT INTO [GRUPO_GENERICO].[Localidad]
        (localidad_nombre, localidad_provincia_id)
    SELECT DISTINCT localidad_nombre, provincia_id
    from(
       SELECT ENVIO_MENSAJERIA_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    provincia_id
                from [GRUPO_GENERICO].Provincia
                where provincia_nombre = ENVIO_MENSAJERIA_PROVINCIA) as provincia_id
            FROM gd_esquema.Maestra
            where ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
        UNION
            SELECT DIRECCION_USUARIO_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    provincia_id
                from [GRUPO_GENERICO].Provincia
                where provincia_nombre =  DIRECCION_USUARIO_PROVINCIA) as provincia_id
            from gd_esquema.Maestra
            where DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
        UNION
            SELECT LOCAL_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    provincia_id
                from [GRUPO_GENERICO].Provincia
                where provincia_nombre =  LOCAL_PROVINCIA) as provincia_id
            FROM gd_esquema.Maestra
            where LOCAL_LOCALIDAD IS NOT NULL
    ) as subquery;
END
GO

/* DATOS USUARIO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Usuario
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Usuario]
        (us_nombre, us_apellido, us_dni, us_telefono, us_mail, us_fecha_registro, us_fecha_nacimiento)
    SELECT DISTINCT USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_TELEFONO, USUARIO_MAIL, USUARIO_FECHA_REGISTRO, USUARIO_FECHA_NAC
    FROM gd_esquema.Maestra
    WHERE USUARIO_DNI IS NOT NULL
END
GO


/* DATOS DIRECCION */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Direccion
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Direccion]
        (dir_direccion,dir_nombre, dir_usuario_id, dir_localidad_id)
    SELECT DISTINCT M.DIRECCION_USUARIO_DIRECCION, M.DIRECCION_USUARIO_NOMBRE,
        ( select top 1
            us_id
        from [GRUPO_GENERICO].[Usuario]
        where us_dni = M.USUARIO_DNI ) as USUARIO_ID,
        ( select top 1
            localidad_id
        from [GRUPO_GENERICO].[Localidad]
        where localidad_nombre = M.DIRECCION_USUARIO_LOCALIDAD
            and localidad_provincia_id = (select top 1
                provincia_id
            from [GRUPO_GENERICO].Provincia
            where provincia_nombre = M.DIRECCION_USUARIO_PROVINCIA )) as LOCALIDAD_ID
    from gd_esquema.Maestra as M
    where M.DIRECCION_USUARIO_DIRECCION IS NOT NULL
        AND ( select top 1
            us_id
        from [GRUPO_GENERICO].[Usuario]
        where us_dni = M.USUARIO_DNI ) IS NOT NULL
END
GO

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Tipo_Paquete
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Tipo_Paquete]
        (tipo_paquete_id, tipo_paquete_alto_max, tipo_paquete_ancho_max, tipo_paquete_largo_max, tipo_paquete_peso_max, tipo_paquete_precio)
    SELECT DISTINCT PAQUETE_TIPO, PAQUETE_ALTO_MAX, PAQUETE_ANCHO_MAX, PAQUETE_LARGO_MAX, PAQUETE_PESO_MAX, PAQUETE_TIPO_PRECIO
    FROM gd_esquema.Maestra
    WHERE PAQUETE_TIPO IS NOT NULL

END
GO

/* DATOS PRODUCTO LOCAL */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Producto_Local
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Producto_Local]
        (prod_loc_local_id, prod_loc_producto_id, prod_loc_precio)
    SELECT DISTINCT L.local_id, P.prod_id, M.PRODUCTO_LOCAL_PRECIO
    FROM gd_esquema.Maestra AS M
        INNER JOIN GRUPO_GENERICO.[Local] AS L ON L.local_nom = M.LOCAL_NOMBRE
        INNER JOIN GRUPO_GENERICO.Producto AS P ON P.prod_nombre = M.PRODUCTO_LOCAL_NOMBRE
    WHERE M.PRODUCTO_LOCAL_NOMBRE IS NOT NULL AND M.LOCAL_NOMBRE IS NOT NULL
    ORDER BY local_id;

END 
GO

/* DATOS ITEM PEDIDO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Item_Pedido
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Item_Pedido]
        (item_ped_pedido_numero, item_ped_prod_id, item_ped_local_id, item_ped_cantidad, item_ped_precio)
    SELECT
        PEDIDO_NRO,
        ( select top 1
            P.prod_id
        from GRUPO_GENERICO.[Producto] as P
        where P.prod_nombre = M.PRODUCTO_LOCAL_NOMBRE),
        ( select top 1
            local_id
        from GRUPO_GENERICO.[Local]
        where local_nombre = M.LOCAL_NOMBRE),
        PRODUCTO_CANTIDAD,
        PRODUCTO_LOCAL_PRECIO
    FROM gd_esquema.Maestra as M
    WHERE M.PEDIDO_NRO is not null
        AND producto_local_precio is not null
    ORDER BY PEDIDO_NRO

END
GO

/* DATOS RECLAMO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Reclamo
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Reclamo]
        (reclamo_nro, reclamo_calificacion, reclamo_descripcion, reclamo_fecha, reclamo_fecha_solucion, reclamo_solucion,
        reclamo_usuario_id, reclamo_pedido_id, reclamo_tipo_id, reclamo_operador_id, reclamo_estado_id, reclamo_cupon_id)
    SELECT DISTINCT RECLAMO_NRO, RECLAMO_CALIFICACION, RECLAMO_DESCRIPCION, RECLAMO_FECHA, RECLAMO_FECHA_SOLUCION, RECLAMO_SOLUCION,
        (SELECT TOP 1
            us_id
        FROM [GRUPO_GENERICO].[Usuario]
        WHERE us_dni = USUARIO_DNI),
        (SELECT TOP 1
            ped_numero
        FROM [GRUPO_GENERICO].[Pedido]
        WHERE ped_numero = PEDIDO_NRO),
        (SELECT TOP 1
            reclamo_tipo_id
        FROM [GRUPO_GENERICO].[Reclamo_Tipo]
        WHERE reclamo_tipo_nombre = RECLAMO_TIPO),
        (SELECT TOP 1
            operador_rec_id
        FROM [GRUPO_GENERICO].[Operador_Reclamo]
        WHERE operador_rec_dni = OPERADOR_RECLAMO_DNI),
        (SELECT TOP 1
            reclamo_estado_id
        FROM [GRUPO_GENERICO].[Reclamo_Estado]
        WHERE reclamo_estado_nombre = RECLAMO_ESTADO),
        (SELECT TOP 1
            cup_rec_numero
        FROM [GRUPO_GENERICO].[Cupon_Reclamo]
        WHERE cup_rec_numero = CUPON_RECLAMO_NRO)
    FROM gd_esquema.Maestra
    WHERE RECLAMO_NRO IS NOT NULL

END
GO

/* DATOS RECLAMO_ESTADO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Reclamo_Estado
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Reclamo_Estado]
        (reclamo_estado_nombre)
    SELECT DISTINCT RECLAMO_ESTADO
    FROM gd_esquema.Maestra
    WHERE RECLAMO_ESTADO IS NOT NULL

END
GO

/* DATOS RECLAMO_TIPO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Reclamo_Tipo
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Reclamo_Tipo]
        (reclamo_tipo_nombre)
    SELECT DISTINCT RECLAMO_TIPO
    FROM gd_esquema.Maestra
    WHERE RECLAMO_TIPO IS NOT NULL

END
GO

/* DATOS OPERADOR_RECLAMO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Operador_Reclamo
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Operador_Reclamo]
        (operador_rec_nombre,operador_rec_apellido, operador_rec_dni,
        operador_rec_telefono, operador_rec_direccion, operador_rec_mail, operador_rec_fecha_nac)
    SELECT DISTINCT OPERADOR_RECLAMO_NOMBRE, OPERADOR_RECLAMO_APELLIDO, OPERADOR_RECLAMO_DNI, OPERADOR_RECLAMO_TELEFONO,
        OPERADOR_RECLAMO_DIRECCION, OPERADOR_RECLAMO_MAIL, OPERADOR_RECLAMO_FECHA_NAC
    FROM gd_esquema.Maestra
    WHERE OPERADOR_RECLAMO_NOMBRE IS NOT NULL

END
GO

/* DATOS LOCAL */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Local
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Local]
        (local_nom, local_descrip, local_direc, local_tip, local_categ, local_localidad_id)
    SELECT DISTINCT LOCAL_NOMBRE, LOCAL_DESCRIPCION, LOCAL_DIRECCION,
        (SELECT TOP 1
            tipo_id
        FROM [GRUPO_GENERICO].[Tipo_Local]
        WHERE tipo_nombre = LOCAL_TIPO),
        (SELECT TOP 1
            cat_id
        FROM [GRUPO_GENERICO].[Categoria_Local]
        WHERE cat_nombre = LOCAL_TIPO),
        (SELECT TOP 1
            localidad_id
        FROM [GRUPO_GENERICO].[Localidad]
        WHERE localidad_nombre = LOCAL_LOCALIDAD AND
            localidad_provincia_id = (SELECT TOP 1
                provincia_id
            FROM [GRUPO_GENERICO].[Provincia]
            WHERE provincia_nombre = LOCAL_PROVINCIA))
    FROM gd_esquema.Maestra
    WHERE LOCAL_NOMBRE IS NOT NULL

END
GO

/* DATOS CATEGORIA_LOCAL */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Categoria_Local
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria Parrilla', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Restaurante'))

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria Heladeria', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Restaurante'))

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria ComidasRapidas', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Restaurante'))

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria Minimercado', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Mercado'))

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria Kiosco', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Mercado'))

    INSERT INTO GRUPO_GENERICO.[Categoria_Local]
        (cat_nombre, cat_tipo)
    VALUES
        ('Categoria Supermercado', (SELECT TOP 1
                tipo_id
            FROM [GRUPO_GENERICO].[Tipo_Local]
            WHERE tipo_nombre = 'Tipo Local Mercado'))

END
GO

/* DATOS TIPO_LOCAL */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Tipo_Local
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Tipo_Local]
        (tipo_nombre)
    SELECT DISTINCT LOCAL_TIPO
    FROM gd_esquema.Maestra
    WHERE LOCAL_TIPO IS NOT NULL

END
GO

/* DATOS HORARIO_DIA_LOCAL */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Horario_Dia_Local
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Horario_Dia_Local]
        (hordialoc_hora_apertura, hordialoc_hora_cierre, hordialoc_local_id, hordialoc_dia)
    SELECT DISTINCT HORARIO_LOCAL_HORA_APERTURA, HORARIO_LOCAL_HORA_CIERRE,
        (SELECT TOP 1
            local_id
        FROM [GRUPO_GENERICO].[Local]
        WHERE local_nom+local_direc = LOCAL_NOMBRE+LOCAL_DIRECCION),
        (SELECT TOP 1
            dia_id
        FROM [GRUPO_GENERICO].[Dia]
        WHERE dia_nombre = HORARIO_LOCAL_DIA)
    FROM gd_esquema.Maestra
    WHERE HORARIO_LOCAL_HORA_APERTURA IS NOT NULL 
END
GO

/* DATOS TIPO TARJETA */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Tipo_Tarjeta
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Tipo_Tarjeta]
        (tipo_tarjeta_nombre)
    select distinct [tipo_medio_pago_nombre] = SUBSTRING(medio_pago_tipo, CHARINDEX(' ', medio_pago_tipo) + 1, LEN(medio_pago_tipo))
    FROM gd_esquema.Maestra AS M
    where medio_pago_tipo Like 'Tarjeta%';
END
GO

/* DATOS MARCA TARJETA */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Marca_Tarjeta
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Marca_Tarjeta]
        (marca_tarjeta_nombre)
    SELECT DISTINCT MARCA_TARJETA
    FROM gd_esquema.Maestra
    WHERE MARCA_TARJETA is not null
END
GO

/* DATOS TARJETA */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Tarjeta
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Tarjeta]
        (tarjeta_numero, tarjeta_usuario_id, tarjeta_tipo, tarjeta_marca)
    SELECT DISTINCT M.MEDIO_PAGO_NRO_TARJETA,
        ( SELECT TOP 1
            us_id
        from [GRUPO_GENERICO].[Usuario]
        where us_dni = M.USUARIO_DNI
        ),
        ( SELECT TOP 1
            tipo_tarjeta_id
        FROM [GRUPO_GENERICO].Tipo_Tarjeta
        WHERE M.MEDIO_PAGO_TIPO LIKE '%' + tipo_tarjeta_nombre + '%'
        ),
        ( SELECT TOP 1
            marca_tarjeta_id
        FROM [GRUPO_GENERICO].Marca_Tarjeta
        WHERE marca_tarjeta_nombre = M.MARCA_TARJETA
        )
    FROM gd_esquema.Maestra as M
    WHERE M.MEDIO_PAGO_NRO_TARJETA IS NOT NULL
END
GO

/* DATOS TIPO MEDIO DE PAGO */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Tipo_Medio_Pago
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Tipo_Medio_Pago]
        (tipo_medio_pago_nombre)
    VALUES
        ('Efectivo'),
        ('Tarjeta')
END
GO

/* DATOS MEDIO PAGO */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Medio_Pago
AS
BEGIN

    INSERT INTO GRUPO_GENERICO.[Medio_Pago]
        (medio_pago_tipo_id, medio_pago_tarjeta)
    select distinct
        ( select top 1
            tipo_medio_pago_id
        from GRUPO_GENERICO.Tipo_Medio_Pago as T
        where M.medio_pago_tipo like  t.tipo_medio_pago_nombre + '%' ),
        ( select top 1
            tarjeta_id
        from GRUPO_GENERICO.Tarjeta as T
        where T.tarjeta_numero =  M.medio_pago_nro_tarjeta )
    from gd_esquema.Maestra as M

END
GO

/* DATOS CUPON */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Cupon
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Cupon]
        (cup_numero, cup_fecha_alta, cup_fecha_vencimiento, cup_monto, cup_usuario_id, cup_tipo)
    SELECT DISTINCT CUPON_NRO, CUPON_FECHA_ALTA, CUPON_FECHA_VENCIMIENTO, CUPON_MONTO,
        ( SELECT TOP 1
            us_id
        from [GRUPO_GENERICO].[Usuario]
        where us_dni = USUARIO_DNI
        ),
        ( SELECT TOP 1
            cupon_tipo_id
        from [GRUPO_GENERICO].[Cupon_Tipo]
        where cupon_tipo_nombre = CUPON_TIPO
        )
    FROM gd_esquema.Maestra
    WHERE CUPON_NRO IS NOT NULL
END
GO

/* DATOS CUPON TIPO */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Cupon_Tipo
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Cupon_Tipo]
        (cupon_tipo_nombre)
    SELECT DISTINCT CUPON_TIPO
    FROM gd_esquema.Maestra
    WHERE CUPON_TIPO IS NOT NULL
END
GO

/* DATOS CUPON_RECLAMO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Cupon_Reclamo
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Cupon]
        (cup_fecha_alta, cup_fecha_vencimiento, cup_monto, cup_usuario_id, cup_tipo, cup_numero)
    SELECT DISTINCT CUPON_RECLAMO_FECHA_ALTA, CUPON_RECLAMO_FECHA_VENCIMIENTO, CUPON_RECLAMO_MONTO,
        (SELECT TOP 1
            us_id
        FROM [GRUPO_GENERICO].[Usuario]
        WHERE us_dni = USUARIO_DNI),
        (SELECT TOP 1
            cupon_tipo_id
        FROM [GRUPO_GENERICO].[Cupon_Tipo]
        WHERE cupon_tipo_nombre = CUPON_RECLAMO_TIPO),
        row_number() OVER (ORDER BY (SELECT NULL)) + (SELECT MAX(cup_numero)
        FROM GRUPO_GENERICO.[Cupon])as ID
    FROM gd_esquema.Maestra
    WHERE CUPON_RECLAMO_MONTO IS NOT NULL

    INSERT INTO GRUPO_GENERICO.[Cupon_Reclamo]
        (cup_rec_numero, cup_rec_cupon_numero)
    SELECT DISTINCT 
        CUPON_RECLAMO_NRO,
        (SELECT TOP 1
            cup_numero
        FROM GRUPO_GENERICO.[Cupon]
        WHERE cup_fecha_alta+cup_fecha_vencimiento+cup_monto = CUPON_RECLAMO_FECHA_ALTA+CUPON_RECLAMO_FECHA_VENCIMIENTO+CUPON_RECLAMO_MONTO)
    FROM gd_esquema.Maestra
    WHERE CUPON_RECLAMO_NRO IS NOT NULL
END
GO

/* DATOS ENVIO_MENSAJERIA */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Envio_Mensajeria
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Envio_Mensajeria]
        (env_mensajeria_id, env_mensajeria_dir_orig, env_mensajeria_dir_dest, env_mensajeria_valor_asegurado,
        env_mensajeria_precio_envio, env_mensajeria_precio_seguro, env_mensajeria_propina, env_mensajeria_total, env_mensajeria_observ, env_mensajeria_fecha,
        env_mensajeria_fecha_entrega, env_mensajeria_tiempo_estimado, env_mensajeria_calificacion, env_mensajeria_km,
        env_mensajeria_usuario_id, env_mensajeria_tipo_paquete, env_mensajeria_localidad_id, env_mensajeria_repartidor, env_mensajeria_medio_pago, env_mensajeria_estado_id)
    SELECT DISTINCT ENVIO_MENSAJERIA_NRO, ENVIO_MENSAJERIA_DIR_ORIG, ENVIO_MENSAJERIA_DIR_DEST, ENVIO_MENSAJERIA_VALOR_ASEGURADO,
        ENVIO_MENSAJERIA_PRECIO_ENVIO, ENVIO_MENSAJERIA_PRECIO_SEGURO, ENVIO_MENSAJERIA_PROPINA, ENVIO_MENSAJERIA_TOTAL,
        ENVIO_MENSAJERIA_OBSERV, ENVIO_MENSAJERIA_FECHA, ENVIO_MENSAJERIA_FECHA_ENTREGA, ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
        ENVIO_MENSAJERIA_CALIFICACION, ENVIO_MENSAJERIA_KM,
        (SELECT TOP 1
            us_id
        FROM [GRUPO_GENERICO].[Usuario]
        WHERE us_dni = USUARIO_DNI),
        (SELECT TOP 1
            tipo_paquete_id
        FROM [GRUPO_GENERICO].[Tipo_Paquete]
        WHERE tipo_paquete_id = PAQUETE_TIPO),
        (SELECT TOP 1
            localidad_id
        FROM [GRUPO_GENERICO].[Localidad]
        WHERE localidad_nombre = ENVIO_MENSAJERIA_LOCALIDAD AND
            localidad_provincia_id = (SELECT TOP 1
                provincia_id
            FROM [GRUPO_GENERICO].[Provincia]
            WHERE provincia_nombre = ENVIO_MENSAJERIA_PROVINCIA)),
        (SELECT TOP 1
            rep_id
        FROM [GRUPO_GENERICO].[Repartidor]
        WHERE rep_dni = REPARTIDOR_DNI),
        (SELECT TOP 1
            medio_pago_id
        FROM [GRUPO_GENERICO].[Medio_Pago]
        WHERE medio_pago_tipo_id = (SELECT TOP 1
                tipo_medio_pago_id
            FROM [GRUPO_GENERICO].[Tipo_Medio_Pago]
            WHERE MEDIO_PAGO_TIPO LIKE tipo_medio_pago_nombre+'%')
            AND medio_pago_tarjeta = (SELECT TOP 1
                tarjeta_id
            FROM [GRUPO_GENERICO].[Tarjeta]
            WHERE tarjeta_numero = MEDIO_PAGO_NRO_TARJETA)),
        (SELECT TOP 1
            env_mensajeria_est_id
            FROM [GRUPO_GENERICO].[Env_mensajeria_estado]
            WHERE env_mensajeria_est_descripcion = ENVIO_MENSAJERIA_ESTADO
        )
    FROM gd_esquema.Maestra
    WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL
END
GO

/* DATOS ESTADO ENVIO MENSAJERIA */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Estado_Env_Mensajeria
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Env_mensajeria_estado]
        (env_mensajeria_est_descripcion)
    SELECT DISTINCT ENVIO_MENSAJERIA_ESTADO
    FROM gd_esquema.Maestra
    WHERE ENVIO_MENSAJERIA_ESTADO IS NOT NULL
END
GO

/* DATOS PEDIDO */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Pedido
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Pedido]
        (ped_numero, ped_fechahora, ped_usuario, ped_local, ped_tarifa_servicio, ped_total_productos, ped_total_cupones, ped_total_servicio,
        ped_med_pago, ped_observ, ped_envio, ped_estado_id, ped_tiempo_est, ped_fecha_hora_entrega, ped_calificacion)
    SELECT DISTINCT
        M.PEDIDO_NRO,
        M.PEDIDO_FECHA,
        U.us_id,
        L.local_id,
        M.PEDIDO_TARIFA_SERVICIO,
        M.PEDIDO_TOTAL_PRODUCTOS,
        M.PEDIDO_TOTAL_CUPONES,
        M.PEDIDO_TOTAL_SERVICIO,
        (SELECT TOP 1
            medio_pago_id
        FROM [GRUPO_GENERICO].[Medio_Pago]
        WHERE medio_pago_tipo_id = (SELECT TOP 1
                tipo_medio_pago_id
            FROM [GRUPO_GENERICO].[Tipo_Medio_Pago]
            WHERE M.MEDIO_PAGO_TIPO LIKE tipo_medio_pago_nombre+'%')
            AND medio_pago_tarjeta = (SELECT TOP 1
                tarjeta_id
            FROM [GRUPO_GENERICO].[Tarjeta]
            WHERE tarjeta_numero = M.MEDIO_PAGO_NRO_TARJETA)),
        M.PEDIDO_OBSERV,
        EN.env_id,
        E.pedido_estado_id,
        M.PEDIDO_TIEMPO_ESTIMADO_ENTREGA,
        M.PEDIDO_FECHA_ENTREGA,
        M.PEDIDO_CALIFICACION
    FROM gd_esquema.Maestra as M
        INNER JOIN GRUPO_GENERICO.[Usuario] AS U on U.us_dni = M.USUARIO_DNI
        INNER JOIN GRUPO_GENERICO.[Local] AS L on L.local_nom = M.LOCAL_NOMBRE
        INNER JOIN GRUPO_GENERICO.[Pedido_Estado] AS E on E.pedido_estado_nombre = M.PEDIDO_ESTADO
        LEFT JOIN GRUPO_GENERICO.[Envio] AS EN on EN.env_pedido_id = M.PEDIDO_NRO
    WHERE M.PEDIDO_NRO IS NOT NULL
    ORDER BY M.PEDIDO_NRO

END
GO

/* DATOS REPARTIDOR */
CREATE PROCEDURE GRUPO_GENERICO.Migrar_Repartidor
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Repartidor]
        (rep_nombre, rep_apellido, rep_dni, rep_telefono, rep_mail, rep_fecha_nacimiento,
         rep_tipo_movilidad_id, rep_direccion)
    SELECT DISTINCT REPARTIDOR_NOMBRE, REPARTIDOR_APELLIDO, REPARTIDOR_DNI, REPARTIDOR_TELEFONO, REPARTIDOR_EMAIL, REPARTIDOR_FECHA_NAC,
        (SELECT TOP 1
            tipo_movilidad_id
        FROM [GRUPO_GENERICO].[Tipo_Movilidad]
        WHERE tipo_movilidad_nombre = REPARTIDOR_TIPO_MOVILIDAD),
        REPARTIDOR_DIRECION
    FROM gd_esquema.Maestra
    WHERE REPARTIDOR_DNI IS NOT NULL
END
GO

/* DATOS REP_LOCALIDAD_ACTIVA */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Rep_Localidad_Activa
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Rep_Localidad_Activa]
        (rep_localidad_act_loc_id, rep_localidad_act_rep_id)
    SELECT DISTINCT
        L.localidad_id,
        R.rep_id
    FROM gd_esquema.Maestra AS M
    INNER JOIN [GRUPO_GENERICO].[Localidad] as L 
        on L.localidad_nombre = ( SELECT TOP 1 LOCAL_LOCALIDAD
            FROM gd_esquema.Maestra
            WHERE REPARTIDOR_DNI = M.REPARTIDOR_DNI
            ORDER BY PEDIDO_FECHA DESC )
            INNER JOIN [GRUPO_GENERICO].[Provincia] as P on 
            P.provincia_nombre = ( SELECT TOP 1 LOCAL_PROVINCIA
            FROM gd_esquema.Maestra
            WHERE REPARTIDOR_DNI = M.REPARTIDOR_DNI
            ORDER BY PEDIDO_FECHA DESC ) and L.localidad_provincia_id = P.provincia_id
    INNER JOIN GRUPO_GENERICO.Repartidor AS R
        ON R.rep_dni = M.REPARTIDOR_DNI
    WHERE M.LOCAL_LOCALIDAD IS NOT NULL AND M.REPARTIDOR_DNI is not null
END
GO


/* DATOS ENVIO */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Envio
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Envio]
        (env_dir_id, env_precio, env_propina, env_repartidor, env_pedido_id)
    SELECT DISTINCT
        (SELECT TOP 1
            dir_id
        FROM [GRUPO_GENERICO].[Direccion]
        WHERE dir_usuario_id = (SELECT TOP 1
                us_id
            FROM [GRUPO_GENERICO].[Usuario]
            WHERE us_dni = USUARIO_DNI)
            AND dir_nombre = DIRECCION_USUARIO_NOMBRE),
        PEDIDO_PRECIO_ENVIO,
        PEDIDO_PROPINA,
        (SELECT TOP 1
            rep_id
        FROM [GRUPO_GENERICO].[Repartidor]
        WHERE rep_dni = REPARTIDOR_DNI),
        PEDIDO_NRO
    FROM gd_esquema.Maestra
    WHERE PEDIDO_PRECIO_ENVIO IS NOT NULL
END
GO

/* DATOS PEDIDO_CUPON */

CREATE PROCEDURE GRUPO_GENERICO.Migrar_Pedido_Cupon
AS
BEGIN
    INSERT INTO GRUPO_GENERICO.[Pedido_Cupon]
        (ped_cup_cupon_numero, ped_cup_pedido_numero, ped_cup_fecha_hora_uso)
    SELECT DISTINCT CUPON_NRO, PEDIDO_NRO, PEDIDO_FECHA
    FROM gd_esquema.Maestra
    WHERE CUPON_NRO IS NOT NULL AND PEDIDO_NRO IS NOT NULL
END
GO

/* EJECUCIONES */

PRINT '--- COMENZANDO LA MIGRACION DE DATOS ---'

/* Tablas primarias sin FK */
execute GRUPO_GENERICO.[Migrar_Tipo_Movilidad]
execute GRUPO_GENERICO.[Migrar_Tipo_Paquete]
execute GRUPO_GENERICO.[Migrar_Provincia]
execute GRUPO_GENERICO.[Migrar_Tipo_Tarjeta]
execute GRUPO_GENERICO.[Migrar_Marca_Tarjeta]
execute GRUPO_GENERICO.[Migrar_Pedido_Estado]
execute GRUPO_GENERICO.[Migrar_Tipo_Medio_Pago]
execute GRUPO_GENERICO.[Migrar_Usuario]
execute GRUPO_GENERICO.[Migrar_Cupon_Tipo]
execute GRUPO_GENERICO.[Migrar_Reclamo_Estado]
execute GRUPO_GENERICO.[Migrar_Reclamo_Tipo]
execute GRUPO_GENERICO.[Migrar_Operador_Reclamo]
execute GRUPO_GENERICO.[Migrar_Producto]
execute GRUPO_GENERICO.[Migrar_Dia]
execute GRUPO_GENERICO.[Migrar_Tipo_Local]
execute GRUPO_GENERICO.[Migrar_Estado_Env_Mensajeria]


/* Tablas con FK */
execute GRUPO_GENERICO.[Migrar_Categoria_Local]
execute GRUPO_GENERICO.[Migrar_Localidad]
execute GRUPO_GENERICO.[Migrar_Direccion]
execute GRUPO_GENERICO.[Migrar_Repartidor]
execute GRUPO_GENERICO.[Migrar_Rep_Localidad_Activa]
execute GRUPO_GENERICO.[Migrar_Local]
execute GRUPO_GENERICO.[Migrar_Horario_Dia_Local]
execute GRUPO_GENERICO.[Migrar_Producto_Local]
execute GRUPO_GENERICO.[Migrar_Cupon]
execute GRUPO_GENERICO.[Migrar_Cupon_Reclamo] 
execute GRUPO_GENERICO.[Migrar_Envio]
execute GRUPO_GENERICO.[Migrar_Tarjeta]
execute GRUPO_GENERICO.[Migrar_Medio_Pago]
execute GRUPO_GENERICO.[Migrar_Pedido]
execute GRUPO_GENERICO.[Migrar_Item_Pedido]
execute GRUPO_GENERICO.[Migrar_Pedido_Cupon]
execute GRUPO_GENERICO.[Migrar_Reclamo]
execute GRUPO_GENERICO.[Migrar_Envio_Mensajeria]

PRINT '--- TABLAS MIGRADAS CORRECTAMENTE ---'


/* CREACION DE INDICES */

PRINT '--- CREACION DE INDICES ---'

-- Tipo_Movilidad 
CREATE INDEX IDX_TIPO_MOVILIDAD_ID ON [GRUPO_GENERICO].[Tipo_Movilidad] (tipo_movilidad_id);

-- Provincia 
CREATE INDEX IDX_PROVINCIA_ID ON [GRUPO_GENERICO].[Provincia] (provincia_id);

-- Pedido_Estado 
CREATE INDEX IDX_PEDIDO_ESTADO_ID ON [GRUPO_GENERICO].[Pedido_Estado] (pedido_estado_id);

-- Producto 
CREATE INDEX IDX_PROD_ID ON [GRUPO_GENERICO].[Producto] (prod_id);

-- Dia 
CREATE INDEX IDX_DIA_ID ON [GRUPO_GENERICO].[Dia] (dia_id);

-- Localidad 
CREATE INDEX IDX_LOCALIDAD_ID ON [GRUPO_GENERICO].[Localidad] (localidad_id);

-- Usuario 
CREATE INDEX IDX_US_ID ON [GRUPO_GENERICO].[Usuario] (us_id);

-- Direccion 
CREATE INDEX IDX_DIR_ID ON [GRUPO_GENERICO].[Direccion] (dir_id);

-- Tipo_Paquete 
CREATE INDEX IDX_TIPO_PAQUETE_ID ON [GRUPO_GENERICO].[Tipo_Paquete] (tipo_paquete_id);

-- Producto_Local 
CREATE INDEX IDX_PROD_LOC_ID ON [GRUPO_GENERICO].[Producto_Local] (prod_loc_producto_id, prod_loc_local_id);

-- Item_Pedido 
CREATE INDEX IDX_ITEM_PED_ID ON [GRUPO_GENERICO].[Item_Pedido] (item_ped_id);

-- Reclamo 
CREATE INDEX IDX_RECLAMO_ID ON [GRUPO_GENERICO].[Reclamo] (reclamo_nro);

-- Reclamo_Estado 
CREATE INDEX IDX_RECLAMO_ESTADO_ID ON [GRUPO_GENERICO].[Reclamo_Estado] (reclamo_estado_id);

-- Reclamo_Tipo 
CREATE INDEX IDX_RECLAMO_TIPO_ID ON [GRUPO_GENERICO].[Reclamo_Tipo] (reclamo_tipo_id);

-- Operador_Reclamo 
CREATE INDEX IDX_OPERADOR_REC_ID ON [GRUPO_GENERICO].[Operador_Reclamo] (operador_rec_id);

-- Local 
CREATE INDEX IDX_LOCAL_ID ON [GRUPO_GENERICO].[Local] (local_id);

-- Categoria_Local
CREATE INDEX IDX_CAT_ID ON [GRUPO_GENERICO].[Categoria_Local] (cat_id);