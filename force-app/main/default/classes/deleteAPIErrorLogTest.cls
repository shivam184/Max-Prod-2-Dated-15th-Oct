@isTest
public class deleteAPIErrorLogTest {
@isTest
    public static void test1(){
        
        API_Error_Log__c api= new API_Error_Log__c();
        api.API_Name__c='Billing-summary';
        api.Error_MAXID__c='MAX.123';
        insert api;
        test.startTest();
        database.executeBatch(new DeleteAPIErrorLog());
        test.stopTest();
    }
}