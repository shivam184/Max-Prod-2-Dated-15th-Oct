global class ScheduleBillingSummaryUpdateBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        BillingSummaryUpdateBatch objBatch = new BillingSummaryUpdateBatch(); 
        Database.executebatch(objBatch);
    }
}