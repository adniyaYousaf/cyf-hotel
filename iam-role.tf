resource "aws_iam_role" "secret_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.secret_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "my-ec2-instance-profile"
  role = aws_iam_role.secret_role.name
}
