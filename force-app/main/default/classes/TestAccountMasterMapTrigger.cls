@isTest(seeAllData = true)
public class TestAccountMasterMapTrigger{

    static testMethod void testAccTrg(){
    
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc.LastName = 'TEst';
        insert acc;
    }

}