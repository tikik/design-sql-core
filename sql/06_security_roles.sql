-- Create roles idempotently
DO $$ 
BEGIN
  CREATE ROLE app_read;
EXCEPTION WHEN duplicate_object THEN
  RAISE NOTICE 'Role app_read already exists. Skipping.';
END $$;

DO $$ 
BEGIN
  CREATE ROLE app_write;
EXCEPTION WHEN duplicate_object THEN
  RAISE NOTICE 'Role app_write already exists. Skipping.';
END $$;

-- Grant schema usage
GRANT USAGE ON SCHEMA public TO app_read, app_write;

-- Grant table-level permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;
GRANT INSERT, UPDATE, DELETE ON orders, order_items TO app_write;  -- add DELETE if needed

-- Grant sequence access (critical for INSERTs with SERIAL/IDENTITY)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_write;

-- Optional: Auto-grant future tables to roles (PostgreSQL 15+)
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO app_read;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT INSERT, UPDATE ON TABLES TO app_write;
