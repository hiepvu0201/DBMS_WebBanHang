-- Trả về danh sách category với điều kiện visibility = 1

use SHOP_DBMS;

GO
-- GET Categories Web

create procedure [dbo].[GetCategoriesWeb]
As  
BEGIN  
	SELECT * FROM [dbo].[Categories] as c
	WHERE [c].[Visibility] = 1
END

-- EXEC
EXEC[dbo].[GetCategoriesWeb]
