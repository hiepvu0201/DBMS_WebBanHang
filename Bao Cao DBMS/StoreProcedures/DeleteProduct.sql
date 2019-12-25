-- Xóa một Product

use SHOP_DBMS

GO

--Delete Product
create procedure [dbo].[DeleteProduct]  
(  
    @Id bigint
)  
As  
BEGIN  
	DELETE FROM Products WHERE Id = @Id
END

--EXEC
EXEC [dbo].[DeleteProduct] @Id = 1