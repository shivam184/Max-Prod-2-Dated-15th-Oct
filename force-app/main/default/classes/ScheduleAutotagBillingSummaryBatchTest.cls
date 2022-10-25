@isTest
public class ScheduleAutotagBillingSummaryBatchTest {
 static testMethod void UpdateBillmethod(){
     Account acc = new Account ();
     acc.lastname = 'prostar';
     acc.Max_ID__c = 'po123';
     acc.PersonMobilePhone = '8987676545';
     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
     insert acc;
     
     
     Billing_Summary__c billing = new Billing_Summary__c();
     billing.Patient__c = acc.id;
     billing.name__c=acc.Max_ID__c;
     billing.alletec_isinternational__c=true;
     billing.alletec_billdate__c=system.today().addMonths(-3);
     insert billing;
     
     Test.startTest();                
     String CRONEXP = '0 0 0 3 9 ? 2022';
     system.schedule('Test Territory Check', CRONEXP,new ScheduleAutotagBillingSummaryBatch());
     Test.stopTest(); 
 }
}