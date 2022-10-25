@istest
public class QRControllerTest {
    static testMethod void testMethod2() {
        test.startTest();
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account ac = new Account();
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        ac.RecordTypeId=recordTypeIdd;
        insert ac;
        QRController.getAccountList(ac.PersonMobilePhone);
        test.stopTest();   
        
    }
    
}