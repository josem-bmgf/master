-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Get User Name by User Id
-- =============================================
CREATE PROCEDURE [app].[uspGetUserName]
(
	 @Id INT
)
AS
BEGIN

	SELECT [ADUser]
		FROM [dbo].[SysUser]
		WHERE [Id] = @Id;

END;