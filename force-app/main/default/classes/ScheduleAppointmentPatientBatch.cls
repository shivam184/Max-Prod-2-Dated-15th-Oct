global class ScheduleAppointmentPatientBatch implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new AppointmentPatientBatch(),200);
    }
}