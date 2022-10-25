@istest
public class PayoutBillDateRestTest {
    @istest
    public static void Testing(){
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        acc2.Gender__c='Male';
        acc2.FirstName='test';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        acc2.alletec_patientregisterationdate__c=system.today();
        insert acc2;  
        
        Payout__c pay=new Payout__c();
        pay.alletec_billdate__c=system.today();
        pay.New_Pre_Intimation_Date_Time__c=system.today();
        pay.Patient__c=acc2.id;
        pay.Date_Time_of_Admission__c=system.today();
        pay.alletec_dateofadmission__c=system.today();
        pay.Date_of_Discharge__c=system.today().addDays(2);
        Insert pay;
        
        Test.startTest();
        string jsonbody='{"startDate":"2020-06-01","endDate":"2020-06-30"}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/PayoutBillDates';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonbody); 
        RestContext.request = req;
        RestContext.response= res;
        PayoutBillDateRest.getPayouts(); 
        
        string jsonbody1='{"":""}';
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/PayoutBillDates';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(jsonbody); 
        RestContext.request = req1;
        RestContext.response= res1;
        PayoutBillDateRest.getPayouts(); 
        
        
        
    }
}