variable "scheduled_function_name" {
  type        = string
  description = "The string that should be used to create resources associated with the module, svc account, pubsub queue, etc"

  validation {
    condition     = length(var.scheduled_function_name) >= 6 && length(var.scheduled_function_name) < 30
    error_message = "The name_prefix must be less than 32 characters to conform to google's naming requirements."
  }
}

variable "cron_schedule" {
  type        = string
  description = "A string representing the cron-format schedule for which to trigger the cloud function"
}

variable "service_account_roles" {
  type        = list(string)
  description = "A list of roles to assign to the service account created for the scheduled function"
  default     = ["roles/cloudfunctions.invoker"]
}

variable "cloudbuild_service_account_email" {
  type        = string
  description = "The email address of the cloudbuild service account"
}

variable "required_gcp_secrets" {
  type        = list(string)
  description = "A list of the names of GCP Secret Manager secrets that the scheudled function requires to run"
  default     = []
}

variable "project_id" {
  type        = string
  description = "The project id of the project in which to create the scheduled function"
}
