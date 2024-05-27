/*  

-- Equipo: MONSTERS INC
-- Fecha de entrega: 30.05.2024
-- TP ANUAL GDD 2024 1C

-- Ciclo lectivo: 2024
-- Descripcion: Migracion de Tabla Maestra - Creacion Inicial

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
	[super_localidad] numeric(18) NOT NULL,
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
    [item_tick_ticket] numeric(18) NOT NULL,
    [item_tick_producto] numeric(18) NOT NULL,
	[item_tick_promocion] numeric(18) NOT NULL,
    [item_tick_cantidad] decimal(18,0),
    [item_tick_total] decimal(18,2),
    [item_tick_descuento_aplicado] decimal(18,2)
);

/* CAJA */
CREATE TABLE [MONSTERS_INC].[Caja]
(
    [caja_id] numeric(18) IDENTITY NOT NULL,
    [caja_tipo] nvarchar(10),
	[caja_sucursal] numeric(18) NOT NULL
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
    [desc_medio_pago] numeric(18) NOT NULL,
    [desc_fecha_inicio] datetime,
	[desc_fecha_fin] datetime,
	[desc_porcentaje] decimal(18,0),
	[desc_tope] decimal(18,0)
);

/* DESCUENTO MEDIO PAGO APLICADO */
CREATE TABLE [MONSTERS_INC].[Descuento_Medio_Pago_Aplicado]
(
    [desc_apli_id] numeric(18) IDENTITY NOT NULL,
    [desc_apli_pago] numeric(18) NOT NULL,
    [desc_apli_cod_descuento_mp] numeric(18) NOT NULL,
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
    [envio_id] numeric(18) NOT NULL IDENTITY,
    [envio_ticket] numeric(18) NOT NULL,
    [envio_fecha] datetime,
	[envio_hora_inicio] datetime,
	[envio_hora_fin] datetime,
	[envio_cliente] numeric(18) NOT NULL,
	[envio_costo] numeric(18),
	[envio_estado] numeric(18) NOT NULL,
	[envio_entrega] numeric(18)
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

/* CONSTRAINT GENERATION - PRIMARY KEYS */

ALTER TABLE [MONSTERS_INC].[Categoria_Mayor]
    ADD CONSTRAINT [PK_Categoria_Mayor] PRIMARY KEY CLUSTERED ([catm_id] ASC)

ALTER TABLE [MONSTERS_INC].[Subcategoria]
    ADD CONSTRAINT [PK_Subcategoria] PRIMARY KEY CLUSTERED ([subc_id] ASC);

ALTER TABLE [MONSTERS_INC].[Producto]
    ADD CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED ([prod_id] ASC);

ALTER TABLE [MONSTERS_INC].[Promocion_Por_Producto]
    ADD CONSTRAINT PK_Promocion_Por_Producto PRIMARY KEY CLUSTERED ([prom_prod_promocion] ASC, [prom_prod_producto] ASC);

ALTER TABLE [MONSTERS_INC].[Promocion]
    ADD CONSTRAINT [PK_Promocion] PRIMARY KEY CLUSTERED ([prom_id] ASC);

ALTER TABLE [MONSTERS_INC].[Regla]
    ADD CONSTRAINT [PK_Regla] PRIMARY KEY CLUSTERED ([reg_id] ASC);

ALTER TABLE [MONSTERS_INC].[Supermercado]
    ADD CONSTRAINT [PK_Supermercado] PRIMARY KEY CLUSTERED ([super_id] ASC);

ALTER TABLE [MONSTERS_INC].[Sucursal]
    ADD CONSTRAINT [PK_Sucursal] PRIMARY KEY CLUSTERED ([sucu_id] ASC);

ALTER TABLE [MONSTERS_INC].[Item_Ticket] 
    ADD CONSTRAINT [PK_Item_Ticket] PRIMARY KEY CLUSTERED ([item_tick_id] ASC);

ALTER TABLE [MONSTERS_INC].[Caja] 
    ADD CONSTRAINT [PK_Caja] PRIMARY KEY CLUSTERED ([caja_id] ASC);

ALTER TABLE [MONSTERS_INC].[Tipo_Comprobante] 
    ADD CONSTRAINT [PK_Tipo_Comprobante] PRIMARY KEY CLUSTERED ([tipo_comp_id] ASC);

ALTER TABLE [MONSTERS_INC].[Descuento_Medio_Pago]
    ADD CONSTRAINT [PK_Descuento_Medio_Pago] PRIMARY KEY CLUSTERED ([desc_id] ASC);

ALTER TABLE [MONSTERS_INC].[Medio_Pago]
    ADD CONSTRAINT [PK_Medio_Pago] PRIMARY KEY CLUSTERED ([medio_pago_id] ASC);

ALTER TABLE [MONSTERS_INC].[Ticket]
    ADD CONSTRAINT [PK_Ticket] PRIMARY KEY CLUSTERED ([tick_id] ASC);

ALTER TABLE [MONSTERS_INC].[Empleado]
    ADD CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED ([empl_id] ASC);

ALTER TABLE [MONSTERS_INC].[Localidad]
    ADD CONSTRAINT [PK_Localidad] PRIMARY KEY CLUSTERED ([loca_id] ASC);

ALTER TABLE [MONSTERS_INC].[Provincia]
    ADD CONSTRAINT [PK_Provincia] PRIMARY KEY CLUSTERED ([prov_id] ASC);

ALTER TABLE [MONSTERS_INC].[Cliente] 
    ADD CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED ([clie_id] ASC);

ALTER TABLE [MONSTERS_INC].[Envio] 
    ADD CONSTRAINT [PK_Envio] PRIMARY KEY CLUSTERED ([envio_id] ASC);

ALTER TABLE [MONSTERS_INC].[Entrega] 
    ADD CONSTRAINT [PK_Entrega] PRIMARY KEY CLUSTERED ([entr_id] ASC);

ALTER TABLE [MONSTERS_INC].[Estado] 
    ADD CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED ([esta_id] ASC);

ALTER TABLE [MONSTERS_INC].[Pago] 
    ADD CONSTRAINT [PK_Pago] PRIMARY KEY CLUSTERED ([pago_id] ASC);

ALTER TABLE [MONSTERS_INC].[Detalle_Pago] 
    ADD CONSTRAINT [PK_Detalle_Pago] PRIMARY KEY CLUSTERED ([deta_id] ASC);

ALTER TABLE [MONSTERS_INC].[Tarjeta] 
    ADD CONSTRAINT [PK_Tarjeta] PRIMARY KEY CLUSTERED ([tarj_id] ASC);

/* CONSTRAINT GENERATION - FOREIGN KEYS */

ALTER TABLE [MONSTERS_INC].[Subcategoria]
    ADD CONSTRAINT [FK_Subcategoria_subc_categoria_mayor] FOREIGN KEY ([subc_categoria_mayor])
    REFERENCES [MONSTERS_INC].[Categoria_Mayor]([catm_id]);

ALTER TABLE [MONSTERS_INC].[Producto]
    ADD CONSTRAINT [FK_Producto_prod_subcategoria] FOREIGN KEY ([prod_subcategoria])
    REFERENCES [MONSTERS_INC].[Subcategoria]([subc_id]);

ALTER TABLE [MONSTERS_INC].[Promocion_Por_Producto]
    ADD CONSTRAINT [FK_Promocion_Por_Producto_prom_prod_promocion] FOREIGN KEY ([prom_prod_promocion])
    REFERENCES [MONSTERS_INC].[Promocion]([prom_id]);

ALTER TABLE [MONSTERS_INC].[Promocion_Por_Producto]
    ADD CONSTRAINT [FK_Promocion_Por_Producto_prom_prod_producto] FOREIGN KEY ([prom_prod_producto])
    REFERENCES [MONSTERS_INC].[Producto]([prod_id]);

ALTER TABLE [MONSTERS_INC].[Promocion]
    ADD CONSTRAINT [FK_Promocion_prom_regla] FOREIGN KEY ([prom_regla])
    REFERENCES [MONSTERS_INC].[Regla]([reg_id]);

ALTER TABLE [MONSTERS_INC].[Supermercado]
    ADD CONSTRAINT [FK_Supermercado_super_localidad] FOREIGN KEY ([super_localidad])
    REFERENCES [MONSTERS_INC].[Localidad](loca_id);

ALTER TABLE [MONSTERS_INC].[Localidad]
    ADD CONSTRAINT [FK_Localidad_loca_provincia] FOREIGN KEY ([loca_provincia])
    REFERENCES [MONSTERS_INC].[Provincia]([prov_id]);

ALTER TABLE [MONSTERS_INC].[Sucursal] 
    ADD CONSTRAINT [FK_Sucursal_sucu_localidad] FOREIGN KEY ([sucu_localidad])
    REFERENCES [MONSTERS_INC].[Localidad]([loca_id]);

ALTER TABLE [MONSTERS_INC].[Sucursal]
    ADD CONSTRAINT [FK_Sucursal_sucu_supermercado] FOREIGN KEY ([sucu_supermercado])
    REFERENCES [MONSTERS_INC].[Supermercado]([super_id]);

ALTER TABLE [MONSTERS_INC].[Caja]
    ADD CONSTRAINT [FK_Caja_caja_sucursal] FOREIGN KEY ([caja_sucursal])
    REFERENCES [MONSTERS_INC].[Sucursal]([sucu_id]);

ALTER TABLE [MONSTERS_INC].[Item_Ticket]
    ADD CONSTRAINT [FK_Item_Ticket_item_tick_ticket] FOREIGN KEY ([item_tick_ticket]) 
    REFERENCES [MONSTERS_INC].[Ticket]([tick_id]);

ALTER TABLE [MONSTERS_INC].[Item_Ticket]
    ADD CONSTRAINT [FK_Item_Ticket_item_tick_producto] FOREIGN KEY ([item_tick_producto]) 
    REFERENCES [MONSTERS_INC].[Producto]([prod_id]);

ALTER TABLE [MONSTERS_INC].[Item_Ticket]
    ADD CONSTRAINT [FK_Item_Ticket_item_tick_promocion] FOREIGN KEY ([item_tick_promocion]) 
    REFERENCES [MONSTERS_INC].[Promocion]([prom_id]);

ALTER TABLE [MONSTERS_INC].[Descuento_Medio_Pago]
    ADD CONSTRAINT [FK_Descuento_Medio_Pago_desc_medio_pago] FOREIGN KEY ([desc_medio_pago]) 
    REFERENCES [MONSTERS_INC].[Medio_Pago]([medio_pago_id]);

ALTER TABLE [MONSTERS_INC].[Ticket]
    ADD CONSTRAINT [FK_Ticket_tick_caja] FOREIGN KEY ([tick_caja]) 
    REFERENCES [MONSTERS_INC].[Caja]([caja_id]);

ALTER TABLE [MONSTERS_INC].[Ticket]
    ADD CONSTRAINT [FK_Ticket_tick_empleado] FOREIGN KEY ([tick_empleado]) 
    REFERENCES [MONSTERS_INC].[Empleado]([empl_id]);

ALTER TABLE [MONSTERS_INC].[Ticket]
    ADD CONSTRAINT [FK_Ticket_tick_tipo_comprobante] FOREIGN KEY ([tick_tipo_comprobante]) 
    REFERENCES [MONSTERS_INC].[Tipo_Comprobante]([tipo_comp_id]);

ALTER TABLE [MONSTERS_INC].[Empleado]
    ADD CONSTRAINT [FK_Empleado_empl_sucursal] FOREIGN KEY ([empl_sucursal]) 
    REFERENCES [MONSTERS_INC].[Sucursal]([sucu_id]);

ALTER TABLE [MONSTERS_INC].[Cliente]
    ADD CONSTRAINT [FK_Cliente_clie_localidad] FOREIGN KEY ([clie_localidad]) 
    REFERENCES [MONSTERS_INC].[Localidad]([loca_id]);

ALTER TABLE [MONSTERS_INC].[Envio]
    ADD CONSTRAINT [FK_Envio_envio_ticket] FOREIGN KEY ([envio_ticket]) 
    REFERENCES [MONSTERS_INC].[Ticket]([tick_id]);

ALTER TABLE [MONSTERS_INC].[Envio]
    ADD CONSTRAINT [FK_Envio_envio_cliente] FOREIGN KEY ([envio_cliente]) 
    REFERENCES [MONSTERS_INC].[Cliente]([clie_id]);

ALTER TABLE [MONSTERS_INC].[Envio]
    ADD CONSTRAINT [FK_Envio_envio_estado] FOREIGN KEY ([envio_estado]) 
    REFERENCES [MONSTERS_INC].[Estado]([esta_id]);

ALTER TABLE [MONSTERS_INC].[Envio]
    ADD CONSTRAINT [FK_Envio_envio_entrega] FOREIGN KEY ([envio_entrega]) 
    REFERENCES [MONSTERS_INC].[Entrega]([entr_id]);

ALTER TABLE [MONSTERS_INC].[Pago]
    ADD CONSTRAINT [FK_Pago_pago_medio_pago] FOREIGN KEY ([pago_medio_pago]) 
    REFERENCES [MONSTERS_INC].[Medio_Pago]([medio_pago_id]);

ALTER TABLE [MONSTERS_INC].[Pago]
    ADD CONSTRAINT [FK_Pago_pago_detalle] FOREIGN KEY ([pago_detalle]) 
    REFERENCES [MONSTERS_INC].[Detalle_Pago]([deta_id]);

ALTER TABLE [MONSTERS_INC].[Pago]
    ADD CONSTRAINT [FK_Pago_pago_ticket] FOREIGN KEY ([pago_ticket]) 
    REFERENCES [MONSTERS_INC].[Ticket]([tick_id]);

ALTER TABLE [MONSTERS_INC].[Descuento_Medio_Pago_Aplicado]
    ADD CONSTRAINT [FK_Descuento_Medio_Pago_Aplicado_desc_apli_pago] FOREIGN KEY ([desc_apli_pago]) 
    REFERENCES [MONSTERS_INC].[Pago]([pago_id]);

ALTER TABLE [MONSTERS_INC].[Descuento_Medio_Pago_Aplicado]
    ADD CONSTRAINT [FK_Descuento_Medio_Pago_Aplicado_desc_apli_cod_descuento_mp] FOREIGN KEY ([desc_apli_cod_descuento_mp]) 
    REFERENCES [MONSTERS_INC].[Descuento_Medio_Pago]([desc_id]);

ALTER TABLE [MONSTERS_INC].[Detalle_Pago]
    ADD CONSTRAINT [FK_Detalle_Pago_deta_cliente] FOREIGN KEY ([deta_cliente]) 
    REFERENCES [MONSTERS_INC].[Cliente]([clie_id]);

ALTER TABLE [MONSTERS_INC].[Detalle_Pago]
    ADD CONSTRAINT [FK_Detalle_Pago_deta_tarjeta] FOREIGN KEY ([deta_tarjeta]) 
    REFERENCES [MONSTERS_INC].[Tarjeta]([tarj_id]);


PRINT '--- TABLAS CREADAS CORRECTAMENTE ---';
GO

/* --- MIGRACION DE DATOS ---*/

/* DATOS PROVINCIAS */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Provincia
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Provincia]
        (prov_nombre)
    SELECT DISTINCT provincia_nombre
    from(
        SELECT SUCURSAL_PROVINCIA as provincia_nombre
            FROM gd_esquema.Maestra
            where SUCURSAL_PROVINCIA IS NOT NULL
        UNION
            SELECT SUPER_PROVINCIA as provincia_nombre
            from gd_esquema.Maestra
            where SUPER_PROVINCIA IS NOT NULL 
		UNION
			SELECT CLIENTE_PROVINCIA as provincia_nombre
			from gd_esquema.Maestra
			where CLIENTE_PROVINCIA IS NOT NULL
    ) as subquery;

END
GO

/* LOCALIDAD */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Localidad
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Localidad]
        (loca_nombre, loca_provincia)
    SELECT DISTINCT localidad_nombre, provincia_id
    from(
       SELECT SUCURSAL_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    prov_id
                from [MONSTERS_INC].Provincia
                where prov_nombre = SUCURSAL_LOCALIDAD) as provincia_id
            FROM gd_esquema.Maestra
            where SUCURSAL_LOCALIDAD IS NOT NULL
        UNION
            SELECT SUPER_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    prov_id
                from [MONSTERS_INC].Provincia
                where prov_nombre =  SUPER_LOCALIDAD) as provincia_id
            from gd_esquema.Maestra
            where SUPER_LOCALIDAD IS NOT NULL
		UNION
			SELECT CLIENTE_LOCALIDAD as localidad_nombre,
                (SELECT top 1
                    prov_id
                from [MONSTERS_INC].Provincia
                where prov_nombre =  CLIENTE_LOCALIDAD) as provincia_id
            from gd_esquema.Maestra
            where CLIENTE_LOCALIDAD IS NOT NULL
    ) as subquery;
END
GO


/* SUPERMERCADO */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Supermercado
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Supermercado]
        (super_nombre, super_razon_social,super_cuit,super_iibb,super_domicilio,super_fecha_inicio_actividad,super_condicion_fiscal, super_localidad)
    SELECT DISTINCT SUPER_NOMBRE, SUPER_RAZON_SOC, SUPER_CUIT, SUPER_IIBB, SUPER_DOMICILIO, SUPER_FECHA_INI_ACTIVIDAD, SUPER_CONDICION_FISCAL,
	 (SELECT TOP 1
            loca_id
        FROM [MONSTERS_INC].[Localidad]
        WHERE loca_nombre = SUPER_LOCALIDAD)
    FROM gd_esquema.Maestra;
END
GO

/* SUCURSAL */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Sucursal
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Sucursal]
        (sucu_numero,sucu_direccion,sucu_localidad,sucu_supermercado)
    SELECT DISTINCT SUCURSAL_NOMBRE,SUCURSAL_DIRECCION,
	 (SELECT TOP 1
            loca_id
        FROM [MONSTERS_INC].[Localidad]
        WHERE loca_nombre = SUCURSAL_LOCALIDAD) as sucu_localidad,
	 (SELECT TOP 1
            super_id
        FROM [MONSTERS_INC].[SUPERMERCADO]
        WHERE [SUPERMERCADO].super_cuit = SUPER_CUIT) as sucu_supermercado			--Esta bien usar SUPER_CUIT?
    FROM gd_esquema.Maestra;
END
GO

/* REGLA */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Regla
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Regla]
        (reg_descripcion, reg_descuento, reg_cantidad_aplicable, reg_cantidad_descuento, reg_cantidad_max, reg_misma_marca, reg_mismo_producto)
    SELECT DISTINCT 
        REGLA_DESCRIPCION, 
        REGLA_DESCUENTO_APLICABLE_PROD, 
        REGLA_CANT_APLICA_DESCUENTO, 
        REGLA_CANT_APLICABLE_REGLA,  
        REGLA_CANT_MAX_PROD, 
        REGLA_APLICA_MISMA_MARCA,
        REGLA_APLICA_MISMO_PROD
    FROM gd_esquema.Maestra
    WHERE 
        REGLA_DESCRIPCION IS NOT NULL AND 
        REGLA_DESCUENTO_APLICABLE_PROD IS NOT NULL AND 
        REGLA_CANT_APLICA_DESCUENTO IS NOT NULL AND 
        REGLA_CANT_APLICABLE_REGLA IS NOT NULL AND   -- Agregué esta línea
        REGLA_CANT_MAX_PROD IS NOT NULL AND 
        REGLA_APLICA_MISMA_MARCA IS NOT NULL AND   -- Agregué esta línea
        REGLA_APLICA_MISMO_PROD IS NOT NULL;
END
GO


/* PROMOCION */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Promocion
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Promocion]
        (prom_descripcion, prom_fecha_fin,prom_fecha_fin,prom_regla)
    SELECT DISTINCT PROMOCION_DESCRIPCION,PROMOCION_FECHA_INICIO,PROMOCION_FECHA_FIN,
	(SELECT TOP 1
        reg_id
        FROM [MONSTERS_INC].[Regla]
        WHERE  reg_descripcion = REGLA_DESCRIPCION)
    FROM  gd_esquema.Maestra;												
END
GO

/* CATEGORÍA MAYOR */

CREATE PROCEDURE [MONSTERS_INC].Migrar_Categoria_Mayor
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Categoria_Mayor]
        (catm_descripcion)
    SELECT DISTINCT PRODUCTO_CATEGORIA
    FROM gd_esquema.Maestra
    WHERE PRODUCTO_CATEGORIA IS NOT NULL
END
GO

/* SUB_CATEGORIA */
CREATE PROCEDURE [MONSTERS_INC].Migrar_Sub_Categoria
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Subcategoria]
        (subc_descripcion, subc_categoria_mayor)
    SELECT DISTINCT PRODUCTO_SUB_CATEGORIA,
        (SELECT TOP 1
            catm_id
        FROM [MONSTERS_INC].[Categoria_Mayor]
        WHERE catm_descripcion = PRODUCTO_CATEGORIA)
    FROM gd_esquema.Maestra
    WHERE PRODUCTO_SUB_CATEGORIA IS NOT NULL
END
GO

/* PRODUCTO */
CREATE PROCEDURE [MONSTERS_INC].Migrar_Producto
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[Producto]
        (prod_descripcion, prod_marca, prod_nombre, prod_precio, prod_subcategoria)
    SELECT DISTINCT PRODUCTO_DESCRIPCION, PRODUCTO_MARCA, PRODUCTO_NOMBRE, PRODUCTO_PRECIO,
        ( select top 1
            subc_id
        from [MONSTERS_INC].[Subcategoria]
        where subc_descripcion = PRODUCTO_SUB_CATEGORIA)
    from gd_esquema.Maestra as M
    where PRODUCTO_DESCRIPCION IS NOT NULL
        AND PRODUCTO_MARCA IS NOT NULL
		AND PRODUCTO_NOMBRE IS NOT NULL
		AND PRODUCTO_PRECIO IS NOT NULL
END
GO



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
    WHERE USUARIO_DNI�IS�NOT�NULL
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