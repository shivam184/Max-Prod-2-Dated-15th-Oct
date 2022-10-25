@isTest
public class Lead_Transmission_to_patient_Batch_Test {
    public static testmethod void test()
    {
        Account acc = new Account ();
        acc.lastname = 'prostar';
        acc.PersonMobilePhone = '12121212';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc;
        
        contact con = new contact();
        con.LastName = 'prostar';
        con.Phone = '12121212';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert con;
        
        list<lead__c> ldlist = new list<lead__c>();
        for(integer i=0;i<190;i++)
        {
            lead__c ld = new lead__c();
            ld.name='test lead';
            ld.Parent_Contact_for_lead__c= con.Id;
            ld.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
            ldlist.add(ld);            
        }
        insert ldlist;
        
        Test.startTest();
        
        Lead_Transmission_to_patient_Batch leadtest = new Lead_Transmission_to_patient_Batch();
        database.executeBatch(leadtest);
        
        Test.stopTest();
        
        
    }
    
}