@istest
global  class QRCodeSMSTest implements HttpCalloutMock {
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('Salesforcescool');
        return res;
    }

    public static testmethod void testsample(){
    Test.setMock(HttpCalloutMock.class,  new MockClass());
    Lead__c l = new Lead__c();        
    l.Name = 'Family Member'; 
    l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
    l.Mobile_Phone__c = '7508447594';
    insert l;
    string leadid= l.id;
    test.startTest();
    QRCodeSMS.sendSMS2(leadid);
    test.stopTest();
      
    }
}