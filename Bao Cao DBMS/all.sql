create database SHOP_DBMS;

GO

use SHOP_DBMS

GO

CREATE TABLE [dbo].[Categories](
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[Name][varchar](255) NOT NULL,
	[Slug][varchar](255) NOT NULL,
	[Visibility][bit] NOT NULL,
	[PostCount][int] NOT NULL,
	[CreatedAt][datetime] NOT NULL,
	[UpdatedAt][datetime] NOT NULL,
)

GO

CREATE TABLE [dbo].[Pots](
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[CategoryId][bigint] NOT NULL,
	[Title][varchar](255) NOT NULL,
	[Slug][varchar](255) NOT NULL,
	[ShortDescription][varchar](255) NOT NULL,
	[Content][text] NOT NULL,
	[Image][varchar](255) NOT NULL,
	[Visibility][bit] NOT NULL,
	[CreatedAt][datetime] NOT NULL,
	[UpdatedAt][datetime] NOT NULL,

	CONSTRAINT FK_CategoryPost FOREIGN KEY (CategoryId)
    REFERENCES Categories(Id)
)

GO

CREATE TABLE [dbo].[Catalogs](
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[Name][varchar](255) NOT NULL,
	[Slug][varchar](255) NOT NULL,
	[Visibility][bit] NOT NULL,
	[ProductCount][int] NOT NULL,
	[CreatedAt][datetime] NOT NULL,
	[UpdatedAt][datetime] NOT NULL,
)

GO

CREATE TABLE [dbo].[Products](
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[CatalogId][bigint] NOT NULL,
	[Name][varchar](255) NOT NULL,
	[Slug][varchar](255) NOT NULL,
	[ShortDescription][varchar](255) NOT NULL,
	[Description][text] NOT NULL,
	[Image][varchar](255) NOT NULL,
	[Price][decimal](18,4) NOT NULL,
	[Visibility][bit] NOT NULL,
	[CreatedAt][datetime] NOT NULL,
	[UpdatedAt][datetime] NOT NULL,

	CONSTRAINT FK_CatalogProduct FOREIGN KEY (CatalogId)
    REFERENCES Catalogs(Id)
)

GO

CREATE TABLE [dbo].[Customers] (
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[FristName][varchar](50) NOT NULL,
	[LastName][varchar](50) NOT NULL,
	[Phone][varchar](50) NOT NULL,
	[Email][varchar](255) NOT NULL,
	[Address][varchar](255) NOT NULL,
	[City][varchar](100) NOT NULL,
	[Note][varchar](255) NOT NULL
)

GO

CREATE TABLE [dbo].[Orders] (
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[CustomerId][bigint] NOT NULL,
	[OrderDate][datetime] NOT NULL,

	CONSTRAINT FK_CusromerOrder FOREIGN KEY (CustomerId)
    REFERENCES Customers(Id)
)

GO

CREATE TABLE [dbo].[OrderDetails] (
	[OrderId][bigint] NOT NULL,
	[ProductId][bigint] NOT NULL,
	[Quantity][int] NOT NULL,

	CONSTRAINT PK_OrderDetail PRIMARY KEY (OrderId,ProductId),
	FOREIGN KEY (OrderId) REFERENCES Orders(Id),
	FOREIGN KEY (ProductId) REFERENCES Products(Id)
)

GO

CREATE TABLE [dbo].[Users] (
	[Id][bigint] IDENTITY(1,1) PRIMARY KEY,
	[Name][varchar](255) NOT NULL,
	[Username][varchar](255) NOT NULL,
	[PasswordHash][varbinary](MAX) NOT NULL,
	[PasswordSalt][varbinary](MAX) NOT NULL
)

GO

-- ////////////////////////////////////////// VIEW \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

CREATE VIEW [dbo].[view_CustomerOrders] AS
SELECT [o].[Id]  as OrderId, [OrderDate],
	   [c].[Id] as CustomerId, [c].[FristName], [c].[LastName], [c].[Phone], [c].[Email], [c].[Address], [c].[City], [c].[Note]
		FROM Customers as c
		INNER JOIN Orders as o
		ON c.Id = o.CustomerId

GO

CREATE VIEW [dbo].[view_CustomerOrderDetails] AS
SELECT [o].[Id]  as OrderId, [OrderDate],
	   [c].[Id] as CustomerId, [c].[FristName], [c].[LastName], [c].[Phone], [c].[Email], [c].[Address], [c].[City], [c].[Note],
	   [od].[ProductId] as ProductId, [od].[Quantity],
	   [p].[Name] as ProductName, [p].[Price]
		FROM [dbo].[Orders] as o
		INNER JOIN [dbo].[Customers] as c
		ON [c].[Id] = [o].[CustomerId]
		INNER JOIN [dbo].[OrderDetails] as od
		ON [od].[OrderId] = [o].[Id]
		INNER JOIN [dbo].[Products] as p
		ON [od].[ProductId] = [p].[Id]

GO

-- ////////////////////////////////////////// FUNTION \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

CREATE FUNCTION [dbo].[func_CalculatePriceQuantityProduct]
(
	@quantity int,
	@price decimal
)
RETURNS decimal
AS
BEGIN
	DECLARE @TotalPrice decimal
	set @TotalPrice = @quantity * @price
	return @TotalPrice 
END

GO

CREATE FUNCTION [dbo].[func_CalculateTotalPriceOneOrder]()
RETURNS @TotalBillPrice table
(
	OrderId bigint,
	TotalProduct int,
	TotalPrice decimal
)
AS
BEGIN
	INSERT INTO @TotalBillPrice
	select OrderId, SUM(Quantity) as TotalProduct ,SUM([dbo].[func_CalculatePriceQuantityProduct]([c].[Quantity], [c].[Price])) AS TotalPrice
	FROM [dbo].[view_CustomerOrderDetails] as c
	GROUP BY OrderId
	return 
END

GO

CREATE FUNCTION [dbo].[func_TotalIncome]()
RETURNS @TotalPrice table
(
	TotalIncome decimal
)
AS
BEGIN
	INSERT INTO @TotalPrice
	SELECT ISNULL(SUM(t.TotalPrice), 0) as TotalIncome
	FROM (SELECT * FROM [dbo].[func_CalculateTotalPriceOneOrder]()) as t
	GROUP BY t.OrderId, t.TotalProduct
	return 
END

GO

-- ////////////////////////////////////////// STORE PROCEDUCE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

-- =================================== USERS ===================================== --
-- Get User By Username
create procedure [dbo].[GetUserByUserName]  
(  
	@Username varchar(255)
)  
As  
BEGIN  
	 SELECT * FROM [dbo].[Users] as u
	 WHERE [u].[Username] = @Username
END

GO

create procedure [dbo].[InsertUser]  
(  
    @Name varchar(255),  
	@Username varchar(255),
	@PasswordHash varbinary(MAX),
	@PasswordSalt varbinary(MAX)
)  
As  
BEGIN  
	 INSERT INTO [dbo].[Users](Name, Username, PasswordHash, PasswordSalt)  
	 VALUES(@Name, @Username, @PasswordHash, @PasswordSalt)
END

GO

-- =================================== CATALOG ===================================== --
GO
-- GET CATALOGS

create procedure [dbo].[GetCatalogs]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM Catalogs as c
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM Catalogs as c
			WHERE CHARINDEX(@SearchValue, [c].[Name]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END


GO

-- GET CATALOG BY ID
create procedure [dbo].[GetCatalog]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM Catalogs 
	WHERE Id = @Id
END

GO

-- INSERT CATALOG
create procedure [dbo].[InsertCatalog]  
(  
    @Name varchar(255),  
	@Slug varchar(255),
	@Visibility bit,
	@ProductCount int,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
	 INSERT INTO Catalogs(Name, Slug, Visibility, ProductCount, CreatedAt, UpdatedAt)  
	 VALUES(@Name, @Slug, @Visibility, @ProductCount, @CreatedAt, @UpdatedAt)
	 SELECT SCOPE_IDENTITY()
END

GO

-- UPDATE CATALOG
create procedure [dbo].[UpdateCatalog]  
(  
    @Id bigint,
	@Name varchar(100),  
	@Slug text,
	@Visibility bit,
	@ProductCount int,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
	UPDATE Catalogs
	SET Name = @Name, Slug = @Slug, Visibility = @Visibility, ProductCount=@ProductCount, CreatedAt = @CreatedAt, UpdatedAt = @UpdatedAt
	WHERE Id = @Id;
END

GO

-- DELETE CATALOG
create procedure [dbo].[DeleteCatalog]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Catalogs WHERE Id = @Id
END

-- =================================== PRODUCT ===================================== --
GO

-- GET PRODUCTS
create procedure [dbo].[GetProducts]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			WHERE CHARINDEX(@SearchValue, [p].[Name]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

GO

-- GET PRODUCT BY ID
create procedure [dbo].[GetProduct]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM Products as p
	INNER JOIN Catalogs as c
	ON [p].[CatalogId] = c.Id
	WHERE [p].[Id] = @Id
END


GO

-- INSERT PRODUCT
create procedure [dbo].[InsertProduct]
(  
    @Name varchar(255), 
	@Slug varchar(255), 
	@ShortDescription varchar(255),
	@Description text,
	@Price decimal (18,4),
	@Image varchar(255),
	@Visibility bit,
	@CatalogId bigint,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
  
 INSERT INTO Products(Name, Slug,ShortDescription, Description, Price, Image, Visibility, CatalogId, CreatedAt, UpdatedAt)  
 VALUES(@Name, @Slug, @ShortDescription, @Description, @Price, @Image, @Visibility, @CatalogId,@CreatedAt,@UpdatedAt)  
 SELECT SCOPE_IDENTITY()
  
END

GO

-- UPDATE PRODUCT
create procedure [dbo].[UpdateProduct]  
(  
    @Id bigint,
	@Name varchar(255), 
	@Slug varchar(255), 
	@ShortDescription varchar(255),
	@Description text,
	@Price decimal (18,4),
	@Image varchar(255),
	@Visibility bit,
	@CatalogId bigint,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
	UPDATE Products
	SET Name = @Name, Slug = @Slug, ShortDescription = @ShortDescription, Description = @Description, Price = @Price, Image = @Image, Visibility = @Visibility, CatalogId = @CatalogId, CreatedAt = @CreatedAt, UpdatedAt = @UpdatedAt
	WHERE Id = @Id;
END

GO

-- DELETE PRODUCT
create procedure [dbo].[DeleteProduct]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Products WHERE Id = @Id
END

-- =================================== CATEGORY ===================================== --
GO

-- GET CATEGORIES
create procedure [dbo].[GetCategories]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM [dbo].[Categories] as c
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[Categories] as c
			WHERE CHARINDEX(@SearchValue, [c].[Name]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

GO

-- GET CATEGORY BY ID
create procedure [dbo].[GetCategory]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM [dbo].[Categories] 
	WHERE Id = @Id
END

GO

-- INSERT CATEGORY
create procedure [dbo].[InsertCategory]  
(  
    @Name varchar(255),  
	@Slug varchar(255),
	@Visibility bit,
	@PostCount int,
	@CreatedAt datetime,  
    @UpdatedAt datetime
)
As  
BEGIN  
	 INSERT INTO Categories(Name, Slug, Visibility, PostCount, CreatedAt, UpdatedAt)  
	 VALUES(@Name, @Slug, @Visibility, @PostCount, @CreatedAt, @UpdatedAt)  
END

GO

-- UPDATE CATEGORY
create procedure [dbo].[UpdateCategory]  
(  
    @Id bigint,
	@Name varchar(255),  
	@Slug varchar(255),
	@Visibility bit,
	@PostCount int,
	@CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
	UPDATE Categories
	SET Name = @Name, Slug = @Slug, Visibility = @Visibility, PostCount=@PostCount, CreatedAt = @CreatedAt, UpdatedAt = @UpdatedAt
	WHERE Id = @Id;
END

GO

-- DELETE CATEGORY
create procedure [dbo].[DeleteCategory]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Categories WHERE Id = @Id
END

GO
-- =================================== POST ===================================== --

-- GET POSTS
create procedure [dbo].[GetPosts]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE CHARINDEX(@SearchValue, [p].[Title]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [p].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [p].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [p].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [p].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [p].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [p].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [p].[UpdatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [p].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

GO

-- GET POST BY ID
create procedure [dbo].[GetPost]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM [dbo].[Pots] as p
	INNER JOIN [dbo].[Categories] as c
	ON [p].[CategoryId] = c.Id
	WHERE [p].[Id] = @Id
END

GO

-- INSERT POST
create procedure [dbo].[InsertPost]  
(  
    @Title varchar(255),  
	@Slug varchar(255),
	@ShortDescription varchar(255),
	@Content text,
	@Image varchar(255),
	@Visibility bit,
	@CategoryId bigint,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
  
 INSERT INTO [dbo].[Pots] (Title, Slug, ShortDescription, Content, Image, Visibility, CategoryId, CreatedAt, UpdatedAt)  
 VALUES(@Title, @Slug, @ShortDescription, @Content, @Image, @Visibility, @CategoryId, @CreatedAt, @UpdatedAt)  
  
END

GO

-- UPDATE POST
create procedure [dbo].[UpdatePost]  
(  
    @Id bigint,
	@Title varchar(255),  
	@Slug varchar(255),
	@ShortDescription varchar(255),
	@Content text,
	@Image varchar(255),
	@Visibility bit,
	@CategoryId bigint,
    @CreatedAt datetime,  
    @UpdatedAt datetime
)  
As  
BEGIN  
	UPDATE [dbo].[Pots]
	SET Title = @Title, Slug = @Slug, ShortDescription = @ShortDescription, Content = @Content, Image = @Image, Visibility = @Visibility, CategoryId = @CategoryId, CreatedAt = @CreatedAt, UpdatedAt = @UpdatedAt
	WHERE Id = @Id;
END

GO

-- DELETE POST
create procedure [dbo].[DeletePost]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM [dbo].[Pots] WHERE Id = @Id
END

-- =================================== CUSTOMER ===================================== --

GO

-- INSERT CUSTOMER
create procedure [dbo].[InsertCustomer]  
(  
    @FirstName varchar(50),  
	@LastName varchar(50),
	@Phone varchar(50),
	@Email varchar(255),
	@Address varchar(255),
    @City varchar(100),  
    @Note varchar(255)
)  
As  
BEGIN  
	INSERT INTO Customers(FristName, LastName, Phone, Email, Address, City, Note)  
	VALUES(@FirstName,@LastName, @Phone, @Email, @Address, @City, @Note)  
	SELECT SCOPE_IDENTITY()
END

GO

-- UPDATE CUSTOMER
create procedure [dbo].[UpdateCustomer]  
(  
	@Id bigint,    
	@FirstName varchar(50),  
	@LastName varchar(50),
	@Phone varchar(50),
	@Email varchar(255),
	@Address varchar(255),
    @City varchar(100),  
    @Note varchar(255)
)  
As  
BEGIN  
	UPDATE Customers
	SET FristName = @FirstName, LastName = @LastName, Phone = @Phone, Email = @Email, Address = @Address, City = @City, Note = @Note
	WHERE Id = @Id;
END

GO

-- DELETE CUSTOMER
create procedure [dbo].[DeleteCustomer]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Customers WHERE Id = @Id
END


-- =================================== ORDER ===================================== --
GO

-- INSERT ORDER
create procedure [dbo].[InsertOrder]  
(  
    @OrderDate datetime,  
	@CustomerId bigint
)  
As  
BEGIN  
	INSERT INTO Orders(OrderDate, CustomerId)  
	VALUES(@OrderDate,@CustomerId)  
	SELECT SCOPE_IDENTITY()
END

GO

-- UPDATE ORDER
create procedure [dbo].[UpdateOrder]  
(  
	@Id bigint,    
	@OrderDate datetime,  
	@CustomerId bigint
)  
As  
BEGIN  
	UPDATE Orders
	SET OrderDate = @OrderDate, CustomerId = @CustomerId
	WHERE Id = @Id;
END

GO

-- DELETE ORDER
create procedure [dbo].[DeleteOrder]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Orders WHERE Id = @Id
END

-- =================================== ORDER DETAIL ===================================== --
GO

-- INSERT ORDER DETAIL
create procedure [dbo].[InsertOrderDetail]  
(  
    @OrderId bigint,  
	@ProductId bigint,
	@Quantity int
)  
As  
BEGIN  
  
 INSERT INTO OrderDetails(OrderId, ProductId,Quantity)  
 VALUES(@OrderId, @ProductId,@Quantity)  
  
END

-- =================================== CUSTOMER ORDERS ===================================== --
GO
-- GET CUSTOMER ORDERS

create procedure [dbo].[GetCustomerOrders]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@SearchValue IS NULL)
		BEGIN
			SELECT * FROM [dbo].[view_CustomerOrders] as c
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[OrderId] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[OrderId] END,
					CASE WHEN @SortOrderName = 'FristName' AND @SortOrder = 'DESC' THEN [c].[FristName] END DESC,
					CASE WHEN @SortOrderName = 'FristName' THEN [c].[FristName] END,
					CASE WHEN @SortOrderName = 'LastName' AND @SortOrder = 'DESC' THEN [c].[LastName] END DESC,
					CASE WHEN @SortOrderName = 'LastName' THEN [c].[LastName] END,
					CASE WHEN @SortOrderName = 'Email' AND @SortOrder = 'DESC' THEN [c].[Email] END DESC,
					CASE WHEN @SortOrderName = 'Email' THEN [c].[Email] END,
					CASE WHEN @SortOrderName = 'City' AND @SortOrder = 'DESC' THEN [c].[City] END DESC,
					CASE WHEN @SortOrderName = 'City' THEN [c].[City] END,
					CASE WHEN @SortOrderName = 'OrderDate' AND @SortOrder = 'DESC' THEN [c].[OrderDate] END DESC,
					CASE WHEN @SortOrderName = 'OrderDate' THEN [c].[OrderDate] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[view_CustomerOrders] as c
			WHERE CHARINDEX(@SearchValue, [c].[FristName]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[OrderId] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[OrderId] END,
					CASE WHEN @SortOrderName = 'FristName' AND @SortOrder = 'DESC' THEN [c].[FristName] END DESC,
					CASE WHEN @SortOrderName = 'FristName' THEN [c].[FristName] END,
					CASE WHEN @SortOrderName = 'LastName' AND @SortOrder = 'DESC' THEN [c].[LastName] END DESC,
					CASE WHEN @SortOrderName = 'LastName' THEN [c].[LastName] END,
					CASE WHEN @SortOrderName = 'Email' AND @SortOrder = 'DESC' THEN [c].[Email] END DESC,
					CASE WHEN @SortOrderName = 'Email' THEN [c].[Email] END,
					CASE WHEN @SortOrderName = 'City' AND @SortOrder = 'DESC' THEN [c].[City] END DESC,
					CASE WHEN @SortOrderName = 'City' THEN [c].[City] END,
					CASE WHEN @SortOrderName = 'OrderDate' AND @SortOrder = 'DESC' THEN [c].[OrderDate] END DESC,
					CASE WHEN @SortOrderName = 'OrderDate' THEN [c].[OrderDate] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

-- ****************************** ORDER DETAIL **************************************

GO

create procedure [dbo].[GetOrderDetail]  
(  
    @OrderId bigint
)  
As  
BEGIN  
	select *, [dbo].[func_CalculatePriceQuantityProduct]([c].[Quantity], [c].[Price]) as TotalPriceProduct
	FROM [dbo].[view_CustomerOrderDetails] as c
	WHERE [c].[OrderId] = @OrderId
END

GO

--============= COUNT =============
-- ** Catalog
create procedure [dbo].[GetCatalogCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Catalogs]
END

GO

-- ** Product
create procedure [dbo].[GetProductCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Products]
END 

GO
-- ** Category
create procedure [dbo].[GetCategoryCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Categories]
END 

GO
-- ** Post
create procedure [dbo].[GetPostCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Pots]
END 

GO
-- ** Order
create procedure [dbo].[GetOrderCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Orders]
END 

GO
-- ** Income
create procedure [dbo].[GetTotalIncome]    
As  
BEGIN  
	SELECT TotalIncome FROM [dbo].[func_TotalIncome]()
END 

GO
-- =================================== WEB (Frontend) ===================================== --
-- GET CATALOGS

create procedure [dbo].[GetCatalogsWeb]
As  
BEGIN  
	SELECT * FROM [dbo].[Catalogs] as c
	WHERE [c].[Visibility] = 1
END

-- EXEC
EXEC[dbo].[GetCatalogsWeb]

GO

-- GET CATALOG PRODUCTS
create procedure [dbo].[GetCatalogProductsWeb]  
(  
	@CatalogName varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN
	IF(@CatalogName IS NULL)
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility]=1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			WHERE [p].[CatalogId] = @CatalogName AND [p].[Visibility] = 1 AND [c].[Visibility]=1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
		END
END

GO

-- GET PRODUCTS HOME WEB
create procedure [dbo].[GetProductsHomeWeb]   
As  
BEGIN  
	BEGIN
		SELECT TOP 6 * FROM Products as p
		INNER JOIN Catalogs as c
		ON [p].[CatalogId] = c.Id
		WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1
		ORDER BY [p].[Id] DESC
	END
END

GO

create procedure [dbo].[GetCategoriesWeb]
As  
BEGIN  
	SELECT * FROM [dbo].[Categories] as c
	WHERE [c].[Visibility] = 1
END

GO

create procedure [dbo].[GetCategoryPostsWeb]  
(  
	@CategoryName varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	IF(@CategoryName IS NULL)
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM [dbo].[Pots] as p
			INNER JOIN [dbo].[Categories] as c
			ON [p].[CategoryId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1 AND [c].[Id] = @CategoryName
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Title' AND @SortOrder = 'DESC' THEN [p].[Title] END DESC,
					CASE WHEN @SortOrderName = 'Title' THEN [p].[Title] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

GO

-- ////////////////////////////////////////// Trigger \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
GO
-- ============================== PRODUCT ====================================

-- TRIG CREATE PRODUCT
CREATE TRIGGER trig_CreateProduct
ON [dbo].[Products] AFTER INSERT AS
DECLARE @CatalogId AS BIGINT
BEGIN
	SET @CatalogId = (SELECT CatalogId FROM inserted)

	UPDATE [dbo].[Catalogs]
	SET [Catalogs].[ProductCount] = [Catalogs].[ProductCount] + 1
	WHERE [Catalogs].[Id] = @CatalogId
END


GO
-- TRIG UPDATE PRODUCT
CREATE TRIGGER trig_UpdateProduct
ON [dbo].[Products] AFTER UPDATE AS
DECLARE @Price AS DECIMAL
SET @Price = (SELECT TOP 1 Price FROM [dbo].[Products] WHERE [Products].[Price] <= 0)
IF @Price < 0
BEGIN
	RAISERROR('Cannot update price < 0', 16, 10);
	ROLLBACK
END

-- TEST TRIG UPDATE PRODUCT
--UPDATE Products
--SET Price = -2.3
--WHERE Id = 2

GO
-- TRIG DELETE PRODUCT
CREATE TRIGGER [dbo].[trig_DeleteProduct]
ON [dbo].[Products] AFTER DELETE AS
DECLARE @CatalogId AS BIGINT
BEGIN
	SET @CatalogId = (SELECT CatalogId FROM deleted)

	UPDATE [dbo].[Catalogs]
	SET [Catalogs].[ProductCount] = [Catalogs].[ProductCount] - 1
	WHERE [Catalogs].[Id] = @CatalogId AND [Catalogs].[ProductCount] > 0
END

-- ============================= POST =================================

GO

-- TRIG CREATE POST
CREATE TRIGGER [dbo].[trig_CreatePost]
ON [dbo].[Pots] AFTER INSERT AS
DECLARE @CategoryId AS BIGINT
BEGIN
	SET @CategoryId = (SELECT CategoryId FROM inserted)

	UPDATE [dbo].[Categories]
	SET [Categories].[PostCount] = [Categories].[PostCount] + 1
	WHERE [Categories].[Id] = @CategoryId
END


GO

-- TRIG DELETE POST
CREATE TRIGGER [dbo].[trig_DeletePost]
ON [dbo].[Pots] AFTER DELETE AS
DECLARE @CategoryId AS BIGINT
BEGIN
	SET @CategoryId = (SELECT CategoryId FROM deleted)

	UPDATE [dbo].[Categories]
	SET [Categories].[PostCount] = [Categories].[PostCount] - 1
	WHERE [Categories].[Id] = @CategoryId AND [Categories].[PostCount] > 0
END


--////////////////////////////////////////////// SEED DATA \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- INSERT CATALOG
EXEC [dbo].[InsertCatalog] @Name="Men", @Slug="men", @Visibility=true, @ProductCount=0, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"
EXEC [dbo].[InsertCatalog] @Name="Women", @Slug="wonmen", @Visibility=true, @ProductCount=0, @CreatedAt="2019-12-19T22:23:40", @UpdatedAt="2019-12-19T22:23:40"
EXEC [dbo].[InsertCatalog] @Name="Children", @Slug="children", @Visibility=true, @ProductCount=0, @CreatedAt="2019-12-19T22:24:40", @UpdatedAt="2019-12-19T22:24:40"

-- INSERT PRODUCT
EXEC [dbo].[InsertProduct] @Name="Product 01", @Slug="product-01", @ShortDescription="Lorem ipsum dolor sit amette, velit aperiam quis.", @Description="Lorem ipsum dolor sit amette, velit aperiam quis.", @Price=24, @Image="product-01.png", @Visibility=true, @CatalogId=1, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"


EXEC [dbo].[InsertProduct] @Name="Product 02", @Slug="product-02", @ShortDescription="Lorem ipsum dolor sit amette, velit aperiam quis.", @Description="Lorem ipsum dolor sit amette, velit aperiam quis.", @Price=32, @Image="product-01.png", @Visibility=true, @CatalogId=2, @CreatedAt="2019-12-19T22:23:40", @UpdatedAt="2019-12-19T22:23:40"

EXEC [dbo].[InsertProduct] @Name="Product 03", @Slug="product-03", @ShortDescription="Lorem ipsum dolor sit amette, velit aperiam quis.", @Description="Lorem ipsum dolor sit amette, velit aperiam quis.", @Price=58, @Image="product-01.png", @Visibility=true, @CatalogId=3, @CreatedAt="2019-12-19T22:24:40", @UpdatedAt="2019-12-19T22:24:40"



