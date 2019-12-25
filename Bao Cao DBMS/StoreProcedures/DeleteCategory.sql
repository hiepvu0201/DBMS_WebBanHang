-- Xóa một category

use SHOP_DBMS

GO

-- DELETE CATEGORY
create procedure [dbo].[DeleteCategory]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Categories WHERE Id = @Id
END

-- EXEC
EXEC [dbo].[DeleteCategory] @Id = 1