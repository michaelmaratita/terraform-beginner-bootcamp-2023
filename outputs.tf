output "bucket_name" {
    description = "Bucket name for our static website"
    value = module.home_destiny_hosting.bucket_name
}
output "s3_website_endpoint" {
    description = "S3 static website hosting endpoint"
    value = module.home_destiny_hosting.website_endpoint
}
output "cloudfront_url" {
    description = "CloudFront Distribution Domain Name"
    value = module.home_destiny_hosting.domain_name
}