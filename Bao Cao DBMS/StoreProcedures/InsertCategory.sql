-- Tạo mới một category

use SHOP_DBMS

GO

-- Insert Category
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

-- EXEC 
EXEC [dbo].[InsertCategory] @Name="Product 01", @Slug="product-01", @Visibility=true, @PostCount=0, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"