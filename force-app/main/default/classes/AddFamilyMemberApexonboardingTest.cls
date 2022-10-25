@istest
public class AddFamilyMemberApexonboardingTest {
    Public static testmethod void mytest(){
        
        
        Prospect__c pro = new Prospect__c();
        pro.Name='Test';
        pro.Gender__c='Male';
        insert pro;
        
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        
        Lead__c lead = new Lead__c();
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        lead.RecordTypeId=recordTypeId;
        lead.Prospect__c=pro.Id;
        lead.Address_Line_1__c='noida';
        lead.Locality__c='NCR';
        insert lead;
        
        
        Business_Unit__c bu = new Business_Unit__c();
        bu.OwnerId=UserInfo.getUserId();
        bu.Business_Unit_Code__c='465868';
        insert bu;
        
        
        String recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acnt = new Account();
        acnt.RecordTypeId = recordTypeId1;
        acnt.FirstName ='test';
        acnt.MiddleName = 'test';
        acnt.LastName = 'test';
        acnt.PersonEmail = 'test@test.com';
        acnt.PersonMobilePhone = '9876543210';
        acnt.Max_ID__c = 'test.12345';
        acnt.Passport__c='9876543210';
        acnt.Postal_Code__c='201301';
        acnt.Gender__c='Male';
        acnt.DOB__c=System.today();
        
        //acnt.Phone='9555064159';
        insert acnt;
        
        AddFamilyMemberApexonboarding.populateBusinesUnit();
        AddFamilyMemberApexonboarding.searchinSalesforce('9876543210');
        //AddFamilyMemberApexonboarding.setMasterValues(lead.Id, lead.Customer_Activation_Onbording__c);
    }
    
    public static testmethod void mytest11(){
        
        Prospect__c pro2 = new Prospect__c();
        pro2.Name='Test2';
        pro2.Gender__c='Male';
        insert pro2;
        
        String recordTypeId2 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        
        Lead__c lead2 = new Lead__c();
        lead2.City__c = 'Delhi';
        lead2.Company_Name__c = 'MAX';
        lead2.Last_Name__c = 'lab';
        lead2.First_Name__c = 'test';
        lead2.Business_Model__c = 'PAS';
        lead2.Sales_Region__c = 'NCR';
        lead2.Rating__c = 'Cold';
        lead2.RecordTypeId=recordTypeId2;
        lead2.Prospect__c=pro2.Id;
        lead2.Address_Line_1__c='noida';
        lead2.Locality__c='NCR';
        insert lead2;
        
    Customer_Activation_Onboarding__c cao = new Customer_Activation_Onboarding__c();
        //cao.Lead__c=lead.Id;
        //cao.Type_Of_Activity__c='Test6';
        insert cao;
        
        String caoStr = String.valueOf(cao.id);
        
        //AddFamilyMemberApexonboarding.saveMemberDetails(lead2, false, caoStr);
        AddFamilyMemberApexonboarding.coverage();
    }
    
    public static testmethod void mytest1(){
                
        
        Customer_Activation_Onboarding__c cao = new Customer_Activation_Onboarding__c();
        //cao.Lead__c=lead.Id;
        cao.Type_Of_Activity__c='Test';
        insert cao;
        
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        
        Lead__c lead = new Lead__c();
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        lead.RecordTypeId=recordTypeId;
        lead.Customer_Activation_Onbording__c=cao.Id;
        insert lead;
       //AddFamilyMemberApexonboarding.saveMemberDetails(lead, True , lead.Id);
       AddFamilyMemberApexonboarding.setMasterValues(cao.id, lead );

    }
}