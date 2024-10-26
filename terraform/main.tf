provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Amazon Linux 2 AMI filter
  }
}

# Define the key pair (use your public key)
resource "aws_key_pair" "my_key" {
  key_name   = "my_aws_key"
  public_key = file("assgn2.pub")
}

#Create ECR Repo
resource "aws_ecr_repository" "webapp_repo" {
  name = "my-ecr-repo"
}

# Create an EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.medium"  # You can change the instance type as needed

  key_name      = aws_key_pair.my_key.key_name

  # Security group open for all traffic
  vpc_security_group_ids = [aws_security_group.open_all.id]
  iam_instance_profile = "LabInstanceProfile"

  tags = {
    Name = "MyEC2Instance"
  }
}

# Security group to allow all traffic
resource "aws_security_group" "open_all" {
  name        = "open_all"
  description = "Allow all inbound and outbound traffic"

  # Ingress rule (allows all inbound traffic)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IPv4 address
    ipv6_cidr_blocks = ["::/0"]  # Allow from any IPv6 address
  }

  # Egress rule (allows all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow to any IPv4 address
    ipv6_cidr_blocks = ["::/0"]  # Allow to any IPv6 address
  }
}


