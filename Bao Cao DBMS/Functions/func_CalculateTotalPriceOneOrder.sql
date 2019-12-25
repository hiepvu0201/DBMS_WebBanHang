/* Hàm trả về tổng giá của một đơn hàng */
use SHOP_DBMS

GO

CREATE FUNCTION [dbo].[func_CalculateTotalPriceOneOrder]()
RETURNS @TotalBillPrice table
(
	OrderId bigint,
	TotalProduct int,
	TotalPrice decimal
)
AS
BEGIN
	INSERT INTO @TotalBillPrice
	select OrderId, SUM(Quantity) as TotalProduct ,SUM([dbo].[func_CalculatePriceQuantityProduct]([c].[Quantity], [c].[Price])) AS TotalPrice
	FROM [dbo].[view_CustomerOrderDetails] as c
	GROUP BY OrderId
	return 
END

GO

--  TEST
SELECT * FROM [dbo].[func_CalculateTotalPriceOneOrder]()