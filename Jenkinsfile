pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Validation') {
            steps {
                bat 'terraform init -backend=false'
                bat 'terraform fmt -check'
                bat 'terraform validate'
            }
        }

        stage('Docker Build') {
            steps {
                dir('frontend') {
                    bat 'docker build -t devops-frontend .'
                }
            }
        }
    }
}