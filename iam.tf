resource "google_bigquery_dataset_iam_member" "member" {
  count   = var.logging_project_id != null && var.bigquery_logging_sink != null ? 1 : 0
  project = var.logging_project_id

  dataset_id = var.bigquery_logging_sink.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_folder_sink.to_bigquery[0].writer_identity
}

resource "google_storage_bucket_iam_member" "member" {
  count  = var.logging_project_id != null && var.storage_logging_sink != null ? 1 : 0
  bucket = var.storage_logging_sink.bucket_name
  role   = "roles/storage.admin"
  member = google_logging_folder_sink.to_storage[0].writer_identity
}
