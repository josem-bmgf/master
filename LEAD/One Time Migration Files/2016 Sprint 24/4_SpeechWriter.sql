ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_SysUser_SpeechWriter] FOREIGN KEY([SpeechWriterFk])
REFERENCES [dbo].[SysUser] ([Id])