CREATE TABLE [staging].[cause_dimension]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ihme_cause_id] [int] NOT NULL,
	[ihme_gbd_2016_cause_nm] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY])
GO
