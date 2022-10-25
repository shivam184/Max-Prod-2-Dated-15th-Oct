@istest
public class PatientFormControllertest {
    static testMethod void testMethod1() {
        String recordTypeIdd = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId(); 
        Account ac = new Account();
        ac.RecordTypeId = recordTypeIdd;
        ac.LastName = 'Test';
        ac.Max_ID__c = 'test123';
        ac.PersonMobilePhone = '9876543210';
        ac.PersonEmail = 'test@gm.com';
        insert ac;
        
        test.startTest();
        lead__c l=PatientFormController.createLead('gupta185','7508447594','punjab',ac.id,'QR Code');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.png';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        PatientFormController.UpdatesaveFile(l.Id,cv.Id);
        
        test.stopTest();    
    }
}