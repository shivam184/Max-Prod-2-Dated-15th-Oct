trigger RecmmondedTestTrigger on Recommended_Test__c (after insert,after update) {
    
    RecmmondedTestTriggerHelper ackHelper = new RecmmondedTestTriggerHelper();
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            ackHelper.RollUpTestMrpToLead(trigger.new);
        }
    }
    
}