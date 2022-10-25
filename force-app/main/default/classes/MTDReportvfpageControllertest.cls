@isTest
public class MTDReportvfpageControllertest {



 @isTest
    public static void mtdTest(){
        MTD_Revenue_Details__c mtd=new MTD_Revenue_Details__c();
        mtd.Month__c='3';
        mtd.Amount__c=10000;
        mtd.Channel__c='TPA';
        Insert mtd;
        
        Billing_Summary__c bs = new Billing_Summary__c();
    bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'Test1';
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.MTD_Revenue_Details__c=mtd.id;
        bs.alletec_billdate__c=system.today();
        insert bs;
        
        Test.startTest();                
   MTDReportVfpageController mtdd=new MTDReportVfpageController();
       MTDReportVfpageController.PickListWrapp mtddd=new MTDReportVfpageController.PickListWrapp(); 
        MTDReportVfpageController.PickListWrapp.MonthYearPicklist();
        Test.stopTest(); 
        
    }
}