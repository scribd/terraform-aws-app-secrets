# [3.1.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v3.0.0...v3.1.0) (2024-04-05)


### Features

* Add delete_in argument ([555d9db](https://github.com/scribd/terraform-aws-app-secrets/commit/555d9db14d884ad4bb4b360deb75204287d16d07))

# [3.0.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v2.3.1...v3.0.0) (2024-01-04)


### chore

* Bump min supported TF to v1.0.0 ([b52520f](https://github.com/scribd/terraform-aws-app-secrets/commit/b52520f2abdc739a56457ddf1fc2d117d3b8d21f))


### BREAKING CHANGES

* Drop support for Terraform 0.13 and 0.14

## [2.3.1](https://github.com/scribd/terraform-aws-app-secrets/compare/v2.3.0...v2.3.1) (2022-08-19)


### Bug Fixes

* Mark secret output as sensitive ([928d1e8](https://github.com/scribd/terraform-aws-app-secrets/commit/928d1e8bf39800d558e0ebe36ad87fb44f288b0c))

# [2.3.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v2.2.0...v2.3.0) (2022-08-17)


### Features

* Bump min Terraform version to v0.13.7 ([331491e](https://github.com/scribd/terraform-aws-app-secrets/commit/331491ed130695d35a6463417a9b4ff9d5e3fba3))

# [2.2.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v2.1.0...v2.2.0) (2022-01-21)


### Features

* Create a KMS key for shareable secrets ([ba9e403](https://github.com/scribd/terraform-aws-app-secrets/commit/ba9e40372adb820d175eabb9e439508fbed6f30c))
* Update outputs ([1da0850](https://github.com/scribd/terraform-aws-app-secrets/commit/1da0850c71ed0fcbc20091598047f1a5ff0a2e3a))

# [2.1.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v2.0.0...v2.1.0) (2021-11-12)


### Bug Fixes

* **ci:** Do not persist token when checking out the repository during Release workflow ([82c9b20](https://github.com/scribd/terraform-aws-app-secrets/commit/82c9b20898fdfb58187bdf778ca449b6bde654be))


### Features

* Add Github workflows to validate terraform and release ([e8134d3](https://github.com/scribd/terraform-aws-app-secrets/commit/e8134d3b48d50f2ddc37585ad91197512fd36c0e))
* Remove Jenkinsfile ([2bb9b97](https://github.com/scribd/terraform-aws-app-secrets/commit/2bb9b97c439941f14a8d7f9a64c0625dc7b1a299))

# [2.0.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v1.1.0...v2.0.0) (2021-10-13)


### Features

* Support policies for secrets ([124d452](https://github.com/scribd/terraform-aws-app-secrets/commit/124d452f9b851426b330c8cc8efa33cb0bd8d2c3))


### BREAKING CHANGES

* Input format for the secrets has changed

# [1.1.0](https://github.com/scribd/terraform-aws-app-secrets/compare/v1.0.1...v1.1.0) (2021-03-30)


### Features

* Make the module compatible with terraform 0.13 ([a5b1ab5](https://github.com/scribd/terraform-aws-app-secrets/commit/a5b1ab58e906906ce8c8fb09e7912e78ab37d778))

## [1.0.1](https://github.com/scribd/terraform-aws-app-secrets/compare/v1.0.0...v1.0.1) (2021-01-21)


### Bug Fixes

* Relax version constraints for the AWS provider ([10f0c4a](https://github.com/scribd/terraform-aws-app-secrets/commit/10f0c4abdbbea08d369c2717e7294d7f0e998c73))

# 1.0.0 (2020-10-19)


### Features

* Add Jenkinsfile ([5a97039](https://git.lo/terraform/terraform-aws-secrets/commit/5a97039180843f69bbcb9f6be3920294b4121cbc))
* Add module's code ([c165d90](https://git.lo/terraform/terraform-aws-secrets/commit/c165d90f11a712bdfab7105d6e78a814b8290834))
* Add semantic release configuration file ([24240ef](https://git.lo/terraform/terraform-aws-secrets/commit/24240efd6d54b1b3d126a0ab253faa5992431950))
* Add skip:build and release steps to Jenkinsfile ([1f6e785](https://git.lo/terraform/terraform-aws-secrets/commit/1f6e785afe7a713744db991e101b2cd754b22844))
