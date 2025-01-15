terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
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

data "terraform_remote_state" "bastion_registry" {
  backend = "local"
  config = {
    path = "../bastion_registry/terraform.tfstate"
  }
}

provider "aws" {
  region = data.terraform_remote_state.shared.outputs.region
}