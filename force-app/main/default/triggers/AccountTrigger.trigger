trigger AccountTrigger on Account (before insert,before update,after insert) {
    TriggerExecutions__c trex = TriggerExecutions__c.getOrgDefaults();
    
    if(trex.Account__c){
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                AccountTriggerHelper.doInsert();
            }
            if(Trigger.isInsert){
                AccountTriggerHelper.accountFieldMapping();
                AccountTriggerHelper.validationDuplicate(Trigger.New);

            }
        }
        
        if(Trigger.isAfter && Trigger.isInsert){
            // Added by Navin Soni on 24-08-2021 for future method.
            Set<String> setOfAccountIds = new Set<String>();
            for(Account objAcc : trigger.new){
                setOfAccountIds.add(objAcc.Id);
            }
           AccountTriggerHelper.mapMaxIDonDigtialLeads(setOfAccountIds);
       }
        
    }
    
}