@isTest
public class ChangeLeadStageBatchTest {
 @isTest 
    public static void test1(){
       
        String recordtypeIdld = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        
        list<lead__c> leadList = new list<lead__c>();
        
        Lead__c ld1 = new lead__c();
        ld1.Name = 'test1';
        ld1.RecordTypeId = recordtypeIdld;
        ld1.Mobile_Phone__c = '9876543210';
        ld1.First_OPD_Bill_Date__c=system.now();
        ld1.Max_ID__c='N-123';
        leadList.add(ld1);
        
        lead__c ld2 = new lead__c();
        ld2.Name = 'test2';
        ld2.Email__c = 'test@test.com';
        ld2.RecordTypeId = recordtypeIdld;
        ld2.First_OPD_Bill_Date__c=system.now();
        ld2.Max_ID__c='M-123';
        leadList.add(ld2);
        
        insert leadList;
        List<Billing_summary__c> bsList=new List<Billing_summary__c>();
        Billing_summary__c bs=new Billing_Summary__c();
            bs.name__c='M-123';
            bs.alletec_billdate__c=system.today();
            bsList.add(bs);
        Billing_summary__c bs1=new Billing_Summary__c();
            bs1.name__c='N-123';
            bs1.alletec_billdate__c=system.today();
            bsList.add(bs1);
        insert bsList;
        
        test.startTest();
        Database.executeBatch(new changeLeadStageBatch());
        test.stopTest();
    }
}