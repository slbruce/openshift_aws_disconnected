resource "aws_instance" "bootstrap_instance" {
  count = var.bootstrap_needed ? 1 : 0

  ami           = var.coreos_ami
  instance_type = var.bootstrap_type
  subnet_id     = data.terraform_remote_state.infra.outputs.private_subnet_1_id
  private_ip    = data.terraform_remote_state.shared.outputs.bootstrap_ip
  vpc_security_group_ids = [
    data.terraform_remote_state.infra.outputs.all_machine_sg_id,
    data.terraform_remote_state.infra.outputs.control_plane_sg_id,
    data.terraform_remote_state.infra.outputs.api_lg_sg_id,
  ]

  tags = {
    Name = "bootstrap_instance"
  }

  volume_tags = {
    Name = "bootstrap_instance"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bootstrap_volume_size

  }

  user_data = <<-EOF
    {
      "ignition": {
        "version": "3.0.0",
        "config": {
          "replace": {
            "source": "http://${data.terraform_remote_state.shared.outputs.registry_ip}/bootstrap.ign",
            "verification": {
              "hash": "${var.bootstrap_ignition_sha}"
            }
          }
        }
      }
    }
  EOF

  user_data_replace_on_change = false
}

resource "aws_instance" "master_instances" {
  count = 3

  ami           = var.coreos_ami
  instance_type = var.control_plane_type
  subnet_id = (count.index == 0 ?
    data.terraform_remote_state.infra.outputs.private_subnet_1_id :
  count.index == 1 ? data.terraform_remote_state.infra.outputs.private_subnet_2_id : data.terraform_remote_state.infra.outputs.private_subnet_3_id)
  private_ip = (count.index == 0 ? data.terraform_remote_state.shared.outputs.master0_ip :
  count.index == 1 ? data.terraform_remote_state.shared.outputs.master1_ip : data.terraform_remote_state.shared.outputs.master2_ip)
  vpc_security_group_ids = [
    data.terraform_remote_state.infra.outputs.all_machine_sg_id,
    data.terraform_remote_state.infra.outputs.control_plane_sg_id,
    data.terraform_remote_state.infra.outputs.api_lg_sg_id,
  ]

  tags = {
    Name = "master${count.index}"
  }

  volume_tags = {
    Name = "master${count.index}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.control_plane_size
  }

  user_data = <<-EOF
    {
      "ignition": {
        "version": "3.0.0",
        "config": {
          "replace": {
            "source": "http://${data.terraform_remote_state.shared.outputs.registry_ip}/master.ign",
            "verification": {
              "hash": "${var.control_plane_ignition_sha}"
            }
          }
        }
      }
    }
  EOF

  user_data_replace_on_change = false

  # this can be ignored.  I originally created instances using launch template
  lifecycle {
    ignore_changes = [
      launch_template
    ]
  }
}

resource "aws_instance" "worker_instances" {
  count = 2

  ami           = var.coreos_ami
  instance_type = var.compute_type
  subnet_id = (count.index == 0 ?
  data.terraform_remote_state.infra.outputs.private_subnet_1_id : data.terraform_remote_state.infra.outputs.private_subnet_3_id)
  private_ip = (count.index == 0 ? data.terraform_remote_state.shared.outputs.worker0_ip : data.terraform_remote_state.shared.outputs.worker1_ip)
  vpc_security_group_ids = [
    data.terraform_remote_state.infra.outputs.all_machine_sg_id,
    data.terraform_remote_state.infra.outputs.apps_lb_sg_id
  ]

  tags = {
    Name = "worker${count.index}"
  }

  volume_tags = {
    Name = "worker${count.index}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = var.compute_size
  }

  user_data = <<-EOF
    {
      "ignition": {
        "version": "3.0.0",
        "config": {
          "replace": {
            "source": "http://${data.terraform_remote_state.shared.outputs.registry_ip}/worker.ign",
            "verification": {
              "hash": "${var.compute_ignition_sha}"
            }
          }
        }
      }
    }
  EOF

  user_data_replace_on_change = false

  # this can be ignored.  I originally created instances using launch template
  lifecycle {
    ignore_changes = [
      launch_template
    ]
  }
}
