@suppressWarnings('PMD')
global class LinkBillingSummaryWithCampaignBatch implements database.Batchable<SObject>{
    global database.QueryLocator start(database.BatchableContext bc){
        string query = 'Select id, campaign_code__c,createddate, campaign_code_management__c from billing_summary__c where Campaign_Code__c!=null and campaign_code_management__c=null';
        return database.getQueryLocator(query);
    }

    global void execute(database.BatchableContext bc, List<billing_summary__c> billingList){
        system.debug('billingList '+billingList);
        Set<string> code = new set<string>();
        for (billing_summary__c b : billingList){
            if (b.campaign_code__c != null){
                code.add(b.campaign_code__c);
            }
        }
        system.debug('code '+code);
        Map<String, campaign_code_management__c> campMap = new Map<String, campaign_code_management__c>();
        List<campaign_code_management__c> campList = [select id, campaign_code__c,start_Date__c,end_date__c
                                                      from campaign_code_management__c
                                                      where campaign_code__c in:code];
        for (campaign_code_management__c c : campList){
            campMap.put(c.campaign_code__c, c);
        }
        system.debug('Map '+campMap);
        if (campMap.isEmpty())
            return;
        for (billing_summary__c b : billingList){
            if (campMap.containsKey(b.campaign_code__c) && b.createddate.date()>=campMap.get(b.campaign_code__c).start_date__c && b.createddate.date()<=campMap.get(b.campaign_code__c).end_date__c){
                b.campaign_code_management__c = campMap.get(b.campaign_code__c).id;
            }
        }
        update billingList;
    }

    global void finish(database.BatchableContext bc){
    }

}