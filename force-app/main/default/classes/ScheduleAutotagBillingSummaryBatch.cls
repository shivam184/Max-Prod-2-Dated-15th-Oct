global class ScheduleAutotagBillingSummaryBatch implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new AutotagBillingSummaryBatch(),100);
    }
}