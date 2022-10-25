@istest
public class MaxOPProcessLeadTest {
    static testMethod void testmethod1(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxOPProcessLead/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof('{"name": "test","Phone": "190223101","Email": "shivam@gmail.com","City": "Noida","Source": "Facebook","LabTest": "test","Remark": "test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxOPProcessLead.doCreateMAXOPLead();
        test.stopTest();
        
    }
    static testMethod void testmethod2(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxOPProcessLead/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof('{"name": "","Phone": "190223101","Email": "shivam@gmail","City": "Noida","Source": "Facebook","LabTest": "test","Remark": "test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxOPProcessLead.doCreateMAXOPLead();
        test.stopTest();
        
    }
    static testMethod void testmethod3(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxOPProcessLead/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof('{"name": "test","Phone": "","Email": "shivam@gmail","City": "Noida","Source": "Facebook","LabTest": "test","Remark": "test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxOPProcessLead.doCreateMAXOPLead();
        test.stopTest();
        
    }
    
    static testMethod void testmethod4(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxOPProcessLead/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof('{"name": "test","Phone": "100","Email": "shivam@gmail","City": "Noida","Source": "Facebook","LabTest": "test","Remark": "test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxOPProcessLead.doCreateMAXOPLead();
        test.stopTest();
        
    }
     static testMethod void testmethod5(){
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaxOPProcessLead/';
        req.httpMethod = 'POST';
	    req.requestBody = Blob.valueof('{"name": "test","Phone": "100","Email": "shivam@gmail","City": "Noida","Source": "","LabTest": "test","Remark": "test"}');
        RestContext.request = req;
        RestContext.response= res;
        MaxOPProcessLead.doCreateMAXOPLead();
        test.stopTest();
        
    }

}