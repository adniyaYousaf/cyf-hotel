# Create the secret
resource "aws_secretsmanager_secret" "db_user" {
  name                    = "db_user"
  description             = "Database credentials for the video app"
  recovery_window_in_days = 0
  tags = {
    Name = "db_user"
  }
}

# Store the username and password as a JSON string
resource "aws_secretsmanager_secret_version" "db_user_version" {
  secret_id     = aws_secretsmanager_secret.db_user.id

  secret_string = jsonencode({
	host     = var.db_host
    username = var.db_username
    password = var.db_password
	port     = var.db_port
  })
}
