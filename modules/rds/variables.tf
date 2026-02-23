variable "project_name" { type = string }
variable "environment" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "rds_sg_id" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_port" { type = number }
variable "db_instance_class" { type = string }
variable "db_allocated_storage" { type = number }
variable "db_max_allocated_storage" { type = number }
variable "backup_retention_period" { type = number }
variable "deletion_protection" { type = bool }
variable "skip_final_snapshot" { type = bool }
variable "final_snapshot_identifier" {
  type    = string
  default = null
}
variable "publicly_accessible" { type = bool }
variable "multi_az" { type = bool }
