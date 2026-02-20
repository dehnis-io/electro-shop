# Electro-shop - a complete DevOps CI/CD project
- [Demo](https://themewagon.github.io/Electro-Bootstrap/)


## Electro-Shop Infrastructure

The Terraform configuration deploys a complete CI/CD infrastructure with three servers:

## Server Components

1. **Electro-shop-master** - Jenkins Master Server
   - Runs Jenkins CI/CD server
   - Accessible on port 8080

2. **Electro-shop-agent** - Docker Agent Server
   - Runs Docker for container builds
   - Configured as Jenkins agent

3. **Electro-shop-sonar-server** - SonarQube Server
   - Runs SonarQube for code quality analysis
   - Accessible on port 9000

## Deployment

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy infrastructure
terraform apply -auto-approve

# Get server information
terraform output


### 📋 Infrastructure Components

| Component | Instance Name | Purpose | Specifications |
|-----------|--------------|---------|----------------|
| **Jenkins Master** | `Electro-shop-master` | Orchestration & Pipeline Management | • Standard instance size<br>• Balanced workload |
| **Jenkins Agent** | `Electro-shop-agent` | Container Builds & Execution | • Docker-enabled<br>• Optimized for build tasks |
| **SonarQube Server** | `Electro-shop-sonar-server` | Code Quality Analysis | • 🚀 **Larger instance type**<br>• 💾 **Extended disk size**<br>• Resource-optimized for analysis |

### ✨ Key Features

- **Properly Tagged Resources**: All servers are consistently tagged for easy identification and management
- **Workload-Optimized Sizing**: Each instance is configured based on its specific workload requirements
- **Resource-Aware Configuration**: The SonarQube server receives enhanced resources to handle code analysis efficiently

> **Note**: The SonarQube server is provisioned with a larger instance type and increased disk capacity to accommodate its higher resource demands for code quality analysis.




