@istest
public class RestAPI_CollectionTest {
    static testMethod void unitTest1(){
        Test.startTest();
        
        RestRequest reqt = new RestRequest(); 
        RestResponse resp = new RestResponse();      
        reqt.requestBody = Blob.valueof('{"MaxLabCallHistory": [{"Call_TypeuseinAPI__c" : "apirtawe","Call_start_date_time__c": "1.12.21","Call_End_date_time__c": "1.12.21","Call_Duration__c" : 20.10,"Leads__c" : "a009H000000EkW1QAK"},{"Call_TypeuseinAPI__c" : "apiqrt","Call_start_date_time__c": "25.12.21","Call_End_date_time__c": "25.12.21","Call_Duration__c" : "abcd","Leads__c" : "a009H000000EkW1QAK"}]}');
                
        reqt.requestURI = '/services/apexrest/MaxLabCallHistory/';
        reqt.httpMethod = 'GET';
        RestContext.request = reqt;
        RestContext.response= resp;
        RestAPI_Collection.initPostService();
        Test.stopTest();
    }
    static testMethod void unitTest2(){
        Test.startTest();
        
        RestRequest reqt = new RestRequest(); 
        RestResponse resp = new RestResponse();      
        reqt.requestBody = Blob.valueof('{"MaxLabCallHistory": [{"Call_TypeuseinAPI__c" : "apirtawe","Call_start_date_time__c": "1.12.21","Call_End_date_time__c": "1.12.21","Call_Duration__c" : ,"Leads__c" : "a009H000000EkW1QAK"},{"Call_TypeuseinAPI__c" : "apiqrt","Call_start_date_time__c": "25.12.21","Call_End_date_time__c": "25.12.21","Call_Duration__c" : ,"Leads__c" : "a009H000000EkW1QAK"}]}');
                
        reqt.requestURI = '/services/apexrest/MaxLabCallHistory/';
        reqt.httpMethod = 'GET';
        RestContext.request = reqt;
        RestContext.response= resp;
        RestAPI_Collection.initPostService();
        Test.stopTest();
    }

}