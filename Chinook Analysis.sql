# Task 5: SQL-Based Analysis of Product Sales (Chinook Database)

USE chinook;

SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre;
SELECT * FROM invoice;
SELECT * FROM invoiceline;
SELECT * FROM mediatype;
SELECT * FROM playlist;
SELECT * FROM playlisttrack;
SELECT * FROM track;


# Distinct countries of customers
SELECT DISTINCT Country
FROM customer;

# Exploring the date range of invoices
SELECT 
	MIN(InvoiceDate) AS start_date,
	MAX(InvoiceDate) AS end_date
FROM invoice;

# Total Revenue
SELECT SUM(Total)
FROM invoice;

# Total Quantity
 SELECT SUM(Quantity)
 FROM invoiceline;

# Total No. Invoices
SELECT COUNT(InvoiceId)
FROM invoice;
  
# Total Customers
SELECT COUNT(CustomerId) AS total_customers
FROM customer;

# Average Track Price
SELECT AVG(UnitPrice) AS avg_price
FROM track;

# Customers by Country
SELECT 
	Country,
	COUNT(CustomerId) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC;

# Revenue by Region
SELECT 
	BillingCountry AS country,
    SUM(Total) AS revenue
FROM invoice
GROUP BY BillingCountry
ORDER BY BillingCountry DESC;

# Top Selling Tracks
SELECT
	tk.`Name` AS track,
	SUM(inv.UnitPrice * inv.Quantity) AS revenue
FROM invoiceline inv
INNER JOIN track tk
	ON inv.TrackId = tk.TrackId
GROUP BY tk.`Name`
ORDER BY revenue DESC
LIMIT 5;

# Top Selling Albums
SELECT
	alb.Title AS album,
	SUM(inv.UnitPrice * inv.Quantity) AS revenue
FROM invoiceline inv
INNER JOIN track tk
	ON inv.TrackId = tk.TrackId
INNER JOIN album alb
	ON tk.AlbumId = alb.AlbumId
GROUP BY alb.Title
ORDER BY revenue DESC
LIMIT 5;

# Top Selling Genres
SELECT
	g.`Name` AS genre,
	SUM(inv.UnitPrice * inv.Quantity) AS revenue
FROM invoiceline inv
INNER JOIN track tk
	ON inv.TrackId = tk.TrackId
INNER JOIN genre g
	ON tk.GenreId = g.GenreId
GROUP BY g.`Name`
ORDER BY revenue DESC
LIMIT 5;

# Top Spending Customers
SELECT
	concat_ws(' ', cust.FirstName, cust.LastName) AS customer,
	SUM(inv.Total) AS revenue
FROM invoice inv
INNER JOIN customer cust
	ON inv.CustomerId = cust.CustomerId
GROUP BY concat_ws(' ', cust.FirstName, cust.LastName)
ORDER BY revenue DESC
LIMIT 5;

# Yearly Revenue Trend
SELECT
	year(InvoiceDate) AS `year`,
    SUM(Total) AS revenue
FROM invoice
GROUP BY year(InvoiceDate)
ORDER BY `year`;

# Monthly Revenue Rolling Total
WITH month_rev_cte AS
(
	SELECT 
		year(InvoiceDate) AS `year`,
		month(InvoiceDate) AS `month`,
		SUM(Total) AS monthly_revenue
	FROM invoice
	GROUP BY year(InvoiceDate), month(InvoiceDate)
)
SELECT 
	`year`,
    `month`,
    monthly_revenue,
	SUM(monthly_revenue) OVER(PARTITION BY `year` ORDER BY `year`, `month`) AS rolling_total
FROM month_rev_cte
ORDER BY `year`, `month`;



## Insights:
# Invoice date ranges from 2021-01-01 up to 2025-12-22
# Total Revenue: 2,329
# Total Quantity Sold: 2,240
# Total Number of Invoices: 412
# Total Number of Customers: 59
# Average Track Price: 1.05
# Customers by Country: USA on top with 13 customers, followed by Canada
# Revenue by Region: USA dominates with $523 followed by UK with $113
# Best Selling Genres: Rock is the dominating genre with $827 followed by Lating and Metal
# Yearly Revenue Trend: Revenue peaked in 2022 with $481, with non-major fluctuations over the years
