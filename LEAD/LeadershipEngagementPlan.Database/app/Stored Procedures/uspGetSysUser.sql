-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Get All Users from SysUser 
-- =============================================
CREATE PROCEDURE [app].[uspGetSysUser]
AS
BEGIN

	SELECT ' --- Select ---' 'FullName', 0 'Id'
	UNION
	SELECT 
		 FirstName + ' ' + LastName 'FullName'
		,[Id]
		FROM [dbo].[SysUser]
		WHERE [Status] = 1
		ORDER BY 1;

END;