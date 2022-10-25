@istest
public class ScheduleCountryMappingBatchClassTest {
     public static testmethod void mytest(){
     ScheduleCountryMappingBatchClass scmb=new ScheduleCountryMappingBatchClass();
     String cronExpr = '0 0 0 15 3 ? 2022';
     String jobId = System.schedule('myJobTestJobName', cronExpr, scmb);
     scmb.execute(null);
   
     }
}