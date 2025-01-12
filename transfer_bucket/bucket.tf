resource "aws_s3_bucket" "transfer-internal-bucket" {
  bucket_prefix = "transfer-internal-bucket-"
  force_destroy = true
}

// add s3 vpc gateway endpoint 
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.terraform_remote_state.infra.outputs.vpc_id
  service_name = "com.amazonaws.${data.terraform_remote_state.shared.outputs.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [data.terraform_remote_state.infra.outputs.private_rt_id]
}

// add security group to allow egress to endpoints from bastion and registry machines
resource "aws_vpc_security_group_egress_rule" "bastion_to_s3_sg_egress" {
  security_group_id =  data.terraform_remote_state.infra.outputs.bastion_sg_id
  prefix_list_id = aws_vpc_endpoint.s3.prefix_list_id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

// add security group to allow egress to endpoints from bastion and registry machines
resource "aws_vpc_security_group_egress_rule" "registry_to_s3_sg_egress" {
  security_group_id =  data.terraform_remote_state.infra.outputs.registry_sg_id
  prefix_list_id = aws_vpc_endpoint.s3.prefix_list_id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}