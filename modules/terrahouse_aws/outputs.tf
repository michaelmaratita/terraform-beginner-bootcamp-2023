output "bucket_name" {
    value = aws_s3_bucket.website_bucket.bucket
}
output "website_endpoint" {
    description = "value"
    value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}