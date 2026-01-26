-- =========================================
-- 06_exercises_01_30.sql
-- Track 1 exercises tailored to this repo (CS 240)
-- =========================================

-- 1. List all customers
\echo 'E01: List all customers'
select * from customers 
limit 5;

-- 2. List customerid and full_name only
\echo 'E02: List customer_id and full_name'
select customer_id, full_name from customers;

-- 3. List all active products
\echo 'E03: List all products'
select * from products where active = true;

-- 5. List inactive products
\echo 'E05: Inactive products'
SELECT *
FROM products
WHERE active = FALSE;

-- 6. All orders newest first
\echo 'E06: All orders newest first'
SELECT *
FROM orders
ORDER BY created_at DESC;

-- 7. 5 most recent orders
\echo 'E07: 5 most recent orders'
SELECT *
FROM orders
ORDER BY created_at DESC
LIMIT 5;

-- 8. How many customers do we have?
\echo 'E08: Count customers'
SELECT COUNT(*) AS customer_count FROM customers;

-- 9. List order by status, count number of orders for each status category. 
\echo 'E09: Count orders by status'
SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status
ORDER BY cnt DESC;

-- 10. List all orders for the first customer in store. 
\echo 'E10: Orders for customer_id = 1'
SELECT *
FROM orders
WHERE customer_id = 1
ORDER BY created_at DESC;

-- 11. List all orders created in Jan 2026
\echo 'E11: Orders created in January 2026 (edit dates as needed)'
SELECT *
FROM orders
WHERE created_at >= '2026-01-01'
  AND created_at <  '2026-02-01'
ORDER BY created_at;

-- 12. List all products priced from $5 to $20. 
\echo 'E12: Products priced between $5 and $20'
SELECT *
FROM products
WHERE price BETWEEN 5 AND 20
ORDER BY price;

-- 13. List all customers whose name is Tran:
\echo 'E13: Customers whose name contains Tran'
SELECT *
FROM customers
WHERE full_name ILIKE '%Tran%';

-- 14. List all orders that our store have and cusomters name as well. Might need left join and coalesce. 
\echo 'E14: Orders with customer names'
SELECT
  o.order_id,
  c.full_name,
  o.status,
  o.created_at
FROM orders o
JOIN customers c
  ON c.customer_id = o.customer_id
ORDER BY o.created_at DESC;

-- 15. List products names and line items they belong to. 
\echo 'E15: Order line items with product names'
SELECT
  oi.order_id,
  p.product_name,
  oi.quantity,
  oi.unit_price,
  (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
JOIN products p
  ON p.product_id = oi.product_id
ORDER BY oi.order_id, p.product_name;

-- 16. Find any duplicate emails
\echo 'E16: Any duplicate emails? (should return 0 rows)'
SELECT email, COUNT(*) AS cnt
FROM customers
GROUP BY email
HAVING cnt > 1;

-- 17. List any invalid orders:
\echo 'E17: Any invalid order statuses? (should return 0 rows)'
SELECT *
FROM orders
WHERE status NOT IN ('open','completed','cancelled');

-- 18. How much did we make per order
\echo 'E18: Order totals per order'
SELECT
  o.order_id,
  SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi
  ON oi.order_id = o.order_id
GROUP BY o.order_id
ORDER BY order_total DESC;

-- 19. Calclate how much each customer spend in our store? 
\echo 'E19: Total revenue per customer (include customers with 0 revenue)'
SELECT
  c.customer_id,
  c.full_name,
  COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS revenue
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
LEFT JOIN order_items oi
  ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY revenue DESC;

-- 20. List all customers with no orders:
\echo 'E20: Customers with no orders'
SELECT c.customer_id, c.full_name
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

-- 21. What orders do not have items?
\echo 'E21: Orders with no items'
SELECT o.order_id
FROM orders o
LEFT JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL
ORDER BY o.order_id;

-- 22. List top 5 products sold?
\echo 'E22: Top 5 products by quantity sold'
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(oi.quantity), 0) AS total_sold
FROM products p
LEFT JOIN order_items oi
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- 23. What is the average order value?
\echo 'E23: Average order value (AOV)'
WITH order_totals AS (
  SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS total
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.order_id
)
SELECT AVG(total) AS avg_order_value
FROM order_totals;

-- 24. How many orders per customer?
\echo 'E24: Orders per customer'
SELECT
  c.customer_id,
  c.full_name,
  COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC;

-- 25. How many orders open in 7 days ? 
\echo 'E25: Open orders older than 7 days (ops risk)'
SELECT *
FROM orders
WHERE status = 'open'
  AND created_at < NOW() - INTERVAL '7 days'
ORDER BY created_at;

\echo 'E26: Price mismatch check (sold vs current price)'
SELECT
  oi.order_id,
  p.product_name,
  oi.unit_price AS sold_price,
  p.price AS current_price
FROM order_items oi
JOIN products p
  ON p.product_id = oi.product_id
WHERE oi.unit_price <> p.price
ORDER BY oi.order_id;

\echo 'E27: Products that have never been ordered'
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi
  ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;

\echo 'E28: Customers who have placed at least one order (EXISTS)'
SELECT c.customer_id, c.full_name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

\echo 'E29: Customers with no orders (NOT EXISTS)'
SELECT c.customer_id, c.full_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.customer_id
);

\echo 'E30: Inventory audit summary'
SELECT
  product_id,
  SUM(change_qty) AS net_change,
  COUNT(*) AS audit_events
FROM inventory_audit
GROUP BY product_id
ORDER BY audit_events DESC;
