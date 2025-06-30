resource "aws_s3_bucket" "terraform_s3_bucket" {
  bucket        = var.aws_bucket_name
  force_destroy = true
}


resource "aws_s3_bucket_website_configuration" "terraform_s3_bucket_website" {
  bucket = aws_s3_bucket.terraform_s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


resource "aws_s3_bucket_versioning" "terraform_s3_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_ownership_controls" "terraform_s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.terraform_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "terraform_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.terraform_s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# resource "aws_s3_bucket_acl" "terraform_s3_bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.terraform_s3_bucket_ownership_controls]

#   bucket = aws_s3_bucket.terraform_s3_bucket.id
#   acl    = "private"
# }


resource "aws_s3_bucket_acl" "terraform_s3_bucket_acl_public" {
  depends_on = [
    aws_s3_bucket_ownership_controls.terraform_s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.terraform_s3_bucket_public_access_block
  ]
  bucket = aws_s3_bucket.terraform_s3_bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_policy" "terraform_s3_bucket_policy" {
  bucket = aws_s3_bucket.terraform_s3_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": [
              "s3:GetObject"
          ],
          "Resource": [
              "arn:aws:s3:::${var.aws_bucket_name}/*"
          ]
      }
  ]
}  
EOF
}

