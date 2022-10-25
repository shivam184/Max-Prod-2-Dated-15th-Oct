@isTest
public class CMPBatch3SchedulerTest {
    public static testMethod void test(){
        
        Test.StartTest();
        CMPBatch3Scheduler sh1 = new CMPBatch3Scheduler();
        
        String sch = '0 0 9 3/3 * ? *'; 
        system.schedule('CMP Batch3 Scheduler1', sch, sh1); 
        Test.stopTest();
    }
}