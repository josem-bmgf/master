/****** Object:  UserDefinedProcedure [dbo].[uspMigratePrincipal]    Script Date: 11/14/2016 10:49:54 AM ******/
/*******************************************************************************
Author:				Ma. Carina Sanchez 
Created Date:		11/14/2016
Description:		Perform Insert to Principal. 
					It loops thru all the Required/Alternate Principal (a comma delimited column) from dbo.Engagement, 
					and insert these rows to dbo.Principal
Parameters:			@FirstId			- the MIN id of the current column (e.g. SELECT MIN(Id) FROM dbo.Engagement)
										- Simply declare a constant here if the column has an IDENTITY property
					@ProceedWithInsert	- Bit(0,1) to idenitify if Insert will push thru,
					@PrincipalType		- Specify if which Principal Type is to be migrated
										- Required(1000) or Alternate(1001). Values may vary.

Execute:			EXEC [dbo].[uspMigratePrincipal] 1000000, 0, 1000; This will only return a list of REQUIRED Principal to be inserted
					EXEC [dbo].[uspMigratePrincipal] 1000000, 1, 1001; Will push thru with the insert of ALTERNATE Principal to dbo.Principal


Changed By			Date			Description 

*******************************************************************************/

CREATE PROCEDURE [dbo].[uspMigratePrincipal]
(    
      @FirstId INT,
	  @ProceedWithInsert BIT,
	  @PrincipalType INT
)
AS
BEGIN

	DECLARE @RowLength INT,
		@LoopCounterMin INT,
		@LoopCounterMax INT,
		@PrincipalSet NVARCHAR(MAX),
		@RequiredType INT,
		@AlternateType INT

	SET @RequiredType = (SELECT [Id] FROM [dbo].[PrincipalType] WHERE [Name] = 'Required')
	SET @AlternateType = (SELECT [Id] FROM [dbo].[PrincipalType] WHERE [Name] = 'Alternate')

	--Temp table that will hold Principals to be inserted
	CREATE TABLE #tempMigratePrincipal(
		 ToBe_EngagementFK INT,
		 ToBe_LeaderFK INT,
		 ToBe_TypeFK INT)
	
	--Initialize loop counter by getting the min and max Id of Engagement based on Principal Type
	IF (@PrincipalType = @RequiredType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Engagement]
			WHERE [PrincipalRequiredFks] IS NOT NULL
		END	
	ELSE IF (@PrincipalType = @AlternateType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM dbo.Engagement  
			WHERE [PrincipalAlternateFks] IS NOT NULL
		END	

	-- Loop to Engagement rows
	WHILE ( @LoopCounterMin IS NOT NULL
        AND  @LoopCounterMin <= @LoopCounterMax)
		BEGIN
			--Get current Principal - this is a comma delimited string
			IF (@PrincipalType = @RequiredType)
				BEGIN
					SET @PrincipalSet = (SELECT [PrincipalRequiredFks]
					FROM [dbo].[Engagement] WHERE Id = @LoopCounterMin)

				END	
			ELSE IF (@PrincipalType = @AlternateType)
				BEGIN
					SET @PrincipalSet = (SELECT [PrincipalAlternateFks]
					FROM [dbo].[Engagement] WHERE Id = @LoopCounterMin)
				END	
			
		   
		   IF (@PrincipalSet IS NOT NULL AND @PrincipalSet <> '')
			   BEGIN
					--Convert the comma delimited string into a table by calling [ufnConvertDelimitedStringToTable]
					--and then insert it to temp table
					INSERT INTO #tempMigratePrincipal (ToBe_EngagementFK, ToBe_LeaderFK, ToBe_TypeFK)
					SELECT *, @PrincipalType
					FROM [dbo].[ufnConvertDelimitedStringToTable](@LoopCounterMin, @PrincipalSet, ',')
			   END
			
		   SET @LoopCounterMin  = @LoopCounterMin  + 1  

	   END      

	IF (@ProceedWithInsert = 1)
		BEGIN
			--Insert rows to Principal table
			INSERT INTO [dbo].[Principal]
			SELECT [ToBe_EngagementFK] AS [EngagementFK]
				,[ToBe_LeaderFK] AS [YearQuarterFK]
				,[ToBe_TypeFK] AS [TypeFK]
			FROM #tempMigratePrincipal
			
			SELECT *
			FROM [dbo].[Principal]
		END
	ELSE
		BEGIN
			-- Return rows to be migrated
			SELECT *
			FROM #tempMigratePrincipal
		END
	
	DROP TABLE #tempMigratePrincipal

END;