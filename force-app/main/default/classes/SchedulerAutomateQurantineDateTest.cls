@isTest
public class SchedulerAutomateQurantineDateTest {
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
       
       
        
        Max_at_Home_Enquiry_Page__c m=new Max_at_Home_Enquiry_Page__c();
        m.Doctor__c=acc.id;
        m.Stage__c='Delivered';
        m.Quarantine_Day__c='1';
        insert m;
        
        vital__c v=new vital__c();
        v.Isolation_Max_Home__c=m.id;
        v.Doctor_Frequency_date__c = system.today();
        v.Next_Notification_date__c=system.today();
      
        v.Time_One__c='12:00PM';
        insert v;
        
        Test.StartTest();
          SchedulerAutomateQurantineDate sh1 = new SchedulerAutomateQurantineDate();
        SchedulerAutomateQurantineDate.start();
          String sch = '18 18 18 13 7 ? 2020'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
}