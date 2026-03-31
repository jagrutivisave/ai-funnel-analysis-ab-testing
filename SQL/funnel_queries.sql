select * from ecommerce_funnel

CREATE TABLE ecommerce_funnel (
    user_id INT PRIMARY KEY,
    date TIMESTAMP,
    traffic_source VARCHAR(50),
    device_type VARCHAR(50),
    region VARCHAR(50),
    variant VARCHAR(10),
    visited_site INT,
    viewed_product INT,
    added_to_cart INT,
    started_checkout INT,
    completed_payment INT,
    time_spent_min NUMERIC(10,2),
    session_count INT
);


COPY ecommerce_funnel
FROM 'C:/data analyst/projects/Funnel_Analysis/AI-powered funnel analysis/data/cleaned_data.csv'
DELIMITER ','
CSV HEADER;

-- View first rows
SELECT * 
FROM ecommerce_funnel
LIMIT 10;

-- Count total rows
SELECT COUNT(*) AS total_users
FROM ecommerce_funnel;

-- Check variants
SELECT variant, COUNT(*) AS users
FROM ecommerce_funnel
GROUP BY variant;

-- Funnel stage counts
SELECT
    COUNT(*) AS total_users,
    SUM(visited_site) AS visited_site_users,
    SUM(viewed_product) AS viewed_product_users,
    SUM(added_to_cart) AS added_to_cart_users,
    SUM(started_checkout) AS started_checkout_users,
    SUM(completed_payment) AS completed_payment_users
FROM ecommerce_funnel;

-- Overall conversion rate
SELECT
    ROUND(SUM(completed_payment)::numeric / SUM(visited_site) * 100, 2) AS overall_conversion_rate
FROM ecommerce_funnel;

-- Conversion by device type
SELECT
    device_type,
    COUNT(*) AS total_users,
    SUM(completed_payment) AS converted_users,
    ROUND(SUM(completed_payment)::numeric / COUNT(*) * 100, 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY device_type
ORDER BY conversion_rate DESC;

-- Conversion by traffic source
SELECT
    traffic_source,
    COUNT(*) AS total_users,
    SUM(completed_payment) AS converted_users,
    ROUND(SUM(completed_payment)::numeric / COUNT(*) * 100, 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY traffic_source
ORDER BY conversion_rate DESC;

-- Conversion by region
SELECT
    region,
    COUNT(*) AS total_users,
    SUM(completed_payment) AS converted_users,
    ROUND(SUM(completed_payment)::numeric / COUNT(*) * 100, 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY region
ORDER BY conversion_rate DESC;

-- A/B test comparison
SELECT
    variant,
    COUNT(*) AS total_users,
    SUM(completed_payment) AS converted_users,
    ROUND(SUM(completed_payment)::numeric / COUNT(*) * 100, 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY variant
ORDER BY variant;

-- Funnel performance by variant
SELECT
    variant,
    SUM(visited_site) AS visited_site_users,
    SUM(viewed_product) AS viewed_product_users,
    SUM(added_to_cart) AS added_to_cart_users,
    SUM(started_checkout) AS started_checkout_users,
    SUM(completed_payment) AS completed_payment_users
FROM ecommerce_funnel
GROUP BY variant
ORDER BY variant;

-- Device and variant combined
SELECT
    device_type,
    variant,
    COUNT(*) AS total_users,
    SUM(completed_payment) AS converted_users,
    ROUND(SUM(completed_payment)::numeric / COUNT(*) * 100, 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY device_type, variant
ORDER BY device_type, variant;

-- Average engagement by variant
SELECT
    variant,
    ROUND(AVG(time_spent_min), 2) AS avg_time_spent,
    ROUND(AVG(session_count), 2) AS avg_session_count
FROM ecommerce_funnel
GROUP BY variant
ORDER BY variant;

