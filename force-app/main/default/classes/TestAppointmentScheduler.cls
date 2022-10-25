@isTest

public class TestAppointmentScheduler{

    public static testMethod void testschedule() {

        Test.StartTest();
        ScheduleFetchAppointmentFromPracto sh1 = new ScheduleFetchAppointmentFromPracto();

        String sch = '0 0 23 * * ?'; 
        
        system.schedule('Test Territory Check', sch, sh1); 
        
        Test.stopTest(); 
    }
}