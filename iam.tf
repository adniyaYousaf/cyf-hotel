resource "aws_iam_user" "video-terraform" {
	name = "adniyayousaf-week4"
	tags = {
	  Description = "I am user for Video recommendation App"
	}
}

resource "aws_iam_policy" "adminUser" {
	name = "AdminUsers"
    policy = file("admin-policy.json")
}

resource "aws_iam_user_policy_attachment" "adniya-admin-access" {
	user = aws_iam_user.video-terraform.name
	policy_arn = aws_iam_policy.adminUser.arn
}
