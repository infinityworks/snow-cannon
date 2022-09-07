locals {
  formatted_s3_path = upper(replace(replace(var.s3_path, "-", "_"), "/", "_"))

  csv_table_def  = var.file_format == "CSV" ? csvdecode(file("table-definition.csv")) : []
  table_def      = var.file_format == "CSV" ? formatlist("%s %s", local.csv_table_def[*].field, local.csv_table_def[*].type) : []
  table_rows     = var.file_format == "CSV" ? "(${join(", ", local.table_def)}, LOAD_TIMESTAMP timestamp)" : "(RAW_DATA variant, LOAD_TIMESTAMP timestamp)"
  formatted_rows = upper(local.table_rows)
  copy_command   = var.file_format == "CSV" ? join(", ", formatlist("$%s", range(1, length(local.table_def) + 1))) : "$1"

  filter_prefix = var.has_key == false ? "" : var.s3_path

  record_delimiter = var.record_delimiter != "" ? "record_delimiter = '${var.record_delimiter}'" : ""
  field_delimiter  = var.field_delimiter != "" ? "field_delimiter = '${var.field_delimiter}'" : ""
  delimiter        = join(" ", [local.record_delimiter, local.field_delimiter])

  skip_header   = var.skip_header != 0 ? "skip_header = ${var.skip_header}" : ""
  date_format   = var.date_format != "" ? "date_format = '${var.date_format}'" : ""
  validate_utf8 = var.validate_utf8 == false ? "validate_UTF8=false" : ""
}
