//Description: Apex Trigger to perform following functions on prospect record
//1) Map the record owner based on Assigned Doctor and it's hospital location
//2) Map secondary doctor's co-ordinator on Prospect record (if applicable)
//3) Share the prospect record with the secondary owner as read only access
//Created by: Techmatrix Consulting.

trigger ProspectTrigger on Prospect__c (before insert, before update, after update,after insert) {
    TriggerExecutions__c trex = TriggerExecutions__c.getOrgDefaults();
    
    if(trex.Prospect__c){
        ProspectTriggerHelper prospectHelper = new ProspectTriggerHelper();
        
        if(trigger.isBefore)
            prospectHelper.prospectIsBeforeEvent(trigger.new);
        
        if(trigger.isAfter)
            prospectHelper.prospectUpdateEvent(trigger.new, trigger.oldMap);
        
    }
    
     if(trigger.isafter && (trigger.isInsert || trigger.isUpdate) ){
     //ProspectTriggerHelperToUpdateOncoTracker.iopAutoPopulationMethod(trigger.new);
         ProspectTriggerHelper.updateIopjRecord(trigger.new);
     }
    if(trigger.isbefore && trigger.isInsert){
        ProspectTriggerHelper.tagInternationalOpPatient(trigger.new);
    }
}