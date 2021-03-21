use FetchRewards
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\brands\brandscleansed.json', SINGLE_CLOB) as j
SELECT *
FROM OPENJSON (@JSON )
WITH 
(
	_id varchar(50) '$._id.oid',
	barcode varchar(15) '$.barcode',
	brandCode varchar(50) '$.brandCode',
	category varchar(50) '$.category',
	categoryCode varchar(50) '$.categoryCode',
	cpgIdOid varchar(50) '$.cpg.id.oid',
	cpgIdRef char(5) '$.cpg.ref',
	name nvarchar(max) '$.name',
	topBrand char(5) '$.topBrand'
) as Dataset
