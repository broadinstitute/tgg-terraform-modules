variable "project_id" {
  description = "The name of the target GCP project, for creating IAM memberships."
}

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

variable "gke_control_plane_zone" {
  description = "The GCP zone where the GKE control plane will reside."
  type        = string
}

variable "gke_control_plane_cidr_range" {
  description = "The IPv4 CIDR Range that should be used for the GKE control plane"
  type        = string
}

variable "gke_cluster_secondary_range_name" {
  description = "The name of the secondary subnet IP range to use for Pods in the GKE cluster"
  type        = string
  default     = "gke-pods"
}

variable "gke_services_secondary_range_name" {
  description = "The name of the secondary subnet IP range to use for GKE services"
  type        = string
  default     = "gke-services"
}

variable "gke_redis_pool_num_nodes" {
  description = "The number of nodes that the redis GKE node pool should contain"
  type        = number
  default     = 1
}

variable "gke_redis_pool_machine_type" {
  description = "The GCE machine type that should be used for the redis GKE node pool"
  type        = string
  default     = "e2-custom-6-49152"
}

variable "gke_redis_pool_zone" {
  description = "The zone where the GKE Redis pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane."
  type        = string
  default     = ""
}

variable "gke_main_pool_num_nodes" {
  description = "The number of nodes that the main/default GKE node pool should contain"
  type        = number
}

variable "gke_main_pool_machine_type" {
  description = "The GCE machine type that should be used for the main/default GKE node pool"
  type        = string
  default     = "e2-standard-4"
}

variable "gke_main_pool_zone" {
  description = "The zone where the GKE Main pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane."
  type        = string
  default     = ""
}

variable "es_data_pool_num_nodes" {
  description = "The number of nodes that the elasticsearch data GKE node pool should contain"
  type        = number
  default     = 3
}

variable "es_data_pool_machine_type" {
  description = "The GCE machine type that should be used for the elasticsearch data GKE node pool"
  type        = string
  default     = "e2-highmem-8"
}

variable "gke_es_data_pool_zone" {
  description = "The zone where the GKE Main pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane."
  type        = string
  default     = ""
}

variable "es_snapshots_bucket_location" {
  description = "The GCS location for the elasticsearch snapshots bucket"
  type        = string
  default     = "us-east1"
}
