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
        stage('Terraform Plan') {
    steps {
         withCredentials([
    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY'),
    string(credentialsId: 'ssh-allowed-cidr', variable: 'TF_VAR_ssh_allowed_cidr')
]){
            bat 'set AWS_DEFAULT_REGION=us-east-1 && terraform plan -input=false'
        }
    }
}

        
stage('Docker Build') {
    steps {
        dir('frontend') {
            bat 'docker build -t ghcr.io/janani-k-s/devops-frontend:latest .'
        }
    }
}

stage('Push to GHCR') {
    steps {
        withCredentials([
            usernamePassword(
                credentialsId: 'ghcr-credentials',
                usernameVariable: 'GHCR_USERNAME',
                passwordVariable: 'GHCR_TOKEN'
            )
        ]) {
            bat 'echo %GHCR_TOKEN% | docker login ghcr.io -u %GHCR_USERNAME% --password-stdin'
            bat 'docker push ghcr.io/janani-k-s/devops-frontend:latest'
            bat 'docker logout ghcr.io'
        }
    }
}

    }
}