#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  # AWS S3 naming rules reference:
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
  # we want to assign a random bucket name.
  # bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
}

# AWS S3 Bucket Website Config
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# AWS S3 Object
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath
  content_type = "text/html"

  etag = filemd5(var.index_html_filepath)
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = var.error_html_filepath
  content_type = "text/html"

  etag = filemd5(var.error_html_filepath)
  lifecycle {
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset("${var.assets_path}", "*.{jpg,jpeg,png,gif}")
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.assets_path}/${each.key}"
  # content_type = "text/html"

  etag = filemd5("${var.assets_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

# 

# AWS S3 Bucket Policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = jsonencode({
    "Version"= "2012-10-17",
    "Statement"= {
      "Sid"= "AllowCloudFrontServicePrincipalReadOnly",
      "Effect"= "Allow",
      "Principal"= {
          "Service"= "cloudfront.amazonaws.com"
      },
      "Action"= "s3:GetObject",
      "Resource"= "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition"= {
          "StringEquals"= {
            "AWS:SourceArn"= "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
          }
      }
    }
  })
}

# data "aws_iam_policy_document" "allow_access_for_website_bucket" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:ListBucket",
#     ]

#     resources = [
#       arn:aws:s3:::
#       "${aws_s3_bucket.website_bucket.id.arn}/*",
#     ]
#   }
# }

resource "terraform_data" "content_version" {
  input = var.content_version
}