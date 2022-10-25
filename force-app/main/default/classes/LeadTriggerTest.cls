@isTest
public class LeadTriggerTest {
    

    
    class MyMock implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest request)
        {            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"number":"1234567890","body" : "Test"}');        
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest 
    static void test1(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.leadcheckbox__c = true;
        insert trex;
        
        CMP_Relationship_SF_ID__c mySettings = new CMP_Relationship_SF_ID__c();
        mySettings.Name ='Test1';
        mySettings.AutoNumber__c = 1;
        insert mySettings;
        
        Round_Robin_Sequence__c rs= new Round_Robin_Sequence__c();
        rs.Name='blah';
        rs.Sequence__c = 1;
        insert rs;
        
        Round_Robin_For_Call_Center_Agent__c rs2= new Round_Robin_For_Call_Center_Agent__c();
        rs2.Name='blah';
        rs2.Round_Sequence__c = 1;
        insert rs2;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        String recordTypeId1 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        List<lead__c> leadList=new List<lead__c>();
        Lead__c lead = new Lead__c();
        if(recordTypeId != NULL)
            lead.RecordTypeId = recordTypeId1;
        lead.Name = 'Test';
        lead.Mobile_Phone__c ='123456778';
        lead.Business_Unit__c = 'Max Vaishali';
        lead.Primary_Member__c = true;
        lead.Follow_Up_time__c='1';
        lead.Membership_Enrolment_Type__c = 'Healthy Family';
       // lead.end_disposition__c='Price Issue';
        leadList.add(lead);
        
        Lead__c l = new Lead__c();        
        l.Name = 'Family Member'; 
        l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Call Center').getRecordTypeId();
        l.Mobile_Phone__c = '1234567890';
        leadList.add(l);
        
        Lead__c lead2 = new Lead__c();
        if(recordTypeId != NULL)
            lead2.RecordTypeId = recordTypeId;
        lead2.Name = 'Test1';
        lead2.Mobile_Phone__c ='1234567789';
        lead2.Business_Unit__c = 'Max Vaishali';
        lead2.Membership_Enrolment_Type__c = 'Healthy Family';
        //lead2.Family_Member__c = l.Id;
        lead2.Want_to_Enrol__c = true;
        lead2.Primary_Member__c = true;
       // lead1.Relationship__c='Mother';
        leadList.add(lead2);
        insert leadList;
            
             Lead__c lead1 = new Lead__c();
        if(recordTypeId != NULL)
            lead1.RecordTypeId = recordTypeId;
        lead1.Name = 'Test';
        lead1.Mobile_Phone__c ='1234567789';
        lead1.Business_Unit__c = 'Max Vaishali';
        lead1.Membership_Enrolment_Type__c = 'Healthy Family';
        lead1.Family_Member__c = leadlist[2].Id;
        lead1.Want_to_Enrol__c = true;
        lead1.Primary_Member__c = false;
        lead1.Relationship__c='Mother';
        insert lead1;
        //leadList.add(lead1);
        //leadList[0].Member_ID__c = '39';  
        test.stopTest();
    }
    
    @isTest
    static void test2(){
        
      //list<Auto_Desk_Sources__mdt> leadlist1 = new list<Auto_Desk_Sources__mdt>();
      // Auto_Desk_Sources__mdt Auto= new Auto_Desk_Sources__mdt();
       // Auto.Lead_Source__c = 'Advertisement';
       	//Auto.Mobile_Phone__c='8698798327';
       	
         List<lead__c> leadList=new List<lead__c>();
        Lead__c lead1 = new Lead__c();
       // if(recordTypeId2 != NULL)
        //    lead1.RecordTypeId = recordTypeId2;
        lead1.Name = 'Test';
        lead1.Mobile_Phone__c ='123456778';
        lead1.Business_Unit__c = 'Max Vaishali';
        lead1.Primary_Member__c = true;
        lead1.Follow_Up_time__c='1';
        lead1.Membership_Enrolment_Type__c = 'Healthy Family';
       // lead.end_disposition__c='Price Issue';
        leadList.add(lead1);
       
        
       
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.leadcheckbox__c = true;
        insert trex;
        
        CMP_Relationship_SF_ID__c mySettings = new CMP_Relationship_SF_ID__c();
        mySettings.Name ='Test1';
        mySettings.AutoNumber__c = 1;
        insert mySettings;
        
        Round_Robin_Sequence__c rs= new Round_Robin_Sequence__c();
        rs.Name='blah';
        rs.Sequence__c = 1;
        insert rs;
        
        Round_Robin_For_Call_Center_Agent__c rs2= new Round_Robin_For_Call_Center_Agent__c();
        rs2.Name='blah';
        rs2.Round_Sequence__c = 1;
        insert rs2;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        
        Account acnt = new Account();
        acnt.RecordTypeId = recordTypeId;
        acnt.FirstName ='test';
        acnt.MiddleName = 'test';
        acnt.LastName = 'test';
        acnt.PersonEmail = 'test@test.com';
        acnt.PersonMobilePhone = '9876543210';
        acnt.Max_ID__c = 'test.12345';
        insert acnt;
         
        prospect__c p=new prospect__c();
        p.Account__c=acnt.id;
        p.Name='pros1';
        insert p;
        
        String recordtypeIdld = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        
        list<lead__c> leadList1 = new list<lead__c>();
        string PhoneNumber;
        Lead__c ld1 = new lead__c();
        ld1.Name = 'test test test';
       	ld1.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        ld1.Mobile_Phone__c = '9876543210';
        ld1.MaxLab_Phone__c='8698796354';
        ld1.Lead_Create__c=false;
        ld1.Prospect__c=p.id;
        ld1.Lead_Source__c='D-Paid';
       	//ld1.Follow_up_Checked__c=true;
        ld1.Sub_Source__c='Contact Us';
        ld1.Stage__c='Proposal Shared';
        ld1.Source_of_Lead__c='newtest';
        ld1.OB_End_Disposition__c='Booking ID';
        ld1.MaxLab_Mobile_no__c='1234567890';
        ld1.sub_category__c='Doctor';
        ld1.Follow_Up_time__c='1';
        ld1.Web_Sub_Source__c = 'Cart Abandoned test teat my new55';
        ld1.follow_up_date__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        leadList.add(ld1);
        
        lead__c ld2 = new lead__c();
        ld2.Name = 'test test test';
        ld2.Email__c = 'test@test.com';
        ld2.Lead_Source__c='D-Paid';
       	//ld2.Follow_up_Checked__c=true;
       	ld2.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        ld2.Stage__c='Proposal Shared';
        ld2.Source_of_Lead__c='new 2';
        ld2.OB_End_Disposition__c='Booking ID';
        ld2.MaxLab_Mobile_no__c='1234567890';
        ld2.Mobile_Phone__c='1234567890';
        ld2.MaxLab_Phone__c='8698796354';
        ld2.Source_of_Lead__c='Call Center converted inbound';
        ld2.sub_category__c='Doctor';
        ld2.Follow_Up_time__c='1';
        ld2.Web_Sub_Source__c = 'Cart Abandoned new test 3';
        ld2.follow_up_date__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
        ld2.Sub_Source__c='Contact Us';
        leadList.add(ld2);
        
        insert leadList;
        
        
        
        test.stopTest();
        
    }
    @isTest
    static void test3(){
        
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.leadcheckbox__c = true;
        insert trex;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acnt = new Account();
        acnt.RecordTypeId = recordTypeId;
        acnt.FirstName ='test';
        acnt.MiddleName = 'test';
        acnt.LastName = 'test';
        acnt.PersonEmail = 'test@test.com';
        acnt.PersonMobilePhone = '9876543210';
        acnt.Max_ID__c = 'test.12345';
        insert acnt;
        
        String recordtypeIdld = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
        
        Lead__c ld = new lead__c();
        ld.Name = 'test test test';
        ld.RecordTypeId = recordtypeIdld;
        ld.Mobile_Phone__c = '9876543210';
        ld.Patient__c=acnt.id;
        ld.Remarks__c='testttt';
        ld.File_Name__c='test';
        ld.Last_Name__c='test';
        ld.Name='tset';
        ld.Email__c='test@gmail.com';
        ld.Title__c='Mr.';
        ld.WardNo__c='45';
        ld.Contact_Person_Name__c='test';
        ld.Contact_Person_MobileNo__c='8888888888';
        ld.Address_Line_2__c='dfdgf';
        ld.Admission_Date__c=system.today();
        ld.Lead_Origin__c='IP';
        ld.Diagnostic__c='fgg';
        ld.Ailment__c='dfgd';
            
        insert ld;
       //  LeadTriggerHelper.sendSMS12();
        ld.Initiate_Assessment__c=true;
        Update ld;
        test.stopTest();
        
    } 
@isTest    
    public static void test4(){
        TriggerExecutions__c trex = new TriggerExecutions__c();
        trex.Name ='Test';
        trex.leadcheckbox__c = true;
        insert trex;
        Round_Robin_Sequence__c rs= new Round_Robin_Sequence__c();
        rs.Name='blah';
        rs.Sequence__c = 1;
        insert rs;
        
        Round_Robin_For_Call_Center_Agent__c rs2= new Round_Robin_For_Call_Center_Agent__c();
        rs2.Name='blah';
        rs2.Round_Sequence__c = 1;
        insert rs2;
        CMP_Relationship_SF_ID__c mySettings = new CMP_Relationship_SF_ID__c();
        mySettings.Name ='Test1';
        mySettings.AutoNumber__c = 1;
        insert mySettings;
         test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Test.setMock(HttpCalloutMock.class,new BitlyHttpCalloutMock());
        String recordTypeId1 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        List<lead__c> leadList=new List<lead__c>();
        Lead__c lead1 = new Lead__c();
        if(recordTypeId != NULL)
            lead1.RecordTypeId = recordTypeId;
        lead1.Name = 'Test1';
        lead1.Mobile_Phone__c ='1234567089';
        lead1.Business_Unit__c = 'Max Vaishali';
        lead1.Membership_Enrolment_Type__c = 'Healthy Family';
        //lead1.Family_Member__c = lead1.Id;
        lead1.Want_to_Enrol__c = true;
        lead1.Primary_Member__c = true;
       // lead1.Relationship__c='Mother';
        leadList.add(lead1);
        
        Lead__c lead = new Lead__c();
        if(recordTypeId1 != NULL)
            lead.RecordTypeId = recordTypeId1;
        lead.Name = 'Test';
        lead.Mobile_Phone__c ='1234567789';
        lead.Business_Unit__c = 'Max Vaishali';
        lead.call_category__c='New Booking';
        lead.sub_category__c='Appointment Not Booked';
        lead.end_disposition__c='Price Issue';
        lead.Source_of_Lead__c='abc';
        //lead.Primary_Member__c = true;
       // lead.Membership_Enrolment_Type__c = 'Healthy Family';
        leadList.add(lead);
       /* RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://ingapps12.ienergizer.in/ieapimax/api/CreateContact';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody=blob.valueOf('{ "contact_id":"123","PHONE_NO":"1234567890","priority":"High"}');
        
        RestContext.request = req;
        RestContext.response= res;*/
        insert leadList;

        Lead__c lead2 = new Lead__c();
        if(recordTypeId != NULL)
            lead2.RecordTypeId = recordTypeId;
        lead2.Name = 'Test';
        lead2.Mobile_Phone__c ='1234567789';
        lead2.Business_Unit__c = 'Max Vaishali';
        lead2.Membership_Enrolment_Type__c = 'Healthy Family';
        lead2.Family_Member__c = leadlist[0].Id;
       // lead2.Want_to_Enrol__c = true;
        lead2.Primary_Member__c = false;
        lead2.Relationship__c='Daughter';
        insert lead2;
        
        test.stopTest();
    } 
    
}