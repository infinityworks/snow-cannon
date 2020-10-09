locals {
  state_bucket_name = "${var.project_name}-remote-state"
}

locals {
  lock_table_name = "${var.project_name}-lock-table"
}
