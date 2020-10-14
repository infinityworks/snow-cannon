module "create_external_stage" {
  source               = "../stages-module/"
  s3_bucket_name       = var.s3_bucket_name
  s3_path              = var.s3_path
  has_key              = var.has_key
  database             = var.database
  schema               = var.schema
  permissions_boundary = var.permissions_boundary
  path                 = var.path
}

module "create_snowpipe" {
  source              = "./snowpipe-base/"
  s3_bucket_name      = var.s3_bucket_name
  s3_path             = var.s3_path
  has_key             = var.has_key
  filter_suffix       = var.filter_suffix
  database            = var.database
  schema              = var.schema
  external_stage_name = module.create_external_stage.external_stage_name
  file_format         = var.file_format
  record_delimiter    = var.record_delimiter
  field_delimiter     = var.field_delimiter
  skip_header         = var.skip_header
  date_format         = var.date_format
  validate_utf8       = var.validate_utf8
}
