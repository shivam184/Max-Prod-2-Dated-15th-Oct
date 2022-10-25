@suppressWarnings('PMD')
@isTest
public with sharing class LinkBillingSummaryWithCampaignBatchTest {
    @isTest
    public static void test1(){

        business_unit__c bu=new business_unit__c();
        bu.name='BLK Max';
        insert bu;
        
        campaign_code_management__c camp=new campaign_code_management__c();
        camp.campaign_code__c='BLK00123';
        camp.business_unit__c=bu.id;
        camp.campaign_channel__c='PSU';
        insert camp;
        
        billing_summary__c b =new billing_summary__c();
        b.campaign_code__c='BLK00123';
        b.name__c='max.123';
        b.alletec_billdate__c=system.today();
        insert b;
        
        test.startTest();
        database.executeBatch(new LinkBillingSummaryWithCampaignBatch());
        test.stopTest();
    }
}