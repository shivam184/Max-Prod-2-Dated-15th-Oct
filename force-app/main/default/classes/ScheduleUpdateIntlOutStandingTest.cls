@isTest
public class ScheduleUpdateIntlOutStandingTest {
    
   public static testmethod void test()
    {
        Internationalpatient_Outstanding__c io = new Internationalpatient_Outstanding__c();
        insert io;
        
        Internationalpatient_Outstanding__c io2 = new Internationalpatient_Outstanding__c();
        io2.Id = io.Id;
        update io2;
        
        String Timee = '0 0 0 3 9 ? 2022';
        System.schedule('ScheduleUpdateInternationalOutStanding', Timee, new ScheduleUpdateInternationalOutStanding());

    }

}