# terraform-aws-app-secrets

A module to create application secrets stored in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/).

## Table of contents

* [Table of contents](#table-of-contents)
* [Prerequisites](#prerequisites)
* [Example usage](#example-usage)
  * [Single-account secrets](#single-account-secrets)
  * [Cross-account secrets](#cross-account-secrets)
* [Inputs](#inputs)
  * [Secrets](#secrets)
  * [Recovery window](#recovery-window)
* [Outputs](#outputs)
* [Release](#release)
* [Maintainers](#maintainers)

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) (version `1.0.0` or higher)
* [AWS provider](https://www.terraform.io/docs/providers/aws/) (version `2.60` or higher)

## Example usage

### Single-account secrets

This is a main use-case of the module. When you want to create application secrets that are not intended to be shared with other AWS accounts please refer to the following example:

```hcl
module "secrets" {
  source = "git::ssh://git@github.com/scribd/terraform-aws-app-secrets.git?ref=main"

  app_name = "project"
  secrets = [
    {
      name         = "app-env"
      value        = "development"
      allowed_arns = []
    },
    {
      name        = "app-database-host"
      value       = "[value required]"
      allowed_arn = []
    },
    {
      name         = "app-database-port"
      value        = "3306"
      allowed_arns = []
    }
  ]

  tags = {
    department = "engineering"
    project    = "project"
    env        = "development"
  }
}
```

### Cross-account secrets

The module allows you to [delegate](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_compare-resource-policies.html#aboutdelegation-resourcepolicy) read-only access to your secrets to other AWS accounts. Unfortunately, the configuration can't be fully provisioned by the module. It requires additional configuration in the AWS accounts where the secrets are requested from. Below you can find an example of sharing secrets with 2 different AWS accounts.

1. Create secrets within an AWS account (in the example, we refer to it as `account_id1`) and specify AWS account ids or user ARNs that should have access to the secrets. The module generates [resource-based policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html#policies_resource-based) which are attached to a secret (one policy per secret):

```hcl
module "secrets" {
  source = "git::ssh://git@github.com/scribd/terraform-aws-app-secrets.git?ref=main"

  app_name = "project"
  secrets = [
    {
      name         = "app-env"
      value        = "development"
      allowed_arns = []
    },
    {
      name         = "app-database-host"
      value        = "[value required]"
      allowed_arns = [var.account_id2]
    },
    {
      name         = "app-database-port"
      value        = "3306"
      allowed_arns = [
        var.account_id2,
        "arn:aws:iam::${var.account_id3}:user/user-name",
      ]
    }
  ]

  tags = {
    department = "engineering"
    project    = "project"
    env        = "development"
  }
}
```

The example above creates the secrets and grants access to the `app-database-host` secret to the `account_id2` AWS account. Access to the `app-database-port` secret is granted to the `account_id2` account and the `user-name` user defined in the `account_id3` AWS account. The `app-env` secret is not shared with any other AWS accounts.

2. Run the terraform pipeline to provision the secrets and copy the KMS key ARN from the `module.secrets.kms_key_arn` output.

3. In the `account_id2` AWS account, create the role `roleName` and attach a policy to it:

```hcl
data "aws_iam_policy_document" "secret_access" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = ["kms-key-arn-copied-from-step-2"]
  }

  statement {
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${var.aws_region}:${var.account_id1}:secret:project-app-database-host*",
      "arn:aws:secretsmanager:${var.aws_region}:${var.account_id1}:secret:project-app-database-port*",
    ]
  }
}

resource "aws_iam_policy" "secret_access" {
  name_prefix = "project"
  description = "Policy to access secrets for application project"
  policy      = data.aws_iam_policy_document.secret_access.json
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.8"

  create_role = true

  role_name         = "roleName"
  role_requires_mfa = false

  custom_role_policy_arns           = [aws_iam_policy.secret_access.arn]
  number_of_custom_role_policy_arns = 1

  tags = {
    department = "engineering"
    project    = "project"
    env        = "development"
  }
}
```

Now you should be able to assume the role from within `account_id2` and read the secret value.

> :warning: Note: As an example, we use a third-party module `iam-assumable-role` to create a new role. In your case, you may want to attach the newly created policy to an existing role.

4. In the `account_id3` AWS account, create the user `user-name` and attach a policy to it:

```hcl
data "aws_iam_policy_document" "secret_access" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = ["kms-key-arn-copied-from-step-2"]
  }

  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.account_id1}:secret:project-app-database-port*"]
  }
}

resource "aws_iam_policy" "secret_access" {
  name_prefix = "project"
  description = "Policy to access secrets for application project"
  policy      = data.aws_iam_policy_document.secret_access.json
}

resource "aws_iam_user_policy_attachment" "user" {
  user       = module.user.iam_user_name
  policy_arn = aws_iam_policy.secret_access.arn
}

module "user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 4.8"

  name = "user-name"

  create_user                   = true
  create_iam_user_login_profile = false

  tags = {
    department = "engineering"
    project    = "project"
    env        = "development"
  }
}
```

> ⚠️ Note: As an example, we use a third-party module `iam-user` to create a new user. In your case, you may want to attach the newly created policy to an existing user.

> ⚠️ **IMPORTANT NOTES**
>
> * Please don't use `ref=main` in your production code. Please refer to a release tag explicitly.
> * Please don't put actual secret values to the terraform code except for the static configuration values (for instance, the static ports). Use any dummy values to provision the secrets. The actual values have to be set manually via [AWS Web Console](https://aws.amazon.com/secrets-manager/) or [AWS CLI](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/index.html) afterwards.

## Inputs

| Name         | Description                                                       | Type         | Default     | Required |
|:-------------|:------------------------------------------------------------------|:-------------|:------------|:---------|
| `app_name`   | Application name                                                  | string       | `null`      | yes      |
| `aws_region` | AWS region                                                        | string       | `us-east-2` | no       |
| `secrets`    | List of objects of [secrets](#secrets)                            | list(object) | `null`      | yes      |
| `delete_in`  | [Number of days](#recovery-window) to wait before secret deletion | number       | `30`        | no       |
| `tags`       | Key-value map of tags                                             | map(string)  | `{}`        | no       |

### Secrets

| Name           | Description                                           | Type   | Default |
|:---------------|:------------------------------------------------------|:-------|:--------|
| `name`         | Secret name                                           | string | `null`  |
| `value`        | Secret value                                          | string | `null`  |
| `allowed_arns` | List of principal ARNs that have access to the secret | list   | `null`  |

### Recovery window

Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be `0` to force deletion without recovery or range from `7` to `30` days. The default value is `30`.

## Outputs

| Name            | Description                              | Sensitive |
|:----------------|:-----------------------------------------|:----------|
| `all`           | Map of names and arns of created secrets | yes       |
| `kms_key_arn`   | The master key ARN                       | no        |
| `kms_alias_arn` | The master key alias ARN                 | no        |

## Release

This project is using [semantic-release](https://semantic-release.gitbook.io/semantic-release/)
and [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/),
with the [`angular` preset](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular).

Releases are done from the `origin/main` branch using a manual step at the end of the CI/CD pipeline.

In order to create a new release:

1. Merge / push changes to `origin/main`
2. Open the `Release` [Github workflow](https://github.com/scribd/terraform-aws-app-secrets/actions/workflows/release.yml)
3. Click `Run workflow` dropdown in the top right corner of the table listing the workflow runs
4. Choose the `main` branch and click `Run workflow` button to start the process

A version bump will happen automatically and the type of version bump
(patch, minor, major) depends on the commits introduced since the last release.

The `semantic-release` configuration is in [`.releaserc.yml`](https://github.com/scribd/terraform-aws-app-secrets/blob/main/.releaserc.yml).

## Maintainers

Made with ❤️ by the Service Foundations team.
