@istest
public class SchedulerBillingSUmmaryBatchupdateTest {
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        
                  ScheduleBillingSummaryUpdateBatch sh1 = new ScheduleBillingSummaryUpdateBatch();
          String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        
        Test.stopTest();
    }
    
}