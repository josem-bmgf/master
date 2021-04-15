-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Year
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_Year]
AS
BEGIN

SELECT 'SELECT ALL' AS YEAR
UNION ALL
 (SELECT DISTINCT cast([Year] AS varchar(10)) FROM [dbo].[YearQuarter]  WHERE [ID] > 0)

END;