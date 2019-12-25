-- Trả vế số lượng post
use SHOP_DBMS

GO

-- Get Post Count
create procedure [dbo].[GetPostCount]    
As  
BEGIN  
	SELECT COUNT(*) as Total FROM [dbo].[Pots]
END 

-- EXEC
EXEC [dbo].[GetPostCount] 