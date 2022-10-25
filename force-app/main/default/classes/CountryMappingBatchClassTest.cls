@isTest
public class CountryMappingBatchClassTest {
    
    @isTest
    static void test1(){       
        
        Nationality__c nationality = new Nationality__c();
        nationality.HIS_ID__c = '13';
        nationality.Name = 'Test Country';
        insert nationality;
        
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(recTypeId != NULL){
            Account acc = new Account();
            acc.RecordTypeId = recTypeId;
            acc.LastName = 'Test Account';
            acc.address2_country__c = '13';
            insert acc;                        
        }            
        
        Test.startTest();
        CountryMappingBatchClass obj = new CountryMappingBatchClass();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}