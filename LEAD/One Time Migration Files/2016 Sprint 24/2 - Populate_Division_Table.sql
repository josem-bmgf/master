--Populate Division Table
SET IDENTITY_INSERT [dbo].[Division] ON
INSERT INTO [dbo].[Division] ([Id],[Name],[Description], [DisplaySortSequence],[Status]) VALUES
(0,'','','0','0')

SET IDENTITY_INSERT [dbo].[Division] OFF

INSERT INTO [dbo].[Division] VALUES
('Global Communications & Engagement','Communications','1100','1'),
('Global Development','Global Development','1200','1'),
('Global Health','Global Health','1300','1'),
('Global Policy and Advocacy','Global Policy and Advocacy','1400','1'),
('Operations','Operations','1500','1'),
('U.S. Program','U.S. Program','1600','1'),
('Executive','Executive','1000','1'),
('Chief Strategy Officer','Chief Strategy Officer','1450','1')

--Clean up for existing data
Update [LEAD].[dbo].[Engagement] set DivisionFk = DivisionFk - 2 Where DivisionFk > 0

--Linking of Engagement table to Division table
---Drop Sysgroup constraint from DivisionFk
ALTER TABLE [dbo].[Engagement] DROP CONSTRAINT [FK_Engagement_SysGroup]
GO
---Add new correct COnstraint with Division table
ALTER TABLE [dbo].[Engagement]  WITH CHECK ADD  CONSTRAINT [FK_Engagement_Division] FOREIGN KEY([DivisionFk])
REFERENCES [dbo].[Division] ([Id])
Go
