output "static_website_url" {
  value = "http://${aws_s3_bucket.terraform_s3_bucket.bucket}.s3-website.${aws_s3_bucket.terraform_s3_bucket.region}.amazonaws.com"
}

output "name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.terraform_s3_bucket.id
}

output "bucket_domain_name" {
  description = "Bucket Domain Name of the S3 Bucket"
  value       = aws_s3_bucket.terraform_s3_bucket.bucket_domain_name
}