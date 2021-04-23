-- [2017 Sprint 06] US 137341 - LEAD - Update Sorting by Status (4)
-- [DEV] Update DisplaySortSequence of Status

USE [LEAD]
GO

UPDATE [dbo].[Status]
   SET [DisplaySortSequence] = 1060
 WHERE Id = 1003
GO

UPDATE [dbo].[Status]
   SET [DisplaySortSequence] = 1020
 WHERE Id = 1004
GO

UPDATE [dbo].[Status]
   SET [DisplaySortSequence] = 1030
 WHERE Id = 1006
GO

UPDATE [dbo].[Status]
   SET [DisplaySortSequence] = 1040
 WHERE Id = 1008
GO

