@isTest
public class MaxInboundApiControllerTest {
    @isTest
    public static void runTest(){
        Billing_Itemwise__c bi=new Billing_Itemwise__c();
        bi.alletec_maxid__c='25';
        insert bi;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/billing-itemwise';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BillDate" : "'+system.today()+'","DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500","QUANTITY" : "45","SERVICE" : "Test","Vistaid" : "67"}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/maxapi/entity/billing-summary';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof('{"Data" :[{"ADDRESS":"sector 2","AppointmentBookinId":"23","BILLDATE":"'+system.today()+'","BILLNO":"56","CASHORCREDIT":"TBD","CHANNELNAME":"Test","CITY":"Noida","CompanyName" : "TMC","CompanyShareAmount" : 6700,"COUNTRY" : "India","DATEOFADMISSION" : "'+system.today()+'","DATEOFDISCHARGE" : "'+system.today()+7+'","DISCOUNT":120,"DiscountReason":"Test","doctor_employee_id" : "788","DoctorID" : "879","DoctorName":"Test","CompanyShareAmount":"4661"}]}');
        RestContext.request = req1;
        RestContext.response= res1;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/maxapi/entity/department';
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req2;
        RestContext.response= res2;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();
        req3.requestURI = '/services/apexrest/maxapi/entity/drAppointment';
        req3.httpMethod = 'POST';
        req3.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req3;
        RestContext.response= res3;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req4 = new RestRequest(); 
        RestResponse res4 = new RestResponse();
        req4.requestURI = '/services/apexrest/maxapi/entity/intlr-pat-outstanding';
        req4.httpMethod = 'POST';
        req4.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req4;
        RestContext.response= res4;
        MaxInboundApiController.doCreateRecords();
        
        RestRequest req5 = new RestRequest(); 
        RestResponse res5 = new RestResponse();
        req5.requestURI = '/services/apexrest/maxapi/entity/patient-info';
        req5.httpMethod = 'POST';
        req5.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req5;
        RestContext.response= res5;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req6 = new RestRequest(); 
        RestResponse res6 = new RestResponse();
        req6.requestURI = '/services/apexrest/maxapi/entity/pat-opprescription';
        req6.httpMethod = 'POST';
        req6.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req6;
        RestContext.response= res6;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req7 = new RestRequest(); 
        RestResponse res7 = new RestResponse();
        req7.requestURI = '/services/apexrest/maxapi/entity/ref-intlr-tagging';
        req7.httpMethod = 'POST';
        req7.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req7;
        RestContext.response= res7;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req8 = new RestRequest(); 
        RestResponse res8 = new RestResponse();
        req8.requestURI = '/services/apexrest/maxapi/entity/specialization';
        req8.httpMethod = 'POST';
        req8.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req8;
        RestContext.response= res8;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req9 = new RestRequest(); 
        RestResponse res9 = new RestResponse();
        req9.requestURI = '/services/apexrest/maxapi/entity/locality';
        req9.httpMethod = 'POST';
        req9.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req9;
        RestContext.response= res9;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req10 = new RestRequest(); 
        RestResponse res10 = new RestResponse();
        req10.requestURI = '/services/apexrest/maxapi/entity/city';
        req10.httpMethod = 'POST';
        req10.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req10;
        RestContext.response= res10;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req11 = new RestRequest(); 
        RestResponse res11 = new RestResponse();
        req11.requestURI = '/services/apexrest/maxapi/entity/state';
        req11.httpMethod = 'POST';
        req11.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req11;
        RestContext.response= res11;
        MaxInboundApiController.doCreateRecords(); 
        
        RestRequest req12 = new RestRequest(); 
        RestResponse res12 = new RestResponse();
        req12.requestURI = '/services/apexrest/maxapi/entity/country';
        req12.httpMethod = 'POST';
        req12.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req12;
        RestContext.response= res12;
        MaxInboundApiController.doCreateRecords();
        
        RestRequest req13 = new RestRequest(); 
        RestResponse res13 = new RestResponse();
        req13.requestURI = '/services/apexrest/maxapi/entity/doctor';
        req13.httpMethod = 'POST';
        req13.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500"}]}');
        RestContext.request = req13;
        RestContext.response= res13;
        MaxInboundApiController.doCreateRecords();
        
        RestRequest req14 = new RestRequest(); 
        RestResponse res14 = new RestResponse();
        req14.requestURI = '/services/apexrest/maxapi/entity/billing';
        req14.httpMethod = 'POST';
        req14.requestBody = Blob.valueof('{"Data" :[{"DISCOUNT":"120"}]}');
        RestContext.request = req14;
        RestContext.response= res14;
        MaxInboundApiController.doCreateRecords(); 
        
        Test.stopTest();
    }
}