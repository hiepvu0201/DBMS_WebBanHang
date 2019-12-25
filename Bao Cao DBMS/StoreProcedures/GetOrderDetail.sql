-- Trả về chi tiết hóa đơn

use SHOP_DBMS

GO

-- GET ORDER DETAIL
create procedure [dbo].[GetOrderDetail]  
(  
    @OrderId bigint
)  
As  
BEGIN  
	select *, [dbo].[func_CalculatePriceQuantityProduct]([c].[Quantity], [c].[Price]) as TotalPriceProduct
	FROM [dbo].[view_CustomerOrderDetails] as c
	WHERE [c].[OrderId] = @OrderId
END

-- EXEC
EXEC [dbo].[GetOrderDetail] @OrderId = "2"
EXEC [dbo].[GetOrderDetail] @OrderId = "3"
