/*  

------------------------------------------------------------------------
-- Equipo: MONSTERS INC
-- Fecha de entrega: 30.06.2024
-- TP CUATRIMESTRAL GDD 2024 1C

-- Ciclo lectivo: 2024
-- Descripcion: Migracion a modelo BI
------------------------------------------------------------------------

*/

USE [GD1C2024]
GO

PRINT '------ MONSTERS INC ------';
GO
PRINT '--- COMENZANDO MIGRACION BI  ---';
GO

/* DROPS */
DECLARE @DropConstraints NVARCHAR(max) = ''

SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
FROM sys.foreign_keys
WHERE name LIKE '%' + 'BI_' + '%';

EXECUTE sp_executesql @DropConstraints;

PRINT '--- CONSTRAINTS BI DROPEADOS CORRECTAMENTE ---';


/* DROPS PROCEDURES */
DECLARE @DropProcedures NVARCHAR(max) = ''

SELECT @DropProcedures += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.procedures
WHERE name LIKE '%' + 'BI_' + '%';

EXECUTE sp_executesql @DropProcedures;

PRINT '--- PROCEDURES BI DROPEADOS CORRECTAMENTE ---';


/* DROPS FUNCTIONS */
DECLARE @DropFunctions NVARCHAR(MAX) = '';

SELECT @DropFunctions += 'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF') AND name LIKE '%' + 'BI_' + '%';

EXEC sp_executesql @DropFunctions;

PRINT '--- FUNCTIONS BI DROPEADOS CORRECTAMENTE ---';


/* DROPS TABLAS */
IF OBJECT_ID('MONSTERS_INC.BI_Tiempo', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Tiempo;
IF OBJECT_ID('MONSTERS_INC.BI_Ubicacion', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Ubicacion;
IF OBJECT_ID('MONSTERS_INC.BI_Sucursal', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Sucursal;
IF OBJECT_ID('MONSTERS_INC.BI_Rango_Etario', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Rango_Etario;
IF OBJECT_ID('MONSTERS_INC.BI_Turno', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Turno;
IF OBJECT_ID('MONSTERS_INC.BI_Medio_Pago', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Medio_Pago;
IF OBJECT_ID('MONSTERS_INC.BI_Categoria', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Categoria;
IF OBJECT_ID('MONSTERS_INC.BI_Item_Ticket', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Item_Ticket;
IF OBJECT_ID('MONSTERS_INC.BI_Hechos_Venta', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Hechos_Venta;
IF OBJECT_ID('MONSTERS_INC.BI_Caja_Tipo', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Caja_Tipo;
IF OBJECT_ID('MONSTERS_INC.BI_Empleado', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Empleado;
IF OBJECT_ID('MONSTERS_INC.BI_Ticket', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Ticket;
IF OBJECT_ID('MONSTERS_INC.BI_Hechos_Envio', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Hechos_Envio;
IF OBJECT_ID('MONSTERS_INC.BI_Hechos_Cuota', 'U') IS NOT NULL DROP TABLE MONSTERS_INC.BI_Hechos_Cuota;

PRINT '--- TABLAS BI DROPEADAS CORRECTAMENTE ---';

------------------------------------------------------------------------

PRINT '--- CREACION TABLAS DE DIMENSIONES  ---';
GO

/* BI Tiempo */
CREATE TABLE [MONSTERS_INC].[BI_Tiempo]
(
    [bi_tiempo_id] numeric(18) IDENTITY NOT NULL,
    [bi_tiempo_anio] numeric(18) NOT NULL,
    [bi_tiempo_cuatrimestre] numeric(6) NOT NULL,
    [bi_tiempo_mes] numeric(16) NOT NULL
);

/* BI Ubicacion */
CREATE TABLE [MONSTERS_INC].[BI_Ubicacion]
(
    [bi_ubicacion_id] numeric(18) IDENTITY NOT NULL,
    [provincia_desc] nvarchar(255) NOT NULL,
    [localidad_desc] nvarchar(255) NOT NULL
);

/* BI Sucursal */
CREATE TABLE [MONSTERS_INC].[BI_Sucursal]
(
    [bi_sucursal_id] numeric(18) IDENTITY NOT NULL,
    [sucursal_desc] nvarchar(255) NOT NULL
);


/* BI Rango_Etario */
CREATE TABLE [MONSTERS_INC].[BI_Rango_Etario]
(
    [bi_rango_etario_id] numeric(18) IDENTITY NOT NULL,
    [rango_etario_desc] nvarchar(255) NOT NULL
);

/* BI Turno */
CREATE TABLE [MONSTERS_INC].[BI_Turno]
(
    [bi_turno_id] numeric(18) IDENTITY NOT NULL,
    [turno_desc] nvarchar(255) NOT NULL
);


/* BI Medio_Pago */
CREATE TABLE [MONSTERS_INC].[BI_Medio_Pago]
(
    [bi_medio_pago_id] numeric(18) IDENTITY NOT NULL,
    [medio_pago_tipo] nvarchar(50) NOT NULL,
    [medio_pago_nombre] nvarchar(50) NOT NULL
);

/* BI Categoria */
CREATE TABLE [MONSTERS_INC].[BI_Categoria]
(
    [bi_categoria_id] numeric(18) IDENTITY NOT NULL,
    [subc_descripcion] nvarchar(50) NOT NULL,
    [catm_descripcion] nvarchar(50) NOT NULL
);

/* BI_Caja_Tipo */
CREATE TABLE [MONSTERS_INC].[BI_Caja_Tipo]
(
    [bi_caja_tipo_id] numeric(18) IDENTITY NOT NULL,
    [caja_desc] nvarchar(255),
    [caja_nro] nvarchar(18)
);

/* BI_Empleado */
CREATE TABLE [MONSTERS_INC].[BI_Empleado]
(
    [bi_empleado_id] numeric(18) IDENTITY NOT NULL,
    [empl_desc] nvarchar(255) NOT NULL,
    [empl_dni] nvarchar(255) NOT NULL
);

/* BI_Ticket */
CREATE TABLE [MONSTERS_INC].[BI_Ticket]
(
    [bi_ticket_id] numeric(18) IDENTITY NOT NULL,
    [ticket_nro] decimal(18) NOT NULL
);

------------------------------------------------------------------------

PRINT '--- CREACION TABLAS DE HECHOS  ---';
GO

/* BI Hechos_Venta */
CREATE TABLE [MONSTERS_INC].[BI_Hechos_Venta]
(
    [bi_hechos_venta_id] numeric(18) IDENTITY NOT NULL,
    [bi_ubicacion_id] numeric(18) NOT NULL,  -- localidad (ubicacion) + anio || mes (tiempo)
    [bi_tiempo_id] numeric(18) NOT NULL,
    [bi_turno_id] numeric(18) NOT NULL,
    [bi_caja_tipo_id] numeric(18) NOT NULL,
    [bi_rango_etario_id] numeric(18) NOT NULL,
    [bi_empleado_id] numeric(18) NOT NULL,
    [bi_ticket_id] numeric(18) NOT NULL,
    [bi_medio_pago_id] numeric(18) NOT NULL,
    [importe_unitario] numeric(18) NOT NULL,
    [cantidad_productos] numeric(18) NOT NULL,
    [descuento_total] numeric(18) NOT NULL,
    [descuento_promo_prod] numeric(18) NOT NULL,
    [categoria_desc] nvarchar(255)
);

/* BI Hechos_Envio */
CREATE TABLE [MONSTERS_INC].[BI_Hechos_Envio]
(
    [bi_hechos_envio_id] numeric(18) IDENTITY NOT NULL, 
    [bi_tiempo_id] numeric(18) NOT NULL,
    [bi_sucursal_id] numeric(18),
    [bi_rango_etario_id] numeric(18) NOT NULL,
    [bi_ubicacion_id] numeric(18) NOT NULL,
    [envi_fecha_programada] datetime NOT NULL,  
    [envi_fecha_entrega] datetime NOT NULL,
    [envi_costo] numeric(18) NOT NULL
);

/* BI Hechos_Couta */
CREATE TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
(
    [bi_hechos_cuota_id] numeric(18) IDENTITY NOT NULL, 
    [bi_tiempo_id] numeric(18) NOT NULL,
    [bi_sucursal_id] numeric(18) NOT NULL,
    [bi_rango_etario_id] numeric(18) NOT NULL,
    [bi_medio_pago_id] numeric(18) NOT NULL,
    [cantidad_cuotas] numeric(18),                                                                              --puede ser null
    [importe_cuota] decimal(18,2)                                                                                 --puede ser null
);

------------------------------------------------------------------------

/* CONSTRAINT GENERATION - PKs*/

ALTER TABLE [MONSTERS_INC].[BI_Tiempo]
    ADD CONSTRAINT [PK_BI_Tiempo] PRIMARY KEY CLUSTERED ([bi_tiempo_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Ubicacion]
    ADD CONSTRAINT [PK_BI_Ubicacion] PRIMARY KEY CLUSTERED ([bi_ubicacion_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Sucursal]
    ADD CONSTRAINT [PK_BI_Sucursal] PRIMARY KEY CLUSTERED ([bi_sucursal_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Rango_Etario]
    ADD CONSTRAINT [PK_BI_Rango_Etario] PRIMARY KEY CLUSTERED ([bi_rango_etario_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Turno]
    ADD CONSTRAINT [PK_BI_Turno] PRIMARY KEY CLUSTERED ([bi_turno_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Medio_Pago]
    ADD CONSTRAINT [PK_BI_Medio_Pago] PRIMARY KEY CLUSTERED ([bi_medio_pago_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Categoria]
    ADD CONSTRAINT [PK_BI_Categoria] PRIMARY KEY CLUSTERED ([bi_categoria_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Caja_Tipo]
    ADD CONSTRAINT [PK_BI_Caja_Tipo] PRIMARY KEY CLUSTERED ([bi_caja_tipo_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Empleado]
    ADD CONSTRAINT [PK_BI_Empleado] PRIMARY KEY CLUSTERED ([bi_empleado_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Ticket]
    ADD CONSTRAINT [PK_BI_Ticket] PRIMARY KEY CLUSTERED ([bi_ticket_id] ASC)

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Envio]
    ADD CONSTRAINT [PK_BI_Hechos_Envio] PRIMARY KEY CLUSTERED ([bi_hechos_envio_id] ASC) 

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
    ADD CONSTRAINT [PK_BI_Hechos_Cuota] PRIMARY KEY CLUSTERED ([bi_hechos_cuota_id] ASC) 

/* CONSTRAINT GENERATION - FKs*/

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_ubicacion_id] FOREIGN KEY ([bi_ubicacion_id])
    REFERENCES [MONSTERS_INC].[BI_Ubicacion]([bi_ubicacion_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_tiempo_id] FOREIGN KEY ([bi_tiempo_id])
    REFERENCES [MONSTERS_INC].[BI_Tiempo]([bi_tiempo_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_turno_id] FOREIGN KEY ([bi_turno_id])
    REFERENCES [MONSTERS_INC].[BI_Turno]([bi_turno_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_caja_tipo_id] FOREIGN KEY ([bi_caja_tipo_id])
    REFERENCES [MONSTERS_INC].[BI_Caja_Tipo]([bi_caja_tipo_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_empleado_id] FOREIGN KEY ([bi_empleado_id])
    REFERENCES [MONSTERS_INC].[BI_Empleado]([bi_empleado_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_rango_etario_id] FOREIGN KEY ([bi_rango_etario_id])
    REFERENCES [MONSTERS_INC].[BI_Rango_Etario]([bi_rango_etario_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_ticket_id] FOREIGN KEY ([bi_ticket_id])
    REFERENCES [MONSTERS_INC].[BI_Ticket]([bi_ticket_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Venta]
    ADD CONSTRAINT [FK_BI_Hechos_Venta_bi_medio_pago_id] FOREIGN KEY ([bi_medio_pago_id])
    REFERENCES [MONSTERS_INC].[BI_Medio_Pago]([bi_medio_pago_id]);

--

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Envio]
    ADD CONSTRAINT [FK_BI_Hechos_Envio_bi_tiempo_id] FOREIGN KEY ([bi_tiempo_id])
    REFERENCES [MONSTERS_INC].[BI_Tiempo]([bi_tiempo_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Envio]
    ADD CONSTRAINT [FK_BI_Hechos_Envio_bi_sucursal_id] FOREIGN KEY ([bi_sucursal_id])
    REFERENCES [MONSTERS_INC].[BI_Sucursal]([bi_sucursal_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Envio]
    ADD CONSTRAINT [FK_BI_Hechos_Envio_bi_rango_etario_id] FOREIGN KEY ([bi_rango_etario_id])
    REFERENCES [MONSTERS_INC].[BI_Rango_Etario]([bi_rango_etario_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Envio]
    ADD CONSTRAINT [FK_BI_Hechos_Envio_bi_ubicacion_id] FOREIGN KEY ([bi_ubicacion_id])
    REFERENCES [MONSTERS_INC].[BI_Ubicacion]([bi_ubicacion_id]);

--

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
    ADD CONSTRAINT [FK_BI_Hechos_Cuota_bi_tiempo_id] FOREIGN KEY ([bi_tiempo_id])
    REFERENCES [MONSTERS_INC].[BI_Tiempo]([bi_tiempo_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
    ADD CONSTRAINT [FK_BI_Hechos_Cuota_bi_sucursal_id] FOREIGN KEY ([bi_sucursal_id])
    REFERENCES [MONSTERS_INC].[BI_Sucursal]([bi_sucursal_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
    ADD CONSTRAINT [FK_BI_Hechos_Cuota_bi_rango_etario_id] FOREIGN KEY ([bi_rango_etario_id])
    REFERENCES [MONSTERS_INC].[BI_Rango_Etario]([bi_rango_etario_id]);

ALTER TABLE [MONSTERS_INC].[BI_Hechos_Cuota]
    ADD CONSTRAINT [FK_BI_Hechos_Cuota_bi_cliente_id] FOREIGN KEY ([bi_medio_pago_id])
    REFERENCES [MONSTERS_INC].[BI_Medio_Pago]([bi_medio_pago_id]);

--

PRINT '--- TABLAS DE DIMENSIONES CREADAS CORRECTAMENTE ---';
GO

/* Funciones para ganar declaratividad y evitar repetir logica */

CREATE FUNCTION [MONSTERS_INC].BI_Resolver_Rango_Etario(@unaFechaDeNacimiento datetime)
RETURNS nvarchar(255)
AS
    BEGIN
        DECLARE @unaEdad AS numeric(6) = Datediff(year, @unaFechaDeNacimiento, GETDATE())

        IF @unaEdad < 25
            RETURN '< 25 anios'
        IF @unaEdad BETWEEN 25 AND 35
            RETURN '25-35 anios'
        IF @unaEdad BETWEEN 35 AND 50
            RETURN '35-50 anios'
        IF @unaEdad > 50
            RETURN '> 50 anios'

        RETURN 'Fuera de Rango Etario'
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Resolver_Turno(@unaFechaHora datetime)
RETURNS nvarchar(255)
AS
    BEGIN
        DECLARE @unHorario AS numeric(6) = datepart(hh, @unaFechaHora)

        IF @unHorario BETWEEN 8 AND 12
            RETURN '08:00 - 12:00'
        IF @unHorario BETWEEN 16 AND 16
            RETURN '12:00 - 16:00'
        IF @unHorario BETWEEN 16 AND 20
            RETURN '16:00 - 20:00'

        RETURN 'Fuera de Turno'
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Tiempo(@unaFecha datetime)
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idFecha AS numeric(18)

        SELECT 
            @idFecha = t.bi_tiempo_id
        FROM [MONSTERS_INC].BI_Tiempo t
        WHERE year(@unaFecha) = t.bi_tiempo_anio AND datepart(Q, @unaFecha) = t.bi_tiempo_cuatrimestre
            AND month(@unaFecha) = t.bi_tiempo_mes

        RETURN @idFecha
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Ubicacion(@unaProvincia nvarchar(255), @unaLocalidad nvarchar(255))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idUbicacion AS numeric(18)
                    
        SELECT TOP 1
            @idUbicacion = u.bi_ubicacion_id
        FROM [MONSTERS_INC].BI_Ubicacion u
        WHERE u.provincia_desc = @unaProvincia AND u.localidad_desc = @unaLocalidad

        RETURN @idUbicacion
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Turno(@unaFechaHora nvarchar(255))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idTurno AS numeric(18)

        SELECT 
            @idTurno = t.bi_turno_id
        FROM [MONSTERS_INC].BI_Turno t
        WHERE [MONSTERS_INC].BI_Resolver_Turno(@unaFechaHora) = t.turno_desc

        RETURN @idTurno
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Caja_Tipo(@unIdCaja numeric(18))
RETURNS numeric(18)
AS
BEGIN
    DECLARE @idCajaTipo AS numeric(18)

    SELECT 
        @idCajaTipo = ct.bi_caja_tipo_id
    FROM [MONSTERS_INC].Caja c
        INNER JOIN [MONSTERS_INC].BI_Caja_Tipo ct ON ct.caja_desc = c.caja_tipo AND ct.caja_nro = c.caja_nro
    WHERE c.caja_id = @unIdCaja

    RETURN @idCajaTipo
END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Empleado(@idEmpleado numeric(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idEmpleadoBI AS numeric(18)
        DECLARE @nombreEmpleado AS nvarchar(128), @apellidoEmpleado AS nvarchar(128), @unDni AS numeric(18)

        SELECT 
            @nombreEmpleado = em.empl_nombre,
            @apellidoEmpleado = em.empl_apellido,
            @unDni = em.empl_dni
        FROM [MONSTERS_INC].Empleado em
        WHERE em.empl_id = @idEmpleado

        SELECT 
            @idEmpleadoBI = e.bi_empleado_id
        FROM [MONSTERS_INC].BI_Empleado e
        WHERE e.empl_desc = @nombreEmpleado + @apellidoEmpleado AND e.empl_dni = @unDni

        RETURN @idEmpleadoBI
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Rango_Etario(@idPersona numeric(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idRangoEtario AS numeric(18)
        DECLARE @fechaNacimientoPersona AS datetime

        SELECT 
            @fechaNacimientoPersona = em.empl_fecha_nacimiento
        FROM [MONSTERS_INC].Empleado em
        WHERE em.empl_id = @idPersona

        SELECT 
            @idRangoEtario = re.bi_rango_etario_id
        FROM [MONSTERS_INC].BI_Rango_Etario re
        WHERE [MONSTERS_INC].BI_Resolver_Rango_Etario(@fechaNacimientoPersona) = re.rango_etario_desc

        RETURN @idRangoEtario
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Rango_Etario_Clie(@idPersona numeric(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idRangoEtario AS numeric(18)
        DECLARE @fechaNacimientoPersona AS datetime

        SELECT 
            @fechaNacimientoPersona = cl.clie_fecha_nacimiento
        FROM [MONSTERS_INC].Cliente cl
        WHERE cl.clie_id = @idPersona

        SELECT 
            @idRangoEtario = re.bi_rango_etario_id
        FROM [MONSTERS_INC].BI_Rango_Etario re
        WHERE [MONSTERS_INC].BI_Resolver_Rango_Etario(@fechaNacimientoPersona) = re.rango_etario_desc

        RETURN @idRangoEtario
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Ticket(@unNroTicket decimal(18))
RETURNS decimal(18)
AS
    BEGIN
        DECLARE @idTicketBi AS numeric(18)

        SELECT TOP 1
            @idTicketBi = t.bi_ticket_id
        FROM [MONSTERS_INC].BI_Ticket t
        WHERE t.ticket_nro = @unNroTicket

        RETURN @idTicketBi
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Medio_Pago(@unMedioPagoId numeric(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idMedioPagoBi AS numeric(18)
        DECLARE @tipoMedioBi AS NVARCHAR(50), @nombreMedioBi AS NVARCHAR(50)
        
        SELECT
            @tipoMedioBi = m.medio_pago_tipo,
            @nombreMedioBi = m.medio_pago_nombre
        FROM [MONSTERS_INC].Medio_Pago m
        WHERE m.medio_pago_id = @unMedioPagoId

        SELECT
            @idMedioPagoBi = mpb.bi_medio_pago_id
        FROM [MONSTERS_INC].BI_Medio_Pago mpb 
        WHERE mpb.medio_pago_nombre = @nombreMedioBi AND mpb.medio_pago_tipo = @tipoMedioBi

        RETURN @idMedioPagoBi
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Sucursal(@unNroSucursal nvarchar(255))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idSucursalBi AS numeric(18)

        SELECT 
            @idSucursalBi = s.bi_sucursal_id
        FROM [MONSTERS_INC].BI_Sucursal s
        WHERE s.sucursal_desc = @unNroSucursal

        RETURN @idSucursalBi
    END
GO

/* --- MIGRACION DE DATOS HACIA MODELO BI ---*/

/* BI_Tiempo */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Tiempo
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Tiempo
    (bi_tiempo_anio, bi_tiempo_cuatrimestre , bi_tiempo_mes)
    SELECT 
        year(t.tick_fecha_hora),
        datepart(Q, t.tick_fecha_hora),
        month(t.tick_fecha_hora)
    FROM [MONSTERS_INC].Ticket t
    UNION
    SELECT 
        year(e.entr_fecha_hora_entrega),
        datepart(Q, e.entr_fecha_hora_entrega),
        month(e.entr_fecha_hora_entrega)
    FROM [MONSTERS_INC].Entrega e
    UNION
    SELECT 
        year(en.envio_fecha),
        datepart(Q, en.envio_fecha),
        month(en.envio_fecha)
    FROM [MONSTERS_INC].Envio en
    UNION
    SELECT 
        year(d.desc_fecha_fin),
        datepart(Q, d.desc_fecha_fin),
        month(d.desc_fecha_fin)
    FROM [MONSTERS_INC].Descuento_Medio_Pago d
END
GO

/* BI_Ubicacion */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Ubicacion
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Ubicacion
    (provincia_desc, localidad_desc)
    SELECT
        p.prov_nombre,
        l.loca_nombre
    FROM [MONSTERS_INC].Provincia p
        INNER JOIN [MONSTERS_INC].Localidad l ON p.prov_id = l.loca_provincia
END
GO

/* BI_Sucursal */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Sucursal
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Sucursal
    (sucursal_desc)
    SELECT
        s.sucu_numero
    FROM [MONSTERS_INC].Sucursal s
END
GO

/* BI_Rango_Etario */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Rango_Etario
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Rango_Etario
    (rango_etario_desc)
    SELECT
        [MONSTERS_INC].BI_Resolver_Rango_Etario(e.empl_fecha_nacimiento)
    FROM [MONSTERS_INC].Empleado e
    UNION
    SELECT
        [MONSTERS_INC].BI_Resolver_Rango_Etario(c.clie_fecha_nacimiento)
    FROM [MONSTERS_INC].Cliente c
END
GO

--

/* BI_Turno */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Turno
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Turno
    (turno_desc)
    SELECT DISTINCT
        [MONSTERS_INC].BI_Resolver_Turno(t.tick_fecha_hora)
    FROM [MONSTERS_INC].Ticket t
END
GO

/* BI_Categoria */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Categoria
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Categoria
    (subc_descripcion, catm_descripcion)
    SELECT
        c.subc_descripcion,
        cm.catm_descripcion
    FROM [MONSTERS_INC].Categoria c
        INNER JOIN [MONSTERS_INC].Categoria_Mayor cm on cm.subc_categoria_mayor = c.catm_id 
END
GO

/* BI_Caja_Tipo */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Caja_Tipo
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Caja_Tipo
    (caja_desc, caja_nro)
    SELECT DISTINCT
        c.caja_tipo,
        c.caja_nro
    FROM [MONSTERS_INC].Caja c
END
GO


/* BI_Empleado */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Empleado
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Empleado
    (empl_desc, empl_dni)
    SELECT DISTINCT
        e.empl_nombre + e.empl_apellido,
        e.empl_dni
    FROM [MONSTERS_INC].Empleado e
END
GO 

/* BI_Ticket */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Ticket
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Ticket
    (ticket_nro)
    SELECT DISTINCT
        t.tick_nro
    FROM [MONSTERS_INC].Ticket t
END
GO

/* BI_Medio_Pago */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Medio_Pago
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Medio_Pago
    (medio_pago_tipo, medio_pago_nombre)
    SELECT DISTINCT
        m.medio_pago_tipo,
        m.medio_pago_nombre
    FROM [MONSTERS_INC].Medio_Pago m
        LEFT JOIN [MONSTERS_INC].Descuento_Medio_Pago d on m.medio_pago_id = d.desc_medio_pago
END
GO

/* BI_Hechos_Venta */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Hechos_Venta
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Hechos_Venta
    (bi_ubicacion_id, bi_tiempo_id , bi_turno_id, bi_caja_tipo_id, bi_rango_etario_id, 
    bi_empleado_id, bi_ticket_id, bi_medio_pago_id, importe_unitario, cantidad_productos, 
    descuento_total, descuento_promo_prod, categoria_desc)
    SELECT
        (SELECT TOP 1
                [MONSTERS_INC].BI_Obtener_Id_Ubicacion(p.prov_nombre, l.loca_nombre)
            FROM [MONSTERS_INC].Caja c
            INNER JOIN [MONSTERS_INC].Sucursal s ON s.sucu_id = c.caja_sucursal
            INNER JOIN [MONSTERS_INC].Localidad l ON l.loca_id  = s.sucu_localidad 
            INNER JOIN [MONSTERS_INC].Provincia p ON p.prov_id = l.loca_provincia
            WHERE c.caja_id = t.tick_caja
        ),
        [MONSTERS_INC].BI_Obtener_Id_Tiempo(t.tick_fecha_hora),
        [MONSTERS_INC].BI_Obtener_Id_Turno(t.tick_fecha_hora),
        [MONSTERS_INC].BI_Obtener_Id_Caja_Tipo(t.tick_caja),
        [MONSTERS_INC].BI_Obtener_Id_Rango_Etario(t.tick_empleado),
        [MONSTERS_INC].BI_Obtener_Id_Empleado(t.tick_empleado),
        [MONSTERS_INC].BI_Obtener_Id_Ticket(t.tick_nro),
        [MONSTERS_INC].BI_Obtener_Id_Medio_Pago(p.pago_medio_pago),
        it.item_tick_total, 
        it.item_tick_cantidad,
        it.item_tick_descuento_aplicado,
        it.item_tick_descuento_aplicado - (
            SELECT mp.desc_apli_descuento_aplicado 
            FROM [MONSTERS_INC].Pago pp
                INNER JOIN [MONSTERS_INC].Descuento_Medio_Pago_Aplicado mp on mp.desc_apli_pago = pp.pago_id
            WHERE pp.pago_id = p.pago_id
        ),
        (SELECT cm.catm_descripcion FROM [MONSTERS_INC].Producto pc
            INNER JOIN [MONSTERS_INC].Subcategoria sc ON pc.prod_subcategoria = sc.subc_id
            INNER JOIN [MONSTERS_INC].Categoria_Mayor cm ON cm.catm_id = sc.subc_categoria_mayor
        WHERE pc.prod_id = it.item_tick_producto)
    FROM [MONSTERS_INC].Ticket t
        INNER JOIN [MONSTERS_INC].Item_Ticket it on it.item_tick_ticket = t.tick_id
        LEFT JOIN [MONSTERS_INC].Pago p ON p.pago_ticket = t.tick_id
END
GO

/* BI_Hechos_Envio */
CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Hechos_Envio
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Hechos_Envio
    (bi_tiempo_id, bi_sucursal_id,  
    bi_rango_etario_id, bi_ubicacion_id, envi_fecha_programada, envi_fecha_entrega,envi_costo)
    SELECT 
        [MONSTERS_INC].BI_Obtener_Id_Tiempo(e.envio_fecha),
        (
            select 
                [MONSTERS_INC].BI_Obtener_Id_Sucursal(sc.sucu_numero)
            from [MONSTERS_INC].Ticket ts
                inner join [MONSTERS_INC].Caja cs on ts.tick_caja = cs.caja_id
                inner join [MONSTERS_INC].Sucursal sc on cs.caja_sucursal = sc.sucu_id
            where e.envio_ticket = ts.tick_id
        ),
        [MONSTERS_INC].BI_Obtener_Id_Rango_Etario_Clie(c.clie_id),
        (SELECT TOP 1
                [MONSTERS_INC].BI_Obtener_Id_Ubicacion(p.prov_nombre, l.loca_nombre)
            FROM [MONSTERS_INC].Localidad l
            INNER JOIN [MONSTERS_INC].Provincia p ON p.prov_id = l.loca_provincia
            WHERE l.loca_id = c.clie_localidad),
        e.envio_fecha,
        en.entr_fecha_hora_entrega,
        e.envio_costo
    FROM [MONSTERS_INC].Envio e
        INNER JOIN [MONSTERS_INC].Entrega en on en.entr_id = e.envio_entrega
        INNER JOIN [MONSTERS_INC].Cliente c on c.clie_id = e.envio_cliente
END
GO

/* BI_Hechos_Cuota */
CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Hechos_Cuota
AS
BEGIN
    INSERT INTO [MONSTERS_INC].[BI_Hechos_Cuota]
    (bi_tiempo_id, bi_sucursal_id,  
    bi_rango_etario_id, bi_medio_pago_id, cantidad_cuotas, importe_cuota)
    SELECT 
        [MONSTERS_INC].BI_Obtener_Id_Tiempo(t.tick_fecha_hora),
        (
            select 
                [MONSTERS_INC].BI_Obtener_Id_Sucursal(sc.sucu_numero)
            from [MONSTERS_INC].Sucursal sc
            where sc.sucu_id = c.caja_sucursal
        ),
        [MONSTERS_INC].BI_Obtener_Id_Rango_Etario_Clie(e.envio_cliente),
        [MONSTERS_INC].BI_Obtener_Id_Medio_Pago(p.pago_medio_pago),
        d.deta_tarjeta_cuotas,
        t.tick_total/d.deta_tarjeta_cuotas
    FROM [MONSTERS_INC].Ticket t
        INNER JOIN [MONSTERS_INC].Envio e on e.envio_ticket = t.tick_id
        INNER JOIN [MONSTERS_INC].Caja c on c.caja_id = t.tick_caja
        INNER JOIN [MONSTERS_INC].Pago p on p.pago_ticket = t.tick_id
        LEFT JOIN [MONSTERS_INC].Detalle_Pago d on d.deta_id = p.pago_detalle 
END
GO

/* CREACION DE VISTAS */

PRINT '--- CREACION DE VISTAS ---';

-----------------------------------------------------------------------------  1

IF Object_id('MONSTERS_INC.BI_Vista_Ticket_Promedio_Mensual') IS NOT NULL 
  DROP VIEW [MONSTERS_INC].BI_Vista_Ticket_Promedio_Mensual
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Ticket_Promedio_Mensual AS
SELECT
    sum(v.cantidad_productos*v.importe_unitario) / count(distinct v.bi_ticket_id) AS PromedioMes,
    count(distinct v.bi_ticket_id) as aux,
    u.localidad_desc,
    t.bi_tiempo_anio AS Año,
    t.bi_tiempo_mes AS Mes
FROM [MONSTERS_INC].BI_Hechos_Venta v
	JOIN [MONSTERS_INC].BI_Tiempo t ON v.bi_tiempo_id = t.bi_tiempo_id
	JOIN [MONSTERS_INC].BI_Ubicacion u ON v.bi_ubicacion_id = u.bi_ubicacion_id
GROUP BY
    t.bi_tiempo_mes,
    t.bi_tiempo_anio,
    u.localidad_desc
GO

-----------------------------------------------------------------------------  2

IF Object_id('MONSTERS_INC.BI_Vista_Cantidad_Unidades_Promedio') IS NOT NULL 
  DROP VIEW [MONSTERS_INC].BI_Vista_Cantidad_Unidades_Promedio
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Cantidad_Unidades_Promedio AS
SELECT
	sum(v.cantidad_productos) / count(distinct v.bi_ticket_id) as Promedio,
	--para cada turno
	tu.turno_desc as Turno,
    --para cada cuatrimestre
	t.bi_tiempo_cuatrimestre as Cuatrimestre,
    --para cada anio
	t.bi_tiempo_anio as Año
FROM [MONSTERS_INC].BI_Hechos_Venta v
	inner join [MONSTERS_INC].BI_Tiempo t on v.bi_tiempo_id = t.bi_tiempo_id
	inner join [MONSTERS_INC].BI_Turno tu on tu.bi_turno_id = v.bi_turno_id
	inner join [MONSTERS_INC].BI_Ticket i on i.bi_ticket_id = v.bi_ticket_id
GROUP BY
	--3,
	tu.turno_desc,
	t.bi_tiempo_cuatrimestre,
	t.bi_tiempo_anio
GO

-----------------------------------------------------------------------------  3

IF Object_id('MONSTERS_INC.BI_Vista_Porcentaje_Anual_Cuatrimestre') IS NOT NULL 
  DROP VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Anual_Cuatrimestre
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Anual_Cuatrimestre AS
SELECT
    r.rango_etario_desc as RangoEtario,
    c.caja_desc as TipoCaja,
    t.bi_tiempo_cuatrimestre as Cuatrimestre,
    t.bi_tiempo_anio as Anio,
    (
        count(distinct v.bi_ticket_id) * 100 /
        (
            SELECT 
                count(distinct v2.bi_ticket_id)
		    FROM  [MONSTERS_INC].BI_Hechos_Venta v2
            	INNER JOIN  [MONSTERS_INC].BI_Tiempo t2 ON v2.bi_tiempo_id = t2.bi_tiempo_id
                INNER JOIN [MONSTERS_INC].BI_Caja_Tipo c2 ON c2.bi_caja_tipo_id = v2.bi_caja_tipo_id
	            INNER JOIN [MONSTERS_INC].BI_Rango_Etario r2 on r2.bi_rango_etario_id = v2.bi_rango_etario_id
                WHERE c2.caja_desc = c.caja_desc and r.rango_etario_desc = r2.rango_etario_desc and t2.bi_tiempo_anio = t.bi_tiempo_anio
        )
    ) as Porcentaje
FROM 
    [MONSTERS_INC].BI_Hechos_Venta v
	JOIN [MONSTERS_INC].BI_Tiempo t ON v.bi_tiempo_id = t.bi_tiempo_id
	JOIN [MONSTERS_INC].BI_Caja_Tipo c ON c.bi_caja_tipo_id = v.bi_caja_tipo_id
	JOIN [MONSTERS_INC].BI_Rango_Etario r on r.bi_rango_etario_id = v.bi_rango_etario_id
GROUP BY
    r.rango_etario_desc,
    c.caja_desc,	
    t.bi_tiempo_cuatrimestre,
    t.bi_tiempo_anio
GO

-----------------------------------------------------------------------------  4

IF Object_id('MONSTERS_INC.BI_Vista_Cantidad_Ventas_Por_Turno') IS NOT NULL 
  DROP VIEW [MONSTERS_INC].BI_Vista_Cantidad_Ventas_Por_Turno
GO


CREATE VIEW [MONSTERS_INC].BI_Vista_Cantidad_Ventas_Por_Turno AS
SELECT
    u.localidad_desc as Localidad,
    t.bi_tiempo_mes as Mes,
    t.bi_tiempo_anio as Año,
	tu.turno_desc as Turno,
    sum(v.cantidad_productos) as CantidadProductos
FROM [MONSTERS_INC].BI_Hechos_Venta v
    JOIN [MONSTERS_INC].BI_Tiempo t ON t.bi_tiempo_id = v.bi_tiempo_id
	JOIN [MONSTERS_INC].BI_Turno tu ON tu.bi_turno_id = v.bi_turno_id
    JOIN [MONSTERS_INC].BI_Ubicacion u ON v.bi_ubicacion_id = u.bi_ubicacion_id
GROUP BY
    tu.turno_desc,
	u.localidad_desc,
    t.bi_tiempo_mes,
    t.bi_tiempo_anio
GO

-----------------------------------------------------------------------------  5

IF Object_id('MONSTERS_INC.BI_Vista_Porcentaje_Descuento_aplicado') IS NOT NULL 
  DROP VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_aplicado
    GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_aplicado AS
SELECT
	t.bi_tiempo_anio as Año,
	t.bi_tiempo_mes as Mes,
	(sum(distinct v.descuento_total)) * 100 / sum(v.cantidad_productos * v.importe_unitario) as Porcentaje
FROM [MONSTERS_INC].BI_Hechos_Venta v
	join [MONSTERS_INC].BI_Tiempo t on t.bi_tiempo_id = v.bi_tiempo_id
GROUP BY
	t.bi_tiempo_anio,
	t.bi_tiempo_mes
GO

-----------------------------------------------------------------------------  6

IF Object_id('MONSTERS_INC.BI_Vista_Top_3_Categorias_Descuento') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Top_3_Categorias_Descuento
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Top_3_Categorias_Descuento AS
SELECT
	t.bi_tiempo_anio as Anio,
    t.bi_tiempo_cuatrimestre as Cuatrimestre,
    v.categoria_desc as Categoria,
	sum(distinct v.descuento_promo_prod) as SumatoriaDescuentosAplicados
FROM [MONSTERS_INC].BI_Hechos_Venta v
	join [MONSTERS_INC].BI_Tiempo t on v.bi_tiempo_id = t.bi_tiempo_id
GROUP BY
    t.bi_tiempo_anio,
	t.bi_tiempo_cuatrimestre,
    v.categoria_desc
HAVING sum(distinct v.descuento_promo_prod) IN (
    SELECT TOP 3 
        sum(distinct vs.descuento_promo_prod)
    FROM [MONSTERS_INC].BI_Hechos_Venta vs
        INNER JOIN [MONSTERS_INC].BI_Tiempo ts ON vs.bi_tiempo_id = ts.bi_tiempo_id
    WHERE ts.bi_tiempo_anio = t.bi_tiempo_anio AND ts.bi_tiempo_cuatrimestre = t.bi_tiempo_cuatrimestre
    GROUP BY vs.categoria_desc
    ORDER BY 1 DESC
)
GO

-----------------------------------------------------------------------------  7

IF Object_id('MONSTERS_INC.BI_Vista_Porcentaje_Cumplimiento_Envios') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Cumplimiento_Envios
GO


CREATE VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Cumplimiento_Envios AS
SELECT
    s.bi_sucursal_id AS Sucursal,
    t.bi_tiempo_anio AS Año,
    t.bi_tiempo_mes AS Mes,
	(SUM(CASE WHEN CAST(e.envi_fecha_entrega AS date) <= CAST(e.envi_fecha_programada AS date) THEN 1 ELSE 0 END) 
    / 
    COUNT(e.bi_hechos_envio_id))*100 AS Porcentaje
FROM [MONSTERS_INC].BI_Hechos_Envio e
    JOIN [MONSTERS_INC].BI_Tiempo t ON t.bi_tiempo_id = e.bi_tiempo_id
    JOIN [MONSTERS_INC].BI_Sucursal s ON e.bi_sucursal_id = s.bi_sucursal_id
GROUP BY s.bi_sucursal_id, t.bi_tiempo_anio, t.bi_tiempo_mes;
GO

-----------------------------------------------------------------------------  8

IF Object_id('MONSTERS_INC.BI_Vista_Cantidad_Envios_Rango_Etario_Cliente') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Cantidad_Envios_Rango_Etario_Cliente
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Cantidad_Envios_Rango_Etario_Cliente AS
SELECT
    r.rango_etario_desc as RangoEtario, 
    t.bi_tiempo_cuatrimestre as Cuatrimeste,
    t.bi_tiempo_anio as Año,
    count(bi_hechos_envio_id) as Envios
FROM [MONSTERS_INC].BI_Hechos_Envio e
    JOIN [MONSTERS_INC].BI_Tiempo t ON t.bi_tiempo_id = e.bi_tiempo_id 
	JOIN [MONSTERS_INC].BI_Rango_Etario r ON r.bi_rango_etario_id = e.bi_rango_etario_id
GROUP BY
    r.rango_etario_desc,
    t.bi_tiempo_cuatrimestre,
    t.bi_tiempo_anio;
GO

-----------------------------------------------------------------------------  9

IF Object_id('MONSTERS_INC.BI_Vista_Top_5_Localidades_Mayor_Costo_Envio') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Top_5_Localidades_Mayor_Costo_Envio
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Top_5_Localidades_Mayor_Costo_Envio AS
SELECT TOP 5
    u.localidad_desc as Localidad
FROM [MONSTERS_INC].BI_Hechos_Envio e
	JOIN [MONSTERS_INC].BI_Ubicacion u on u.bi_ubicacion_id = e.bi_ubicacion_id
GROUP BY
	u.localidad_desc
ORDER BY
    sum(e.envi_costo) desc
GO

-----------------------------------------------------------------------------  10

IF Object_id('MONSTERS_INC.BI_Vista_Top_3_Sucursales_Importe_Cuotas') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Top_3_Sucursales_Importe_Cuotas
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Top_3_Sucursales_Importe_Cuotas AS
SELECT top 3
    s.bi_sucursal_id as Sucursal,
    c.bi_medio_pago_id as MedioDePago,
    t.bi_tiempo_anio as Anio,
    sum(c.importe_cuota) as ImporteCuota
FROM [MONSTERS_INC].BI_Hechos_Cuota c
    JOIN [MONSTERS_INC].BI_Tiempo t ON t.bi_tiempo_id = c.bi_tiempo_id
	join [MONSTERS_INC].BI_Sucursal s on c.bi_sucursal_id = s.bi_sucursal_id
WHERE c.cantidad_cuotas IS NOT NULL -- Puede ser null, cuidado
GROUP BY
    s.bi_sucursal_id,
	t.bi_tiempo_anio,
    c.bi_medio_pago_id
ORDER BY
    sum(c.importe_cuota) desc
GO

-----------------------------------------------------------------------------  11

IF Object_id('MONSTERS_INC.BI_Vista_Promedio_Importe_Cuota_RangoEtario') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Promedio_Importe_Cuota_RangoEtario
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Promedio_Importe_Cuota_RangoEtario AS
SELECT
    re.rango_etario_desc AS RangoEtario,
    AVG(ISNULL(c.importe_cuota,0)) AS PromedioImporteCuota
FROM [MONSTERS_INC].BI_Hechos_Cuota c
    INNER JOIN [MONSTERS_INC].BI_Rango_Etario re ON re.bi_rango_etario_id = c.bi_rango_etario_id
WHERE c.cantidad_cuotas IS NOT NULL -- Puede ser null, cuidado
GROUP BY
    re.rango_etario_desc
GO

-----------------------------------------------------------------------------  12

IF Object_id('MONSTERS_INC.BI_Vista_Porcentaje_Descuento_Por_Medio_Pago') IS NOT NULL
  DROP VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_Por_Medio_Pago
GO

CREATE VIEW [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_Por_Medio_Pago AS
SELECT
    m.medio_pago_nombre as MedioPago,
    t.bi_tiempo_anio as Año,
    t.bi_tiempo_cuatrimestre as Cuatrimestre,
    (sum(v.descuento_total - v.descuento_promo_prod) / (sum (v.cantidad_productos * v.importe_unitario)))*100 as Porcentaje
FROM [MONSTERS_INC].BI_Hechos_Venta v
    JOIN [MONSTERS_INC].BI_Tiempo t ON t.bi_tiempo_id = v.bi_tiempo_id
	join [MONSTERS_INC].BI_Medio_Pago m on v.bi_medio_pago_id = m.bi_medio_pago_id
GROUP BY
    m.medio_pago_nombre,
    t.bi_tiempo_anio,
    t.bi_tiempo_cuatrimestre
GO
-----------------------------------------------------------------------------  

PRINT '--- COMENZANDO LA MIGRACION DE DATOS BI ---'

/* EJECUTAR PROCEDURES MIGRACION BI */

EXEC [MONSTERS_INC].Migrar_BI_Tiempo
EXEC [MONSTERS_INC].Migrar_BI_Ubicacion
EXEC [MONSTERS_INC].Migrar_BI_Sucursal
EXEC [MONSTERS_INC].Migrar_BI_Rango_Etario
EXEC [MONSTERS_INC].Migrar_BI_Turno
EXEC [MONSTERS_INC].Migrar_BI_Caja_Tipo
EXEC [MONSTERS_INC].Migrar_BI_Empleado
EXEC [MONSTERS_INC].Migrar_BI_Ticket
EXEC [MONSTERS_INC].Migrar_BI_Medio_Pago
EXEC [MONSTERS_INC].Migrar_BI_Hechos_Venta
EXEC [MONSTERS_INC].Migrar_BI_Hechos_Envio
EXEC [MONSTERS_INC].Migrar_BI_Hechos_Cuota

PRINT '--- MIGRACION REALIZADA ---';

-- Referencia a vistas con fines de prueba

/*

select * from [MONSTERS_INC].BI_Vista_Ticket_Promedio_Mensual
select * from [MONSTERS_INC].BI_Vista_Cantidad_Unidades_Promedio
select * from [MONSTERS_INC].BI_Vista_Porcentaje_Anual_Cuatrimestre
select * from [MONSTERS_INC].BI_Vista_Cantidad_Ventas_Por_Turno
select * from [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_aplicado
select * from [MONSTERS_INC].BI_Vista_Top_3_Categorias_Descuento

select * from [MONSTERS_INC].BI_Vista_Porcentaje_Cumplimiento_Envios
select * from [MONSTERS_INC].BI_Vista_Cantidad_Envios_Rango_Etario_Cliente
select * from [MONSTERS_INC].BI_Vista_Top_5_Localidades_Mayor_Costo_Envio

select * from [MONSTERS_INC].BI_Vista_Top_3_Sucursales_Importe_Cuotas
select * from [MONSTERS_INC].BI_Vista_Promedio_Importe_Cuota_RangoEtario
select * from [MONSTERS_INC].BI_Vista_Porcentaje_Descuento_Por_Medio_Pago

*/
