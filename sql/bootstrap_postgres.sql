/*
  Bootstrap script for AWS DMS demo
  ---------------------------------
  - Creates dms_user
  - Creates hr schema
  - Creates dept and emp tables
  - Grants required privileges for DMS
  - Optionally inserts sample data

  IMPORTANT:
  - Do NOT commit real passwords to Git.
  - Replace 'REPLACE_ME' at execution time, OR run an ALTER USER afterward.
*/

-- =========================
-- 1. Create DMS user
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM pg_catalog.pg_roles WHERE rolname = 'dms_user'
  ) THEN
    CREATE USER dms_user WITH PASSWORD 'REPLACE_ME';
  END IF;
END
$$;

-- Required for logical replication on Amazon RDS for PostgreSQL
GRANT rds_replication TO dms_user;

-- =========================
-- 2. Create HR schema
-- =========================
CREATE SCHEMA IF NOT EXISTS hr;

-- =========================
-- 3. Create DEPT table
-- =========================
CREATE TABLE IF NOT EXISTS hr.dept (
  dept_id     SERIAL PRIMARY KEY,
  dept_name   VARCHAR(100) NOT NULL,
  location    VARCHAR(100),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 4. Create EMP table
-- =========================
CREATE TABLE IF NOT EXISTS hr.emp (
  emp_id      SERIAL PRIMARY KEY,
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  email       VARCHAR(120) UNIQUE,
  salary      NUMERIC(10,2),
  dept_id     INT REFERENCES hr.dept(dept_id),
  hired_date  DATE DEFAULT CURRENT_DATE,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- 5. Grant privileges to DMS
-- =========================
GRANT USAGE ON SCHEMA hr TO dms_user;
GRANT SELECT ON ALL TABLES IN SCHEMA hr TO dms_user;

-- Ensure future tables in hr schema are accessible to dms_user
ALTER DEFAULT PRIVILEGES IN SCHEMA hr
GRANT SELECT ON TABLES TO dms_user;

-- =========================
-- 6. Optional seed data
-- =========================
INSERT INTO hr.dept (dept_name, location)
VALUES
  ('Engineering', 'New York'),
  ('HR', 'Chicago'),
  ('Finance', 'San Francisco')
ON CONFLICT DO NOTHING;

INSERT INTO hr.emp (first_name, last_name, email, salary, dept_id)
VALUES
  ('John', 'Doe', 'john.doe@example.com', 90000, 1),
  ('Jane', 'Smith', 'jane.smith@example.com', 95000, 1),
  ('Mike', 'Brown', 'mike.brown@example.com', 80000, 2)
ON CONFLICT DO NOTHING;
