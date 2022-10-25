@isTest
public class AdmissionAcknowledgementsControllerTest {

    @isTest static void test1(){
        System.debug('METHOD 1');
        Business_Unit__c obj1=new Business_Unit__c();
        obj1.Name = 'Test';
        obj1.HIS_ID__c = '23';
        insert obj1;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.alletec_doctorid__c = '12344';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='4556';
        insert acc2;
         
         Doctor_Coordinator_Master__c dcm = new Doctor_Coordinator_Master__c();
        dcm.Doctor__c = acc.Id;
        
        Admission_Acknowledgement__c ack = new Admission_Acknowledgement__c();
        ack.IPID__c='654';
        ack.alletec_hospitallocation__c =obj1.Id;
        ack.Doctor__c= acc.Id;
        insert ack;
        
        Prospect__c obj=new Prospect__c();
        obj.Source__c= 'Estimation';
        //obj.Stage__c = 'Patient Admitted';
        obj.HIS_Hospital_Location__c = obj1.Id;
        obj.Doctor__c = acc.id;
        obj.Max_Id__c='4556';
        obj.RecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        insert obj;        
        
        International_OP_Patient_Journey__c ij = new International_OP_Patient_Journey__c();
        ij.Name='tests';
        ij.Patient_Max_id__c='4556';
        ij.Admission_advice__c = true;
        ij.First_OP_Bill__c = '29891';
       // ij.OP_Bill_Lists__c = 'Bill Lists';
        ij.Patient_Age__c = 16.50;
        ij.Patient_Phone_Number__c = '9871234560';
        ij.Patient_Email_Id__c = 'patient@email.com';
        ij.First_OP_Bill_Date__c = Date.today();
        ij.Date_Of_Admission__c = DateTime.newInstance(2021, 7, 11, 8, 6, 16);
        ij.Stage__c = 'new';
        ij.Channel_Name__c = 'Ultimate';
        ij.Patient_Nationality__c = 'indian';
        ij.Doctor_Name__c = 'Dr. Chandra';
        insert ij;
        
        TriggerExecutions__c texc = new TriggerExecutions__c();
        texc.Admission_Ack_API__c = true;
        texc.Name='Blow';
        insert texc;
        //AdmissionAcknowledgementsController.coverage();
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/createadmissionack/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('{"Data" : [{"SSNNo" : "test1","DoctorID":"12344","DOCTORNAME":"Dr Kumar Vishawas","WardNo":"2432","BedNo":"232","ContactPersonMobileNo":"9863534232","ContactPersonName":"Ravi","IPID" : "654","HospitalLocation" : "23","EmergencyNo" : "1234","International":"true","AccountID":"901", "MarkupType":"009","MaxId":"4556","PreadmitNo":"456","TransactionType" :"AK-1234","Address" : "abcd","Locality" : "Noida","City" : "10","Country" : "India","OP" : "Test","Pincode" : "234567","BILLNO" : "567","BILLDATE" : "'+system.today()+'","DISCOUNT" : "789","TOTALAMOUNT" : "2000","CASHOrCredit" : "Cash","CAMPAIGNCODE" : "test02", "CHANNELNAME":"International","DATEOFADMISSION":"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'", "SpecialityId":"123","SubSpecialityId":"123","isbillcancelled":"yes","State":"Maharastra","doctor_employee_id":"1234","AppointmentBookinId":"1233","ProcessByDrAppointment":"abc","DiscountReason" : "test","PatientName":"test","SourceOfInfo":"Others","billupdated":"45","CompanyShareAmount":"4563","CompanyName":"abbb","AdmissionStatus":"A","IsEmergency":"true","CouponCode":"342","IsPatientTransfer":"abc","MarkupPer":"mmm"},{"SSNNo" : "test1","IPID" : "654","EmergencyNo" : "1234","International":"true","AccountID":"901", "MarkupType":"009","PreadmitNo":"456","TransactionType" :"AK-1234","Address" : "abcd","Locality" : "Noida","City" : "10","Country" : "India","OP" : "Test","Pincode" : "234567","BILLNO" : "567","BILLDATE" : "'+system.today()+'","DISCOUNT" : "789","DOCTORNAME" : "test1","TOTALAMOUNT" : "2000","CASHOrCredit" : "Cash","CAMPAIGNCODE" : "test02", "CHANNELNAME":"International","DATEOFADMISSION":"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'", "SpecialityId":"123","isbillcancelled":"yes","State":"Maharastra","doctor_employee_id":"1234","AppointmentBookinId":"1233","ProcessByDrAppointment":"abc","DiscountReason" : "test","PatientName":"test","SourceOfInfo":"Others","billupdated":"45","CompanyShareAmount":"4563","CompanyName":"abbb","IsEmergency":"true","CouponCode":"342","IsPatientTransfer":"abc","MarkupPer":"mmm"}]}');
        RestContext.request = req;
        RestContext.response= res;
        AdmissionAcknowledgementsController.doCreateAdmission();
        AdmissionAcknowledgementsController.RequestBody requestBody = new AdmissionAcknowledgementsController.RequestBody();
        AdmissionAcknowledgementsController.existingprospectIdMap(new Map<String,Boolean>{obj.Max_Id__c=>True}, new Map<String,Admission_Acknowledgement__c>{obj.Max_Id__c=>ack});
    }
    
    @isTest static void test2(){
        System.debug('METHOD 2');
        
        TriggerExecutions__c texc = new TriggerExecutions__c();
        texc.Admission_Ack_API__c = true;
        texc.Name='Blow';
        insert texc;
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/createadmissionack/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('{"Data" : [{"SSNNo" : "test1","IPID" : "654","HOSPITALLOCATION" : "23","EmergencyNo" : "1234","International":"false","AccountID":"900", "MarkupType":"008","MaxId":"4556","PreadmitNo":"456","TransactionType" :"AK-1234","Address" : "abcd","Locality" : "Noida","City" : "10","Country" : "India","OP" : "Test","Pincode" : "234567","BILLNO" : "567","BILLDATE" : "'+system.today()+'","DISCOUNT" : "789","DOCTORNAME" : "test","TOTALAMOUNT" : "2000","CASHOrCredit" : "Cash","CAMPAIGNCODE" : "test02", "CHANNELNAME":"International","DATEOFADMISSION":"'+system.today()+'", "DATEOFDISCHARGE":"'+system.today()+'", "SubSpecialityId":"123","isbillcancelled":"yes","State":"Maharastra","doctor_employee_id":"1234","AppointmentBookinId":"1233","ProcessByDrAppointment":"abc","DiscountReason" : "test","PatientName":"test","SourceOfInfo":"Others","billupdated":"45","CompanyShareAmount":"4563","CompanyName":"abbb","AdmissionStatus":"A","IsEmergency":"true","CouponCode":"342","IsPatientTransfer":"abc","MarkupPer":"mmm"}]}');
        RestContext.request = req;
        RestContext.response= res;
        AdmissionAcknowledgementsController.doCreateAdmission();
        AdmissionAcknowledgementsController.RequestBody requestBody = new AdmissionAcknowledgementsController.RequestBody();        
    }    
    
    @isTest static void test3(){
        System.debug('METHOD 2');
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/createadmissionack/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof('{"Data" : []}');
        RestContext.request = req;
        RestContext.response= res;
        AdmissionAcknowledgementsController.doCreateAdmission();
        AdmissionAcknowledgementsController.RequestBody requestBody = new AdmissionAcknowledgementsController.RequestBody();        
    }    
}