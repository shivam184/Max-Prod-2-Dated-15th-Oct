global class ScheduleCountryMappingBatchClass implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        CountryMappingBatchClass cmb = new CountryMappingBatchClass ();
        database.executebatch(cmb,200);
    }
    
}