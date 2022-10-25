@isTest
public class VisaInviteBatchClassSchedularTest {
    @IsTest
    public static void runVisaInviteTest(){
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account';
        insert hcf;
        
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        insert doctor;
        
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
        insert acc2;  
        
        Visa_Invite__c inv = new Visa_Invite__c();
        inv.Hospital_Location__c = bu.Id;
        inv.Passport_number__c = '125485';
        inv.HCF_Partner_name__c = hcf.Id;
        inv.Country__c = add.id;
        inv.Customer_Patient_Name__c = 'test';
        inv.Doctor_Name__c=doctor.Id;
        inv.Visa_Invite_Number__c = '2020/Mar/693753/v1.1';
        inv.Ailment__c = 'test';
        inv.Stage__c='New';
        //inv.Patient__c=acc2.id;
        inv.Max_Id__c='M124';
        insert inv;
        
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new VisaInviteBatchClassSchedular());
        Test.stopTest(); 
        
    }
    
}