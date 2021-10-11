resource "google_logging_folder_sink" "to_bigquery" {
  count            = var.logging_project_id != null && var.bigquery_logging_sink != null ? 1 : 0
  name             = "${lower(replace(var.folder_name, " ", "-"))}-sink-bq"
  description      = "Folder sink of ${var.folder_name} to BigQuery dataset ${var.bigquery_logging_sink.dataset_id} in project ${var.logging_project_id}"
  folder           = google_folder.this.name
  include_children = true

  destination = "bigquery.googleapis.com/projects/${var.logging_project_id}/datasets/${var.bigquery_logging_sink.dataset_id}"

  bigquery_options {
    use_partitioned_tables = true
  }

  filter = var.bigquery_logging_sink.filter

  dynamic "exclusions" {
    for_each = var.bigquery_logging_sink.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = false
    }
  }
}

resource "google_logging_folder_sink" "to_storage" {
  count            = var.logging_project_id != null && var.storage_logging_sink != null ? 1 : 0
  name             = "${lower(replace(var.folder_name, " ", "-"))}-sink-gcs"
  description      = "Folder sink of ${var.folder_name} to GCS bucket ${var.storage_logging_sink.bucket_name} in project ${var.logging_project_id}"
  folder           = google_folder.this.name
  include_children = true

  destination = "storage.googleapis.com/${var.storage_logging_sink.bucket_name}"

  filter = var.storage_logging_sink.filter

  dynamic "exclusions" {
    for_each = var.storage_logging_sink.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = false
    }
  }
}

