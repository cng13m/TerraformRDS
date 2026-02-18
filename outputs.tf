output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID (bastion)"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID (RDS)"
  value       = module.network.private_subnet_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by RDS subnet group"
  value       = module.network.private_subnet_ids
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.bastion.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds.port
}

output "rds_master_secret_arn" {
  description = "Secrets Manager ARN for RDS master password"
  value       = module.rds.master_user_secret_arn
}
