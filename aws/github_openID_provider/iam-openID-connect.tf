resource "aws_iam_openid_connect_provider" "github_actions_deployment" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  tags = {
    Description = "IDP integration for secure deployments with GitHub Actions"}
}