@isTest
public class LIMSTransactionControllerTest {
			
    	@isTest
    	static void test1(){
        	Account acc=new account();
        	acc.Name='Test1';
       		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
        	acc.Account_Category__c = 'MECP';
        	acc.LIMS_Code__c = '23';
        	insert acc;
        
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"billNo": "1234","limsCode": "23","billingDateTime": "2019-05-21 00:00:00","amount": "200.00","typeOfTransaction": "test","description": "test des","visitId": "11","isCancel": "true","cancelDateTime": "2015-10-23 00:00:00 "}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
    	}	
    
    	@isTest
    	static void test2(){                
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
	        req.httpMethod = 'POST';
       		req.requestBody = Blob.valueof('{"billNo": "1234","limsCode": "3","billingDateTime": "2019-05-21 00:00:00","amount": "200.00","typeOfTransaction": "test","description": "test des","isCancel ": "true","cancelDateTime": "2015-10-23 00:00:00"}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
   		}	
    
    	@isTest
    	static void test3(){                
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"billNo": "","limsCode": "3","billingDateTime": "2019-05-21 00:00:00","amount": "200.00","typeOfTransaction": "test","description": "test des","isCancel ": "true","cancelDateTime": "2015-10-23 00:00:00"}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
	    }	
    	
    	@isTest
    	static void test4(){                
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"billNo": "123","limsCode": "","billingDateTime": "2019-05-21 00:00:00","amount": "200.00","typeOfTransaction": "test","description": "test des","isCancel ": "true","cancelDateTime": "2015-10-23 00:00:00"}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
	    }	
    
    	@isTest
    	static void test5(){                
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('{"billNo": "123","limsCode": "","billingDateTime": "2019-05-21 00:00:00","": "amount": "200.00","typeOfTransaction": "test","description": "test des","isCancel ": "true","cancelDateTime": "2015-10-23 00:00:00"}');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
	    }	
    
    	@isTest
    	static void test6(){                
        	Test.startTest();
        	RestRequest req = new RestRequest(); 
        	RestResponse res = new RestResponse();
        	req.requestURI = '/services/apexrest/transactionservice';
        	req.httpMethod = 'POST';
        	req.requestBody = Blob.valueof('');
        	RestContext.request = req;
        	RestContext.response= res;
			LIMSTransactionController.updateTransaction();
        	Test.stopTest();
	    }	
}