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
GRANT rds_superuser TO dms_user;  

-- =========================
-- 2. Create HR schema
-- =========================
CREATE SCHEMA IF NOT EXISTS hr;


CREATE TABLE hr.departments (
    dept_id      BIGSERIAL PRIMARY KEY,
    dept_name    VARCHAR(100) NOT NULL,
    location     VARCHAR(100),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional: enforce unique department names (good practice)
CREATE UNIQUE INDEX ux_departments_dept_name ON hr.departments (dept_name);

-- 4) Create employees table
CREATE TABLE hr.employees (
    emp_id       BIGSERIAL PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(150) UNIQUE,
    dept_id      BIGINT       NOT NULL,
    salary       NUMERIC(10,2),
    hire_date    DATE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_employees_department
        FOREIGN KEY (dept_id)
        REFERENCES hr.departments (dept_id)
        ON DELETE RESTRICT
);

-- Recommended index for join/filter performance
CREATE INDEX idx_employees_dept_id ON hr.employees (dept_id);

-- ============================================================
-- 5) Insert test data
-- ============================================================

-- Departments
INSERT INTO hr.departments (dept_name, location) VALUES
  ('Engineering', 'Detroit'),
  ('Finance',     'Chicago'),
  ('HR',          'Detroit'),
  ('Sales',       'New York'),
  ('IT Support',  'Columbus');

-- Employees
-- (dept_id values are generated; we fetch them by dept_name)
INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Aisha', 'Khan', 'aisha.khan@example.com', d.dept_id, 125000.00, '2022-03-14'
FROM hr.departments d WHERE d.dept_name = 'Engineering';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Noah', 'Patel', 'noah.patel@example.com', d.dept_id, 98000.00, '2021-11-01'
FROM hr.departments d WHERE d.dept_name = 'Engineering';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Mia', 'Johnson', 'mia.johnson@example.com', d.dept_id, 86000.00, '2020-06-22'
FROM hr.departments d WHERE d.dept_name = 'Finance';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Ethan', 'Lee', 'ethan.lee@example.com', d.dept_id, 74000.00, '2023-01-09'
FROM hr.departments d WHERE d.dept_name = 'HR';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Sophia', 'Garcia', 'sophia.garcia@example.com', d.dept_id, 110000.00, '2019-09-30'
FROM hr.departments d WHERE d.dept_name = 'Sales';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Liam', 'Brown', 'liam.brown@example.com', d.dept_id, 72000.00, '2024-05-13'
FROM hr.departments d WHERE d.dept_name = 'IT Support';

-- A couple more employees per dept for better test coverage
INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Olivia', 'Davis', 'olivia.davis@example.com', d.dept_id, 102000.00, '2022-08-08'
FROM hr.departments d WHERE d.dept_name = 'Finance';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Lucas', 'Wilson', 'lucas.wilson@example.com', d.dept_id, 69000.00, '2023-10-02'
FROM hr.departments d WHERE d.dept_name = 'HR';

INSERT INTO hr.employees (first_name, last_name, email, dept_id, salary, hire_date)
SELECT 'Emma', 'Martinez', 'emma.martinez@example.com', d.dept_id, 95000.00, '2021-02-17'
FROM hr.departments d WHERE d.dept_name = 'Sales';

-- ============================================================
-- 6) Quick sanity checks (optional output)
-- ============================================================

-- Show departments
-- SELECT * FROM hr.departments ORDER BY dept_id;

-- Show employees with dept name
-- SELECT e.emp_id, e.first_name, e.last_name, e.email, d.dept_name, e.salary, e.hire_date
-- FROM hr.employees e
-- JOIN hr.departments d ON d.dept_id = e.dept_id
-- ORDER BY e.emp_id;

COMMIT;

-- ============================================================
-- Notes for AWS DMS (Full Load + CDC):
-- - PKs are present (dept_id, emp_id) -> CDC friendly
-- - Avoid dropping/recreating tables while task runs
-- - After schema change, reload tables in DMS and start-replication
-- ============================================================

-- Allow schema access
GRANT USAGE ON SCHEMA hr TO dms_user;

-- Allow reading all existing tables in the schema
GRANT SELECT ON ALL TABLES IN SCHEMA hr TO dms_user;

-- Ensure future tables are readable too
ALTER DEFAULT PRIVILEGES IN SCHEMA hr
GRANT SELECT ON TABLES TO dms_user;
-- --- IGNORE -------------------------
-- DROP SCHEMA hr CASCADE;
-- DROP USER dms_user;
-- ------------------------------------   