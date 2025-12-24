#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { EcrStack } from '../lib/ecr-stack';
import { EcsStack } from '../lib/ecs-stack';
import { ParametersStack } from '../lib/parameters-stack';

const app = new cdk.App();

// Get context variables
const envName = app.node.tryGetContext('env') || 'dev';
const createEcr = app.node.tryGetContext('create_ecr') || false;
const containerImage = app.node.tryGetContext('container_image');
const releaseVersion = app.node.tryGetContext('release_version');
const lastUpdated = app.node.tryGetContext('last_updated');
const vpcId = app.node.tryGetContext('vpc_id');
const awsAccount = process.env.AWS_ACCOUNT_ID || process.env.CDK_DEFAULT_ACCOUNT;
const awsRegion = process.env.AWS_REGION || process.env.CDK_DEFAULT_REGION || 'us-east-1';

const env = {
  account: awsAccount,
  region: awsRegion,
};

// Configuration
const appName = 'bcrisktool';
const stackName = `analysistools-${envName}-${appName}`;

// Common tags
const commonTags = {
  Application: appName,
  Environment: envName,
  ManagedBy: 'CDK',
};

// ECR Stack (optional - set create_ecr context to true if you want CDK to manage ECR)
let ecrStack: EcrStack | undefined;
if (createEcr) {
  ecrStack = new EcrStack(app, `${stackName}-ecr`, {
    appName,
    envName,
    env,
    tags: commonTags,
  });
}

// ECS Stack
const ecsStack = new EcsStack(app, `${stackName}-ecs`, {
  appName,
  envName,
  stackName,
  containerImage,
  releaseVersion,
  lastUpdated,
  vpcId,
  env,
  tags: commonTags,
  // Optional: Configure subnets, ALB
  // subnetIds: ['subnet-xxxxx', 'subnet-yyyyy'],
  // albListenerArn: 'arn:aws:elasticloadbalancing:...',
  // healthCheckPath: '/',
});

// Parameters Stack (optional - only create if needed for external tools)
// Commenting out since we're using CDK outputs directly in GitHub Actions
/*
const parametersStack = new ParametersStack(app, `${stackName}-parameters`, {
  appName,
  envName,
  ecsClusterName: ecsStack.cluster.clusterName,
  ecsWebTaskFamily: ecsStack.webTaskDefinition.family,
  ecsWebServiceName: ecsStack.webService.serviceName,
  taskRoleArn: ecsStack.taskRole.roleArn,
  env,
  tags: commonTags,
});

parametersStack.addDependency(ecsStack);
*/

app.synth();
