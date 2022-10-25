@IsTest
public class TestSFrelationshipID{
    @isTest
    public static void method1(){
        TriggerExecutions__c triggercheck = TriggerExecutions__c.getOrgDefaults();
        triggercheck.name ='test';
        triggercheck.leadcheckbox__c=true;
        insert triggercheck;
         Id devRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        CMP_Relationship_SF_ID__c mySettings = CMP_Relationship_SF_ID__c.getOrgDefaults();
        mySettings.name='abc';
        mySettings.AutoNumber__c=1000;
        insert mySettings;
            
        Double myAutoNum = mySettings.AutoNumber__c;
        lead__c ld = new lead__c();
        ld.name='test lead';
        ld.recordtypeid=devRecordTypeId;
        ld.Primary_Member__c=true;
        insert ld;
        
        lead__c ld2 = new lead__c();
        ld2.name='test lead2';
        ld2.recordtypeid=devRecordTypeId;
        ld2.Primary_Member__c=false;
        ld2.Family_Member__c=ld.id;
        insert ld2;
        
       
        

    }

}