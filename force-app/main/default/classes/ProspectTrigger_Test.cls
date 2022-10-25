@isTest
public class ProspectTrigger_Test {
    
    public static testmethod void test()
    {
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Prospect__c = true;
        trex.Name = 'test';
        insert trex;
        
        Business_Unit__c obj1=new Business_Unit__c();
        obj1.Name = 'Test';
        insert obj1;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        Doctor_Coordinator_Master__c obj2= new Doctor_Coordinator_Master__c();
        obj2.Business_Unit__c=obj1.id;
        obj2.Doctor__c=acc.id;
        obj2.Channel__c='TPA';
        obj2.Co_ordinator__c=UserInfo.getUserId();
        insert obj2;
        
        International_OP_Patient_Journey__c ipoj=new International_OP_Patient_Journey__c();
        ipoj.Stage__c='OPD Mapping';
        ipoj.Admission_advice__c=true;
        ipoj.First_OP_Bill_Date__c=system.today()-2;
        insert ipoj;
        
        Prospect__c obj=new Prospect__c();
        obj.Source__c= 'E Prescription';
        obj.Stage__c = 'Admission Advised';
        obj.HIS_Hospital_Location__c = obj1.Id;
        obj.Doctor__c = acc.id;
        obj.Max_Id__c='blah';
        obj.Channel__c = 'TPA';
        obj.International_OP_Patient_Journey__c=ipoj.id;
        insert obj;
        
        obj.Max_Id__c='bla';
        obj.Doctor_Est_Ep__c=acc.Id;
        obj.Secondary_Doctor_Business_Unit__c=obj1.Id;
        update obj;
        
        
    }
}