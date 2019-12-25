/* Hàm trả về tổng thu nhập của trang web */

use SHOP_DBMS

GO

CREATE FUNCTION [dbo].[func_TotalIncome]()
RETURNS @TotalPrice table
(
	TotalIncome decimal
)
AS
BEGIN
	INSERT INTO @TotalPrice
	SELECT ISNULL(SUM(t.TotalPrice), 0) as TotalIncome
	FROM (SELECT * FROM [dbo].[func_CalculateTotalPriceOneOrder]()) as t
	GROUP BY t.OrderId, t.TotalProduct
	return 
END

GO

-- TEST
SELECT TotalIncome FROM [dbo].[func_TotalIncome]()