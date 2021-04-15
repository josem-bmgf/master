-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Engagement Purpose
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Purpose]
AS
BEGIN

	SELECT [Id], [Purpose] 
		FROM (SELECT [Id], [Purpose], [DisplaySortSequence]
					FROM [dbo].[Purpose]
					WHERE	[Status] =1) a
		ORDER BY [DisplaySortSequence];

END;