output "bastion_instance_id" {
  value = aws_instance.bastion_instance.id
}

output "bastion_ip" {
  value = aws_instance.bastion_instance.private_ip
}