CloudFormation do


  real_rules = backup_rules.collect do |it|
    new_rule = it.clone
    new_rule['TargetBackupVault'] = FnGetAtt(it['TargetBackupVault'], 'BackupVaultName')
    new_rule
  end

  plan = {
      BackupPlanName: Ref(:PlanName),
      BackupPlanRule: real_rules,
  }

  vault_names = backup_rules.collect { |it| it['TargetBackupVault'] }
  vault_names.each do |vault|
    Backup_BackupVault(vault) do
      DeletionPolicy :Retain
      BackupVaultName vault if named
      BackupVaultName FnSub('${AWS::StackName}vault') unless named
    end
  end

  Backup_BackupPlan(:BackupPlan) do
    BackupPlanTags tags
    BackupPlan plan
  end
  index = 0
  backup_selection.each do |el|
    Resource("BackupSelection#{index}") do
      Type('AWS::Backup::BackupSelection')
      Property('BackupPlanId', Ref(:BackupPlan))
      Property('BackupSelection', {
          IamRoleArn: FnGetAtt(:RestoreRole, 'Arn'),
          SelectionName: named ? FnSub("${PlanName}Selection#{index}") : FnSub("${AWS::StackName}${PlanName}Selection#{index}"),
          ListOfTags: [{
              ConditionKey: el['tag_key'],
              ConditionType: 'STRINGEQUALS',
              ConditionValue: el['tag_value']
          }]
      })
    end
    index = index + 1
  end
  IAM_Role(:RestoreRole) do
    Path '/'
    AssumeRolePolicyDocument service_assume_role_policy('backup')
    ManagedPolicyArns %w(arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores)
  end


  Output(:BackupPlanId) do
    Value Ref(:BackupPlan)
  end

end