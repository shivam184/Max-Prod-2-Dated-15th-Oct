/*created By: Nitya (IRT) on 1st April 2022
 * 
*/
public class MaxLabCallHistoryHandler {
    public static void countNumberOfCalls(set<id> leadIds){
        List<lead__c> leadList=[select id, call_count__c ,(select id from max_lab_call_history__r) from lead__c where id in:leadIds];
        for(lead__c l:leadList){
            l.call_count__c=l.max_lab_call_history__r.size();
            if(l.Call_Count__c>=5){
                l.Stage__c='Not Connected by Dialer';
            }
        }
        update leadList;
    }
}