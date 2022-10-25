@isTest
public class AccountTriggerTest {
    
    @isTest
    public static void doTest() {
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Account__c = true;
        trex.Name = 'test';
        insert trex;
        
        AccountNumberGeneration__c ang = new AccountNumberGeneration__c();
        ang.AutoNumber__c = 1;
        insert ang;
        
        String rec = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('City').getRecordTypeId(); 
        Address_Master__c add = new Address_Master__c();
        add.RecordTypeId = rec;
        add.alletec_cityid__c = 'test';
        insert add;
        
        String rectype = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId(); 
        Address_Master__c addd = new Address_Master__c();
        addd.RecordTypeId = rectype;
        addd.alletec_countryid__c = 'test';
        insert addd;
        
        Department__c dep = new Department__c();
        dep.alletec_id__c = 12;
        insert dep;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';
        at.Business_Unit__c = bu.Id;
        insert at;
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId(); 
        Account acc = new Account();
        if(String.isNotBlank(recordTypeId))
            acc.RecordTypeId = recordTypeId;
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        insert acc;
        
        String recordTypeLeadId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId(); 
        System.debug('========>>>>'+recordTypeLeadId);
        Lead__c ld = new Lead__c();
        ld.Name = 'Test';
        ld.RecordTypeId = recordTypeLeadId;
        ld.Mobile_Phone__c = '9876543210';
        ld.Email__c = 'test@gm.com';
        insert ld;
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account ac = new Account();
        if(String.isNotBlank(recordTypeId))
            ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        insert ac;
        
        
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(Ld.Id, yesterday);
    }
    
    @isTest
    public static void unitTest() {
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Account__c = true;
        trex.Name = 'test';
        insert trex;
        
        AccountNumberGeneration__c ang = new AccountNumberGeneration__c();
        ang.AutoNumber__c = 1;
        insert ang;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';
        at.Business_Unit__c = bu.Id;
        insert at;
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId(); 
        Account acc = new Account();
        if(String.isNotBlank(recordTypeId))
            acc.RecordTypeId = recordTypeId;
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        insert acc;
        
        String recordTypeLeadId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId(); 
        System.debug('========>>>>'+recordTypeLeadId);
        Lead__c ld = new Lead__c();
        ld.Name = 'Test';
        ld.RecordTypeId = recordTypeLeadId;
        ld.Max_ID__c = NULL;
        ld.Email__c = 'test@gm.com';
        insert ld;
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account ac = new Account();
        if(String.isNotBlank(recordTypeId))
            ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.PersonEmail = 'test@gm.com';
        insert ac;
        
        
    }
    
}