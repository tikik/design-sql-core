-- =========================================
-- 04_core_queries.sql
-- Core SQL queries (CS 240)
-- =========================================

-- List all customers
\echo 'Q1: Customers'
SELECT * FROM customers;

\echo 'Q2: Orders with customer names'
-- Orders with customer names

SELECT
  o.order_id,
  c.full_name,
  o.status,
  o.created_at
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.created_at DESC;

-- Order totals (no view yet)
\echo 'Q3: order totals per order'
SELECT
  o.order_id,
  SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_id desc;

-- Active products under $20
\echo 'Q4: Active products under $20'

SELECT *
FROM products
WHERE active AND price < 20.00
ORDER BY price ASC;


-- Orders with no items (data quality check)
\echo 'Q5: Orders with no items'

SELECT o.order_id
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL
order by o.order_id;

-- Inventory audit for a product (e.g., product_id = 1)

SELECT *
FROM inventory_audit
WHERE product_id = 1
ORDER BY changed_at DESC;

-- Top 5 customers by total spending

SELECT
  c.customer_id,
  c.full_name,
  SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 5;

