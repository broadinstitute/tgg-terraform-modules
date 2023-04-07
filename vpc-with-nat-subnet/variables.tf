variable "network_name" {
  description = "The name that should be given to the VPC network"
  type        = string
  default     = "atlantis"
}

variable "subnets" {
  description = "The subnet definitions that you'd like to create for the network"
  type = list(object({
    subnet_name_suffix           = string
    subnet_region                = string
    ip_cidr_range                = string
    enable_private_google_access = bool
  }))
  default = [
    {
      subnet_name_suffix           = ""
      subnet_region                = "us-central1"
      ip_cidr_range                = "192.168.0.0/20"
      enable_private_google_access = true
    }
  ]
}
