/*
Crear BD en sql server (TIENDADB) con las siguientes tablas y relaciones:

* MARCA:     (catálogo de marcas, Levis, H&M, Jack&Jones...)
MarcaId            Identity
Codigo             Numeric
Descripcion        VARCHAR(100)


* TIPOPRODUCTO:    (catálogo de tipo de productos - Sombrero, Perfume, Jeans, camiseta...)
TipoProductoId    Identity
Codigo            Numeric
Nombre            VARCHAR(50)


* PRODUCTO:     (Producto específico - Camiseta verde XL, Perfume hombre 50mm, Pantalon Denim 44)
ProductoId        Identity
MarcaId            Numeric    - FK Marca.MarcaId
TipoProductoId    Numeric - Foreign key TIPOPRODUCTO.TipoProductoId
Descripcion        VARCHAR(100)
Talle            VARCHAR(20)
Color            VARCHAR(20)
Precio            money
Stock            Numeric


* TICKET:        (
TicketId             Identity
Fecha                datetime
Subtotal            money
Descuento            money
Importe                money
CantidadProductos    Numeric


* TICKETDETALLE
TicketDetalleId    Identity
TicketId        Numeric - FK.TICKET.TicketId
ProductoId        numeric - FK PRODUCTO.ProductoId
*/

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'TIENDADB')
  BEGIN
    CREATE DATABASE [TIENDADB]
  END

  GO
	USE [TIENDADB]
  GO

IF OBJECT_ID('MARCA', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.MARCA (
		MarcaId int IDENTITY PRIMARY KEY,
		Codigo int,
		Descripcion VARCHAR(100)
	);
END

IF OBJECT_ID('TIPOPRODUCTO', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.TIPOPRODUCTO (
		TipoProductoId int IDENTITY PRIMARY KEY,
		Codigo int,
		Nombre VARCHAR(50)
	);
END

IF OBJECT_ID('PRODUCTO', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.PRODUCTO (
		ProductoId int IDENTITY PRIMARY KEY,
		MarcaId int FOREIGN KEY REFERENCES dbo.MARCA(MarcaId),
		TipoProductoId int FOREIGN KEY REFERENCES dbo.TIPOPRODUCTO(TipoProductoId),
		Descripcion VARCHAR(100),
		Talle VARCHAR(20),
		Color VARCHAR(20),
		Precio MONEY,
		Stock int
	);
END

IF OBJECT_ID('TICKET', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.TICKET (
		TicketId int IDENTITY PRIMARY KEY,
		Fecha datetime,
		Subtotal MONEY,
		Descuento MONEY,
		Importe MONEY,
		CantidadProductos int
	);
END

IF OBJECT_ID('TICKETDETALLE', 'U') IS NULL
BEGIN
	CREATE TABLE dbo.TICKETDETALLE (
		TicketDetalleId int IDENTITY PRIMARY KEY,
		TicketId int FOREIGN KEY REFERENCES dbo.TICKET(TicketId),
		ProductoId int FOREIGN KEY REFERENCES dbo.PRODUCTO(ProductoId),
		Descuento MONEY,
		Importe MONEY,
		CantidadProductos int
	);
END