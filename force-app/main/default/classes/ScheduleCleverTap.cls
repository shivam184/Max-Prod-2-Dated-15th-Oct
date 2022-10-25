global class ScheduleCleverTap implements Schedulable {
    global void execute(SchedulableContext sc) {
        CleverTapBatch b = new CleverTapBatch(); 
        database.executebatch(b); 
       
    }
}