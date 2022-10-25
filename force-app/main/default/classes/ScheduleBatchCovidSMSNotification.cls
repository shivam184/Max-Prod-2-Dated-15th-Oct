global class ScheduleBatchCovidSMSNotification  implements Schedulable{
    
    
    global void execute(SchedulableContext sc) {
        BatchCovidSMSNotification b = new BatchCovidSMSNotification();
        
        database.executebatch(b);
    }
    
}