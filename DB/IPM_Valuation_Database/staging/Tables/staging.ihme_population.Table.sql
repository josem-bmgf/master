/****** Object:  Table [staging].[ihme_population]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [staging].[ihme_population](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] [varchar](3) NOT NULL,
	[sex_nm] [varchar](10) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[age_group_nm] [varchar](20) NULL,
	[age_nr] [float] NULL,
	[year_nm] [int] NULL,
	[ihme_population_qty] [float] NULL,
	[un_population_age_age_group_country_year_population_weight_pct] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
