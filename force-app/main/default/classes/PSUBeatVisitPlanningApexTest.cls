@istest
public class PSUBeatVisitPlanningApexTest {
    Public static testmethod void mytest(){
       List<Account> accList= new List<Account>();
        Speciality__c spc = new Speciality__c();
        spc.name = 'test';
        insert spc;
        
        PSU_Corporate_Territory__c act = new PSU_Corporate_Territory__c();
        act.name = 'test';
        insert act;
       
        Account acc = new Account ();
        acc.Name='TestName';
        acc.SF_Speciality__c = spc.Id;
        acc.PSU_Corporate_Territory__c =act.Id;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Corporate PSU').getRecordTypeId();
        accList.add(acc);
        insert accList;
        
        List<Contact> conList = new List<Contact>();
        contact con = new contact();
        con.LastName='test1';
        con.Specialty__c = spc.Id;              
        con.Contact_Territory__c=acc.Account_Territory__c;
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();       
        conList.add(con);
        insert conList;
        //string accJson='{"listAccount":[{"isSelected":true,"acc":"'+acc+'"}]}';
        PSUBeatVisitPlanningApex.getDataFromApex();
        
        PSUBeatVisitPlanningApex.doSearchApex(true,false,true,true,spc.Id,'test',act.Id);
        
        List<PSUBeatVisitPlanningApex.AccountWrapperClass> listAccount = new List<PSUBeatVisitPlanningApex.AccountWrapperClass>();
        PSUBeatVisitPlanningApex.AccountWrapperClass accwrap = new PSUBeatVisitPlanningApex.AccountWrapperClass(acc);
        accwrap.isSelected = true;
        listAccount.add(accwrap);
        List<PSUBeatVisitPlanningApex.ContactWrapperClass> listContact = new List<PSUBeatVisitPlanningApex.ContactWrapperClass>();
        PSUBeatVisitPlanningApex.ContactWrapperClass conwrap = new PSUBeatVisitPlanningApex.ContactWrapperClass(con);
        conwrap.isSelected = true;
        listContact.add(conwrap);
        PSUBeatVisitPlanningApex.createBeatDetailsApex(JSON.serialize(listAccount),system.today(),JSON.serialize(listContact));
        
        //BeatVisitPlanningApex.createBeatDetailsApex(accJson, system.today(), con.Id);
        
    }
}