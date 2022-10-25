global class ScheduleBatchLeadFirstOPDBillDateUpdate implements Schedulable{
    global void execute(SchedulableContext sc ){
        Database.executeBatch(new BatchLeadFirstOPDBillDateUpdate(),100);
    }
}