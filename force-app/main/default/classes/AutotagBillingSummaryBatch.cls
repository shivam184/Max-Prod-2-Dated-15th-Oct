global class AutotagBillingSummaryBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id FROM Billing_Summary__c WHERE Patient__c!=NULL AND name__c!=NULL AND alletec_isinternational__c=True AND HCF_Source__c=NULL AND (CreatedDate = TODAY OR CreatedDate = YESTERDAY)';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Billing_Summary__c> BillingSummaryList){
        //List<Billing_Summary__c> listBillToUpdate=new List<Billing_Summary__c>();
        //For(Billing_Summary__c bill:BillingSummaryList){
        //    listBillToUpdate.add(bill);
        //}
        Update BillingSummaryList;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}