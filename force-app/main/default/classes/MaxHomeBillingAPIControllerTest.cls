@isTest
public class MaxHomeBillingAPIControllerTest {

    @isTest public static void test1(){
        Business_Unit__c bUnit = new Business_Unit__c();
		bUnit.Name = 'Test BU';
        bUnit.HIS_ID__c = '13';
        insert bUnit;
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        acc.LastName = 'Doctor Account';        
        acc.alletec_doctorid__c = '11';
        insert acc;

		Account acc1 = new Account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.LastName = 'Patient Account';        
		acc1.Max_ID__c = '123001';
        insert acc1;
        
        Speciality__c sp = new Speciality__c();
        sp.Name = 'Speciality Test';
        sp.HIS_ID__c = '19';
        insert sp;
        
        Lead__c lead = new Lead__c();
        lead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        lead.Name = 'Test Lead';
        lead.Max_ID__c = '123001';
        insert lead;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxhomebilling';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"maxid" : "123001","billno" : "1232","orderno" : "555","billdate" : "2019-05-29","type" : "GDA Services","channelname" : "Cash","totalamount" : "100","transactiontype" : "Emergency","ipid" : "I234","hospitallocation" : "13","doctor" : "11","speciality" : "19","department" : "61"}');
        RestContext.request = req;
        RestContext.response= res;
		MaxHomeBillingAPIController.insertBillingSummary();
        Test.stopTest();
    }    
    
     @isTest public static void test2(){
        Business_Unit__c bUnit = new Business_Unit__c();
		bUnit.Name = 'Test BU';
        bUnit.HIS_ID__c = '13';
        insert bUnit;
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        acc.LastName = 'Doctor Account';        
        acc.alletec_doctorid__c = '11';
        insert acc;

		Account acc1 = new Account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.LastName = 'Patient Account';        
		acc1.Max_ID__c = '123001';
        insert acc1;
        
        Speciality__c sp = new Speciality__c();
        sp.Name = 'Speciality Test';
        sp.HIS_ID__c = '19';
        insert sp;
        
        Lead__c lead = new Lead__c();
        lead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        lead.Name = 'Test Lead';
        lead.Max_ID__c = '123001';
        insert lead;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxhomebilling';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"maxid" : "123001","billno" : "1232","orderno" : "555","billdate" : "2019-05-29","type" : "Assessment","channelname" : "Cash","totalamount" : "100","transactiontype" : "Emergency","ipid" : "I234","hospitallocation" : "13","doctor" : "11","speciality" : "19","department" : "61"}');
        RestContext.request = req;
        RestContext.response= res;
		MaxHomeBillingAPIController.insertBillingSummary();
        Test.stopTest();
    }    
    
    @isTest public static void test3(){        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxhomebilling';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"maxid" : "123001","billno" : "1232","" :"orderno" : "555","billdate" : "2019-05-29","type" : "GDA Services","channelname" : "Cash","totalamount" : "100","transactiontype" : "Emergency","ipid" : "I234","hospitallocation" : "13","doctor" : "11","speciality" : "19","department" : "61"}');
        RestContext.request = req;
        RestContext.response= res;
		MaxHomeBillingAPIController.insertBillingSummary();
        Test.stopTest();
    }    
    
    @isTest public static void test4(){        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxhomebilling';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('');
        RestContext.request = req;
        RestContext.response= res;
		MaxHomeBillingAPIController.insertBillingSummary();
        Test.stopTest();
    }    
}