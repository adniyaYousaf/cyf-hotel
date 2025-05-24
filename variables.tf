variable "public_key" {
  type      = string
  sensitive = true
}


variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "Database host"
  type        = string
  sensitive   = true
}


variable "db_port" {
  description = "Database port"
  type        = string
  sensitive   = true
}

variable "sg-rds-to-ec2" {
  description = "sg"
  type        = string
  sensitive   = true
}
