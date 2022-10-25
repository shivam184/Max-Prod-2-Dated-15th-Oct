@istest
public class BeatVisitPlanningApexTest {
    Public static testmethod void mytest(){
       List<Account> accList= new List<Account>();
        Speciality__c spc = new Speciality__c();
        spc.name = 'test';
        insert spc;
        
        Account_Territory__c act = new Account_Territory__c();
        act.name = 'test';
        insert act;
       
        Account acc = new Account ();
        acc.Name='TestName';
        acc.SF_Speciality__c = spc.Id;
        acc.Account_Territory__c =act.Id;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
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
        BeatVisitPlanningApex.getDataFromApex();
        
        BeatVisitPlanningApex.doSearchApex(true,true,spc.Id,'test',act.Id);
        
        List<BeatVisitPlanningApex.AccountWrapperClass> listAccount = new List<BeatVisitPlanningApex.AccountWrapperClass>();
        BeatVisitPlanningApex.AccountWrapperClass accwrap = new BeatVisitPlanningApex.AccountWrapperClass(acc);
        accwrap.isSelected = true;
        listAccount.add(accwrap);
        List<BeatVisitPlanningApex.ContactWrapperClass> listContact = new List<BeatVisitPlanningApex.ContactWrapperClass>();
        BeatVisitPlanningApex.ContactWrapperClass conwrap = new BeatVisitPlanningApex.ContactWrapperClass(con);
        conwrap.isSelected = true;
        listContact.add(conwrap);
        BeatVisitPlanningApex.createBeatDetailsApex(JSON.serialize(listAccount),system.today(),JSON.serialize(listContact));
        
        //BeatVisitPlanningApex.createBeatDetailsApex(accJson, system.today(), con.Id);
        
    }
}