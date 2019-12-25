-- Trả về danh sách catalog (tìm kiếm, phân trang, sắp xếp)

use SHOP_DBMS;

GO
-- GET CATALOGS

create procedure [dbo].[GetCatalogs]  
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
			SELECT * FROM Catalogs as c
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM Catalogs as c
			WHERE CHARINDEX(@SearchValue, [c].[Name]) > 0
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [c].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [c].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [c].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [c].[Name] END,
					CASE WHEN @SortOrderName = 'Slug' AND @SortOrder = 'DESC' THEN [c].[Slug] END DESC,
					CASE WHEN @SortOrderName = 'Slug' THEN [c].[Slug] END,
					CASE WHEN @SortOrderName = 'Visibility' AND @SortOrder = 'DESC' THEN [c].[Visibility] END DESC,
					CASE WHEN @SortOrderName = 'Visibility' THEN [c].[Visibility] END,
					CASE WHEN @SortOrderName = 'CreatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'CreatedAt' THEN [c].[CreatedAt] END,
					CASE WHEN @SortOrderName = 'UpdatedAt' AND @SortOrder = 'DESC' THEN [c].[CreatedAt] END DESC,
					CASE WHEN @SortOrderName = 'UpdatedAt' THEN [c].[UpdatedAt] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
END

EXEC[dbo].[GetCatalogs] @SearchValue = null, @SortOrderName="name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCatalogs] @SearchValue = "abc", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
