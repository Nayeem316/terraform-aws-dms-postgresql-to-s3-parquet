output "aws_region" {
  value       = var.aws_region
  description = "AWS region"
}

output "vpc_id" {
  value       = aws_vpc.rds_hybrid_vpc.id
  description = "VPC id"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "Private subnet ids"
}

output "rds_endpoint" {
  value       = aws_db_instance.hr.address
  description = "RDS PostgreSQL endpoint address"
}

output "rds_port" {
  value       = aws_db_instance.hr.port
  description = "RDS PostgreSQL port"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.dms_bucket.bucket
  description = "S3 bucket receiving DMS output"
}

output "dms_replication_instance_arn" {
  value       = aws_dms_replication_instance.ri.replication_instance_arn
  description = "DMS replication instance ARN"
}

output "dms_task_arn" {
  value       = aws_dms_replication_task.hr_pg_to_s3_parquet.replication_task_arn
  description = "DMS replication task ARN"
}
