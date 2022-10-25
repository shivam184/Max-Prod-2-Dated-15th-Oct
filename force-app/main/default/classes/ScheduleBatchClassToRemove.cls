global class ScheduleBatchClassToRemove implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        BatchClassToRemoveDuplicateRecords obj = new BatchClassToRemoveDuplicateRecords();
        database.executebatch(obj,1);
    }
}