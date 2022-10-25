@istest
public class CleverTapBatchTest implements HttpCalloutMock {
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('Salesforcescool');
        return res;
    }
public static testmethod void testsample(){
    Test.setMock(HttpCalloutMock.class, new CleverTapBatchTest());
   
    lead__c ld = new lead__c();
    ld.Name='Shivam test';
    ld.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
    ld.Stage__c='New';
    ld.Mobile_Phone__c='12347680';
    ld.Doctor_Name__c='Salesforce';
    ld.Speciality_Text__c='onco';
    ld.Email__c='gupta@test.com';
    insert ld;
    
    Test.setCreatedDate(ld.Id, System.today()-1);

    
   //Test.setCreatedDate( ap.Id, System.today()-1);
    Test.startTest();
    CleverTapBatch obj = new CleverTapBatch();
    DataBase.executeBatch(obj); 
    Test.stopTest();

}
    public static testmethod void testsample2(){
    Test.setMock(HttpCalloutMock.class, new CleverTapBatchTest());
   
    Appointment__c ap = new Appointment__c();
    ap.Appointment_Date_Time__c = System.now();
    ap.Patient_Name__c='Test';
    ap.Patient_Phone__c='12345678';
    ap.Max_ID__c = 'MAXX.85235';
        ap.Age__c=22;
        
   // ap.CreatedDate=System.today()-1;
    insert ap; 
    
    Test.setCreatedDate(ap.Id, System.today()-1);

    
   //Test.setCreatedDate( ap.Id, System.today()-1);
  //  Test.startTest();
    CleverTapBatch obj = new CleverTapBatch();
    DataBase.executeBatch(obj); 
    //Test.stopTest();

    
}
}