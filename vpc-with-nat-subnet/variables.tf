variable "network_name" {
  description = "The name that should be given to the VPC network"
  type        = string
  default     = "atlantis"
}

variable "subnet_name_suffix" {
  description = "The suffix for the name of the primary subnet; resulting name is network_name-subnet_name_suffix"
  type        = string
  default     = "gke"
}

variable "primary_subnet_cidr" {
  description = "The RFC1918 CIDR mask for the primary subnet range"
  type        = string
  default     = "192.168.0.0/20"
}

variable "secondary_network_ranges" {
  description = "A list of network range objects"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = [
    {
      range_name    = "gke-services"
      ip_cidr_range = "10.0.32.0/20"
    },
    {
      range_name    = "gke-pods"
      ip_cidr_range = "10.4.0.0/14"
    }
  ]
}

variable "enable_google_private_access" {
  description = "Whether to enable private network access for google services in the primary subnet"
  type        = bool
  default     = true
}
