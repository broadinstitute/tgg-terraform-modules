variable "cluster_name" {
  type        = string
  description = "The name of your GKE cluster"
}

variable "cluster_ipv4_cidr" {
  type        = string
  description = "The network CIDR that's used for the pod network"
}

variable "cluster_location" {
  type        = string
  description = "The GCP region where your cluster runs. E.g. us-central1-c"
}

variable "default_pool_machine_type" {
  type        = string
  description = "The GCP machine type that should be used for the default pool"
}

variable "default_pool_node_count" {
  type        = number
  description = "The number of nodes that should be contained in the default pool"
}

variable "remove_default_node_pool" {
  type        = bool
  default     = true
  description = "value"
}

variable "cluster_initial_node_count" {
  type        = number
  description = "The number of nodes that should be created in the cluster's initial default pool"
  default     = "0"
}

variable "default_pool_disk_size" {
  type        = number
  description = "The size of the default pool disk in gb"
  default     = "100"
}

# Default to daily 3AM-7AM Eastern time maintenance window
variable "recurring_maint_windows" {
  type = list(map(string))
  default = [{
    start_time = "1970-01-01T07:00:00Z"
    end_time   = "1970-01-01T11:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU"
  }]
}

variable "maint_exclusions" {
  type    = list(map(string))
  default = []
}

variable "networking_mode" {
  type    = string
  default = "ROUTES"
}

variable "project" {
  type        = string
  description = "The name of your GCP project"
  default     = "seqr-project"
}

variable "gke_resource_labels" {
  type    = map(string)
  default = {}
}

variable "workload_identity" {
  type    = list(map(string))
  default = []
}

variable "default_pool_image_type" {
  type        = string
  description = "The GKE image to use for the default node pool. Should generally be COS_CONTAINERD unless you specifically need something else."
  default     = "COS_CONTAINERD"
}
