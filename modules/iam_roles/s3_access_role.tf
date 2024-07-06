resource "aws_iam_role" "s3_access_role" {
  name               = "S3AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"  // Example: Allow EC2 instances to assume this role
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Provides access to specific S3 bucket"
  policy      = file("${path.module}/s3_access_policy.json")
}

resource "aws_iam_role_policy_attachment" "s3_access_role_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
