SELECT SUM(revenue) AS revenue FROM transaction;
SELECT COUNT(DISTINCT transaction_id) AS total_order FROM transaction;
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM customer; 
SELECT SUM(revenue) / COUNT(DISTINCT transaction_id) AS avg_order_value FROM transaction;
SELECT SUM(quantity) AS total_product_sold FROM transaction;
SELECT SUM(revenue) / COUNT(DISTINCT customer_id) AS revenue_per_customer FROM transaction;
SELECT AVG(revenue) AS avg_revenue FROM transaction;


CREATE OR REPLACE VIEW KPI_summary AS SELECT 
SUM(revenue) AS revenue ,
COUNT(DISTINCT transaction_id) AS total_order ,
COUNT(DISTINCT customer_id) AS total_customers ,
SUM(revenue) / COUNT(DISTINCT transaction_id) AS avg_order_value ,
SUM(quantity) AS total_product_sold ,
SUM(revenue) / COUNT(DISTINCT customer_id) AS revenue_per_customer ,
AVG(revenue) AS avg_revenue FROM transaction;
SELECT * FROM  KPI_summary ;

CREATE VIEW customer_country_analysis AS
SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(t.revenue) AS total_revenue
FROM customer c
JOIN transaction t
ON c.customer_id = t.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;
SELECT * FROM customer_country_analysis;


CREATE VIEW top_customers AS
SELECT
    t.customer_id,
    SUM(t.revenue) AS customer_revenue,
    COUNT(DISTINCT t.transaction_id) AS total_orders
FROM transaction t
GROUP BY t.customer_id
ORDER BY customer_revenue DESC
LIMIT 10;
SELECT * FROM top_customers ;


CREATE VIEW top_products AS
SELECT
    p.product_name,
    SUM(t.quantity) AS total_quantity_sold
FROM transaction t
JOIN product p
ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;
SELECT * FROM top_products;

CREATE VIEW product_revenue_analysis AS
SELECT
    p.product_name,
    SUM(t.revenue) AS product_revenue
FROM transaction t
JOIN product p
ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC;
SELECT * FROM product_revenue_analysis;


CREATE VIEW campaign_customer_acquisition AS
SELECT
    m.campaign_name,
    COUNT(c.customer_id) AS customers_acquired
FROM marketing m
JOIN customer c
ON m.campaign_id = c.marketing_id
GROUP BY m.campaign_name
ORDER BY customers_acquired DESC;
SELECT * FROM campaign_customer_acquisition ;

CREATE VIEW campaign_cac AS
SELECT
    m.campaign_name,
    m.marketing_spend,
    COUNT(c.customer_id) AS customers,
    m.marketing_spend / COUNT(c.customer_id) AS customer_acquisition_cost
FROM marketing m
JOIN customer c
ON m.campaign_id = c.marketing_id
GROUP BY m.campaign_name, m.marketing_spend;
SELECT * FROM campaign_cac;

CREATE VIEW campaign_revenue_analysis AS
SELECT
    m.campaign_name,
    SUM(t.revenue) AS total_revenue
FROM marketing m
JOIN customer c
ON m.campaign_id = c.marketing_id
JOIN transaction t
ON c.customer_id = t.customer_id
GROUP BY m.campaign_name
ORDER BY total_revenue DESC;
SELECT * FROM campaign_revenue_analysis;


