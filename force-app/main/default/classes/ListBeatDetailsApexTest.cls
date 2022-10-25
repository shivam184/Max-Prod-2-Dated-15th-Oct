@isTest
public class ListBeatDetailsApexTest {

    @isTest
    public static void test1() {
        Beat_Plan__c beatPlan = new Beat_Plan__c();
        beatPlan.Agent__c = UserInfo.getUserId();
        beatPlan.Month__c = 'March';
        beatPlan.Year__c = '2019';
        beatPlan.Status__c = 'Scheduled';
        insert beatPlan;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'test';
        insert acc;
        
        Beat_Plan_Detail__c bpd = new Beat_Plan_Detail__c();
        bpd.Account__c = acc.Id;
        bpd.Beat_Plan__c = beatPlan.id;
        bpd.Status__c = 'Scheduled';
        bpd.Expected_Date_of_Visit__c = System.today();
        insert bpd;
        
        ListBeatDetailsApex.doInitApex(System.today());
        Date dt;
        ListBeatDetailsApex.doInitApex(dt);
        
        
    }
}