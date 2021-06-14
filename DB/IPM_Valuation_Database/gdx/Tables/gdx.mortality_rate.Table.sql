/****** Object:  Table [gdx].[mortality_rate]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [gdx].[mortality_rate](
	[resource_id] [nvarchar](max) NULL,
	[ISO_Code] [nvarchar](max) NULL,
	[age] [float] NULL,
	[year] [nvarchar](max) NULL,
	[population] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
