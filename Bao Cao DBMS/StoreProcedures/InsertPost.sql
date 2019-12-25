-- Tạo mới một post

use SHOP_DBMS

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

--EXEC
EXEC [dbo].[InsertPost] @Title="Post 01", @Slug="post-01", @ShortDescription="Post 01", @Content="Post 01", @Image="product-01.jpg", @Visibility=true, @CategoryId=1, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"