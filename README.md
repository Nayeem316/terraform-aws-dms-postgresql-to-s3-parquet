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
   git clone https://github.com/<your-username>/terraform-aws-dms-postgresql-to-s3-parquet.git
