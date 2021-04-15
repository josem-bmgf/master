-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get list of Leaders
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Principals]
AS
BEGIN

SELECT ([LastName] +  ', ' + [FirstName]) 'Principal'
	  ,[Id]
	FROM [dbo].[Leader]
	WHERE 1=1
		AND [Status]=1
		AND [Id] > 0
	ORDER BY [DisplaySortSequence], [ShortName];

END;