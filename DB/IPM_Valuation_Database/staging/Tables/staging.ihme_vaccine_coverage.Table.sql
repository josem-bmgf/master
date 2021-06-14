/****** Object:  Table [staging].[ihme_disease_burden]    Script Date: 12/12/2019 9:48:31 AM ******/

CREATE TABLE [staging].[ihme_vaccine_coverage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] VARCHAR(10) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[year_nm] INT NOT NULL, 
	[sex_nm] [varchar](10) NOT NULL,
	[age_group_nm] [varchar](50) NOT NULL,
	[vaccine_nm] [varchar](50) NOT NULL,
	[scenario_nm] VARCHAR(50) NULL,
	[vaccine_coverage_qty] [float] NULL,

    PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
