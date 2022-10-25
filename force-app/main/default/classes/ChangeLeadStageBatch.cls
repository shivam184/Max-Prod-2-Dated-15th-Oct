global class ChangeLeadStageBatch implements Database.Batchable<sObject>{
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id,Max_ID__c,Submitted_On__c,First_OPD_Bill_Date__c FROM Lead__c WHERE RecordType.Name = \'Digital Customer Acquisition\' AND Stage__c!=\'OPD Consult Taken\' AND Stage__c!=\'Closed Lost\' AND Max_ID__c  != NULL AND createdDate=LAST_N_DAYS:60';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Lead__c> ldLst){
        list<lead__c> leadList=new list<lead__c>();
        set<String> setOfMaxIds=new set<string>();
        if(ldLst!=null){
            for(lead__c lead:ldLst){
                setOfMaxIds.add(lead.max_id__c);
            }
        }
        
        list<billing_summary__c> listOfBillingSummaries=[select name__c from billing_summary__c where name__c in :setOfMaxIds and Digital_Lead__c=null and createddate=LAST_N_DAYS:180 and alletec_billdate__c!=null];
        system.debug(listOfBillingSummaries);
        map<string,billing_summary__c> mapOfBillingSummary=new map<string,billing_summary__c>();
        for(billing_summary__c bill:listOfBillingSummaries){
            mapOfBillingSummary.put(bill.name__c.toLowerCase(),bill);
        }
        for(lead__c lead:ldLst){
            if(mapOfBillingSummary.containsKey(lead.max_id__c.toLowerCase())){
                lead.stage__c='OPD Consult Taken';
                leadList.add(lead);
            }
        }
        update leadList;
    }
    global void finish(Database.BatchableContext BC){
    }
}