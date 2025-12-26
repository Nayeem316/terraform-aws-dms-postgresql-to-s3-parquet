# Terraform: RDS PostgreSQL → AWS DMS → S3 (Parquet)

This repo is a **public, generic** Terraform example that provisions an AWS pipeline to replicate data from **Amazon RDS for PostgreSQL** to **Amazon S3** using **AWS Database Migration Service (DMS)**, writing output as **Parquet**.

Default posture is **private-by-default** (recommended):
- RDS is deployed in **private subnets** and is **not publicly accessible**
- DMS replication instance is deployed in **private subnets** and is **not publicly accessible**
- Optional public access can be enabled via variables (for demos only)

---

## Architecture (high level)

- VPC (2 AZs)
  - Public subnets (for NAT gateways / public routing)
  - Private subnets (for RDS + DMS)
  - Internet Gateway + NAT Gateway(s)
- RDS PostgreSQL (encrypted, Multi-AZ optional)
- AWS DMS
  - Replication subnet group (private subnets)
  - Replication instance
  - Source endpoint: PostgreSQL
  - Target endpoint: S3 (Parquet)
  - Replication task: full load + CDC
- S3 bucket (versioning + public access blocked)
- IAM role/policy for DMS → S3 writes

---

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured locally (AWS CLI / SSO / environment variables)
- Permissions to create: VPC, RDS, DMS, S3, IAM resources

---

## Repo hygiene (important)

Do **not** commit secrets.

- Use `terraform.tfvars` locally (gitignored) OR environment variables:
  - `TF_VAR_db_password`
  - `TF_VAR_dms_password`

This repo includes `terraform.tfvars.example` to get you started.

---

## Quick start

```bash
terraform init
terraform plan
terraform apply
```

### Create your local tfvars

Copy and edit the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then set values (especially passwords and your environment).

---

## Post-deploy: database setup required

Terraform provisions the RDS instance, but you must ensure:
- The source schema/tables exist (example schema: `hr`)
- The DMS user exists and has the correct permissions

Example SQL (adjust to your needs):

```sql
CREATE USER dms_user WITH PASSWORD '...';
GRANT rds_replication TO dms_user;

CREATE SCHEMA IF NOT EXISTS hr;

GRANT USAGE ON SCHEMA hr TO dms_user;
GRANT SELECT ON ALL TABLES IN SCHEMA hr TO dms_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA hr GRANT SELECT ON TABLES TO dms_user;
```

---

## Validate

1. Check the Terraform outputs for:
   - RDS endpoint
   - S3 bucket name
   - DMS task/instance identifiers (if output)
2. Insert/update rows in PostgreSQL
3. Verify Parquet files appear in the S3 bucket

---

## Cleanup

```bash
terraform destroy
```

Note: If your RDS configuration requires a final snapshot, destroy may take longer and/or require snapshot settings.

---

## Notes for public repos

- Keep `terraform.tfvars` out of Git (use `.gitignore`)
- Avoid storing credentials in Terraform state for real production usage
- For production: prefer Secrets Manager / SSM, least-privilege IAM, and private networking
