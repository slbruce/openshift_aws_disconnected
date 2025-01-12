data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "s3_instance_role" {
  name               = "s3_instance_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "s3_instance_profile" {
  name = "s3_instance_profile"
  role = aws_iam_role.s3_instance_role.name
}

resource "aws_instance" "bastion_instance" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_type
  subnet_id              = data.terraform_remote_state.infra.outputs.private_subnet_2_id
  vpc_security_group_ids = [data.terraform_remote_state.infra.outputs.bastion_sg_id]
  key_name               = var.bastion_key_name
  iam_instance_profile   = aws_iam_instance_profile.s3_instance_profile.id

  tags = {
    Name = "bastion"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_volume_size
  }
}

resource "aws_instance" "registry_instance" {
  ami                         = var.registry_ami
  instance_type               = var.registry_type
  associate_public_ip_address = false
  subnet_id                   = data.terraform_remote_state.infra.outputs.private_subnet_1_id
  vpc_security_group_ids      = [data.terraform_remote_state.infra.outputs.registry_sg_id]
  private_ip                  = data.terraform_remote_state.shared.outputs.registry_ip
  iam_instance_profile        = aws_iam_instance_profile.s3_instance_profile.id

  tags = {
    Name = "registry-server"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.registry_volume_size
  }
}
