trigger OncologypatientTrigger on oncology_patient_journey__c (before update) {

    if(trigger.isbefore && trigger.isUpdate){
			System.debug('Inside Trigger');
            OncologypatientTriggerHelper.updateOncology(Trigger.New);
    }
    
    // if(trigger.IsAfter && trigger.IsUpdate){
			
           //OncologypatientTriggerHelper.CreateProspect(Trigger.New);
    //}
}