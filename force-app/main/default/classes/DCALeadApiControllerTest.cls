@isTest
public class DCALeadApiControllerTest {
    static testMethod void runTest1(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dcaleads/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name":"test","campaign":"Vailshali","email":"anas@khan.com","GCLID":"12345","URL":"https://maxhealthcare.in/specialities/liver/?utm_source=&utm_medium=&utm_campaign=","PhoneNumber":"8439024407","Adw":"Max","Keyw":"Anas","Placement":"test","City":"Noida","State":"UP","Country":"India","EnquiryID":"5","TypeOfQuery":"test","Comments":"xyz","Speciality":"xyz","HospitalName":"Max","DoctorName":"test","MaxID":"50","NameOfPatient":"test","EnquiryType":"test","Source":"Mobile","Channel":"test","SubSource":"test","IP_Address":"test","UniqueLeadID":"20","LocationName":"Noida","PreferredTimetoCall":"5PM"}');
        RestContext.request = req;
        RestContext.response= res;
        DCALeadApiController.doCreateDCALead();
        DCALeadApiController.RequestBody requestBody = new DCALeadApiController.RequestBody();
        
        req.requestBody = Blob.valueof('');
        DCALeadApiController.doCreateDCALead();
        test.stopTest();
    }
    
    static testMethod void runTest2(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dcaleads/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name":"test","campaign":"Vailshali","email":"anas@khan.com","GCLID":"12345","URL":"","PhoneNumber":"8439024407","Adw":"Max","Keyw":"Anas","Placement":"test","City":"Noida","State":"UP","Country":"India","EnquiryID":"5","TypeOfQuery":"test","Comments":"xyz","Speciality":"xyz","HospitalName":"Max","DoctorName":"test","MaxID":"50","NameOfPatient":"test","EnquiryType":"test","Source":"Mobile","Channel":"test","SubSource":"test","IP_Address":"test","UniqueLeadID":"20","LocationName":"Noida","PreferredTimetoCall":"5PM"}');
        RestContext.request = req;
        RestContext.response= res;
        DCALeadApiController.doCreateDCALead();
        DCALeadApiController.RequestBody requestBody = new DCALeadApiController.RequestBody();
        
        req.requestBody = Blob.valueof('');
        DCALeadApiController.doCreateDCALead();
        test.stopTest();
    }
        static testMethod void runTest3(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dcaleads/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name":"","campaign":"Vailshali","email":"anas@khan.com","GCLID":"12345","URL":"","PhoneNumber":"8439024407","Adw":"Max","Keyw":"Anas","Placement":"test","City":"Noida","State":"UP","Country":"India","EnquiryID":"5","TypeOfQuery":"test","Comments":"xyz","Speciality":"xyz","HospitalName":"Max","DoctorName":"test","MaxID":"50","NameOfPatient":"test","EnquiryType":"test","Source":"Mobile","Channel":"test","SubSource":"test","IP_Address":"test","UniqueLeadID":"20","LocationName":"Noida","PreferredTimetoCall":"5PM"}');
        RestContext.request = req;
        RestContext.response= res;
        DCALeadApiController.doCreateDCALead();
        DCALeadApiController.RequestBody requestBody = new DCALeadApiController.RequestBody();
        
        req.requestBody = Blob.valueof('');
        DCALeadApiController.doCreateDCALead();
        test.stopTest();
    }
    static testMethod void runTest4(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dcaleads/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"name":"test12","campaign":"Vailshali","email":"anas@khan","GCLID":"12345","URL":"","PhoneNumber":"8439024407","Adw":"Max","Keyw":"Anas","Placement":"test","City":"Noida","State":"UP","Country":"India","EnquiryID":"5","TypeOfQuery":"test","Comments":"xyz","Speciality":"xyz","HospitalName":"Max","DoctorName":"test","MaxID":"50","NameOfPatient":"test","EnquiryType":"test","Source":"Mobile","Channel":"test","SubSource":"test","IP_Address":"test","UniqueLeadID":"20","LocationName":"Noida","PreferredTimetoCall":"5PM"}');
        RestContext.request = req;
        RestContext.response= res;
        DCALeadApiController.doCreateDCALead();
        DCALeadApiController.RequestBody requestBody = new DCALeadApiController.RequestBody();
        
        req.requestBody = Blob.valueof('');
        DCALeadApiController.doCreateDCALead();
        test.stopTest();
    }
}