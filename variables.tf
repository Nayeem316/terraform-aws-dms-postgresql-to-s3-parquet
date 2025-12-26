variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
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

variable "public_db_allowed_cidr" {
  description = "Optional IPv4 CIDR allowed to access PostgreSQL (e.g., your workstation IP/32). If null, no public ingress rule is created."
  type        = string
  default     = null
  nullable    = true
}

variable "dms_username" {
  description = "Database username used by DMS to read from PostgreSQL"
  type        = string
  default     = "dms_user"
}

variable "dms_password" {
  description = "Database password used by DMS to read from PostgreSQL"
  type        = string
  sensitive   = true
}
