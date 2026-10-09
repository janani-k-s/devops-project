
pipeline {
    agent any

    environment {
        EC2_HOST = '100.57.205.32'
        GHCR_IMAGE = 'ghcr.io/janani-k-s/devops-frontend:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('AWS Authentication Check') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    bat 'set AWS_DEFAULT_REGION=us-east-1 && aws sts get-caller-identity'
                }
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
                ]) {
                    bat 'set AWS_DEFAULT_REGION=us-east-1 && terraform plan -input=false'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('frontend') {
                    bat 'docker build -t %GHCR_IMAGE% .'
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
                    bat '''
                        echo %GHCR_TOKEN%| docker login ghcr.io -u %GHCR_USERNAME% --password-stdin
                        if errorlevel 1 exit /b 1
                        docker push %GHCR_IMAGE%
                        if errorlevel 1 exit /b 1
                        docker logout ghcr.io
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'ghcr-pull-credentials',
                        usernameVariable: 'GHCR_USERNAME',
                        passwordVariable: 'GHCR_TOKEN'
                    ),
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    bat '''
                        powershell -NoProfile -Command "$env:GHCR_TOKEN | ssh -o StrictHostKeyChecking=no -i $env:SSH_KEY $env:SSH_USER@$env:EC2_HOST 'sudo docker login ghcr.io -u janani-k-s --password-stdin'"
                        if errorlevel 1 exit /b 1

                        ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %SSH_USER%@%EC2_HOST% "sudo docker pull %GHCR_IMAGE%"
                        if errorlevel 1 exit /b 1

                        ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %SSH_USER%@%EC2_HOST% "sudo docker rm -f devops-frontend"
                        ssh -o StrictHostKeyChecking=no -i "%SSH_KEY%" %SSH_USER%@%EC2_HOST% "sudo docker run -d --restart unless-stopped --name devops-frontend -p 80:80 %GHCR_IMAGE%"
                        if errorlevel 1 exit /b 1
                    '''
                }
            }
        }
    }
}
