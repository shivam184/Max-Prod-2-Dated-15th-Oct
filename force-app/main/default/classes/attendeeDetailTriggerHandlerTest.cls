/*created by: Nitya(IRT) on 6th April
* */
@isTest
public class attendeeDetailTriggerHandlerTest {
    @isTest
    public static void test1(){
        //Doctor
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        insert doctor;
        
        //HCF
        Account hcf = new Account();
        hcf.Name = 'test';
        hcf.Type = 'MACN';
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert hcf;
        
        //Business Unit
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name = 'MAX Saket';
        bu.Business_Unit_HIS__c = 'test MAX';
        bu.HIS_ID__c = '20';
        bu.Business_Unit_Code__c = 'VSH';
        insert bu;
        
        //Country
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        visa_invite__c vi=new visa_invite__c();
        vi.Doctor_Name__c=doctor.id;
        vi.Country__c=add.id;
        vi.HCF_Partner_name__c=hcf.id;
        vi.Hospital_Location__c=bu.id;
        vi.Passport_number__c = '125485';
        vi.Customer_Patient_Name__c = 'test';
        vi.Visa_Invite_Number__c = '2020/Mar/693753/v1.1';
        vi.Ailment__c = 'test';
        vi.Gender__c ='Male';
        vi.Sub_HCF_Name__c ='Test';
        vi.HCF_Mobile_No__c ='123456789';
        vi.Recipient_Email__c ='test@test.com';
        vi.Recipient_City__c ='Delhi';
        vi.Type_of_Visa__c='Donor';
        insert vi;
        
        attendant_detail__c ad=new attendant_detail__c();
        ad.Active__c=true;
        ad.Visa_Invite__c=vi.id;
        ad.Date_of_Birth__c=system.today();
        ad.Name='attendee-1';
        ad.Passport_number__c='123';
        insert ad;
        ad.Active__c=false;
        update ad;
    }
    @isTest
    public static void test2(){
        //Doctor
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        insert doctor;
        
        //HCF
        Account hcf = new Account();
        hcf.Name = 'test';
        hcf.Type = 'MACN';
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert hcf;
        
        //Business Unit
        Business_Unit__c bu = new Business_Unit__c();
        bu.Name = 'MAX Saket';
        bu.Business_Unit_HIS__c = 'test MAX';
        bu.HIS_ID__c = '20';
        bu.Business_Unit_Code__c = 'VSH';
        insert bu;
        
        //Country
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        visa_invite__c vi=new visa_invite__c();
        vi.Doctor_Name__c=doctor.id;
        vi.Country__c=add.id;
        vi.HCF_Partner_name__c=hcf.id;
        vi.Hospital_Location__c=bu.id;
        vi.Passport_number__c = '125485';
        vi.Customer_Patient_Name__c = 'test';
        vi.Visa_Invite_Number__c = '2020/Mar/693753/v1.1';
        vi.Ailment__c = 'test';
        vi.Gender__c ='Male';
        vi.Sub_HCF_Name__c ='Test';
        vi.HCF_Mobile_No__c ='123456789';
        vi.Recipient_Email__c ='test@test.com';
        vi.Recipient_City__c ='Delhi';
        vi.Type_of_Visa__c='Donor';
        insert vi;
        Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
        attendant_detail__c ad=new attendant_detail__c();
        ad.RecordTypeId=donorRTId;
        ad.Active__c=true;
        ad.Visa_Invite__c=vi.id;
        ad.Date_of_Birth__c=system.today();
        ad.Name='attendee-1';
        ad.Passport_number__c='123';
        insert ad;
        ad.Active__c=false;
        update ad;
    }
}