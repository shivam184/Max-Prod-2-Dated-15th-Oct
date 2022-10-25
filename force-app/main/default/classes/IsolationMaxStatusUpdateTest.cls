@isTest
public class IsolationMaxStatusUpdateTest {
    
     @isTest
    public static void runTest(){
          Profile p1 = [SELECT Id FROM Profile WHERE Name LIKE 'System Administrator'];

        
        User u1 = new User(Alias = 'standt',
                          Email='standarer@storg.com', 
                          EmailEncodingKey='UTF-8',
                          LastName='Testing1',
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',
                          ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standardr@te.com');        
        Insert u1;
        
         Id RecordTypeIdacc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max@Home Doctor').getRecordTypeId();

        Account acc = new Account();
        acc.LastName = 'test';
        acc.Address_From_Geolocation__c = 'test';
        acc.recordtypeid=RecordTypeIdacc;
        acc.Doctor__c=u1.id;
        insert acc;
        
        
         Id RecordTypeIdacc1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max@Home Nurse').getRecordTypeId();

        Account acc1 = new Account();
        acc1.LastName = 'test';
        acc1.Address_From_Geolocation__c = 'test';
        acc1.recordtypeid=RecordTypeIdacc1;
       // acc.Doctor__c=u1.id;
        insert acc1;
       Id RecordTypeIdacc2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();

        Account acc2 = new Account();
        acc2.LastName = 'test';
        acc2.Address_From_Geolocation__c = 'test';
        acc2.recordtypeid=RecordTypeIdacc2;
       // acc.Doctor__c=u1.id;
        insert acc2;
            list<Max_at_Home_Enquiry_Page__c> listMax=new list<Max_at_Home_Enquiry_Page__c>();

        
        Max_at_Home_Enquiry_Page__c m=new Max_at_Home_Enquiry_Page__c();
        m.Doctor__c=acc.id;
        m.Stage__c='Delivered';
        m.nurse__c=acc1.id;
        m.Patient_Search__c=acc2.id;
        insert m;
        listMax.add(m);
        
        E_Prescription__c ep=new E_Prescription__c();
        ep.Isolation_Max_Home__c=m.id;
        insert ep;
        
    }

}