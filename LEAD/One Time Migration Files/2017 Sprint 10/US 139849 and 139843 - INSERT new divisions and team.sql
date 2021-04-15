--US 139843 and 139849
--Adding the new Team and Divisions for the recent organizational changes in the foundation.
INSERT INTO [dbo].[Division] (Name, Description, DisplaySortSequence, Status)
VALUES ('Legal', 'Legal', 1800, 1),
('Office of the Executive Director', 'Office of the Executive Director', 1900, 1)

INSERT INTO [dbo].[Team]
VALUES (0, 'Legal', 1, 1009)