@isTest
public class ACDFormController_Test {
    static testmethod void test()
    {   
        Business_Unit__c obj1=new Business_Unit__c();
        obj1.Name = 'Test';
        insert obj1;
        
        Account acc2=new account();
        acc2.FirstName='Test1';
        acc2.LastName='mr blag';
        acc2.Max_ID__c='blah';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc2;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        Prospect__c objNew=new Prospect__c();
        objNew.Source__c= 'E Prescription';
        objNew.Stage__c = 'Admission Advised';
        objNew.HIS_Hospital_Location__c = obj1.Id;
        objNew.Doctor__c = acc.id;
        objNew.Max_Id__c='blah';
        objNew.Account__c = acc2.Id;
        insert objNew;
        
        Admission_Acknowledgement__c ack = new Admission_Acknowledgement__c();
        ack.Max_Id__c = 'blah';
        insert ack;
    
        
        ACDFormController.saveProspectDetails(objNew);
    }
    
}