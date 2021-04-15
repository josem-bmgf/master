-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Priority
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Priority]
AS
BEGIN

	SELECT [Id], [Priority]
		FROM (SELECT [Id], [Priority], [DisplaySortSequence]
					FROM [dbo].[Priority]
					WHERE [Status] =1
			 ) a
		ORDER BY [DisplaySortSequence];

END;