resource "aws_iam_role" "ci_deployment_role" {
  name                 = "${local.project_name}-ci-deployment-role-${local.formatted_env}"
  permissions_boundary = var.permissions_boundary
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.ci_assume_role_policy.json
  tags = {
    Project     = local.project_name
    Environment = local.env
    Description = "Role for progrommatic user to adopt for CI deployments"
  }
}

data "aws_iam_policy_document" "ci_assume_role_policy" {
  statement {
    sid     = "ciAssumeDeploymentRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.ci_user.name}"]
    }
  }
}

resource "aws_iam_role_policy" "ci_deployment_policy" {
  name   = "${local.project_name}-ci-deployment-role-policy-${local.formatted_env}"
  policy = data.aws_iam_policy_document.ci_policy.json
  role   = aws_iam_role.ci_deployment_role.id
}

data "aws_iam_policy_document" "ci_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:ListRoleTags",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
      "iam:ListPolicies",
      "iam:GetRole",
      "iam:GetUser",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetUserPolicy",
      "iam:ListAccessKeys"
    ]
  }

  statement {
    sid       = "managestatelock"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${local.project_name}-lock-table"]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
  }

  statement {
    sid       = "listbucketdata"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-data-lake-${local.formatted_env}"]

    actions = [
      "s3:ListBucket",
    ]
  }

  statement {
    sid       = "interractobjectsdata"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-data-lake-${local.formatted_env}/*"]

    actions = [
      "s3:Get*",
      "s3:Put*",
    ]
  }

  statement {
    sid       = "listBucketState"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-remote-state"]

    actions = [
      "s3:ListBucket",
    ]
  }

  statement {
    sid       = "interractobjectsstate"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-remote-state/*"]

    actions = [
      "s3:Get*",
      "s3:Put*",
    ]
  }
}
