resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier                   = "${var.project_name}-${var.environment}-postgres"
  engine                       = "postgres"
  instance_class               = var.db_instance_class
  allocated_storage            = var.db_allocated_storage
  max_allocated_storage        = var.db_max_allocated_storage
  storage_encrypted            = true
  db_name                      = var.db_name
  username                     = var.db_username
  manage_master_user_password  = true
  port                         = var.db_port
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = [var.rds_sg_id]
  backup_retention_period      = var.backup_retention_period
  deletion_protection          = var.deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot
  final_snapshot_identifier    = var.skip_final_snapshot ? null : coalesce(var.final_snapshot_identifier, "${var.project_name}-${var.environment}-final-snapshot")
  publicly_accessible          = var.publicly_accessible
  multi_az                     = var.multi_az
  auto_minor_version_upgrade   = true
  performance_insights_enabled = false
  copy_tags_to_snapshot        = true

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres"
  }
}
