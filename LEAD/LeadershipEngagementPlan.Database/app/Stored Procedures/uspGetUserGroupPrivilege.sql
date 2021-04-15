-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Get group/s a user belong to
-- =============================================
CREATE PROCEDURE [app].[uspGetUserGroupPrivilege]
(
	 @Id INT
)
AS
BEGIN

	SELECT g.[GroupName] 'GroupName',
		   CASE gp.[SysAdmin]			WHEN 1 THEN 'SysAdmin' ELSE '' END + 
		   CASE gp.[AppAdmin]			WHEN 1 THEN ',AppAdmin' ELSE '' END + 
		   CASE gp.[GroupAdmin]			WHEN 1 THEN ',GroupAdmin' ELSE '' END + 
		   CASE gp.[GroupEntry]			WHEN 1 THEN ',GroupEntry' ELSE '' END + 
		   CASE gp.[GroupApprover]		WHEN 1 THEN ',GroupApprover' ELSE '' END + 
		   CASE gp.[Scheduler]			WHEN 1 THEN ',Scheduler' ELSE '' END + 
		   CASE gp.[ScheduleApprover]	WHEN 1 THEN ',ScheduleApprover' ELSE '' END + 
		   CASE gp.[BlackOutDateEntry]  WHEN 1 THEN ',BlackOutDateEntry' ELSE '' END 'Privilege',
		   g.[Id] 'GroupId'
		FROM [dbo].[SysGroupUserPrivilege] gp
		JOIN [dbo].[SysGroup] g ON gp.[SysGroupFk] = g.[Id]
		WHERE gp.[SysUserFk] = @Id AND gp.[Status] = 1 AND g.[Status] = 1;

END;