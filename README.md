# terraform-gcp-audited-folder
Terraform module to deploy a GCP folder with optional configurable logging sink.

Log destination options are:

- BigQuery dataset
- GCS bucket

## Prerequisites

You need a Google Cloud Organization to work with Google Folders.

### Prerequisites for aggregated logging:

1. For Audit Logs, enable audit in your projects
2. Decide with GCP project will host your aggregated logs (your `logging project`).
3. For Logging Sink to BigQuery, create a dataset in the logging project.
4. For Logging Sink go Google Cloud Storage, create a bucket in the logging project.
5. If you are using VPC Service Controls, and the logging project is in a perimeter, create an Access Level to which this module will attach Access Level Conditions for the logging sink to work. 

## Examples

Deploy a folder with a logging sink to BigQuery, with GKE and Cloud Composer logs excluded from the sink:
```
module "folder" {
  source = "git@github.com:ngodec/terraform-gcp-audited-folder.git"
  folder_name        = "My Folder"
  parent_id          = "folders/123456"
  logging_project_id = "audit-logs-prod"
  bigquery_logging_sink = {
      dataset_id = "logs"
      filter     = ""
      exclusions = [
        {
          name        = "exclude_k8s_composer"
          description = "Exclude k8s and Cloud Composer system logs"
          filter      = "resource.type=\"cloud_composer_environment\" OR protoPayload.serviceName=~\"k8s.io\""
        }
      ]
    }
  logging_access_level_name = "accessPolicies/${var.policy_number}/accessLevels/${var.logging_access_level_name}"
}
```

Deploy a folder without logging sinks:

```
module "folder" {
  source = "git@github.com:ngodec/terraform-gcp-audited-folder.git"
  name   = "My Folder"
  parent = "folders/123456"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| folder\_name | The name of the folder | string | n/a | yes |
| parent\_id | Id (numerical) of the parent folder or organization, in the format folders/12345 or organizations/6789 | string | n/a | yes |
| bigquery\_logging\_sink | If provided, will create a Logging Sink to a BQ dataset. Dataset must exist in logging_project_id. | object | `"null"` | no |
| logging\_access\_level\_name | If provided, an Access Level Condition will be added to this access level with the logging sink's Writer Identity | string | `"null"` | no |
| logging\_project\_id | Project id for the centralised logging project. If provided, enables creation of aggregated logging sinks. Project must exist. Use together with bigquery_logging_sink and/or storage_logging_sink | string | `"null"` | no |
| storage\_logging\_sink | If provided, will create a Logging Sink to a GCS bucket. Bucket must exist in logging_project_id. | object | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| folder | All the exported attributes of the folder (map). |
| logging\_sinks | All the exported attributes of the logging sinks, if created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
