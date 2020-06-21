resource "snowflake_warehouse" "warehouse_Marketing" {
  name              = "Marketing"
  comment           = "ADEWBERRY Test"
  warehouse_size    = "small"
  auto_resume       = "true"
  auto_suspend      = "90"
  min_cluster_count = 1
  max_cluster_count = 2
  scaling_policy    = "ECONOMY"
}
