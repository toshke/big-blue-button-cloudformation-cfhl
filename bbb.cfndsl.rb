CloudFormation do


  EC2_EIP(:EIPResource) do
    Condition :EIPNotProvided if external_eip
  end

  Route53_RecordSet(:DNSRecord) do
    Condition :ZoneProvided
    HostedZoneName FnSub('${Route53Zone}.')
    Name Ref(:DomainName)
    Type :A
    ResourceRecords FnIf(:EIPNotProvided, [Ref(:EIPResource)], [Ref(:ElasticIP)]) if external_eip
    ResourceRecords [Ref(:EIPResource)] unless external_eip
    TTL 3600
  end

  Output(:ServerUrl) do
    Value(FnSub('https://${DomainName}'))
  end

end