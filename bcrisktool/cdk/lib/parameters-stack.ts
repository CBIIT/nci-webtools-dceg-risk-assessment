import * as cdk from 'aws-cdk-lib';
import * as ssm from 'aws-cdk-lib/aws-ssm';
import { Construct } from 'constructs';

export interface ParametersStackProps extends cdk.StackProps {
  appName: string;
  envName: string;
  ecsClusterName: string;
  ecsWebTaskFamily: string;
  ecsWebServiceName: string;
  taskRoleArn: string;
}

/**
 * SSM Parameters Stack - Creates parameters for ECS resources
 * Mirrors the Terraform parameters module functionality
 */
export class ParametersStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: ParametersStackProps) {
    super(scope, id, props);

    const { appName, envName, ecsClusterName, ecsWebTaskFamily, ecsWebServiceName, taskRoleArn } = props;
    const parameterPath = `/analysistools/${envName}/${appName}`;

    // ECS Cluster parameter
    new ssm.StringParameter(this, 'EcsClusterParameter', {
      parameterName: `${parameterPath}/ecs_cluster`,
      stringValue: ecsClusterName,
      description: `ECS cluster name for ${appName}`,
      tier: ssm.ParameterTier.STANDARD,
    });

    // ECS Web Task parameter
    new ssm.StringParameter(this, 'EcsWebTaskParameter', {
      parameterName: `${parameterPath}/ecs_web_task`,
      stringValue: ecsWebTaskFamily,
      description: `ECS web task definition family for ${appName}`,
      tier: ssm.ParameterTier.STANDARD,
    });

    // ECS Web Service parameter
    new ssm.StringParameter(this, 'EcsWebServiceParameter', {
      parameterName: `${parameterPath}/ecs_web_service`,
      stringValue: ecsWebServiceName,
      description: `ECS web service name for ${appName}`,
      tier: ssm.ParameterTier.STANDARD,
    });

    // Task Role ARN parameter
    new ssm.StringParameter(this, 'RoleArnParameter', {
      parameterName: `${parameterPath}/role_arn`,
      stringValue: taskRoleArn,
      description: `Task role ARN for ${appName}`,
      tier: ssm.ParameterTier.STANDARD,
    });

    // Outputs
    new cdk.CfnOutput(this, 'ParameterPath', {
      value: parameterPath,
      description: 'SSM Parameter Path',
    });
  }
}
