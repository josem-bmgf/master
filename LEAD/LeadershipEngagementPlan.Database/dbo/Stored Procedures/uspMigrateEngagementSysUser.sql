/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/07/2017
Description:		Perform Insert to EngagementSysUser. 
					It loops thru all the Staff or Content Owner SysUser (a comma delimited column)
					from dbo.Engagement, and insert these rows to dbo.EngagementSysUser.
Parameters:			@FirstId			- the MIN id of the current column (e.g. SELECT MIN(Id) FROM dbo.Engagement)
										- Simply declare a constant here if the column has an IDENTITY property
					@ProceedWithInsert	- Bit(0,1) to idenitify if Insert will push thru,
					@SysUserType		- Specify if which SysUser Type is to be migrated
										- Staff(1000) or Content Owner(1001),. Values may vary.

Execute:			EXEC [dbo].[uspMigrateEngagementSysUser] 1000000, 0, 1000; This will only return a list of STAFF SysUser to be inserted
					EXEC [dbo].[uspMigrateEngagementSysUser] 1000000, 1, 1001; Will push thru with the insert of CONTENT OWNER SysUser to dbo.EngagementSysUser


Changed By			Date			Description
Darwin C. Baluyot	7/7/2017		Created stored procedure 

*******************************************************************************/

CREATE PROCEDURE [dbo].[uspMigrateEngagementSysUser]
(    
      @FirstId INT,
	  @ProceedWithInsert BIT,
	  @SysUserType INT
)
AS
BEGIN

	DECLARE @LoopCounterMin INT,
		@LoopCounterMax INT,
		@EngagementSysUserSet NVARCHAR(MAX),
		@StaffType INT,
		@BriefOwnerType INT


	SET @StaffType = (SELECT [Id] FROM [dbo].[SysUserType] WHERE [Name] = 'Staff')
	SET @BriefOwnerType = (SELECT [Id] FROM [dbo].[SysUserType] WHERE [Name] = 'Content Owner')


	--Temp table that will hold EngagementSysUser to be inserted
	CREATE TABLE #tempMigrateEngagementSysUser(
		 ToBe_EngagementFK INT,
		 ToBe_SysUserFK INT,
		 ToBe_TypeFK INT)


	--Initialize loop counter by getting the min and max Id of Engagement based on SysUserType
	IF (@SysUserType = @StaffType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Engagement]
			WHERE [StaffFk] > 0
		END	
	ELSE IF (@SysUserType = @BriefOwnerType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Engagement]
			WHERE [BriefOwnerFk] > 0
		END
							

	-- Loop to Engagement rows
	WHILE ( @LoopCounterMin > 0
        AND  @LoopCounterMin <= @LoopCounterMax)
		BEGIN
			--Get current SysUser - this is a comma delimited string
			IF (@SysUserType = @StaffType)
				BEGIN
					SET @EngagementSysUserSet = (SELECT [StaffFk]
					FROM [dbo].[Engagement] WHERE Id = @LoopCounterMin AND [StaffFk] > 0)
				END	
			ELSE IF (@SysUserType = @BriefOwnerType)
				BEGIN
					SET @EngagementSysUserSet = (SELECT [BriefOwnerFk]
					FROM [dbo].[Engagement] WHERE Id = @LoopCounterMin AND [BriefOwnerFk] > 0)
				END	
														
		   
		   IF (@EngagementSysUserSet IS NOT NULL AND @EngagementSysUserSet <> '')
			   BEGIN
					--Convert the comma delimited string into a table by calling [ufnConvertDelimitedStringToTable]
					--and then insert it to temp table
					INSERT INTO #tempMigrateEngagementSysUser (ToBe_EngagementFK, ToBe_SysUserFK, ToBe_TypeFK)
					SELECT *, @SysUserType
					FROM [dbo].[ufnConvertDelimitedStringToTable](@LoopCounterMin, @EngagementSysUserSet, ',')

			   END

			
		   SET @LoopCounterMin  = @LoopCounterMin  + 1  

	   END      

	IF (@ProceedWithInsert = 1)
		BEGIN
			--Insert rows to EngagementSysUser table
			INSERT INTO [dbo].[EngagementSysUser]
			SELECT [ToBe_EngagementFK] AS [EngagementFK]
				,[ToBe_SysUserFK] AS [SysUserFK]
				,[ToBe_TypeFK] AS [TypeFK]
			FROM #tempMigrateEngagementSysUser
			
			-- Return rows that has been migrated
			SELECT *
			FROM #tempMigrateEngagementSysUser

		END
	ELSE
		BEGIN
			-- Return rows to be migrated
			SELECT *
			FROM #tempMigrateEngagementSysUser

		END
	

	DROP TABLE #tempMigrateEngagementSysUser


END;