-- Trả về danh sách sản phẩm thuộc một danh mục nhất định(Id)

use SHOP_DBMS

GO

-- GET CATALOG PRODUCTS
create procedure [dbo].[GetCatalogProducts]  
(  
	@SearchValue varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN  
	SELECT * FROM Products as p
	INNER JOIN Catalogs as c
	ON [p].[CatalogId] = c.Id
	WHERE [p].[CatalogId] = @SearchValue
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

-- EXEC
EXEC[dbo].[GetCatalogProducts] @SearchValue = "2", @SortOrderName="Id", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCatalogProducts] @SearchValue = "1", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5