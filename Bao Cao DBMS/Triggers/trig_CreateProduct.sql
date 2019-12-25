-- Khi tạo mới một sản phẩn thì đồng thời cập nhâp cột ProductCount của bảng  Catalog cộng thêm 1

use SHOP_DBMS;
GO

-- TRIG CREATE PRODUCT
CREATE TRIGGER trig_CreateProduct
ON [dbo].[Products] AFTER INSERT AS
DECLARE @CatalogId AS BIGINT
BEGIN
	SET @CatalogId = (SELECT CatalogId FROM inserted)

	UPDATE [dbo].[Catalogs]
	SET [Catalogs].[ProductCount] = [Catalogs].[ProductCount] + 1
	WHERE [Catalogs].[Id] = @CatalogId
END
