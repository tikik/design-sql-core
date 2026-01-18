-- =========================================
-- 03_seed_data.sql
-- Sample data for testing & demos
-- =========================================

INSERT INTO customers (full_name, email) VALUES
  ('Alice Nguyen', 'alice@example.com'),
  ('Bob Tran', 'bob@example.com'),
  ('Chris Pham', 'chris@example.com');

INSERT INTO products (product_name, price, active) VALUES
  ('Notebook', 4.99, TRUE),
  ('Pen', 1.50, TRUE),
  ('Backpack', 39.99, TRUE),
  ('Water Bottle', 12.00, TRUE),
  ('Old Item', 19.99, FALSE);

INSERT INTO orders (customer_id, status) VALUES
  (1, 'open'),
  (2, 'completed'),
  (3, 'open');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 2, 4.99),
  (1, 2, 3, 1.50),
  (2, 3, 1, 39.99);
