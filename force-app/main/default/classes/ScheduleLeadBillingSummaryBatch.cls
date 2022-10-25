global class ScheduleLeadBillingSummaryBatch implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new LeadBillingSummaryBatchNew(),100);
    }
}