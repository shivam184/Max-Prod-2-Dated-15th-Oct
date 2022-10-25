public class OncologypatientTriggerHelper {
    
    
    // To Update prospect on the bases of Max Id 
    public static void updateOncology(list<oncology_patient_journey__c > triggerNew)
    {
        System.debug('111');
        Id devRecordTypeId = Schema.SObjectType.Prospect__c .getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        List<oncology_patient_journey__c> UpdateOncoList = new List<oncology_patient_journey__c>();
        for(oncology_patient_journey__c onco : triggerNew)
        {
            /*
			Integer i = ((onco.CreatedDate.Date()).daysBetween(onco.LastModifiedDate.Date()))* 24 ;
				if(onco.EP_Number__c  != triggerOldMap.get(onco.id).EP_Number__c && i > 24){
					onco.Stage__c = 'Lead Close';
					UpdateOncoList.add(onco);

						}
			*/
            if(  onco.E_Precription__c )
            {
                system.debug('Inside E-Prescription');
                onco.Stage__c = 'E-Prescription';
                
                if(onco.E_Precription__c  && onco.Benign__c)
                {
                    system.debug('Inside Benign__c');
                    onco.Stage__c = 'Lead Close';
                    //UpdateOncoList.add(onco);
                }
                Else if( onco.E_Precription__c &&
                        (onco.Malignant__c || onco.Requires_More_Investigation__c))
                {
                    system.debug('Inside Maligant');
                    onco.Stage__c = 'Convert to Prospect';
                    //UpdateOncoList.add(onco);
                }          	
            }
        }
    }
   
}