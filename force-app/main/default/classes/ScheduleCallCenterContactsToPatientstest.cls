@isTest
public class ScheduleCallCenterContactsToPatientstest {
    public static testmethod void test(){
        
        
        // This test runs a scheduled job at midnight Sept. 3rd. 2022
        String Scheduledate = '0 0 0 3 9 ? 2022';
        System.schedule('ScheduleCallCenterContactsToPatients', Scheduledate, new ScheduleCallCenterContactsToPatients());
        
    }
    
}