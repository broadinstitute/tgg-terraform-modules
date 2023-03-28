# Provide a GKE cluster with private networking


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
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
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | The name of the GKE cluster you want to manage | `string` | n/a | yes |
| <a name="input_gke_control_plane_zone"></a> [gke\_control\_plane\_zone](#input\_gke\_control\_plane\_zone) | The zone to launch the GKE cluster in | `string` | `"us-central1-c"` | no |
| <a name="input_gke_master_ipv4_cidr_block"></a> [gke\_master\_ipv4\_cidr\_block](#input\_gke\_master\_ipv4\_cidr\_block) | The IPv4 CIDR Range (RFC1918) that should be used for the control plane | `string` | `"172.16.0.0/28"` | no |
| <a name="input_gke_pods_range_name"></a> [gke\_pods\_range\_name](#input\_gke\_pods\_range\_name) | The name of the secondary subnet range to use for gke pods | `string` | `"gke-pods"` | no |
| <a name="input_gke_services_range_name"></a> [gke\_services\_range\_name](#input\_gke\_services\_range\_name) | The name of the secondary subnet range to use for gke services | `string` | `"gke-services"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane | <pre>list(object({<br>    pool_name            = string<br>    pool_num_nodes       = number<br>    pool_machine_type    = string<br>    pool_preemptible     = bool<br>    pool_zone            = string<br>    pool_resource_labels = map(string)<br>  }))</pre> | <pre>[<br>  {<br>    "pool_machine_type": "e2-medium",<br>    "pool_name": "main-pool",<br>    "pool_num_nodes": 2,<br>    "pool_preemptible": true,<br>    "pool_resource_labels": {},<br>    "pool_zone": ""<br>  }<br>]</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the gcp project the cluster is launching in | `string` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel name for the GKE cluster | `string` | `"STABLE"` | no |
| <a name="input_resource_labels"></a> [resource\_labels](#input\_resource\_labels) | A map of string values to use as resource labels on all cluster objects. | `map(string)` | `{}` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network to launch the cluster in | `string` | `"default"` | no |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet to launch the cluster in | `string` | `"default"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a wa>

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
