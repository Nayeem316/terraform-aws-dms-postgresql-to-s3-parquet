resource "aws_dms_replication_subnet_group" "dms" {
  replication_subnet_group_id          = "dms-subnet-group"
  replication_subnet_group_description = "DMS subnet group"
  subnet_ids                           = coalesce(var.dms_subnet_ids, aws_subnet.private[*].id)
}

resource "aws_dms_replication_instance" "ri" {
  replication_instance_id    = "hr-dms-ri"
  replication_instance_class = "dms.t3.medium"
  allocated_storage          = 50
  publicly_accessible        = var.enable_public_dms

  vpc_security_group_ids      = [aws_security_group.dms_sg.id]
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms.replication_subnet_group_id
}
