ALTER PROCEDURE [dbo].[sp_GetYear]
AS
BEGIN

	/*******************************************************************************
	Author:		John Gomez
	Created Date:	07/27/2018
	Description:	Get the current year if Month is June 1 onwards ELSE get the previous year
	
	Changed By				Date		Description 
	--------------------------------------------------------------------------------
	John Gomez	        07/27/2018	Initial Version
	*******************************************************************************/
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT
	CASE WHEN MONTH(GETDATE())>=11  then YEAR(GETDATE())-2 ELSE YEAR(GETDATE())-3 END Year3   
	,CASE WHEN MONTH(GETDATE())>=11 then YEAR(GETDATE())-1 ELSE YEAR(GETDATE())-2 END Year2       
	,CASE WHEN MONTH(GETDATE())>=11 then YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END Year1
END

GO