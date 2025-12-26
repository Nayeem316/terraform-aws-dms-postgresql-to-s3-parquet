output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint hostname"
  value       = aws_db_instance.hr.address
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.hr.port
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.hr.identifier
}

output "dms_replication_instance_id" {
  description = "DMS replication instance ID"
  value       = aws_dms_replication_instance.ri.replication_instance_id
}

output "dms_replication_instance_arn" {
  description = "DMS replication instance ARN"
  value       = aws_dms_replication_instance.ri.replication_instance_arn
}

output "dms_source_endpoint_arn" {
  description = "DMS source endpoint ARN"
  value       = aws_dms_endpoint.src_pg.endpoint_arn
}

output "dms_target_s3_endpoint_arn" {
  description = "DMS target S3 endpoint ARN"
  value       = aws_dms_s3_endpoint.tgt_s3.endpoint_arn
}

output "dms_replication_task_arn" {
  description = "DMS replication task ARN"
  value       = aws_dms_replication_task.hr_pg_to_s3_parquet.replication_task_arn
}

output "s3_bucket_name" {
  description = "S3 bucket receiving DMS Parquet output"
  value       = aws_s3_bucket.dms_bucket.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.dms_bucket.arn
}

output "dms_bucket_name_local" {
  description = "Bucket name from locals (single source of truth)"
  value       = local.dms_bucket_name
}
