/*
* User Story: 153589
* Date Created: 04/17/2018
* Author: Jake Harry Chavez / Jobbie James Aguas
* Description: Applying indices to some of InvestmentScore tables to optimize execution of queries.
*/


IF EXISTS
(
	SELECT * 
	FROM sys.indexes 
	WHERE name='IX_InvestmentPayment' AND object_id = OBJECT_ID('dbo.Investment_Payment')
)
BEGIN
DROP INDEX IX_InvestmentPayment ON [dbo].[Investment_Payment]
END

CREATE INDEX IX_InvestmentPayment	
ON Investment_Payment	
(	
INV_ID	
,PMT_Division	
,PMT_Strategy	
,PMT_Initiative	
,PMT_SubInitiative	
,PMT_Key_Element	
)	
GO	
	
IF EXISTS
(
	SELECT * 
	FROM sys.indexes 
	WHERE name='IX_Investment' AND object_id = OBJECT_ID('dbo.Investment')
)
BEGIN
DROP INDEX IX_Investment ON [dbo].[Investment]
END
	
CREATE INDEX IX_Investment	
ON Investment (ID)	
INCLUDE (	
	ID_Combined
	,Managing_Team_Level_1
	,Managing_Team_Level_2
	,Managing_Team_Level_3
	,Managing_Team_Level_4
)	
GO	
