-- Trả về danh sach product (tìm kiếm, phân trang, sắp xếp)

use SHOP_DBMS
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

-- EXEC
EXEC[dbo].[GetProducts] @SearchValue = null, @SortOrderName="Id", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetProducts] @SearchValue = "abc", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5