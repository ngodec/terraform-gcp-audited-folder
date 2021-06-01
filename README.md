# terraform-gcp-audited-folder
Terraform module to deploy a GCP folder with optional configurable BigQuery logging sink


```
module "folder" {
  name = "My Folder"
  parent = "123456"
  logging_sinks = [
    {
      destination = "bigquery"
      log_storage_region  = "europe-west2"
      log_expiration_milliseconds = "1234567"
      sink_exclusions = {
        "exclude-k8s-composer" = {
          description = "Exclude k8s and Cloud Composer system logs"
          filter      = "resource.type=\"cloud_composer_environment\" OR protoPayload.serviceName=~\"k8s.io\""
          disabled    = false
        }
      }
    }
  ]
  allow_cross_perimeter_logging = {
    access_level_name = "accessPolicies/$POLICY_ID/accessLevels/$ACCESS_LEVEL_NAME"
  }
}
```

Or, for a non-audited folder:

```
module "folder" {
  name = "My Folder"
  parent = "123456"
}
```
