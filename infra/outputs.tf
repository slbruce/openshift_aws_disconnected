output "private_rt_id" {
  value = aws_route_table.private_rt.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

output "private_subnet_3_id" {
  value = aws_subnet.private_subnet_3.id
}

output "vpc_id" {
  value = aws_vpc.installation_vpc.id
}

output "apps_lb_sg_id" {
  value = aws_security_group.apps_lb_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "registry_sg_id" {
  value = aws_security_group.registry_sg.id
}

output "api_lg_sg_id" {
  value = aws_security_group.api_lg_sg.id
}

output "all_machine_sg_id" {
  value = aws_security_group.all_machine_sg.id
}

output "control_plane_sg_id" {
  value = aws_security_group.control_plane_sg.id
}