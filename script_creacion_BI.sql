/*  

-- Equipo: MONSTERS INC
-- Fecha de entrega: 30.06.2024
-- TP CUATRIMESTRAL GDD 2024 1C

-- Ciclo lectivo: 2024
-- Descripcion: Migracion

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

/* BI Item_Ticket */
CREATE TABLE [MONSTERS_INC].[BI_Caja_Tipo]
(
    [bi_caja_tipo_id] numeric(18) IDENTITY NOT NULL,
    [caja_desc] nvarchar(255) NOT NULL,
    [caja_nro] nvarchar(18) NOT NULL
);

/* BI Item_Ticket */
CREATE TABLE [MONSTERS_INC].[BI_Empleado]
(
    [bi_empleado_id] numeric(18) IDENTITY NOT NULL,
    [empl_desc] nvarchar(255) NOT NULL,
    [empl_dni] nvarchar(255) NOT NULL
);


-- Ticket Promedio mensual -> VENTAS
-- Cantidad unidades promedio -> VENTAS
-- Porcentaje anual de ventas -> VENTAS
-- Cantidad de ventas registradas por turno -> VENTAS
-- Porcentaje de descuento aplicados en función del total de los tickets -> Descuento [... Continuara (?]

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
    [bi_empleado_id] numeric(18) NOT NULL,
    [importe_unitario] numeric(18) NOT NULL,
    [cantidad_productos] numeric(18) NOT NULL,
);

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

        RETURN 'Error al leer Rango Etario'
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

        RETURN 'Error al leer Turno'
    END
GO

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Tiempo(@unaFecha datetime)
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idFecha AS numeric(18)

        SELECT 
            @idFecha = t.bi_tiempo_id
        FROM [MONSTERS_INC].BI_Tiempo
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

        SELECT 
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

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Caja_Tipo(@unTipo nvarchar(10), @unNroCaja decimal(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idCajaTipo AS numeric(18)

        SELECT 
            @idCajaTipo = ct.bi_caja_tipo_id
        FROM [MONSTERS_INC].BI_Caja_Tipo ct
        WHERE ct.caja_desc = @unTipo AND ct.caja_nro = @unNroCaja

        RETURN @idCajaTipo
    END
GO

-- Revisar si los parametros son comodos para despues joinear en las tablas de hechos

CREATE FUNCTION [MONSTERS_INC].BI_Obtener_Id_Empleado(@nombreEmpleado nvarchar(128), @apellidoEmpleado nvarchar(128), @unDni numeric(18))
RETURNS numeric(18)
AS
    BEGIN
        DECLARE @idEmpleado AS numeric(18)

        SELECT 
            @idCajaTipo = e.bi_empleado_id
        FROM [MONSTERS_INC].BI_Empleado e
        WHERE e.empl_desc = @nombreEmpleado + @apellidoEmpleado AND e.empl_dni = @unDni

        RETURN @idEmpleado
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

/* BI_Medio_Pago */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Medio_Pago
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Medio_Pago
    (medio_pago_tipo, medio_pago_nombre)
    SELECT
        m.medio_pago_tipo,
        m.medio_pago_nombre
    FROM [MONSTERS_INC].Medio_Pago m
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

/* BI_Hechos_Venta */

CREATE PROCEDURE [MONSTERS_INC].Migrar_BI_Hechos_Venta
AS
BEGIN
    INSERT INTO [MONSTERS_INC].BI_Hechos_Venta
    (bi_ubicacion_id, bi_tiempo_id , bi_turno_id, bi_caja_tipo_id, 
    bi_empleado_id, importe_unitario, cantidad_productos)
    SELECT 
        [MONSTERS_INC].BI_Obtener_Id_Ubicacion(),
        [MONSTERS_INC].BI_Obtener_Id_Tiempo(t.tick_fecha_hora),,,,, it.item_tick_total, i.item_tick_cantidad
    FROM [MONSTERS_INC].Ticket t
        INNER JOIN [MONSTERS_INC].Item_Ticket it on it.item_tick_ticket = t.tick_id
END
GO

/* EJECUTAR PROCEDURES MIGRACION BI */

EXEC [MONSTERS_INC].Migrar_BI_Tiempo
EXEC [MONSTERS_INC].Migrar_BI_Ubicacion
EXEC [MONSTERS_INC].Migrar_BI_Sucursal
EXEC [MONSTERS_INC].Migrar_BI_Rango_Etario
EXEC [MONSTERS_INC].Migrar_BI_Turno
EXEC [MONSTERS_INC].Migrar_BI_Caja_Tipo
EXEC [MONSTERS_INC].Migrar_BI_Empleado


/* CREACION DE VISTAS */

-----------------------------------------------------------------------------  1
CREATE VIEW MONSTERS_INC_Vista_Ticket_Promedio_Mensual AS
SELECT
    (v.cantidad_productos*v.importe_unitario)/v.cantidad_productos AS PromedioMes,
    u.localidad_desc,
    t.bi_tiempo_anio AS Año,
    t.bi_tiempo_mes AS Mes
FROM MONSTERS_INC.BI_Hechos_Venta v
	JOIN MONSTERS_INC.BI_Tiempo t ON v.bi_tiempo_id = t.bi_tiempo_id
	JOIN MONSTERS_INC.BI_Ubicacion u ON v.bi_ubicacion_id = u.bi_ubicacion_id
GROUP BY
    t.bi_tiempo_mes,
    t.bi_tiempo_anio,
    u.localidad_desc
GO

-----------------------------------------------------------------------------  2
CREATE VIEW MONSTERS_INC_Vista_Cantidad_Unidades_Promedio AS
SELECT
	(v.cantidad_productos*v.importe_unitario)/v.cantidad_productos as Promedio,
	--para cada turno
	tu.turno_desc as Turno,
    --para cada cuatrimestre
	t.bi_tiempo_cuatrimestre as Cuatrimestre,
    --para cada anio
	t.bi_tiempo_anio as Año
FROM MONSTERS_INC.BI_Hechos_Venta v
	join MONSTERS_INC.BI_Tiempo t on v.bi_tiempo_id = t.bi_tiempo_id
	join MONSTERS_INC.BI_Turno tu on tu.bi_turno_id = v.bi_turno_id
	join MONSTERS_INC.BI_Ticket i on i.bi_ticket_id = v.bi_ticket
GROUP BY
	--3,
	tu.turno_desc,
	t.bi_tiempo_cuatrimestre,
	t.bi_tiempo_cuatrimestre
GO

-----------------------------------------------------------------------------  3

CREATE VIEW MONSTERS_INC_BI_Porcentaje_Anual_Cuatrimestre AS
SELECT
    MONSTERS_INC.BI_Resolver_Rango_Etario(e.empleado_fecha_nacimiento) as RangoEtario, -- falta atributo fecha nacimiento
    c.caja_desc as TipoCaja,
    t.bi_tiempo_cuatrimestre as Cuatrimestre,
    (
        SUM(v.cantidad_productos*v.importe_unitario)/
        (SELECT SUM(v2.cantidad_productos*v2.importe_unitario)
		FROM  MONSTERS_INC.BI_Hechos_Venta v2
		JOIN  MONSTERS_INC.BI_Tiempo t2 ON v2.bi_tiempo_id = t2.bi_tiempo_id
		WHERE t2.bi_tiempo_anio = t.bi_tiempo_anio) * 100 ) as Porcentaje
FROM 
    MONSTERS_INC.BI_Hechos_Venta v
	JOIN MONSTERS_INC.BI_Tiempo t ON v.bi_tiempo_id = t.bi_tiempo_id
	JOIN MONSTERS_INC.BI_Caja_Tipo c ON c.bi_caja_tipo_id = v.bi_caja_tipo_id
	JOIN MONSTERS_INC.BI_Empleado e ON v.bi_empleado_id = e.bi_empleado_id
	JOIN MONSTERS_INC.BI_Rango_Etario r on r.bi_rango_etario_id = e.bi_empleado_id		--esto al pedo creo
GROUP BY
    MONSTERS_INC.BI_Resolver_Rango_Etario(e.empleado_fecha_nacimiento),		-- falta atributo fecha nacimiento
	r.rango_etario_desc,													-- estop o el de arriba(aca no esta conectado con empleado creo)
    c.caja_desc,	
    t.bi_tiempo_cuatrimestre,
    t.bi_tiempo_anio
GO

-----------------------------------------------------------------------------  4

CREATE VIEW MONSTERS_INC_Vista_Cantidad_Ventas_Por_Turno_ AS
SELECT
    u.localidad_desc as Localidad,
    t.bi_tiempo_mes as Mes,
    t.bi_tiempo_anio as Año,
	tu.turno_desc as Turno,
    count(*) as v.cantidad_productos
FROM MONSTERS_INC.BI_Hechos_Venta v
    JOIN MONSTERS_INC.BI_Tiempo t ON t.bi_tiempo_id = v.bi_tiempo_id
	JOIN MONSTERS_INC.BI_Turno tu ON tu.bi_turno_id = v.bi_turno_id
    JOIN MONSTERS_INC.BI_Ubicacion u ON v.bi_ubicacion_id = u.bi_ubicacion_id
GROUP BY
    tu.turno_desc,
	u.localidad_desc,
    t.bi_tiempo_mes,
    t.bi_tiempo_anio
GO

-----------------------------------------------------------------------------  5

CREATE VIEW MONSTERS_INC_BI_Vista_Porcentaje_Descuento_aplicado AS
SELECT
	t.bi_tiempo_anio as Año,
	t.bi_tiempo_mes as Mes,
	(count(distinct ti.ticket_total_descuento_aplicado) * 100) / (count (distinct v.bi_hechos_venta_id)) as Porcentaje
FROM MONSTERS_INC.BI_Hechos_Venta v
	join MONSTERS_INC.BI_Tiempo t on t.bi_tiempo_id = v.bi_tiempo_id
	join MONSTERS_INC.bi_Ticket ti on ti.ticket_id = v.bi_ticket_id
WHERE ti.ticket_total_descuento_aplicado is not null
GROUP BY
	t.bi_tiempo_anio,
	t.bi_tiempo_mes
GO

-----------------------------------------------------------------------------  6

CREATE VIEW MONSTERS_INC_Vista_Top_3_Categorias_Descuento AS
SELECT top 3
	t.bi_tiempo_anio as Anio,
    t.bi_tiempo_cuatrimestre as Cuatrimestre,
    pc.producto_categoria_detalle as Categoria,
	sum(ti.ticket_total_descuento_aplicado) as SumatoriaDescuentosAplicados
FROM MONSTERS_INC.BI_Hechos_Venta v
	join MONSTERS_INC.BI_Tiempo t on v.bi_tiempo_id = t.bi_tiempo_id
	join MONSTERS_INC.BI_Ticket ti on v.bi_ticket_id = ti.bi_ticket_id
	join MONSTERS_INC.Producto p on ti.id_producto = p.id_producto
	join MONSTERS_INC.BI_Producto_categoria pc on p.id_producto_categoria = pc.id_producto_categoria
WHERE ti.ticket_total_descuento_aplicado IS NOT NULL
GROUP BY
    t.bi_tiempo_anio,
	t.bi_tiempo_cuatrimestre,
	pc.producto_categoria_detalle
ORDER BY
	sum(ti.ticket_total_descuento_aplicado)
GO
