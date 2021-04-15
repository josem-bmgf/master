-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/12/2016
-- Description:	Enter Seed records
-- =============================================
CREATE PROCEDURE [dbo].[usp_Add_Seed_Records]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Add Seed records in dbo.SysUser
	SET IDENTITY_INSERT dbo.SysUser ON;
	INSERT  dbo.SysUser (Id, LastName, FirstName, ADUser, Status) VALUES (  -1, 'Not Found', 'Not Found', 'Not Found', 0);
	INSERT  dbo.SysUser	(Id, LastName, FirstName, ADUser, Status) VALUES (   0, '',          '',          '', 0);
	INSERT  dbo.SysUser	(Id, LastName, FirstName, ADUser, Status) VALUES (1000, 'System',    'System',    'System', 1);
	SET IDENTITY_INSERT dbo.SysUser OFF;

	-- Add Seed records in dbo.SysGroup
	SET IDENTITY_INSERT dbo.SysGroup ON;
	INSERT  dbo.SysGroup (Id, GroupName, GroupDescription, Status) VALUES (-1,   'Not Found', 'Not Found', 0);
	INSERT  dbo.SysGroup (Id, GroupName, GroupDescription, Status) VALUES ( 0,   ''         , '',          0);
	INSERT  dbo.SysGroup (Id, GroupName, GroupDescription, Status) VALUES (1000, 'System'   , 'System',    1);
	SET IDENTITY_INSERT dbo.SysGroup OFF;

	-- Add Seed records in dbo.SysGroupUserPrivilege
	SET IDENTITY_INSERT dbo.SysGroupUserPrivilege ON;
	INSERT  dbo.SysGroupUserPrivilege (  Id, SysGroupFK, SysUserFK, SysAdmin, GroupAdmin, GroupEntry, GroupApprover, Scheduler, ScheduleApprover, Status) 
							  VALUES  (  -1, -1,         -1,        0,        0,          0,          0,             0,              0,                     0);
	INSERT  dbo.SysGroupUserPrivilege (  Id, SysGroupFK, SysUserFK, SysAdmin, GroupAdmin, GroupEntry, GroupApprover, Scheduler, ScheduleApprover, Status) 
							  VALUES  (   0, 0,          0,         0,        0,          0,          0,             0,              0,                     0);
	INSERT  dbo.SysGroupUserPrivilege (  Id, SysGroupFK, SysUserFK, SysAdmin, GroupAdmin, GroupEntry, GroupApprover, Scheduler, ScheduleApprover, Status) 
							  VALUES  (1000, 1000,       1000,      1,        1,          1,          1,             1,              1,                     1);
	SET IDENTITY_INSERT dbo.SysGroupUserPrivilege OFF;


	SET IDENTITY_INSERT dbo.Region ON;
	INSERT dbo.Region (Id, Region, Status) VALUES (-1, 'Not Found', 0);
	INSERT dbo.Region (Id, Region, Status) VALUES ( 0, '',          0);
	SET IDENTITY_INSERT dbo.Region OFF;


	SET IDENTITY_INSERT dbo.Country ON;
	INSERT dbo.Country (Id, RegionFk, Country, Status) VALUES (-1, -1, 'Not Found', 0);
	INSERT dbo.Country (Id, RegionFk, Country, Status) VALUES ( 0,  0, '',          0);
	SET IDENTITY_INSERT dbo.Country OFF;


	INSERT dbo.YearQuarter (Id, Year, Quarter, Display) VALUES (-1, -1, 0, 'Not Found');
	INSERT dbo.YearQuarter (Id, Year, Quarter, Display) VALUES ( 0,  0, 0, '');


	SET IDENTITY_INSERT dbo.Purpose ON;
	INSERT dbo.Purpose (Id, IsInternalEngagement, Purpose, Status) VALUES (-1, 0, 'Not Found', 0);
	INSERT dbo.Purpose (Id, IsInternalEngagement, Purpose, Status) VALUES ( 0, 0, '',          0); 
	SET IDENTITY_INSERT dbo.Purpose OFF;

/*
	SET IDENTITY_INSERT [dbo].[Priority] ON;
	INSERT [dbo].[Priority] ([Id],[Priority],[RequesterInput],[PresidentReview],[Status]) VALUES (-1, 'Not Found', 0, 0, 0);
	INSERT [dbo].[Priority] ([Id],[Priority],[RequesterInput],[PresidentReview],[Status]) VALUES ( 0, '',          0, 0, 0);
	SET IDENTITY_INSERT [dbo].[Priority] OFF;

	INSERT [dbo].[Priority] ([Priority],[RequesterInput],[PresidentReview],[Status]) VALUES ('Highest',				1, 1, 1);
	INSERT [dbo].[Priority] ([Priority],[RequesterInput],[PresidentReview],[Status]) VALUES ('High',				1, 1, 1);
	INSERT [dbo].[Priority] ([Priority],[RequesterInput],[PresidentReview],[Status]) VALUES ('Medium/Opportunistic',1, 1, 1);
	INSERT [dbo].[Priority] ([Priority],[RequesterInput],[PresidentReview],[Status]) VALUES ('Declined',			0, 1, 1);
*/

	SET IDENTITY_INSERT dbo.Duration ON;
	INSERT dbo.Duration ([Id], [IsInternalEngagement], [Duration], [DurationInMinutes], [DurationInDays], [Status]) VALUES ( -1, 0, 'Not Found', -1, -1, 0)
	INSERT dbo.Duration ([Id], [IsInternalEngagement], [Duration], [DurationInMinutes], [DurationInDays], [Status]) VALUES (  0, 0, '',           0,  0, 0)
	SET IDENTITY_INSERT dbo.Duration OFF;



	SET IDENTITY_INSERT [dbo].[PrioritySub] ON;
	INSERT [dbo].[PrioritySub] ([Id],[PriorityFk],[SubPriority],[Status]) VALUES (-1, -1, 'Not Found', 0);
	INSERT [dbo].[PrioritySub] ([Id],[PriorityFk],[SubPriority],[Status]) VALUES ( 0, 0,  '',          0);
	SET IDENTITY_INSERT [dbo].[PrioritySub] OFF;


	SET IDENTITY_INSERT dbo.Team ON;
	INSERT dbo.Team (Id, SysGroupFk, Team, Status) VALUES (-1, -1, 'Not Found', 0);
	INSERT dbo.Team (Id, SysGroupFk, Team, Status) VALUES ( 0,  0, '',          0);
	SET IDENTITY_INSERT dbo.Team OFF;

	SET IDENTITY_INSERT [dbo].[Engagement] ON;
	INSERT [dbo].[Engagement] ([Id], [Title], [Details], [Objectives]) VALUES (1000, 'Blackout Dates', 'Blackout Dates', 'Blackout Dates')
	SET IDENTITY_INSERT [dbo].[Engagement] OFF;

END