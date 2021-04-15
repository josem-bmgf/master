-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Ranking
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Ranking]
AS
BEGIN
	SELECT [Id], [Ranking]
		FROM [dbo].[Ranking]
		WHERE Status = 1
		ORDER BY [DisplaySortSequence];

END;