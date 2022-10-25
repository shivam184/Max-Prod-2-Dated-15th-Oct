global class UpdatePatientOnBillingSummary implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext b){ 
        return Database.getQueryLocator('SELECT Id,Patient__c,name__c FROM Billing_Summary__c WHERE Patient__c = NULL and name__c != NULL');
    }
    
    global void execute(Database.BatchableContext b,List<Billing_Summary__c> listBillingSummary){ 
        Map<String,Id> mapMaxIdToPatientId = new Map<String,Id>();
        
        if(listBillingSummary != NULL && listBillingSummary.size() > 0){
            for(Billing_Summary__c bSummary : listBillingSummary){
                mapMaxIdToPatientId.put(bSummary.name__c,null);
            }
            
            for(Account acc : [Select Id,Max_ID__c from Account WHERE Max_ID__c IN : mapMaxIdToPatientId.keySet()]){
                if(mapMaxIdToPatientId.containsKey(acc.Max_ID__c))
                    mapMaxIdToPatientId.put(acc.Max_ID__c,acc.Id);
            }            
            for(Billing_Summary__c bSummary : listBillingSummary){
                if(mapMaxIdToPatientId.containsKey(bSummary.name__c)){
                    if(mapMaxIdToPatientId.get(bSummary.name__c) != NULL)
                        bSummary.Patient__c = mapMaxIdToPatientId.get(bSummary.name__c);
                    
                }
            }            
            Database.SaveResult[] result = Database.update(listBillingSummary,false);                                    
            List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
            
            for(Integer i=0;i<result.size();i++){
                if(test.isRunningTest()){
                    if(!result[i].isSuccess()){                    
                        API_Error_Log__c apiError = new API_Error_Log__c();
                        apiError.API_Name__c = 'UpdatePatientOnBillingSummaryBatch';
                        apiError.Error_Message__c = String.valueOf(result[i].getErrors());
                        apiError.Trigger_Point__c = 'UpdatePatientOnBillingSummary';
                        apiError.Record_Identifier__c = '{"Billling Summary Id" : "'+listBillingSummary[i].Id+'","Max ID" : "'+listBillingSummary[i].name__c+'"}';
                        listApiErrorLog.add(apiError); 
                    }                      
                }                                                      
            }                                                                                                           
            if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                insert listApiErrorLog;
        }                
    }
    
    global void finish(Database.BatchableContext b){
        
    }
    
}