# gnomAD browser infrastructure

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.browser_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.main_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.gke_nodes_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.gke_cluster_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_cluster_secondary_range_name"></a> [gke\_cluster\_secondary\_range\_name](#input\_gke\_cluster\_secondary\_range\_name) | The name of the secondary subnet IP range to use for Pods in the GKE cluster | `string` | `"gke-pods"` | no |
| <a name="input_gke_control_plane_cidr_range"></a> [gke\_control\_plane\_cidr\_range](#input\_gke\_control\_plane\_cidr\_range) | The IPv4 CIDR Range that should be used for the GKE control plane | `string` | n/a | yes |
| <a name="input_gke_control_plane_zone"></a> [gke\_control\_plane\_zone](#input\_gke\_control\_plane\_zone) | The GCP zone where the GKE control plane will reside. | `string` | n/a | yes |
| <a name="input_gke_main_pool_machine_type"></a> [gke\_main\_pool\_machine\_type](#input\_gke\_main\_pool\_machine\_type) | The GCE machine type that should be used for the main/default GKE node pool | `string` | `"e2-standard-4"` | no |
| <a name="input_gke_main_pool_num_nodes"></a> [gke\_main\_pool\_num\_nodes](#input\_gke\_main\_pool\_num\_nodes) | The number of nodes that the main/default GKE node pool should contain | `number` | n/a | yes |
| <a name="input_gke_main_pool_zone"></a> [gke\_main\_pool\_zone](#input\_gke\_main\_pool\_zone) | The zone where the GKE Main pool should be launched | `string` | `""` | no |
| <a name="input_gke_services_secondary_range_name"></a> [gke\_services\_secondary\_range\_name](#input\_gke\_services\_secondary\_range\_name) | The name of the secondary subnet IP range to use for GKE services | `string` | `"gke-services"` | no |
| <a name="input_infra_prefix"></a> [infra\_prefix](#input\_infra\_prefix) | The string to use for a prefix on resource names (GKE cluster, GCS Buckets, Service Accounts, etc) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The name of the target GCP project, for creating IAM memberships. | `any` | n/a | yes |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network that the GKE cluster should reside in. | `string` | n/a | yes |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet that the GKE cluster nodes should reside in. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
