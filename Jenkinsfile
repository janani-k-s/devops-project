pipeline {
    agent any

    stages {
        stage('AWS Authentication Check') {
    steps {
        withCredentials([
            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            bat 'aws sts get-caller-identity'
        }
    }
}
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