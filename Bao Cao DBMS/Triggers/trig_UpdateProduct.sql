-- Khi cập nhập sản phẩm nếu giá <= 0 thì báo lỗi và quay lại trươc đó

use SHOP_DBMS;
GO


-- TRIG UPDATE PRODUCT
CREATE TRIGGER trig_UpdateProduct
ON [dbo].[Products] AFTER UPDATE AS
DECLARE @Price AS DECIMAL
SET @Price = (SELECT TOP 1 Price FROM [dbo].[Products] WHERE [Products].[Price] <= 0)
IF @Price < 0
BEGIN
	RAISERROR('Cannot update price < 0', 16, 10);
	ROLLBACK
END