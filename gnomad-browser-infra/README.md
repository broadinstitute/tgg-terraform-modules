# gnomAD browser infrastructure

This module configures the base set of cloud infrastructure for the [gnomAD Browser](https://gnomad.broadinstitute.org). At a high level, the module will result in a private GKE cluster with three node pools, and GCS buckets for operational tasks (data-pipeline input storage and Elasticsearch snapshot storage). A global public IP address which can be used as the address for the Ingress/LoadBalancer in front of the browser is also provisioned and the value is output at the end of the terraform run. A complete inventory of the created resources can be found in the [Resources](#resources) list below.

## Usage

This module can be used by including a module block in your terraform configuration, using a [github module source block](https://developer.hashicorp.com/terraform/language/modules/sources#github), and providing the [required inputs](#inputs):

```terraform
data "google_client_config" "tf_sa" {}

provider "kubernetes" {
  host  = "https://${module.gnomad-browser-infra.gke_cluster_api_endpoint}"
  token = data.google_client_config.tf_sa.access_token
  cluster_ca_certificate = base64decode(
    module.gnomad-browser-infra.gke_cluster_ca_cert,
  )
}

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

## Upgrading
### Breaking Changes in v1.0.0

The module was updated in 1.0.0 to handle the creation of a kubernetes configmap, a kubernetes service account, and the static IP reservation was removed from the module. In order for a pre-1.0 config to work, **before applying**, you need:

- To configure the kubernetes provider with the gnomad-browser-infra's authentication endpoint outputs, as documented above in [Usage](#usage)

- If they already exist, import the proxy-ips configmap and es-snaps service account into your configuration:

```bash
terraform import module.gnomad-browser-infra.kubernetes_service_account.es_snaps default/es-snaps
terraform import module.gnomad-browser-infra.kubernetes_config_map.gnomad_proxy_ips default/proxy-ips
```

- Move your static IP reservation outside of the module:
```
# create a global address resource to move state to
resource "google_compute_global_address" "my_static_ip" {
  name = "<YOUR INFRA PREFIX>-global-ip"
}

# then, in a shell
terraform state mv module.gnomad-browser-infra.google_compute_global_address.public_ingress google_compute_global_address.my_static_ip
```

### Networking / VPC
This module assumes that you have provisioned a VPC in your GCP project, with a subnet of an appropriate size to run the GKE cluster. That subnet must have two secondary ranges, one for the GKE pods, and one for the GKE services. The names of these ranges are the ones that should be passed in via the `gke_cluster_secondary_range_name` and `gke_services_secondary_range_name` respectively.

If you don't already have a VPC, the [gnomAD VPC](https://github.com/broadinstitute/tgg-terraform-modules/tree/main/gnomad-vpc) module in this repository can provision a VPC that looks like the one this module expects.

### Elasticsearch

This module provisions a service account (both GCP IAM and K8S service accounts) and GCS bucket for storing elasticsearch snapshots. The GKE cluster will be configured using [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity).

If you are using the [ECK Operator](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html), you should associate your Elasticsearch resources with the K8S service account by adding the following to your `podTemplate.spec`:

```yaml
automountServiceAccountToken: true
serviceAccountName: es-snaps
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.11.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.11.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gnomad-gke"></a> [gnomad-gke](#module\_gnomad-gke) | github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster | private-gke-cluster-v1.2.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.es_webbook](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_project_iam_member.data_pipeline_dataproc_worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.data_pipeline_service_consumer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.gnomad_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.gnomad_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.elastic_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.gene_cache](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.data_pipeline](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.es_snapshots](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.gene_cache](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [kubernetes_config_map.gnomad_proxy_ips](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/config_map) | resource |
| [kubernetes_service_account.es_snaps](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service_account) | resource |
| [kubernetes_service_account.gnomad_api](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service_account) | resource |
| [google_compute_subnetwork.gke_vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_pipeline_bucket_location"></a> [data\_pipeline\_bucket\_location](#input\_data\_pipeline\_bucket\_location) | The GCS location for the data-pipeline bucket | `string` | `"us-east1"` | no |
| <a name="input_es_snapshots_bucket_location"></a> [es\_snapshots\_bucket\_location](#input\_es\_snapshots\_bucket\_location) | The GCS location for the elasticsearch snapshots bucket | `string` | `"us-east1"` | no |
| <a name="input_gene_cache_bucket_location"></a> [gene\_cache\_bucket\_location](#input\_gene\_cache\_bucket\_location) | The GCS location for the JSON gene cache bucket | `string` | `"us-east1"` | no |
| <a name="input_gke_control_plane_authorized_networks"></a> [gke\_control\_plane\_authorized\_networks](#input\_gke\_control\_plane\_authorized\_networks) | The IPv4 CIDR ranges that should be allowed to connect to the control plane | `list(string)` | `[]` | no |
| <a name="input_gke_control_plane_zone"></a> [gke\_control\_plane\_zone](#input\_gke\_control\_plane\_zone) | The GCP zone where the GKE control plane will reside | `string` | `"us-east1-c"` | no |
| <a name="input_gke_maint_exclusions"></a> [gke\_maint\_exclusions](#input\_gke\_maint\_exclusions) | Specified times and dates that non-emergency GKE maintenance should pause | `list(map(string))` | `[]` | no |
| <a name="input_gke_node_pools"></a> [gke\_node\_pools](#input\_gke\_node\_pools) | A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane | <pre>list(object({<br/>    pool_name            = string<br/>    pool_num_nodes       = optional(number, 2)<br/>    pool_machine_type    = optional(string, "e2-medium")<br/>    pool_preemptible     = optional(bool, false)<br/>    pool_spot            = optional(bool, true)<br/>    pool_zone            = optional(string, "")<br/>    pool_resource_labels = optional(map(string), {})<br/>    pool_taints          = optional(list(object({ key = string, value = string, effect = string })), []),<br/>    pool_autoscaling     = optional(object({ min_pool_nodes = string, max_pool_nodes = string }))<br/>  }))</pre> | <pre>[<br/>  {<br/>    "pool_machine_type": "e2-standard-4",<br/>    "pool_name": "main-pool",<br/>    "pool_num_nodes": 2,<br/>    "pool_spot": false<br/>  },<br/>  {<br/>    "pool_machine_type": "e2-custom-6-49152",<br/>    "pool_name": "redis",<br/>    "pool_num_nodes": 1,<br/>    "pool_resource_labels": {<br/>      "component": "redis"<br/>    },<br/>    "pool_spot": false<br/>  },<br/>  {<br/>    "pool_machine_type": "e2-highmem-8",<br/>    "pool_name": "es-data",<br/>    "pool_num_nodes": 3,<br/>    "pool_resource_labels": {<br/>      "component": "elasticsearch"<br/>    },<br/>    "pool_spot": false,<br/>    "pool_zone": ""<br/>  }<br/>]</pre> | no |
| <a name="input_gke_pods_range_slice"></a> [gke\_pods\_range\_slice](#input\_gke\_pods\_range\_slice) | The full (e.g. 10.0.0.0/14) or simple (e.g. /14) CIDR range slice to assign for internal pod IP addresses | `string` | `"/14"` | no |
| <a name="input_gke_recurring_maint_windows"></a> [gke\_recurring\_maint\_windows](#input\_gke\_recurring\_maint\_windows) | A start time, end time and recurrence pattern for GKE automated maintenance windows | `list(map(string))` | <pre>[<br/>  {<br/>    "end_time": "1970-01-01T06:00:00Z",<br/>    "recurrence": "FREQ=DAILY",<br/>    "start_time": "1970-01-01T01:00:00Z"<br/>  }<br/>]</pre> | no |
| <a name="input_gke_services_range_slice"></a> [gke\_services\_range\_slice](#input\_gke\_services\_range\_slice) | The full (e.g. 10.0.0.0/20) or simple (e.g. /20) CIDR range slice to assign for internal service IP addresses | `string` | `"/20"` | no |
| <a name="input_infra_prefix"></a> [infra\_prefix](#input\_infra\_prefix) | The string to use for a prefix on resource names (GKE cluster, GCS Buckets, Service Accounts, etc) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The name of the target GCP project, for creating IAM memberships | `string` | n/a | yes |
| <a name="input_public_static_ip"></a> [public\_static\_ip](#input\_public\_static\_ip) | The public IP address that has been reserved for your browser | `string` | `null` | no |
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network that the GKE cluster should reside in | `string` | n/a | yes |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet that the GKE cluster nodes should reside in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_cluster_api_endpoint"></a> [gke\_cluster\_api\_endpoint](#output\_gke\_cluster\_api\_endpoint) | n/a |
| <a name="output_gke_cluster_ca_cert"></a> [gke\_cluster\_ca\_cert](#output\_gke\_cluster\_ca\_cert) | n/a |
| <a name="output_gke_cluster_name"></a> [gke\_cluster\_name](#output\_gke\_cluster\_name) | n/a |
| <a name="output_gke_pods_ipv4_cidr_block"></a> [gke\_pods\_ipv4\_cidr\_block](#output\_gke\_pods\_ipv4\_cidr\_block) | for obtaining the internal network value that should be set in gnomad's PROXY\_IPS env variable |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a way that has added, removed, or changed a variable, resource, or output, you can regenerate the `TF_DOCS` block with:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
