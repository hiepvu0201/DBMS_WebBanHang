-- Trả về danh sach 6 product với điều kiện Visibility = true và mới nhất

use SHOP_DBMS
GO

-- GET PRODUCTS HOME WEB
create procedure [dbo].[GetProductsHomeWeb]   
As  
BEGIN  
	BEGIN
		SELECT TOP 6 * FROM Products as p
		INNER JOIN Catalogs as c
		ON [p].[CatalogId] = c.Id
		WHERE [p].[Visibility] = 1 AND [c].[Visibility] = 1
		ORDER BY [p].[Id] DESC
	END
END

-- EXEC
EXEC[dbo].[GetProductsHomeWeb]