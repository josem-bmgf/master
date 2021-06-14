/****** Object:  Table [staging].[ihme_disease_burden]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [staging].[ihme_disease_burden](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ihme_location_id] [int] NOT NULL,
	[ihme_cause_id] [int] NOT NULL,
	[disease_burden_source_nm] [varchar](100) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[sex_nm] [varchar](10) NULL,
	[age_group_nm] [varchar](50) NULL,
	[age_nr] [float] NULL,
	[year_nm] [int] NULL,
	[disease_burden_scenario_nm] [varchar](50) NULL,
	[disease_burden_measure_nm] [varchar](50) NULL,
	[disease_burden_metric_nm] [varchar](50) NULL,
	[disease_burden_measure_point_estimate_value_qty] [float] NULL,
	[disease_burden_measure_upper_value_qty] [float] NULL,
	[disease_burden_meaure_lower_value_qty] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
