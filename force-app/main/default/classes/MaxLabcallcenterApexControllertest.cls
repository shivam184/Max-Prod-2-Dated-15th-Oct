@isTest
public class MaxLabcallcenterApexControllertest {
    @isTest
    public static void test(){
        String recordTypeAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account();
        acc.lastname = 'test';
        acc.RecordTypeId = recordTypeAccountId;
        acc.Max_ID__c = 'MAXX.1234';
        insert acc;
        
        String recordTypeLeadId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId(); 
        System.debug('========>>>>'+recordTypeLeadId);
        Lead__c ld = new Lead__c();
        ld.Name = 'Test';
        ld.RecordTypeId = recordTypeLeadId;
        ld.Call_Type__c='Blank Call';
        ld.Mobile_Phone__c = '9876543210';
        ld.Service__c='No Response';
        ld.DisconnectionType__c='Caller';
        ld.Email__c = 'test@gm.com';
        insert ld;
        
        Transaction__c tr = new Transaction__c();
        tr.Bill_No__c = 'Bill-001';
        tr.Patient__c = acc.Id;
        insert tr;
        
        String recordTypeLeadId1 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId(); 
        
        Lead__c ld1 = new Lead__c();
        ld1.Name = 'Test';
        ld1.RecordTypeId = recordTypeLeadId1;
        ld1.Call_Type__c='Blank Call';
        ld1.Mobile_Phone__c = '9876543210';
        ld1.Service__c='No Response';
        ld1.DisconnectionType__c='Caller';
        ld1.Email__c = 'test@gm.com';
        ld1.Complaint_Category__c ='callback';
        ld1.Complaint_Sub_Category__c='callback';
        insert ld1;
        
String recordTypeLeadId2 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId(); 
        Lead__c ld2 = new Lead__c();
        ld2.Name = 'Test';
        ld2.RecordTypeId = recordTypeLeadId2;
        ld2.Call_Type__c='Blank Call';
        ld2.Mobile_Phone__c = '9876543210';
        ld2.Service__c='No Response';
        ld2.DisconnectionType__c='Caller';
        ld2.Email__c = 'test@gm.com';
        insert ld2;
       // MaxLabcallcenterApexController1.getUserInfo('9876543210');
       MaxLabcallcenterApexController1.getPatientNameForMobileNumber('9555064159',True);
        MaxLabcallcenterApexController1.getPatientForMobileNumber('9876543210',True);
        MaxLabcallcenterApexController1.getPatientForMobileNumber('MAXX.1234',True);
        MaxLabcallcenterApexController1.getCallTypeApex();
        MaxLabcallcenterApexController1.ComplaintCategoryApex('Call Centre');
        MaxLabcallcenterApexController1.searchPatientForPicklistApex('MAXX.1234');
        MaxLabcallcenterApexController1.searchLeadByMobileNo('9876543210');        
        MaxLabcallcenterApexController1.saveDataApex('callback','callback','9876543210', '9876543210', 'contactName', 'contactSalutation', '18', 'male', 'xyz@gmail.com','9876543210','New Booking' ,'Complaints', 'Other',acc.Id ,'Others','SMS','','', '123',false,'','123',2093,false,'','','');
       MaxLabcallcenterApexController1.createLead('Mr.', '9876543210', '18', 'Male', 'xyz@gmail.com', 'test','','','','','','',676,false,false,tr.Id,'','name','callback','callback','','');
    }
    
}