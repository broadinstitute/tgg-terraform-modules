variable "node_pool_count" {
  type = string
}

variable "node_location" {
  type    = string
  default = "us-central1-b"
}

variable "preemptible_nodes" {
  type    = bool
  default = false
}

variable "node_pool_labels" {
  type    = map(string)
  default = {}
}
variable "node_pool_name" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster that the node pool should reside in."
}

variable "node_pool_machine_type" {
  type = string
}

variable "node_pool_image_type" {
  type        = string
  description = "The GKE image to use for the node pool. Should usually be COS_CONTAINERD."
  default     = "COS_CONTAINERD"
}

variable "node_pool_local_ssd_count" {
  type    = string
  default = "0"
}
