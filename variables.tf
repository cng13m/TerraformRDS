variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "secure-rds"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "availability_zone" {
  description = "Availability zone for public and private subnet"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone for private subnet 2 (RDS subnet group requirement)"
  type        = string
  default     = "us-east-1b"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for second private subnet"
  type        = string
  default     = "10.20.3.0/24"
}

variable "admin_cidr" {
  description = "My public IP CIDR (required for SSH to bastion)"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for private subnet outbound internet"
  type        = bool
  default     = false
}

variable "bastion_key_name" {
  description = "Existing EC2 key pair name for bastion SSH access"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "bastion_root_volume_size_gb" {
  description = "Bastion root EBS volume size in GB"
  type        = number
  default     = 8
}

variable "db_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "dbadmin"
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial storage for RDS in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaling storage for RDS in GB"
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Number of days to retain RDS backups"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on destroy"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Optional final snapshot identifier when skip_final_snapshot is false. If unset, a default value based on project/environment is used."
  type        = string
  default     = null
}
