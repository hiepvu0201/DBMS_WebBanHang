-- Trả về MỘT catalog bằng Id

use SHOP_DBMS

GO

-- GET CATALOG BY ID
create procedure [dbo].[GetCatalog]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM Catalogs 
	WHERE Id = @Id
END

-- EXEC
EXEC [dbo].[GetCatalog] @Id = "1"