# Terraform Deployment Template

## Overview

This project provides a reusable Terraform template for deploying an application consistently across different environments.

The template uses Docker as the demonstration infrastructure provider so that the deployment can be tested locally without requiring cloud infrastructure or incurring cloud costs. The structure is designed to be adaptable to cloud providers such as AWS, Azure, or Google Cloud by replacing the provider-specific resources while keeping the reusable module and environment configuration approach.

## Objectives

* Create a reusable Terraform deployment template.
* Separate reusable infrastructure logic into a Terraform module.
* Support multiple deployment environments.
* Use variables for configurable deployment parameters.
* Expose useful deployment outputs.
* Validate Terraform configuration before deployment.
* Demonstrate repeatable and idempotent infrastructure deployment.
* Document the deployment process and provider-specific considerations.

## Architecture

```text
terraform-deployment-template/
│
├── environments/
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── production.tfvars
│
├── modules/
│   └── deployment/
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
│       └── versions.tf
│
├── main.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── versions.tf
├── terraform.tfvars.example
├── .gitignore
└── README.md
```

### Deployment Flow

```text
Environment Variables
        |
        v
Root Terraform Configuration
        |
        v
Reusable Deployment Module
        |
        v
Provider-Specific Resources
        |
        v
Application Deployment
```

## Technology Stack

* Terraform
* Docker
* Docker Terraform Provider
* Terraform Workspaces
* HCL

## Terraform Provider

The current implementation uses the Docker provider:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
```

Docker was selected as the demonstration provider because it allows the template to be validated locally.

For a cloud deployment, the provider can be replaced with the appropriate provider, such as:

* AWS
* Azure
* Google Cloud Platform
* DigitalOcean

The reusable module pattern and environment configuration can remain largely the same while the provider-specific resources are changed.

## Reusable Deployment Module

The core deployment logic is contained in:

```text
modules/deployment/
```

The module accepts variables for:

* Project name
* Environment
* Container image
* Container name
* Container port
* Host port

This keeps the root configuration simple while allowing the deployment logic to be reused.

### Module Resources

The Docker implementation creates:

1. A Docker image resource.
2. A Docker container resource.

The container receives environment and project labels for identification.

## Variables

The root configuration defines the following variables:

| Variable          | Description                | Example                    |
| ----------------- | -------------------------- | -------------------------- |
| `project_name`    | Name of the project        | `terraform-deployment`     |
| `environment`     | Deployment environment     | `dev`                      |
| `container_image` | Application image          | `nginx:latest`             |
| `container_name`  | Container name             | `terraform-deployment-dev` |
| `container_port`  | Application container port | `80`                       |
| `host_port`       | Host port                  | `8080`                     |

Variable validation is included for environment names and valid port ranges.

## Outputs

The deployment exposes:

* Container ID
* Container name
* Application URL

Example:

```text
application_url = "http://localhost:8080"
container_name  = "terraform-deployment-dev"
```

## Environment Configuration

Separate `.tfvars` files are provided for each environment.

### Development

```text
environments/dev.tfvars
```

Uses:

```text
Environment: dev
Host Port:   8080
```

### Staging

```text
environments/staging.tfvars
```

Uses:

```text
Environment: staging
Host Port:   8081
```

### Production

```text
environments/production.tfvars
```

Uses:

```text
Environment: production
Host Port:   8082
```

Using different host ports allows all three Docker deployments to run simultaneously on the local machine.

## Terraform Workspaces

Terraform workspaces are used to maintain separate state for each environment.

Available workspaces:

```text
dev
staging
production
```

This prevents the state of one environment from being mixed with another environment.

## Prerequisites

Install the following:

* Terraform >= 1.5
* Docker
* Git

Verify Terraform:

```bash
terraform version
```

Verify Docker:

```bash
docker --version
```

## Initialization

Clone the repository and enter the project:

```bash
git clone <repository-url>
cd terraform-deployment-template
```

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Format the Terraform files:

```bash
terraform fmt -recursive
```

## Development Deployment

Create or select the development workspace:

```bash
terraform workspace new dev
```

If the workspace already exists:

```bash
terraform workspace select dev
```

Review the deployment:

```bash
terraform plan -var-file=environments/dev.tfvars
```

Apply the deployment:

```bash
terraform apply -var-file=environments/dev.tfvars
```

Access the application:

```text
http://localhost:8080
```

## Staging Deployment

Select the staging workspace:

```bash
terraform workspace new staging
```

If it already exists:

```bash
terraform workspace select staging
```

Plan:

```bash
terraform plan -var-file=environments/staging.tfvars
```

Apply:

```bash
terraform apply -var-file=environments/staging.tfvars
```

Access:

```text
http://localhost:8081
```

## Production Deployment

Select the production workspace:

```bash
terraform workspace new production
```

If it already exists:

```bash
terraform workspace select production
```

Plan:

```bash
terraform plan -var-file=environments/production.tfvars
```

Apply:

```bash
terraform apply -var-file=environments/production.tfvars
```

Access:

```text
http://localhost:8082
```

## Validation

The Terraform configuration was validated using:

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

The validation completed successfully.

Environment-specific plans also confirmed that the infrastructure matched the requested configuration after deployment.

Example:

```text
No changes. Your infrastructure matches the configuration.
```

HTTP validation was performed against all three deployments:

```text
PORT 8080 -> HTTP Status: 200
PORT 8081 -> HTTP Status: 200
PORT 8082 -> HTTP Status: 200
```

This confirms that the development, staging, and production deployments were reachable successfully.

## Environment Isolation

Each environment uses:

* A separate Terraform workspace.
* A separate `.tfvars` configuration.
* A unique container name.
* A unique host port.

Example:

| Environment | Workspace    | Container                         | Port   |
| ----------- | ------------ | --------------------------------- | ------ |
| Development | `dev`        | `terraform-deployment-dev`        | `8080` |
| Staging     | `staging`    | `terraform-deployment-staging`    | `8081` |
| Production  | `production` | `terraform-deployment-production` | `8082` |

## Idempotency

Terraform was tested by running a plan after deployment.

When the infrastructure matched the configuration, Terraform reported:

```text
No changes. Your infrastructure matches the configuration.
```

This demonstrates the expected declarative and idempotent behavior of the template.

## Cleanup

To remove the deployment for the currently selected workspace:

```bash
terraform destroy -var-file=environments/dev.tfvars
```

For staging:

```bash
terraform workspace select staging
terraform destroy -var-file=environments/staging.tfvars
```

For production:

```bash
terraform workspace select production
terraform destroy -var-file=environments/production.tfvars
```

You can verify running containers with:

```bash
docker ps
```

## Cloud Provider Adaptation

The current Docker implementation is intended as a provider-specific demonstration.

For a cloud deployment, the provider-specific resources can be replaced while maintaining the same general structure.

For example, an AWS implementation could use resources such as:

* VPC
* Subnets
* Security groups
* ECS
* ECR
* Application Load Balancer
* IAM roles

An Azure implementation could use:

* Resource groups
* Virtual networks
* Container services
* Load balancers
* Managed identities

A GCP implementation could use:

* VPC networks
* Subnets
* Cloud Run or GKE
* Load balancing
* IAM

The exact resources depend on the application's deployment requirements.

## Production Considerations

The demonstration template intentionally keeps the infrastructure simple. A production implementation should additionally consider:

### Remote State

Use remote Terraform state rather than local state.

Examples include:

* AWS S3 with state locking
* Azure Storage
* Google Cloud Storage
* Terraform Cloud

### Container Image Pinning

Avoid relying on mutable tags such as:

```text
nginx:latest
```

Production deployments should use immutable image tags or digests.

### Secrets Management

Sensitive credentials should not be stored directly in `.tfvars` files.

Use an appropriate secrets-management system such as:

* AWS Secrets Manager
* Azure Key Vault
* Google Secret Manager
* HashiCorp Vault

### CI/CD

Terraform validation and deployment can be integrated into a CI/CD pipeline.

A typical pipeline could include:

```text
Format
  ↓
Validate
  ↓
Security Scan
  ↓
Plan
  ↓
Approval
  ↓
Apply
```

### Production Protection

Production infrastructure should normally include additional controls such as:

* Approval requirements
* Restricted credentials
* Remote state locking
* State backups
* Monitoring
* Logging
* Security scanning
* Disaster recovery procedures

## Security

The repository excludes local Terraform state and local variable files through `.gitignore`.

Ignored files include:

```text
*.tfstate
terraform.tfvars
.terraform/
*.tfplan
```

The example variable file is intentionally tracked:

```text
terraform.tfvars.example
```

This allows users to understand the required configuration without exposing local values.

## Project Limitations

This implementation is intended as a reusable deployment template and local demonstration.

It does not currently include:

* Cloud infrastructure resources
* Remote Terraform state
* CI/CD automation
* Production secrets management
* Automated security scanning
* Production monitoring
* High availability configuration

These can be added when adapting the template to a specific production platform.

## Conclusion

This Terraform deployment template demonstrates how reusable infrastructure can be structured using Terraform modules, variables, outputs, environment-specific configurations, and workspaces.

The Docker provider provides a cost-free local implementation for validation, while the modular structure allows the provider-specific deployment resources to be replaced for AWS, Azure, GCP, or another supported infrastructure platform.

The implementation has been formatted, validated, deployed across development, staging, and production configurations, and verified through HTTP connectivity tests.
