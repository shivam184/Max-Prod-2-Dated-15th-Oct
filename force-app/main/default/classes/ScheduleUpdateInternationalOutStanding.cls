//Description: Scheduler to update International Patient Outstanding details. 
//Created by : Techmatrix Consulting


global class ScheduleUpdateInternationalOutStanding implements Schedulable {
   
   global void execute(SchedulableContext SC) {
      
      List<Internationalpatient_Outstanding__c> inOutList = new list<Internationalpatient_Outstanding__c>([SELECT Id FROM 
                                                                              Internationalpatient_Outstanding__c LIMIT 10000]);
      
      if(inOutList!=null && inOutList.size()>0)
          delete inOutList;
   }
}