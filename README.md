# Secure RDS Deployment with Terraform

This project deploys a secure AWS environment for PostgreSQL on Amazon RDS with a bastion host for controlled access.

## Architecture

- 1 VPC (`10.20.0.0/16` by default)
- 1 public subnet for bastion EC2
- 2 private subnets for RDS subnet group (AWS requirement)
- Internet Gateway for public subnet
- Optional NAT Gateway for private subnet outbound traffic
- Security groups:
  - Bastion SG: SSH (`22`) only from `admin_cidr`
  - RDS SG: PostgreSQL (`5432`) only from bastion SG
- Network ACLs:
  - Public NACL allows SSH from `admin_cidr`
  - Private NACL allows PostgreSQL traffic from public subnet CIDR
- EC2 bastion with:
  - IMDSv2 required
  - Encrypted gp3 root volume
  - IAM role with `AmazonSSMManagedInstanceCore`
- RDS PostgreSQL with:
  - Private subnet placement
  - `publicly_accessible = false`
  - Encryption at rest enabled
  - Credentials managed in AWS Secrets Manager (`manage_master_user_password = true`)

## Project Structure

|-- main.tf
|-- provider.tf
|-- versions.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
|-- modules/
|   |-- network/
|   |-- security/
|   |-- bastion/
|   |-- rds/

## Prerequisites

- Terraform >= 1.6
- AWS CLI configured (`aws configure`)
- Existing EC2 key pair in your target region
- S3 bucket (manually created) for Terraform state, with versioning enabled

## 1) Configure Remote State (S3)

`versions.tf` contains `backend "s3" {}`. Initialize with backend config:

```bash
terraform init \
  -backend-config="bucket=<your-tfstate-bucket>" \
  -backend-config="key=secure-rds/dev/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true"
```

Recommended: Use DynamoDB state locking (optional, if configured in your account).

## 2) Configure Variables

1. Copy example file:
```bash
cp terraform.tfvars.example terraform.tfvars
```
PowerShell equivalent:
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```
2. Update at least:
- `admin_cidr` to your current public IP with `/32`
- `bastion_key_name` to an existing EC2 key pair name

## 3) Deploy

```bash
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

## 4) Access RDS Securely via Bastion

From local machine:

1. SSH into bastion:
```bash
ssh -i <path-to-private-key.pem> ec2-user@<bastion_public_ip>
```

2. From bastion, connect to PostgreSQL:
```bash
psql -h <rds_endpoint> -U <db_username> -d <db_name> -p 5432
```

Get the RDS master password from Secrets Manager:
- Use output `rds_master_secret_arn`
- Fetch secret value via AWS CLI or console.

## 5) Destroy

If `deletion_protection = true`, disable it first and apply:

```bash
terraform apply -var="deletion_protection=false"
```

Then destroy:

```bash
terraform destroy
```

Notes:
- If `skip_final_snapshot = false`, Terraform will provide `final_snapshot_identifier` automatically (or you can set one explicitly in `terraform.tfvars`).
- If you want to skip creating a final snapshot, use `-var="skip_final_snapshot=true"` during destroy.

## Security Practices Implemented

- Private RDS (no public endpoint exposure)
- DB ingress restricted to bastion security group only
- Bastion SSH restricted to a single admin CIDR
- IMDSv2 enforced on EC2
- Encrypted storage (EC2 root and RDS)
- RDS credentials not hardcoded; managed by AWS Secrets Manager
- Network segmentation through public/private subnet isolation
- Optional NAT to reduce unnecessary public egress path from private subnet

## Notes

- Free-tier oriented defaults are used where possible (`t3.micro`, `db.t3.micro`, minimal storage).
- AWS RDS subnet groups generally require subnets in at least two AZs for successful creation. This project uses two private subnets to satisfy that requirement while keeping RDS private.
