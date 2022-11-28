variable "network_name_prefix" {
  description = "The string that should be used to prefix nets, subnets, nats, etc created by this module."
  type        = string
}

variable "gke_services_secondary_range" {
  description = "The IP address range to use for the secondary IP address range for GKE Services"
  type        = string
}

variable "gke_pods_secondary_range" {
  description = "The IP address range to use for the secondary IP address range for GKE Pods"
  type        = string
}

variable "gnomad_primary_subnet_range" {
  description = "The IP address range to use for the primary gnomad subnet."
  type        = string
}

variable "dataproc_primary_subnet_range" {
  description = "The IP address range to use for the primary dataproc subnet."
  type        = string
}
