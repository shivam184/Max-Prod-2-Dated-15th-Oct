global class VisaInviteBatchClass implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query =' SELECT Id,Max_ID__c,CreatedDate,Patient__c,Stage__c FROM Visa_Invite__c';
        query += ' WHERE Patient__c=NULL AND Id NOT IN (Select Visa_Invite__c From Admission_Acknowledgement__c)';
        query +=  ' AND Id NOT IN (Select Visa_Invite__c From Billing_Summary__c) AND Stage__c=\'New\'';
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Visa_Invite__c> records){
        List<Visa_Invite__c> listVisaInviteUpdate=new List<Visa_Invite__c>();
        for (Visa_Invite__c visaInvite : records){
            DateTime  regDate;
            regDate =visaInvite.CreatedDate;
            if(regDate.date().daysBetween(system.today())>90){
                visaInvite.Stage__c='Expired';
                listVisaInviteUpdate.add(visaInvite);
            }
        }
        if(listVisaInviteUpdate.size()>0)
            Database.SaveResult[] srList = Database.Update(listVisaInviteUpdate, false);
        
    }    
    global void finish(Database.BatchableContext bc){
    }    
}