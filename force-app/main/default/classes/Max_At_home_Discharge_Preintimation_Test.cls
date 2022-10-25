@isTest
public class Max_At_home_Discharge_Preintimation_Test {
    @isTest
    Public static void test(){
        
        lead__c l = new lead__c();
        l.name = 'new';
        l.Max_ID__c = '1266669';
        l.IPID__c = '12344';
        l.Hospital_Location__c = '6789';
        l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        insert l ;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.alletec_doctorid__c = '545';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/dischargepreintimation/';
        
        req.httpMethod = 'POST';
        req.requestBody = BLOB.valueOf('{ "Data":[{ "IPID" : "12344", "HospitalID" : "6789", "DoctorID"  : "545","DoctorName" : "Very good","StationID"  : "45","StationName" : "male", "UserID" :"1281","UserName"  : "Pro", "MaxID" : "1266669", "ReqDisDatetime" : "2018-03-29","ProposedDischargeDate" : "2018-03-29"}]}');
        RestContext.request = req;
        RestContext.response = res;
        Max_At_Home_Discharge_Preintimation_API.updaterecAPI();
        
        Max_At_Home_Discharge_Preintimation_API.RequestBody respo = new Max_At_Home_Discharge_Preintimation_API.RequestBody();
        test.stopTest();
        
    }

}