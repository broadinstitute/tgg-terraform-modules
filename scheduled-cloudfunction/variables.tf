variable "scheduled_function_name" {
  type        = string
  description = "The string that should be used to create resources associated with the module, svc account, pubsub queue, etc"

  validation {
    condition     = length(var.scheduled_function_name) >= 6 && length(var.scheduled_function_name) < 30
    error_message = "The function name must be greater than 6 chars and less than 30 characters to conform to google's naming requirements."
  }
}

variable "cron_schedule" {
  type        = string
  description = "A string representing the cron-format schedule for which to trigger the cloud function"
}

variable "manage_service_accounts" {
  type        = bool
  description = "Whether or not to manage the service accounts for the scheduled function and the deployment service account"
  default     = true
}

variable "service_account_roles" {
  type        = list(string)
  description = "A list of roles to assign to the service account created for the scheduled function. Cannot be specified if manage_service_accounts is false"
  default     = []
}

variable "cloudbuild_service_account_email" {
  type        = string
  description = "The email address of the cloudbuild service account"
}

variable "required_gcp_secrets" {
  type        = list(string)
  description = "A list of the names of GCP Secret Manager secrets that the scheudled function requires to run. Cannot be specified if manage_service_accounts is false"
  default     = []
}

variable "project_id" {
  type        = string
  description = "The project id of the project in which to create the scheduled function"
}

variable "configure_workload_identity" {
  type        = bool
  description = "Whether or not to configure workload identity federation for the scheduled function and github actions. Cannot be specified if manage_service_accounts is false"
  default     = true
}

variable "workload_identity_attr_condition" {
  type        = string
  description = "The workload identity attribute condition to use for the scheduled function workload identity mapping"
  default     = "assertion.ref=='refs/heads/main'"
}

variable "workload_identity_attr" {
  type        = string
  description = "value of the workload identity attribute to use for the scheduled function workload identity mapping"
  default     = "attribute.repository/broadinstitute/gnomad-storage-monitoring"
}
