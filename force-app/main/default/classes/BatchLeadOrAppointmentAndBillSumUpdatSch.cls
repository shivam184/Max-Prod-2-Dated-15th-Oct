global class BatchLeadOrAppointmentAndBillSumUpdatSch implements Schedulable {

     global void execute(SchedulableContext sc ){
        Database.executeBatch(new BatchLeadOrAppointmentAndBillSumUpdate(),200);
    }
}