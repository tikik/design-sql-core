
-- =========================================
-- 07_exercises_31_50.sql
-- Track 1 (Repo #1 / CS 240): Intermediate Exercises 31–50
-- Schema: customers, products, orders, order_items, inventory_audit
-- =========================================

\echo 'E31: Customer names and their order IDs (JOIN customers + orders)'
SELECT
  c.customer_id,
  c.full_name,
  o.order_id,
  o.status,
  o.created_at
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

\echo 'E32: Order details with product name, qty, unit_price, line_total'
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

\echo 'E33: Full order report (customer + order_total)'
WITH order_totals AS (
  SELECT
    o.order_id,
    o.customer_id,
    o.status,
    o.created_at,
    SUM(oi.quantity * oi.unit_price) AS order_total
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.order_id, o.customer_id, o.status, o.created_at
)
SELECT
  ot.order_id,
  c.full_name,
  ot.status,
  ot.created_at,
  ot.order_total
FROM order_totals ot
JOIN customers c
  ON c.customer_id = ot.customer_id
ORDER BY ot.created_at DESC;

\echo 'E34: Customers who have NOT placed any orders (LEFT JOIN)'
SELECT
  c.customer_id,
  c.full_name
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;

\echo 'E35: Products that have NEVER been ordered'
SELECT
  p.product_id,
  p.product_name
FROM products p
LEFT JOIN order_items oi
  ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;

\echo 'E36: Orders with NO items (data quality check)'
SELECT
  o.order_id,
  o.customer_id,
  o.status,
  o.created_at
FROM orders o
LEFT JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL
ORDER BY o.order_id;

\echo 'E37: Customers who ordered a specific product (change product_name as needed)'
-- Change 'Notebook' to any product_name in your seed data
SELECT DISTINCT
  c.customer_id,
  c.full_name
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON oi.order_id = o.order_id
JOIN products p
  ON p.product_id = oi.product_id
WHERE p.product_name = 'Notebook'
ORDER BY c.customer_id;

\echo 'E38: Orders containing at least 2 distinct products'
SELECT
  oi.order_id,
  COUNT(DISTINCT oi.product_id) AS distinct_products
FROM order_items oi
GROUP BY oi.order_id
HAVING COUNT(DISTINCT oi.product_id) >= 2
ORDER BY distinct_products DESC, oi.order_id;

\echo 'E39: Orders where total value > 20 (change threshold as needed)'
WITH order_totals AS (
  SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.order_id
)
SELECT *
FROM order_totals
WHERE order_total > 20
ORDER BY order_total DESC;

\echo 'E40: Customer who placed the most orders (ties allowed)'
SELECT
  c.customer_id,
  c.full_name,
  COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC, c.customer_id
LIMIT 1;

\echo 'E41: Average price of all products'
SELECT AVG(price) AS avg_product_price
FROM products;

\echo 'E42: Min and max product price (active products only)'
SELECT
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM products
WHERE active = TRUE;

\echo 'E43: Count number of orders placed by each customer'
SELECT
  c.customer_id,
  c.full_name,
  COUNT(o.order_id) AS orders_placed
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY orders_placed DESC, c.customer_id;

\echo 'E44: Total revenue for each product'
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS revenue
FROM products p
LEFT JOIN order_items oi
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC, p.product_id;

\echo 'E45: Total revenue by day'
SELECT
  DATE(o.created_at) AS order_day,
  SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
  ON oi.order_id = o.order_id
GROUP BY DATE(o.created_at)
ORDER BY order_day;

\echo 'E46: Average order value per customer'
WITH order_totals AS (
  SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
  FROM orders o
  JOIN order_items oi
    ON oi.order_id = o.order_id
  GROUP BY o.order_id, o.customer_id
)
SELECT
  c.customer_id,
  c.full_name,
  AVG(ot.order_total) AS avg_order_value
FROM customers c
JOIN order_totals ot
  ON ot.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY avg_order_value DESC;

\echo 'E47: Customers with more than 1 order (change threshold as needed)'
SELECT
  c.customer_id,
  c.full_name,
  COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

\echo 'E48: Products with total quantity sold > 2 (change threshold as needed)'
SELECT
  p.product_id,
  p.product_name,
  COALESCE(SUM(oi.quantity), 0) AS total_qty_sold
FROM products p
LEFT JOIN order_items oi
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING COALESCE(SUM(oi.quantity), 0) > 2
ORDER BY total_qty_sold DESC;

\echo 'E49: Top 3 products by revenue (qty * unit_price)'
SELECT
  p.product_id,
  p.product_name,
  SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
  ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 3;

\echo 'E50: Revenue share by product (product revenue / total revenue)'
WITH product_revenue AS (
  SELECT
    p.product_id,
    p.product_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS revenue
  FROM products p
  LEFT JOIN order_items oi
    ON oi.product_id = p.product_id
  GROUP BY p.product_id, p.product_name
),
total_revenue AS (
  SELECT SUM(revenue) AS total_rev
  FROM product_revenue
)
SELECT
  pr.product_id,
  pr.product_name,
  pr.revenue,
  CASE
    WHEN tr.total_rev = 0 THEN 0
    ELSE (pr.revenue / tr.total_rev)
  END AS revenue_share
FROM product_revenue pr
CROSS JOIN total_revenue tr
ORDER BY pr.revenue DESC, pr.product_id;
