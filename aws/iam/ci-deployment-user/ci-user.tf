resource "aws_iam_user" "ci_user" {
  name = "${local.project_name}-ci-user-${local.formatted_env}"
  path = var.path

  tags = {
    Project     = local.project_name
    Environment = local.env
    Description = "Programmatic user for CI deployments"
  }
}

resource "aws_iam_access_key" "ci_access_key" {
  user = aws_iam_user.ci_user.name
}
