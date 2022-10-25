@isTest
public class UpdateHcfAndCMPLeads_BatchTest {
@isTest
    public static void test1(){
        List<account> accList= new List<account>();
        Account acc= new account();
        acc.LastName='Test Account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        accList.add(acc);
        
        Account acc33=new account();
        acc33.Name='Test1';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        accList.add(acc33);
         insert accList;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.HIS_ID__c='BU1';
        bu.Name = 'test';
        insert bu;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
        adm.RecordTypeId = admRecordTypeId;
        adm.IPID__c = 'al123';
        adm.alletec_hospitallocation__c = bu.Id;
        adm.Max_ID__c = 'Test1';
        adm.Patient__c=accList[0].id;
        insert adm;
        
        List<billing_summary__c> bsList=new list<billing_summary__c>();
        billing_summary__c bs1=new billing_summary__c();
        bs1.alletec_billdate__c=system.today();
        bs1.alletec_isinternational__c=true;
        bs1.hcf_source__c=accList[1].id;
        bs1.Patient__c=accList[0].id;
        bs1.Pre_Intimation_Status__c='Pre';
        bsList.add(bs1);
        //insert bs1;
        
        billing_summary__c bs2=new billing_summary__c();
        bs2.alletec_billdate__c=system.today();
        bs2.alletec_isinternational__c=true;
        bs2.Patient__c=accList[0].id;
        bsList.add(bs2);
        insert bsList;
        test.startTest();
        database.executeBatch(new UpdateHcfAndCMPLeads_Batch());
        
        test.stopTest();
    }
    @isTest
    public static void test2(){
        List<account> accList= new List<account>();
        Account acc= new account();
        acc.LastName='Test Account1';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        accList.add(acc);
        
        Account acc33=new account();
        acc33.Name='Test2';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        accList.add(acc33);
         insert accList;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test1';
        bu.HIS_ID__c='BU2';
        bu.Name = 'test1';
        insert bu;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
        adm.RecordTypeId = admRecordTypeId;
        adm.IPID__c = 'al12';
        adm.alletec_hospitallocation__c = bu.Id;
        adm.Max_ID__c = 'Test';
        adm.Patient__c=accList[0].id;
        adm.HCF_Source__c=accList[1].id;
        adm.Date_Time_of_Admission__c=system.today()-1;
        insert adm;
        
        List<billing_summary__c> bsList=new list<billing_summary__c>();
        billing_summary__c bs1=new billing_summary__c();
        bs1.alletec_billdate__c=system.today();
        bs1.alletec_isinternational__c=true;
        bs1.hcf_source__c=accList[1].id;
       // bs1.Patient__c=accList[0].id;
        bs1.Pre_Intimation_Status__c='Pre';
        bsList.add(bs1);
        //insert bs1;
        
        billing_summary__c bs2=new billing_summary__c();
        bs2.alletec_billdate__c=system.today();
        bs2.alletec_isinternational__c=true;
        bs2.Patient__c=accList[0].id;
        bsList.add(bs2);
        insert bsList;

        test.startTest();
        database.executeBatch(new UpdateHcfAndCMPLeads_Batch());
        
        test.stopTest();
    }
}