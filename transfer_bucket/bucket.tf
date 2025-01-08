resource "aws_s3_bucket" "example" {
  bucket_prefix = "transfer_internal_bucket_"
  force_destroy = true
}

// add s3 vpc gateway endpoint 
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.terraform_remote_state.infra.outputs.vpc_id
  service_name = "com.amazonaws.${data.terraform_remote_state.shared.outputs.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [data.terraform_remote_state.infra.outputs.private_rt_id]
  subnet_configuration {
    ipv4 = var.bucket_gateway_endpoint_ip
    subnet_id = data.terraform_remote_state.infra.outputs.private_subnet_3_id
  }
}