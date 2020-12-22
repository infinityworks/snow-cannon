resource "snowflake_task" "export_data_to_s3" {
  name               = local.formatted_name
  database           = var.database
  schema             = var.schema
  sql_statement      = "copy into @${var.external_stage}/${var.export_filename} from (${local.query}) file_format = ${var.file_format} ${var.copy_parameters}"
  schedule           = var.schedule
  session_parameters = var.session_parameters
  warehouse          = var.warehouse
  enabled            = var.enabled
  comment            = var.comment
}
