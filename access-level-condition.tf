resource "google_access_context_manager_access_level_condition" "access-level-condition" {
  count        = var.logging_access_level_name != null ? 1 : 0
  access_level = var.logging_access_level_name
  members      = tolist(local.sink_output.*.writer_identity)
}
