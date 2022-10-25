global class VisaInviteBatchClassSchedular implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new VisaInviteBatchClass(),200);
    }
}