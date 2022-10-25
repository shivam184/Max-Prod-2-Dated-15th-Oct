@isTest
public class LIMSCentreUpdateAPITest {
	
    @isTest
    static void test1(){   
        	Account acc=new account();
        	acc.Name='Test1';
       		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
        	//acc.Account_Category__c = 'MECP';
        	acc.LIMS_Code__c = '23';
        	insert acc;
        
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/limsCenterUpdate';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"Data":[{"CentreCode": "1234","Centre": "testq","Mobile": "1234567890","Email": "test@gmail.com","Address": "sector 2","State": "UP","City": "Noida","BusinessModel":"HLM","SalesTerritory" :"Noida","SalesRegion" : "NCR","PartnerCategory" :"Gold","Affiliation" : "Max","Alias" : "Test"}]}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSCentreUpdateAPI.doUpdateRecords();
        	Test.stopTest();    
    }
    
    @isTest
    static void test2(){   
        	Account acc=new account();
        	acc.Name='Test1';
       		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
        	//acc.Account_Category__c = 'MECP';
        	acc.LIMS_Code__c = '23';
        	insert acc;
        
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/limsCenterUpdate';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSCentreUpdateAPI.doUpdateRecords();
        	Test.stopTest();    
    }
    
    @isTest
    static void test3(){   
        	Account acc=new account();
        	acc.Name='Test1';
       		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
        	//acc.Account_Category__c = 'MECP';
        	acc.LIMS_Code__c = '23';
        	insert acc;
        
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/limsCenterUpdate';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"Data":[{"CentreCode": "1234","Centre": "testq","":"Mobile": "1234567890","Email": "test@gmail.com","Address": "sector 2","State": "UP","City": "Noida"}]}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSCentreUpdateAPI.doUpdateRecords();
        	Test.stopTest();    
    }
    
    @isTest
    static void test4(){   
        	Account acc=new account();
        	acc.Name='Test1';
       		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
        	//acc.Account_Category__c = 'MECP';
        	acc.LIMS_Code__c = '23';
        	insert acc;
        
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/limsCenterUpdate';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"Data":[{"CentreCode": "1234","Centre": "","Mobile": "1234567890","Email": "test@gmail.com","Address": "sector 2","State": "UP","City": "Noida","BusinessModel":"HLM","SalesTerritory" :"Noida","SalesRegion" : "NCR","PartnerCategory" :"Gold","Affiliation" : "Max","Alias" : "Test"}]}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSCentreUpdateAPI.doUpdateRecords();
        	Test.stopTest();    
    }
}