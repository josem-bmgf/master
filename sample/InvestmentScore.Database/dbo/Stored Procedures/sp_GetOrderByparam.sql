CREATE PROCEDURE [dbo].[sp_GetOrderByparam]
	@Filter_By     NVARCHAR(100)
AS

BEGIN
	
	/*******************************************************************************
	Author:		Alvin John Apilan
	Created Date:	08/04/2017
	Description:	Get the list of all possible ordering of investments based on filter by parameter
	Usage:
			  EXEC [sp_GetOrderByparam] 'Managed Only'
			  EXEC [sp_GetOrderByparam] 'Managed Only,Funded Only'
			  EXEC [sp_GetOrderByparam] 'Managed Only,Funded Only,Managed and Funded Only'

	Changed By				Date		Description 
	--------------------------------------------------------------------------------
	Alvin Apilan	        08/08/2017	Initial Version
	Richard Santos          10/05/2017  US 145846: Remove "Managed Only" in between when all categories are selected
	*******************************************************************************/

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @tmpFilterList AS TABLE (Item  NVARCHAR(100))
	DECLARE @CountOrder AS INT

	SET @CountOrder = (SELECT COUNT(*) FROM [dbo].[ufn_Split] (@Filter_By,','))

	IF (@CountOrder > 1)
		BEGIN
			--MT FT
			IF (@Filter_By = 'Managed Only,Funded Only')
				BEGIN
					SELECT  'Managed Only And Funded Only' as ITEM
					UNION ALL
					SELECT  'Funded Only And Managed Only'
				END

			--MT Both
			IF (@Filter_By = 'Managed Only,Managed and Funded Only')
				BEGIN
					SELECT  'Managed Only, Managed and Funded Only' as ITEM
					UNION ALL
					SELECT  'Managed and Funded Only, Managed Only'
				END
	
			--FT Both
			IF (@Filter_By = 'Funded Only,Managed and Funded Only')
				BEGIN
					SELECT  'Funded Only, Managed and Funded Only'  as ITEM
					UNION ALL
					SELECT  'Managed and Funded Only, Funded Only'
				END

			--MT FT Both
			IF (@Filter_By = 'Managed Only,Funded Only,Managed and Funded Only')
				BEGIN
					SELECT  'Managed Only, Funded Only, Managed and Funded Only' as ITEM
					UNION ALL
					SELECT   'Funded Only, Managed and Funded Only, Managed Only'
					UNION ALL
					SELECT   'Managed Only, Managed and Funded Only, Funded Only'
					UNION ALL
					SELECT   'Managed and Funded Only, Funded Only, Managed Only'
				END
		END
	ELSE 
		BEGIN
			SELECT ITEM FROM [dbo].[ufn_Split] (@Filter_By, ',')
		END
	END
GO