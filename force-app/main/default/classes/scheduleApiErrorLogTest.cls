@isTest
public class scheduleApiErrorLogTest {
public static testMethod void test(){
        
        Test.StartTest();
        scheduleApiErrorLog sh1 = new scheduleApiErrorLog();
        
        String sch = '0 0 23 * * ? *'; 
        system.schedule('Delete Api Error Log', sch, sh1); 
        Test.stopTest();
    }
}