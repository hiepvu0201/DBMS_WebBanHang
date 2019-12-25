-- Trả về số lượng product

use SHOP_DBMS

GO

-- Get Product Count
create procedure [dbo].[GetProductCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Products]
END 

-- EXEC
EXEC [dbo].[GetProductCount] 