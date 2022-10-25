@istest
public class SendSmsDoctorOnCallApextest {
    
    
    public static testmethod void runTest(){
        
        Max_at_Home_Enquiry_Page__c ld= new Max_at_Home_Enquiry_Page__c();
        ld.Phone_No__c='0123456789';
        ld.Patient_Name__c='test';
        insert ld;
        E_Prescription__c ep=new E_Prescription__c();
        ep.Isolation_Max_Home__c=ld.id;
        insert ep;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,new BitlyHttpCalloutMock());
        // Test.setMock(HttpCalloutMock.class, new SendSmsDoctorOnCallApextest());
        SendSmsDoctorOnCallApex.sendSMS(ld.Id);
        Test.stopTest();
    }
    
}