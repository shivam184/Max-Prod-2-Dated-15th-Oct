@isTest
public class ScheduleLeadBillingSummaryBatchTest {
    static testMethod void method1(){
        
        
        String leadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        Lead__c lead = new Lead__c();
        //lead.Name = 'A S K';
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        lead.Max_ID__c = 'po123';
        lead.Stage__c='OPD Consult Taken';
        lead.RecordTypeId = leadRecordTypeId;
        lead.Mobile_Phone__c = '8987676545';
        lead.First_OPD_Bill_Date__c=system.today().addMonths(-3);
        insert lead;
        
        Account acc = new Account ();
        acc.lastname = 'prostar';
        acc.Max_ID__c = 'po123';
        acc.PersonMobilePhone = '8987676545';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc;
        
        
        
        Billing_Summary__c billing = new Billing_Summary__c();
        billing.Patient__c = acc.id;
        billing.name__c=acc.Max_ID__c;
        billing.alletec_billdate__c=system.today().addMonths(-3);
        insert billing;
       
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new ScheduleLeadBillingSummaryBatch());
        
       Test.stopTest(); 
        
    }
    static testMethod void method2(){
        
        
        String leadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        Lead__c lead = new Lead__c();
        //lead.Name = 'A S K';
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        lead.Max_ID__c = 'po123';
        lead.RecordTypeId = leadRecordTypeId;
        lead.Mobile_Phone__c = '8987676545';
        lead.Stage__c='OPD Consult Taken';
        lead.First_OPD_Bill_Date__c = Date.valueof(System.today().addmonths(-4));
        insert lead;
        
        Account acc = new Account ();
        acc.lastname = 'prostar';
        acc.Max_ID__c = 'po123';
        acc.PersonMobilePhone = '8987676545';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        insert acc;
        
        Billing_Summary__c billing = new Billing_Summary__c();
        billing.Patient__c = acc.id;
        insert billing;
       
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new ScheduleLeadBillingSummaryBatch());
        
       Database.executeBatch(new LeadBillingSummaryBatchNew());
       Test.stopTest(); 
        
    }
}