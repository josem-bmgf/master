-- [2017 Sprint 04] User Story 136466: LEAD: Add New Status (2)
-- Insert the new value Opportunistic in Status Table with 1045 sequence number for ordering

USE LEAD

INSERT INTO [dbo].[Status] (Name, DisplaySortSequence)
       VALUES ('Opportunistic', 1045);

SELECT * FROM [LEAD].[dbo].[Status]