locals {

  ####### LOGGING SINK LOCALS #########

  bigquery_sink = var.logging_project_id != null && var.bigquery_logging_sink != null ? google_logging_folder_sink.to_bigquery : []
  storage_sink  = var.logging_project_id != null && var.storage_logging_sink != null ? google_logging_folder_sink.to_storage : []
  sink_output   = flatten(concat(local.bigquery_sink, local.storage_sink, []))

}
