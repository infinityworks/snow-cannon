resource "null_resource" "create_snowflake_table" {

  provisioner "local-exec" {
    command = <<EOT
{
      snowsql --accountname $SNOWFLAKE_ACCOUNT.$SNOWFLAKE_REGION --username $SNOWFLAKE_USER --rolename SYSADMIN --query 'CREATE TABLE IF NOT EXISTS ${var.database}.${var.schema}.${local.formatted_s3_path} ${local.formatted_rows}' || \
      (echo 'Make sure $SNOWFLAKE_ACCOUNT, $SNOWFLAKE_REGION and $SNOWFLAKE_USER env vars are set and the snowsql tool is on the path'; exit 1;)
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

resource "snowflake_pipe" "create_pipe" {
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
  --queue ${snowflake_pipe.create_pipe.notification_channel} \
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
