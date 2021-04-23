-- [2017 Sprint 04] User Story 134445: LEAD: Update Country and Region List
-- Remapped Country's Region, Added new Countries and Renamed existing one 
USE LEAD 
GO

IF OBJECT_ID('dbo.CountryBackup', 'U') IS NOT NULL 
  DROP TABLE [dbo].[CountryBackup]; 

DECLARE @Region INT

SELECT * 
INTO [dbo].[CountryBackup]
FROM [dbo].[Country]

UPDATE [dbo].[Country]
SET [Status] = 0

---------------------------START OF NORTH AMERICA---------------------------
UPDATE [dbo].[Country]
SET [Status] = 1
FROM [dbo].[Country] C
INNER JOIN [dbo].[Region] R
	ON C.RegionFk = R.Id
WHERE R.Region = 'North America'
	AND C.Country IN ( 'Antigua and Barbuda', 
              'Bahamas',
              'Barbados',
              'Belize',
              'Canada',
              'Costa Rica',
              'Cuba',
              'Dominica',
              'Dominican Republic',
              'El Salvador',
              'Grenada',
              'Guatemala',
              'Haiti',
              'Honduras',
              'Jamaica',
              'Mexico',
              'Nicaragua',
              'Panama',
              'Saint Kitts and Nevis',
              'Saint Lucia',
              'Saint Vincent and the Grenadines',
              'Trinidad and Tobago',
              'United States')
---------------------------END OF NORTH AMERICA---------------------------

------------------------------START OF AFRICA-----------------------------
--Rename first
UPDATE [dbo].[Country]
SET Country = 'Cabo Verde'
WHERE Country = 'Cape Verde'

UPDATE [dbo].[Country]
SET Country = 'Democratic Republic of the Congo'
WHERE Country = 'Congo, The Democratic Republic of the'

UPDATE [dbo].[Country]
SET Country = 'Republic of Congo'
WHERE Country = 'Congo'

UPDATE [dbo].[Country]
SET Country = 'Cote d''Ivoire'
WHERE Country = 'Côte d''Ivoire'

UPDATE [dbo].[Country]
SET Country = 'Tanzania'
WHERE Country = 'Tanzania, United Republic of'

SELECT @Region = Id 
FROM [dbo].[Region]
WHERE Region = 'Africa'

UPDATE [dbo].[Country]
SET [Status] = 1, [RegionFk] = @Region
WHERE Country IN  ('Algeria',
              'Angola',
              'Benin',
              'Botswana',
              'Burkina Faso',
              'Burundi',
              'Cabo Verde', 
              'Cameroon',
              'Central African Republic',
              'Chad',
              'Comoros',
              'Democratic Republic of the Congo', 
              'Republic of Congo', 
              'Cote d''Ivoire', 
              'Djibouti',
              'Egypt',
              'Equatorial Guinea',
              'Eritrea',
              'Ethiopia',
              'Gabon',
              'Gambia',
              'Ghana',
              'Guinea',
              'Guinea-Bissau',
              'Kenya',
              'Lesotho',
              'Liberia',
              'Libya',
              'Madagascar',
              'Malawi',
              'Mali',
              'Mauritania',
              'Mauritius',
              'Morocco',
              'Mozambique',
              'Namibia',
              'Niger',
              'Nigeria',
              'Rwanda',
              'Sao Tome and Principe',
              'Senegal',
              'Seychelles',
              'Sierra Leone',
              'Somalia',
              'South Africa',
              'South Sudan',
              'Sudan',
              'Swaziland',
              'Tanzania', 
              'Togo',
              'Tunisia',
              'Uganda',
              'Zambia',
              'Zimbabwe')
  
------------------------------END OF AFRICA-----------------------------

------------------------------START OF ASIA-----------------------------
--Rename first
UPDATE [dbo].[Country]
SET Country = 'Brunei'
WHERE Country = 'Brunei Darussalam'

UPDATE [dbo].[Country]
SET Country = 'Iran'
WHERE Country = 'Iran, Islamic Republic of'

UPDATE [dbo].[Country]
SET Country = 'Laos'
WHERE Country = 'Lao People''s Democratic Republic'

UPDATE [dbo].[Country]
SET Country = 'North Korea'
WHERE Country = 'Korea, Democratic People''s Republic of'

UPDATE [dbo].[Country]
SET Country = 'Russia'
WHERE Country = 'Russian Federation'

UPDATE [dbo].[Country]
SET Country = 'South Korea'
WHERE Country = 'Korea, Republic of'

UPDATE [dbo].[Country]
SET Country = 'Taiwan'
WHERE Country = 'Taiwan, Province Of China'

UPDATE [dbo].[Country]
SET Country = 'Vietnam'
WHERE Country = 'Viet Nam'


--SELECT * FROM COUNTRYTEMP WHERE COUNTRY LIKE 'Lao People''s Democratic Republic'

SELECT @Region = Id 
FROM [dbo].[Region]
WHERE Region = 'Asia'

UPDATE [dbo].[Country]
SET [Status] = 1, [RegionFk] = @Region
WHERE Country IN   ('Bahrain',
              'Bangladesh ', 
              'Bhutan',
              'Brunei',
              'Cambodia',
              'China ',
              'Cyprus',
              'Georgia',
              'India',
              'Indonesia',
              'Iran', 
              'Iraq',
              'Israel',
              'Japan',
              'Jordan',
              'Kyrgyzstan',
              'Laos', 
              'Malaysia',
              'Maldives',
              'Mongolia',
              'Myanmar',
              'Nepal',
			  'North Korea',
              'Philippines',
              'Russia', 
              'Singapore',
			  'South Korea',
              'Sri Lanka',
              'Taiwan', 
              'Tajikistan',
              'Thailand',
              'Timor-Leste',
              'Turkmenistan',
              'Uzbekistan',
              'Vietnam'
			  )
  
------------------------------END OF ASIA-----------------------------


----------------------------START OF EUROPE---------------------------
SELECT @Region = Id 
FROM [dbo].[Region]
WHERE Region = 'Europe'

--Rename first
UPDATE [dbo].[Country]
SET Country = 'Macedonia'
WHERE Country = 'Macedonia, The Former Yugoslav Republic of'

UPDATE [dbo].[Country]
SET Country = 'Moldova'
WHERE Country = 'Moldova, Republic of'

UPDATE [dbo].[Country]
SET Country = 'Vatican City'
WHERE Country = 'Holy See (Vatican City State)'

--SELECT * FROM COUNTRYTEMP WHERE COUNTRY LIKE '%Russia%'


INSERT INTO [dbo].[Country]
VALUES (@Region, 'Cyprus', 1)
	,(@Region, 'Georgia', 1)
	,(@Region, 'Kosovo', 1)
	,(@Region, 'Russia', 1)

UPDATE [dbo].[Country]
SET [Status] = 1, [RegionFk] = @Region
WHERE Country IN    ('Albania',
              'Andorra',
              'Armenia',
              'Austria',
              'Azerbaijan',
              'Belarus',
              'Belgium',
              'Bosnia and Herzegovina',
              'Bulgaria',
              'Croatia',
              'Czech Republic',
              'Denmark',
              'Estonia',
              'Finland',
              'France',
              'Germany',
              'Greece',
              'Hungary', 
              'Iceland',
              'Ireland',
              'Italy',
              'Kazakhstan', 
              'Kosovo', 
              'Latvia',
              'Liechtenstein',
              'Lithuania',
              'Luxembourg',
              'Macedonia', 
              'Malta',
              'Moldova', 
              'Monaco',
              'Montenegro',
              'Netherlands',
              'Norway',
              'Poland',
              'Portugal',
              'Romania',
              'San Marino',
              'Serbia',
              'Slovakia',
              'Slovenia',
              'Spain',
              'Sweden',
              'Switzerland',
              'Ukraine',
              'United Kingdom',
              'Vatican City '
			  )

------------------------------END OF EUROPE-----------------------------


---------------------------START OF MIDDLE EAST--------------------------
SELECT @Region = Id 
FROM [dbo].[Region]
WHERE Region = 'Middle East'

--Rename first
UPDATE [dbo].[Country]
SET Country = 'Palestine'
WHERE Country = 'Palestine, State of'

UPDATE [dbo].[Country]
SET Country = 'Syria'
WHERE Country = 'Syrian Arab Republic'

UPDATE [dbo].[Country]
SET Country = 'UAE'
WHERE Country = 'United Arab Emirates'

--SELECT * FROM COUNTRYTEMP WHERE COUNTRY LIKE '%Russia%'

INSERT INTO [dbo].[Country]
VALUES (@Region, 'Bahrain', 1)
	,(@Region, 'Iran', 1)
	,(@Region, 'Iraq', 1)
	,(@Region, 'Israel', 1)
	,(@Region, 'Jordan', 1)
	,(@Region, 'Tunisia', 1)

UPDATE [dbo].[Country]
SET [Status] = 1, [RegionFk] = @Region
WHERE Country IN      ('Afghanistan', 
              'Kuwait',
              'Lebanon',
              'Oman',
              'Pakistan',
              'Palestine',
              'Qatar',
              'Saudi Arabia',
              'Syria',
              'Turkey',
              'UAE',  
              'Yemen')

----------------------------END OF MIDDLE EAST---------------------------


---------------------------START OF MIDDLE EAST--------------------------
SELECT @Region = Id 
FROM [dbo].[Region]
WHERE Region = 'South America'

--Rename first
UPDATE [dbo].[Country]
SET Country = 'Bolivia'
WHERE Country = 'Bolivia, Plurinational State Of'

UPDATE [dbo].[Country]
SET Country = 'Venezuela'
WHERE Country = 'Venezuela, Bolivarian Republic of'

UPDATE [dbo].[Country]
SET [Status] = 1, [RegionFk] = @Region
WHERE Country IN      ('Argentina',
              'Bolivia',
              'Brazil',
              'Chile',
              'Colombia',
              'Ecuador',
              'Guyana', 
              'Paraguay',
              'Peru',
              'Suriname',
              'Uruguay',
              'Venezuela'
			  ) 

----------------------------END OF MIDDLE EAST---------------------------

----------------------------START OF AUSTRALIA---------------------------
UPDATE [dbo].[Country]
SET [Status] = 1
FROM [dbo].[Country] C
INNER JOIN [dbo].[Region] R
	ON C.RegionFk = R.Id
WHERE R.Region = 'Australia'
	AND C.Country = 'Australia'

-----------------------------END OF AUSTRALIA----------------------------

SELECT Region, Country, C.Status, c.Id as CountryId
FROM Country C
INNER JOIN Region R
	on C.RegionFk = R.ID
GROUP BY Region, Country,  C.Status, c.Id
ORDER BY Region, Country