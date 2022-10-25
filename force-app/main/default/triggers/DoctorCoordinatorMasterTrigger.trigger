trigger DoctorCoordinatorMasterTrigger on Doctor_Coordinator_Master__c (before insert , before update) {
	
    TriggerExecutions__c triggercheck = TriggerExecutions__c.getOrgDefaults();
    if(triggercheck.Doctor_Coordinator_Master__c) {
        if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
            DoctorCoordinatorTriggerHelper.beforeInsert(trigger.new);
    }
}