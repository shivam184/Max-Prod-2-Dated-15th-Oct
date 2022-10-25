global class ScheduleCoustomNotificationController implements Schedulable{

   global void execute(SchedulableContext sc) {
      BatchCustomNotificationAPI b = new BatchCustomNotificationAPI();
      Database.executeBatch(b);
  start();
}
    
        public static void start(){
        DateTime currentTime = System.now().addMinutes(Integer.valueOf(Label.CustomNotificationcontroller));
        String cronExp = ' '+currentTime.second()+' '+currentTime.minute()+' '+currentTime.hour()+' '+currentTime.day()+' '+currentTime.month()+' ? '+currentTime.year();
        System.schedule('Execute Doctor Notification class in Every 30 minute'+currentTime, cronExp, new ScheduleCoustomNotificationController()); 
    }
}