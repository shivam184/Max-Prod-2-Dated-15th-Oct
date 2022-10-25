public class OncoProspectPopulationonBillingHandler {
   public static void iopAutoPopulationMethod(List<Billing_Summary__c> billingSummaryList) {
        try {
            Set<String> maxIDSet = new Set<String>();
            for(Billing_Summary__c billingSummartObj : billingSummaryList) {
                if(billingSummartObj.name__c == NULL) {
                    continue;
                }
                maxIDSet.add(billingSummartObj.name__c);
            }
            System.debug('@maxIDSet: '+maxIDSet);
            Map<String, Prospect__c> mapMaxIDWithONCOTracker = new Map<String, Prospect__c>();
              String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
            
              System.debug('@maxIDSet: '+maxIDSet);
            System.debug('@Record ID: '+oncorecordTypeId);
            for(Prospect__c prospect : [SELECT Id, Max_Id__c,Treatment_Completed__c ,Billing_List__c FROM Prospect__c 
                                                                      WHERE Max_Id__c in :maxIDSet and RecordTypeID =: oncorecordTypeId  ])
            {
                System.debug('inside prospect');
                if(!prospect.Treatment_Completed__c){
                		mapMaxIDWithONCOTracker.put(prospect.Max_Id__c, prospect);
                }
            }
           
            System.debug('@mapMaxIDWithONCOTracker.values(): '+mapMaxIDWithONCOTracker.values());
            
            for(Billing_Summary__c billingSummartObj : billingSummaryList) {
                if(mapMaxIDWithONCOTracker.containsKey(billingSummartObj.name__c)){
                billingSummartObj.Onco_Tracker__c = mapMaxIDWithONCOTracker.get(billingSummartObj.name__c).Id;
                }
            }
            System.debug('@billingSummaryList: '+billingSummaryList);
        }
        catch(Exception e) {
            System.debug('Error Message: ' + e.getMessage() + 'at Line Number: ' + e.getLineNumber());
        }
    }
}