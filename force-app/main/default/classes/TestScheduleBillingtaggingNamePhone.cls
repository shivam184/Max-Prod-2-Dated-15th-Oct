@istest
public class TestScheduleBillingtaggingNamePhone {
    public static testMethod void testschedule() {
       
        Test.StartTest();
        ScheduleBillingtaggingNamePhone sh1 = new ScheduleBillingtaggingNamePhone();
        String sch = '0 30 23 1/1 * ? *';  
        system.schedule('Test Territory Check', sch, sh1); 
       // sh1.execute(null);
        Test.stopTest();
    }

}