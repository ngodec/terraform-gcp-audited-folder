variable "folder_name" {
  type        = string
  description = "The name of the folder"
}

variable "parent_id" {
  description = "Id (numerical) of the parent folder or organization, in the format folders/12345 or organizations/6789"
  type        = string

  validation {
    condition     = can(regex("folders/\\d*|organizations/\\d*", var.parent_id))
    error_message = "Variable validation error: parent_id must be in the format folders/12345 or organizations/12345."
  }
}

variable "logging_project_id" {
  description = "Project id for the centralised logging project. If provided, enables creation of aggregated logging sinks. Project must exist. Use together with bigquery_logging_sink and/or storage_logging_sink"
  type        = string
  default     = null
}

variable "bigquery_logging_sink" {
  description = "If provided, will create a Logging Sink to a BQ dataset. Dataset must exist in logging_project_id."
  type = object({
    dataset_id = string
    filter     = string
    exclusions = list(object({
      name        = string
      description = string
      filter      = string
    }))
  })
  default = null
}

variable "storage_logging_sink" {
  description = "If provided, will create a Logging Sink to a GCS bucket. Bucket must exist in logging_project_id."
  type = object({
    bucket_name = string
    filter      = string
    exclusions = list(object({
      name        = string
      description = string
      filter      = string
    }))
  })
  default = null
}

variable "logging_access_level_name" {
  type        = string
  description = "If provided, an Access Level Condition will be added to this access level with the logging sink's Writer Identity"
  default     = null

  validation {
    condition     = var.logging_access_level_name == null || can(regex("accessPolicies/\\d*/accessLevels/\\w*", var.logging_access_level_name))
    error_message = "Variable validation error: Format of access_level_name is: accessPolicies/$POLICY_ID/accessLevels/$ACCESS_LEVEL_NAME."
  }
}

