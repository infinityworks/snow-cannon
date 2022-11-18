resource "snowflake_warehouse" "infra_deployment" {
  name              = "INFRA_DEPLOYMENT"
  comment           = "Warehouse for Infrastructure Deployments"
  warehouse_size    = "x-small"
  auto_resume       = "true"
  auto_suspend      = "60"
  min_cluster_count = 1
  max_cluster_count = 2
  scaling_policy    = "ECONOMY"
}

resource "snowflake_warehouse_grant" "usage_grants_infra_deployment_WH" {
  warehouse_name = snowflake_warehouse.infra_deployment.name
  privilege      = "USAGE"

  roles = [
    "SECURITYADMIN",
    "SYSADMIN",
  ]
}
