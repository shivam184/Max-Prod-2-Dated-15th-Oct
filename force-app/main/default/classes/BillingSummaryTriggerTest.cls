@isTest
public class BillingSummaryTriggerTest {
    @isTest 
    public static void test12(){
        TriggerExecutions__c trex = new TriggerExecutions__c();        
        trex.BillingSummary__c = true;
        trex.Name = 'test';
        insert trex;
        List<account> accList=new List<Account>();
        String docRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId(); 
        Account acc1 = new Account();
        if(String.isNotBlank(docRecordTypeId))
            acc1.RecordTypeId = docRecordTypeId;
        acc1.LastName = 'Doctor Account';     
        acc1.alletec_doctorid__c='13254';
        accList.add(acc1);
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.LastName = 'Patient Account';        
        acc2.Max_ID__c ='Test1';
        accList.add(acc2);
        
        Account acc33=new account();
        acc33.Name='Test1';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        accList.add(acc33);

insert accList;
        
        Business_Unit__c bu = new  Business_Unit__c();
        bu.Business_Unit_Code__c = 'test';
        bu.HIS_ID__c='BU1';
        bu.Name = 'test';
        insert bu;
        
        String admRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId(); 
        Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
        if(String.isNotBlank(admRecordTypeId))
            adm.RecordTypeId = admRecordTypeId;
        adm.IPID__c = 'al123';
        adm.alletec_hospitallocation__c = bu.Id;
        adm.Max_ID__c = 'Test1';
        insert adm;
        
        List<Address_Master__c> addList=new List<Address_Master__c>();
        String countryRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Country').getRecordTypeId(); 
        Address_Master__c am1 = new Address_Master__c();
        if(String.isNotBlank(countryRecordTypeId))
            am1.RecordTypeId = countryRecordTypeId;
        am1.Name = 'India';
        am1.alletec_countryid__c = '149';
       addList.add(am1);        		
        
        String stateRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('State').getRecordTypeId(); 
        Address_Master__c am2 = new Address_Master__c();
        if(String.isNotBlank(stateRecordTypeId))
            am2.RecordTypeId = stateRecordTypeId;
        am2.Name = 'UP';        
        am2.State_ID__c='22';
        am2.alletec_state__c = '22';
        am2.Country__c = am1.Id;
        addList.add(am2); 
        
        String cityRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('City').getRecordTypeId(); 
        Address_Master__c am3 = new Address_Master__c();
        if(String.isNotBlank(cityRecordTypeId))
            am3.RecordTypeId = cityRecordTypeId;
        am3.Name = 'Noida';        
        am3.alletec_cityid__c = '34';
        addList.add(am3); 
        
        String localityRecordTypeId = Schema.SObjectType.Address_Master__c.getRecordTypeInfosByName().get('Locality').getRecordTypeId(); 
        Address_Master__c am4 = new Address_Master__c();
        if(String.isNotBlank(localityRecordTypeId))
            am4.RecordTypeId = localityRecordTypeId;
        am4.alletec_localityid__c = '42';
        am4.Name = 'Sector 2';        
        addList.add(am4);      
        insert addList;
        
        List<lead__c> leadList=new List<lead__c>();
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        
        Lead__c ld = new lead__c();
        ld.RecordTypeId = recordTypeId;
        ld.Max_ID__c = 'Test1';
        ld.Stage__c = 'New';
        leadList.add(ld);
        
        String recordTypeIdInt = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Query Management').getRecordTypeId();
        
        String recordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('International Query').getRecordTypeId();
        
        
        Lead__c ld1 = new lead__c();
        ld1.RecordTypeId = recordTypeIdInt;
        ld1.Max_ID__c = 'Test1';
        ld1.Stage__c = 'New Query';
        ld1.LeadType__c='International Query';
        leadList.add(ld1);
        
        String recordTypeIdInt5 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        
        //  String recordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('International Query').getRecordTypeId();
        
        
        Company_Master__c cm = new Company_Master__c();
        cm.Name='test';
        cm.GL_Code__c='test23';
        insert cm;
        
        Lead__c ld5 = new lead__c();
        ld5.RecordTypeId = recordTypeIdInt5;
        ld5.Max_ID__c = 'Test1';
        ld5.Stage__c = 'OPD Consult Taken';
        ld5.LeadType__c='International Query';
        ld5.relationship__c='Mother';
        leadList.add(ld5);
        insert leadList;
        
        case cs=new case();
        cs.Name__c='Test';
        cs.Lead_Create__c=true;
        cs.Max_ID__c='SKDD.12345';
        CS.Address_Line_1__c='TEST';
        CS.Campaign__c='TEST';
        CS.Country_Region__c='TEST';
        CS.Description='TESTING';
        CS.Doctor_Name__c='TEST';
        CS.Email__c='TEST@GMAIL.COM';
        CS.File_Name__c='TEST';
        CS.Form_Name__c='TEST';
        cs.Placement__c='test';
        cs.Patient_Name__c='test';
        cs.Passport_No__c='testpass';
        cs.RecordTypeId=recordTypeIdCase;
        Insert cs;
        
        Visa_Invite__c vi = new Visa_Invite__c();
        // vi.Name=bs.id;
        // vi.Id=bs.id;
        vi.Patient__c = acc2.Id;
        vi.Passport_number__c='tmc1234';
        vi.Hospital_Location__c=bu.Id;
        vi.Stage__c='New';
        vi.Doctor_Name__c=acc1.id;
        vi.HCF_Partner_name__c=acc33.Id;
        vi.Country__c=am1.Id;
        vi.Ailment__c='testing';
        vi.Gender__c='Male';
        vi.Sub_HCF_Name__c='test';
        vi.HCF_Mobile_No__c='9897979797';
        vi.Recipient_Email__c='test@test.com';
        vi.Recipient_City__c='Delhi';
        vi.Type_of_Visa__c='Patient';
        vi.Customer_Patient_Name__c='Test';
        vi.Max_Id__c = 'Test1';
        insert vi;
        
        International_OP_Patient_Journey__c ij = new International_OP_Patient_Journey__c();
        ij.Name='tests';
        ij.Patient_Max_id__c='Test1';
        ij.Admission_advice__c = true;
        ij.First_OP_Bill__c = '29891';
        //ij.OP_Bill_Lists__c = 'Bill Lists';
        ij.Patient_Age__c = 16.50;
        ij.Patient_Phone_Number__c = '9871234560';
        ij.Patient_Email_Id__c = 'patient@email.com';
        ij.First_OP_Bill_Date__c = System.today()-1;
        ij.Date_Of_Admission__c = DateTime.newInstance(2021, 7, 11, 8, 6, 16);
        ij.Stage__c = 'new';
        ij.Channel_Name__c = 'Ultimate';
        ij.Patient_Nationality__c = 'indian';
        ij.Doctor_Name__c = 'Dr. Chandra';
        insert ij;
        
        Test.startTest();
        department__c d=new department__c();
        d.name='Oncology';
        insert d;
        
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_hisamount__c = 100;
        bs.alletec_companyname__c = acc1.Id;
        bs.City__c = am3.Id;        
        bs.billto_city__c='34';
        bs.alletec_state__c ='22' ; 
        bs.State__c = am2.Id;
        bs.billto_country__c = '149';
        bs.Country__c = am1.Id;        
        bs.Hospital_Location_HIS__c = 'BU1';
        bs.name__c = 'Test1';
        bs.alletec_transactiontype__c='IP';
        bs.Patient__c = acc2.Id;
        bs.Admission_Acknowledgement__c = adm.Id;        
        bs.alletec_doctorid__c = '13254';        
        bs.alletec_locality__c = '42';
        bs.Locality__c = am4.Id;
        bs.GL_Code__c='test23';
        bs.alletec_department__c=d.id;
        bs.alletec_isinternational__c=true;
        bs.alletec_billdate__c=system.today()-3;
        // bs.alletec_hospitallocation__c='test';
        bs.alletec_ipid__c='al123';
        insert bs;

        Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.alletec_hisamount__c = 100;
        bs1.alletec_companyname__c = acc1.Id;
        bs1.alletec_billdate__c=system.today();
        bs1.City__c = am3.Id;        
        bs1.billto_city__c='34';
        bs1.alletec_state__c ='22' ; 
        bs1.State__c = am2.Id;
        bs1.billto_country__c = '149';
        bs1.Country__c = am1.Id;        
        bs1.Hospital_Location_HIS__c = 'BU1';
        bs1.name__c = 'Test1';
        bs1.alletec_transactiontype__c='IP';
        bs1.Patient__c = acc2.Id;
        bs1.Admission_Acknowledgement__c = adm.Id;        
        bs1.alletec_doctorid__c = '13254';        
        bs1.alletec_locality__c = '42';
        bs1.Locality__c = am4.Id;
        bs1.GL_Code__c='test23';
        bs1.alletec_department__c=d.id;
        bs1.alletec_isinternational__c=true;
        // bs.alletec_hospitallocation__c='test';
        bs1.alletec_ipid__c='al123';
        insert bs1;
        bs.hcf_source__c=accList[2].id;
        update bs;
        Test.stopTest();
        
    }
    
   @isTest 
    public static void test2(){
        
        Account acc33=new account();
        acc33.Name='Test1';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc33;
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.Max_ID__c ='123';
        acc2.LastName = 'Patient Account'; 
        acc2.PersonMobilePhone='123456';
        acc2.PersonEmail='nitya@dummy.com';
        
        insert acc2;
       
        International_OP_Patient_Journey__c ij = new International_OP_Patient_Journey__c();
        ij.Name='tests';
        ij.Patient_Max_id__c='123';
        ij.Admission_advice__c = true;
        ij.First_OP_Bill__c = '29891';
      //  ij.OP_Bill_Lists__c = 'Bill Lists';
        ij.Patient_Age__c = 16.50;
        ij.Patient_Phone_Number__c = '9871234560';
        ij.Patient_Email_Id__c = 'patient@email.com';
        ij.First_OP_Bill_Date__c = date.today().addDays( -10 );
        ij.Date_Of_Admission__c = DateTime.newInstance(2021, 7, 11, 8, 6, 16);
        ij.Stage__c = 'new';
        ij.Channel_Name__c = 'Ultimate';
        ij.Patient_Nationality__c = 'indian';
        ij.Doctor_Name__c = 'Dr. Chandra';
        insert ij;
        
        Test.startTest();
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_isinternational__c=true;
        bs.HCF_Source__c = acc33.id;
        bs.Patient__c = acc2.id;
        bs.name__c='123';
        bs.Auto_Tagged__c=true;
        bs.alletec_dateofadmission__c=date.today().adddays(-5);
        bs.Is_Tagged_By_International_Hidden__c=true;
        bs.SMS_Tagged__c=true;
        bs.alletec_billdate__c = date.today().addDays( -10 );
        bs.alletec_transactiontype__c = 'IP';
        bs.IOP_Journey__c=ij.id;
        insert bs;
        
        International_OP_Patient_Journey__c ij2 = new International_OP_Patient_Journey__c();
        ij2.Name='tests';
        ij2.Patient_Max_id__c='12345';
        ij2.Admission_advice__c = true;
        ij2.First_OP_Bill__c = '29891';
     //   ij2.OP_Bill_Lists__c = 'Bill Lists';
        ij2.Patient_Age__c = 16.50;
        ij2.Patient_Phone_Number__c = '9871234560';
        ij2.Patient_Email_Id__c = 'patient@email.com';
        ij2.First_OP_Bill_Date__c = date.today().addDays( -100 );
        ij2.Date_Of_Admission__c = DateTime.newInstance(2021, 7, 11, 8, 6, 16);
        ij2.Stage__c = 'new';
        ij2.Channel_Name__c = 'Ultimate';
        ij2.Patient_Nationality__c = 'indian';
        ij2.Doctor_Name__c = 'Dr. Chandra';
        
        insert ij2;
        Department__c dp = new Department__c();
        dp.Name = 'Radiology';
        insert dp; 
       
       Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.alletec_isinternational__c=true;
        bs1.HCF_Source__c = acc33.id;
        bs1.Patient__c = acc2.id;
        bs1.name__c='12345';
        bs1.Auto_Tagged__c=true;
        bs1.alletec_dateofadmission__c=date.today().adddays(-5);
        bs1.Is_Tagged_By_International_Hidden__c=true;
        bs1.SMS_Tagged__c=true;
        bs1.alletec_billdate__c = date.today().addDays( -10 );
        bs1.alletec_transactiontype__c = 'OP';
        bs1.IOP_Journey__c=ij2.id;
        bs1.alletec_patientname__c='Nitya';
        bs1.invoicenumber__c='Inv-123';
        bs1.alletec_channeltype__c='channel-1';
        bs1.alletec_doctorname__c='Doctor Manish';
        bs1.alletec_department__c=dp.id;
        insert bs1;
        bs1.alletec_doctorname__c='Dr. Change';
        update bs1;
        Test.StopTest();
    }
    @isTest 
    public static void test3(){
        
        Account acc33=new account();
        acc33.Name='Test1';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        insert acc33;
        
        String patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account acc2 = new Account();
        if(String.isNotBlank(patientRecordTypeId))
            acc2.RecordTypeId = patientRecordTypeId;
        acc2.Max_ID__c ='123';
        acc2.LastName = 'Patient Account'; 
        acc2.PersonMobilePhone='123456';
        acc2.PersonEmail='nitya@dummy.com';
        
        insert acc2;
       
        International_OP_Patient_Journey__c ij = new International_OP_Patient_Journey__c();
        ij.Name='tests';
        ij.Patient_Max_id__c='12390';
        ij.Admission_advice__c = true;
        ij.First_OP_Bill__c = '29891';
       // ij.OP_Bill_Lists__c = 'Bill Lists';
        ij.Patient_Age__c = 16.50;
        ij.Patient_Phone_Number__c = '9871234560';
        ij.Patient_Email_Id__c = 'patient@email.com';
        ij.First_OP_Bill_Date__c = date.today().addDays( -10 );
        ij.Date_Of_Admission__c = DateTime.newInstance(2021, 7, 11, 8, 6, 16);
        ij.Stage__c = 'new';
        ij.Channel_Name__c = 'Ultimate';
        ij.Patient_Nationality__c = 'indian';
        ij.Doctor_Name__c = 'Dr. Chandra';
        insert ij;
        
        Department__c dp = new Department__c();
        dp.Name = 'Radiology';
        insert dp; 
        
        Test.startTest();
        Billing_Summary__c bs = new Billing_Summary__c();
        bs.alletec_isinternational__c=true;
        bs.HCF_Source__c = acc33.id;
        bs.Patient__c = acc2.id;
        bs.name__c='12390';
        bs.Auto_Tagged__c=true;
        bs.alletec_dateofadmission__c=date.today().adddays(-5);
        bs.Is_Tagged_By_International_Hidden__c=true;
        bs.SMS_Tagged__c=true;
        bs.alletec_billdate__c = date.today().addDays( -10 );
        bs.alletec_transactiontype__c = 'OP';
        bs.alletec_department__c=dp.id;
        
       // bs.IOP_Journey__c=ij.id;
        insert bs;
        
        Billing_Summary__c bs1 = new Billing_Summary__c();
        bs1.name__c='420';
        bs1.alletec_billdate__c = date.today().addDays( -10 );
        bs1.IOP_Journey__c=null;
        insert bs1;
        test.stopTest();
    }
    
}