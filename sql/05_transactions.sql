-- =========================================
-- 05_transactions.sql
-- Transaction demo: commit vs rollback (CS 240)
-- =========================================

\echo 'T1: SUCCESSFUL TRANSACTION (commit)'

BEGIN;

WITH new_order AS (
  INSERT INTO orders (customer_id, status)
  VALUES (1, 'open')
  RETURNING order_id
)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
  new_order.order_id,
  1,      -- valid product_id from seed data
  2,
  4.99
FROM new_order;

COMMIT;

\echo 'T1 CHECK: latest order + items (should exist)'
SELECT o.order_id, o.customer_id, o.status, o.created_at
FROM orders o
ORDER BY o.order_id DESC
LIMIT 1;

SELECT oi.order_id, oi.product_id, oi.quantity, oi.unit_price
FROM order_items oi
ORDER BY oi.order_item_id DESC
LIMIT 3;

\echo 'T2: FAILURE TRANSACTION (FK violation + rollback proof)'
\echo 'Expect an ERROR below (product_id 999 does not exist).'

-- Record counts BEFORE
\echo 'T2 BEFORE: counts'
SELECT COUNT(*) AS orders_before FROM orders;
SELECT COUNT(*) AS items_before  FROM order_items;

BEGIN;

WITH bad_order AS (
  INSERT INTO orders (customer_id, status)
  VALUES (1, 'open')
  RETURNING order_id
)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
  bad_order.order_id,
  999,    -- invalid product_id -> FK violation
  1,
  9.99
FROM bad_order;

-- If the INSERT fails, transaction is aborted.
-- We explicitly ROLLBACK to show intent.
ROLLBACK;

-- Record counts AFTER
\echo 'T2 AFTER: counts (should match BEFORE)'
SELECT COUNT(*) AS orders_after FROM orders;
SELECT COUNT(*) AS items_after  FROM order_items;