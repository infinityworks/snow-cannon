module "rbac" {
  source = "../../rbac"
}

resource "snowflake_database" "db_ANALYTICS_TEST" {
  name                        = "ANALYTICS_TEST"
  comment                     = "ADEWERRY testing"
  data_retention_time_in_days = 14
}

resource "snowflake_database_grant" "usage_grants_on_db_ANALYTICS_TEST" {
  database_name = snowflake_database.db_ANALYTICS_TEST.name
  privilege     = "USAGE"

  roles = [
    "${module.rbac.BI_ref}",
    "${module.rbac.DA_ref}",
  ]

}

resource "snowflake_database_grant" "modify_grants_on_db_ANALYTICS_TEST" {
  database_name = snowflake_database.db_ANALYTICS_TEST.name
  privilege     = "MODIFY"

  roles = [
    "${module.rbac.BI_ref}",
    "${module.rbac.DA_ref}",
  ]

}
