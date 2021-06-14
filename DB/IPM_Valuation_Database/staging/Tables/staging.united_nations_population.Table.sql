/****** Object:  Table [staging].[united_nations_population]    Script Date: 12/12/2019 9:48:32 AM ******/

GO

GO
CREATE TABLE [staging].[united_nations_population](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] [varchar](3) NOT NULL,
	[sex_nm] [varchar](10) NOT NULL,
	[gates_data_exchange_metadata_id] [nvarchar](100) NOT NULL,
	[age_group_nm] [varchar](20) NOT NULL,
	[age_nr] [float] NOT NULL,
	[year_nm] [int] NOT NULL,
	[un_population_qty] [float] NULL,
	[un_population_age_age_group_country_year_population_weight_pct] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
