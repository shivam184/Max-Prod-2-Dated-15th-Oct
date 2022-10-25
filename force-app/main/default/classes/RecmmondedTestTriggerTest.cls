@isTest
public class RecmmondedTestTriggerTest {
    @isTest
    public static void runRecTest(){
        Lead__c ld=new Lead__c();
        ld.Name='test';
        insert ld;
        
        Recommended_Test__c rct=new Recommended_Test__c();
        rct.Leads__c=ld.id;
        rct.Test_MRP__c=500;
        insert rct;
    }
}