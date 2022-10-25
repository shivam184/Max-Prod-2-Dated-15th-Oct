global class ScheduleCallCenterContactsToPatients implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new Lead_Transmission_to_patient_Batch(),100);
    }

}