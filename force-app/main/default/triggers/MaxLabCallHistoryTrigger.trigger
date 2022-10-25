/*created By: Nitya (IRT) on 1st April 2022
 * 
*/
trigger MaxLabCallHistoryTrigger on Max_Lab_Call_History__c (after insert, after update, after delete) {
     Set<id> leadIds=new Set<id>();
    if(trigger.isInsert|| trigger.isUpdate){
        for(max_lab_call_history__c m:trigger.New){
            if(m.Leads__c!=null && m.Lead_Record_Type__c=='Max Lab customer lead'){
                leadIds.add(m.Leads__c);
            }
        }
    }
    else if(trigger.isDelete){
       for(max_lab_call_history__c m:trigger.Old){
            if(m.Leads__c!=null && m.Lead_Record_Type__c=='Max Lab customer lead'){
                leadIds.add(m.Leads__c);
            }
        } 
    }
MaxLabCallHistoryHandler.countNumberOfCalls(leadIds);
}