# tgg-atlantis

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.18.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 5.18.3 |
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlantis-gke"></a> [atlantis-gke](#module\_atlantis-gke) | github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster | bc1853e79f848c52ae014cf0210f78fa9fc8481c |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.atlantis_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_security_policy.argocd_cloudarmor_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_security_policy) | resource |
| [google_compute_security_policy.atlantis_cloudarmor_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_security_policy) | resource |
| [google_service_account.atlantis_runner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.atlantis_identity](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [github_ip_ranges.github_hook_ips](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/ip_ranges) | data source |
| [google_storage_bucket_object_content.broad_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_network_name"></a> [vpc\_network\_name](#input\_vpc\_network\_name) | The name of the VPC network to deploy atlantis in | `string` | `"atlantis"` | no |
| <a name="input_vpc_subnet_name"></a> [vpc\_subnet\_name](#input\_vpc\_subnet\_name) | The name of the VPC network subnet to deploy atlantis in | `string` | `"atlantis"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgg_atlantis_ip"></a> [tgg\_atlantis\_ip](#output\_tgg\_atlantis\_ip) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a wa>

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
