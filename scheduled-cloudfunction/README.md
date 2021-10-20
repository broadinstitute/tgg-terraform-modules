# Scheduled Google Cloud Functions

This attempts to provide a reusable module for creating scheduled cloudfunctions as described here: https://cloud.google.com/scheduler/docs/tut-pub-sub

The idea is that you end up with a cloudscheduler schedule, which sends a message to a pub/sub queue that triggers the desired function. The module needs to be provided a service account email. The service accounts needs to have the IAM permissions required for running the function -- you are responsible for creating the service account, and granting it permissions.

## Required inputs

- `scheduled_function_name`: The name of your scheduled function, less than 32 characters in length.
- `scheduled_function_description`: The description of the function.
- `service_account_email`: The email address of a google service account. This SA must be granted any permissions required by the runtime of your function
- `function_entrypoint`: The function that cloudfunctions should invoke to run your code.
- `source_repository_url`: The google Source Repository URL where your code is hosted
- `cron_schedule`: The cron-syntax schedule that your function should run on.

## Example

```terraform
module "my-scheduled-cloudfunction" {
    source = "github.com/broadinstitute/tgg-terraform-modules//scheduled-cloudfunction?ref=v0.0.1"
    scheduled_function_name = "run-a-doodad"
    scheduled_function_description = "Runs a doodad that checks a thingamabob"
    service_account_email = "my-service-account-ex@iam.gserviceaccount.com"
    function_environment_variables = {
      GCP_PROJECT   = "${data.google_project.project.project_id}"
      SLACK_CHANNEL = "#doodad-notifications"
    }
    function_entrypoint = "run_routine"
    source_repository_url = "https://source.developers.google.com/projects/projectname/repos/github_broadinstitute_reponame/moveable-aliases/main/paths/functions/function_name"
    cron_schedule = "30 7 * * 1"
}
```
