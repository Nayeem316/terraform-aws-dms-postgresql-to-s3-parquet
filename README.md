# Terraform: AWS DMS PostgreSQL to S3 (Parquet)

## Overview
This project demonstrates an end-to-end **data ingestion pipeline** using **Terraform** to provision **AWS DMS** for replicating data from a **PostgreSQL database** into **Amazon S3** in **Parquet format**.

The solution is designed to support **analytics and lakehouse architectures**, enabling downstream consumption by **Databricks, Athena, or Spark-based platforms**.

This repository is provided for **learning, reuse, and experimentation**.

---

## Architecture
PostgreSQL (Source)
   ↓
AWS DMS (Full Load + CDC)
   ↓
Amazon S3 (Parquet Files)
   ↓
Databricks / Spark / Athena

---

## Key Features
- Infrastructure fully provisioned using **Terraform**
- AWS DMS Full Load + Change Data Capture (CDC)
- Parquet output format optimized for analytics
- Modular and reusable Terraform code
- GitHub-based version control and collaboration

---

## Technologies Used
- **Terraform**
- **AWS DMS**
- **Amazon S3**
- **PostgreSQL**
- **Parquet**
- **GitHub**

---

## Prerequisites
- AWS Account
- Terraform >= 1.3
- PostgreSQL source database
- IAM permissions for DMS, S3, VPC, IAM roles

---

## Terraform Resources Created
- DMS Replication Instance
- Source Endpoint (PostgreSQL)
- Target Endpoint (Amazon S3 – Parquet)
- Replication Task (Full Load + CDC)
- IAM Roles and Policies
- S3 Bucket and Bucket Policies
- Networking (Security Groups, Subnets)

---

## Usage
1. Clone the repository:
   ```bash
 
 git clone    https://github.com/Nayeem316/terraform-aws-dms-postgresql-to-s3-parquet.git

 Use Cases

Data lake ingestion

Lakehouse architectures

Analytics modernization

Database migration and replication

Databricks ingestion pipelines

Notes

This project is intended for educational purposes

Security hardening (encryption, KMS, private endpoints) can be added as enhancements

Author

Maintained by a Senior Cloud DBA / Data Platform Engineer with expertise in
AWS, Terraform, Databricks, and large-scale data migrations.


# Terraform: RDS PostgreSQL → AWS DMS → S3 (Parquet)

This repository provisions an AWS-based demo pipeline that replicates data from an **Amazon RDS PostgreSQL** database into **Amazon S3** using **AWS Database Migration Service (DMS)**, writing data as **Parquet** files.

> Intended as a learning / reference project for Terraform + AWS DMS patterns.

---

## Architecture

- **VPC** with:
  - 2 public subnets (across 2 AZs)
  - 2 private subnets (across 2 AZs)
  - Internet Gateway (public routing)
  - NAT Gateways (private egress)
- **RDS PostgreSQL** (Multi-AZ, encrypted)
  - Parameter group enables logical replication for DMS
- **AWS DMS**
  - Replication subnet group
  - Replication instance
  - Source endpoint: PostgreSQL
  - Target endpoint: S3 (Parquet + GZIP)
  - Replication task: **full-load-and-cdc**
- **S3 bucket** for DMS output
  - Versioning enabled
  - Public access blocked
- **IAM role/policy** allowing DMS to write objects to the S3 bucket

---

## Prerequisites

- Terraform installed (v1.5+ recommended)
- AWS account + credentials configured locally (AWS CLI, SSO, or environment variables)
- Permissions to create:
  - VPC/Subnets/IGW/NAT
  - RDS instances + parameter groups
  - DMS replication instances/endpoints/tasks
  - S3 buckets
  - IAM roles/policies

---

## Important: secrets + tfvars

Do **NOT** commit real secrets into Git.

This repo expects you to provide values for sensitive variables (`db_password`, `dms_password`) via one of these approaches:

- `terraform.tfvars` (local only, gitignored)
- `TF_VAR_db_password` and `TF_VAR_dms_password` environment variables
- A secrets manager integration (recommended for production)

---

## Quick Start

### 1) Clone and initialize

```bash
terraform init

