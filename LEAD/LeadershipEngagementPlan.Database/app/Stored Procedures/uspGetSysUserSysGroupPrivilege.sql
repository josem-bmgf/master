-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Get All Users from SysUser 
-- =============================================
CREATE PROCEDURE [app].[uspGetSysUserSysGroupPrivilege]
(
	@SysGroupFk INT
)
AS
BEGIN

SELECT sgp.[Id]
	  ,sg.GroupName 'Division'
	  ,LTRIM(RTRIM(su.FirstName)) + ' ' + LTRIM(RTRIM(su.LastName)) 'FullName'
      ,sgp.[SysAdmin]
      ,sgp.[AppAdmin]
      ,sgp.[GroupAdmin]
      ,sgp.[GroupEntry]
      ,sgp.[GroupApprover]
      ,sgp.[Scheduler]
      ,sgp.[ScheduleApprover]
      ,sgp.[BlackOutDateEntry]
      ,sgp.[Status]
	  ,sgp.[SysGroupFK]
      ,sgp.[SysUserFK]
	FROM [dbo].[SysGroupUserPrivilege] sgp
	JOIN [dbo].[SysGroup] sg ON sgp.[SysGroupFk] =sg.[Id]
	JOIN [dbo].[SysUser] su ON sgp.[SysUserFK] =su.[Id]
	WHERE (@SysGroupFk = sgp.[SysGroupFK] AND sgp.[Id] > 1000)
--			OR
--		  (@SysGroupFk = 1000 AND sgp.[Id] >= 1000)
--		    OR
--		  (@SysGroupFk = 1001 AND sgp.[Id] >= 1001)

END;