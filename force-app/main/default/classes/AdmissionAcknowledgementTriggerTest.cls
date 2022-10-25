@isTest
public class AdmissionAcknowledgementTriggerTest {
    @isTest static void test1(){
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Admission_Acknowledgement__c = true;
        trex.Name = 'test';
        insert trex;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';        
        at.Business_Unit__c = bu.Id;
        insert at;                
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        List<account> accList=new List<account>();
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        accList.add(acc);
        
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account';
        hcf.Account_Territory__c = at.Id;
        accList.add(hcf);
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        accList.add(doctor);
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        acc2.Gender__c='Male';
        acc2.FirstName='test';
        acc2.Salutation='Mr';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        accList.add(acc2); 
        insert accList;
        
         Admission_Acknowledgement__c adm1 = new Admission_Acknowledgement__c();
        adm1.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm1.Patient__c = accList[3].Id;
        adm1.Date_Time_of_Admission__c = System.today()-3;
        adm1.Max_ID__c = 'M12456';
        adm1.alletec_international__c=true;
        adm1.HCF_Source__c=accList[1].id;
       insert adm1;
        
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        Visa_Invite__c inv = new Visa_Invite__c();
        inv.Hospital_Location__c = bu.Id;
        inv.Passport_number__c = '12548567';
        inv.HCF_Partner_name__c = accList[1].Id;
        inv.Country__c = add.id;
        inv.Customer_Patient_Name__c = 'test1';
        inv.Doctor_Name__c=accList[2].Id;
        inv.Visa_Invite_Number__c = '2020/Mar/693753/v1.123';
        inv.Ailment__c = 'test1';
        inv.Stage__c='New';
        inv.Patient__c=accList[3].id;
        inv.Max_Id__c='M1245';
        inv.Gender__c='Female';
        inv.Sub_HCF_Name__c='Sub-Hcf';
        inv.HCF_Mobile_No__c='123456789';
        inv.Recipient_Email__c='nitya.k@dummy.com';
        inv.Recipient_City__c='Noida';
        inv.Type_of_Visa__c='Patient';
        
        insert inv;
        
        International_OP_Patient_Journey__c ipoj1=new International_OP_Patient_Journey__c();
        ipoj1.Stage__c='New';
        Ipoj1.First_OP_Bill_Date__c=system.today()-3;
        insert ipoj1;
        
        Prospect__c pros1 = new Prospect__c();
        pros1.Max_Id__c = 'M1245';
        pros1.Stage__c = 'Admission Advised';
        pros1.International_OP_Patient_Journey__c=ipoj1.id;
        pros1.RecordTypeId=Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
        insert pros1;
        
        test.startTest();
        
        // List<Admission_Acknowledgement__c> admList=new list<Admission_Acknowledgement__c>();
        
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        adm.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm.Total_Amount__c = 100;
        adm.Total_Revenue__c = 100;
        adm.MECP_Source__c = accList[0].Id;
        adm.alletec_speciality__c = dept.Id;
        adm.Patient__c = accList[3].Id;
        adm.Date_Time_of_Admission__c = System.today()-1;
        adm.Max_ID__c = 'M1245';
        adm.Channel_Name__c = 'PSU';
        adm.alletec_international__c=true;
        adm.Visa_Invite__c=inv.id;
        //adm.Procedure__c='Normal';
        adm.Related_Prospect__c=pros1.id;
        adm.HCF_Source__c = accList[1].Id;
        adm.WardNo__c='2';
        adm.Patient_Name__c='Nitya';
        adm.IPID__c='1234';
        adm.Doctor__c=accList[2].id;
        adm.Contact_Person_Name__c='Nitya';
        adm.Contact_Person_MobileNo__c='123456679';
        adm.BedNo__c='123';
        adm.alletec_hospitallocation__c=bu.id;
        adm.HCF_Source__c=accList[1].id;
        //AvoidRecursion.firstRun=true;
        insert adm;   

        billing_summary__c bs=new Billing_summary__c();
        bs.alletec_billdate__c=system.today();
        bs.alletec_isinternational__c=true;
        bs.Admission_Acknowledgement__c=adm.id;
        bs.Patient__c=accList[3].id;
        bs.HCF_Source__c=accList[1].id;
        insert bs;
        
        Lead__c ld=new Lead__c();
        ld.Name='Test';
        ld.Admission_Acknowledgement__c=adm.id;
        ld.BedNo__c='23';
        ld.Contact_Person_MobileNo__c='9988776655';
        ld.Contact_Person_Name__c='test';
        ld.IPID__c='999999';
        ld.Patient_Name__c='test';
        ld.WardNo__c='55';
        Insert ld;
        
        //adm.Procedure__c='Key';
        adm.alletec_international__c=true;
        update adm;
    }
   @isTest static void test2(){
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Admission_Acknowledgement__c = true;
        trex.Name = 'test';
        insert trex;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';        
        at.Business_Unit__c = bu.Id;
        insert at;                
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        List<account> accList=new List<account>();
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        accList.add(acc);
        
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account';
        hcf.Account_Territory__c = at.Id;
        accList.add(hcf);
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        accList.add(doctor);
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        acc2.Gender__c='Male';
        acc2.FirstName='test';
        acc2.Salutation='Mr';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        //acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        accList.add(acc2); 
        insert accList;
        
         Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        adm.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm.Patient__c = accList[3].Id;
        adm.Date_Time_of_Admission__c = System.today()-3;
        adm.Max_ID__c = 'M12456';
        adm.alletec_international__c=true;
        adm.HCF_Source__c=accList[1].id;
       insert adm;
       
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        Visa_Invite__c inv = new Visa_Invite__c();
        inv.Hospital_Location__c = bu.Id;
        inv.Passport_number__c = '12548567';
        inv.HCF_Partner_name__c = accList[1].Id;
        inv.Country__c = add.id;
        inv.Customer_Patient_Name__c = 'test1';
        inv.Doctor_Name__c=accList[2].Id;
        inv.Visa_Invite_Number__c = '2020/Mar/693753/v1.123';
        inv.Ailment__c = 'test1';
        inv.Stage__c='New';
        inv.Patient__c=accList[3].id;
        inv.Max_Id__c='M12456';
        inv.Gender__c='Female';
        inv.Sub_HCF_Name__c='Sub-Hcf';
        inv.HCF_Mobile_No__c='123456789';
        inv.Recipient_Email__c='nitya.k@dummy.com';
        inv.Recipient_City__c='Noida';
        inv.Type_of_Visa__c='Patient';
        
        insert inv;
        
        International_OP_Patient_Journey__c ipoj1=new International_OP_Patient_Journey__c();
        ipoj1.Stage__c='New';
        Ipoj1.First_OP_Bill_Date__c=system.today()-3;
        insert ipoj1;
        
        Prospect__c pros1 = new Prospect__c();
        pros1.Max_Id__c = 'M12456';
        pros1.Stage__c = 'Admission Advised';
        pros1.RecordTypeId=Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
        pros1.International_OP_Patient_Journey__c=ipoj1.id;
        insert pros1;
        
        Lead__c ld1=new Lead__c();
        ld1.name='Test1';
        ld1.RecordtypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        ld1.Max_ID__c='M12456';
       ld1.Relationship__c='Mother';
        insert ld1;
       
        test.startTest();
        Admission_Acknowledgement__c adm1 = new Admission_Acknowledgement__c();
        adm1.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm1.Total_Amount__c = 100;
        adm1.Total_Revenue__c = 100;
        adm1.MECP_Source__c = accList[0].Id;
        adm1.alletec_speciality__c = dept.Id;
        adm1.Patient__c = accList[3].Id;
        adm1.Date_Time_of_Admission__c = System.today()-1;
        adm1.Max_ID__c = 'M12456';
        adm1.Visa_Invite__c=inv.id;
        adm1.Related_Prospect__c=pros1.id;
        adm1.alletec_international__c=true;
        adm1.Is_Emergency__c=true;
        adm1.Channel_Name__c='Cash';
        adm1.HCF_Source__c=accList[1].id;
        adm1.Procedure__c='Key';
        //AvoidRecursion.firstRun=true;
        insert adm1; 
        
        billing_summary__c bs=new Billing_summary__c();
        bs.alletec_billdate__c=system.today()-5;
        bs.alletec_isinternational__c=true;
        bs.Admission_Acknowledgement__c=adm1.id;
        bs.Patient__c=accList[3].id;
        bs.HCF_Source__c=accList[1].id;
        insert bs;
        
        adm1.Procedure__c='Normal';
        update adm1;
        
        // delete adm1;
        // undelete adm1;
        test.stopTest();
    }
    @isTest 
    public static void test3(){
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Admission_Acknowledgement__c = true;
        trex.Name = 'test';
        insert trex;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test1';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test2';        
        at.Business_Unit__c = bu.Id;
        insert at;                
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test1';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        List<Account> accList=new list<account>();
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account123';
        hcf.Account_Territory__c = at.Id;
        accList.add(hcf);
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124909';
        acc2.Gender__c='Male';
        acc2.FirstName='test123';
        acc2.Salutation='Mr';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        //acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        accList.add(acc2); 
        insert accList;
        
        Address_Master__c add = new Address_Master__c();
        add.Name = 'Nigeria/Lagos';
        add.Capital__c = 'Lagos';
        add.RecordtypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId();
        insert add;
        
        
        billing_summary__c bs=new Billing_summary__c();
        bs.alletec_billdate__c=system.today()-5;
        bs.alletec_isinternational__c=true;
        // bs.Admission_Acknowledgement__c=adm1.id;
        bs.Patient__c=accList[1].id;
        bs.HCF_Source__c=accList[0].id;
        insert bs;
        
        test.startTest();
        Admission_Acknowledgement__c adm1 = new Admission_Acknowledgement__c();
        adm1.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        adm1.Total_Amount__c = 100;
        adm1.Total_Revenue__c = 100;
        // adm1.MECP_Source__c = accList[0].Id;
        adm1.alletec_speciality__c = dept.Id;
        adm1.Patient__c = accList[1].Id;
        adm1.Date_Time_of_Admission__c = System.today()-1;
        adm1.Max_ID__c = 'M124909';
        //    adm1.Visa_Invite__c=inv.id;
        //    adm1.Related_Prospect__c=pros1.id;
        adm1.alletec_international__c=true;
        //adm1.Is_Emergency__c=true;
        adm1.Channel_Name__c='Cash';
        //adm1.HCF_Source__c=accList[0].id;
        adm1.Procedure__c='Key';
        adm1.alletec_international__c=true;
        //AvoidRecursion.firstRun=true;
        insert adm1;
        
        test.stopTest();
    }
    @isTest
    public static void testtagging(){
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Admission_Acknowledgement__c = true;
        trex.Name = 'test';
        insert trex;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.Name = 'test';
        insert bu;
        
        Account_Territory__c at = new Account_Territory__c();
        at.Name = 'Test';        
        at.Business_Unit__c = bu.Id;
        insert at;                
        
        Department__c dept = new Department__c();
        dept.Name = 'Department Test';
        dept.alletec_id__c = 61 ;        
        insert dept;
        
        List<account> accList=new List<account>();
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('MECP Doctor Business').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Account_Territory__c = at.Id;
        accList.add(acc);
        
        Account hcf = new Account();
        hcf.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        hcf.Name = 'Test Account';
        hcf.Account_Territory__c = at.Id;
        accList.add(hcf);
        
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        Account doctor = new Account();
        doctor.RecordTypeId = recordTypeIdd;
        doctor.LastName = 'Test Doctor';
        doctor.Max_ID__c = 'test123';
        doctor.PersonMobilePhone = '9876543210';
        doctor.PersonEmail = 'test@gm.com';
        accList.add(doctor);
        
        Account acc2 = new Account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='M124';
        acc2.Gender__c='Male';
        acc2.FirstName='test';
        acc2.Salutation='Mr';
        acc2.Alternate_Email__c='test@gmail.com';
        acc2.PersonMobilePhone='7788996644';
        acc2.DOB__c=system.today();
        acc2.BillingCity='Noida';
        //acc2.BillingCountry='India';
        acc2.BillingPostalCode='444444';
        acc2.BillingState='UP';
        acc2.BillingStreet='34';
        accList.add(acc2); 
        insert accList;
        Admission_Acknowledgement__c adm11 = new Admission_Acknowledgement__c();
        adm11.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();  
        adm11.Patient__c = accList[3].Id;
        adm11.Date_Time_of_Admission__c = System.today()-1;
        adm11.Max_ID__c = 'N.1245';
        adm11.alletec_international__c=true;
        adm11.Patient_Name__c='Nitya';
        //AvoidRecursion.firstRun=true;
        insert adm11;   
        Admission_Acknowledgement__c adm2 = new Admission_Acknowledgement__c();
        adm2.RecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();  
        adm2.Patient__c = accList[3].Id;
        adm2.Date_Time_of_Admission__c = System.today();
        adm2.Max_ID__c = 'N.1245';
        adm2.alletec_international__c=true;
        adm2.Patient_Name__c='Nitya';
        //AvoidRecursion.firstRun=true;
        insert adm2;   
        adm11.hcf_source__c=accList[1].id;
        update adm11;
    }
}