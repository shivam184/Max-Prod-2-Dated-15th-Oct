@istest
public class BillingSummaryUpdateBatchTest {
    @isTest
    public static void runTest(){
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc = new Account();
        acc.RecordTypeId = patientRecordTypeId;
        acc.LastName = 'Patient Account';        
        acc.Max_ID__c ='Test1';
        insert acc;
        
        
        /*  
Billing_Summary__c bill=new Billing_Summary__c();
bill.name__c='SKDD.12345';
bill.alletec_isinternational__c=true;
bill.alletec_billdate__c=system.today().addMonths(-1);
BILL.Patient__c=Acc.ID;
Insert Bill;*/
        
        
        List<Billing_Summary__c> listbill= new List<Billing_Summary__c>();
        for(Integer i=0 ;i <200;i++)
        {
            Billing_Summary__c bill=new Billing_Summary__c();
            bill.name__c='SKDD.12345';
            bill.alletec_isinternational__c=true;
            bill.billingautotag_test__c='International tagging testing';
            bill.alletec_billdate__c=system.today().addMonths(-1);
            BILL.Patient__c=Acc.ID;
            listbill.add(BILL);            
        }
        Insert listbill;
        
        Test.startTest();
        BillingSummaryUpdateBatch obj = new BillingSummaryUpdateBatch();
        
        Database.QueryLocator ql = obj.start(null);
        obj.execute(null,listbill);
        obj.Finish(null);
   
        Test.stopTest();
        
    }
}