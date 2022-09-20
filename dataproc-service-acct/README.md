# Dataproc Service Accounts

To allow users to run dataproc in a GCP project with limited access to storage, we need to provide several things:

- A service account to run the dataproc cluster with, so that the user doesn't need access to the default compute service account
- An IAM grant that allows the user to ActAs that service account
- stage and temp buckets for dataproc, which the service account and user both have write access to

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
| [google_project_iam_member.grant_dataproc_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.dataproc_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.grant_sa_usage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_storage_bucket.user_dataproc_stage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.user_dataproc_temp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.dataproc_sa_stage_write](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.dataproc_sa_temp_write](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.grant_user_dataproc_stage_write](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.grant_user_dataproc_temp_write](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dataproc_bucket_prefix"></a> [dataproc\_bucket\_prefix](#input\_dataproc\_bucket\_prefix) | The prefix that we should use for the names of the stage and temp buckets for Dataproc. | `string` | n/a | yes |
| <a name="input_force_destroy_user_dataproc_buckets"></a> [force\_destroy\_user\_dataproc\_buckets](#input\_force\_destroy\_user\_dataproc\_buckets) | n/a | `bool` | `false` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | The display name of the service account that we are going to create | `string` | n/a | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The name that we should use as the username portion of the service account email address | `string` | n/a | yes |
| <a name="input_user_principal"></a> [user\_principal](#input\_user\_principal) | The email address of the user we'd like to grant access to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataproc_stage_bucket_name"></a> [dataproc\_stage\_bucket\_name](#output\_dataproc\_stage\_bucket\_name) | n/a |
| <a name="output_dataproc_temp_bucket_name"></a> [dataproc\_temp\_bucket\_name](#output\_dataproc\_temp\_bucket\_name) | n/a |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | n/a |
<!-- END_TF_DOCS -->
