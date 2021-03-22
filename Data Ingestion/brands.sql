use FetchRewards

--Stage data load
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\brands\brandscleansed.json', SINGLE_CLOB) as j

TRUNCATE TABLE [STG].[brands]

INSERT [STG].[brands] ([_id], [barcode], [brandCode], [category], [categoryCode], [cpgIdOid], [cpgIdRef], [name], [topBrand])
SELECT [_id], [barcode], [brandCode], [category], [categoryCode], [cpgIdOid], [cpgIdRef], [name], CASE WHEN [topBrand] = 'true' THEN 1 WHEN [topBrand] = 'false' THEN 0 ELSE NULL END AS [topBrand] 
FROM OPENJSON (@JSON )
WITH 
(
	_id varchar(250) '$._id.oid',
	barcode varchar(250) '$.barcode',
	brandCode varchar(250) '$.brandCode',
	category varchar(250) '$.category',
	categoryCode varchar(250) '$.categoryCode',
	cpgIdOid varchar(250) '$.cpg.id.oid',
	cpgIdRef varchar(250) '$.cpg.ref',
	name varchar(250) '$.name',
	topBrand varchar(250) '$.topBrand'
) as Dataset

--Fix the duplicate issue - with no information available I randomly picked a record with duplicate barcode and deleted it
select barcode, brandCode from [STG].[brands] WHERE barcode IN
(
	select barcode from [STG].[brands]
	group by barcode
	having count(barcode) > 1
)
order by barcode, brandCode

DELETE [STG].[brands] WHERE barcode = '511111004790' and brandCode = 'BITTEN'
DELETE [STG].[brands] WHERE barcode = '511111204923' and brandCode = 'CHESTERS'
DELETE [STG].[brands] WHERE barcode = '511111305125' and brandCode = '511111305125'
DELETE [STG].[brands] WHERE barcode = '511111504139' and brandCode = 'CHRISXYZ'
DELETE [STG].[brands] WHERE barcode = '511111504788' and brandCode = 'TEST'
DELETE [STG].[brands] WHERE barcode = '511111605058' and brandCode = '09090909090'
DELETE [STG].[brands] WHERE barcode = '511111704140' and brandCode = 'DIETCHRIS2'

--DW data load
INSERT INTO [DW].[dimBrands]([barcode], [_id], [brandCode], [category], [categoryCode], [cpgIdOid], [cpgIdRef], [name], [topBrand])
SELECT [barcode], [_id], [brandCode], [category], [categoryCode], [cpgIdOid], [cpgIdRef], [name], [topBrand] FROM [STG].[brands]

--To handle NULL barcode in receipt table
INSERT INTO [DW].[dimBrands] ([barcode], [_id], [brandCode], [category], [categoryCode], [cpgIdOid], [cpgIdRef], [name], [topBrand])
VALUES (999999, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)


