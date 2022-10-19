variable "user_principal" {
  type        = string
  description = "The email address of the user we'd like to grant access to"
}

variable "service_account_email" {
  type        = string
  description = "The email of the user's dataproc worker service account"
}

variable "dataproc_bucket_prefix" {
  type        = string
  description = "The prefix that we should use for the names of the stage and temp buckets for Dataproc."
}

variable "force_destroy_user_dataproc_buckets" {
  type    = bool
  default = false
}

variable "project_id" {
  type        = string
  description = "The GCP project ID where resources and permission grants should be created"
}
