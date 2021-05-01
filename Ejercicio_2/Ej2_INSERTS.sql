/*
Crear un script para poblar la tabla Productos con 1.000 registros bajo estas particularidades:

1- El nombre del producto será "CAMISETA STYLE art "+ Numero random de 4 posiciones completado con ceros a la izquierda.
2- Color del producto:
Si el segundo (tiempo) donde se realiza el insert es número par el valor a ingresar será "Azul"
Si el segundo donde se realiza el insert es número impar debe ser de color "Blanco"
Si el segundo donde se realiza el insert es 0 debe ser de color "Rojo"
3- El importe debe ser variable entre 20 y 45
4- El stock debe ser variable (utilizar los milisegundos de la fecha como valor)
5- Los primeros 500 productos deben ser de Marca 1, el resto de Marca 2.
6- El tipo de producto debe ser 7.
7-Poblar las tablas necesarias previamente a la ejecución del script.
*/

USE TIENDADB;

BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM [dbo].[TIPOPRODUCTO] WHERE [TipoProductoId] = 7)
	BEGIN
		SET IDENTITY_INSERT [dbo].[TIPOPRODUCTO] ON
		INSERT INTO [dbo].[TIPOPRODUCTO] ([TipoProductoId], [Codigo], [Nombre]) VALUES (7, 777, 'Camiseta');
		SET IDENTITY_INSERT [dbo].[TIPOPRODUCTO] OFF
	END

IF NOT EXISTS (SELECT 1 FROM [dbo].[MARCA] WHERE [MarcaId] = 1)
	BEGIN
		SET IDENTITY_INSERT [dbo].[MARCA] ON
		INSERT INTO [dbo].[MARCA] ([MarcaId], [Codigo], [Descripcion]) VALUES (1, 788, 'Levis');
		SET IDENTITY_INSERT [dbo].[MARCA] OFF
	END

IF NOT EXISTS (SELECT 1 FROM [dbo].[MARCA] WHERE [MarcaId] = 2)
	BEGIN
		SET IDENTITY_INSERT [dbo].[MARCA] ON
		INSERT INTO [dbo].[MARCA] ([MarcaId], [Codigo], [Descripcion]) VALUES (2, 455, 'D&G');
		SET IDENTITY_INSERT [dbo].[MARCA] OFF
	END


DECLARE @artNum AS VARCHAR(4);
DECLARE @tallaRandom AS int;
DECLARE @talla AS VARCHAR(2);
DECLARE @segundos AS int;
DECLARE @numStock AS int;
DECLARE @precio AS int;


DECLARE @fila int = 1
WHILE @fila >= 1 AND @fila <= 1000
	BEGIN
		SET @artNum = right( '000' + cast(FLOOR(RAND()*(1000-0+1))+0 AS varchar(4)), 4);
		SET @tallaRandom = FLOOR(RAND()*(4-1+1))+1;
		SET @talla = CHOOSE(@tallaRandom, 'S', 'M', 'L', 'XL');
		SET @segundos = DATEPART(SECOND, GETDATE());
		SET @numStock = DATEPART(MILLISECOND, GETDATE());
		SET @precio = RAND()*(45-20+1)+20;

		INSERT INTO [dbo].PRODUCTO ([MarcaId], [TipoProductoId], [Descripcion], [Talle], [Color], [Precio], [Stock])
		VALUES (CASE WHEN @fila <= 500 THEN 1
					ELSE 2
					END, 7, 'CAMISETA STYLE art. '+ CONVERT(NVARCHAR(MAX),@artNum), @talla, CASE 
                                                                                            WHEN @segundos % 2 = 0 THEN 'Azul'
																							WHEN @segundos %2 != 0 THEN 'Blanco'
																							WHEN @segundos = 0 THEN 'Rojo'
																							END, @precio, @numStock);
		SET @fila = @fila + 1;
	END

COMMIT;