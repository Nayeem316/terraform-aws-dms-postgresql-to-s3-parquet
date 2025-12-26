resource "aws_dms_replication_task" "hr_pg_to_s3_parquet" {
  replication_task_id = "hr-pg-to-s3-parquet"
  migration_type      = "full-load-and-cdc"

  replication_instance_arn = aws_dms_replication_instance.ri.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.src_pg.endpoint_arn
  target_endpoint_arn      = aws_dms_s3_endpoint.tgt_s3.endpoint_arn

  table_mappings = jsonencode({
    rules = [
      {
        "rule-type" : "selection",
        "rule-id" : "1",
        "rule-name" : "include-hr-schema",
        "object-locator" : {
          "schema-name" : "hr",
          "table-name" : "%"
        },
        "rule-action" : "include"
      }
    ]
  })

  replication_task_settings = jsonencode({
    Logging          = { EnableLogging = true },
    FullLoadSettings = { MaxFullLoadSubTasks = 8 }
  })
}
