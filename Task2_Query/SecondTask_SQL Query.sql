/*1) When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, 
which is greater?*/
/* Assumption - Since the table does not contain any value called "ACCEPTED" for the rewardsReceiptStatus
column, I have assumed that "FINISHED" is consodered as "ACCEPTED".*/

	SELECT TOP 1 AVG(totalSpent) AS 'Average Spend', rewardsReceiptStatus
	FROM [DW].[factReceipts]
	where rewardsReceiptStatus in ('FINISHED', 'REJECTED')
	GROUP BY rewardsReceiptStatus
	ORDER BY 1 DESC;

/*2) When considering total number of items purchased from receipts with 
'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?*/
/* Assumption - Since the table does not contain any value called "ACCEPTED" for the rewardsReceiptStatus
column, I have assumed that "FINISHED" is consodered as "ACCEPTED".*/

	SELECT TOP 1 SUM(purchasedItemCount) AS 'Total Number Of Items Purchased', rewardsReceiptStatus
	FROM [DW].[factReceipts]
	where rewardsReceiptStatus in ('FINISHED' , 'REJECTED')
	GROUP BY rewardsReceiptStatus
	ORDER BY COUNT(purchasedItemCount) DESC;

/* 3) What are the top 5 brands by receipts scanned for most recent month? */
/* this predetermined question is little vague to understand as there is no specific details on how the top 5 brands
are being considered? Based on TotalSpent or revenue during most recent month, OR based on number of total items sold,
OR based on the "topBrands" flag */

	DECLARE @startOfCurrentMonth DATETIME
	SET @startOfCurrentMonth = DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0)

	SELECT TOP 5 (b.name) AS 'Brand Name', COUNT(b.topBrand) as TopBrandCountByReceiptScannedForMostRecentMonth
	FROM [DW].[dimBrands] b
	INNER JOIN [DW].[factReceipts] c on b.cpgidoid = c.rewardsReceiptItemListrewardsProductPartnerId 
	WHERE c.datescanned >= DATEADD(MONTH, -1, @startOfCurrentMonth) 
		  AND b.topBrand = 1
	GROUP BY (b.name)
	ORDER BY 2 DESC


