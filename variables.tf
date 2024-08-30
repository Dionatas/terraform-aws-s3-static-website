variable "name" {
  description = "Bucket unique name. It can contain only numbers, letters and dashes"
  type        = string
  default     = null # Não será necessário passar o nome do Bucket. 
}


variable "ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "BucketOwnerPreferred"

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.ownership)
    error_message = "Invalid S3 bucket ownership. Valid values are: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter"
  }
}


variable "acl" {
  description = "Access Control List. It defines which AWS accounts or groups are granted access and the type of access"
  type        = string
  default     = "private"
}


variable "policy" {
  description = "Bucket policy"
  type = object({
    json = string
  })
  default = null
}


variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}


variable "versioning" {
  description = "Map containing versioning configuration."
  type = object({
    expected_bucket_owner = optional(string)
    status                = optional(string)
    mfa                   = optional(string)
    mfa_delete            = optional(string)
  })
  nullable = true
  default  = {}

  validation {
    condition     = var.versioning.status != null ? contains(["Enabled", "Suspended", "Disabled"], var.versioning.status) : true
    error_message = "Allowed values for versioning.status are \"Enabled\", \"Suspended\", \"Disabled\"."
  }
}


variable "public_access" {
  description = "Public access block configurarion"

  type = object({
    block_public_acls       = optional(string)
    block_public_policy     = optional(string)
    ignore_public_acls      = optional(string)
    restrict_public_buckets = optional(string)
  })

  nullable = true
  default  = {}

}


variable "website" {
  description = "Map containing website configuration"

  type = object({
    index_document           = optional(string)
    error_document           = optional(string)
    redirect_all_requests_to = optional(string)
  })
  nullable = true
  default  = {}
}


variable "logging" {
  description = "Map containing logging configuration"

  type = object({
    target_bucket = optional(string)
    target_prefix = optional(string)

  })
  nullable = true
  default  = {}
}