USE airbnb_analysis;

CREATE TABLE listings (
    id BIGINT PRIMARY KEY,
    name VARCHAR(500),
    host_id BIGINT,
    host_name VARCHAR(100),
    host_type VARCHAR(30),
    neighbourhood_group VARCHAR(50),
    neighbourhood VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    room_type VARCHAR(50),
    price INT,
    price_tier VARCHAR(20),
    minimum_nights INT,
    number_of_reviews INT,
    reviews_per_month DECIMAL(5,2),
    review_velocity DECIMAL(5,2),
    ever_reviewed BOOLEAN,
    last_review DATE,
    host_listings_count INT,
    availability_365 INT,
    estimated_booked_nights INT,
    occupancy_rate_pct DECIMAL(5,1),
    estimated_annual_revenue INT
);
SELECT COUNT(*) FROM listings;
show warnings;
TRUNCATE TABLE listings;
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@secure_file_priv;
SELECT CONCAT('>>>', @@secure_file_priv, '<<<') AS full_path;
TRUNCATE TABLE listings;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airbnb_nyc_cleaned.csv'
INTO TABLE listings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, host_id, host_name, host_type, neighbourhood_group, neighbourhood,
 latitude, longitude, room_type, price, price_tier, minimum_nights,
 number_of_reviews, reviews_per_month, review_velocity, ever_reviewed,
 last_review, host_listings_count, availability_365, estimated_booked_nights,
 occupancy_rate_pct, estimated_annual_revenue);
 SELECT @@secure_file_priv;
 DESCRIBE listings;
 TRUNCATE TABLE listings;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airbnb_nyc_cleaned.csv'
INTO TABLE listings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, host_id, host_name, neighbourhood_group, neighbourhood, latitude, longitude,
room_type, price, minimum_nights, number_of_reviews, last_review, reviews_per_month,
host_listings_count, availability_365, estimated_booked_nights,
estimated_annual_revenue, occupancy_rate_pct, host_type, price_tier);
TRUNCATE TABLE listings;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airbnb_nyc_cleaned.csv'
INTO TABLE listings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, host_id, host_name, neighbourhood_group, neighbourhood, latitude, longitude,
room_type, price, minimum_nights, number_of_reviews, @last_review, reviews_per_month,
host_listings_count, availability_365, estimated_booked_nights,
estimated_annual_revenue, occupancy_rate_pct, host_type, price_tier)
SET last_review = NULLIF(@last_review, '');
 SELECT COUNT(*) FROM listings;
SELECT * FROM listings LIMIT 5;
SELECT 
    neighbourhood_group,
    neighbourhood,
    COUNT(*) AS listing_count,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(estimated_annual_revenue), 0) AS avg_est_revenue,
    ROUND(AVG(occupancy_rate_pct), 1) AS avg_occupancy_pct
FROM listings
GROUP BY neighbourhood_group, neighbourhood
HAVING listing_count >= 20
ORDER BY avg_est_revenue DESC
LIMIT 15; 
SELECT 
    host_type,
    COUNT(*) AS num_listings,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(estimated_annual_revenue), 0) AS avg_est_revenue,
    ROUND(AVG(reviews_per_month), 2) AS avg_review_velocity,
    ROUND(AVG(occupancy_rate_pct), 1) AS avg_occupancy_pct
FROM listings
GROUP BY host_type;
SELECT 
    price_tier,
    COUNT(*) AS num_listings,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(occupancy_rate_pct), 1) AS avg_occupancy_pct,
    ROUND(AVG(estimated_annual_revenue), 0) AS avg_est_revenue
FROM listings
GROUP BY price_tier
ORDER BY avg_price;
SELECT 
    room_type,
    COUNT(*) AS num_listings,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(occupancy_rate_pct), 1) AS avg_occupancy_pct,
    ROUND(AVG(estimated_annual_revenue), 0) AS avg_est_revenue
FROM listings
GROUP BY room_type
ORDER BY avg_est_revenue DESC;
CREATE VIEW neighbourhood_summary AS
SELECT 
    neighbourhood_group,
    neighbourhood,
    room_type,
    COUNT(*) AS listing_count,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(estimated_annual_revenue), 0) AS avg_est_revenue,
    ROUND(AVG(occupancy_rate_pct), 1) AS avg_occupancy_pct,
    ROUND(AVG(reviews_per_month), 2) AS avg_review_velocity
FROM listings
GROUP BY neighbourhood_group, neighbourhood, room_type;
SELECT * FROM neighbourhood_summary LIMIT 10;