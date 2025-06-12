provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "lab_sg" {
  name        = "lab-security-group"
  description = "Allow SSH, HTTP, and Ansible access"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Open to all (for lab only)
  }

  # HTTP Access (For Nginx)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows worldwide HTTP access
  }

  # Outbound traffic (Allow all)
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
  ami           = "ami-077c1137cbc2cd941"  # Ubuntu in us-west-1
  instance_type = "t2.micro"
  key_name      = "terraform-ansible-lab"
  vpc_security_group_ids = [aws_security_group.lab_sg.id]  # Attaches security group

  tags = {
    Name = "ansible-lab-instance-${count.index}"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/hosts.ini"
  content = templatefile("inventory.tmpl", {
    instances = aws_instance.lab_instance[*]
    ssh_user  = "ubuntu"
    ssh_key   = "~/.ssh/your-private-key"
  })
}

output "instance_ips" {
  value = aws_instance.lab_instance[*].public_ip
}
