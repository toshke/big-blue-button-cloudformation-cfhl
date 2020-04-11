CloudFormation do


  tags = tags.collect { |k, v| { 'Key' => k, 'Value' => v } }

  cidr_components = cidr.split('.')
  cidr_components[3] = cidr_components[3].split('/')[0]
  subnet_bits = cidr.split('/')[1].to_i

  if subnet_bits > 16
    STDERR.print('VPC CIDR must be at least w/16 subnet mask')
    exit 1
  end


  # check for private ranges
  given_range = NetAddr::CIDR.create(cidr)
  r1 = NetAddr::CIDR.create('172.16.0.0/12')
  r2 = NetAddr::CIDR.create('10.0.0.0/8')
  r3 = NetAddr::CIDR.create('192.168.0.0/16')
  ok = (r1.contains? given_range) || (r2.contains? given_range) || (r3.contains? given_range)
  unless ok
    STDERR.print("CfndDSL VPC: #{cidr} must be valid private range!")
    exit 1
  end

  EC2_VPC('VPC') do
    CidrBlock cidr
    EnableDnsHostnames true
    EnableDnsSupport true
    InstanceTenancy 'default'
    Tags extended_tags(tags, { 'Name' => name })
  end


  if internet_enabled
    EC2_InternetGateway('Gateway') do
      Tags extended_tags(tags, { 'Name' => "gateway#{name}" })
    end

    EC2_VPCGatewayAttachment('GatewayAttachment') do
      VpcId Ref('VPC')
      InternetGatewayId Ref('Gateway')
    end
  end

  subnet_counter = 0
  current_subnet = "#{cidr_components[0]}.#{cidr_components[1]}.#{subnet_counter}.0/24"

  ## subnets
  ## public subnets
  i = 0
  public_subnets = []
  private_subnets = []
  markers = %w(A B C D E F G)
  if internet_enabled
    availability_zones.each do |az|
      subnet_name = "Public#{markers[i]}"
      public_subnets << subnet_name
      EC2_Subnet(subnet_name) do
        VpcId Ref('VPC')
        AvailabilityZone az
        CidrBlock current_subnet
        MapPublicIpOnLaunch false
        Tags [{ 'Key' => 'Name', 'Value' => "#{name}-#{subnet_name}" }]
      end
      Output(subnet_name) do
        Value(Ref(subnet_name))
      end
      subnet_counter = subnet_counter + 1
      current_subnet = "#{cidr_components[0]}.#{cidr_components[1]}.#{subnet_counter}.0/24"
      i = i+1
    end
  end
  ## private subnets
  i = 0
  availability_zones.each do |az|
    subnet_name = "Private#{markers[i]}"
    private_subnets << subnet_name
    EC2_Subnet(subnet_name) do
      VpcId Ref('VPC')
      AvailabilityZone az
      CidrBlock current_subnet
      MapPublicIpOnLaunch false
      Tags [{ 'Key' => 'Name', 'Value' => "#{name}-#{subnet_name}" }]
    end
    Output(subnet_name) do
      Value(Ref(subnet_name))
    end
    subnet_counter = subnet_counter + 1
    current_subnet = "#{cidr_components[0]}.#{cidr_components[1]}.#{subnet_counter}.0/24"
    i = i+1
  end

  route_tables = []

  ## route tables and their associations
  if internet_enabled
    EC2_RouteTable('PublicRouteTable') do
      VpcId Ref('VPC')
      Tags [{ 'Key' => 'Name', 'Value' => "#{name}-publicrt" }]
    end
    route_tables << Ref('PublicRouteTable')

    EC2_Route('PublicRoute') do
      GatewayId Ref('Gateway')
      DestinationCidrBlock '0.0.0.0/0'
      RouteTableId Ref('PublicRouteTable')
    end
    i = 0
    public_subnets.each do |subnet|
      EC2_SubnetRouteTableAssociation("PublicRTAssociations#{i}") do
        SubnetId Ref(subnet)
        RouteTableId Ref('PublicRouteTable')
      end
      i = i+1
    end
  end

  if nat_gateway['enabled']
    if not internet_enabled
      STDERR.print('Simple VPC Nat Gateway enabled, but no internet access,set `internet_enabled` to true')
    end

    if nat_gateway['per_az']
      public_subnets.each_with_index do |public_subnet, ix|
        EC2_EIP("EIPNat#{markers[ix]}") do
          Domain 'vpc'
        end
        EC2_NatGateway("NatGateway#{markers[ix]}") do
          AllocationId FnGetAtt("EIPNat#{markers[ix]}", 'AllocationId')
          SubnetId Ref(public_subnet)
          Tags extended_tags(tags, { 'Name' => "#{name}-nat-gateway#{markers[ix]}" })
        end
      end
      private_subnets.each_with_index do |private_subnet, ix|
        rt_name = "PrivateSubnetInternetRoute#{markers[ix]}"
        route_tables << Ref(rt_name)
        EC2_RouteTable(rt_name) do
          VpcId Ref('VPC')
          Tags [{ 'Key' => 'Name', 'Value' => "#{name}-privatert-#{markers[ix]}" }]
        end
        EC2_SubnetRouteTableAssociation("#{rt_name}Assoc#{ix}") do
          SubnetId Ref(private_subnet)
          RouteTableId Ref(rt_name)
        end
        EC2_Route("PrivateSubnetInternetRoute#{ix}") do
          NatGatewayId Ref("NatGateway#{markers[ix]}")
          DestinationCidrBlock '0.0.0.0/0'
          RouteTableId Ref(rt_name)
        end
      end
    else
      EC2_EIP('EIPNat') do
        Domain 'vpc'
      end
      EC2_NatGateway('NatGateway') do
        SubnetId Ref(public_subnets[0])
        AllocationId FnGetAtt('EIPNat', 'AllocationId')
        Tags extended_tags(tags, { 'Name' => "#{name}-nat-gateway" })
      end
      EC2_RouteTable('PrivateRouteTable') do
        VpcId Ref('VPC')
        Tags [{ 'Key' => 'Name', 'Value' => "#{name}-privatert" }]
      end
      route_tables << Ref('PrivateRouteTable')


      EC2_Route('PrivateSubnetInternetRoute') do
        NatGatewayId Ref('NatGateway')
        DestinationCidrBlock '0.0.0.0/0'
        RouteTableId Ref('PrivateRouteTable')
      end
      private_subnets.each_with_index do |private_subnet, ix|
        EC2_SubnetRouteTableAssociation("PrivateSubnetRouteAssoc#{ix}") do
          SubnetId Ref(private_subnet)
          RouteTableId Ref('PrivateRouteTable')
        end
      end

    end
  end

  ## NACLs


  ## endpoints
  if s3_endpoint then
    EC2_VPCEndpoint('VPCEndpointS3') do
      VpcId Ref('VPC')
      PolicyDocument({
          Version: '2012-10-17',
          Statement: [{
              Effect: 'Allow',
              Principal: '*',
              Action: ['s3:*'],
              Resource: ['arn:aws:s3:::*']
          }]
      })
      ServiceName FnSub('com.amazonaws.${AWS::Region}.s3')
      RouteTableIds route_tables
    end
  end
  if dynamodb_endpoint then
    EC2_VPCEndpoint('VPCEndpointDynamo') do
      VpcId Ref('VPC')
      PolicyDocument({
          Version: '2012-10-17',
          Statement: [{
              Effect: 'Allow',
              Principal: '*',
              Action: ['dynamodb:*'],
              Resource: ['*']
          }]
      })
      ServiceName FnSub('com.amazonaws.${AWS::Region}.dynamodb')
      RouteTableIds route_tables
    end
  end


  ## Outputs
  Output('VpcId') do
    Value Ref('VPC')
  end
end