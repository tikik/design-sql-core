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

-- 4. List inactive products
