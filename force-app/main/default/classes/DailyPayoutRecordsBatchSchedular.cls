global class DailyPayoutRecordsBatchSchedular implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new DailyPayoutRecordsBatch(),200);
    }
}