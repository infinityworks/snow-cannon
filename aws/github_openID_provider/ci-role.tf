resource "aws_iam_role" "ci_deployment_role" {
  name                 = "${local.project_name}-ci-deployment-role-${local.config.env_formatted.lower}"
  permissions_boundary = var.permissions_boundary
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.ci_assume_role_policy.json
  max_session_duration = var.session_duration
  tags = {
    Description = "Role for Programmatic user to adopt for CI deployments"
  }
}

data "aws_iam_policy_document" "ci_assume_role_policy" {
  statement {
    sid    = "ciAssumeDeploymentRolePolicy"
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity",
      "sts:TagSession"
    ]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions_deployment.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:infinityworks/snow-cannon:*"
      ]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:iss"
      values = [
        "https://token.actions.githubusercontent.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ci_deployment_policy" {
  name   = "${local.project_name}-ci-deployment-role-policy-${local.config.env_formatted.lower}"
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
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRolePolicy",
      "iam:GetRole",
      "iam:GetUser",
      "iam:GetUserPolicy",
      "iam:ListAccessKeys",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicies",
      "iam:ListRolePolicies",
      "iam:ListRoleTags",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
    ]
  }

  statement {
    sid       = "manageStateLock"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${local.project_name}-lock-table"]

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
  }

  statement {
    sid       = "listBucketData"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-data-lake-${local.config.env_formatted.lower}"]

    actions = [
      "s3:ListBucket",
      "s3:GetBucketNotification*",
      "s3:PutBucketNotification*",
    ]
  }

  statement {
    sid       = "interractObjectsData"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-data-lake-${local.config.env_formatted.lower}/*"]

    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:Delete*",
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
    sid       = "interractObjectsState"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${local.project_name}-remote-state/*"]

    actions = [
      "s3:Get*",
      "s3:Put*",
      "s3:Delete*",
    ]
  }
}
