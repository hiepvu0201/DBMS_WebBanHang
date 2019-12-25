/*Hàm trả về giá của sản phẩm với số lượng*/

use SHOP_DBMS

GO

CREATE FUNCTION [dbo].[func_CalculatePriceQuantityProduct]
(
	@quantity int,
	@price decimal
)
RETURNS decimal
AS
BEGIN
	DECLARE @TotalPrice decimal
	set @TotalPrice = @quantity * @price
	return @TotalPrice 
END

GO
-- TEST
select *, [dbo].[func_CalculatePriceQuantityProduct]([c].[Quantity], [c].[Price]) as TotalPriceProduct
FROM [dbo].[view_CustomerOrderDetails] as c