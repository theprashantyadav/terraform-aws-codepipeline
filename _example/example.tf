provider "aws" {
  region = "eu-west-1"
}


module "aws_s3_bucket" {
  source = "clouddrove/s3/aws"

  name        = "radhe"
  environment = "test"
  attributes  = ["private"]
  label_order = ["name", "environment"]

  versioning = true
  acl        = "private"
}


module "iam-role" {
  source = "clouddrove/iam-role/aws"

  name               = "iam"
  environment        = "test"
  label_order        = ["environment", "name"]
  assume_role_policy = data.aws_iam_policy_document.assume.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.defaultb.json
}

data "aws_iam_policy_document" "defaultb" {

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["arn:aws:s3:::example2-test-private/*", "arn:aws:s3:::example2-test-private"]
  }

}


data "aws_iam_policy_document" "assume" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

module "kms_key" {
  source = "clouddrove/kms/aws"

  name        = "kms"
  environment = "test"
  label_order = ["name", "environment"]

  enabled                 = true
  description             = "KMS key for cloudtrail"
  deletion_window_in_days = 15
  alias                   = "alias/cloudtrail_Nam"
  policy                  = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow CloudTrail to encrypt logs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:XXXXXXXXXXXX:trail/*"]
    }
  }

  statement {
    sid    = "Allow CloudTrail to describe key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow principals in the account to decrypt log files"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
      "XXXXXXXXXXXX"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:XXXXXXXXXXXX:trail/*"]
    }
  }

  statement {
    sid    = "Allow alias creation during setup"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
  }
}

module "codepipeline" {
  source         = "./../"
  name           = "test-pipelines"
  ActionMode     = "REPLACE_ON_FAILURE"
  Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
  OutputFileName = "CreateStackOutput.json"
  StackName      = "MyStack"
  TemplatePath   = "build_output::sam-templated.yaml"
  role_arn       = module.iam-role.arn
  location       = "eu-west-1"
  kms_key        = module.kms_key.key_id
}