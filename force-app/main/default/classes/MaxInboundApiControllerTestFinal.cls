@isTest
public class MaxInboundApiControllerTestFinal {
    @testSetup static void setup(){
        String countryRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId(); 
        Address_Master__c am1 = new Address_Master__c();
        if(String.isNotBlank(countryRecordTypeId))
            am1.RecordTypeId = countryRecordTypeId;
        am1.Name = 'India';
        am1.Deleted__c = '0';
        am1.alletec_countryid__c = '149';
        insert am1;        		
        
        String stateRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('State').getRecordTypeId(); 
        Address_Master__c am2 = new Address_Master__c();
        if(String.isNotBlank(stateRecordTypeId))
            am2.RecordTypeId = stateRecordTypeId;
        am2.Name = 'UP';        
        am2.State_ID__c='22';
        am2.alletec_state__c = '22';
        am2.Deleted__c = '0';
        am2.Country__c = am1.Id;
        insert am2;
        
        String cityRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('City').getRecordTypeId(); 
        Address_Master__c am3 = new Address_Master__c();
        if(String.isNotBlank(cityRecordTypeId))
            am3.RecordTypeId = cityRecordTypeId;
        am3.Name = 'Noida';        
        am3.alletec_cityid__c = '34';
        am3.Deleted__c = '0';
        insert am3;
        
        String localityRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Locality').getRecordTypeId(); 
        Address_Master__c am4 = new Address_Master__c();
        if(String.isNotBlank(localityRecordTypeId))
            am4.RecordTypeId = localityRecordTypeId;
        am4.alletec_localityid__c = '42';
        am4.Name = 'Sector 2';        
        am4.Deleted__c = '0';
        insert am4;      
        
        Speciality__c sp = new Speciality__c();
        sp.Name = 'test';
        insert sp;
        
        Department__c dp = new Department__c();
        dp.Name = 'test';
        dp.alletec_id__c = 1122;
        insert dp;
    }
    
    
    @isTest
    public static void FinalTest1(){
        //Billing_Itemwise__c bi=new Billing_Itemwise__c();
        //bi.alletec_maxid__c='25';
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/billing-itemwise';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BillDate" : "'+system.today()+'","DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500","QUANTITY" : "45","SERVICE" : "Test","Vistaid" : "67"}]}'); 
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
    }
    
    @isTest
    public static void FinalTest2(){
        //Billing_Summary__c bi=new Billing_Summary__c();
        //bi.alletec_maxid__c='25';
		
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/billing-summary';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"ADDRESS" : "Test","AppointmentBookinId":"1235","BILLDATE":"'+system.today()+'","BILLNO":"456","CASHORCREDIT":"Cash","CHANNELNAME":"International","CITY" : "Noida","CompanyName" : "TMC","GLCode" : "4444","InsuranceCompanyName" : "TMCCon","CompanyShareAmount" : 5567,"COUNTRY" : "INDIA","DATEOFADMISSION" :"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'","DISCOUNT":23344,"DiscountReason" : "TEST","doctor_employee_id" : "77","DoctorID" : "567","DOCTORNAME" : "TEST","EmergencyNo" : "789","HOSPITALLOCATION" : "NOIDA","IPID" : "654","isbillcancelled":"YES","LOCALITY":"Delhi","MAXID":"865","OP" : "Test","PatientName":"abc","PINCODE":"345","PREADMITNO":"2345","SPECIALITYId":"234","SSNNo":"123","State":"Bih","SUBSPECIALITY":"abc","SUBSPECIALITYID" : "6878","TOTALAMOUNT" :234,"TRANSACTIONTYPE":"OP","billingitemwise": [{"DISCOUNT":"1356","DiscountReason":"abc","isitemcancelled":"True","ITEM":"new","ItemRecordId":"","Orderid":"1235","PRICE":"4500","QUANTITY":"1235"}]}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
        
        MaxInboundApiController.doCreateRecords(); 
        req.requestBody = Blob.valueof('{"Data" :[{"ADDRESS" : "Test","AppointmentBookinId":"1235","BILLDATE":"'+system.today()+'","BILLNO":"456","CASHORCREDIT":"Cash","CHANNELNAME":"International","CITY" : "Noida","CompanyName" : "TMC","CompanyShareAmount" : 5567,"COUNTRY" : "INDIA","DATEOFADMISSION" :"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'","DISCOUNT":23344,"DiscountReason" : "TEST","doctor_employee_id" : "77","DoctorID" : "567","DOCTORNAME" : "TEST","EmergencyNo" : "789","HOSPITALLOCATION" : "NOIDA","IPID" : "654","isbillcancelled":"YES","LOCALITY":"Delhi","MAXID":"865","OP" : "Test","PatientName":"abc","PINCODE":"345","PREADMITNO":"2345","SPECIALITYId":"234","SSNNo":"123","State":"Bih","SUBSPECIALITY":"abc","SUBSPECIALITYID" : "6878","TOTALAMOUNT" :234,"TRANSACTIONTYPE":"OP","billingitemwise": [{"DISCOUNT":"1356","DiscountReason":"abc","isitemcancelled":"True","ITEM":"new","ItemRecordId":"","Orderid":"1235","PRICE":"4500","QUANTITY":"1235"}]}]}');
    }
    
    @isTest
    public static void FinalTest6(){
        //Billing_Summary__c bi=new Billing_Summary__c();
        //bi.alletec_maxid__c='25';
		Business_Unit__c bUnit = new Business_Unit__c();
		bUnit.Name = 'Test BU';
        bUnit.HIS_ID__c = '13';
        insert bUnit;
		        
        Billing_Summary__c bs =new Billing_Summary__c();
        bs.invoicenumber__c = '5500';
        bs.alletec_hospitallocation__c = bUnit.Id;
        insert bs;      
        String bsId = bs.Id;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/billing-summary';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"ADDRESS" : "Test","AppointmentBookinId":"1235","International" : "true","CAMPAIGNCODE" : "test","BILLDATE":"'+system.today()+'","BillNo":"5500","CASHORCREDIT":"Cash","CHANNELNAME":"International","CITY" : "Noida","CompanyName" : "TMC","GLCode" : "4444","InsuranceCompanyName" : "TMCCon","CompanyShareAmount" : 5567,"COUNTRY" : "INDIA","DATEOFADMISSION" :"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'","DISCOUNT":23344,"DiscountReason" : "TEST","doctor_employee_id" : "77","DoctorID" : "567","DOCTORNAME" : "TEST","EmergencyNo" : "789","HOSPITALLOCATION" : "13","IPID" : "654","isbillcancelled":"true","LOCALITY":"Delhi","MAXID":"865","OP" : "Test","PatientName":"abc","PINCODE":"345","PREADMITNO":"2345","SPECIALITYId":"234","SSNNo":"123","State":"Bih","SUBSPECIALITY":"abc","SUBSPECIALITYID" : "6878","TOTALAMOUNT" :234,"TRANSACTIONTYPE":"OP","billingitemwise": [{"DISCOUNT":"1356","DiscountReason":"abc","isitemcancelled":"True","ITEM":"new","ItemRecordId":"","Orderid":"1235","PRICE":"4500","QUANTITY":"1235"}]}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords();   
        
        MaxInboundApiController.doCreateRecords(); 
        req.requestBody = Blob.valueof('{"Data" :[{"ADDRESS" : "Test","AppointmentBookinId":"1235","BILLDATE":"'+system.today()+'","BillNo":"500","CASHORCREDIT":"Cash","CHANNELNAME":"International","CITY" : "Noida","CompanyName" : "TMC","GLCode" : "4444","InsuranceCompanyName" : "TMCCon","CompanyShareAmount" : 5567,"COUNTRY" : "INDIA","DATEOFADMISSION" :"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'","DISCOUNT":23344,"DiscountReason" : "TEST","doctor_employee_id" : "77","DoctorID" : "567","DOCTORNAME" : "TEST","EmergencyNo" : "789","HOSPITALLOCATION" : "130","IPID" : "654","isbillcancelled":"YES","LOCALITY":"Delhi","MAXID":"865","OP" : "Test","PatientName":"abc","PINCODE":"345","PREADMITNO":"2345","SPECIALITYId":"234","SSNNo":"123","State":"Bih","SUBSPECIALITY":"abc","SUBSPECIALITYID" : "6878","TOTALAMOUNT" :234,"TRANSACTIONTYPE":"OP"}]}');
    
        //req.requestBody = Blob.valueof('{}');
        MaxInboundApiController.doCreateRecords(); 
        
        req.requestBody =NULL;
        MaxInboundApiController.doCreateRecords(); 

 
    
    }
    
     @isTest
    public static void FinalTest3(){
        //Billing_Itemwise__c bi=new Billing_Itemwise__c();
        //bi.alletec_maxid__c='25';
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/Doctor';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"dateofbirth":"2017-09-09","name":"abc","designation" : "Test","gender" : "Male","mobilenumber" : "8439024407","speciality" : "MBBS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
        
         
    }
    
    @isTest
    public static void FinalTest4(){
        //Billing_Itemwise__c bi=new Billing_Itemwise__c();
        //bi.alletec_maxid__c='25';
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/patient-info';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"Email":"anasKhanyar@gmail.com","Email2":"anasKhanyar@gmail.com","FathersName":"Test","Gender":"Male","IsVIP":"true","MothersMaidenName":"test","DateOfBirth":"2017-09-09","FirstName":"abc","Lastname" : "Test","MiddleName": "test1","Address1" : "123","gender" : "Male","Nationality" : "Indian","Occupation" : "test","SSNNO" : "77","PassportNo" : "6778","PhoneNumber" : "9876543121","MaritalStatus" : "Single","City":"Noida","Country":"India","BloodGroup" : "O+","MAXID" : "89"}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
        
        MaxInboundApiController.doCreateRecords(); 
        req.requestBody = Blob.valueof('{"Data" :[{"Email":"agmail.com","DateOfBirth":"2017-09-09","Address1" : "123","gender" : "Myuyu","MaritalStatus" : "Single","City":"Noida","Country":"India","BloodGroup" : "O+", "MAXID" : "88"}]}');
        
        MaxInboundApiController.doCreateRecords(); 
        req.requestBody = Blob.valueof('{"Data" :[{"Email":"agmail.com","DateOfBirth":"2017-09-09","Address1" : "123","gender" : "Myuyu","MaritalStatus" : "sss","City":"Noida","Country":"India","BloodGroup" : "O+", "MAXID" : "88"}]}');
        
    }

    @isTest
    public static void FinalTest5(){
        //Billing_Itemwise__c bi=new Billing_Itemwise__c();
        //bi.alletec_maxid__c='25';
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/intlr-pat-outstanding';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"AdmissionDate":"2013-08-01 12:00:00","BillAmount": "1212","AdvanceAmount" : "1212","BillingDate" : "2019-03-29 15:20:20","BillNo" : "23","EmergencyNo" : "44","IPID" : "33","locationname":"12","MAXID":"233","OP" : "23","OutStandingAmount" : "89","PreAdmitNo" : "223","AdvanceAmount" : "3445","BillNo" : "22","EmergencyNo" : "22","IPID" :"22","locationname":"Noida","MAXID" : "33","SSNNO" : "66","PreAdmitNo":"66"}]}');
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
              		
    }
    
     @isTest
    public static void FinalTest61(){
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/maxapi/entity/Specialization';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"Data" :[{"BillDate" : "'+system.today()+'","DISCOUNT":"120","DiscountReason":"Test","DoctorName":"Test","ITEM":"Test","MAXID":"50","Orderid":"05","PRICE":"500","QUANTITY" : "45","SERVICE" : "Test","Vistaid" : "67"}]}'); 
        RestContext.request = req;
        RestContext.response= res;
        MaxInboundApiController.doCreateRecords(); 
    }
    
}