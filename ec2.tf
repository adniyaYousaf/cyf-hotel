
# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnets in that VPC (usually one per AZ)
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
    cidr_blocks = ["0.0.0.0/0"] # You may want to restrict this more tightly to your subnet CIDR or security group
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

# Import your existing public key or create a new one
resource "aws_key_pair" "docker_cicd" {
  key_name   = "docker-cicd-1"
  public_key = file(".ssh/docker-cicd-key.pub")
}


# Launch EC2 instance in the default subnet (first subnet found)
resource "aws_instance" "backend_server" {
  ami                    = "ami-0c1ac8a41498c1a9c" # Adjust as needed for your region
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
