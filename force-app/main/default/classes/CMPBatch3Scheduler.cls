global class CMPBatch3Scheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        CMPBatch3 b = new CMPBatch3(); 
        database.executebatch(b,50);
    }
}