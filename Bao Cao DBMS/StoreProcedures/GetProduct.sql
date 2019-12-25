-- Trả về một product

use SHOP_DBMS

GO

-- GET PRODUCT
create procedure [dbo].[GetProduct]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM Products as p
	INNER JOIN Catalogs as c
	ON [p].[CatalogId] = c.Id
	WHERE [p].[Id] = @Id
END

-- EXEC
EXEC[dbo].[GetProduct] @Id = 1