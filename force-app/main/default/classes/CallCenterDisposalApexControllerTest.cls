@isTest
public class CallCenterDisposalApexControllerTest {
    
    @isTest
    static void test1(){
        Account acc = new Account();
        Account acc1 = new Account();
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(recordTypeId != NULL){            
            acc.RecordTypeId = recordTypeId;
            acc.LastName = 'test';
            acc.Salutation = 'Mr.';
            acc.Max_ID__c = 'AS456';                
            acc.Gender__c = 'Male';
            acc.mobilephone__c = '1234567890';
            insert acc;        
        }
        
        Department__c depart = new Department__c();
        depart.Name = 'Test Depart';
        insert depart;
        
        Speciality__c speciality = new Speciality__c();
        speciality.Name = 'Test Speciality';
        speciality.alletec_department__c = depart.Id;
        
        
        String docRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        if(docRecordTypeId != NULL){                 
            acc1.RecordTypeId = docRecordTypeId;
            acc1.LastName = 'test';                          
            acc1.Gender__c = 'Male';           
            acc1.Specialty__pc = speciality.Id;
            insert acc1;        
        }
        
        String leadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        if(leadRecordTypeId != NULL){
            Lead__c lead = new Lead__c();
            lead.RecordTypeId = leadRecordTypeId;
            lead.Name ='Test Lead';
            lead.Location_Name__c = 'Noida';
            
            lead.Call_Type__c = 'Appointment';
            lead.Service__c = 'Doctor';
            lead.Patient__c = acc.Id;                    
            insert lead;
        }                                        
        
        Billing_Summary__c bSummary = new Billing_Summary__c();
        bSummary.alletec_channeltype__c = 'PSU';
        bSummary.Patient__c = acc.Id;
       	insert bSummary;
                        
        Test.startTest();
        CallCenterDisposalApexController.getPatientForMobileNumber('1234567890',true);
        CallCenterDisposalApexController.getCallTypeApex();
        CallCenterDisposalApexController.checkValidation('987654321012');
        CallCenterDisposalApexController.searchPatientForPicklistApex('AS456');
       // CallCenterDisposalApexController.saveDataApex('Test Contact','','','','','','','','AS456', 'Appointment', 'Doctor','','','','Test','','','','','',acc1.Id,speciality.Id, '', '','', '', '','',false,true,'Test');
        Test.stopTest();
    }
    
    @isTest
    static void test2(){        
        Department__c depart = new Department__c();
        depart.Name = 'Test Depart';
        insert depart;
        
        Speciality__c speciality = new Speciality__c();
        speciality.Name = 'Test Speciality';
        speciality.alletec_department__c = depart.Id;
        
        Account acc1 = new Account();
        String docRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Doctor').getRecordTypeId();
        if(docRecordTypeId != NULL){                 
            acc1.RecordTypeId = docRecordTypeId;
            acc1.LastName = 'test';                          
            acc1.Gender__c = 'Male';   
            acc1.Specialty__pc = speciality.Id;
            insert acc1; 
        }
         Account acc2 = new Account();
        String docRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Call Center Users').getRecordTypeId();
        {                 
            acc2.RecordTypeId = docRecordTypeId2;
            acc2.AccountNumber  = 'MX_T139967_HIMAN';                          
            acc2.Name  ='Himanshu Dawar';
            insert acc2; 
        }
        Contact con = new Contact();    
        String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(recordTypeId != NULL){            
            con.RecordTypeId = recordTypeId;
            con.LastName = 'Con Test';
            con.Email = 'tset@test.com';
            con.Phone = '0987654321';            
            insert con;
        }
                                        
        Test.startTest();
        CallCenterDisposalApexController.saveDataApex('Con Test','MX_T139967_HIMAN','','0987654321','Mr.','','Male','','','', 'Query','','', 'LOC123','','Testing',
                                                      '','','','','',acc1.Id,speciality.Id, '', '','', '', '','9876543210',false,false,'Test');     
        Test.stopTest();
    }
    
    @isTest
    static void test3(){
        Contact con = new Contact();
        String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(recordTypeId != NULL){            
            con.RecordTypeId = recordTypeId;
            con.LastName = 'Con Test';
            con.Email = 'tset@test.com';
            con.Phone = '0987654321';
            insert con;
        }
                                        
        Test.startTest();
        CallCenterDisposalApexController.saveDataApex('Con Test','','','0987654321','Mr.','','Male','','','', 'Appointment','','', '','','Testing',
                                                      '','','','','','','General Physician', '', '','', '', '','9876543210',true,true,'Test');     
        Test.stopTest();
    }
        
    @isTest
    static void test4(){
        
        userid__c use = new userid__c();
       // use.Unique_Id__c='109';
        use.Name ='test';
        insert use;
        
        Test.startTest();
        CallCenterDisposalApexController.getUseridApex('109');
        Test.stopTest();
        
        
        
        
    }
}