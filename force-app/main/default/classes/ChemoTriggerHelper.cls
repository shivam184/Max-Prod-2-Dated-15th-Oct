/*
Helper class of Chemo_Appointment  Trigger 
*/
public class ChemoTriggerHelper {

    // To Update prospect on the bases of Max Id 
    public static void UpdateProspect(list<Chemo_Appointment__c> triggerNew){
        Id devRecordTypeId = Schema.SObjectType.Prospect__c .getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        map<string,id> prospectMap =new map<string, id>();
        for(Prospect__c prospect:[select id,Max_Id__c from Prospect__c where Max_Id__c!= null and RecordTypeId =: devRecordTypeId]){
            prospectMap.put(prospect.Max_Id__c, prospect.id);
        }
        for(Chemo_Appointment__c chemo: triggerNew){
            if(prospectMap.containskey(chemo.Max_Id__c)){
                chemo.Prospect__c= prospectMap.get(chemo.Max_Id__c);
            }
        } 
    }
}