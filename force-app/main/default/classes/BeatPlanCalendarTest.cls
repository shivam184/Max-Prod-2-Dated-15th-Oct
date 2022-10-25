@isTest
public class BeatPlanCalendarTest {
    
    @isTest
    public static void Test(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        Account_Territory__c act = new Account_Territory__c();
        act.Name='terte';
        insert act;
        
        Account acc = new Account();
        acc.Name ='test';
        acc.Account_Territory__c=act.Id;
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        insert acc;
        
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        con.LastName = 'ABC Contact';
        insert con;
        
        
        Department__c dept=new Department__c();
        dept.Name='test';
        insert dept;
        
        Speciality__c spec = new Speciality__c();
        spec.Name='spectest';
        spec.alletec_department__c=dept.Id;
        spec.alletec_startdatetime__c=System.now();
        insert spec;
        
        Beat_Plan__c bplan = new Beat_Plan__c();
        bplan.Name='TEST NAME';
        bplan.Agent__c = UserInfo.getUserId();
        bplan.Month__c ='January';
        bplan.Year__c = '2019';
        insert bplan;
        
        Beat_Plan_Detail__c bdetail = new Beat_Plan_Detail__c();
		bdetail.Account__c  = acc.Id;
		bdetail.Beat_Plan__c =   bplan.Id;
        bdetail.Expected_Date_of_Visit__c = system.today();
        bdetail.Status__c ='Scheduled';
        insert bdetail;
        
        BeatPlanCalendar Beat = new BeatPlanCalendar();
        beat.meeting = acc.Id+'@'+string.valueOf(system.today())+',';
        beat.callSaveApex();
   
    }
 
    
    @isTest
    public static void Test2(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];        
        Account_Territory__c act = new Account_Territory__c();
        act.Name='terte';
        insert act;
        
        Account acc = new Account();
        acc.Name ='test';
        acc.Account_Territory__c=act.Id;
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        insert acc;
        
        Contact con = new Contact();
        con.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        con.LastName = 'ABC Contact';
        insert con;
        
        Department__c dept=new Department__c();
        dept.Name='test';
        insert dept;
        
        Speciality__c spec = new Speciality__c();
        spec.Name='spectest';
        spec.alletec_department__c=dept.Id;
        spec.alletec_startdatetime__c=System.now();
        insert spec;
        
        Beat_Plan__c bplan = new Beat_Plan__c();
        bplan.Name='TEST NAME';
        bplan.Agent__c = UserInfo.getUserId();
        bplan.Month__c ='January';
        bplan.Year__c = '2019';
        insert bplan;
        
        Beat_Plan_Detail__c bdetail = new Beat_Plan_Detail__c();
		bdetail.Contact__c  = con.Id;
		bdetail.Beat_Plan__c =   bplan.Id;
        bdetail.Expected_Date_of_Visit__c = system.today();
        bdetail.Status__c ='Scheduled';
        insert bdetail;
        
        BeatPlanCalendar Beat = new BeatPlanCalendar();
        Beat.checkContact = true;
        beat.meeting = con.Id+'@'+string.valueOf(system.today())+',';
        Beat.maxLabsinit();
        beat.callSaveApex();
        BeatPlanCalendar.toggleErrorFlag();
        BeatPlanCalendar.toggleSuccessFlag();

    }

}