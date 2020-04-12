CfhighlanderTemplate do

  ami_id = ENV.fetch('BBB_AMI_ID', image_id)

  Parameters do
    ComponentParam :Route53Zone, '', description: 'Route53 Zone name to create A record -e.g. example.com. Leave empty for manual DNS configuration. Omit trailing dot'
    ComponentParam :ElasticIP, '', description: 'Elastic IP Address to assign to BBB server. Will be created if non given'
    ComponentParam :ImageId, ami_id, type: 'AWS::EC2::Image::Id', description: 'AMI Id for Ubuntu 16.04 Server Machine Image. Defaults to ap-southeast-2 AMI'
  end

  Condition(:EIPNotProvided, FnEquals(Ref(:ElasticIP), ''))
  Condition(:EIPProvided, FnNot(FnEquals(Ref(:ElasticIP), '')))
  Condition(:ZoneProvided, FnNot(FnEquals(Ref(:Route53Zone), '')))

  # render vpc with public subnets to place big blue instance in
  Component template: 'simple-vpc', name: 'vpc'


  user_data = File.read "#{template_dir}/user_data.sh"
  Component template: 'simple-asg', name: 'asg', config: { 'user_data' => user_data } do
    # passing parameter values
    parameter name: 'ImageId', value: Ref(:ImageId)
    parameter name: 'SubnetIds', value: FnGetAtt('vpc', 'Outputs.PublicA')
    parameter name: :EIP, value: FnIf(:EIPProvided, Ref(:ElasticIP), Ref(:EIPResource))

    # extended parameters from default component
    Parameters do
      # global parameters bubble up to top level component without prefix
      ComponentParam :DomainName, type: 'String', isGlobal: true, description: 'FQDN for your BBB Server. Must be subdomain of provided Route53 zone, if one given'
      ComponentParam :AdminEmail, type: 'String', isGlobal: true
      ComponentParam :EIP, type: 'String'
    end
  end

end