CREATE TABLE [dbo].[Principal]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFK] INT CONSTRAINT [DF_Principal_EngagementFK] DEFAULT ((0)) NOT NULL, 
    [LeaderFK] INT CONSTRAINT [DF_Principal_LeaderFK] DEFAULT ((0)) NOT NULL, 
    [TypeFK] INT CONSTRAINT [DF_Principal_TypeFK] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [FK_Principal_Engagement] FOREIGN KEY ([EngagementFK]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_Principal_Leader] FOREIGN KEY ([LeaderFK]) REFERENCES [dbo].[Leader] ([Id]),
	CONSTRAINT [FK_Principal_PrincipalType] FOREIGN KEY ([TypeFK]) REFERENCES [dbo].[PrincipalType] ([Id])
)
