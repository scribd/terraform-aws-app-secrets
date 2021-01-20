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
        buildDiscarder logRotator(numToKeepStr: '128')
    }

    environment {
        // https://www.terraform.io/docs/commands/environment-variables.html#tf_in_automation
        TF_IN_AUTOMATION = 'true'

        // Provide default AWS region in order to validate the configuration
        //
        // https://github.com/hashicorp/terraform/issues/21408#issuecomment-495746582
        AWS_DEFAULT_REGION = 'us-east-2'

        GITHUB_TOKEN = credentials('scribdbot-github-token')
    }

    stages {
        stage('skip:build') {
            steps {
                // Skips a build if a commit message contains "[skip ci]"
                scmSkip(deleteBuild: true, skipPattern: '.*\\[skip ci\\].*')
            }
        }

        stage('init') {
            steps {
                sh("terraform init -input=false")
            }
        }

        stage('check:format') {
            steps {
                sh('terraform fmt -check -diff -recursive')
            }
        }

        stage('validate') {
            steps {
                sh('terraform validate')
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
        }
    }
}
