@isTest
public class ScheduleBatchClassToRemoveTest {
    public static testmethod void mytest(){
        ScheduleBatchClassToRemove scmb=new ScheduleBatchClassToRemove();
        //String cronExpr = '0 0 0 15 3 ? 2022';
        //String jobId = System.schedule('myJobTestJobName', cronExpr, scmb);
        scmb.execute(null);
        
    }
    
}