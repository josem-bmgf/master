-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Engagement Duration
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Duration]
AS
BEGIN

	SELECT [Id], [Duration], [DurationInMinutes], [DurationInDays]
		FROM ( SELECT [Id], [Duration], [DurationInMinutes], [DurationInDays]
					FROM [dbo].[Duration]
					WHERE	[Status] =1) a
		ORDER BY [DurationInDays], [DurationInMinutes]
END;