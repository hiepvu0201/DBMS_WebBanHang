-- -- Khi xóa một bài viết thì đồng thời cập nhâp cột PostCount của bảng  Categories trừ đi 1

use SHOP_DBMS

GO

-- TRIG DELETE POST
CREATE TRIGGER [dbo].[trig_DeletePost]
ON [dbo].[Pots] AFTER DELETE AS
DECLARE @CategoryId AS BIGINT
BEGIN
	SET @CategoryId = (SELECT CategoryId FROM deleted)

	UPDATE [dbo].[Categories]
	SET [Categories].[PostCount] = [Categories].[PostCount] - 1
	WHERE [Categories].[Id] = @CategoryId AND [Categories].[PostCount] > 0
END
