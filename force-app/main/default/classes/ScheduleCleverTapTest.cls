@istest
public class ScheduleCleverTapTest {
    public static testMethod void testschedule() {
       
        Test.StartTest();
        ScheduleCleverTap sh1 = new ScheduleCleverTap();
        String sch = '0 0 0 1/1 * ? *';  
        system.schedule('Test Territory Check', sch, sh1); 
       // sh1.execute(null);
        Test.stopTest();
    }
}