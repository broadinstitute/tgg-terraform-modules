variable "sa_name_prefix" {
  type        = string
  description = "The string prefix to apply to the serviceAccount created by the module"

  validation {
    condition     = length(var.sa_name_prefix) < 14
    error_message = "The name_prefix must be less than 14 characters to conform to google's naming requirements."
  }
}

variable "secret_id" {
  type        = string
  description = "The name of the slack token secret in your project's SecretManager"
}

variable "memory_mb" {
  type        = number
  default     = 128
  description = "Number of megabytes to allocate to the cloud functon. Default 128"
}

variable "slack_channel_name" {
  type        = string
  description = "The name of the slack channel that should receive notifications"

  validation {
    condition     = substr(var.slack_channel_name, 0, 1) == "#"
    error_message = "The slack_channel_name must start with a pound (#) symbol."
  }
}

variable "source_repository_url" {
  type        = string
  description = "The URL of the google Source Repository object, see: https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions#SourceRepository"
}

variable "cron_schedule" {
  type        = string
  description = "A string representing the cron-format schedule for which to trigger the cloud function"
}
