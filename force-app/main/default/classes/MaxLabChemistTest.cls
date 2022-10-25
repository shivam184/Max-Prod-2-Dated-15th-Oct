@istest
public class MaxLabChemistTest {
    static testmethod void test1(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxLabChemist/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name": "test", "Mobile":"0001283", "URL":"https://maxhealthcare--developer.sandbox.my.salesforce.com/services/apexrest/MaxLabChemist/","Source":"Google", "Median":"Facebook","Campaign":"Test","ChemistName":"Testing Chemist","CentreName":"3034 - Dr. Shishir Bhatnagar"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxLabChemist.doCreateMAXChemistLead();
        test.stopTest();
        
        
    }

    static testmethod void test2(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxLabChemist/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name": "test", "Mobile":"0001283", "URL":"https://maxhealthcare--developer.sandbox.my.salesforce.com/services/apexrest/MaxLabChemist/","Source":"Google", "Median":"Facebook","Campaign":"Test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxLabChemist.doCreateMAXChemistLead();
        test.stopTest();
        
        
    }

    static testmethod void test3(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxLabChemist/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('');
        RestContext.request = req;
        RestContext.response= res;
        MaxLabChemist.doCreateMAXChemistLead();
        test.stopTest();
        
        
    }
    static testmethod void test4(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxLabChemist/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name": "test", "Mobile":"0001283", "URL":"https://maxhealthcare--developer.sandbox.my.salesforce.com/services/apexrest/MaxLabChemist/","Source":"Google", "Median":"Facebook","Campaign":"Test","ChemistID": "0017200000LuSFPAA3"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxLabChemist.doCreateMAXChemistLead();
        test.stopTest();
        
        
    }

    
}