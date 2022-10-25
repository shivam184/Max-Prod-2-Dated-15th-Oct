trigger CampaignCodeManagementTrigger on Campaign_Code_Management__c (before insert) {
    TriggerExecutions__c triggerExecution = TriggerExecutions__c.getOrgDefaults();
    
    if(triggerExecution.Campaign_Code_Trigger__c){
        if(trigger.isBefore && trigger.isInsert){
            CampaignCodeManagementTriggerHelper.CampaignCodeGenerate(trigger.new);
        }
    }
    
}