@istest
public class GenratetemplatePdfController_Test {
    
    
    Public  static testmethod void GenerateTemplatePDFControllerTest() {
        
        //Patient
        Account patient = new Account();
        patient.LastName = 'Test Patient';
        patient.Max_ID__c = 'S124';
        patient.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert patient;
        
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
        Visa_Invite__c inv = new Visa_Invite__c();
        inv.Date_of_Birth__c=Date.newInstance(2016, 12, 9);
        inv.Hospital_Location__c = bu.Id;
        inv.Passport_number__c = '125485';
        inv.HCF_Partner_name__c = hcf.Id;
        inv.Country__c = add.id;
        inv.Customer_Patient_Name__c = 'test';
        inv.Doctor_Name__c=doctor.Id;
        inv.Visa_Invite_Number__c = '2020/Mar/693753/v1.1';
        inv.Ailment__c = 'test';
        inv.Gender__c ='Male';
        inv.Sub_HCF_Name__c ='Test';
        inv.HCF_Mobile_No__c = '1234567890' ;
        inv.Recipient_Email__c ='test@test.com'; 
        inv.Recipient_City__c ='Delhi';
        inv.Type_of_Visa__c ='Patient';
        insert inv;
        
        Id attendeeRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Attendee').getRecordTypeId();
        Attendant_Detail__c atendant = new Attendant_Detail__c();
        atendant.Name = 'Attendee';
       atendant.Date_of_Birth__c=Date.newInstance(2016, 12, 9);
      atendant.Visa_Invite__c = inv.id;
       atendant.RecordTypeId = attendeeRTId;
       atendant.Passport_number__c = '125485';
      atendant.Relation__c = 'Father';
        Insert atendant;
        
        
        
        
        
        
        
        
        
        
        Id donorRTId = Schema.SObjectType.Attendant_Detail__c.getRecordTypeInfosByDeveloperName().get('Donor').getRecordTypeId();
        Attendant_Detail__c donor = new Attendant_Detail__c();
        donor.Name = 'Donor';
        donor.Date_of_Birth__c=Date.newInstance(2016, 12, 9);
        donor.Visa_Invite__c = inv.id;
        donor.RecordTypeId = donorRTId;
        donor.Passport_number__c = '125485';
        donor.Relation__c = 'Father';
        Insert donor;
        
        List<Visa_Invite__c> LstVIsa = [Select Id, Passport_number__c From Visa_Invite__c where Passport_number__c = '125485' limit 1];
        Test.startTest();
        PageReference pageRef = Page.GenerateTemplatePDF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', LstVIsa [0].Id);
        
        GenerateTemplatePDFController pdf = new GenerateTemplatePDFController();
        pdf.footerimg = '';
        pdf.bottomImgURL = '';
        pdf.bottomImageset = new List<String>();
        pdf.invitefromaddress = '';
        String templateBodyPreview = pdf.templateBodyPreview;
        
        
        Test.stopTest();
    }
}