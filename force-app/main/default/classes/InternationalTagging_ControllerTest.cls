/*last modified by:Nitya
 * */
@isTest
public class InternationalTagging_ControllerTest {
    @isTest
    public static void runTest(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(1);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
        InternationalTagging_Controller.fetchLead('abc',null,null);
        InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    
    @isTest
    public static void runTest1(){
        
        
        Account acc3=new account();
        acc3.Name='Test1';
        
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc3;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        Account acc1=new account();
        //acc1.FirstName='Test1';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(10);
        insert acc1;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Description__c='abc';
        ld.Lead_Source__c='Email';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-10;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        //bs.name__c='karu';
        bs.name__c='25';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=acc1.Id;
       // bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=false;
       // bs.alletec_billdate__c=null;
        bs.alletec_dateofadmission__c=system.today()-1;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=acc.id;
        ack.Patient__c= acc1.id;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
        // ack.HCF_Source__c=acc3.id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=false;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
         Billing_Summary__c bs1=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs1.name__c='max.123';
        bs1.SMS_Tagged__c=false;
        bs1.alletec_isinternational__c=true;
        bs1.alletec_ipid__c='1234';
        bs1.alletec_transactiontype__c='OP';
        bs1.alletec_preadmitno__c=88999;
        bs1.Patient__c=acc1.Id;
       // bs1.alletec_billdate__c=system.now();
        bs1.Tagging_Availability__c=false;
        bs1.alletec_dateofadmission__c=system.today();
        bs1.Remark__c='90';
        bs1.HCF_Source__c=acc3.id;
        insert bs1;
        
        Admission_Acknowledgement__c ack4=new Admission_Acknowledgement__c();
        ack4.Max_ID__c='max.123';
        ack4.OPID__c='blah';
        ack4.IPID__c='1234';
        ack4.Patient_Name__c='shiv';
        ack4.Doctor_Name__c='prashant';
        ack4.Last_OPD_Speciality__c=s.Id;
        ack4.Doctor__c=acc.id;
        ack4.Patient__c=acc1.id;
        ack4.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack4.Channel_Name__c='International';
        ack4.Date_Time_of_Admission__c=system.now().addDays(2);
        ack4.Is_Tagged_By_International_Hidden__c=true;
        ack4.pcl_markuptype__c='bhj';
      //  ack4.Date_of_Discharge__c=system.today();
        ack4.SMS_Tagged__c=false;
        ack4.Tagging_Availability__c=false;
        ack4.Pre_Intimation_Status__c='Pre';
        ack4.HCF_Source__c=acc3.id;
        insert ack4;
        
        test.startTest();
        InternationalTagging_Controller.fetchLead('abc',System.today(),System.today()+2);
        InternationalTagging_Controller.doSearchAckOpApex('shiv','1234','max.123',true);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
        
        InternationalTagging_Controller.TagWithOutSMSApex(ack4.Id,ack4.HCF_Source__c,'90');
        InternationalTagging_Controller.directTagging(ack.Id,ld.Id);
      // InternationalTagging_Controller.directTagging(bs.Id,ld.Id);
        InternationalTagging_Controller.doGetMecpDoctor('xyz');
        test.stopTest();        
        
    }
    @isTest
 
    public static void runTest2(){
        
        
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc3;
        
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        insert acc;
        
        Account acc1=new account();
       // acc1.FirstName='Test1';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(1);
        insert acc1;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Description__c='abc';
        ld.Lead_Source__c='Email';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today();
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
        //bs.Name__c='blah';
        bs.name__c='25';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=acc1.Id;
       // bs.alletec_billdate__c=system.now();
        bs.alletec_billdate__c=system.today().addDays(1);
        bs.Tagging_Availability__c=false;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=acc.id;
        ack.Patient__c= acc1.id;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
        // ack.HCF_Source__c=acc3.id;
        ack.pcl_markuptype__c='bhj';
        ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=false;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        Admission_Acknowledgement__c ack4=new Admission_Acknowledgement__c();
        ack4.Max_ID__c='max.123';
        ack4.OPID__c='blah';
        ack4.IPID__c='1234';
        ack4.Patient_Name__c='shiv';
        ack4.Doctor_Name__c='prashant';
        ack4.Last_OPD_Speciality__c=s.Id;
        ack4.Doctor__c=acc.id;
        ack4.Patient__c=acc1.id;
        ack4.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack4.Channel_Name__c='International';
        ack4.Date_Time_of_Admission__c=system.now().addDays(2);
        ack4.Is_Tagged_By_International_Hidden__c=true;
        ack4.pcl_markuptype__c='bhj';
       ack4.Date_of_Discharge__c=system.today();
        ack4.SMS_Tagged__c=false;
        ack4.Tagging_Availability__c=false;
        ack4.Pre_Intimation_Status__c='Pre';
        ack4.HCF_Source__c=acc3.id;
        insert ack4;
         Billing_Summary__c bs1=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs1.name__c='max.123';
        bs1.SMS_Tagged__c=false;
        bs1.alletec_isinternational__c=true;
        bs1.alletec_ipid__c='1234';
        bs1.alletec_transactiontype__c='OP';
        bs1.alletec_preadmitno__c=88999;
        bs1.Patient__c=acc1.Id;
        bs1.alletec_billdate__c=system.now();
        bs1.Tagging_Availability__c=false;
       // bs1.alletec_dateofadmission__c=system.today();
        bs1.Remark__c='90';
        bs1.HCF_Source__c=acc3.id;
        insert bs1;
        
        test.startTest();
        InternationalTagging_Controller.fetchLead('abc',System.today(),System.today()+2);
        InternationalTagging_Controller.doSearchAckOpApex('shiv','1234','max.123',true);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, bs.id,ack.HCF_Source__c);
        InternationalTagging_Controller.getTaggedApex();
        InternationalTagging_Controller.TagWithOutSMSApex(bs1.Id,bs1.HCF_Source__c,'90');
        InternationalTagging_Controller.directTagging(bs1.Id,ld.Id);
        /*InternationalTagging_Controller.getTaggedApex();
        InternationalTagging_Controller.TagWithOutSMSApex(ack.Id,ack.HCF_Source__c,'90');
        InternationalTagging_Controller.directTagging(ack.Id,ld.Id);
        InternationalTagging_Controller.directTagging(bs2.Id,ld.Id);
        InternationalTagging_Controller.doGetMecpDoctor('xyz');*/
        test.stopTest();   
    }
    @isTest
    public static void runTest3(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-70);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
        InternationalTagging_Controller.getTaggedApex();
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    @isTest
    public static void runTest4(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-90);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    @isTest
    public static void runTest5(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-70);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, bs.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
@isTest
    public static void runTest6(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-190);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, bs.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    
    @isTest
    public static void runTest7(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-70);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now()-90;
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, bs.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
@isTest
    public static void runTest8(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now().addDays(-190);
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today()-1;
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    @isTest
    public static void runTest9(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now()-95;
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today();
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, ack.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
    @isTest
    public static void runTest10(){
        List<account> accList=new List<account>();
        Account acc3=new account();
        acc3.Name='Test1';
        acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        //insert acc3;
        accList.add(acc3);
        Account acc=new account();
        acc.FirstName='Test1';
        acc.LastName='mr blag';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        //insert acc;
        accList.add(acc);
        Account acc1=new account();
       // acc1.FirstName='Shiv';
        acc1.LastName='Shiv';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc1.alletec_patientregisterationdate__c=system.now()-95;
        //insert acc1;
        accList.add(acc1);
        insert accList;
        
        Speciality__c s=new Speciality__c();
        s.name='ghoul';
        insert s;
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
        lead__c ld=new lead__c();
        ld.recordtypeId=RecordTypeId;
        ld.Name='test';
        ld.Lead_Channel__c='International';
        ld.Lead_Source__c='Email';
        ld.Description__c='abc';
        //ld.VIL_Detail__c=inv.id;
        ld.Intlr_Intimation_Date__c = System.today();
        ld.Intlr_Intimation_Time__c = System.now().time();
        insert ld;
        
        Billing_Summary__c bs=new Billing_Summary__c();
       // bs.Name__c='blah';
        bs.name__c='karu';
        bs.SMS_Tagged__c=false;
        bs.alletec_isinternational__c=true;
        bs.alletec_transactiontype__c='OP';
        bs.alletec_preadmitno__c=88999;
        bs.Patient__c=accList[2].Id;
        bs.alletec_billdate__c=system.now();
        bs.Tagging_Availability__c=true;
        bs.Remark__c='90';
        insert bs;
        
        Admission_Acknowledgement__c ack=new Admission_Acknowledgement__c();
        ack.Max_ID__c='25';
        ack.OPID__c='blah';
        ack.IPID__c='xyz';
        ack.Patient_Name__c='shiv';
        ack.Doctor_Name__c='prashant';
        ack.Last_OPD_Speciality__c=s.Id;
        ack.Doctor__c=accList[1].id;
        ack.Patient__c= bs.Patient__c;
        ack.RecordTypeId =  Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        ack.Channel_Name__c='International';
        ack.Date_Time_of_Admission__c=system.now().addDays(5);
        ack.Is_Tagged_By_International_Hidden__c=true;
       // ack.HCF_Source__c=accList[0].id;
        ack.pcl_markuptype__c='bhj';
       // ack.Date_of_Discharge__c=system.today();
        ack.SMS_Tagged__c=true;
        ack.Tagging_Availability__c=true;
        ack.Pre_Intimation_Status__c='Pre';
        ack.Tagged_On__c=system.today();
        ack.Is_Emergency__c=true;
        ack.International_Status__c='Pre-Intimations';
        insert ack;
        
        test.startTest();   
       // InternationalTagging_Controller.fetchLead('abc',null,null);
       // InternationalTagging_Controller.doSearchAckOpApex('shiv','','',false);
        InternationalTagging_Controller.doTagWithSMSApex(ld.Id, bs.id,ack.HCF_Source__c);
       // accList[2].alletec_patientregisterationdate__c=system.now().addDays(-2);
        
        test.stopTest();
    }
}