-- Trả về số lượng category

use SHOP_DBMS

GO

--Get Category Count
create procedure [dbo].[GetCategoryCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Categories]
END 

-- EXEC
EXEC [dbo].[GetCategoryCount] 