-- Trả về một category

use SHOP_DBMS

GO

-- Get Category
create procedure [dbo].[GetCategory]  
(  
    @Id bigint
)  
As  
BEGIN  
	SELECT TOP(1) * FROM [dbo].[Categories] 
	WHERE Id = @Id
END

-- EXEC
EXEC[dbo].[GetCategory] @Id = "2"