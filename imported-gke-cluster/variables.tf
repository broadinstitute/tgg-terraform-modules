variable "cluster_name" {
  type        = string
  description = "The name of your GKE cluster"
}

variable "cluster_location" {
  type        = string
  description = "The GCP region where your cluster runs. E.g. us-central1-c"
}

variable "network_id" {
  type        = string
  description = "The id of the network where your cluster lives. E.g. projects/appname/global/networks/default"
}

variable "subnetwork_id" {
  type        = string
  description = "The id of the subnet where your cluster lives. E.g. projects/appname/regions/us-central1/subnetworks/default"
}

variable "maint_start_time" {
  type        = string
  description = "a datespec containing the time of day your maint should starti. E.g. 2021-03-24T11:00:00Z"
}

variable "maint_end_time" {
  type        = string
  description = "a datespec containing the time of day your maint should end. E.g. 2021-03-24T23:00:00Z"
}

variable "maint_recurence_sched" {
  type = string
}

variable "default_pool_node_count" {
  type = number
}

variable "default_pool_machine_type" {
  type = string
}

variable "default_pool_preemptible" {
  type    = boolean
  default = false
}

variable "cluster_v4_cidr" {
  type        = string
  description = "The ipv4 CIDR block of your cluster network, E.g. 10.4.0.0/14. Locate this value under the 'Pod address range' in the cluster details pane of the GKE console"
}

variable "services_v4_cidr" {
  type        = string
  description = "The ipv4 CIDR block of your service network, E.g. 10.8.0.0/20. Locate this value under the 'Service address range' in the cluster details pane of the GKE console"
}

variable "shielded_nodes" {
  type        = boolean
  default     = false
  description = "Whether to enable or disable the shielded nodes feature"
}

variable "enable_tpu" {
  type        = boolean
  default     = false
  description = "Whether to enable the Cloud TPU on the kubernetes cluster."
}

variable "intranode_visibility" {
  type        = boolean
  default     = false
  description = "Whether to enable the intranode visibility setting for GKE"
}
