global class BatchAppointmentRevenueProcessSchedule implements Schedulable {

     global void execute(SchedulableContext sc ){
        Database.executeBatch(new BatchAppointmentRevenueProcess(),200);
    }
}