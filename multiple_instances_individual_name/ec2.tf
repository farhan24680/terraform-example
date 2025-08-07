# Lookup latest Ubuntu 20.04 AMI from Canonical
data "aws_ami" "os_image" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Key pair for SSH login
resource "aws_key_pair" "deployer" {
  key_name   = "${var.env} terraform-key"
  public_key = file("terraform-key.pub")
}

# Get your public IP (for SSH access)
data "http" "my_ip" {
  url = "https://api.ipify.org"
}

resource "aws_default_vpc" "default" {

}

# Security Group
resource "aws_security_group" "allow_user_to_connect" {
  name        = "allow TLS"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 8000"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "my-sg-${var.env}"
    environment = var.env
  }
}

# EC2 Instances (micro and small)
resource "aws_instance" "my_instance" {
  for_each = {
    automate_micro = "t3.micro"
  }
  ami                         = data.aws_ami.os_image.id
  instance_type               = each.value
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.allow_user_to_connect.name]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.aws_root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
    environment = var.env
  }

}
