resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  force_destroy = var.force_destroy

}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.ownership
  }

}


resource "aws_s3_bucket_public_access_block" "this" {
  count = local.is_public_access_set ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = lookup(var.public_access, "block_public_acls", true)
  block_public_policy     = lookup(var.public_access, "block_public_policy", true)
  ignore_public_acls      = lookup(var.public_access, "ignore_public_acls", true)
  restrict_public_buckets = lookup(var.public_access, "restrict_public_buckets", true)
}


resource "aws_s3_bucket_acl" "this" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this
  ]

  bucket = aws_s3_bucket.this.bucket
  acl    = var.acl
}


resource "aws_s3_bucket_policy" "this" {
  count = var.policy != null ? 1 : 0

  depends_on = [
    aws_s3_bucket_acl.this,
  ]

  bucket = aws_s3_bucket.this.id
  policy = var.policy.json

}


resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning.status != null ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = lookup(var.versioning, "expected_bucket_owner", null)
  mfa                   = lookup(var.versioning, "mfa", null)

  versioning_configuration {
    status     = lookup(var.versioning, "status", null)
    mfa_delete = lookup(var.versioning, "mfa_delete", null)
  }

}


resource "aws_s3_bucket_logging" "this" {
  count = local.is_logging_set ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = lookup(var.logging, "target_bucket", null)
  target_prefix = lookup(var.logging, "target_prefix", null)

}