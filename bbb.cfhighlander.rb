CfhighlanderTemplate do

  ami_id = ENV.fetch('BBB_AMI_ID', image_id)

  Parameters do
    ComponentParam :Route53Zone, '', description: 'Route53 Zone name to create A record -e.g. example.com. Leave empty for manual DNS configuration. Omit trailing dot'
    ComponentParam :ElasticIP, '', description: 'Elastic IP Address to assign to BBB server. Will be created if non given' if external_eip
    ComponentParam :ImageId, ami_id, type: 'AWS::EC2::Image::Id', description: 'AMI Id for Ubuntu 16.04 Server Machine Image. Default to cannonical image within template region'
    unless render_vpc
      ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>', description: 'Subnets to place ASG instances into'
    end
  end

  Condition(:EIPNotProvided, FnEquals(Ref(:ElasticIP), '')) if external_eip
  Condition(:EIPProvided, FnNot(FnEquals(Ref(:ElasticIP), ''))) if external_eip
  Condition(:ZoneProvided, FnNot(FnEquals(Ref(:Route53Zone), '')))

  # render vpc with public subnets to place big blue instance in
  Component template: 'simple-vpc', name: 'vpc' if render_vpc


  user_data = File.read "#{template_dir}/user_data.sh"
  Component template: 'simple-asg', name: 'asg', config: { 'user_data' => user_data, 'tags' => tags } do
    # passing parameter values
    parameter name: 'ImageId', value: Ref(:ImageId)
    parameter name: 'SubnetIds', value: FnGetAtt('vpc', 'Outputs.PublicA') if render_vpc
    parameter name: 'SubnetIds', value: FnJoin(',', Ref('SubnetIds')) unless render_vpc
    parameter name: :EIP, value: FnIf(:EIPProvided, Ref(:ElasticIP), Ref(:EIPResource)) if external_eip
    parameter name: :EIP, value: Ref(:EIPResource) unless external_eip
    parameter name: :WaitHandle, value: Ref(:WaitSetupCompleteHandle)

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