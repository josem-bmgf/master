/****** Object:  Table [gdx].[ihme_disability_weight]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [gdx].[ihme_disability_weight](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[sequela_name] [varchar](250) NOT NULL,
	[health_state_nm] [varchar](200) NULL,
	[health_state_desc] [varchar](500) NULL,
	[disability_weight_source_nm] [varchar](10) NULL,
	[disability_weight_dt] [varchar](10) NULL,
	[disease_disability_weight_percent_point_estimate] [float] NULL,
	[disease_disablity_weight_upper_pct] [float] NULL,
	[disease_disability_weight_lower_pct] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
