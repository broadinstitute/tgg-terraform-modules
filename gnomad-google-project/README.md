# gnomAD Terraform Project

This module is designed to easily spin up a google cloud project in a configuration that is suitable for typical gnomAD activities.

## Inventory

- Create a google project with a randomized suffix (this makes the project easier to delete and recreate if necessary)
- Enable frequently used APIs/Services:
  - Dataproc API
  - Cloudfunctions API
  - Storage API (if necessary)
- Create a VPC network to run resources in
- Add some default firewall rules to allow for traffic in our commonly used service scenarios
  - A firewall rule allowing SSH access to the networks from Broad IP ranges
  - A firewall rule allowing SSH access to GCE VMs from the google IAP service (for GCP console-based SSH sessions)
- Set a specified group as the owner of the project
- Grant the default compute service account permissions
  - compute.admin
  - dataproc.worker
  - storage.objectAdmin

## Configuring network access to VMs

Firewall rules that are created by this module work on the basis of tags:

- To allow dataproc nodes to communicate with eachother, ensure that your dataproc clusters are created with the 'dataproc-node' tag.
- To allow a VM to be accessed via SSH from Broad Institute networks (i.e. the office or the VPN), tag your instances/clusters with 'broad-ssh'

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default-project-services"></a> [default-project-services](#module\_default-project-services) | terraform-google-modules/project-factory/google//modules/project_services | 13.0.0 |
| <a name="module_project-services"></a> [project-services](#module\_project-services) | terraform-google-modules/project-factory/google//modules/project_services | 13.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_ssh_broad_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.dataproc_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.iap_forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.project_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_project.current_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_custom_role.bucket_list_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.default_compute_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.default_compute_bucket_list](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.default_compute_dataproc_worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.default_compute_object_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.default_compute_service_usage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.owner_group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.primary_iap_tunnel_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.primary_user_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_storage_bucket.general_use_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.tmp_4day_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_id.random_project_id_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_broad_inst_ssh_access"></a> [allow\_broad\_inst\_ssh\_access](#input\_allow\_broad\_inst\_ssh\_access) | Whether to create a firewall rule that allows access to TCP port 22 from Broad Institute networks. | `bool` | `true` | no |
| <a name="input_apis_to_enable"></a> [apis\_to\_enable](#input\_apis\_to\_enable) | The list of additional APIs to enable. We always enable dataproc and cloudfunctions. | `list(string)` | `[]` | no |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | The ID of the billing account that the project should be associated with. | `string` | n/a | yes |
| <a name="input_configure_dataproc_firewall_rules"></a> [configure\_dataproc\_firewall\_rules](#input\_configure\_dataproc\_firewall\_rules) | Whether we should configure firewall rules to allow all traffic between nodes tagged 'dataproc-node'. If you intend to use dataproc, you will need this. | `bool` | `true` | no |
| <a name="input_create_default_buckets"></a> [create\_default\_buckets](#input\_create\_default\_buckets) | Specifies whether to create default general-use and tmp with 4-day auto-delete lifecycle buckets. | `bool` | `true` | no |
| <a name="input_default_resource_region"></a> [default\_resource\_region](#input\_default\_resource\_region) | For managed items that require a region/location | `string` | `"us-central1"` | no |
| <a name="input_enable_default_services"></a> [enable\_default\_services](#input\_enable\_default\_services) | Whether or not to enable the default cloudfunction or dataproc services. Set to false if you don't want to enable these, or if you want to manage them via apis\_to\_enable. | `bool` | `true` | no |
| <a name="input_gcp_folder_id"></a> [gcp\_folder\_id](#input\_gcp\_folder\_id) | The ID numder of the GCP Organization folder to place the project in. | `string` | n/a | yes |
| <a name="input_owner_group_id"></a> [owner\_group\_id](#input\_owner\_group\_id) | The email address for the group you would like to grant Owner access on the project. | `string` | n/a | yes |
| <a name="input_primary_user_principal"></a> [primary\_user\_principal](#input\_primary\_user\_principal) | The primary user/group of the GCP project. This grants Editor access, and other permissions generally required to use services. Provide a IAM principal style {group/user/serviceAccount}:{email} string. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The string that should be used to create the unique ID google project; Will be suffixed with a random identifier. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The human readable name of the project. Does not need to be unique. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_identifier"></a> [project\_identifier](#output\_project\_identifier) | n/a |
<!-- END_TF_DOCS -->
