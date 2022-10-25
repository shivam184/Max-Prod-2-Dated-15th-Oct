@isTest
public class VILLinkageApexTest {
    @isTest
    public static void runVilTest(){
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
        cs.Passport_No__c='testpass';
        cs.Lead_Create__c=True;
        Insert cs;
        
        VILLinkageApex.doInitApex(cs.id);
    }

}