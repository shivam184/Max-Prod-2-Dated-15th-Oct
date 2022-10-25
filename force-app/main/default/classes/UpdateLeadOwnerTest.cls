@isTest
public class UpdateLeadOwnerTest {
    @isTest
    public static void runTest(){
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test2', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sasac@mde.com');
        
        insert u;
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId(); 
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        insert ac;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'tsetBusinessUnit';
        insert bu;
        
        Doctor_Co_Ordinator_OP_OP__c dco=new Doctor_Co_Ordinator_OP_OP__c();
        dco.Doctor__c=ac.id;
        dco.Co_Ordinator__c=u.id;
        dco.Doctor_Speciality__c='testSpeciality';
        dco.Business_Unit__c=bu.id;
        insert dco;
        
        Lead__c lead = new Lead__c();
        lead.Name = 'Test';
        lead.Mobile_Phone__c ='1234567789';
        lead.Email__c='test@gmail.com';
        lead.City__c='Noida';
        lead.APISave__c=true;
        insert lead;
        
        lead.Disposition_Option__c='Follow Up';
        lead.name='testtwo';
        lead.Doctor__c=ac.id;
        lead.Speciality_Text__c='testSpeciality';
        lead.Business_Unit__c='tsetBusinessUnit';
        try{
        update lead;    
        }Catch(Exception e){}
        
        
        lead.Disposition_Option__c='Not Interested';
        lead.name='testtwo';
        lead.Doctor__c=ac.id;
        lead.Speciality_Text__c='testSpeciality';
        lead.Business_Unit__c='tsetBusinessUnit';
        lead.Sub_Option__c='Not required Immediately';
        update lead;
    }    
    
}