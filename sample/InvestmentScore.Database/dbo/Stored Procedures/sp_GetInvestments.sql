CREATE PROCEDURE [dbo].[sp_GetInvestments]	
	@Division AS NVARCHAR(100), 
	@Strategy AS NVARCHAR(100),
    @Filter_By NVARCHAR(100),
	@Order_Group NVARCHAR(100)
	
AS

/*******************************************************************************
Author:		Alvin John Apilan
Created Date:	August 4, 2017
Description:	Get the top 1 list of Investments
exec [[sp_GetInvestments]]  'Global Advocacy',  'Global Policy and Advocacy'

Changed By		Date		Description 
--------------------------------------------------------------------------------
Alvin John Apilan	8/1/2017	Initial Version
Alvin John Apilan   8/24/2017   Filter out Top & Bottom 5 by Division, Strategy and INVs Include
Alvin John Apilan   8/24/2017   Added INV_Managing_Team and INV_Managing_SubTeam in WHERE Clause
Karla Tuazon		01/03/2018  ZD62425: Change the current year to 2017
*******************************************************************************/

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @tmpInvestments AS TABLE (ID_Combined NVARCHAR(max)
      ,Investment_ID_Title  NVARCHAR(100)
	  ,PMT_Division NVARCHAR(100)
	  ,PMT_Strategy NVARCHAR(100)
	  ,INV_Managing_Team NVARCHAR(100)
	  ,INV_Managing_SubTeam NVARCHAR(100))
 
DECLARE @tmpInvestmentsFinal AS TABLE (ID_Combined NVARCHAR(max)
      ,Investment_ID_Title  NVARCHAR(100)
	  ,PMT_Division NVARCHAR(100)
	  ,PMT_Strategy NVARCHAR(100)
	  ,INV_Managing_Team NVARCHAR(100)
	  ,INV_Managing_SubTeam NVARCHAR(100))

BEGIN

INSERT INTO @tmpInvestments
SELECT DISTINCT CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
            THEN CPT_GATEWAY_ID
            ELSE  INV_ID
			END ID_Combined, 
			INV_ID + ' ' + 
			(CASE WHEN LEN(INV_Title) >= 65
			THEN LEFT(INV_Title, 65) + '...' 
			ELSE INV_Title END) AS Investment_ID_Title,
			PMT_Division,
			PMT_Strategy,
			INV_Managing_Team,
			INV_Managing_SubTeam
FROM Investment_Payment 
WHERE 	((PMT_Division = @Division) AND (PMT_Strategy = @Strategy)
		   OR
		 (INV_Managing_Team = @Division) AND (INV_Managing_SubTeam = @Strategy))		
	
		AND (INV_Total_Payout_Amt >= 5000000)			 			
		AND ([INV_Status] = 'Active'
			OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
			   --KCT: Set current year to 2017
				AND YEAR([INV_END_DATE]) = '2017')
         )	

DECLARE @CountInvestment AS INT
SET @CountInvestment =(SELECT COUNT(*) FROM @tmpInvestments)

IF (@CountInvestment >= 1 ) 
BEGIN


--1
IF (@Order_Group ='Managed Only, Funded Only, Managed and Funded Only')
	BEGIN 
		INSERT INTO @tmpInvestmentsFinal
		SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		ORDER BY  INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy
	 END

--2
IF (@Order_Group = 'Managed and Funded Only, Managed Only, Funded Only')
	BEGIN  
		INSERT INTO @tmpInvestmentsFinal
		SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy)
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		ORDER BY   INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy
	END
--3
IF (@Order_Group = 'Funded Only, Managed and Funded Only, Managed Only')
	BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy)
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
		ORDER BY  PMT_Division, PMT_Strategy, INV_Managing_Team, INV_Managing_SubTeam
	END

--4)
IF (@Order_Group ='Managed Only And Funded Only') 
	BEGIN
		INSERT INTO @tmpInvestmentsFinal
		SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		ORDER BY  INV_Managing_Team, INV_Managing_SubTeam

	END

--5
IF (@Order_Group = 'Funded Only And Managed Only') 
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		ORDER BY PMT_Division, PMT_Strategy

END
 

--6
IF (@Order_Group = 'Managed Only, Managed and Funded Only') 
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
		ORDER BY INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy

END

--7
IF (@Order_Group = 'Managed and Funded Only, Managed Only')
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
	OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
	ORDER BY INV_Managing_Team, INV_Managing_SubTeam
END

--8
IF (@Order_Group ='Funded Only, Managed and Funded Only')
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
	OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
	ORDER BY PMT_Division ,  PMT_Strategy
END

--9
IF (@Order_Group ='Managed and Funded Only, Funded Only')
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
	OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) ORDER BY  INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy

END

--10
IF (@Order_Group = 'Managed Only')
BEGIN
	INSERT INTO @tmpInvestmentsFinal
	SELECT * FROM @tmpInvestments WHERE INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy
	ORDER BY  INV_Managing_Team, INV_Managing_SubTeam


END

--11
IF (@Order_Group = 'Funded Only')
	BEGIN
		INSERT INTO @tmpInvestmentsFinal
		SELECT * FROM @tmpInvestments WHERE PMT_Division = @Division AND PMT_Strategy = @Strategy 
		ORDER BY  PMT_Division, PMT_Strategy
	END

--12
IF (@Order_Group = 'Managed and Funded Only')
	BEGIN 	INSERT INTO @tmpInvestmentsFinal
			SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		AND (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		ORDER BY  INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy
	
	END


--13  MT Both FT
IF (@Order_Group = 'Managed Only, Managed and Funded Only, Funded Only')
	BEGIN 	INSERT INTO @tmpInvestmentsFinal
			SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
		ORDER BY  INV_Managing_Team, INV_Managing_SubTeam, PMT_Division, PMT_Strategy
	
	END

--14  FT MT Both

IF (@Order_Group = 'Funded Only, Managed Only, Managed and Funded Only')
	BEGIN 	INSERT INTO @tmpInvestmentsFinal
			SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
		ORDER BY  PMT_Division, PMT_Strategy, INV_Managing_Team, INV_Managing_SubTeam
	
	END
--15  Both FT MT
IF (@Order_Group = 'Managed and Funded Only, Funded Only, Managed Only')
	BEGIN 	INSERT INTO @tmpInvestmentsFinal
			SELECT * FROM @tmpInvestments WHERE (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy)
		OR (PMT_Division = @Division AND PMT_Strategy = @Strategy) 
		OR (INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy AND PMT_Division = @Division AND PMT_Strategy = @Strategy)
		ORDER BY  INV_Managing_Team, INV_Managing_SubTeam,PMT_Division, PMT_Strategy
END


SELECT ID_Combined, Investment_ID_Title 
FROM 
(	
	SELECT 'Null' ID_Combined, '<blank>' Investment_ID_Title
	UNION
	SELECT ID_Combined, Investment_ID_Title FROM @tmpInvestmentsFinal
) AS Inv
ORDER BY CASE WHEN ID_Combined = 'Null' THEN 1 ELSE 2 END, ID_Combined
		
END
ELSE
	BEGIN
		SELECT  'NULL' AS ID_Combined, '<blank>' AS Investment_ID_Title
	END
END




