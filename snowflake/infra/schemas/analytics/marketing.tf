resource "snowflake_schema" "schema_marketing" {
  name     = "Marketing"
  database = module.databases.analytics_database
  comment  = "ADEWERRY testing"
}

output "marketing_schema" {
  value = "${snowflake_schema.schema_marketing.name}"
}
