-- Tạo mới orderdetail

use SHOP_DBMS

GO

-- INSERT ORDER DETAIL
create procedure [dbo].[InsertOrderDetail]  
(  
    @OrderId bigint,  
	@ProductId bigint,
	@Quantity int
)  
As  
BEGIN  
	 INSERT INTO OrderDetails(OrderId, ProductId,Quantity)  
	 VALUES(@OrderId, @ProductId,@Quantity)  
END

--EXEC
EXEC [dbo].[InsertOrderDetail] @OrderId=1, @ProductId=1, @Quantity=1