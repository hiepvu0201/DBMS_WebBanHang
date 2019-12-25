-- Trả về số lượng order

use SHOP_DBMS

GO

-- Get Order Count
create procedure [dbo].[GetOrderCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Orders]
END 

-- EXEC
EXEC [dbo].[GetOrderCount] 