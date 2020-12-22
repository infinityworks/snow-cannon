locals {
  formatted_name = replace(replace(upper(var.name), "-", "_"), "/", "_")
}

locals {
  query = "SELECT ${var.columns} FROM ${var.database}.${var.schema}.${var.table} ${var.group_by_and_having_statement}"
}
