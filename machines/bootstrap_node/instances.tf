resource "aws_instance" "bootstrap_instance" {
  ami           = data.terraform_remote_state.shared.outputs.coreos_ami
  instance_type = var.bootstrap_type
  subnet_id     = data.terraform_remote_state.infra.outputs.private_subnet_1_id
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
            "source": "http://${data.terraform_remote_state.bastion_registry.outputs.bastion_ip}:8080/bootstrap.ign",
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

resource "aws_route53_record" "bootstrap" {
  zone_id = data.terraform_remote_state.infra.outputs.route53_primary_zone_id
  name    = "bootstrap.${data.terraform_remote_state.infra.outputs.cluster_fqdn}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.bootstrap_instance.private_ip]
}

resource "aws_route53_record" "bootstrap_reverse" {
  zone_id = data.terraform_remote_state.infra.outputs.route53_reverse_zone_id
  name    = "${slice(split(".", aws_instance.bootstrap_instance.private_ip), 3, 4)[0]}.${data.terraform_remote_state.infra.outputs.dns_reverse_domain}"
  type    = "PTR"
  ttl     = 300
  records = [aws_route53_record.bootstrap.fqdn]
}

resource "aws_lb_target_group_attachment" "api_lb_tg_6443_to_bootstrap_attachment" {
  target_group_arn  = data.terraform_remote_state.infra.outputs.api_lb_tg_6443_arn
  target_id         = aws_instance.bootstrap_instance.private_ip
  port              = 6443
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}a"
}

resource "aws_lb_target_group_attachment" "api_lb_tg_22623_to_master_attachments" {
  target_group_arn  = data.terraform_remote_state.infra.outputs.api_lb_tg_22623_arn
  target_id         = aws_instance.bootstrap_instance.private_ip
  port              = 22623
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}a"
}