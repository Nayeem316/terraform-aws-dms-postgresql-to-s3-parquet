resource "aws_dms_endpoint" "src_pg" {
  endpoint_id   = "hr-src-pg"
  endpoint_type = "source"
  engine_name   = "postgres"

  server_name   = aws_db_instance.hr.address
  port          = 5432
  database_name = "postgres"

  username = var.dms_username
  password = var.dms_password
  ssl_mode = "require"
}

resource "aws_dms_s3_endpoint" "tgt_s3" {
  endpoint_id   = "hr-tgt-s3"
  endpoint_type = "target"

  bucket_name             = aws_s3_bucket.dms_bucket.bucket
  bucket_folder           = "hr/"
  service_access_role_arn = aws_iam_role.dms_s3_role.arn

  data_format      = "parquet"
  compression_type = "GZIP"
}
