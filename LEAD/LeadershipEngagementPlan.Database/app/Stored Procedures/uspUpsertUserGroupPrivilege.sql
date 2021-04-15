-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/09/2016
-- Description:	Update User UserGroupPrivilege.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertUserGroupPrivilege]
(
	   @Id					INT
      ,@SysGroupFK			INT
      ,@SysUserFK			INT
      ,@SysAdmin			BIT
      ,@AppAdmin			BIT
      ,@GroupAdmin			BIT
      ,@GroupEntry			BIT
      ,@GroupApprover		BIT
      ,@Scheduler			BIT
      ,@ScheduleApprover	BIT
      ,@BlackOutDateEntry	BIT
      ,@Status				BIT
	  ,@ModifiedByFk	INT
)
AS
BEGIN

	DECLARE @Err INT;

IF @Id = -1	-- Adding a new cecord 
BEGIN

    BEGIN TRY
		INSERT [dbo].[SysGroupUserPrivilege]
				([SysGroupFK], [SysUserFK], [SysAdmin], [AppAdmin], [GroupAdmin]
				,[GroupEntry], [GroupApprover], [Scheduler], [ScheduleApprover]
				,[BlackOutDateEntry], [Status]
				,[EntryDate], [EntryByFk],   [ModifiedDate], [ModifiedByFk])
		VALUES  (@SysGroupFK,  @SysUserFK,  @SysAdmin,  @AppAdmin,  @GroupAdmin
				,@GroupEntry,  @GroupApprover,  @Scheduler,  @ScheduleApprover
				,@BlackOutDateEntry,  @Status
				,GETDATE(),   @ModifiedByFk, GETDATE(),      @ModifiedByFk);
		SET @Err = 0;
    END TRY
    BEGIN CATCH
		SET @Err = 1;
    END CATCH	
END
ELSE		-- Modifiying an existing record
BEGIN
	
    BEGIN TRY
        BEGIN TRANSACTION t1;
			INSERT [hst].[SysGroupUserPrivilege]
					([IdFk], [SysGroupFK], [SysUserFK], [SysAdmin], [AppAdmin], [GroupAdmin]
					,[GroupEntry], [GroupApprover], [Scheduler], [ScheduleApprover]
					,[BlackOutDateEntry], [Status]
					,[EntryDate], [EntryByFk],       [ModifiedDate], [ModifiedByFk])
			SELECT   [Id],   [SysGroupFK], [SysUserFK], [SysAdmin], [AppAdmin], [GroupAdmin]
					,[GroupEntry], [GroupApprover], [Scheduler], [ScheduleApprover]
					,[BlackOutDateEntry], [Status]
					,[EntryDate], [EntryByFk],       [ModifiedDate], [ModifiedByFk]
				FROM [dbo].[SysGroupUserPrivilege]
				WHERE Id = @Id;

			UPDATE [dbo].[SysGroupUserPrivilege]
				SET	 [SysAdmin]			= @SysAdmin
					,[AppAdmin]			= @AppAdmin
					,[GroupAdmin]		= @GroupAdmin
					,[GroupEntry]		= @GroupEntry
					,[GroupApprover]	= @GroupApprover
					,[Scheduler]		= @Scheduler
					,[ScheduleApprover]	= @ScheduleApprover
					,[BlackOutDateEntry]= @BlackOutDateEntry
					,[Status]			= @Status
					,[ModifiedDate]		= GETDATE()
					,[ModifiedByFk]		= @ModifiedByFk
				WHERE Id = @Id;

        COMMIT TRANSACTION t1;
		SET @Err = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION t1;
        BEGIN 
			SET @Err = 1;
        END
    END CATCH	
END

SELECT @Err;

END;