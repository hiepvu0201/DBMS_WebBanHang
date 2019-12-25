-- Xóa một catalog

use SHOP_DBMS

GO

-- DELETE CATALOG
create procedure [dbo].[DeleteCatalog]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Catalogs WHERE Id = @Id
END

-- EXCE
EXEC [dbo].[DeleteCatalog] @Id = 1