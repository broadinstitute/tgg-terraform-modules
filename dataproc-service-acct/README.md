# Dataproc Service Accounts

To allow users to run dataproc in a GCP project with limited access to storage, we need to provide several things:

- A service account to run the dataproc cluster with, so that the user doesn't need access to the default compute service account
- An IAM grant that allows the user to ActAs that service account
- stage and temp buckets for dataproc, which the service account and user both have write access to

## Inputs

- We need the user principal
- We need the name / id that we should use for the service account
- We need the name of the two buckets (or, maybe just a single prefix to use for both)

## Outputs

This module returns:
- the email address of the new service account
- The names of the two buckets


With this information, you should:

- Grant the least-privileged dataproc worker role to the service account
- Grant the user dataproc.editor
- Grant the user and service accounts the storage access that they need
