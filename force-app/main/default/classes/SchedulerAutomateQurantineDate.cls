global class SchedulerAutomateQurantineDate implements Schedulable{
    global void execute(SchedulableContext SC) {
        AutomateQuarantineDateBatch obj = new AutomateQuarantineDateBatch ();
        Database.executeBatch(obj);
        //start();
        
    }
    public static void start(){
        DateTime currentTime = System.now().addMinutes(Integer.valueOf(Label.SchedulerAutomateQurantineDay));
        String cronExp = ' '+currentTime.second()+' '+currentTime.minute()+' '+currentTime.hour()+' '+currentTime.day()+' '+currentTime.month()+' ? '+currentTime.year();
        System.schedule('Execute  Every 10 minute'+currentTime, cronExp, new SchedulerAutomateQurantineDate()); 
    }    
}