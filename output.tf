output "folder" {
  description = "All the exported attributes of the folder (map)."
  value       = google_folder.this
}

output "logging_sinks" {
  description = "All the exported attributes of the logging sinks, if created"
  value       = local.sink_output
}
