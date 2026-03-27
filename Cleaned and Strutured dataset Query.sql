CREATE TABLE retail_raw (
    invoice TEXT,
    stockcode TEXT,
    description TEXT,
    quantity TEXT,
    invoice_date TEXT,
    price TEXT,
    customer_id TEXT,
    country TEXT
);
SELECT * FROM PUBLIC.retail_raw;

SELECT COUNT(*) FROM retail_raw;
SELECT COUNT(DISTINCT invoice) FROM retail_raw;
SELECT COUNT(DISTINCT customer_id) FROM retail_raw;
SELECT COUNT(DISTINCT stockcode) FROM retail_raw;



SELECT 
COUNT(*) total_rows,
COUNT(invoice) AS invoice_not_null,
COUNT(stockcode) AS  stockcode_not_null,
COUNT(description) AS description_not_null,
COUNT(quantity) AS quantity_not_null,
COUNT(price) AS price_not_null,
COUNT(customer_id) AS customer_id_not_null,
COUNT(country)AS country_not_null
FROM retail_raw;


DELETE FROM retail_raw WHERE invoice IS NULL;
DELETE FROM retail_raw WHERE stockcode IS NULL;
DELETE FROM retail_raw WHERE price IS NULL OR quantity IS NULL;
DELETE FROM retail_raw WHERE  customer_id IS NULL;


SELECT COUNT(*) 
FROM retail_raw
WHERE description IS NULL;

SELECT COUNT(*) 
FROM retail_raw
WHERE country IS NULL;

SELECT COUNT(*) FROM retail_raw
WHERE invoice_date IS NULL;

SELECT 
COUNT(*) AS total_rows,
COUNT(customer_id) AS customer_not_null
FROM retail_raw;


SELECT COUNT(*)
FROM retail_raw
WHERE invoice LIKE 'C%';


CREATE TABLE cancellation AS
SELECT * FROM retail_raw
WHERE invoice LIKE 'C%';

DELETE FROM retail_raw 
WHERE invoice LIKE 'C%';


SELECT COUNT(*) FROM retail_raw
WHERE invoice LIKE 'c%';

SELECT COUNT(*) FROM retail_raw
WHERE quantity < 0;

SELECT COUNT(*) FROM retail_raw
WHERE price <=0;

SELECT COUNT(*) FROM retail_raw
WHERE revenue IS NULL;


UPDATE retail_raw SET revenue = quantity * price;

SELECT invoice_date FROM retail_raw LIMIT 20;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'retail_raw'
;


ALTER TABLE retail_raw 
ADD COLUMN invoice_date_clean DATE;


UPDATE retail_raw SET 
invoice_date_clean= TO_DATE(
invoice_date,'YYYY-MM-DD'
);

SELECT invoice_date,invoice_date_clean
FROM retail_raw LIMIT 10;

ALTER TABLE retail_raw 
DROP COLUMN invoice_date;

ALTER TABLE retail_raw 
RENAME COLUMN invoice_date_clean TO invoice_date;

SELECT country,LENGTH(country)
FROM retail_raw
WHERE country LIKE ' %'
OR country LIKE '% ';

UPDATE retail_raw
SET country=TRIM(country),
stockcode=TRIM(stockcode),
description=TRIM(description),
invoice=TRIM(invoice);

UPDATE retail_raw
SET country = INITCAP(LOWER(country));

CREATE TABLE customer(customer_id INT PRIMARY KEY,
country VARCHAR(50),fisrt_purchase_date DATE);

SELECT * FROM public.customer;

INSERT INTO customer (customer_id, country, fisrt_purchase_date)
SELECT 
    customer_id,
    country,
    MIN(invoice_date)
FROM retail_raw
WHERE customer_id IS NOT NULL
GROUP BY customer_id, country
ON CONFLICT (customer_id) DO NOTHING;
SELECT * FROM public.customer;

SELECT 
customer_id,
COUNT(DISTINCT invoice) AS total_orders
FROM retail_raw
GROUP BY customer_id;

CREATE TABLE product(product_id VARCHAR(20) PRIMARY KEY,
product_name TEXT,
price NUMERIC(12,2));

INSERT INTO product (product_id, product_name, price)
SELECT DISTINCT 
stockcode AS product_id,
description AS product_name,
price FROM retail_raw
WHERE stockcode IS NOT NULL
ON CONFLICT (product_id) DO NOTHING;

SELECT * FROM product LIMIT 20;

CREATE TABLE transaction (
    transaction_id VARCHAR(20),
    product_id VARCHAR(20),
    customer_id INT,
    quantity INT,
    invoice_date TIMESTAMP,
    revenue NUMERIC(12,2),
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

INSERT INTO transaction (transaction_id, product_id, customer_id, quantity, invoice_date, revenue)
SELECT 
    invoice AS transaction_id,
    stockcode AS product_id,
    customer_id,
    quantity,
    invoice_date,
    revenue
FROM retail_raw
WHERE customer_id IS NOT NULL
ON CONFLICT (transaction_id, product_id) DO NOTHING;

SELECT * FROM transaction;


SELECT DISTINCT(country) FROM retail_raw;

CREATE TABLE marketing (
    marketing_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50),
    campaign_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    marketing_spend NUMERIC(12,2),
    region VARCHAR(50)
);


INSERT INTO marketing (campaign_name, channel, campaign_type, start_date, end_date, marketing_spend, region)
VALUES
('Australia Market Expansion','Facebook Ads','Paid','2026-01-01','2026-01-31',3000,'Australia'),
('Austria Digital Campaign','Google Ads','Paid','2026-01-02','2026-01-30',2800,'Austria'),
('Bahrain Customer Drive','Instagram Ads','Paid','2026-01-03','2026-01-28',2500,'Bahrain'),
('Belgium Email Campaign','Email Marketing','Organic','2026-01-04','2026-01-25',900,'Belgium'),
('Brazil Growth Campaign','YouTube Ads','Paid','2026-01-05','2026-02-05',3200,'Brazil'),
('Canada Holiday Promotion','Facebook Ads','Paid','2026-01-06','2026-02-01',3400,'Canada'),
('Channel Islands Local Promo','Website Promotion','Organic','2026-01-07','2026-01-27',700,'Channel Islands'),
('Cyprus Social Campaign','Instagram Ads','Paid','2026-01-08','2026-02-02',2400,'Cyprus'),
('Czech Republic Digital Push','Google Ads','Paid','2026-01-09','2026-02-04',2600,'Czech Republic'),
('Denmark Brand Awareness','LinkedIn Ads','Paid','2026-01-10','2026-02-10',2700,'Denmark'),
('Eire Customer Engagement','Email Marketing','Organic','2026-01-11','2026-02-05',850,'Eire'),
('European Community Expansion','Affiliate','Paid','2026-01-12','2026-02-08',2900,'European Community'),
('Finland Winter Campaign','Facebook Ads','Paid','2026-01-13','2026-02-07',3100,'Finland'),
('France Market Promotion','Instagram Ads','Paid','2026-01-14','2026-02-09',3000,'France'),
('Germany Performance Ads','Google Ads','Paid','2026-01-15','2026-02-10',3600,'Germany'),
('Greece Seasonal Campaign','YouTube Ads','Paid','2026-01-16','2026-02-11',2700,'Greece'),
('Iceland Online Campaign','Website Promotion','Organic','2026-01-17','2026-02-12',800,'Iceland'),
('Israel Digital Sales Drive','Facebook Ads','Paid','2026-01-18','2026-02-13',3000,'Israel'),
('Italy Social Growth Campaign','Instagram Ads','Paid','2026-01-19','2026-02-14',3100,'Italy'),
('Japan Market Expansion','Google Ads','Paid','2026-01-20','2026-02-15',3500,'Japan'),
('Lebanon Brand Awareness','LinkedIn Ads','Paid','2026-01-21','2026-02-16',2500,'Lebanon'),
('Lithuania Digital Campaign','Facebook Ads','Paid','2026-01-22','2026-02-17',2300,'Lithuania'),
('Malta Customer Campaign','Email Marketing','Organic','2026-01-23','2026-02-18',750,'Malta'),
('Netherlands Performance Ads','Google Ads','Paid','2026-01-24','2026-02-19',3400,'Netherlands'),
('Norway Winter Sales Campaign','Instagram Ads','Paid','2026-01-25','2026-02-20',3000,'Norway'),
('Poland Market Awareness','YouTube Ads','Paid','2026-01-26','2026-02-21',2600,'Poland'),
('Portugal Online Growth','Facebook Ads','Paid','2026-01-27','2026-02-22',2500,'Portugal'),
('RSA Market Campaign','Affiliate','Paid','2026-01-28','2026-02-23',2400,'RSA'),
('Saudi Arabia Sales Drive','Google Ads','Paid','2026-01-29','2026-02-24',3300,'Saudi Arabia'),
('Singapore Digital Campaign','LinkedIn Ads','Paid','2026-01-30','2026-02-25',3100,'Singapore'),
('Spain Social Engagement','Instagram Ads','Paid','2026-01-31','2026-02-26',3200,'Spain'),
('Sweden Nordic Campaign','Facebook Ads','Paid','2026-02-01','2026-02-27',3000,'Sweden'),
('Switzerland Premium Campaign','Google Ads','Paid','2026-02-02','2026-02-28',3500,'Switzerland');



UPDATE customer
SET marketing_id = (SELECT marketing_id FROM marketing ORDER BY RANDOM() LIMIT 1);
ALTER TABLE customer
ADD COLUMN marketing_id INT;

UPDATE customer
SET marketing_id = (
    SELECT campaign_id
    FROM marketing
    ORDER BY RANDOM()
    LIMIT 1
);

DROP TABLE marketing;
ALTER TABLE customer
ADD COLUMN marketing_id INT;

UPDATE customer
SET marketing_id = FLOOR(RANDOM() * 33 + 1);


SELECT marketing_id, COUNT(customer_id)
FROM customer
GROUP BY marketing_id
ORDER BY marketing_id;

CREATE TABLE marketing (
campaign_id INT PRIMARY KEY,
campaign_name TEXT,
channel TEXT,
campaign_type TEXT,
marketing_spend NUMERIC,
region TEXT
);

INSERT INTO marketing (campaign_id, campaign_name, channel, campaign_type, marketing_spend, region)
VALUES
(1,'Australia Summer Promo','Google Ads','Paid',3500,'Australia'),
(2,'Austria Winter Discount','Facebook Ads','Paid',3000,'Austria'),
(3,'Bahrain Holiday Campaign','Instagram Ads','Paid',2800,'Bahrain'),
(4,'Belgium Seasonal Offer','Email Marketing','Organic',900,'Belgium'),
(5,'Brazil Carnival Sale','Google Ads','Paid',4000,'Brazil'),
(6,'Canada Holiday Campaign','YouTube Ads','Paid',4200,'Canada'),
(7,'Channel Islands Local Promo','Email Marketing','Organic',600,'Channel Islands'),
(8,'Cyprus Online Growth Campaign','Facebook Ads','Paid',2100,'Cyprus'),
(9,'Czech Republic Market Expansion','Google Ads','Paid',2500,'Czech Republic'),
(10,'Denmark Digital Awareness','LinkedIn Ads','Paid',2200,'Denmark'),
(11,'Eire Loyalty Program','Email Marketing','Organic',700,'Eire'),
(12,'European Community Brand Campaign','YouTube Ads','Paid',5000,'European Community'),
(13,'Finland Winter Shopping Campaign','Instagram Ads','Paid',2300,'Finland'),
(14,'France Fashion Promotion','Google Ads','Paid',4100,'France'),
(15,'Germany Retail Growth Campaign','Facebook Ads','Paid',3900,'Germany'),
(16,'Greece Tourism Promotion','Instagram Ads','Paid',2400,'Greece'),
(17,'Iceland Holiday Promotion','Email Marketing','Organic',650,'Iceland'),
(18,'Israel Digital Campaign','Google Ads','Paid',2700,'Israel'),
(19,'Italy Seasonal Fashion Sale','Instagram Ads','Paid',3200,'Italy'),
(20,'Japan Tech Shopping Campaign','YouTube Ads','Paid',4500,'Japan'),
(21,'Lebanon Local Promotion','Facebook Ads','Paid',1900,'Lebanon'),
(22,'Lithuania Market Awareness','Google Ads','Paid',2000,'Lithuania'),
(23,'Malta Tourism Shopping Campaign','Instagram Ads','Paid',2100,'Malta'),
(24,'Netherlands Retail Growth','Google Ads','Paid',3600,'Netherlands'),
(25,'Norway Winter Campaign','Facebook Ads','Paid',2500,'Norway'),
(26,'Poland Online Shopping Campaign','Google Ads','Paid',2600,'Poland'),
(27,'Portugal Summer Sale','Instagram Ads','Paid',2400,'Portugal'),
(28,'RSA Regional Campaign','Email Marketing','Organic',800,'Rsa'),
(29,'Saudi Arabia Shopping Festival','Google Ads','Paid',3800,'Saudi Arabia'),
(30,'Singapore Digital Sale','Facebook Ads','Paid',3300,'Singapore'),
(31,'Spain Holiday Discount','Instagram Ads','Paid',3000,'Spain'),
(32,'Sweden Winter Deals','Google Ads','Paid',3100,'Sweden'),
(33,'Switzerland Premium Shopping Campaign','LinkedIn Ads','Paid',4200,'Switzerland');

SELECT * FROM marketing;

SELECT campaign_id
FROM marketing
ORDER BY campaign_id;


ALTER TABLE customer
ADD CONSTRAINT fk_campaign
FOREIGN KEY (marketing_id)
REFERENCES marketing(campaign_id);

SELECT c.customer_id, m.campaign_name
FROM customer c
JOIN marketing m
ON c.marketing_id = m.campaign_id;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';


