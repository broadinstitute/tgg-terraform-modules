variable "public_ingress_ip" {
  description = "The IP address that will be used as the public ingress"
  type        = string
  default     = null
}

variable "gke_vpc_ip_cidr_range" {
  description = "The IP CIDR range for the GKE host nodes"
  type        = string
}

variable "gke_pods_ipv4_cidr_block" {
  description = "The IP CIDR range that is used for pods within the GKE cluster"
  type        = string
}

variable "gke_services_ipv4_cidr_block" {
  description = "The IP CIDR range that is used for services within the GKE cluster"
  type        = string
}

variable "es_snapshots_email" {
  description = "The email address of the service account that is used for elasticsearch snapshots"
  type        = string
  default     = null
}
