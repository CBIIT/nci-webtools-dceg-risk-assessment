# AWS CDK Infrastructure for BCRiskTool (TypeScript)

This directory contains the AWS CDK infrastructure code using TypeScript to replace the Terraform configuration.

## Prerequisites

- Node.js 18 or later
- AWS CDK CLI: `npm install -g aws-cdk`
- AWS credentials configured

## Setup

1. Install dependencies:
```bash
cd cdk
npm install
```

2. Bootstrap CDK (first time only):
```bash
cdk bootstrap aws://ACCOUNT-ID/REGION
```

## Deployment

### Deploy to Development
```bash
cdk deploy --all -c env=dev
```

### Deploy to QA
```bash
cdk deploy --all -c env=qa
```

### Deploy to Stage
```bash
cdk deploy --all -c env=stage
```

### Deploy to Production
```bash
cdk deploy --all -c env=prod
```

## Stacks

- **ECR Stack** (optional): Creates container registry
  - Enable with `-c create_ecr=true`
- **ECS Stack**: Creates ECS Fargate cluster, services, tasks, and autoscaling
- **Parameters Stack**: Stores configuration in SSM Parameter Store

## Configuration

### VPC and Networking

Update [bin/cdk.ts](bin/cdk.ts) to configure your VPC:

```typescript
const ecsStack = new EcsStack(app, `${stackName}-ecs`, {
  // ... other props
  vpcId: 'vpc-xxxxx',  // Your VPC ID
  albListenerArn: 'arn:aws:elasticloadbalancing:...',  // Your ALB listener ARN
  healthCheckPath: '/',
});
```

### ALB Integration

To attach the ECS service to an Application Load Balancer, uncomment the ALB integration code in [lib/ecs-stack.ts](lib/ecs-stack.ts) (lines 163-188).

## Useful CDK Commands

- `npm run build` - Compile TypeScript to JavaScript
- `npm run watch` - Watch for changes and compile
- `npm run test` - Run Jest unit tests
- `cdk ls` - List all stacks
- `cdk synth` - Synthesize CloudFormation template
- `cdk diff` - Compare deployed stack with current state
- `cdk deploy` - Deploy stack to AWS account
- `cdk destroy` - Remove stack from AWS account

## Project Structure

```
cdk/
├── bin/
│   └── cdk.ts              # CDK app entry point
├── lib/
│   ├── ecr-stack.ts        # ECR repository stack
│   ├── ecs-stack.ts        # ECS Fargate stack
│   └── parameters-stack.ts # SSM parameters stack
├── test/
│   └── cdk.test.ts         # Unit tests
├── cdk.json                # CDK configuration
├── package.json            # Node.js dependencies
└── tsconfig.json           # TypeScript configuration
```

## Migration from Terraform

1. **Review existing infrastructure**: Document your VPC ID, subnet IDs, ALB ARN, security groups
2. **Update ECS stack**: Add your specific VPC and ALB references in `bin/cdk.ts`
3. **Deploy CDK**: Run `cdk deploy --all -c env=<env>`
4. **Verify**: Check AWS Console that resources are created correctly
5. **Update GitHub Actions**: The workflow is already configured for TypeScript CDK
6. **Destroy Terraform**: Once verified, run `terraform destroy`

## GitHub Actions Integration

The GitHub Actions workflow automatically:
1. Installs Node.js and dependencies
2. Builds Docker images
3. Deploys CDK stacks with the new image
4. Waits for ECS service stability

## Customization

### Adjust CPU/Memory
Edit [lib/ecs-stack.ts](lib/ecs-stack.ts#L73-L74):
```typescript
cpu: 256,          // 256 (.25 vCPU), 512 (.5 vCPU), etc.
memoryLimitMiB: 512,  // 512 MB, 1024 MB, etc.
```

### Adjust Autoscaling
Edit [lib/ecs-stack.ts](lib/ecs-stack.ts#L124-L144):
```typescript
minCapacity: 1,    // Minimum tasks
maxCapacity: 4,    // Maximum tasks
targetUtilizationPercent: 70,  // CPU threshold
```

### Enable Schedule-based Scaling
Uncomment lines 147-160 in [lib/ecs-stack.ts](lib/ecs-stack.ts#L147-L160).
