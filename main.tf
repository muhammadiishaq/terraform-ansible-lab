terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
  }
}

provider "aws" {
  region = "us-west-1"  # Confirmed to be the correct region
}

resource "aws_security_group" "lab_sg" {
  name        = "lab-security-group"
  description = "Allow SSH and Ansible access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-lab-sg"
  }
}

resource "aws_instance" "lab_instance" {
  count         = 2
  ami           = "custom-ami-id" 
  instance_type = "t2.micro"
  key_name      = "keypair-name" # Verified key pair
  vpc_security_group_ids = [aws_security_group.lab_sg.id]

  tags = {
    Name = "ansible-lab-instance-${count.index}"
  }

  # Wait for SSH to be available
  provisioner "remote-exec" {
    inline = ["echo 'SSH connection established'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa") # Path to your private key
      host        = self.public_ip
    }
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/hosts.ini"
  content = templatefile("inventory.tmpl", {
    instances = aws_instance.lab_instance[*]
    ssh_user  = "ubuntu" # Default user for Ubuntu AMI
    ssh_key   = "~/.ssh/id_rsa" # Path to your private key
  })
}

output "instance_ips" {
  value = aws_instance.lab_instance[*].public_ip
}
