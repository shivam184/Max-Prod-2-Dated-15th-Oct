global class BatchClassToRemoveDuplicateRecords implements Database.Batchable<AggregateResult> {
    
    
    global Iterable<AggregateResult> start(Database.BatchableContext BC){ 
        String query = 'SELECT Max_Id__c,Count(Id) con FROM Account WHERE RecordType.Name = \'Patient\' AND Max_Id__c != NULL GROUP BY Max_Id__c having Count(Id) > 1 LIMIT 10000';
        return new AggregateResultIterable(query); 
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        
        Integer count = 1;
        String maxId = '';
        List<Sobject> listDataToUpdate = new List<Sobject>();
        List<Account> listAccountToDelete = new List<Account>();
        
        for(sObject s : scope){ 
            AggregateResult ar = (AggregateResult)s;
            count = (Integer)ar.get('con');
            maxId = (String)ar.get('Max_Id__c');
        }
        
        if(count != 1) {
            String accId = '';
            Set<Id> setAccountId = new Set<Id>();
            for(Account acc : [SELECT Id FROM Account WHERE RecordType.Name = 'Patient' AND Max_Id__c = :maxId]) {
                setAccountId.add(acc.Id);
                accId = acc.Id;
            }
            setAccountId.remove(accId);
            
            for(Lead__c lead : [SELECT Id FROM Lead__c WHERE Patient__c IN :setAccountId]) {
                Lead__c ld = new Lead__c();
                ld.Id = lead.Id;
                ld.Patient__c = accId;
                listDataToUpdate.add(ld);
            }
            
            for(Appointment__c appoint : [SELECT Id FROM Appointment__c WHERE Patient__c IN :setAccountId]) {
                Appointment__c app = new Appointment__c();
                app.Id = appoint.Id;
                app.Patient__c = accId;
                listDataToUpdate.add(app);
            }
            
            for(Admission_Acknowledgement__c admsn : [SELECT Id FROM Admission_Acknowledgement__c WHERE Patient__c IN :setAccountId]) {
                Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
                adm.Id = admsn.Id;
                adm.Patient__c = accId;
                listDataToUpdate.add(adm);
            }
            
            for(Internationalpatient_Outstanding__c intPat : [SELECT Id FROM Internationalpatient_Outstanding__c WHERE Patient__c IN :setAccountId]) {
                Internationalpatient_Outstanding__c iPat = new Internationalpatient_Outstanding__c();
                iPat.Id = intPat.Id;
                iPat.Patient__c = accId;
                listDataToUpdate.add(iPat);
            }
            
            for(Prospect__c prosp : [SELECT Id FROM Prospect__c WHERE Account__c IN :setAccountId]) {
                Prospect__c pro = new Prospect__c();
                pro.Id = prosp.Id;
                pro.Account__c = accId;
                listDataToUpdate.add(pro);
            }
            
            for(Billing_Summary__c billSum : [SELECT Id FROM Billing_Summary__c WHERE Patient__c IN :setAccountId]) {
                Billing_Summary__c bs = new Billing_Summary__c();
                bs.Id = billSum.Id;
                bs.Patient__c = accId;
                listDataToUpdate.add(bs);
            }
            
            for(String accountId : setAccountId) {
                Account acc = new Account();
                acc.Id = accountId;
                listAccountToDelete.add(acc);
            }
            
            if(listDataToUpdate.size() > 0)
                update listDataToUpdate;
            
            if(listAccountToDelete.size() > 0)
                delete listAccountToDelete;
             
        }
    }  
    
    global void finish(Database.BatchableContext bc){
        
    }    
}