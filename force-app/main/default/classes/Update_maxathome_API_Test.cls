@isTest
public class Update_maxathome_API_Test {
    @istest
    public static void test(){
        
        lead__c l = new lead__c();
        l.Name = 'blah';
        l.Max_ID__c='1234';
        l.recordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        l.Stage__c = 'Patient Admitted';
        insert l; 
        
        
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        
        req.requestURI = '/services/apexrest/updatemaxhomelead/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        update_maxathome_stage_API.updatestage('1234','Patient Admitted');
        
       
    }
    @istest
    public static void test2(){
        
        lead__c l = new lead__c();
        l.Name = 'blah';
        l.Max_ID__c='1234';
        l.recordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        l.Stage__c = 'Patient Admitted';
        insert l; 
        
        
        RestRequest req = new RestRequest();
        RestResponse res= new RestResponse();
        
        req.requestURI = '/services/apexrest/updatemaxhomelead/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        update_maxathome_stage_API.updatestage('1235','Lead Won');
        
        
    }

}