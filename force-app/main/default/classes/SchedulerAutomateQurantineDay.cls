global class SchedulerAutomateQurantineDay  implements Schedulable{
    global void execute(SchedulableContext SC) {
        AutomateQuarantineDayBatch obj = new AutomateQuarantineDayBatch ();
        Database.executeBatch(obj);
     //   start();
        
    }
 /*   public static void start(){
        DateTime currentTime = System.now().addMinutes(Integer.valueOf(Label.SchedulerAutomateQurantineDay));
        String cronExp = ' '+currentTime.second()+' '+currentTime.minute()+' '+currentTime.hour()+' '+currentTime.day()+' '+currentTime.month()+' ? '+currentTime.year();
        System.schedule('Execute  Every 10 minute'+currentTime, cronExp, new SchedulerAutomateQurantineDay()); 
    }    */
}


/*global class SchedulerAutomateQurantineDayBatch implements Schedulable{
global void execute(SchedulableContext SC) {
AutomateQuarantineDayBatch obj = new AutomateQuarantineDayBatch ();
Database.executeBatch(obj); 
}    
}*/