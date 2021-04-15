-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Year Quarter
-- =============================================
CREATE PROCEDURE [app].[uspGetYearQuarter]
AS
BEGIN

SELECT CAST(0 as bit) 'Selected'
      ,[Display]
	  ,[Id]
      ,[Year]
      ,[Quarter]
  FROM [dbo].[YearQuarter]
  WHERE [ID] > 0;

END;