trigger InternationalOPPatientJourney on International_OP_Patient_Journey__c (after insert, before insert, before update, after update) {
    Trigger_Setting_All_Objects__mdt ioTrigger=[select id, Before_Insert__c,before_update__c, after_insert__c, after_update__c from Trigger_Setting_All_Objects__mdt where DeveloperName='IOPJ_Object'];
    if(ioTrigger.After_Insert__c && ioTrigger.After_Update__c){
    if(trigger.isafter && (trigger.isInsert|| trigger.isUpdate) ){
        InternationalOPPatientJourneyHelper.updateBillingSummaryOnIopCreation(trigger.new);
    }
    }
    
    if(trigger.isBefore){
        if(trigger.isInsert && ioTrigger.Before_Insert__c){
            InternationalOPPatientJourneyHelper.ChangeStage(trigger.new, null);
        }
        else if(trigger.isUpdate && ioTrigger.Before_Update__c){
            InternationalOPPatientJourneyHelper.ChangeStage(trigger.new, trigger.oldmap);
        }
    }
}