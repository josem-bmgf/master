CREATE TABLE gdx.[cause_dimension]
(
	[Id] int IDENTITY(1,1) NOT NULL,
	[ihme_cause_id] [int] NOT NULL,
	[ihme_cause_nm] [varchar](500) NULL
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_cause_id] UNIQUE NONCLUSTERED
(
	[ihme_cause_id] ASC
)
) ON [PRIMARY]
GO