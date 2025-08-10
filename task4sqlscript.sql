-- 1 . Show top 10 rows
select * from olist_customer_dataset limit 10;
select * from olist_order_items_dataset limit 10;
select * from olist_order_payments_dataset limit 10;
select * from olist_order_reviews_dataset limit 10;
select * from olist_orders_dataset limit 10;
select * from olist_products_dataset limit 10;
select * from olist_sellers_dataset limit 10;
select * from product_category_name_translation limit 10;

-- 2 . Total Number of Unique Customers
SELECT COUNT(distinct(customer_unique_id)) AS total_unique_customers
FROM olist_customers_dataset;

--  3. Number of Orders per State
SELECT c.customer_state, COUNT(o.order_id) AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC ;

-- 4 . Number of order per City
SELECT c.customer_city, COUNT(o.order_id) AS total_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC;


-- 5. Top 5 Most Sold Products
SELECT product_id, COUNT(order_id) AS total_sold
FROM olist_order_items_dataset
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 5;

-- 	6. Top 5 Cities by Number of Customers
SELECT customer_city, COUNT(*) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 5;


--  7. Average Payment per Order
SELECT AVG(payment_value) AS avg_payment
FROM olist_order_payments_dataset;

--  8. Total Revenue per Customer
SELECT o.customer_id, round(SUM(p.payment_value),2) AS total_spent
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC;

--  9. Find Orders with No Reviews
SELECT o.order_id
FROM olist_orders_dataset o
LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE r.review_id IS NULL;

-- 10.  Orders with Late Delivery
SELECT order_id
FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date;

--  11. review_category based on review_score.
SELECT order_id,review_score,
    CASE 
        WHEN review_score = 5 THEN 'Excellent'
        WHEN review_score = 4 THEN 'Good'
        WHEN review_score = 3 THEN 'Average'
        WHEN review_score = 2 THEN 'Poor'
        WHEN review_score = 1 THEN 'Bad'
        ELSE 'Unknown'
    END AS review_category
FROM olist_order_reviews_dataset
LIMIT 20;

-- 12. Show all sellers and their total sales (including sellers with no sales).
SELECT s.seller_id, IFNULL(SUM(oi.price), 0) AS total_sales
FROM olist_sellers_dataset s
LEFT JOIN olist_order_items_dataset oi  ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
-- ORDER BY total_sales DESC;

-- 13. Creat views for Olist (monthly, total_sales,total_orders)
CREATE VIEW monthly_sales AS
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(p.payment_value), 2) AS total_sales,
    COUNT(o.order_id) AS total_orders
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p 
    ON o.order_id = p.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

SELECT * FROM monthly_sales;
