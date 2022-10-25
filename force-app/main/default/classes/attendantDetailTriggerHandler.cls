/*created by: Nitya(IRT) on 6th April 2022
* */
public class attendantDetailTriggerHandler {
    //update visa invite fields based on active/inactive attendant details.
    public static void updateVisaInviteField(List<attendant_detail__c> triggerNew, set<id> visaId){
        Id attendeeId = Schema.SObjectType.attendant_detail__c.getRecordTypeInfosByName().get('Attendee').getRecordTypeId();
        Id donorId = Schema.SObjectType.attendant_detail__c.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        if(visaId.isEmpty())
            return;
        Map<id,visa_invite__c> visaMap=new map<id,visa_invite__c>([select id, Attendee_Active_Inactive__c,donor_active_inactive__c from visa_invite__c where id in:visaId]);
       /* for(visa_invite__c vi:[select id, Attendee_Active_Inactive__c,donor_active_inactive__c from visa_invite__c where id in:visaId])
            visaMap.put(vi.id,vi);*/
        for(attendant_detail__c a:triggerNew){
            if(a.RecordTypeId==attendeeId && visaMap.get(a.Visa_Invite__c).Attendee_Active_Inactive__c==false){
                visaMap.get(a.Visa_Invite__c).Attendee_Active_Inactive__c=true;
            }
            else if(a.RecordTypeId==donorId && visaMap.get(a.Visa_Invite__c).donor_Active_Inactive__c==false){
                visaMap.get(a.Visa_Invite__c).Donor_Active_Inactive__c=true;
            }
        }
       // system.debug(visaMap);
        update visaMap.values();
    }
}