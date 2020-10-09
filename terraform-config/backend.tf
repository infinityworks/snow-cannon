locals {
  state_bucket_name = "${var.project_name}-remote-state-${terraform.workspace}"
}

locals {
  lock_table_name = "${var.project_name}-lock-table"
}
