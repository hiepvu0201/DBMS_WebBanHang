-- Trả về danh sách catalog với điều kiện visibility = 1

use SHOP_DBMS;

GO
-- GET CATALOGS

create procedure [dbo].[GetCatalogsWeb]
As  
BEGIN  
	SELECT * FROM [dbo].[Catalogs] as c
	WHERE [c].[Visibility] = 1
END

-- EXEC
EXEC[dbo].[GetCatalogsWeb]
