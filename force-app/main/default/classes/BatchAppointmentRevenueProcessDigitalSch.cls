global class BatchAppointmentRevenueProcessDigitalSch implements Schedulable {
    
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new BatchAppointmentRevenueProcessDigital(),200);
    }
}