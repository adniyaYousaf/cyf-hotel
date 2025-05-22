resource "aws_s3_bucket" "video" {
  bucket = "terraform-video-app"
  tags = {
    Description : "frontend-video-app"
  }
}


resource "aws_s3_bucket_public_access_block" "video" {
  bucket = aws_s3_bucket.video.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "video" {
  bucket = aws_s3_bucket.video.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "video-policy" {
  bucket = aws_s3_bucket.video.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = [
          aws_s3_bucket.video.arn,
          "${aws_s3_bucket.video.arn}/*"
        ]
      }
    ]
  })
}


