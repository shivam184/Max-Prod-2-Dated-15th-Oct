@isTest
public class LeadConvert_ControllerTest {
    
    static testMethod void testLeadConvert(){
        Lead__c lead = new Lead__c();
        //lead.Name = 'A S K';
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        insert lead;
        
        
        Account acc = new Account();
        acc.Name = 'TMC Account';
        insert acc;
        
        contact con = new contact();
        con.AccountId = acc.id;
        con.LastName = 'Test Name';
        //insert con;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opp';
        opp.Account__c = acc.id;
        opp.Business_Potential_Per_Month__c	= 1000;
        opp.Est_Close_Date__c = system.today();
        opp.Business_Model__c = 'PAS';
        //insert opp;
        
        List<LeadConversionMapping__c> customList = new List<LeadConversionMapping__c>();
        LeadConversionMapping__c accCustom = new LeadConversionMapping__c();
        accCustom.Mapping_Label__c = 1;
        accCustom.Mapped_Field__c = 'AnnualRevenue';
        accCustom.Name = 'Annual_Revenue__c';
        customList.add(accCustom);
        
        LeadConversionMapping__c conCustom = new LeadConversionMapping__c();
        conCustom.Mapping_Label__c = 2;
        conCustom.Mapped_Field__c = 'Description';
        conCustom.Name = 'Description__c';
        customList.add(conCustom);
        
        insert customList;
        
        LeadConvert_Controller.doInitApex(lead.Id);
        LeadConvert_Controller.wrapperClass wrapObj = new LeadConvert_Controller.wrapperClass();
        wrapObj.lead = lead;
        wrapObj.con = con;
        wrapObj.opp = opp;
        wrapObj.accountId = acc.id;
        wrapObj.oppName = opp.Name;
        wrapObj.acc = acc;
        LeadConvert_Controller.convertLeadApex(json.serialize(wrapObj), lead.Id);
    }
    static testMethod void testLeadConvert1(){
        Lead__c lead = new Lead__c();
        //lead.Name = 'A S K';
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        //lead.Sales_Territory__c = 'Jaipur';
        lead.Rating__c = 'Cold';
        //lead.RecordTypeId = Schema.SObjectType.Lead.getRecordtypeInfosByName().get('Max Labs').getRecordTypeId();
        // lead.Stage__c = 'New';
        insert lead;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'TMC Account';
        insert acc;
        
        contact con = new contact();
        con.AccountId = acc.id;
        con.LastName = 'Test Name';
        insert con;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opp';
        opp.Account__c = acc.id;
        opp.Business_Potential_Per_Month__c	= 1000;
        opp.Est_Close_Date__c = system.today();
        opp.Business_Model__c = 'PAS';
        insert opp;
        
        LeadConvert_Controller.wrapperClass wrapObj = new LeadConvert_Controller.wrapperClass();
        wrapObj.acc = acc;
        wrapObj.contId = con.id;
        wrapObj.oppId = opp.id;
        wrapObj.accountId = acc.id;
        LeadConvert_Controller.convertLeadApex(json.serialize(wrapObj), lead.Id);
        
    }
}