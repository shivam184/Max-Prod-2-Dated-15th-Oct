@isTest
public class MTDRevenueCalculationBatchTest {
 @isTest
    public static void mtdTest(){
        MTD_Revenue_Details__c mtd=new MTD_Revenue_Details__c();
        mtd.Month__c='10';
        mtd.Amount__c=10000;
        mtd.Channel__c='TPA';
        Insert mtd;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.HIS_ID__c='BU1';
        bu.Name = 'test';
        insert bu;
        
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        acc2.Gender__c='Male';
        acc2.FirstName='test';
        //acc2.Salutation='Mr';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        insert acc2;  

        
        Admission_Acknowledgement__c adm2 = new Admission_Acknowledgement__c();
        adm2.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm2.Total_Amount__c = 100;
        adm2.Total_Revenue__c = 100;
        adm2.Patient__c = acc2.Id;
        adm2.Date_Time_of_Admission__c = System.today()-10;
        adm2.Max_ID__c = 'M124';
        adm2.Procedure__c='Normal';
        adm2.Channel_Name__c ='Cash';
        adm2.Is_Patient_Transfer__c='Admitted';
        insert adm2;    
        
        
        
        
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
        bs.alletec_billdate__c=system.today().addDays(-1);
        bs.R_Channel__c='PSU';
        bs.alletec_isbillcancelled__c=false;
        bs.Admission_Acknowledgement__c=adm2.id;
        bs.Hospital_Location__c='Max Patparganj';
        insert bs;
        

        MTD_Revenue_Details__c mt=new MTD_Revenue_Details__c();
        mt.RecordTypeId = Schema.SObjectType.MTD_Revenue_Details__c.getRecordTypeInfosByName().get('Achievement').getRecordTypeId();
        mt.Month__c='6';
        mt.Amount__c=10000;
        mt.Channel__c='TPA';
        mt.Business_Unit__c=bu.id;
        Insert mt;
        
        Test.startTest();                
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new MTDRevenueCalculationBatchSche());
        
        Database.executeBatch(new MTDRevenueCalculationBatch());
        Test.stopTest(); 
        
    }
}