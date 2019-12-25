-- Trả về danh sách sản phẩm với điều kiện visibility = 1 và visibility catalog = 1 (Sắp xếp, Phân trang)

use SHOP_DBMS

GO

-- GET CATALOG PRODUCTS
create procedure [dbo].[GetCatalogProductsWeb]  
(  
	@CatalogName varchar(255) = null,
	@SortOrderName varchar(50),
	@SortOrder varchar(4),
	@CurrentPage int,
	@PageSize int
)  
As  
BEGIN
	IF(@CatalogName IS NULL)
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			WHERE [p].[Visibility] = 1 AND [c].[Visibility]=1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY 
		END
	ELSE
		BEGIN
			SELECT * FROM Products as p
			INNER JOIN Catalogs as c
			ON [p].[CatalogId] = c.Id
			WHERE [p].[CatalogId] = @CatalogName AND [p].[Visibility] = 1 AND [c].[Visibility]=1
			ORDER BY 
					CASE WHEN @SortOrderName = 'Id' AND @SortOrder = 'DESC' THEN [p].[Id] END DESC,
					CASE WHEN @SortOrderName = 'Id' THEN [p].[Id] END,
					CASE WHEN @SortOrderName = 'Name' AND @SortOrder = 'DESC' THEN [p].[Name] END DESC,
					CASE WHEN @SortOrderName = 'Name' THEN [p].[Name] END,
					CASE WHEN @SortOrderName = 'Price' AND @SortOrder = 'DESC' THEN [p].[Price] END DESC,
					CASE WHEN @SortOrderName = 'Price' THEN [p].[Price] END
			OFFSET ((@CurrentPage-1) * @PageSize) ROWS FETCH NEXT @PageSize ROWS ONLY
		END
END

-- EXEC
EXEC[dbo].[GetCatalogProductsWeb] @CatalogName = "2", @SortOrderName="Id", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCatalogProductsWeb] @CatalogName = "1", @SortOrderName="Name", @SortOrder="desc", @CurrentPage=1, @PageSize=5
EXEC[dbo].[GetCatalogProductsWeb] @CatalogName = "3", @SortOrderName="Id", @SortOrder="desc", @CurrentPage=1, @PageSize=5