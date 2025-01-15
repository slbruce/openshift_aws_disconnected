resource "aws_instance" "master_instances" {
  count = 3

  ami           = data.terraform_remote_state.shared.outputs.coreos_ami
  instance_type = var.control_plane_type
  subnet_id = (count.index == 0 ?
    data.terraform_remote_state.infra.outputs.private_subnet_1_id :
  count.index == 1 ? data.terraform_remote_state.infra.outputs.private_subnet_2_id : data.terraform_remote_state.infra.outputs.private_subnet_3_id)
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
            "source": "http://${data.terraform_remote_state.bastion_registry.outputs.bastion_ip}:8080/master.ign",
            "verification": {
              "hash": "${var.control_plane_ignition_sha}"
            }
          }
        }
      }
    }
  EOF

  user_data_replace_on_change = false
}

resource "aws_route53_record" "master_records" {
  count = 3
  zone_id  = data.terraform_remote_state.infra.outputs.route53_primary_zone_id
  name     = "master${count.index}.${data.terraform_remote_state.infra.outputs.cluster_fqdn}"
  type     = "A"
  ttl      = 300
  records  = [aws_instance.master_instances[count.index].private_ip]
}

resource "aws_route53_record" "master_reverse_records" {
  count = 3
  zone_id  = data.terraform_remote_state.infra.outputs.route53_reverse_zone_id
  name     = "${slice(split(".", aws_instance.master_instances[count.index].private_ip), 3, 4)[0]}.${data.terraform_remote_state.infra.outputs.dns_reverse_domain}"
  type     = "PTR"
  ttl      = 300
  records  = ["master${count.index}.${data.terraform_remote_state.infra.outputs.cluster_fqdn}"]
}

resource "aws_lb_target_group_attachment" "api_lb_tg_6443_to_master_attachments" {
  count = 3
  target_group_arn  = data.terraform_remote_state.infra.outputs.api_lb_tg_6443_arn
  target_id         = aws_instance.master_instances[count.index].private_ip
  port              = 6443
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"
}

resource "aws_lb_target_group_attachment" "api_lb_tg_22623_to_master_attachments" {
  count = 3
  target_group_arn  = data.terraform_remote_state.infra.outputs.api_lb_tg_22623_arn
  target_id         = aws_instance.master_instances[count.index].private_ip
  port              = 22623
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}${count.index == 0 ? "a" : count.index == 1 ? "b" : "c"}"
}