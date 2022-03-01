variable "instance_name" {
  type        = string
  description = "The name of the database instance itself (not databases within it)."
}

variable "database_version" {
  type    = string
  default = "POSTGRES_12"
}

variable "availability_type" {
  type        = string
  description = "ZONAL for non-HA, or REGIONAL for HA"
}

variable "enable_private_network" {
  type        = bool
  default     = false
  description = "Set to true to deploy the cloudsql instance as a Private Instance."
}

variable "private_network_name" {
  type    = string
  default = ""
}

variable "project" {
  type    = string
  default = ""
}

variable "backup_enabled" {
  type    = string
  default = "true"
}
