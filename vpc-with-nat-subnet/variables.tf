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
    subnet_flow_logs             = bool
    subnet_flow_logs_sampling    = string
    subnet_flow_logs_metadata    = string
    subnet_flow_logs_filter      = string
  }))
  default = [
    {
      subnet_name_suffix           = "gke"
      subnet_region                = "us-central1"
      ip_cidr_range                = "192.168.0.0/20"
      enable_private_google_access = true
      subnet_flow_logs             = false
      subnet_flow_logs_sampling    = "0.5"
      subnet_flow_logs_metadata    = "EXCLUDE_ALL_METADATA"
      subnet_flow_logs_filter      = "true"
    }
  ]
}

variable "nat_ip_allocate_option" {
  description = "AUTO_ONLY or MANUAL_ONLY, for configuring a stable outbound IP"
  type        = string
  default     = "AUTO_ONLY"
}

variable "nat_ips" {
  description = "A list of self_links to static IP reservations used as stable outbound IPs"
  type        = list(string)
  default     = null
}
