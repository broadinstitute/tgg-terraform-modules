variable "scheduled_function_name" {
  type        = string
  description = "The string that should be used to create resources associated with the module, pubsub queue, etc"

  validation {
    condition     = length(var.scheduled_function_name_prefix) < 32
    error_message = "The name_prefix must be less than 32 characters to conform to google's naming requirements."
  }
}

variable "scheduled_function_description" {
  type        = string
  description = "The string that should be used as the scheduled function description"
}

variable "service_account_email" {
  type        = string
  description = "A string representing the email address of the serviceAccount that the cloudfunction should run as."

  validation {
    condition     = substr(var.service_account_email, -19, -1) == "gserviceaccount.com"
    error_message = "The service account email must end in gserviceaccount.com"
  }
}

variable "slack_channel_name" {
  type        = string
  description = "The name of the slack channel that should receive notifications"

  validation {
    condition     = substr(var.slack_channel_name, 0, 1) == "#"
    error_message = "The slack_channel_name must start with a pound (#) symbol."
  }
}

variable "function_environment_variables" {
  type        = map(string)
  default     = {}
  description = "A set of key/value environment variables to pass to the function."
}

variable "function_runtime" {
  type        = string
  default     = "python39"
  description = "The cloudfunction runtime that should be used for the function, e.g. python39."
}

variable "function_entrypoint" {
  type        = string
  description = "The entrypoint (main function name) that cloudfunctions should use to invoke the function"
}

variable "memory_mb" {
  type        = number
  default     = 128
  description = "Number of megabytes to allocate to the cloud functon. Default 128"
}

variable "source_repository_url" {
  type        = string
  description = "The URL of the google Source Repository object, see: https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions#SourceRepository"
}

variable "cron_schedule" {
  type        = string
  description = "A string representing the cron-format schedule for which to trigger the cloud function"
}
