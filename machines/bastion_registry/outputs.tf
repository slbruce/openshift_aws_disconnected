output "bastion_instance_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}