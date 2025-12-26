variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "hr_admin" # Can override per environment
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "public_db_allowed_cidr" {
  description = "Public IPv4 CIDR allowed to access the RDS instance (e.g., your workstation IP/32)"
  type        = string
}

variable "dms_subnet_ids" {
  description = "Subnet IDs for DMS replication instance"
  type        = list(string)
}

variable "dms_password" {
  description = "Password for the DMS user"
  type        = string
  sensitive   = true
}