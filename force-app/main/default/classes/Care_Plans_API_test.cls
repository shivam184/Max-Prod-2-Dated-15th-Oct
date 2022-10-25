@isTest
public class Care_Plans_API_test {

    @isTest
    public static void test(){
        
        lead__c l = new lead__c();
        l.name = 'new';
        l.Max_ID__c = '1266669';
        l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        insert l ;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.alletec_doctorid__c = '9560';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc; 
        
        Account acc1=new account();
        acc1.FirstName='Test1';
        acc1.LastName='mr blag';
        acc1.Max_ID__c= '1266669';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc1; 
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/careplanapi/';
        req.httpMethod = 'POST';
        req.requestBody = BLOB.valueOf('{ "Data":[{ "patientaddress" : "JAnakpuri", "maxid" : "1266669", "mobilenumber"  : "999999999","channel" : "Very good","age"  : "45","gender" : "male", "speciality" :"1281","doctor"  : "9560", "admissiondate" : "2018-03-29", "totalhospitaldays" : "20", "unit" : "87865"}]}');
        RestContext.request = req;
        RestContext.response = res;
        Care_Plans_Api.createplans();
        
        Care_Plans_Api.RequestBody requestt =  new Care_Plans_Api.RequestBody();
         test.stopTest();
    }
}