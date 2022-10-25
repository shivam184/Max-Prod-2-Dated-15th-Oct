@isTest(seeAllData = false)
public class AddFamilyMemberTest {
    
    
    static testMethod void testData1(){
        
        Account acc = new Account();
        acc.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc.Phone = '87687688';
        acc.LastName='Last Name';
        acc.Max_ID__c='KJHKUU';
        acc.PersonMobilePhone = '87687688';
        acc.FirstName='Last Name';
        acc.PersonEmail='kjhk@kjhk.com';
        acc.Postal_Code__c = '876876';
        acc.BillingStreet='Last Name';
        acc.Gender__c='Male';
        acc.DOB__c=Date.valueOf('1991-03-07');
        
        insert acc;
        
        Account acc2 = new Account();
        acc2.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.Phone = '87687688';
        acc2.LastName='Last Name';
        acc2.Max_ID__c='8IUYI';
        acc.PersonMobilePhone = '87687688';
        acc.FirstName='Last Name';
        acc.PersonEmail='kjhk@kjhk.com';
        acc.Postal_Code__c = '876876';
        acc.BillingStreet='Last Name';
        acc.Gender__c='Male';
        acc.DOB__c=Date.valueOf('1991-03-07');
        insert acc2;
        
        AddFamilyMemberApex.searchinSalesforce('87687688', true);
        
        AddFamilyMemberApex.searchinSalesforce('876876786', false);
        
        Account acc3 = new Account();
        acc3.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc3.Phone = '99999999';
        acc3.LastName='Last Name';
        acc3.Max_ID__c='8IUYI';
        acc3.PersonMobilePhone = '99999999';
        acc3.FirstName='Last Name';
        acc3.PersonEmail='kjhk@kjhk.com';
        acc3.Postal_Code__c = '876876';
        acc3.BillingStreet='Last Name';
        acc3.Gender__c='Male';
        acc3.DOB__c=Date.valueOf('1991-03-07');
        insert acc3;
        
        AddFamilyMemberApex.searchinSalesforce('99999999', false);
        
    }    
    
    
    static testMethod void testData2(){
        
        Account acc = new Account();
        acc.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc.Phone = '87687688';
        acc.LastName='Last Name';
        acc.Max_ID__c='KJHKUU';
        insert acc;
        
        
        Address_Master__c adm = new Address_Master__c();
        adm.Name = 'City';
        adm.Deleted__c = '0';
        adm.RecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('City').getRecordTypeId();
        insert adm;
        
        Address_Master__c adm2 = new Address_Master__c();
        adm2.Name = 'Locality';
        adm2.RecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Locality').getRecordTypeId();
        insert adm2;
        
        
        Customer_Activation__c custAct = new Customer_Activation__c();
        custAct.City_AddressMaster__c = adm.Id;
        custAct.HIS_Locality__c = adm2.Id; 
        insert custAct;
         
        AddFamilyMemberApex.populateBusinesUnit();
        Lead__c lead = new Lead__c();
        lead.RecordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        Lead.Name = 'Test Lead';
        lead.Primary_Member__c = true;
        lead.Mobile_Phone__c = '65466';
        lead.Max_ID__c = '65466';
        lead.Business_Unit__c = 'Max Saket';
        lead.Membership_Enrolment_Type__c = 'Citizen Plus';
        insert Lead;
        
        AddFamilyMemberApex.setMasterValues(custAct.Id, Lead);
        
        AddFamilyMemberApex.fetchPrimaryMember(Lead.Id);
        AddFamilyMemberApex.getOccupations();
        
        AddFamilyMemberApex.getEnrolmentTypes();      
        
        AddFamilyMemberApex.searchMember('9874856985');
        
        
        PatientSearchJsonParser.Patients pat = new PatientSearchJsonParser.Patients();
        pat.MaxID = 'KJHKJH';
        pat.PatientName = 'Test Name';
        pat.MobileNo = '9879879';
        pat.Age = '24';
        pat.FirstName = 'TEST 876';
        pat.LastName = 'TEST';
        pat.EmailID = 'gems@xyz.com';
        pat.CityName='TST';
        pat.Area = 'ARES';
        pat.PinCode =313213;
        pat.Address = '32132';
        pat.Gender = 'Male';
        pat.AgeINT = 9;
        
        AddFamilyMemberApex.mapDetails(pat);
        
        
        Lead__c lead2 = new Lead__c();
        lead2.RecordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        lead2.Name = 'Test Lead2';
        lead2.Primary_Member__c = false; 
        lead2.Mobile_Phone__c = '65466';
        lead2.Want_to_Enrol__c =true;
        lead2.Max_ID__c = '65466';
        lead2.Business_Unit__c = 'Max Saket';
        lead2.Membership_Enrolment_Type__c = 'Citizen Plus';
         
        
        
        AddFamilyMemberApex.searchinSalesforce('87687688', false);
        
        AddFamilyMemberApex.validateMemberDetails(lead2, lead.id, false);
        AddFamilyMemberApex.saveMemberDetails(lead2,lead.Id,false,false,'65456546', true,'','');
        
        AddFamilyMemberApex.attachFile('fileName.png', 'iuyiuyiuyiuyiyiuyiuyiuyi', lead.Id);
        
        
        
        
    }

}