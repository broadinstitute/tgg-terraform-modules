# gnomAD browser infrastructure

This module configures the base set of cloud infrastructure for the [gnomAD Browser](https://gnomad.broadinstitute.org). At a high level, the module will result in a private GKE cluster with three node pools, and GCS buckets for operational tasks (data-pipeline input storage and Elasticsearch snapshot storage). A global public IP address which can be used as the address for the Ingress/LoadBalancer in front of the browser is also provisioned and the value is output at the end of the terraform run. A complete inventory of the created resources can be found in the [Resources](#resources) list below.

## Usage

This module can be used by including a module block in your terraform configuration, using a [github module source block](https://developer.hashicorp.com/terraform/language/modules/sources#github), and providing the [required inputs](#inputs):

```terraform
module "gnomad-browser-infra" {
  source = "github.com/broadinstitute/tgg-terraform-modules//gnomad-browser-infra?ref=<git commit SHA ID or Tag>"
  infra_prefix = "my-gnomad-browser"
  project_id = "my-gcp-project"
  vpc_network_name = "my-vpc-network"
  vpc_subnet_name = "my-vpc-subnet"
  gke_control_plane_zone = "us-central1-c"
  gke_control_plane_cidr_range = "172.16.8.32/28"
}
```

This module assumes that you have provisioned a VPC in your GCP project, with a subnet of an appropriate size to run the GKE cluster (A minimum of 8 available IP addresses are needed in the subnet, though larger is highly recommended).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.es_webbook](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.public_ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_container_cluster.browser_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.es_data_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.main_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.redis_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.data_pipeline_dataproc_worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.data_pipeline_service_consumer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.gke_nodes_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.gke_cluster_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.elastic_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_pipeline_bucket_location"></a> [data\_pipeline\_bucket\_location](#input\_data\_pipeline\_bucket\_location) | The GCS location for the data-pipeline bucket | `string` | `"us-east1"` | no |
| <a name="input_es_snapshots_bucket_location"></a> [es\_snapshots\_bucket\_location](#input\_es\_snapshots\_bucket\_location) | The GCS location for the elasticsearch snapshots bucket | `string` | `"us-east1"` | no |
| <a name="input_gke_cluster_secondary_range_name"></a> [gke\_cluster\_secondary\_range\_name](#input\_gke\_cluster\_secondary\_range\_name) | The name of the secondary subnet IP range to use for Pods in the GKE cluster | `string` | `"gke-pods"` | no |
| <a name="input_gke_control_plane_authorized_networks"></a> [gke\_control\_plane\_authorized\_networks](#input\_gke\_control\_plane\_authorized\_networks) | The IPv4 CIDR ranges that should be allowed to connect to the control plane | `list(string)` | `[]` | no |
| <a name="input_gke_control_plane_cidr_range"></a> [gke\_control\_plane\_cidr\_range](#input\_gke\_control\_plane\_cidr\_range) | The IPv4 CIDR Range that should be used for the GKE control plane | `string` | n/a | yes |
| <a name="input_gke_control_plane_zone"></a> [gke\_control\_plane\_zone](#input\_gke\_control\_plane\_zone) | The GCP zone where the GKE control plane will reside | `string` | n/a | yes |
| <a name="input_gke_es_data_pool_machine_type"></a> [gke\_es\_data\_pool\_machine\_type](#input\_gke\_es\_data\_pool\_machine\_type) | The GCE machine type that should be used for the elasticsearch data GKE node pool | `string` | `"e2-highmem-8"` | no |
| <a name="input_gke_es_data_pool_num_nodes"></a> [gke\_es\_data\_pool\_num\_nodes](#input\_gke\_es\_data\_pool\_num\_nodes) | The number of nodes that the elasticsearch data GKE node pool should contain | `number` | `3` | no |
| <a name="input_gke_es_data_pool_zone"></a> [gke\_es\_data\_pool\_zone](#input\_gke\_es\_data\_pool\_zone) | The zone where the GKE Main pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane | `string` | `""` | no |
| <a name="input_gke_include_broad_inst_authorized_networks"></a> [gke\_include\_broad\_inst\_authorized\_networks](#input\_gke\_include\_broad\_inst\_authorized\_networks) | Include the Broad Institute network ranges in the GKE control plane authorized networks | `bool` | `false` | no |
| <a name="input_gke_main_pool_machine_type"></a> [gke\_main\_pool\_machine\_type](#input\_gke\_main\_pool\_machine\_type) | The GCE machine type that should be used for the main/default GKE node pool | `string` | `"e2-standard-4"` | no |
| <a name="input_gke_main_pool_num_nodes"></a> [gke\_main\_pool\_num\_nodes](#input\_gke\_main\_pool\_num\_nodes) | The number of nodes that the main/default GKE node pool should contain | `number` | `2` | no |
| <a name="input_gke_main_pool_zone"></a> [gke\_main\_pool\_zone](#input\_gke\_main\_pool\_zone) | The zone where the GKE Main pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane | `string` | `""` | no |
| <a name="input_gke_maint_exclusions"></a> [gke\_maint\_exclusions](#input\_gke\_maint\_exclusions) | Specified times and dates that non-emergency GKE maintenance should pause | `list(map(string))` | `[]` | no |
| <a name="input_gke_recurring_maint_windows"></a> [gke\_recurring\_maint\_windows](#input\_gke\_recurring\_maint\_windows) | A start time, end time and recurrence pattern for GKE automated maintenance windows | `list(map(string))` | <pre>[<br>  {<br>    "end_time": "1970-01-01T11:00:00Z",<br>    "recurrence": "FREQ=DAILY",<br>    "start_time": "1970-01-01T07:00:00Z"<br>  }<br>]</pre> | no |
| <a name="input_gke_redis_pool_machine_type"></a> [gke\_redis\_pool\_machine\_type](#input\_gke\_redis\_pool\_machine\_type) | The GCE machine type that should be used for the redis GKE node pool | `string` | `"e2-custom-6-49152"` | no |
| <a name="input_gke_redis_pool_num_nodes"></a> [gke\_redis\_pool\_num\_nodes](#input\_gke\_redis\_pool\_num\_nodes) | The number of nodes that the redis GKE node pool should contain | `number` | `1` | no |
| <a name="input_gke_redis_pool_zone"></a> [gke\_redis\_pool\_zone](#input\_gke\_redis\_pool\_zone) | The zone where the GKE Redis pool should be launched. Leaving this unspecified will result in the pool being launched in the same zone as the control plane | `string` | `""` | no |
| <a name="input_gke_services_secondary_range_name"></a> [gke\_services\_secondary\_range\_name](#input\_gke\_services\_secondary\_range\_name) | The name of the secondary subnet IP range to use for GKE services | `string` | `"gke-services"` | no |
| <a name="input_infra_prefix"></a> [infra\_prefix](#input\_infra\_prefix) | The string to use for a prefix on resource names (GKE cluster, GCS Buckets, Service Accounts, etc) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The name of the target GCP project, for creating IAM memberships | `string` | n/a | yes |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network that the GKE cluster should reside in | `string` | n/a | yes |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet that the GKE cluster nodes should reside in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_cluster_name"></a> [gke\_cluster\_name](#output\_gke\_cluster\_name) | n/a |
| <a name="output_public_web_address"></a> [public\_web\_address](#output\_public\_web\_address) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a way that has added, removed, or changed a variable, resource, or output, you can regenerate the `TF_DOCS` block with:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
