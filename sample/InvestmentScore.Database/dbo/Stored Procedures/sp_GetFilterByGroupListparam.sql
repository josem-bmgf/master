CREATE PROCEDURE [dbo].[sp_GetFilterByGroupListparam] 


AS

/*******************************************************************************
Author:	Alvin John C. Apilan
Created Date: 8/8/2017	
Description:	Get the list of Group Team for Filter By Parameter
exec [sp_GetFilterByGroupListparam]
Changed By		Date		Description 
--------------------------------------------------------------------------------
Alvin Apilan	8/8/2017	Initial Version
*******************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN

SELECT 1 as ID, 'Managed Only' AS FilterGroupList
UNION ALL
SELECT 2,  'Funded Only'
UNION ALL
SELECT 3, 'Managed and Funded Only'

END




GO


