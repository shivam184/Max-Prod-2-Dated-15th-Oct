@isTest
public class DigitalLeadTriggerTest {
    @isTest
    public static void runDigitalLead(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.Digital_Lead__c = true;
        trex.leadcheckbox__c=false;
        insert trex;
        
        
        
        Lead__c ld=new Lead__c();
        ld.Name='Test';
        ld.Max_ID__c='SKDD.123456';
        ld.Lead_Create__c=false;
        Insert ld;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Max_ID__c='SKDD.12345';
        CS.Address_Line_1__c='TEST';
        CS.Campaign__c='TEST';
        CS.Country_Region__c='TEST';
        CS.Description='TESTING';
        CS.Doctor_Name__c='TEST';
        CS.Email__c='TEST@GMAIL.COM';
        CS.File_Name__c='TEST';
        CS.Form_Name__c='TEST';
        cs.Placement__c='test';
        cs.Patient_Name__c='test';
        cs.Passport_No__c='555';
        cs.Lead_Create__c=True;
        cs.Lead_Source__c='D-Paid';
        cs.Sub_Source__c='Online Chat';
        cs.Appointment_Date__c=system.today();
        cs.Stage__c='New';
        cs.Lead__c=ld.id;
        Insert cs;
        CS.Doctor_Name__c='TEST1';
        cs.Passport_No__c='556';
        cs.status = 'Proposal Shared';
        cs.stage__c='OPD Consult Taken';
        update cs;
        cs.status = 'Reports Shared with Unit';
        update cs;
        
    }
     @isTest
    public static void runDigitalLead1(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.Digital_Lead__c = true;
        trex.leadcheckbox__c=false;
        insert trex;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Lead_Source__c='D-Paid';
        cs.Sub_Source__c='Online Chat';
        cs.Appointment_Date__c=system.today();
        cs.status='Appointment Booked';
        insert cs;
        cs.status='New';
        update cs;

    }
    @isTest
    public static void runDigitalLead2(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.Digital_Lead__c = true;
        trex.leadcheckbox__c=false;
        insert trex;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Lead_Source__c='D-Paid';
        cs.Sub_Source__c='Online Chat';
        cs.Appointment_Date__c=system.today();
        cs.status='OPD Consult Taken';
        insert cs;
        cs.status='Appointment Booked';
        update cs;

    }
    
    @isTest
    public static void runDigitalLead3(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.Digital_Lead__c = true;
        trex.leadcheckbox__c=false;
        insert trex;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Lead_Source__c='D-Paid';
        cs.Sub_Source__c='Online Chat';
        cs.Appointment_Date__c=system.today();
        cs.status='Proposal Shared';
        insert cs;
        cs.status='OPD Consult Taken';
        update cs;

    }
    
    @isTest
    public static void runDigitalLead4(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.Digital_Lead__c = true;
        trex.leadcheckbox__c=false;
        insert trex;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Lead_Source__c='D-Paid';
        cs.Sub_Source__c='Online Chat';
        cs.Appointment_Date__c=system.today();
        cs.status='Closed Lost';
        cs.Lost_Reason__c='Closed Lost';
        insert cs;
        cs.status='Contacted Patient';
        update cs;

    }
}