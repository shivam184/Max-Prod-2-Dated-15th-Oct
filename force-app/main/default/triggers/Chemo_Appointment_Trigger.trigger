trigger Chemo_Appointment_Trigger on Chemo_Appointment__c (before insert) {
    
if(trigger.isBefore && trigger.isInsert ){ 
         
            ChemoTriggerHelper chemoHelper = new ChemoTriggerHelper();
            ChemoTriggerHelper.UpdateProspect(trigger.New);

        }
}