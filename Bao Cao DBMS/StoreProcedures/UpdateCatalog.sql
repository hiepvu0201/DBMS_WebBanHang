-- Cập nhập một catalog

use SHOP_DBMS

GO

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

-- EXEC 
EXEC [dbo].[UpdateCatalog] @Id=1, @Name="Product 01", @Slug="product-01", @Visibility=true, @ProductCount=0, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"