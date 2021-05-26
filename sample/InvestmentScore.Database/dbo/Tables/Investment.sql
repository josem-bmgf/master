﻿CREATE TABLE [dbo].[Investment] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [ID_Combined]             NVARCHAR (255)  NULL,
    [INV_Grantee_Vendor_Name] NVARCHAR (255)  NULL,
    [INV_Type]                NVARCHAR (100)  NULL,
    [INV_Status]              NVARCHAR (255)  NULL,
    [INV_Title]               NVARCHAR (255)  NULL,
    [INV_Owner]               NVARCHAR (MAX)  NULL,
    [INV_Manager]             NVARCHAR (255)  NULL,
    [INV_Start_Date]          DATETIME        NULL,
    [INV_End_Date]            DATETIME        NULL,
    [INV_Level_of_Engagement] NVARCHAR (100)  NULL,
    [Total_Investment_Amount] DECIMAL (28, 6) NULL,
    [Amt_Paid_To_Date]        DECIMAL (28, 6) NULL,
    [INV_Description]         NVARCHAR (4000) NULL,
    [Managing_Team_Level_1]   NVARCHAR (255)  NULL,
    [Managing_Team_Level_2]   NVARCHAR (255)  NULL,
    [Managing_Team_Level_3]   NVARCHAR (255)  NULL,
    [Managing_Team_Level_4]   NVARCHAR (255)  NULL,
    [PMT_Expenditure_Type]    NVARCHAR (100)  NULL,
    [Funding_Type]            NVARCHAR (50)   NULL,
    [Old_Investment_ID]       INT             NULL,
    [Old_Investment_ID_MNF]   INT             NULL,
    [OPP_Closed_Date]         DATETIME        NULL,
	[Is_Deleted]			  BIT             DEFAULT ((0)) NOT NULL,
    [Is_Excluded_From_TOI]    BIT             DEFAULT ((0)) NULL, 
    CONSTRAINT [PK_Investment] PRIMARY KEY CLUSTERED ([ID] ASC)
);

