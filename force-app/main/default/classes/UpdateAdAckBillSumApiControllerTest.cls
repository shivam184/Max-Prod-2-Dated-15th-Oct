@isTest
public class UpdateAdAckBillSumApiControllerTest {

    @isTest
    static void test1(){
        Business_Unit__c bUnit = new Business_Unit__c();
		bUnit.Name = 'Test BU';
        bUnit.HIS_ID__c = '13';
        insert bUnit;
        
        Admission_Acknowledgement__c admAck1 = new Admission_Acknowledgement__c();
        admAck1.IPID__c = '1234';
        admAck1.alletec_hospitallocation__c = bUnit.Id;
        insert admAck1;               
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/admission-acknowledgement';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"IPID" : "1234","HOSPITALLOCATION" : "13","INTERNATIONAL" : "true"}]}');
        RestContext.request = req;
        RestContext.response= res;
		UpdateAdAckBillSumApiController.doUpdateRecords();                
        Test.stopTest();
    }
    
    @isTest
    static void test2(){
        Business_Unit__c bUnit = new Business_Unit__c();
		bUnit.Name = 'Test BU';
        bUnit.HIS_ID__c = '13';
        insert bUnit;
        
        Admission_Acknowledgement__c admAck1 = new Admission_Acknowledgement__c();
        admAck1.IPID__c = '1234';
        admAck1.alletec_hospitallocation__c = bUnit.Id;
        insert admAck1;               
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/admission-acknowledgement';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"IPID" : "1234","HOSPITALLOCATION" : "13","INTERNATIONAL" : "false"}]}');
        RestContext.request = req;
        RestContext.response= res;
		UpdateAdAckBillSumApiController.doUpdateRecords();                
        Test.stopTest();
    }
    
    @isTest
    static void test3(){        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.invoicenumber__c = '440';
        bs.alletec_transactiontype__c = 'OP';
        insert bs;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/billing-summary';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BILLNO" : "440","TRANSACTIONTYPE" : "OP","INTERNATIONAL" : "true"}]}');
        RestContext.request = req;
        RestContext.response= res;
		UpdateAdAckBillSumApiController.doUpdateRecords();             
        Test.stopTest();
    }
    
    @isTest
    static void test4(){        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.invoicenumber__c = '440';
        bs.alletec_transactiontype__c = 'OP';
        insert bs;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/billing-summary';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BILLNO" : "440","TRANSACTIONTYPE" : "OP","INTERNATIONAL" : "false"}]}');
        RestContext.request = req;
        RestContext.response= res;
		UpdateAdAckBillSumApiController.doUpdateRecords();                        
        Test.stopTest();
    }
    
    @isTest
    static void test5(){        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.invoicenumber__c = '440';
        bs.alletec_transactiontype__c = 'OP';
        insert bs;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/billing-summary1';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BILLNO" : "440","TRANSACTIONTYPE" : "OP","INTERNATIONAL" : "false"}]}');
        RestContext.request = req;
        RestContext.response= res;
		UpdateAdAckBillSumApiController.doUpdateRecords();                        
        
        req.requestBody = Blob.valueof('{}');
        UpdateAdAckBillSumApiController.doUpdateRecords();
        
        req.requestBody = Blob.valueof('{"Data" :[{"BILLNO" : "440","TRANSACTIONTYPE" : "88",INTERNATIONAL" : "false"}]}');
        UpdateAdAckBillSumApiController.doUpdateRecords();                
        
        Test.stopTest();
    }
    
     @isTest
    static void test6(){        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.invoicenumber__c = '440';
        bs.alletec_transactiontype__c = 'OP';
        insert bs;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateAdBill/entity/billing-summary';
        req.httpMethod = 'POST';        
        RestContext.request = req;
        RestContext.response= res;
        req.requestBody = Blob.valueof('');
		UpdateAdAckBillSumApiController.doUpdateRecords();                     
                
        Test.stopTest();
    }
}