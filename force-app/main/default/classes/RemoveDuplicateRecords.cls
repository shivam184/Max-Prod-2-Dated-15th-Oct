global class RemoveDuplicateRecords implements Database.Batchable<AggregateResult> {
    
    global Iterable<AggregateResult> start(Database.BatchableContext BC){ 
        String query = 'SELECT TransactionBillNo__c,Count(Id) con FROM Billing_Summary__c WHERE TransactionBillNo__c != NULL GROUP BY TransactionBillNo__c having Count(Id) > 1';
        return new AggregateResultIterable(query); 
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        String transactionBillNo = '';
        List<Billing_Summary__c> listBillingSummaryToDelete = new List<Billing_Summary__c>();
        List<Sobject> listDataToUpdate = new List<Sobject>();

        set<String> setBillingIdwe = new set<String>();
        for(sObject s : scope){ 
            AggregateResult ar = (AggregateResult)s;
            transactionBillNo = (String)ar.get('TransactionBillNo__c');
            setBillingIdwe.add(transactionBillNo);
        }
        String BillingId = '';
        Map<string,list<Id>> setBillingMap = new Map<string,list<Id>>();
        Set<Id> setBillingId = new Set<Id>();
        for(Billing_Summary__c bill : [SELECT Id,TransactionBillNo__c FROM Billing_Summary__c WHERE TransactionBillNo__c IN :setBillingIdwe]) {
            list<Id> tmp = new list<Id>();
            if(setBillingMap.containsKey(bill.TransactionBillNo__c))
                tmp = setBillingMap.get(bill.TransactionBillNo__c);
            tmp.add(bill.id);
            setBillingMap.put(bill.TransactionBillNo__c,tmp);  
        } 
        
        for(string str : setBillingMap.keySet()){
            if(setBillingMap.get(str).size()>1)
                setBillingMap.get(str).remove(0);
            setBillingId.addAll( setBillingMap.get(str));
        }
        
        for(String billId : setBillingId) {               
            Billing_Summary__c bill = new Billing_Summary__c();
            bill.Id = billId;
            listBillingSummaryToDelete.add(bill);
            system.debug('=====listBillingSummaryToDelete='+listBillingSummaryToDelete);
        }
        if(listBillingSummaryToDelete.size()>0)
            delete listBillingSummaryToDelete;
    }
    global void finish(Database.BatchableContext bc){
        
    } 
}