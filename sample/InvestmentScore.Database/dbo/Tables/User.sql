CREATE TABLE [dbo].[User] (
    [ID]            NVARCHAR (255) NOT NULL,
    [Department]    NVARCHAR (255) NULL,
    [DisplayName]   NVARCHAR (255) NULL,
    [Email]         NVARCHAR (255) NULL,
    [JobTitle]      NVARCHAR (255) NULL,
    [LoginName]     NVARCHAR (255) NULL,
    [Mobile]        NVARCHAR (255) NULL,
    [PrincipleType] INT            NULL,
    [SipAddress]    NVARCHAR (255) NULL,
    [LastUpdated]   DATETIME       NULL,
	[DivisionID]    NVARCHAR (255) NULL,
    [Division]      NVARCHAR (255) NULL,
    [EmployeeID]    NVARCHAR (10)  NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([ID] ASC)
);

