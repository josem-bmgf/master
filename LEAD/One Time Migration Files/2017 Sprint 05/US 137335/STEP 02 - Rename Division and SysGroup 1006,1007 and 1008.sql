-- [2017 Sprint 05] US 137335 - Update 1006, 1007 and 1008 in Division and SysGroup tables

USE [LEAD]
GO

UPDATE [dbo].[Division]
   SET [Name] = 'Executive'
      ,[Description] = 'Executive'
 WHERE Id = 1008
 GO

UPDATE [dbo].[Division]
   SET [Name] = 'CEO Office'
      ,[Description] = 'CEO Office'
 WHERE Id = 1006
 GO
  
UPDATE [dbo].[Division]
   SET [Name] = 'Foundation Strategy Office'
      ,[Description] = 'Foundation Strategy Office'
 WHERE Id = 1007
 GO
  
UPDATE [dbo].[SysGroup]
   SET [GroupName] = 'CEO Office1'
      ,[GroupShortName] = 'CEO1'
      ,[GroupDescription] = 'CEO Office1'
 WHERE  Id = 1006
GO

UPDATE [dbo].[SysGroup]
   SET [GroupName] = 'Executive'
      ,[GroupShortName] = 'EXEC'
      ,[GroupDescription] = 'Executive'
 WHERE  Id = 1008
GO

UPDATE [dbo].[SysGroup]
   SET [GroupName] = 'CEO Office'
      ,[GroupShortName] = 'CEO'
      ,[GroupDescription] = 'CEO Office'
 WHERE  Id = 1006
GO

UPDATE [dbo].[SysGroup]
   SET [GroupName] = 'Foundation Strategy Office'
      ,[GroupShortName] = 'FSO'
      ,[GroupDescription] = 'Foundation Strategy Office'
 WHERE Id = 1007
GO


