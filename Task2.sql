
/* 1) What are the top 5 brands by receipts scanned for most recent month? */
	DECLARE @startOfCurrentMonth DATETIME
	SET @startOfCurrentMonth = DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0)

	SELECT TOP 5 (b.name), COUNT(b.topBrand) as TopBrandCountByReceiptScannedForMostRecentMonth
	FROM brands b
	INNER JOIN receipts c on b.cpgidoid = c.rewardsReceiptItemListrewardsProductPartnerId 
	WHERE c.datescanned >= DATEADD(MONTH, -1, @startOfCurrentMonth) 
		  AND b.topBrand NOT IN('false', 'NULL')
	GROUP BY (b.name)
	ORDER BY 2 DESC

/*2) When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, 
which is greater?*/

	SELECT TOP 1 AVG(CAST(totalSpent AS FLOAT)) AS 'Average Spend', rewardsReceiptStatus
	FROM receipts
	where rewardsReceiptStatus in ('FINISHED', 'REJECTED')
	GROUP BY rewardsReceiptStatus
	ORDER BY 1 DESC;

/*3) When considering total number of items purchased from receipts with 
'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?*/

	SELECT TOP 1 COUNT(purchasedItemCount) AS 'Total Number Of Items Purchased', rewardsReceiptStatus
	FROM receipts
	where rewardsReceiptStatus in ('FINISHED' , 'REJECTED')
	GROUP BY rewardsReceiptStatus
	ORDER BY COUNT(purchasedItemCount) DESC;
