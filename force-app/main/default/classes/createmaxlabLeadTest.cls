@isTest
public class createmaxlabLeadTest {
 @isTest
    public static void runTest(){
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
        Lead__c lead = new Lead__c();
        lead.RecordTypeId = recordTypeId;
        lead.Name = 'Test';
        lead.Mobile_Phone__c ='1234567789';
        lead.Email__c='test@gmail.com';
        lead.City__c='Noida';
        insert lead;
        
        string jsonbody='{"Name":"Test","Phone":"9988776655","Email":"test@gmail.com","City":"Noida"}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/createmaxlablead';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonbody);
        RestContext.request = req;
        RestContext.response= res;
        createmaxlabLead.doCreateLabLead();
    }
     @isTest
    public static void runTest1(){
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
        Lead__c lead = new Lead__c();
        lead.RecordTypeId = recordTypeId;
        lead.Name = 'Test';
        lead.Mobile_Phone__c ='1234567789';
        lead.Email__c='test@gmail.com';
        lead.City__c='Noida';
        insert lead;
        
        string jsonbody='';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/createmaxlablead';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonbody);
        RestContext.request = req;
        RestContext.response= res;
        createmaxlabLead.doCreateLabLead();
    }
    
}