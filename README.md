# nci-webtools-dceg-risk-assessment

## Overview

This repository contains multiple risk assessment tools for cancer prevention and early detection research.

### Available Tools

- **bcrisktool** - Breast Cancer Risk Assessment Tool
- **colorectalcancerrisk** (ccrisktool) - Colorectal Cancer Risk Assessment Tool
- **melanomarisktool** (mrisktool) - Melanoma Risk Assessment Tool

## CI/CD Deployment

### Workflow Structure

Each tool has a dedicated GitHub Actions workflow for automated build and deployment:

- `.github/workflows/bcrisktool-deploy.yml` - Breast Cancer Risk Tool
- `.github/workflows/ccrisktool-deploy.yml` - Colorectal Cancer Risk Tool
- `.github/workflows/mrisktool-deploy.yml` - Melanoma Risk Tool

### Environment Mapping

Deployments support four tiers with different configurations:

| Tier | Description | Image Tier | Log Level | Use Case |
|------|-------------|-----------|-----------|----------|
| `dev` | Development | development | debug | Active development and testing |
| `qa` | Quality Assurance | development | info | QA validation and integration testing |
| `stage` | Staging | release | info | Pre-production validation |
| `prod` | Production | release | info | Live production environment |

### Deployment Process

#### 1. Manual Trigger

All workflows use manual dispatch (`workflow_dispatch`) with the following inputs:

- **tier**: Target environment (dev/qa/stage/prod)

#### 2. Build Steps

1. **Setup**
   - Checkout code with full git history

2. **Docker Build**
   - Configure AWS credentials using OIDC
   - Login to Amazon ECR
   - Build and push Docker images with tags:
     - `{IMAGE_TIER}-backend-{GIT_TAG}-{TIMESTAMP}`
     - `{IMAGE_TIER}-backend-latest`

3. **ECS Deployment**
   - Retrieve ECS configuration from SSM Parameter Store
   - Substitute environment variables in task definition
   - Register new task definition
   - Update ECS service with new task
   - Wait for service stability

### AWS Resources

Each tool deployment requires:

- **ECR Repository**: `{AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/{APP}`
- **ECS Cluster**: Retrieved from `/analysistools/{TIER}/{APP}/ecs_cluster`
- **ECS Service**: Retrieved from `/analysistools/{TIER}/{APP}/ecs_web_service`
- **Task Definition**: Retrieved from `/analysistools/{TIER}/{APP}/ecs_web_task`
- **IAM Role**: `arn:aws:iam::{AWS_ACCOUNT_ID}:role/github-actions-cicd`

### Environment Variables

Key environment variables set during deployment:

```bash
AWS_REGION=us-east-1
APP={bcrisktool|ccrisktool|mrisktool}
TIER={dev|qa|stage|prod}
IMAGE_TIER={development|release}
LOG_LEVEL={debug|info}
ECS_CPU_UNITS=256
ECS_MEMORY_UNITS=512
BACKEND_CONTAINER_PORT=80
```

### Running a Deployment

1. Navigate to Actions tab in GitHub
2. Select the appropriate workflow (bcrisktool/ccrisktool/mrisktool)
3. Click "Run workflow"
4. Select the target tier
5. Optionally configure rebuild and cache options
6. Click "Run workflow" to start deployment

### Task Definition Cleanup

Workflows automatically prune old task definition revisions, keeping only the 3 most recent versions to prevent accumulation.
