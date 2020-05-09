CfhighlanderTemplate do

  ami_id = ENV.fetch('BBB_AMI_ID', image_id)

  Parameters do
    ComponentParam :Route53Zone, '', description: 'Route53 Zone name to create A record -e.g. example.com. Leave empty for manual DNS configuration. Omit trailing dot'
    ComponentParam :ElasticIP, '', description: 'Elastic IP Address to assign to BBB server. Will be created if non given' if external_eip
    ComponentParam :ImageId, ami_id, type: 'AWS::EC2::Image::Id', description: 'AMI Id for Ubuntu 16.04 Server Machine Image. Default to cannonical image within template region'
    unless render_vpc
      ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>', description: 'Subnets to place ASG instances into'
    end
    ComponentParam :DeploymentMode,'EC2', type: 'String', allowedValues: %w(ASG EC2), description: 'Deploy in an AutoScalingGroup or as a static EC2 server'
    ComponentParam :InstanceType, instance_type_default, description: 'InstanceType to use for ASG instances'
  end

  Condition(:EIPNotProvided, FnEquals(Ref(:ElasticIP), '')) if external_eip
  Condition(:EIPProvided, FnNot(FnEquals(Ref(:ElasticIP), ''))) if external_eip
  Condition(:ZoneProvided, FnNot(FnEquals(Ref(:Route53Zone), '')))
  Condition(:DeployAsg, FnEquals(Ref(:DeploymentMode),'ASG'))
  Condition(:DeployEC2, FnEquals(Ref(:DeploymentMode),'EC2'))

  # render vpc with public subnets to place big blue instance in
  Component template: 'simple-vpc', name: 'vpc' if render_vpc


  user_data = File.read "#{template_dir}/user_data.sh"
  Component template: 'simple-asg', name: 'asg', condition: :DeployAsg, conditional: true,
      config: { 'user_data' => user_data, 'tags' => tags } do
    # passing parameter values
    parameter name: 'ImageId', value: Ref(:ImageId)
    parameter name: 'SubnetIds', value: FnGetAtt('vpc', 'Outputs.PublicA') if render_vpc
    parameter name: 'SubnetIds', value: FnJoin(',', Ref('SubnetIds')) unless render_vpc
    parameter name: :EIP, value: FnIf(:EIPProvided, Ref(:ElasticIP), Ref(:EIPResource)) if external_eip
    parameter name: :EIP, value: Ref(:EIPResource) unless external_eip
    parameter name: :WaitHandle, value: Ref(:WaitSetupCompleteHandle)
    parameter name: :InstanceType, value: Ref(:InstanceType)
    # extended parameters from default component
    Parameters do
      # global parameters bubble up to top level component without prefix
      ComponentParam :DomainName, type: 'String', isGlobal: true, description: 'FQDN for your BBB Server. Must be subdomain of provided Route53 zone, if one given'
      ComponentParam :AdminEmail, type: 'String', isGlobal: true
      ComponentParam :EIP, type: 'String'
      ComponentParam :RootVolumeSpace, 40, type: 'Number', description: 'Size in GB for server root volume. Default install takes about 8GB', isGlobal: true, minValue: 20
      ComponentParam :ConfigSSMPath, default_ssm_path, type: 'String', description: 'Path in SSM to store configuration', isGlobal: true
      ComponentParam :WaitHandle
    end
  end

  user_data = File.read "#{template_dir}/user_data.sh"
  Component template: 'github.com:toshke/cfhl-component-simple-instance#master', name: 'ec2', condition: :DeployEC2, conditional: true,
      config: { 'user_data' => user_data, 'tags' => tags } do
    # passing parameter values
    parameter name: :Ami, value: Ref(:ImageId)
    parameter name: :SubnetId, value: FnGetAtt('vpc', 'Outputs.PublicA') if render_vpc
    parameter name: :SubnetId, value: FnSelect(0, FnSplit(',', Ref('SubnetIds'))) unless render_vpc
    parameter name: :EIP, value: FnIf(:EIPProvided, Ref(:ElasticIP), Ref(:EIPResource)) if external_eip
    parameter name: :EIP, value: Ref(:EIPResource) unless external_eip
    parameter name: :WaitHandle, value: Ref(:WaitSetupCompleteHandle)
    parameter name: :RootVolumeSize, value: Ref(:RootVolumeSpace)
    parameter name: :Name, value: tags['Name']
    parameter name: :KeyName, value: ''
    parameter name: :InstanceType, value: Ref(:InstanceType)
    # extended parameters from default component
    Parameters do
      # global parameters bubble up to top level component without prefix
      ComponentParam :DomainName, type: 'String', isGlobal: true, description: 'FQDN for your BBB Server. Must be subdomain of provided Route53 zone, if one given'
      ComponentParam :AdminEmail, type: 'String', isGlobal: true
      ComponentParam :EIP, type: 'String'
      ComponentParam :ConfigSSMPath, default_ssm_path, type: 'String', description: 'Path in SSM to store configuration', isGlobal: true
      ComponentParam :WaitHandle
      ComponentParam :TerminationProtection,'true', isGlobal: true, allowedValues: %w(true false), description: 'Enable termination protection if deployed in EC2 mode. Has no effect on ASG deployment'
    end
  end


  backup_config = {
      'backup_selection' => [{
          'tag_key' => 'Name',
          'tag_value' => tags['Name']
      }]
  }
  Component template: 'aws-backup-plan', name: 'backup', config: backup_config do
    # overriding backup plan name
    parameter name: :PlanName, value: backup_plan_name

  end

end