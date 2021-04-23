--US 140056 : LEAD - Require Scheduled Start / End Date only when Status = Scheduled
--Update the Schema of Scheduled Start Date and Schedule End Date to accept null value

ALTER TABLE [LEAD].[dbo].[Schedule] ALTER COLUMN DateFrom DATETIME NULL
ALTER TABLE [LEAD].[dbo].[Schedule] ALTER COLUMN DateTo DATETIME NULL