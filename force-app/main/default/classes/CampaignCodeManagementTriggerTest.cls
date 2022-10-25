@isTest
public class CampaignCodeManagementTriggerTest {
    @isTest
     public static void runTest2(){
        TriggerExecutions__c trex = new TriggerExecutions__c();        
        trex.Campaign_Code_Trigger__c= true;
        trex.Name = 'test';
        insert trex;
         
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'SKT';
        bu.HIS_ID__c='7';
        bu.Name = 'test';
        insert bu;
        
        Campaign_Code_Management__c ccm=new Campaign_Code_Management__c();
        ccm.Business_Unit__c=bu.id;
        ccm.Campaign_Channel__c='EWS';
        insert ccm;
        
        CampaignCodeManagementTriggerHelper.CampaignCodeGenerate(new List<Campaign_Code_Management__c>{ccm});
    }
}