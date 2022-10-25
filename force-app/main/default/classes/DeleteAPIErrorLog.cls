global class DeleteAPIErrorLog implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful
    {
     global String query;
   global Database.QueryLocator start(Database.BatchableContext batchContext){
       query = 'select id,createddate from API_Error_Log__c order by createddate';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, List<sObject> scope){      
        delete scope;
      }
         global void finish(Database.BatchableContext context){
        
    }
}