global class MTDRevenueCalculationBatchSche implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new MTDRevenueCalculationBatch(),200);
    }
}