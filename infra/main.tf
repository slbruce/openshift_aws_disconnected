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

data "terraform_remote_state" "shared" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}
