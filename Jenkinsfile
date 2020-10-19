// Build pipeline

pipeline {
    agent {
        kubernetes {
            label 'terraform-0-12-20'
            defaultContainer 'terraform-0-12-20'
        }
    }

    options {
        ansiColor('xterm')
        timeout(30)
        gitLabConnection('GitLab')
        buildDiscarder logRotator(numToKeepStr: '128')
    }

    triggers {
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    }

    environment {
        // https://www.terraform.io/docs/commands/environment-variables.html#tf_in_automation
        TF_IN_AUTOMATION = 'true'

        // Provide default AWS region in order to validate the configuration
        //
        // https://github.com/hashicorp/terraform/issues/21408#issuecomment-495746582
        AWS_DEFAULT_REGION = 'us-east-2'

        GITLAB_TOKEN = credentials('tf-scribdbot-gitlab-token')
    }

    stages {
        stage('skip:build') {
            steps {
                // Skips a build if a commit message contains "[skip ci]"
                scmSkip(deleteBuild: true, skipPattern: '.*\\[skip ci\\].*')
            }

            post {
                failure { updateGitlabCommitStatus(name: 'build:skip', state: 'failed') }
                success { updateGitlabCommitStatus(name: 'build:skip', state: 'success') }
            }
        }

        stage('init') {
            steps {
                sh("terraform init -input=false")
            }

            post {
                failure { updateGitlabCommitStatus(name: 'terraform:init', state: 'failed') }
                success { updateGitlabCommitStatus(name: 'terraform:init', state: 'success') }
            }
        }

        stage('check:format') {
            steps {
                sh('terraform fmt -check -diff -recursive')
            }

            post {
                failure { updateGitlabCommitStatus(name: 'terraform:check:format', state: 'failed') }
                success { updateGitlabCommitStatus(name: 'terraform:check:format', state: 'success') }
            }
        }

        stage('validate') {
            steps {
                sh('terraform validate')
            }

            post {
                failure { updateGitlabCommitStatus(name: 'terraform:validate', state: 'failed') }
                success { updateGitlabCommitStatus(name: 'terraform:validate', state: 'success') }
            }
        }

        stage('release') {
            when {
                beforeInput(true)
                beforeAgent(true)

                branch 'main'
            }

            agent {
                kubernetes {
                    label 'semantic-release'
                    defaultContainer 'semantic-release'
                }
            }

            input {
                message "Hereby I confirm I want to release a new version"
            }

            steps {
                sh('npx semantic-release')
            }

            post {
                failure { updateGitlabCommitStatus(name: 'terraform:release', state: 'failed') }
                success { updateGitlabCommitStatus(name: 'terraform:release', state: 'success') }
            }
        }
    }
}
