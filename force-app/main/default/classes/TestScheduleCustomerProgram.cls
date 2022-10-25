@isTest
public class TestScheduleCustomerProgram{


    static testMethod void testschedule() {

        Test.StartTest();
        
        ScheduleCustomerProgramBatch sh1 = new ScheduleCustomerProgramBatch();

        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        
        Test.stopTest(); 
        
    }

}