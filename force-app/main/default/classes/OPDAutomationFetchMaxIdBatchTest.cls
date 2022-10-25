@isTest
public class OPDAutomationFetchMaxIdBatchTest {
    @testSetup
    static void setup() {
        List<Lead__c> leads = new List<Lead__c>();
        List<Lead__c> leadsErr = new List<Lead__c>();
        Map <String,Schema.RecordTypeInfo> recordTypesadjustment = Lead__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        Id RecTypeIdinadj = recordTypesadjustment.get('OPD automation Lead').getRecordTypeId();
        Id RecTypeIdinadjErr = recordTypesadjustment.get('International Query Management').getRecordTypeId();
        
        Gender__c gen = new Gender__c();
        gen.Name='Male';
        insert gen;
        
        for (Integer i=0;i<10;i++) {
            leads.add(new Lead__c(First_Name__c='test'+i,Last_Name__c='last'+i,Business_Unit__c='Smart SE',Address_Line_1__c='delhi',Mobile_Phone__c='991016897'+i,
                               Gender__c='Male',Email__c='srjatwork1@gmail.com',ZIP_Postal_Code__c='110016', RecordTypeId=RecTypeIdinadj ));
        }
        insert leads;
        
    }
    @isTest static void test() {
        Test.startTest();
        OPDAutomationFetchMaxIdBatch oafmb = new OPDAutomationFetchMaxIdBatch();
        Id batchId = Database.executeBatch(oafmb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from lead__c where ZIP_Postal_Code__c = '110016']);
    }
}