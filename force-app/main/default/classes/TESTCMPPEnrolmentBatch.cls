@isTest
public class TESTCMPPEnrolmentBatch{

    static testMethod void testMethod1(){
        
        Address_Master__c adm = new Address_Master__c();
        adm.Name = 'City';
        adm.Deleted__c = '0';
        adm.RecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('City').getRecordTypeId();
        insert adm;
        
        Address_Master__c adm2 = new Address_Master__c();
        adm2.Name = 'Locality';
        adm2.RecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Locality').getRecordTypeId();
        insert adm2;
        
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name = 'Max Saket';
        bu.HIS_ID__c = '15';
        insert bu;
        
        Gender__c gender = new Gender__c();
        gender.Name = 'Male';
        gender.HIS_ID__c = '1';
        insert gender;
        
        Gender__c gender2 = new Gender__c();
        gender2.Name = 'Female';
        gender2.HIS_ID__c = '2';
        insert gender2;
        
        Customer_Activation__c custAct = new Customer_Activation__c();
        custAct.City_AddressMaster__c = adm.Id;
        custAct.HIS_Locality__c = adm2.Id; 
        insert custAct;
        
        
        Lead__c lead2 = new Lead__c();
        lead2.RecordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        lead2.Name = 'Test Lead2';
        lead2.First_Name__c= 'Test Lead2';
        lead2.Last_Name__c= 'Test Lead2';
        lead2.Address_Line_1__c= 'Test Lead2';
        lead2.Primary_Member__c = false; 
        lead2.Mobile_Phone__c = '65466';
        lead2.Gender__c= 'Male'; 
        lead2.Email__c = 'test2@GMAIL.COM';
        LEAD2.DOB__c = system.today().addyearS(-30);
        lead2.Want_to_Enrol__c =true; 
        lead2.Business_Unit__c = 'Max Saket';
        lead2.Membership_Enrolment_Type__c = 'Citizen Plus';
        lead2.Health_Camp__c = custAct.Id;
        lead2.ZIP_Postal_Code__c = '321565';
        lead2.Enrollment_Verified__c = system.label.Verified_Enrolment;
       // lead2.Max_ID__c ='MHLI.3945123';
        //lead2.Want_to_Enrol__c =true ;
        //lead2.Enrollment_Verified__c ='Yes';
        insert lead2;
        
        Test.startTest();
        CMPPatientRegistrationAndEnrolmentBatch obj = new CMPPatientRegistrationAndEnrolmentBatch();

        DataBase.executeBatch(obj);
       // CMPBatch3 obj2 = new CMPBatch3();

        //DataBase.executeBatch(obj2);
        
        Test.stopTest();

        
    }

}