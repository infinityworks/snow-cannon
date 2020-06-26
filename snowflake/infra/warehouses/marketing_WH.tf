resource "snowflake_warehouse" "Marketing_WH" {
  name              = "Marketing"
  comment           = "ADEWBERRY Test"
  warehouse_size    = "small"
  auto_resume       = "true"
  auto_suspend      = "300"
  min_cluster_count = 1
  max_cluster_count = 2
  scaling_policy    = "ECONOMY"
}

resource "snowflake_warehouse_grant" "usage_grants_on_Marketing_WH" {
  warehouse_name = snowflake_warehouse.Marketing_WH.name
  privilege      = "USAGE"

  roles = [
    module.rbac.role_BI_ANALYST,
    module.rbac.role_DATA_ANALYST,
  ]
}
