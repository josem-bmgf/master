ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_SysUser_CommunicationsLead] FOREIGN KEY(CommunicationsLeadFk)
REFERENCES [dbo].[SysUser] ([Id])