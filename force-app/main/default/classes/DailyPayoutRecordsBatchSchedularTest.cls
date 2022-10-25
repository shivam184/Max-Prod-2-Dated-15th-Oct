@isTest
public class DailyPayoutRecordsBatchSchedularTest {
    @isTest
    public static void runTest(){
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='Test1';
        insert acc2;
        
        
        String patRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId(); 
        Account acc3 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc3.RecordTypeId = patRecordTypeId;
        acc3.Name = 'Patient Account';     
        acc3.Max_ID__c ='Test1';
        
        insert acc3;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
            adm.RecordTypeId = admRecordTypeId;
        insert adm;
        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'Test1';
        bs.alletec_transactiontype__c='IP';
        bs.Patient__c = acc2.Id;
        bs.Admission_Acknowledgement__c = adm.Id;        
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.alletec_ipid__c='al123';
        bs.alletec_isinternational__c=true;
        bs.alletec_isbillcancelled__c = false;
        bs.alletec_transactiontype__c='OP';
        bs.HCF_Source__c=acc3.id;
        insert bs;
        
        Slab_Master__c slab=new Slab_Master__c();
        slab.Name='test';
        slab.HCF_Source__c=acc3.id;
        slab.Validity__c=system.today().addDays(-1);
        slab.Minimum_Range__c=12;
        slab.Maximum_Range__c=15;
        insert slab;
        
        Payout__c pay=new Payout__c();
        pay.Patient__c=acc2.id;
        pay.alletec_hisamount__c=14;
        pay.Slab_Master__c=slab.id;
        pay.Payout_Percentage__c='15';
        insert pay;
        
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(bs.Id, yesterday);  
        
        
        Test.startTest();    
        Billing_Summary__c testAcc = [SELECT Id, Name, CreatedDate FROM Billing_Summary__c WHERE Id =:bs.id];  
        System.assertEquals(testAcc.CreatedDate, yesterday);  
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new DailyPayoutRecordsBatchSchedular());
        test.stopTest();
       
    }
    @isTest
    public static void runTest1(){
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='Test1';
        insert acc2;
        
        
        String patRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId(); 
        Account acc3 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc3.RecordTypeId = patRecordTypeId;
        acc3.Name = 'Patient Account';     
        acc3.Max_ID__c ='Test1';
        
        insert acc3;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
            adm.RecordTypeId = admRecordTypeId;
        insert adm;
        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'Test1';
        bs.alletec_transactiontype__c='IP';
        bs.Patient__c = acc2.Id;
        bs.Admission_Acknowledgement__c = adm.Id;        
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.alletec_ipid__c='al123';
        bs.alletec_isinternational__c=true;
        bs.alletec_isbillcancelled__c = false;
        bs.alletec_transactiontype__c='OP';
        bs.HCF_Source__c=acc3.id;
        insert bs;
        
        Slab_Master__c slab=new Slab_Master__c();
        slab.Name='test';
        slab.HCF_Source__c=acc3.id;
        slab.Validity__c=system.today().addDays(-1);
        slab.Minimum_Range__c=NULL;
        slab.Maximum_Range__c=NULL;
        insert slab;
        
        Payout__c pay=new Payout__c();
        pay.Patient__c=acc2.id;
        pay.alletec_hisamount__c=13;
        pay.alletec_hisamount__c=14;
        pay.Payout_Percentage__c='15';

        insert pay;
        
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(bs.Id, yesterday);  
        
        
        Test.startTest();    
        Billing_Summary__c testAcc = [SELECT Id, Name, CreatedDate FROM Billing_Summary__c WHERE Id =:bs.id];  
        System.assertEquals(testAcc.CreatedDate, yesterday);  
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new DailyPayoutRecordsBatchSchedular());
        Test.stopTest(); 
    }
    
    @isTest
    public static void runTest2(){
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='Test1';
        insert acc2;
        
        
        String patRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId(); 
        Account acc3 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc3.RecordTypeId = patRecordTypeId;
        acc3.Name = 'Patient Account';     
        acc3.Max_ID__c ='Test1';
        
        insert acc3;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
            adm.RecordTypeId = admRecordTypeId;
        insert adm;
        
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.billto_country__c = '149';
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'Test1';
        bs.alletec_transactiontype__c='IP';
        bs.Patient__c = acc2.Id;
        bs.Admission_Acknowledgement__c = adm.Id;        
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.alletec_ipid__c='al123';
        bs.alletec_isinternational__c=true;
        bs.alletec_isbillcancelled__c = false;
        bs.alletec_transactiontype__c='OP';
        bs.HCF_Source__c=acc3.id;
        insert bs;
        
        Slab_Master__c slab=new Slab_Master__c();
        slab.Name='test';
        slab.HCF_Source__c=acc3.id;
        slab.Validity__c=system.today().addDays(-1);
        slab.Minimum_Range__c=NULL;
        slab.Maximum_Range__c=15;
        insert slab;
        
        Payout__c pay=new Payout__c();
        pay.Patient__c=acc2.id;
        pay.alletec_hisamount__c=14;
        pay.Payout_Percentage__c='15';

        insert pay;
        
        
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(bs.Id, yesterday);  
        
        
        Test.startTest();    
        Billing_Summary__c testAcc = [SELECT Id, Name, CreatedDate FROM Billing_Summary__c WHERE Id =:bs.id];  
        System.assertEquals(testAcc.CreatedDate, yesterday);  
        String CRONEXP = '0 0 0 3 9 ? 2022';
        system.schedule('Test Territory Check', CRONEXP,new DailyPayoutRecordsBatchSchedular());
        Test.stopTest(); 
    }
    
}