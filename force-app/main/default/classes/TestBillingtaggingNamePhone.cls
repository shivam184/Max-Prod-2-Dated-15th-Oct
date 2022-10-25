@istest
public class TestBillingtaggingNamePhone {

    public static testmethod void testsample(){
        
        lead__c ld = new lead__c();
        ld.Name='Shivam test';
        ld.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        ld.Mobile_Phone__c='12347680';
        insert ld;
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account ac = new Account(); 
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.PersonEmail = 'test@gm.com';
        ac.PersonMobilePhone = '7508447594';
        insert ac;
        
        Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.Patient__c=ac.id;
        bs1.alletec_patientname__c='Shivam test';
        insert bs1;
        
        Test.startTest();
        BillingtaggingNamePhone obj = new BillingtaggingNamePhone();
        DataBase.executeBatch(obj); 
        Test.stopTest();

        


    }
  
}