@isTest
public class AdmissionAckUpdateTest {
@isTest
    public static void run(){
               Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';        
        at.Business_Unit__c = bu.Id;
        insert at;                
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        insert acc;
        
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account';
        hcf.Account_Territory__c = at.Id;
        insert hcf;
        
          
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        insert acc2;  
        
        List<Admission_Acknowledgement__c> admlist = new List<Admission_Acknowledgement__c>();
        Admission_Acknowledgement__c adm1 = new Admission_Acknowledgement__c();
        adm1.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        adm1.Total_Amount__c = 100;
        adm1.Total_Revenue__c = 100;
        adm1.MECP_Source__c = acc.Id;
        adm1.alletec_speciality__c = dept.Id;
        adm1.Patient__c = acc2.Id;
        adm1.Date_Time_of_Admission__c = System.today()-5;
        adm1.Max_ID__c = 'M124';
        adm1.Channel_Name__c = 'PSU';
        adm1.Procedure__c='Normal';
        adm1.Update_Redemption__c=false;
       // insert adm1;    
        admlist.add(adm1);
        insert admlist;
        
        Datetime yes = Datetime.now().addmonths(-1);
        Test.setCreatedDate(admlist[0].Id, yes);
       //adm1.Update_Redemption__c=true;
        update admlist;
        
        System.debug('-admlist----'+admlist[0].CreatedDate);
        
        //AdmissionAckUpdate admobj = new AdmissionAckUpdate();
        AdmissionAckUpdate.updatePicklist();
    }
}