ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_SysUser_TripDirector] FOREIGN KEY([TripDirectorFk])
REFERENCES [dbo].[SysUser] ([Id])