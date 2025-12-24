import * as cdk from 'aws-cdk-lib';
import * as ecr from 'aws-cdk-lib/aws-ecr';
import { Construct } from 'constructs';

export interface EcrStackProps extends cdk.StackProps {
  appName: string;
  envName: string;
}

/**
 * ECR Stack - Creates container repositories
 * Mirrors the Terraform ECR module functionality
 */
export class EcrStack extends cdk.Stack {
  public readonly repository: ecr.Repository;

  constructor(scope: Construct, id: string, props: EcrStackProps) {
    super(scope, id, props);

    const { appName, envName } = props;

    // Create ECR repository
    this.repository = new ecr.Repository(this, 'Repository', {
      repositoryName: appName,
      imageScanOnPush: true,
      imageTagMutability: ecr.TagMutability.MUTABLE,
      removalPolicy: cdk.RemovalPolicy.RETAIN, // Keep images on stack deletion
      lifecycleRules: [
        {
          description: 'Keep last 10 images',
          maxImageCount: 10,
          rulePriority: 1,
        },
      ],
    });

    // Add tags
    cdk.Tags.of(this.repository).add('Name', `${appName}-ecr-${envName}`);
  }
}
