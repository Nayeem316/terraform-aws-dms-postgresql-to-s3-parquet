# Terraform: RDS PostgreSQL → AWS DMS → S3 (Parquet)

This repository provisions an AWS demo pipeline that replicates data from **Amazon RDS for PostgreSQL** into **Amazon S3** using **AWS Database Migration Service (DMS)**, writing data as **Parquet** files.

It is designed for a **public GitHub repo**:
- no environment-specific names
- no plaintext secrets committed
- safer-by-default networking (private subnets)

---

## What it deploys

- **VPC** with 2 AZs
  - Public subnets (for NAT gateways)
  - Private subnets (for RDS + DMS)
  - Internet Gateway, route tables, and NAT Gateways
- **RDS PostgreSQL** (Multi-AZ, encrypted)
  - Parameter group enables logical replication for DMS
- **AWS DMS**
  - Replication subnet group
  - Replication instance (private)
  - Source endpoint: PostgreSQL
  - Target endpoint: S3 (Parquet + GZIP)
  - Replication task: `full-load-and-cdc`
- **S3 bucket** for DMS output (versioning + public access blocked)
- **IAM role/policy** allowing DMS to write to the S3 bucket

---

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured (AWS CLI / SSO / environment variables)
- Permissions to create VPC, RDS, DMS, S3, IAM resources

---

## Repository safety (secrets)

**Never commit real secrets**.

Use one of these patterns:
- local-only `terraform.tfvars` (gitignored)
- environment variables:
  - `TF_VAR_db_password`
  - `TF_VAR_dms_password`

A sample file is provided: `terraform.tfvars.example`.

---

## Quick start

### 1) Initialize

```bash
terraform init
```

### 2) Create your tfvars (local only)

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your real values
```

### 3) Plan & apply

```bash
terraform plan
terraform apply
```

---

## Post-deploy: database setup required (DMS user + permissions)

Terraform provisions the database and DMS infrastructure, but it **does not create the DMS user inside Postgres**.
Create the DMS user and grant permissions.

Example (adjust to your security posture):

```sql
-- Connect as the master user
CREATE USER dms_user WITH PASSWORD 'REPLACE_ME';

-- RDS managed role used for logical replication / CDC
GRANT rds_replication TO dms_user;

-- Example schema used by the DMS table mappings in this repo
CREATE SCHEMA IF NOT EXISTS hr;

-- Allow reading the schema/tables
GRANT USAGE ON SCHEMA hr TO dms_user;
GRANT SELECT ON ALL TABLES IN SCHEMA hr TO dms_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA hr GRANT SELECT ON TABLES TO dms_user;
```

> The DMS task in this repo includes schema `hr` and all tables (`%`). See `dms_task.tf`.

---

## How to validate

1. Insert or update rows in your `hr.*` tables.
2. Open the S3 bucket output (see Terraform output `s3_bucket_name`)
3. Look under the prefix `hr/` for Parquet files.

---

## Cleanup

```bash
terraform destroy
```

This repo sets `skip_final_snapshot = true` on the RDS instance so destroy is smoother for demos.

---

## Common troubleshooting

- **DMS task fails with logical replication / slot errors**
  - Confirm the RDS parameter group enables logical replication (see `rds_dms_parameters.tf`)
  - Ensure the DMS user has `rds_replication` and table read permissions
- **Can’t connect to Postgres from your laptop**
  - By default, RDS is in **private subnets**. You’ll need a bastion/SSM/VPN approach.
  - For a quick lab-only exception, set `public_db_allowed_cidr = "YOUR_IP/32"` (not recommended long-term).
- **No files appear in S3**
  - Check the DMS task status and CloudWatch logs
  - Confirm the DMS S3 IAM role is attached and has permissions

---

## Suggested next enhancements (PR ideas)

- Store secrets in AWS Secrets Manager and reference them from Terraform
- Add CloudWatch log group + DMS enhanced logging
- Add optional single-NAT mode to reduce demo cost
- Convert the repo into modules (network / rds / dms) for reusability
