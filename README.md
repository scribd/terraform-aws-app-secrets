# terraform-aws-secrets

A module to create application secrets stored in [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/).

## Table of contents

* [Table of contents](#table-of-contents)
* [Prerequisites](#prerequisites)
* [Example usage](#example-usage)
* [Inputs](#inputs)
* [Outputs](#outputs)
* [Release](#release)
* [Maintainers](#maintainers)

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) (version `0.12.9` or higher)
* [AWS provider](https://www.terraform.io/docs/providers/aws/) (version `2.60` or higher)

## Example usage

```hcl
module "secrets" {
  source = "git::ssh://git@git.lo/terraform/terraform-aws-secrets.git?ref=main"

  app_name = "go-chassis"
  secrets = {
    "app-env"               = "development"
    "app-settings-name"     = "go-chassis"
    "app-database-host"     = "[value required]"
    "app-database-port"     = "3306"
    "app-database-name"     = "[value required]"
    "app-database-username" = "[value required]"
    "app-database-password" = "[value required]"
  }

  tags = {
    department = "engineering"
    project    = "go-chassis"
    env        = "development"
  }
}
```

>>>
⚠️ **IMPORTANT NOTES**

* Please don't use `ref=main` in your production code. Please refer to a release tag explicitly.
* Please don't put actual secret values to the terraform code except for the static configuration values (for instance, the static ports). Use any dummy values to provision the secrets. The actual values have to be set manually via [AWS Web Console](https://aws.amazon.com/secrets-manager/) or [AWS CLI](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/index.html) afterwards.
>>>

## Inputs

| Name        | Description              | Type        | Default | Required  |
| ----------- | ------------------------ | ----------- | ------- | :-------: |
| app_name    | Application name         | string      | `null`  | yes       |
| secrets     | Key-value map of secrets | map(string) | `null`  | yes       |
| tags        | Key-value map of tags    | map(string) | `{}`    | no        |

## Outputs

| Name | Description                              | Sensitive |
| ---- | ---------------------------------------- | --------- |
| all  | Map of names and arns of created secrets | no        |

## Release

This project is using [semantic-release](https://semantic-release.gitbook.io/semantic-release/)
and [conventional-commits](https://www.conventionalcommits.org/en/v1.0.0/),
with the [`angular` preset](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular).

Releases are done from the `origin/main` branch using a manual step at the end of the CI/CD pipeline.

In order to create a new release:

1. Merge / push changes to `origin/main`
2. Open the `origin/main` [Jenkins CI/CD pipeline](https://jenkins.kube-charlie.lo/blue/organizations/jenkins/Terraform%2Fterraform%252Fterraform-aws-secrets/activity/?branch=main)
3. Click "Proceed" button on the release step

A version bump will happen automatically and the type of version bump
(patch, minor, major) depends on the commits introduced since the last release.

The `semantic-release` configuration is in [`.releaserc.yml`](https://git.lo/terraform/terraform-aws-secrets/blob/main/.releaserc.yml).

## Maintainers

Made with ❤️  by the Service Foundations team.
