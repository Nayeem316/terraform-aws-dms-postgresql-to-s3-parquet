variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-2"
}

variable "environment" {
  type        = string
  description = "Environment label (dev/test/prod)"
  default     = "dev"
}

variable "name_prefix" {
  type        = string
  description = "Prefix used in resource names"
  default     = "pg-dms-s3"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "hr_admin"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "enable_public_rds" {
  type        = bool
  description = "If true, RDS may be publicly accessible (demo only; not recommended)."
  default     = false
}

variable "enable_public_dms" {
  type        = bool
  description = "If true, DMS replication instance may be publicly accessible (demo only; not recommended)."
  default     = false
}

variable "public_db_allowed_cidr" {
  description = "Optional public IPv4 CIDR allowed to access PostgreSQL (e.g., your workstation IP/32). Used only when enable_public_rds=true."
  type        = string
  default     = null
}

# Kept for backwards compatibility with your original repo.
# If not set, DMS will default to private subnets created by this repo.
variable "dms_subnet_ids" {
  description = "Optional subnet IDs for DMS replication instance. If null, uses this repo's private subnets."
  type        = list(string)
  default     = null
}

variable "dms_password" {
  description = "Password for the DMS user"
  type        = string
  sensitive   = true
}
