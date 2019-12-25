-- TẠO MỚI CATALOG SAU ĐÓ TRẢ VỀ ID CATALOG VỪA TẠO

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

-- EXEC 
EXEC [dbo].[InsertCatalog] @Name="Product 01", @Slug="product-01", @Visibility=true, @ProductCount=0, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"