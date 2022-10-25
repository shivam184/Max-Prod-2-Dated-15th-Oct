//Last Modified By Nitya on 2nd August 2022
trigger MaxIsolationTrigger on Max_at_Home_Enquiry_Page__c(before Insert,after insert, before update, after update, after delete ){
    set<Id> docId = new set<Id>();
    set<Id> nurseId = new set<Id>();
    set<id> setOfIds = new Set<id>();
    if (trigger.isInsert){
        if(trigger.isBefore)
        {
            MaxIsolationTriggerHelper.updateMAxAtHomeFromAccount(trigger.new); 
            MaxIsolationTriggerHelper.updatePatientName(trigger.new);
        }
        if(trigger.isAfter){
        for (Max_at_Home_Enquiry_Page__c eachLead : trigger.New ){
            if (eachLead.Doctor__c != null)
                docId.add(eachLead.Doctor__c);
            if (eachLead.Nurse__c != null)
                nurseId.add(eachLead.Nurse__c);
            setOfIds.add(eachLead.id);
        }
        MaxIsolationTriggerHelper.updateAccount(docId, nurseId);
        MaxIsolationTriggerHelper.updateTranactionId(setOfIds);
    }
    
 } else if (trigger.isUpdate){
    if(trigger.isBefore){
        MaxIsolationTriggerHelper.updatePatientName(trigger.new);
    }
    if(trigger.isAfter){
        for (Max_at_Home_Enquiry_Page__c eachLead : trigger.New ){
            if (eachLead.Doctor__c != trigger.oldMap.get(eachLead.id).Doctor__c)
                docId.add(eachLead.Doctor__c);
            if (eachLead.Nurse__c != trigger.oldMap.get(eachLead.id).Nurse__c)
                nurseId.add(eachLead.Nurse__c);
        }
        MaxIsolationTriggerHelper.updateAccount(docId, nurseId);
    }
}
}