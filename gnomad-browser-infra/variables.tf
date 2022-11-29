variable "infra_prefix" {
  description = "The string to use for a prefix on resource names (GKE cluster, GCS Buckets, Service Accounts, etc)"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC network that the GKE cluster should reside in."
  type        = string
}

variable "vpc_subnet_name" {
  description = "The name of the VPC network subnet that the GKE cluster nodes should reside in."
  type        = string
}

variable "gke_master_node_cidr_range" {
  description = "The IPv4 CIDR Range that should be used for the GKE control plane"
  type        = string
}

variable "redis_pool_num_nodes" {
  description = "The number of nodes that the redis GKE node pool should contain"
  type        = number
}

variable "redis_pool_machine_type" {
  description = "The GCE machine type that should be used for the redis GKE node pool"
  type        = string
  default     = "e2-custom-6-49152" # TODO create this?
}

variable "main_pool_num_nodes" {
  description = "The number of nodes that the main/default GKE node pool should contain"
  type        = number
}

variable "main_pool_machine_type" {
  description = "The GCE machine type that should be used for the main/default GKE node pool"
  type        = string
  default     = "e2-standard-4"
}

variable "es_data_pool_num_nodes" {
  description = "The number of nodes that the elasticsearch data GKE node pool should contain"
  type        = number
}

variable "es_data_pool_machine_type" {
  description = "The GCE machine type that should be used for the elasticsearch data GKE node pool"
  type        = string
  default     = "e2-highmem-8"
}
