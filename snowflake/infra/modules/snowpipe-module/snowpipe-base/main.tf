locals {
  formatted_s3_path = upper(replace(replace(var.s3_path, "-", "_"), "/", "_"))

  csv_table_def  = "${var.file_format == "CSV" ? csvdecode(file("table-definition.csv")) : []}"
  table_def      = "${var.file_format == "CSV" ? formatlist("%s %s", local.csv_table_def[*].field, local.csv_table_def[*].type) : []}"
  table_rows     = "${var.file_format == "CSV" ? "(${join(", ", local.table_def)}, LOAD_TIMESTAMP timestamp)" : "(RAW_DATA variant, LOAD_TIMESTAMP timestamp)"}"
  formatted_rows = upper(local.table_rows)
  copy_command   = "${var.file_format == "CSV" ? join(", ", formatlist("$%s", range(1, length(local.table_def) + 1))) : "$1"}"

  filter_prefix = "${var.has_key == false ? "" : var.s3_path}"

  record_delimiter = "${var.record_delimiter != "" ? "record_delimiter = '${var.record_delimiter}'" : ""}"
  field_delimiter  = "${var.field_delimiter != "" ? "field_delimiter = '${var.field_delimiter}'" : ""}"
  delimiter        = join(" ", [local.record_delimiter, local.field_delimiter])

  skip_header   = "${var.skip_header != 0 ? "skip_header = ${var.skip_header}" : ""}"
  date_format   = "${var.date_format != "" ? "date_format = '${var.date_format}'" : ""}"
  validate_utf8 = "${var.validate_utf8 == false ? "validate_UTF8=false" : ""}"
}

resource "null_resource" "create_snowflake_table" {

  provisioner "local-exec" {
    command = <<EOT
{
      snowsql -a $SNOWFLAKE_ACCOUNT -u $SNOWFLAKE_USER --query 'CREATE TABLE IF NOT EXISTS ${var.database}.${var.schema}.${local.formatted_s3_path} ${local.formatted_rows}' || \
      echo 'Make sure $SNOWFLAKE_ACCOUNT and $SNOWFLAKE_USER env vars are set'
}
EOT
  }
}

resource "null_resource" "wait_for_iam_instantiation" {
  depends_on = [null_resource.create_snowflake_table]
  provisioner "local-exec" {
    command = "echo 'Wait for IAM role instantiation' && sleep 10"
  }
}

resource "snowflake_pipe" "pipe_event_data" {
  depends_on     = [null_resource.wait_for_iam_instantiation]
  name           = "${local.formatted_s3_path}_DATA_PIPE"
  auto_ingest    = "true"
  database       = var.database
  schema         = var.schema
  copy_statement = "COPY INTO ${var.database}.${var.schema}.${local.formatted_s3_path} from ( SELECT ${local.copy_command}, TO_TIMESTAMP_NTZ(current_timestamp) FROM @${var.database}.${var.schema}.${var.external_stage_name}) file_format = (type = '${var.file_format}' ${local.delimiter} ${local.skip_header} ${local.date_format}  ${local.validate_utf8})"
  comment        = "Pipe to ingest ${var.s3_path} data from ${var.s3_bucket_name} into ${var.database}.${var.schema}.${local.formatted_s3_path}"
}

resource "null_resource" "update_s3_bucket_notification" {

  triggers = {
    bucket  = var.s3_bucket_name
    s3_path = var.s3_path
  }

  provisioner "local-exec" {
    command = <<EOT
{
 python3 ${path.module}/set-bucket-notification.py --s3_key ${var.s3_path} \
  --bucket ${var.s3_bucket_name} \
  --queue ${snowflake_pipe.pipe_event_data.notification_channel} \
  --prefix ${local.filter_prefix} --suffix ${var.filter_suffix}
}
EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
{
 python3 ${path.module}/destroy-bucket-notification.py --s3_key ${self.triggers.s3_path} \
  --bucket ${self.triggers.bucket}
}
EOT
  }
}