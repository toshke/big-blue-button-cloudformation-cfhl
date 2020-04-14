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

  CloudFormation_WaitCondition(:WaitSetupComplete) do
    Count 1
    Timeout 1800
    Handle Ref(:WaitSetupCompleteHandle)
  end

  CloudFormation_WaitConditionHandle(:WaitSetupCompleteHandle) {}

  IAM_Role(:RestoreRole) do
    Path '/'
    AssumeRolePolicyDocument service_assume_role_policy('backup')
    ManagedPolicyArns %w(arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores)
  end
  Backup_BackupSelection(:BackupSelection) do
    BackupPlanId FnGetAtt('backup', 'Outputs.BackupPlanId')
    BackupSelection ({
        IamRoleArn: FnGetAtt(:RestoreRole, 'Arn'),
        SelectionName: 'bbb-backup-selection',
        ListOfTags: [{
            ConditionKey: "ec2:ResourceTag/#{backup_tag_key}",
            ConditionType: 'STRINGEQUALS',
            ConditionValue: "#{tags[backup_tag_key]}"
        }]
    })
  end

  Output(:ServerUrl) do
    Value(FnSub('https://${DomainName}'))
  end

end