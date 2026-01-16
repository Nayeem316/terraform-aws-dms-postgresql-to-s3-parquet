# iam_dms_s3.tf
# IAM role + policy for DMS to write to S3

resource "aws_iam_role" "dms_s3_role" {
  name = "dms-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "dms.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(local.common_tags, { Name = "dms-s3-access-role" })
}

resource "aws_iam_role_policy" "dms_s3_policy" {
  name = "dms-s3-access-policy"
  role = aws_iam_role.dms_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = [
          aws_s3_bucket.dms_bucket.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ListBucketMultipartUploads"
        ],
        Resource = [
          "${aws_s3_bucket.dms_bucket.arn}/*"
        ]
      }
    ]
  })
}