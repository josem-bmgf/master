Read the following to execute one time migration scripts for US 140471


STEP 01 - Go to $/S-CC/LEAD/Development/LeadershipEngagementPlan.Database/dbo/Tables and execute the following scripts
1. SysUserType
2. EngagementSysUser
3. ScheduleSysUser

STEP 02 - Go to $/S-CC/LEAD/Development/One Time MigrationFiles/2017 Sprint 13/US 140471/ and execute STEP 02 STEP 02 - Insert rows in SysUserType table.sql

STEP 03 - Go to $/S-CC/LEAD/Development/LeadershipEngagementPlan.Database/dbo/Stored Procedures and execute the following scripts
1. uspMigrateScheduleSysUser
2. uspMigrateEngagementSysUser

STEP 04 - Go to $/S-CC/LEAD/Development/One Time MigrationFiles/2017 Sprint 13/US 140471/ and execute STEP 04 - Populates EngagemenSysUser and SchduleSysUser table.sql

STEP 05 - Go to $/S-CC/LEAD/Development/LeadershipEngagementPlan.Database/dbo/Functions and execute the following scripts
1. ufnGetSysUserNameByEngagementId
2. ufnGetSysUserNameByScheduleId
3. ufnGetSysUserIdByEngagementId
4. ufnGetSysUserIdByScheduleId

STEP 06 - Go to $/S-CC/LEAD/Development/LeadershipEngagementPlan.Database/dbo/Views and execute.
Make sure to update script from CREATE to ALTER
1. dbo.vEngagementLeaderSchedule