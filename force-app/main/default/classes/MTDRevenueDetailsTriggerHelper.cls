public class MTDRevenueDetailsTriggerHelper {
    
    public static void addRecords(List<MTD_Revenue_Details__c> listMtdRevenueDetails){
        
        String recordtypeId = Schema.SObjectType.MTD_Revenue_Details__c.getRecordTypeInfosByName().get('Budget').getRecordTypeId();
        String achievementRecordtypeId = Schema.SObjectType.MTD_Revenue_Details__c.getRecordTypeInfosByName().get('Achievement').getRecordTypeId();
        String outlookRecordtypeId = Schema.SObjectType.MTD_Revenue_Details__c.getRecordTypeInfosByName().get('Outlook').getRecordTypeId();
        
        List<MTD_Revenue_Details__c> revenueDetailsList = new List<MTD_Revenue_Details__c>();
        
        for(MTD_Revenue_Details__c revenueDetails : listMtdRevenueDetails){
            if(recordtypeId == revenueDetails.RecordTypeId){
                
                MTD_Revenue_Details__c mtdRevenue = new MTD_Revenue_Details__c();
                mtdRevenue.Amount__c = revenueDetails.Amount__c;
                mtdRevenue.Budgets__c= revenueDetails.Budgets__c;
                mtdRevenue.Business_Unit__c= revenueDetails.Business_Unit__c;
                mtdRevenue.Channel__c = revenueDetails.Channel__c;
                mtdRevenue.Month__c = revenueDetails.Month__c;
                mtdRevenue.RecordTypeId = achievementRecordtypeId;
                mtdRevenue.Year__c = revenueDetails.Year__c;
                revenueDetailsList.add(mtdRevenue);
                
                MTD_Revenue_Details__c mtdRevenueDetails = new MTD_Revenue_Details__c();
                mtdRevenueDetails.Amount__c = revenueDetails.Amount__c;
                mtdRevenueDetails.Budgets__c= revenueDetails.Budgets__c;
                mtdRevenueDetails.Business_Unit__c= revenueDetails.Business_Unit__c;
                mtdRevenueDetails.Channel__c = revenueDetails.Channel__c;
                mtdRevenueDetails.Month__c = revenueDetails.Month__c;
                mtdRevenueDetails.RecordTypeId = outlookRecordtypeId;
                mtdRevenueDetails.Year__c = revenueDetails.Year__c;
                revenueDetailsList.add(mtdRevenueDetails);
                
            }
        }
        if(revenueDetailsList.size() > 0){
          /*  try{
                //Insert MTD Revenue Details
                Insert revenueDetailsList;
            }catch(Exception ex){
                System.debug('Exception = '+ex);
            }*/
            Insert revenueDetailsList;
        }
    }
}