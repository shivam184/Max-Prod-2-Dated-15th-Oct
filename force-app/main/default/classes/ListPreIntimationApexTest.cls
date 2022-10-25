@isTest
public class ListPreIntimationApexTest {
	
    @isTest
    public static void test1() {
    	Lead__c lead = new Lead__c();
        lead.recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
        lead.Name = 'test';
        insert lead;
        
        test.setCreatedDate(lead.Id, System.now());
        
        ListPreIntimationApex.doInitApex(String.valueOf(System.today()));
    }
}