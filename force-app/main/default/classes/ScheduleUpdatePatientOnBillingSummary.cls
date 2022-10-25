global class ScheduleUpdatePatientOnBillingSummary implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new UpdatePatientOnBillingSummary(),100);
    }
}