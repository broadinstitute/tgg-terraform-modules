# Scheduled Google Cloud Functions

This modules creates the resources necessary to deploy a cloud scheduler triggered cloudfunction. The outputs include the following information that is necessary for deploying a cloudfunction via something like GitHub Actions:

- the name we expect the function to use
- the service account ID that the function will use at runtime
- the service account ID that the github action will authenticate as for deployment
- the name of the pub/sub trigger topic

## Upgrading

### Breaking changes for v1.0.0

As of v1.0.0, this module no longer creates a cloudfunction for you. It only configures the necessary resources to run and trigger a cloudfunction which you deploy by other means. This is because deploying functions via terraform was janky, and we usually had a github action/cloudbuild trigger to update the function anyway. The module now also creates a service account on your behalf, and no longer requires one to be provided ahead of time.

It's recommended that you delete any pre-v1.0.0 deployments of this module, apply v1.0.0, and then update your github deployment actions to use the new service account and trigger topic configuration that it generates.

## Example

```terraform
module "my_scheduled_cloudfunction" {
    source = "github.com/broadinstitute/tgg-terraform-modules//scheduled-cloudfunction?ref=v1.0.0"
    scheduled_function_name = "run-a-doodad"
    cloudbuild_service_account_email = "cloubuild@myproj.iam.gserviceaccount.com"
    cron_schedule = "30 7 * * 1"
    required_gcp_secrets = ["my-slack-token-gcp-secret-name", "database-password-secret-name"]
    service_account_roles = ["roles/storage.objectViewer", "roles/monitoring.viewer"]
    project_id = "my-gcp-project"
}
```

## Workload Identity Federation

This module configures workload identity federation with GitHub Actions, to allow the github action to authenticate for function deployment. The default set of conditions that governs what actions will be able to do things is: Only commits to `refs/heads/main` on the [gnomAD storage monitoring](https://github.com/broadinstitute/gnomad-storage-monitoring) repository will be allowed to authenticate.

If you need to use another branch / repository, adjust the `workload_identity_attr_condition` (the assertion rule) and the `workload_identity_attr` (the target repository) accordingly.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.42.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gh_oidc_wif"></a> [gh\_oidc\_wif](#module\_gh\_oidc\_wif) | terraform-google-modules/github-actions-runners/google//modules/gh-oidc | 3.1.1 |

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.cloud_scheduler_schedule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_project_iam_member.deployment_service_account_project_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.service_account_project_permissions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_pubsub_topic.scheduled_function_trigger_topic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_secret_manager_secret_iam_member.function_secret_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_service_account.deployment_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.scheduled_function_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.cloudbuild_impersonate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.deployer_impersonate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudbuild_service_account_email"></a> [cloudbuild\_service\_account\_email](#input\_cloudbuild\_service\_account\_email) | The email address of the cloudbuild service account | `string` | n/a | yes |
| <a name="input_cron_schedule"></a> [cron\_schedule](#input\_cron\_schedule) | A string representing the cron-format schedule for which to trigger the cloud function | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id of the project in which to create the scheduled function | `string` | n/a | yes |
| <a name="input_required_gcp_secrets"></a> [required\_gcp\_secrets](#input\_required\_gcp\_secrets) | A list of the names of GCP Secret Manager secrets that the scheudled function requires to run | `list(string)` | `[]` | no |
| <a name="input_scheduled_function_name"></a> [scheduled\_function\_name](#input\_scheduled\_function\_name) | The string that should be used to create resources associated with the module, svc account, pubsub queue, etc | `string` | n/a | yes |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | A list of roles to assign to the service account created for the scheduled function | `list(string)` | <pre>[<br>  "roles/cloudfunctions.invoker"<br>]</pre> | no |
| <a name="input_workload_identity_attr"></a> [workload\_identity\_attr](#input\_workload\_identity\_attr) | value of the workload identity attribute to use for the scheduled function workload identity mapping | `string` | `"attribute.repository/broadinstitute/gnomad-storage-monitoring"` | no |
| <a name="input_workload_identity_attr_condition"></a> [workload\_identity\_attr\_condition](#input\_workload\_identity\_attr\_condition) | The workload identity attribute condition to use for the scheduled function workload identity mapping | `string` | `"assertion.ref=='refs/heads/main'"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_service_account_member"></a> [deployment\_service\_account\_member](#output\_deployment\_service\_account\_member) | n/a |
| <a name="output_scheduled_function_name"></a> [scheduled\_function\_name](#output\_scheduled\_function\_name) | n/a |
| <a name="output_scheduled_function_trigger_topic"></a> [scheduled\_function\_trigger\_topic](#output\_scheduled\_function\_trigger\_topic) | n/a |
| <a name="output_service_account_member"></a> [service\_account\_member](#output\_service\_account\_member) | n/a |
<!-- END_TF_DOCS -->
