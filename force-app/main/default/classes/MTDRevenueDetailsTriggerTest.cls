@isTest
public class MTDRevenueDetailsTriggerTest {
 @isTest
    public static void runTest(){
        MTD_Revenue_Details__c mtd=new MTD_Revenue_Details__c();
        mtd.Month__c='Oct';
        mtd.Amount__c=10000;
        mtd.Channel__c='TPA';
        Insert mtd;
    }
}