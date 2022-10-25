@isTest 
private class CovidSMSClassTest {

   static testMethod void service_call(){
        
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
       
            list<Max_at_Home_Enquiry_Page__c> listMax=new list<Max_at_Home_Enquiry_Page__c>();

        Max_at_Home_Enquiry_Page__c m=new Max_at_Home_Enquiry_Page__c();
        m.Doctor__c=acc.id;
        m.Stage__c='Delivered';
        m.Phone_No__c = '9898989898';
       // insert m;
        listMax.add(m);
        insert listMax;
        
        E_Prescription__c ep=new E_Prescription__c();
        ep.Isolation_Max_Home__c=m.id;
        insert ep;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyHttpCalloutMock());
       
        CovidSMSClass CovidObj = new CovidSMSClass();
        CovidSMSClass.sendSMS(listMax[0].Id);
        
        
        Test.stopTest();
    }
    
    
}