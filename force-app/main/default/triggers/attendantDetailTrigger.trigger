/*created by: Nitya(IRT) on 6th April 2022
* */
trigger attendantDetailTrigger on Attendant_Detail__c (after update) {
    List<attendant_detail__c> attendeeList=new List<attendant_detail__c>();
    set<id> visaId=new set<id>();
    for(attendant_detail__c ad:Trigger.new){
        if(trigger.oldmap.get(ad.id).Active__c!=ad.Active__c && ad.Active__c==false && ad.Visa_Invite__c!=null){
            attendeeList.add(ad); 
            visaId.add(ad.Visa_Invite__c);
        }
    }
    if(!attendeeList.isEmpty())
       // system.debug('inside Function');
        attendantDetailTriggerHandler.updateVisaInviteField(attendeeList,visaId);
}