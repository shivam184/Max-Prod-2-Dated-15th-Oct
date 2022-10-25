@isTest
public class BatchClassToRemoveDuplicateRecordsTest {
    
    @isTest 
    static void test1(){
        List<Account> accList = new List<Account>();
        List<SObject> sObjList = new List<SObject>();
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(recTypeId != NULL){
            for(integer i=0; i<5; i++){
                Account acc1 = new Account();
                acc1.RecordTypeId = recTypeId;
                acc1.LastName = 'Test Account'+i;
                acc1.Max_ID__c = '1234';  
                accList.add(acc1);
            }  
            if(accList != NULL && accList.size() > 0)
                insert accList;
        }  
        
        if(accList != NULL && accList.size() > 0){
            Appointment__c appoint = new Appointment__c();
            appoint.Patient__c = accList[0].Id;
            sObjList.add(appoint);
            
            Lead__c lead = new Lead__c();
            lead.Name ='Test Lead';
            lead.Patient__c = accList[1].Id;
            sObjList.add(lead);
            
            Admission_Acknowledgement__c admAck = new Admission_Acknowledgement__c();
            admAck.Patient__c = accList[1].Id;
            sObjList.add(admAck);
            
            Internationalpatient_Outstanding__c io = new Internationalpatient_Outstanding__c();
            io.Patient__c = accList[2].Id;
            sObjList.add(io); 
            
            Prospect__c prospect = new Prospect__c();
            prospect.Name = 'Test Prospect';
            prospect.Account__c = accList[3].Id;
            sObjList.add(prospect); 
            
            Billing_Summary__c bs = new Billing_Summary__c();
           	bs.Patient__c = accList[3].Id;
            sObjList.add(bs); 
       }
        
        if(sObjList != NULL && sObjList.size() > 0)
            insert sObjList;
        
        Test.startTest();
        BatchClassToRemoveDuplicateRecords obj = new BatchClassToRemoveDuplicateRecords();
        Database.executeBatch(obj);
        Test.stopTest();
        
    }
    
}