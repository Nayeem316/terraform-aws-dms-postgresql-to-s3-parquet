resource "aws_db_parameter_group" "hr_dms" {
  name        = "hr-postgres17-dms-pg"
  family      = "postgres17"
  description = "Parameter group for PostgreSQL 17 DMS logical replication"

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  # Headroom for DMS tasks
  parameter {
    name         = "max_replication_slots"
    value        = "10"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_wal_senders"
    value        = "10"
    apply_method = "pending-reboot"
  }

  tags = merge(local.common_tags, { Name = "hr-postgres17-dms-pg" })
}
