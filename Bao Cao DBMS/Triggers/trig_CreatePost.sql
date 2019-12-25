-- Khi tạo mới một bài viết thì đồng thời cập nhâp cột PostCount của bảng  Categories cộng thêm 1
use SHOP_DBMS

GO

CREATE TRIGGER [dbo].[trig_CreatePost]
ON [dbo].[Pots] AFTER INSERT AS
DECLARE @CategoryId AS BIGINT
BEGIN
	SET @CategoryId = (SELECT CategoryId FROM inserted)

	UPDATE [dbo].[Categories]
	SET [Categories].[PostCount] = [Categories].[PostCount] + 1
	WHERE [Categories].[Id] = @CategoryId
END
