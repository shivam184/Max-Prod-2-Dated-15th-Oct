/***********************Written By Nitya***************
* 
* 
* This is used for Patient Form QR Code LWC Component-8th June 2022
* Last Modified by: Nitya(IRT)on 16th June: removed unwanted code
* *************************************************************************/

@suppresswarnings('PMD')
public without sharing class PatientFormController {
    
    @AuraEnabled
    public static Lead__c createLead(string Name,string Phone,string SampleBookingLocation,string DoctorId, string sourceOfLead){
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        Lead__c lead = new Lead__c();
        lead.RecordTypeId = recordTypeId;
        lead.Name = Name;
        lead.source_of_lead__c=sourceOfLead;
        lead.Mobile_Phone__c =Phone;
        lead.Sample_Booking_Location__c=SampleBookingLocation;
        lead.Doctor__c = DoctorId;
        insert lead;
        return lead;      
    }
   
    @AuraEnabled
    public static void UpdatesaveFile(String Parentid,string contentVersionId) { 
       // System.debug(contentVersionId);
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionId].ContentDocumentId;
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;//Add ContentDocumentId
        contentDocumentLink.LinkedEntityId = Parentid;//Add attachment parentId
        contentDocumentLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        contentDocumentLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert contentDocumentLink;
    }
}