-- Xóa một post

use SHOP_DBMS;

GO

-- DELETE POST
create procedure [dbo].[DeletePost]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM [dbo].[Pots] WHERE Id = @Id
END

-- EXEC
EXEC [dbo].[DeletePost] @Id = 1