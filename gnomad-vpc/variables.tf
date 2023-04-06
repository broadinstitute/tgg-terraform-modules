variable "network_name_prefix" {
  description = "The string that should be used to prefix nets, subnets, nats, etc created by this module"
  type        = string
}

variable "dataproc_primary_subnet_range" {
  description = "The IP address range to use for the primary dataproc subnet"
  type        = string
  default     = "192.168.255.0/24"
}

variable "allow_broad_institute_networks" {
  description = "Allow broad's network/ip ranges in various firewall rules"
  type        = bool
  default     = true
}
