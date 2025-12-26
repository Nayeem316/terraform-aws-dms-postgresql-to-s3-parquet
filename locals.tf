data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Pick first 2 AZs for the region
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

  common_tags = {
    Project     = var.name_prefix
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  # Single source of truth for the DMS target bucket name
  dms_bucket_name = "dms-hr-parquet-${data.aws_caller_identity.current.account_id}-${var.environment}"
}
