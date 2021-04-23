--Engagement table
ALTER TABLE [dbo].[Engagement] ALTER COLUMN [Details] varchar(max) NULL
ALTER TABLE [dbo].[Engagement] ALTER COLUMN [City] varchar(128) NULL
ALTER TABLE [dbo].[Engagement] ALTER COLUMN [DateStart] date NULL
ALTER TABLE [dbo].[Engagement] ALTER COLUMN [DateEnd] date NULL
ALTER TABLE [dbo].[Engagement] ALTER COLUMN [PresidentComment] varchar(max) NULL
--Schedule table
ALTER TABLE [dbo].[Schedule] DROP CONSTRAINT [DF_Schedule_BriefDueToGCEByDate]
ALTER TABLE [dbo].[Schedule] ALTER COLUMN [BriefDueToGCEByDate] date NULL
ALTER TABLE [dbo].[Schedule] ALTER COLUMN [ScheduleComment] varchar(max) NULL

