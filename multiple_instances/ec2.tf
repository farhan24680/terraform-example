# key pair login
resource "aws_key_pair" "key" {
  key_name   = var.aws_key_pair_name
   public_key = file(var.aws_key_public_key_file)
}

# Get your public IP
data "http" "my_ip" {
  url = "https://api.ipify.org"
}

# vpc & security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "automate_sg"
  description = "This is a TF security group for testing"
  vpc_id      = aws_default_vpc.default.id #interpolation
  
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
    Name = "automate_sgs"
  }
}

# ec2 instance
resource "aws_instance" "my_instance" {
    count                        = var.aws_instance_count
    key_name                    = aws_key_pair.key.key_name
    security_groups             = [aws_security_group.my_security_group.name]
    instance_type               = var.aws_instance_type
    ami                         = var.aws_ami
    associate_public_ip_address = true
    root_block_device {
        volume_size = var.aws_root_volume_size
        volume_type = "gp3"
    }
    tags = {
        Name = "automate-${count.index}"
    }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("terraform-key.pem")
    host        = self.public_ip
  }

}