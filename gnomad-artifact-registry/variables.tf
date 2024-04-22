variable "project_id" {
  type        = string
  description = "The GCP project ID you'd like to your repositories in"
}

variable "location" {
  type        = string
  description = "The google cloud region to host your repositories in"
}

variable "cleanup_policy_dry_run" {
  type        = bool
  description = "Whether to run your cleanup policy in dry run mode"
  default     = false
}
