-- Tạo mới order

use SHOP_DBMS

GO

-- Insert Order
create procedure [dbo].[InsertOrder]  
(  
    @OrderDate datetime,  
	@CustomerId bigint
)  
As  
BEGIN  
	INSERT INTO Orders(OrderDate, CustomerId)  
	VALUES(@OrderDate,@CustomerId)  
	SELECT SCOPE_IDENTITY()
END

-- EXEC
EXEC [dbo].[InsertOrder] @OrderDate = "2019-12-19T22:22:40", @CustomerId = 1