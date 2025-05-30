data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create a Security Group in the default VPC
resource "aws_security_group" "default_vpc_sg" {
  name        = "default-vpc-ec2-sg"
  description = "Allow SSH, HTTP, and DB access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Postgres DB"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

 ingress {
    description = "grafana"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

   ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
    ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # or restrict to Prometheus IP
  }

  ingress {
    description = "cAdvisor"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Postgres Exporter"
    from_port   = 9187
    to_port     = 9187
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-vpc-ec2-sg"
  }
}

resource "aws_key_pair" "docker_cicd" {
  key_name   = "docker-cicd-1"
  public_key = file(".ssh/docker-cicd-key.pub")
}


data "aws_security_group" "rds_sg" {
  id = "sg-08a97375cfa69b048"  
}


resource "aws_security_group_rule" "allow_ec2_to_rds_postgres" {
  type                     = "ingress"
  from_port               = 5432
  to_port                 = 5432
  protocol                = "tcp"
  security_group_id       = data.aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.default_vpc_sg.id
  description             = "Allow EC2 access to RDS PostgreSQL"
}

resource "aws_instance" "backend_server" {
  ami                    = "ami-0c1ac8a41498c1a9c" 
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default_vpc_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.default_vpc_sg.id]
  key_name               = aws_key_pair.docker_cicd.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "terraform-full-stack-app"
  }
  user_data = file("${path.module}/script.sh")
}

