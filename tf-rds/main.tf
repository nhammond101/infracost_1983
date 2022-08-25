locals {
  engine               = "postgres"
  engine_version       = "14.2"
  family               = "postgres14"
  major_engine_version = "14"
  port                 = 5432
}

module "primary" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.3"

  identifier = "primary"

  engine         = local.engine
  engine_version = local.engine_version
  family         = local.family
  instance_class = "db.t4g.small"

  allocated_storage = 10

  db_name  = "test"
  username = "test"
  port     = local.port

  multi_az               = true
#  db_subnet_group_name   = aws_db_subnet_group.db.name
#  vpc_security_group_ids = [aws_security_group.database.id]

#  maintenance_window              = "Mon:00:00-Mon:03:00"
#  backup_window                   = "03:00-06:00"
#  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
#  monitoring_interval    = "30"
#  monitoring_role_name   = "${var.name_prefix}-monitoring-role"
#  create_monitoring_role = true

  # Backups are required in order to create a replica
  backup_retention_period = 30
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
#  kms_key_id              = var.kms_key_id_storage

  performance_insights_enabled          = false
#  performance_insights_kms_key_id       = var.kms_key_id_logs
#  performance_insights_retention_period = 7
}

module "replica" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.3"

  identifier = "replica"

  replicate_source_db    = module.primary.db_instance_id
  create_random_password = false

  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = "db.t4g.small"

  allocated_storage = 10

  port = local.port

  multi_az               = false
#  vpc_security_group_ids = [aws_security_group.database.id]

#  maintenance_window              = "Tue:00:00-Tue:03:00"
#  backup_window                   = "03:00-06:00"
#  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

#  backup_retention_period = 0
#  skip_final_snapshot     = true
#  deletion_protection     = false
#  storage_encrypted       = true
#  kms_key_id              = var.kms_key_id_storage

  performance_insights_enabled          = false
#  performance_insights_kms_key_id       = var.kms_key_id_logs
#  performance_insights_retention_period = 7
}