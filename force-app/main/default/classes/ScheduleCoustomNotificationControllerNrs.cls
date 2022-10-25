global class ScheduleCoustomNotificationControllerNrs implements Schedulable{
global void execute(SchedulableContext sc) {
      BatchCustomNotificationAPIForNurse b = new BatchCustomNotificationAPIForNurse();
      Database.executeBatch(b);
      start();
}
    
        public static void start(){
        DateTime currentTime = System.now().addMinutes(Integer.valueOf(Label.CustomNotificationcontroller));
        String cronExp = ' '+currentTime.second()+' '+currentTime.minute()+' '+currentTime.hour()+' '+currentTime.day()+' '+currentTime.month()+' ? '+currentTime.year();
        System.schedule('Execute Schedule Nurse Notification class in Every 30 minute'+currentTime, cronExp, new ScheduleCoustomNotificationControllerNrs()); 
    }
}