# DevOps CI/CD Project — AWS, Terraform, Jenkins & Docker

## Project Overview

This project demonstrates an end-to-end DevOps workflow for deploying a containerized web application to Amazon EC2. It combines Infrastructure as Code (IaC), continuous integration, container image publishing, and automated application deployment.

The AWS infrastructure was provisioned using Terraform. Jenkins automates source-code checkout, Terraform validation and planning, Docker image building, publishing to GitHub Container Registry (GHCR), and deployment to EC2.

## Architecture

GitHub → Jenkins → Terraform Validation & Plan → Docker Build → GHCR → AWS EC2 → Nginx Web Application

## Technologies Used

- **AWS:** VPC, public subnets, Internet Gateway, route tables, security groups, EC2, Elastic IP
- **Terraform:** Infrastructure as Code
- **Jenkins:** CI/CD pipeline automation
- **Docker:** Containerization
- **GitHub:** Source-code version control
- **GitHub Container Registry (GHCR):** Docker image storage
- **Nginx:** Web server
- **Windows:** Jenkins host environment

## AWS Infrastructure

The infrastructure was provisioned in the `us-east-1` region.

Resources include:

- One VPC with CIDR `10.0.0.0/16`
- Two public subnets across separate Availability Zones
- An Internet Gateway and route table
- Security group rules for HTTP and restricted SSH access
- Two EC2 instances configured for the project
- An Elastic IP associated with the deployment instance

The first EC2 instance hosts the application. The second instance is retained as an additional provisioned resource and can remain stopped when not required.

## Jenkins Pipeline

The Jenkins pipeline contains the following stages:

1. **Checkout:** Retrieves the source code from the GitHub `main` branch.
2. **AWS Authentication Check:** Verifies AWS credentials using AWS STS.
3. **Terraform Validation:** Initializes Terraform without a backend, checks formatting, and validates the configuration.
4. **Terraform Plan:** Generates an execution plan for the configured infrastructure.
5. **Docker Build:** Builds the frontend image from the Dockerfile.
6. **Push to GHCR:** Authenticates with GitHub Container Registry and publishes the image.
7. **Deploy to EC2:** Connects to the EC2 instance through SSH, authenticates with GHCR, pulls the image, and runs the container.

## Docker Image

The frontend uses Nginx as its base image and copies the application's HTML file into the Nginx web root.

Image:

`ghcr.io/janani-k-s/devops-frontend:latest`

The deployed container is named `devops-frontend` and exposes port 80.

## Deployment Verification

The project was successfully deployed and verified by opening the application in a web browser through the EC2 Elastic IP.

The successful Jenkins build confirmed that the pipeline completed its stages, including Docker image publishing and EC2 deployment.

## Security Considerations

- AWS credentials and GitHub tokens are stored in Jenkins Credentials.
- The EC2 SSH private key is managed through Jenkins credentials.
- SSH access should be restricted to an authorized source IP or an appropriate access mechanism.
- Secrets, private keys, Terraform state files, and local environment files must not be committed to GitHub.
- The application currently uses HTTP. HTTPS and production-grade access controls are potential future improvements.

## Cost Management

EC2 instances can incur charges while running. Stop instances when they are not needed, and review the charges associated with Elastic IPs and other AWS resources.

The deployment instance must be running for the website to be accessible.

## Current Scope and Future Improvements

- Configure shared Terraform state management if infrastructure provisioning will be managed from both the local machine and Jenkins.
- Integrate controlled Terraform provisioning into the pipeline after state management is configured.
- Add HTTPS, improved monitoring, and deployment health checks.
- Add screenshots of the successful Jenkins build, AWS infrastructure, and deployed application.

## Conclusion

This project demonstrates practical experience with Infrastructure as Code, CI/CD automation, Docker image management, AWS networking, and container deployment to EC2.
