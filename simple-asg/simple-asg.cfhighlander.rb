CfhighlanderTemplate do


  DependsOn 'lib-iam@0.1.0'

  Parameters do
    ComponentParam 'ImageId', 'ami-08fdde86b93accf1c', type: 'AWS::EC2::Image::Id', description: 'Amazon Machine Image (AMI) for ASG'
    ComponentParam :InstanceType, instance_type_default, description: 'InstanceType to use for ASG instances'
    ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>', description: 'Subnets to place ASG instances into'
    ComponentParam 'VpcId', type: 'AWS::EC2::VPC::Id', description: 'VPC for network elements (SG)'
    ComponentParam 'KeyName', type: 'AWS::EC2::KeyPair::KeyName', description: 'SSH KeyPair to login to ASG instances. Consider using SSM Session Manager' if allow_ssh
  end

end