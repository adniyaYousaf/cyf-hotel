module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1" 

  name                 = "video"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_db_subnet_group" "video-subnet-group" {
  name       = "video"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "video subnet group"
  }
}

resource "aws_db_parameter_group" "video" {
  name   = "video"
  family = "postgres17"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "terraform-video-db" {
  allocated_storage      = 10
  db_name                = "video"
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.video-subnet-group.name
  parameter_group_name   = aws_db_parameter_group.video.name
  
  publicly_accessible    = true
  skip_final_snapshot    = true
}

