-- Cập nhập category

use SHOP_DBMS

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

-- EXEC
EXEC [dbo].[UpdateCategory] @Id=1, @Name="Product 01", @Slug="product-01", @Visibility=true, @PostCount=0, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"
