terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../../infra/terraform.tfstate"
  }
}

resource "aws_instance" "bastion_instance" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_type
  associate_public_ip_address = true
  subnet_id                   = data.terraform_remote_state.infra.outputs.public_subnet_id
  key_name                    = var.bastion_key_name
  vpc_security_group_ids             = [data.terraform_remote_state.infra.outputs.bastion_sg_id]

  tags = {
    Name = "internet-bastion"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_volume_size
  }
}

resource "aws_instance" "registry_instance" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_type
  associate_public_ip_address = true
  subnet_id                   = data.terraform_remote_state.infra.outputs.public_subnet_id
  key_name                    = var.bastion_key_name
  vpc_security_group_ids             = [data.terraform_remote_state.infra.outputs.bastion_sg_id]

  tags = {
    Name = "internet-bastion"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_volume_size
  }
}