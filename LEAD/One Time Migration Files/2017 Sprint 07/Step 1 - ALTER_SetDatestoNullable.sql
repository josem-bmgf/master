--[DEFECT] [STRETCH] LEAD Regression: BriefDueToBGC3ByDate, ScheduledDate and ReviewCompletedDate values in dbo.Schedule is set to the Last Modified Date
--sets the date fields of scheduling table to nullable

ALTER TABLE [dbo].[Schedule] DROP CONSTRAINT [DF_Schedule_ScheduledDate]
ALTER TABLE [dbo].[Schedule] DROP CONSTRAINT [DF_Schedule_BriedDueToBGC3ByDate]
ALTER TABLE [dbo].[Schedule] DROP CONSTRAINT [DF_Schedule_ReviewCompletedDate]
GO

ALTER TABLE [dbo].[Schedule] ALTER COLUMN [ScheduledDate] date NULL
ALTER TABLE [dbo].[Schedule] ALTER COLUMN [BriefDueToBGC3ByDate] date NULL
ALTER TABLE [dbo].[Schedule] ALTER COLUMN [ReviewCompletedDate] date NULL