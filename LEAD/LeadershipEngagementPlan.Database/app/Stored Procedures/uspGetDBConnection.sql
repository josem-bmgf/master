-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Make Sure that I can connect to Server
-- =============================================
CREATE PROCEDURE [app].[uspGetDBConnection]
AS
BEGIN

	DECLARE @svr SYSNAME;

	SELECT @svr = @@SERVERNAME;

	IF @svr = 'SQLGPSBV01A' OR  @svr = 'SQLGPSBV01B'
		SET @svr = 'SQLCLSGPSB01LS1';

	SELECT @svr;

END