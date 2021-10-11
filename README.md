# terraform-gcp-audited-folder
Terraform module to deploy a GCP folder with optional configurable logging sink.

Log destination options are:

- BigQuery dataset
- GCS bucket


```
module "folder" {
  source = "git@github.com:ngodec/terraform-gcp-audited-folder.git"
  folder_name = "My Folder"
  parent_id = "folders/123456"
  logging_project_id = "audit-logs-prod"
  bigquery_logging_sink = {
      dataset_id = "logs"
      filter = ""
      exclusions = [
        {          name = "exclude_k8s_composer"
          description = "Exclude k8s and Cloud Composer system logs"
          filter      = "resource.type=\"cloud_composer_environment\" OR protoPayload.serviceName=~\"k8s.io\""
        }
      ]
    }
  logging_access_level_name = "accessPolicies/$POLICY_ID/accessLevels/$ACCESS_LEVEL_NAME"
}
```

Or, for a non-audited folder:

```
module "folder" {
  name = "My Folder"
  parent = "folders/123456"
}
```
