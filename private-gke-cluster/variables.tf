variable "gke_cluster_name" {
  description = "The name of the GKE cluster you want to manage"
  type        = string
}

variable "project_name" {
  description = "The name of the gcp project the cluster is launching in"
  type        = string
}

variable "gke_control_plane_zone" {
  description = "The zone to launch the GKE cluster in"
  type        = string
  default     = "us-central1-c"
}

variable "gke_master_ipv4_cidr_block" {
  description = "The IPv4 CIDR Range (RFC1918) that should be used for the control plane"
  type        = string
  default     = "172.16.0.0/28"
}

variable "gke_services_range_name" {
  description = "The name of the secondary subnet range to use for gke services"
  type        = string
  default     = "gke-services"
}

variable "gke_pods_range_name" {
  description = "The name of the secondary subnet range to use for gke pods"
  type        = string
  default     = "gke-pods"
}

variable "resource_labels" {
  description = "A map of string values to use as resource labels on all cluster objects."
  type        = map(string)
  default     = {}
}

variable "vpc_network_name" {
  description = "The name of the VPC network to launch the cluster in"
  type        = string
  default     = "default"
}

variable "vpc_subnet_name" {
  description = "The name of the VPC network subnet to launch the cluster in"
  type        = string
  default     = "default"
}

variable "release_channel" {
  description = "The release channel name for the GKE cluster"
  type        = string
  default     = "STABLE"
}

variable "node_pools" {
  description = "A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane"
  type = list(object({
    pool_name            = string
    pool_num_nodes       = number
    pool_machine_type    = string
    pool_preemptible     = bool
    pool_zone            = string
    pool_resource_labels = map(string)
  }))
  default = [
    {
      "pool_name"            = "main-pool"
      "pool_num_nodes"       = 2
      "pool_machine_type"    = "e2-medium"
      "pool_preemptible"     = true
      "pool_zone"            = ""
      "pool_resource_labels" = {}
    }
  ]
}
