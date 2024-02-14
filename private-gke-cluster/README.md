# Provide a GKE cluster with private networking


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.node_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.gke_nodes_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.gke_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether or not to enable deletion protection on the GKE cluster. Default false. | `bool` | `false` | no |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | The name of the GKE cluster you want to manage | `string` | n/a | yes |
| <a name="input_gke_control_plane_authorized_networks"></a> [gke\_control\_plane\_authorized\_networks](#input\_gke\_control\_plane\_authorized\_networks) | The IPv4 CIDR ranges that should be allowed to connect to the control plane | `list(string)` | `[]` | no |
| <a name="input_gke_control_plane_zone"></a> [gke\_control\_plane\_zone](#input\_gke\_control\_plane\_zone) | The zone to launch the GKE cluster in | `string` | `"us-central1-c"` | no |
| <a name="input_gke_maint_exclusions"></a> [gke\_maint\_exclusions](#input\_gke\_maint\_exclusions) | Specified times and dates that non-emergency GKE maintenance should pause | `list(map(string))` | `[]` | no |
| <a name="input_gke_master_ipv4_cidr_block"></a> [gke\_master\_ipv4\_cidr\_block](#input\_gke\_master\_ipv4\_cidr\_block) | The IPv4 CIDR Range (RFC1918) that should be used for the control plane | `string` | `"172.16.0.0/28"` | no |
| <a name="input_gke_pods_range_slice"></a> [gke\_pods\_range\_slice](#input\_gke\_pods\_range\_slice) | The CIDR notation for the size of the GKE pods IP address alias range | `string` | `"/14"` | no |
| <a name="input_gke_recurring_maint_windows"></a> [gke\_recurring\_maint\_windows](#input\_gke\_recurring\_maint\_windows) | A start time, end time and recurrence pattern for GKE automated maintenance windows | `list(map(string))` | <pre>[<br>  {<br>    "end_time": "1970-01-01T11:00:00Z",<br>    "recurrence": "FREQ=DAILY",<br>    "start_time": "1970-01-01T07:00:00Z"<br>  }<br>]</pre> | no |
| <a name="input_gke_services_range_slice"></a> [gke\_services\_range\_slice](#input\_gke\_services\_range\_slice) | The CIDR notation for the size of the GKE services IP address alias range | `string` | `"/20"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane | <pre>list(object({<br>    pool_name            = string<br>    pool_num_nodes       = optional(number, 2)<br>    pool_machine_type    = optional(string, "e2-medium")<br>    pool_preemptible     = optional(bool, false)<br>    pool_spot            = optional(bool, true)<br>    pool_zone            = optional(string, "")<br>    pool_resource_labels = optional(map(string), {})<br>    pool_taints          = optional(list(object({ key = string, value = string, effect = string })), [])<br>  }))</pre> | <pre>[<br>  {<br>    "pool_machine_type": "e2-medium",<br>    "pool_name": "main-pool",<br>    "pool_num_nodes": 2,<br>    "pool_preemptible": true,<br>    "pool_resource_labels": {},<br>    "pool_spot": false,<br>    "pool_taints": [],<br>    "pool_zone": ""<br>  }<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the gcp project the cluster is launching in | `string` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel name for the GKE cluster | `string` | `"STABLE"` | no |
| <a name="input_resource_labels"></a> [resource\_labels](#input\_resource\_labels) | A map of string values to use as resource labels on all cluster objects. | `map(string)` | `{}` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network to launch the cluster in | `string` | `"default"` | no |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet to launch the cluster in | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_cluster_api_endpoint"></a> [gke\_cluster\_api\_endpoint](#output\_gke\_cluster\_api\_endpoint) | cluster API endpoint |
| <a name="output_gke_cluster_ca_cert"></a> [gke\_cluster\_ca\_cert](#output\_gke\_cluster\_ca\_cert) | cluster CA certificate |
| <a name="output_gke_cluster_name"></a> [gke\_cluster\_name](#output\_gke\_cluster\_name) | cluster name |
| <a name="output_gke_control_plane_cidr"></a> [gke\_control\_plane\_cidr](#output\_gke\_control\_plane\_cidr) | ipv4 control plane cidr |
| <a name="output_gke_pods_ipv4_cidr_block"></a> [gke\_pods\_ipv4\_cidr\_block](#output\_gke\_pods\_ipv4\_cidr\_block) | ipv4 cidr block for pods running in the cluster |
| <a name="output_gke_service_account_email"></a> [gke\_service\_account\_email](#output\_gke\_service\_account\_email) | service account email |
| <a name="output_gke_services_ipv4_cidr_block"></a> [gke\_services\_ipv4\_cidr\_block](#output\_gke\_services\_ipv4\_cidr\_block) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a wa>

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
