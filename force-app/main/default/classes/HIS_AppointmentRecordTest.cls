/*created by : Nitya(IRT)
 * Created Date :31st May 2022
 * Purpose: API to insert appointment records from HIS
 */
@isTest
public class HIS_AppointmentRecordTest {
@isTest
    public static void test1(){
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/AppointmentHis';  //Request URL
        req.httpMethod = 'PATCH';//HTTP Request Type
        req.requestBody=blob.valueOf('[{"attributes":{"type":"appointment__c","referenceId":"19947745"},"Amount__c":"1200","age__c":"3","Amount_After_Discount__c":"1200","Appointment_Created_Time__c":"2021-12-26T14:05:03Z","Appointment_ID__c":"BAOAOH2J93","Appointment_Date_Time__c":"2021-12-27T11:10:00Z","Booking_Source__c":"MyHealth","Booking_Status__c":"Confirmed","Clinic_Name__c":"","Department_Name__c":"Pediatrics","DOB__c":"2019-03-04","Doctor_Name__c":"Anil Kumar Gulati","Discount__c":"0.00","Gender__c":"2","Patient_Email__c":"","Patient_Name__c":"Ms. SARA GOYAL","Patient_Phone__c":"9958285530","Procedure_Name__c":"","Payment_Status__c":"Y","Duration__c":""}]');
        
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
       HIS_AppointmentRecord.upsertAppointment();
        test.stopTest();
    }
    @isTest
    public static void test2(){
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/AppointmentHis';  //Request URL
        req.httpMethod = 'PATCH';//HTTP Request Type
        req.requestBody=blob.valueOf('[{"attributes":{"type":"appointment__c","referenceId":"19947745"},"Amount__c":"1200","age__c":"3","Amount_After_Discount__c":"1200","Appointment_Created_Time__c":"2021-12-26T14:05:03Z","Appointment_ID__c":"","Appointment_Date_Time__c":"2021-12-27T11:10:00Z","Booking_Source__c":"MyHealth","Booking_Status__c":"Confirmed","Clinic_Name__c":"","Department_Name__c":"Pediatrics","DOB__c":"2019-03-04","Doctor_Name__c":"Anil Kumar Gulati","Discount__c":"0.00","Gender__c":"2","Patient_Email__c":"","Patient_Name__c":"Ms. SARA GOYAL","Patient_Phone__c":"9958285530","Procedure_Name__c":"","Payment_Status__c":"Y","Duration__c":""}]');
        
        RestContext.request = req;
        RestContext.response= res;
        test.startTest();
       HIS_AppointmentRecord.upsertAppointment();
        test.stopTest();
    }
}