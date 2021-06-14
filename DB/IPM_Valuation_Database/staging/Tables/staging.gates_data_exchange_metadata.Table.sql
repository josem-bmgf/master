/****** Object:  Table [staging].[gates_data_exchange_metadata]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [staging].[gates_data_exchange_metadata](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[gdx_dataset_id] [nvarchar](100) NOT NULL,
	[ipm_reference_data_type_nm] [varchar](100) NOT NULL,
	[ipm_reference_data_table_nm] [varchar](100) NOT NULL,
	[ipm_reference_data_friendly_nm] varchar(100) NOT NULL,
	[gdx_dataset_title_nm] [nvarchar](100) NOT NULL,
	[gdx_dataset_version_nm] [nvarchar](100) NOT NULL,
	[gdx_resource_id] [nvarchar](100) NOT NULL,
	[gdx_resource_nm] [nvarchar](100) NOT NULL,
	[gdx_dataset_current_version_indicator] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
