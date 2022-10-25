global class BillingSummaryUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        STRING query='SELECT Id,billingautotag_test__c FROM Billing_Summary__c WHERE alletec_isinternational__c=true AND HCF_Source__c=NULL AND Patient__c!=NULL AND name__c!=NULL AND alletec_billdate__c!=NULL AND alletec_billdate__c=THIS_MONTH';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<Billing_Summary__c> listBilling){ 
        SYSTEM.debug('===>listBilling=='+listBilling);
        list<Billing_Summary__c> listld=new list<Billing_Summary__c>();
        for(Billing_Summary__c bill : listBilling){
            
            bill.billingautotag_test__c='International tagging testing';
                
            system.debug('===bill=='+bill);
            listld.add(bill);
        }
        update listld;
        system.debug('===>listld'+listld);
    }
    global void finish(Database.BatchableContext bc){
        
    } 
}