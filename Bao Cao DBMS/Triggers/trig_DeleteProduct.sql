-- Khi xóa một sản phẩn thì đồng thời cập nhâp cột ProductCount của bảng  Catalog trừ đi 1

use SHOP_DBMS

GO

-- TRIG DELETE PRODUCT
CREATE TRIGGER trig_DeleteProduct
ON [dbo].[Products] AFTER DELETE AS
DECLARE @CatalogId AS BIGINT
BEGIN
	SET @CatalogId = (SELECT CatalogId FROM deleted)

	UPDATE [dbo].[Catalogs]
	SET [Catalogs].[ProductCount] = [Catalogs].[ProductCount] - 1
	WHERE [Catalogs].[Id] = @CatalogId AND [Catalogs].[ProductCount] > 0
END
