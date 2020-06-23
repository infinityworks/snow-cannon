module "databases" {
  source = "../../databases"
}

resource "snowflake_schema" "schema_Marketing" {
  name     = "Marketing"
  database = module.databases.analytics_database
  comment  = "ADEWERRY testing"
}
