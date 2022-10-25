@istest
  public class SMSQRCodeTest implements HttpCalloutMock {
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('Salesforcescool');
        return res;
    }
      
      
      
      public static testmethod void testsample(){
         Test.setMock(HttpCalloutMock.class,new BitlyHttpCalloutMock());
          
      
          Lead__c l = new Lead__c();        
          l.Name = 'Family Member'; 
          l.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
          l.Mobile_Phone__c = '1234567890';
          insert l;
      string leadid= l.id;
      test.startTest();
      SMSQRCode.sendSMS2(leadid);
      test.stopTest();
      
         
         
         
         
    }
      
      public static testmethod void testsample2(){
         Test.setMock(HttpCalloutMock.class,new BitlyHttpCalloutMock());
          
      string phonenumber= '7508447594';
      string CompliantNumber='c-12345';
      test.startTest();
      SMSQRCode.sendSMS3(phonenumber,CompliantNumber);
      SMSQRCode.sendSMS4(phonenumber,CompliantNumber);   
      test.stopTest();
      
         
         
         
         
    }
      
}