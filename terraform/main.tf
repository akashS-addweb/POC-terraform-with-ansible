resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  security_groups = [aws_security_group.node_app_sg.name]

  
  tags = {
    Name = "Terraform-NodeJS-App"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = file("${path.module}/../ssh/<enter_your_key_name>.pub")
}

resource "null_resource" "run_playbook" {
  depends_on = [aws_instance.web_server]

  triggers = {
    instance_id = aws_instance.web_server.id
  }

  provisioner "local-exec" {
    command = <<EOT
      echo '[ec2_instance]' > ../ansible/inventory
      echo "${aws_instance.web_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../ssh/<enter_your_key_name>" >> ../ansible/inventory
      echo "Running Ansible playbook..."
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory ../ansible/main.yml
    EOT
  }
}

resource "aws_security_group" "node_app_sg" {
  name        = "node-app-sg"
  description = "Security group for Node.js application"

  ingress {
    description      = "Allow HTTP traffic on port 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow SSH traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Allow HTTP traffic on port 3000"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP traffic on port 3000"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
