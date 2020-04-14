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
      BackupVaultName vault
    end
  end

  Backup_BackupPlan(:BackupPlan) do
    BackupPlanTags tags
    BackupPlan plan
  end

  Output(:BackupPlanId) do
    Value Ref(:BackupPlan)
  end

end