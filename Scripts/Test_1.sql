-- public.cohort_analysis source
DROP VIEW cohort_analysis ;
CREATE OR REPLACE VIEW public.cohort_analysis AS 
WITH customer_revenue AS (
         SELECT s.orderdate,
            s.customerkey,
            sum(s.quantity::double precision * s.unitprice / s.exchangerate) AS total_net_revenue,
            count(s.orderkey) AS num_order,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
           FROM sales s
             LEFT JOIN customer c ON s.customerkey = c.customerkey
          GROUP BY s.orderdate, s.customerkey, c.countryfull, c.age, c.givenname, c.surname
        )
 SELECT orderdate,
    customerkey,
    total_net_revenue,
    num_order,
    countryfull,
    age,
    concat(trim(givenname), ' ',trim(surname)) AS cleaned_name,
    min(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM customer_revenue cr;