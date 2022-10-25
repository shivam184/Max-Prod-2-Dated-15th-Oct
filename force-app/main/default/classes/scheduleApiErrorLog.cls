global class scheduleApiErrorLog implements Schedulable{
 global void execute(SchedulableContext sc) {
        DeleteAPIErrorLog b = new DeleteAPIErrorLog(); 
        database.executebatch(b);
    }
}