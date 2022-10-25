/*
* Developed By : Karan Kumar
* Date : 12th -Feb-2020
* Class : To pass two scheduler BatchLeadOrAppointmentAndBillSumUpdatSch &  ScheduleAppointmentPatientBatch of two different batch classes
*/
@isTest
public class BatchLeadOrAppointmentAndBillSumUpdTest {
    @isTest
    public static void AppoitTest1(){
        AppointmentRevenueProcessHelper.testCoverage();
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Account__c = false;
        trex.BillingSummary__c = false;
        trex.Name = 'test';
        insert trex;
        
        Account acc = new Account ();
        acc.lastname = 'prostar';
        acc.Max_ID__c = '12345';
        acc.PersonMobilePhone = '8987676545';
        acc.alletec_patientregisterationdate__c=system.today().addMonths(-1);
        acc.Gender__c='Male';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc;
        
        Appointment__c app=new Appointment__c();
        app.Patient__c = acc.Id;
        app.Patient_Phone__c='8987676545';
        app.Appointment_Created_Time__c=system.today().addMonths(-1);
        app.Gender__c='Male';
        app.Stage__c='Closed Won';
        app.Max_ID__c='12345';
        app.First_OPD_Bill_Date__c=null;
        app.Appointment_Original_Time__c=system.today().addDays(2);
        insert app;
        
        Billing_Summary__c bill = new Billing_Summary__c();
        bill.Patient__c=acc.id;
        bill.alletec_billdate__c=system.now()+10;
        bill.Appointment__c=null;
        insert bill;
        
        Appointment_Revenue_Process__mdt mdt = new Appointment_Revenue_Process__mdt();
        mdt.DeveloperName='BatchSetting';
        
        
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new BatchAppointmentRevenueProcessSchedule());
        
        
        Test.stopTest(); 
        
    }
    @isTest
    public static void AppoitTest(){
        AppointmentRevenueProcessHelper.testCoverage();
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Account__c = false;
        trex.BillingSummary__c = false;
        trex.Name = 'test';
        insert trex;
        
        Account acc = new Account ();
        acc.lastname = 'prostar';
        acc.Max_ID__c = 'po123';
        acc.PersonMobilePhone = '8987676545';
        acc.alletec_patientregisterationdate__c=system.today().addMonths(-1);
        acc.Gender__c='Male';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc;
        
        Appointment__c app=new Appointment__c();
        //app.Max_ID__c='po123';
        //app.Patient__c=acc.id;
        app.Patient_Phone__c='8987676545';
        app.Appointment_Created_Time__c=system.today().addMonths(-1);
        app.Gender__c='Male';
        insert app;
        
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new BatchAppointmentRevenueProcessSchedule());
        
        system.schedule('Test Territory Check1', CRONEXP,new BatchAppointmentRevenueProcessDigitalSch());
        
        //Database.executeBatch( new BatchAppointmentRevenueProcessSchedule() );
        Test.stopTest(); 
        
    }
}