@isTest
public class ScheduleRemoveDuplicateRecordsTest {
 @isTest
    public static void runTest(){
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.invoicenumber__c='12345';
        bs.alletec_transactiontype__c='OP';
        bs.TransactionBillNo__c = '112';
        insert bs;
        
        Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.invoicenumber__c = '121345';
        bs1.alletec_transactiontype__c = 'OP';
        bs1.TransactionBillNo__c = '112';
        insert bs1;
        
        Billing_Summary__c bs2 = new Billing_Summary__c();
        bs2.invoicenumber__c = '121345';
        bs2.alletec_transactiontype__c = 'OP';
        bs2.TransactionBillNo__c = '112';
        insert bs2;
        
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new ScheduleRemoveDuplicateRecords());
        Test.stopTest(); 
    }
}