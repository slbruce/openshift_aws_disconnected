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

data "terraform_remote_state" "shared" {
  backend = "local"
  config = {
    path = "../../terraform.tfstate"
  }
}

resource "aws_instance" "bastion_instance" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_type
  associate_public_ip_address = true
  subnet_id                   = data.terraform_remote_state.infra.outputs.public_subnet_id
  key_name                    = var.bastion_key_name
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.bastion_sg_id]

  tags = {
    Name = "internet-bastion"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_volume_size
  }
}

output "bastion_instance_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}

resource "aws_instance" "registry_instance" {
  ami                         = var.registry_ami
  instance_type               = var.registry_type
  associate_public_ip_address = false
  subnet_id                   = data.terraform_remote_state.infra.outputs.private_subnet_1_id
  key_name                    = var.registry_key_name
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.registry_sg_id]
  private_ip = data.terraform_remote_state.shared.outputs.registry_ip

  tags = {
    Name = "registry-server"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.registry_volume_size
  }
}
