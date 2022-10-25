trigger MTDRevenueDetailsTrigger on MTD_Revenue_Details__c (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        MTDRevenueDetailsTriggerHelper.addRecords(trigger.new);
    }
}