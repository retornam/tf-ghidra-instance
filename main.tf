locals {
  inittemplate = templatefile("${path.module}/templates/init.sh.tpl", {
    docker_image_version = var.docker_image_version,
    ghidra_users         = var.ghidra_users
  })
}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"
    ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "tls_private_key" "keypem" {
  algorithm = "RSA"
  rsa_bits  = var.bits
}


resource "aws_key_pair" "key" {
  key_name   = "${var.name}-ssh-key"
  public_key = tls_private_key.keypem.public_key_openssh
}


resource "aws_security_group" "sg" {
  name        = "ghidra-node-access"
  description = "access to ghidra node"
  ingress {
    description = "allowlist 13100"
    from_port   = 13100
    to_port     = 13100
    protocol    = "tcp"
    cidr_blocks = var.access_list
  }
  ingress {
    description = "allowlist 13101"
    from_port   = 13101
    to_port     = 13101
    protocol    = "tcp"
    cidr_blocks = var.access_list
  }
  ingress {
    description = "allowlist 13102"
    from_port   = 13102
    to_port     = 13102
    protocol    = "tcp"
    cidr_blocks = var.access_list
  }
  ingress {
    description = "allowlist 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.access_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "ghidra" {

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  user_data                   = local.inittemplate
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name # your key here
  disable_api_termination     = var.prevent_destroy
  tags                        = var.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      vpc_security_group_ids,
      ami
    ]
  }

}

