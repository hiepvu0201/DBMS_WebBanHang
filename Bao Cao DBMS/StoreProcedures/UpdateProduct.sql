-- Cập nhập product

use SHOP_DBMS

GO

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

-- EXEC
EXEC [dbo].[UpdateProduct] @Id=1, @Name="Product 01", @Slug="product-02", @ShortDescription="Product 01", @Description="Product 01", @Price=5, @Image="product-01.jpg", @Visibility=true, @CatalogId=1, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"