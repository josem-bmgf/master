-- [2017 Sprint 05] US 137335 - Add DivisionFk in SysUser table

USE [LEAD]
GO

ALTER TABLE [dbo].[SysUser] ADD [DivisionFk] [int] NOT NULL CONSTRAINT [DF_SysUser_Division]  DEFAULT ((0))

ALTER TABLE [dbo].[SysUser]  WITH CHECK ADD  CONSTRAINT [FK_SysUser_Division] FOREIGN KEY([DivisionFk])
REFERENCES [dbo].[Division] ([Id])
GO
