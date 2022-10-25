@isTest
public class ScheduleCoustomNotificationContNRTest {
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
        
         Id RecordTypeIdacc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max@Home Nurse').getRecordTypeId();

        Account acc = new Account();
        acc.LastName = 'test';
        acc.Address_From_Geolocation__c = 'test';
        acc.recordtypeid=RecordTypeIdacc;
        acc.Nurse__c=u1.id;
        insert acc;
       
            

        
        Max_at_Home_Enquiry_Page__c m=new Max_at_Home_Enquiry_Page__c();
        m.Nurse__c=acc.id;
        m.Stage__c='Delivered';
        insert m;
        
        vital__c v=new vital__c();
        v.Isolation_Max_Home__c=m.id;
        v.Next_Notification_Date_Nurse__c=system.today();
        v.Time_One_Nurse__c='4:00pm';
        v.Time_TWO_Nurse__c='4:00pm';
        insert v;
        
        Test.StartTest();
          ScheduleCoustomNotificationControllerNrs sh1 = new ScheduleCoustomNotificationControllerNrs();
          String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
        
    }

}