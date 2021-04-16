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
  type = int
}

variable "default_pool_machine_type" {
  type = string
}

variable "default_pool_preemptible" {
  type = boolean
}
