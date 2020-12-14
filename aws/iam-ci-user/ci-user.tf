resource "aws_iam_user" "ci_user" {
  name = "${local.project_name}-ci-user-${local.formatted_env}"
  path = var.path

  tags = {
    Owner = var.owner
  }
}

resource "aws_iam_access_key" "ci_access_key" {
  user = aws_iam_user.ci_user.name
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


resource "aws_iam_user_policy" "ci_user_policy" {
  name = "ci_user_policy"
  user = aws_iam_user.ci_user.name

  policy = data.aws_iam_policy_document.ci_policy.json
}
