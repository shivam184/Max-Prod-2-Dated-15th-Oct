public class IOPPopulationOnBillingSummaryHandler {
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
            Map<String, International_OP_Patient_Journey__c> mapMaxIDWithIOPJourney = new Map<String, International_OP_Patient_Journey__c>();
            for(International_OP_Patient_Journey__c IOPJourneyObj : [SELECT Id, Patient_Max_id__c,Journey_Day__c FROM International_OP_Patient_Journey__c 
                                                                      WHERE Patient_Max_id__c in :maxIDSet  and (Stage__c <> 'Closed Won'  OR Stage__c <> 'Closed Lost') ])
            {
                if(IOPJourneyObj.Journey_Day__c < 90)
                {
                		mapMaxIDWithIOPJourney.put(IOPJourneyObj.Patient_Max_id__c, IOPJourneyObj);
                }
            }
       
            System.debug('@mapMaxIDWithIOPJourney.values(): '+mapMaxIDWithIOPJourney.values());
         
            for(Billing_Summary__c billingSummartObj : billingSummaryList) {
                if(mapMaxIDWithIOPJourney.Containskey(billingSummartObj.name__c)){
                billingSummartObj.IOP_Journey__c = mapMaxIDWithIOPJourney.get(billingSummartObj.name__c).Id;
                }
            }
            System.debug('@billingSummaryList: '+billingSummaryList);
        }
        catch(Exception e) {
            System.debug('Error Message: ' + e.getMessage() + 'at Line Number: ' + e.getLineNumber());
        }
    }
}