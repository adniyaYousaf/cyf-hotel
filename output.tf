output "ec2_instance_id" {
  value = aws_instance.backend_server.id
}
output "public_ip" {
  value = aws_instance.backend_server.public_ip
}
