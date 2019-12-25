-- Cập nhập một post

use SHOP_DBMS

GO

-- Update Post
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

--EXEC
EXEC [dbo].[UpdatePost] @Id=1, @Title="Post 01", @Slug="post-01", @ShortDescription="Post 01", @Content="Post 01", @Image="product-01.jpg", @Visibility=true, @CategoryId=1, @CreatedAt="2019-12-19T22:22:40", @UpdatedAt="2019-12-19T22:22:40"