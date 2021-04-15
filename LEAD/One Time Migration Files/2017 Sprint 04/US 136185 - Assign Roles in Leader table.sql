-- [2017 Sprint 04] User Story 136185: LEAD: Update Executive Sponsors, Required, and Alternate Principal fields 
-- Created new columns for Leader table: [IsExecutiveSponsor], [IsRequiredPrincipal], [IsAlternatePrincipal]


USE LEAD

ALTER TABLE  [dbo].[Leader]
ADD [IsExecutiveSponsor]	BIT		CONSTRAINT [DF_Leader_IsExecutiveSponsor]  DEFAULT ((0)) NOT NULL,
	[IsRequiredPrincipal]	BIT		CONSTRAINT [DF_Leader_IsRequiredPrincipal]  DEFAULT ((0)) NOT NULL,	
	[IsAlternatePrincipal]	BIT		CONSTRAINT [DF_Leader_IsAlternatePrincipal]  DEFAULT ((0)) NOT NULL
GO
select * from dbo.leader
select * from sysgroup


--EXECUTIVE SPONSOR:
UPDATE [dbo].[Leader]
SET [IsExecutiveSponsor] = 1
WHERE FirstName + ' ' + LastName IN (
	'Allan Golston'
	,'Chris Elias'
	,'Connie Collingsworth'
	,'Jim Bromley'
	,'Leigh Morgan'
	,'Mark Suzman'
	,'Rodger Voorhies '
	,'Sue Desmond-Hellmann'
	,'Trevor Mundel'
)
 
 
--REQUIRED PRINCIPAL:
UPDATE [dbo].[Leader]
SET [IsRequiredPrincipal] = 1
WHERE FirstName + ' ' + LastName IN (
	'Allan Golston'
	,'Bill Sr. Gates'
	,'Chris Elias'
	,'Connie Collingsworth'
	,'Geoff Lamb'
	,'Jim Bromley'
	,'Leigh Morgan'
	,'Mark Suzman'
	,'Melinda Gates'
	,'Rodger Voorhies'
	,'Steven Rice'
	,'Sue Desmond-Hellmann'
	,'Trevor Mundel'
	)

--ALTERNATE PRINCIPAL:
UPDATE [dbo].[Leader]
SET [IsAlternatePrincipal] = 1
WHERE FirstName + ' ' + LastName IN (
	'Allan Golston'
	,'Bill Sr. Gates'
	,'Chris Elias'
	,'Connie Collingsworth'
	,'Geoff Lamb'
	,'Jim Bromley'
	,'Leigh Morgan'
	,'Mark Suzman'
	,'Melinda Gates'
	,'Rodger Voorhies'
	,'Steven Rice'
	,'Sue Desmond-Hellmann'
	,'Trevor Mundel'
	)

-- Sue Taylor is a new entry for both Required and Alternate Principal 
INSERT INTO [dbo].[Leader] 
VALUES(1006, 'Sue', 'Taylor', 'Sue', 'Seattle\suet', 2000, 1, 0, 1, 1)

