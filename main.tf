locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "network" {
  source = "./modules/network"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
  admin_cidr            = var.admin_cidr
  enable_nat_gateway    = var.enable_nat_gateway
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  admin_cidr   = var.admin_cidr
  db_port      = var.db_port
}

module "bastion" {
  source = "./modules/bastion"

  project_name        = var.project_name
  environment         = var.environment
  subnet_id           = module.network.public_subnet_id
  vpc_id              = module.network.vpc_id
  bastion_sg_id       = module.security.bastion_sg_id
  instance_type       = var.bastion_instance_type
  key_name            = var.bastion_key_name
  root_volume_size_gb = var.bastion_root_volume_size_gb
}

module "rds" {
  source = "./modules/rds"

  project_name              = var.project_name
  environment               = var.environment
  private_subnet_ids        = module.network.private_subnet_ids
  rds_sg_id                 = module.security.rds_sg_id
  db_name                   = var.db_name
  db_username               = var.db_username
  db_port                   = var.db_port
  db_instance_class         = var.db_instance_class
  db_allocated_storage      = var.db_allocated_storage
  db_max_allocated_storage  = var.db_max_allocated_storage
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  publicly_accessible       = false
  multi_az                  = false
}
