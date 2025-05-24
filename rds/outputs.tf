output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.terraform-video-db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.terraform-video-db.port

}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.terraform-video-db.username
}

output "rds_endpoint" {
  value     = aws_db_instance.terraform-video-db.endpoint
}
