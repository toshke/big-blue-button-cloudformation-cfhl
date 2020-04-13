CloudFormation do

  name = external_parameters.fetch(:name)
  instance_userdata = external_parameters.fetch(:user_data)
  capacity = external_parameters.fetch(:capacity)
  termination_policies = external_parameters.fetch(:termination_policies)
  policies = external_parameters.fetch(:policies)
  managed_policies = external_parameters.fetch(:managed_policies)
  public_ip = external_parameters.fetch(:public_ip)
  allow_incoming = external_parameters.fetch(:allow_incoming)

  ingress_rules = []

  allow_incoming.each do |it|
    rule = { CidrIp: it['range'], IpProtocol: it.fetch('protocol', 'tcp') }
    if it['port'].to_s.include? '-'
      rule[:FromPort] = it['port'].split('-')[0]
      rule[:ToPort] = it['port'].split('-')[1]
    else
      rule[:FromPort] = it['port'].to_i
      rule[:ToPort] = it['port'].to_i
    end
    ingress_rules << rule
  end

  EC2_SecurityGroup(:ASGSecGroup) do
    VpcId Ref('VpcId')
    GroupDescription "#{name} - ASG SG"
    SecurityGroupIngress ingress_rules unless ingress_rules.empty?
  end

  Output(:SecurityGroup) do
    Value(Ref(:ASGSecGroup))
  end

  IAM_Role(:Role) do
    Path '/'
    AssumeRolePolicyDocument service_assume_role_policy('ec2')
    ManagedPolicyArns managed_policies unless managed_policies.empty?
    Policies policies unless policies.empty?
  end

  IAM_InstanceProfile(:InstanceProfile) {
    Path '/'
    Roles [Ref(:Role)]
  }

  lt_data = {
      IamInstanceProfile: { Arn: FnGetAtt(:InstanceProfile, :Arn) },
      ImageId: Ref(:ImageId),
      InstanceInitiatedShutdownBehavior: shutdown_behaviour,
      InstanceType: Ref(:InstanceType),
      SecurityGroupIds: [Ref(:ASGSecGroup)],
      UserData: FnBase64(FnSub(instance_userdata))
  }

  lt_data[:KeyName] = Ref(:KeyName) if allow_ssh

  if public_ip
    lt_data[:NetworkInterfaces] = [{
        AssociatePublicIpAddress: true,
        DeviceIndex: 0,
        Groups: [Ref(:ASGSecGroup)] }]
    lt_data.delete :SecurityGroupIds
  end

  EC2_LaunchTemplate(:LaunchTemplate) do
    LaunchTemplateData lt_data
    LaunchTemplateName "#{name}-lt" if named_resources
  end

  AutoScaling_AutoScalingGroup(:ASG) do
    AutoScalingGroupName "#{name}" if named_resources
    # line below causes Ref fn to be wrapped within array, hence using Property statement instead
    # VPCZoneIdentifier Ref(:SubnetIds)
    Property('VPCZoneIdentifier', Ref(:SubnetIds))
    LaunchTemplate ({ LaunchTemplateId: Ref(:LaunchTemplate), Version: FnGetAtt(:LaunchTemplate, :LatestVersionNumber) })
    MinSize capacity.fetch(:min, '1')
    MaxSize capacity.fetch(:max, '1')
    DesiredCapacity capacity.fetch(:desired, '1')
    TerminationPolicies termination_policies
    Tags [{ Key: 'Name', Value: "#{name}-asg", PropagateAtLaunch: true }]
  end

end