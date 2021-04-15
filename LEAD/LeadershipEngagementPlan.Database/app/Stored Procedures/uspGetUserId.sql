-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get User Id
-- =============================================
CREATE PROCEDURE [app].[uspGetUserId]
AS
BEGIN

	DECLARE @Id INT;

	SET @Id = -1;

	SELECT @Id = [Id]
		FROM [dbo].[SysUser]
		WHERE [ADUser] = SYSTEM_USER AND [Status] = 1;

	IF @Id = -1
	BEGIN
		INSERT [dbo].[SysUser]
					([ADUser], [Status])
			VALUES  (SYSTEM_USER,  1);

		SELECT @Id = [Id]
			FROM [dbo].[SysUser]
			WHERE [ADUser] = SYSTEM_USER AND [Status] = 1;
	END;

	SELECT @Id;

END;