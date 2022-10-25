/*****************************************************************************************************
 * Date: 9th Sept 2022                                                                               *
 * Written By: Shivam Gupta                                                                          *
 * Batch Class for finding lead Name and Phone from billing summary if MAX ID is null                *
 * Test Class : TestBillingtaggingNamePhone                                                          *
 * Scheduler : TestScheduleBillingtaggingNamePhone                                                   *
 * ***************************************************************************************************/
global class ScheduleBillingtaggingNamePhone implements Schedulable {    
    global void execute(SchedulableContext sc) {
        BillingtaggingNamePhone b = new BillingtaggingNamePhone(); 
        database.executebatch(b); 
       
    }
    
   
}