variable "gcs_bucket_name" {
  type        = string
  description = "The name of the GCS bucket you'd like to monitor"

  validation {
    condition     = length(var.gcs_bucket_name) >= 3
    error_message = "The gcs_bucket_name must be 3 or more characters."
  }
}

variable "sent_bytes_alerting_threshold" {
  type        = number
  description = "The number of bytes sent, to be used as a threshold for alerting"
}

variable "sent_bytes_alerting_duration" {
  type        = string
  description = "The number of seconds to evaluate an alert threshold on. As a string, 60 seconds would be represented as '60s'"
}

variable "sent_bytes_alerting_alignment_period" {
  type        = string
  description = "The number of seconds to use for the alignment period when evaluating an alert condition. As a string, 60 seconds would be represented as '60s'"

}

variable "notification_channels" {
  type        = list(string)
  description = "A list of notification channel IDs. These should be defined in your project's configuration, and supplied here as an input to the module"
  default     = []
}