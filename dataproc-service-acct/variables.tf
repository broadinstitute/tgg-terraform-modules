variable "user_principal" {
  type        = string
  description = "The email address of the user we'd like to grant access to"
}

variable "service_account_id" {
  type        = string
  description = "The name that we should use as the username portion of the service account email address"
}

variable "service_account_display_name" {
  type        = string
  description = "The display name of the service account that we are going to create"
}

variable "dataproc_bucket_prefix" {
  type        = string
  description = "The prefix that we should use for the names of the stage and temp buckets for Dataproc."
}

variable "force_destroy_user_dataproc_buckets" {
  type    = bool
  default = false
}
