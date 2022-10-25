global class ScheduleRemoveDuplicateRecords implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new RemoveDuplicateRecords(),100);
    }
}