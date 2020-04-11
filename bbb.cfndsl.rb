CloudFormation do


  EC2_EIP(:EIPResource) do
    Condition :EIPNotProvided
  end

  Route53_RecordSet(:DNSRecord) do
    Condition :ZoneProvided
    HostedZoneName FnSub('${Route53Zone}.')
    Name Ref(:DomainName)
    Type :A
    ResourceRecords FnIf(:EIPNotProvided, [Ref(:EIPResource)], [Ref(:ElasticIP)])
    TTL 3600
  end

  Output(:ServerUrl) do
    Value(FnSub('https://${DomainName}'))
  end

end