resource "aws_instance" "worker_instances" {
  count = 2

  ami           = data.terraform_remote_state.shared.outputs.coreos_ami
  instance_type = var.compute_type
  subnet_id = (count.index == 0 ?
  data.terraform_remote_state.infra.outputs.private_subnet_1_id : data.terraform_remote_state.infra.outputs.private_subnet_3_id)
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
            "source": "http://${data.terraform_remote_state.bastion_registry.outputs.bastion_ip}:8080/worker.ign",
            "verification": {
              "hash": "${var.compute_ignition_sha}"
            }
          }
        }
      }
    }
  EOF

  user_data_replace_on_change = false
}

resource "aws_route53_record" "worker_records" {
  count = 2
  zone_id  = data.terraform_remote_state.infra.outputs.route53_primary_zone_id
  name     = "worker${count.index}.${data.terraform_remote_state.infra.outputs.cluster_fqdn}"
  type     = "A"
  ttl      = 300
  records  = [aws_instance.worker_instances[count.index].private_ip]
}

resource "aws_route53_record" "worker_reverse_records" {
  count = 2
  zone_id  = data.terraform_remote_state.infra.outputs.route53_reverse_zone_id
  name     = "${slice(split(".", aws_instance.worker_instances[count.index].private_ip), 3, 4)[0]}.${data.terraform_remote_state.infra.outputs.dns_reverse_domain}"
  type     = "PTR"
  ttl      = 300
  records  = ["worker${count.index}.${data.terraform_remote_state.infra.outputs.cluster_fqdn}"]
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_443_to_worker_attachments" {
  count = 2
  target_group_arn  = data.terraform_remote_state.infra.outputs.apps_ingress_lb_tg_443_arn
  target_id         = aws_instance.worker_instances[count.index].private_ip
  port              = 443
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}${count.index == 0 ? "a" :  "c"}"
}

resource "aws_lb_target_group_attachment" "apps_ingress_lb_tg_80_to_worker_attachments" {
  count = 2
  target_group_arn  = data.terraform_remote_state.infra.outputs.apps_ingress_lb_tg_80_arn
  target_id         = aws_instance.worker_instances[count.index].private_ip
  port              = 80
  availability_zone = "${data.terraform_remote_state.shared.outputs.region}${count.index == 0 ? "a" :  "c"}"
}
