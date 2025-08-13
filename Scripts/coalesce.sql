WITH sales_data AS (
SELECT
	customerkey,
	sum(quantity * netprice / exchangerate) AS net_revenue
FROM sales s 
GROUP BY customerkey
)
SELECT
	avg(s.net_revenue) AS spending_customers_avg_revenue,
	avg(COALESCE(s.net_revenue, 0)) AS all_cust_avg_net_revenue

FROM customer AS c
LEFT JOIN sales_data AS s ON c.customerkey = s.customerkey;


-- trim,upper,lower
SELECT trim(BOTH '@' FROM '@@faraj hafidh@')