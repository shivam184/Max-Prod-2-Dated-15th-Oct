@isTest
public class DoctorCoordinatorMasterTriggerTest {

    @isTest
    static void test1(){
        
        TriggerExecutions__c triggercheck = new TriggerExecutions__c();
        triggercheck.Doctor_Coordinator_Master__c = true;
        triggercheck.Name = 'Test';
        insert triggercheck;
        
        Department__c depart = new Department__c();
        depart.Name = 'Test Depart';
        insert depart;
        
        Speciality__c speciality = new Speciality__c();
        speciality.Name = 'Test Specialization';
        speciality.alletec_department__c = depart.Id;
        insert speciality;
        
        Business_Unit__c bUnit = new Business_Unit__c();
        bUnit.Name = 'Test BUnit';
        bUnit.HIS_ID__c = '12';
        insert bUnit;
        
        String accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account acc = new Account();
        if(accRecordTypeId != NULL){
            acc.RecordTypeId = accRecordTypeId;
            acc.LastName = 'Test Doctor';
            insert acc;            
        }
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser123@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser11@testorg.com');
        
        insert u;
                
        Doctor_Coordinator_Master__c dcm = new Doctor_Coordinator_Master__c();
        dcm.Doctor__c = acc.Id;
        dcm.Business_Unit__c = bUnit.Id;
        dcm.Specialization__c = speciality.Id;
        dcm.Co_ordinator__c = u.Id;
        dcm.Channel__c = 'Cash';
        insert dcm;		   
    }
}