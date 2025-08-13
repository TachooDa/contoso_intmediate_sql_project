-- customer segmentation Q1
WITH customer_ltv AS (
	SELECT 
		customerkey,
		cleaned_name,
		sum(total_net_revenue ) AS total_ltv
	FROM cohort_analysis
	GROUP BY
		customerkey,
		cleaned_name
), customer_quarter AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_q1,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_q3
	FROM customer_ltv
), segment_values AS (
	SELECT
		cl.*,
		CASE 
			WHEN cl.total_ltv < cq.ltv_q1 THEN '1-- Low-value'
			WHEN cl.total_ltv <= cq.ltv_q3 THEN '2-- Mid-value'
			ELSE '3-- High-value'
		END AS customer_segment
	FROM customer_ltv AS cl,
		customer_quarter AS cq
)
SELECT 
	customer_segment,
	round(sum(total_ltv::numeric),3) AS total_ltv,
	count(customerkey) AS customer_count,
	round(sum(total_ltv::numeric) / count(customerkey::numeric),3) AS avg_ltv
FROM segment_values
GROUP BY
	customer_segment
ORDER BY
	customer_segment DESC;