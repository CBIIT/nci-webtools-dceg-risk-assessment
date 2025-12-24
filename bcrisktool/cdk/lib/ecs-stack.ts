import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as elbv2 from 'aws-cdk-lib/aws-elasticloadbalancingv2';
import { Construct } from 'constructs';

export interface EcsStackProps extends cdk.StackProps {
  appName: string;
  envName: string;
  stackName: string;
  containerImage?: string;
  releaseVersion?: string;
  lastUpdated?: string;
  vpcId?: string;
  subnetIds?: string[];
  securityGroupIds?: string[];
  albListenerArn?: string;
  healthCheckPath?: string;
}

/**
 * ECS Fargate Stack - Creates ECS cluster, services, tasks, and autoscaling
 * Mirrors the Terraform ecs-webservices module functionality
 */
export class EcsStack extends cdk.Stack {
  public readonly cluster: ecs.Cluster;
  public readonly webTaskDefinition: ecs.FargateTaskDefinition;
  public readonly webService: ecs.FargateService;
  public readonly taskRole: iam.Role;

  constructor(scope: Construct, id: string, props: EcsStackProps) {
    super(scope, id, props);

    const { 
      appName, 
      envName, 
      stackName, 
      vpcId, 
      healthCheckPath = '/',
      containerImage,
      releaseVersion = '1.0.0',
      lastUpdated = new Date().toISOString().split('T')[0]
    } = props;

    // Determine the container image to use
    const imageUri = containerImage || 'public.ecr.aws/amazonlinux/amazonlinux:latest';

    // Import VPC - if vpcId not specified, find the first available VPC
    const vpc = vpcId
      ? ec2.Vpc.fromLookup(this, 'VPC', { vpcId })
      : ec2.Vpc.fromLookup(this, 'VPC', { 
          tags: { 'analysistools:Network': 'true' },
        });

    // Create ECS Cluster
    this.cluster = new ecs.Cluster(this, 'Cluster', {
      clusterName: `${stackName}-cluster`,
      vpc,
      containerInsights: true,
    });

    // Create Task Execution Role
    const executionRole = new iam.Role(this, 'TaskExecutionRole', {
      assumedBy: new iam.ServicePrincipal('ecs-tasks.amazonaws.com'),
      managedPolicies: [
        iam.ManagedPolicy.fromAwsManagedPolicyName('service-role/AmazonECSTaskExecutionRolePolicy'),
      ],
    });

    // Create Task Role (for application)
    this.taskRole = new iam.Role(this, 'TaskRole', {
      assumedBy: new iam.ServicePrincipal('ecs-tasks.amazonaws.com'),
      description: `Task role for ${appName}`,
    });

    // Create CloudWatch Log Group
    const logGroup = new logs.LogGroup(this, 'LogGroup', {
      logGroupName: `/ecs/${appName}`,
      retention: logs.RetentionDays.ONE_MONTH,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // Create Fargate Task Definition
    this.webTaskDefinition = new ecs.FargateTaskDefinition(this, 'WebTaskDefinition', {
      family: `${stackName}-web`,
      cpu: 256,
      memoryLimitMiB: 512,
      executionRole,
      taskRole: this.taskRole,
    });

    // Add Container (placeholder - will be updated by GitHub Actions)
    const container = this.webTaskDefinition.addContainer('backend', {
      image: ecs.ContainerImage.fromRegistry(imageUri),
      logging: ecs.LogDrivers.awsLogs({
        streamPrefix: `${envName}-backend`,
        logGroup,
      }),
      environment: {
        TIER: envName,
        APP_NAME: appName,
        RELEASE_VERSION: releaseVersion,
        LAST_UPDATED: lastUpdated,
      },
    });

    container.addPortMappings({
      containerPort: 80,
      protocol: ecs.Protocol.TCP,
    });

    // Create Security Group for ECS Service
    const serviceSecurityGroup = new ec2.SecurityGroup(this, 'ServiceSecurityGroup', {
      vpc,
      description: `Security group for ${appName} ECS service`,
      allowAllOutbound: true,
    });

    // Allow inbound traffic on port 80
    serviceSecurityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'Allow HTTP traffic'
    );

    // Create Fargate Service
    this.webService = new ecs.FargateService(this, 'WebService', {
      serviceName: `${stackName}-web-service`,
      cluster: this.cluster,
      taskDefinition: this.webTaskDefinition,
      desiredCount: 1,
      healthCheckGracePeriod: cdk.Duration.seconds(60),
      securityGroups: [serviceSecurityGroup],
      enableExecuteCommand: true,
      circuitBreaker: { rollback: true },
      assignPublicIp: true, // Set to false if using private subnets with NAT
    });

    // Setup Auto Scaling
    const scaling = this.webService.autoScaleTaskCount({
      minCapacity: 1,
      maxCapacity: 4,
    });

    // CPU-based autoscaling
    scaling.scaleOnCpuUtilization('CpuScaling', {
      targetUtilizationPercent: 70,
      scaleInCooldown: cdk.Duration.seconds(60),
      scaleOutCooldown: cdk.Duration.seconds(60),
    });

    // Memory-based autoscaling
    scaling.scaleOnMemoryUtilization('MemoryScaling', {
      targetUtilizationPercent: 80,
      scaleInCooldown: cdk.Duration.seconds(60),
      scaleOutCooldown: cdk.Duration.seconds(60),
    });

    // Optional: Schedule-based autoscaling
    // Uncomment if you need scheduled scaling
    /*
    scaling.scaleOnSchedule('ScaleUpMorning', {
      schedule: appscaling.Schedule.cron({ hour: '8', minute: '0' }),
      minCapacity: 2,
      maxCapacity: 4,
    });

    scaling.scaleOnSchedule('ScaleDownEvening', {
      schedule: appscaling.Schedule.cron({ hour: '18', minute: '0' }),
      minCapacity: 1,
      maxCapacity: 2,
    });
    */

    // Optional: ALB Integration
    // If you have an existing ALB, uncomment and configure:
    /*
    if (props.albListenerArn) {
      const listener = elbv2.ApplicationListener.fromApplicationListenerAttributes(
        this,
        'Listener',
        {
          listenerArn: props.albListenerArn,
          securityGroup: serviceSecurityGroup,
        }
      );

      const targetGroup = new elbv2.ApplicationTargetGroup(this, 'TargetGroup', {
        vpc,
        port: 80,
        protocol: elbv2.ApplicationProtocol.HTTP,
        targetType: elbv2.TargetType.IP,
        healthCheck: {
          path: healthCheckPath,
          healthyThresholdCount: 2,
          unhealthyThresholdCount: 3,
          interval: cdk.Duration.seconds(30),
        },
      });

      this.webService.attachToApplicationTargetGroup(targetGroup);

      listener.addTargetGroups('AddTargetGroup', {
        targetGroups: [targetGroup],
      });
    }
    */

    // Add tags
    cdk.Tags.of(this.cluster).add('Name', `${stackName}-cluster`);
    cdk.Tags.of(this.webService).add('Name', `${stackName}-web-service`);

    // Outputs
    new cdk.CfnOutput(this, 'ClusterName', {
      value: this.cluster.clusterName,
      description: 'ECS Cluster Name',
    });

    new cdk.CfnOutput(this, 'ServiceName', {
      value: this.webService.serviceName,
      description: 'ECS Service Name',
    });

    new cdk.CfnOutput(this, 'TaskDefinitionFamily', {
      value: this.webTaskDefinition.family,
      description: 'Task Definition Family',
    });
  }
}
