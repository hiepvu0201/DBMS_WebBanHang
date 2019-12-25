-- Tạo mới một product

use SHOP_DBMS

GO

-- INSET PROUCT
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

-- EXEC
EXEC [dbo].[InsertProduct] @Name="Product 01", @Slug="product-02", @ShortDescription="Product 01", @Description="Product 01", @Price=5, @Image="product-01.jpg", @Visibility=true, @CatalogId=1, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"