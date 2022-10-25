@isTest
public class MaxLabCallHistoryHandlerTest {
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
    public static void test1(){
        
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        lead__c l=new lead__c();
        l.Last_Name__c='Kumari';
        l.RecordTypeid=RecordTypeId;
        insert l;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        max_lab_call_history__c m=new max_lab_call_history__c();
        m.Leads__c=l.id;
       // m.Lead_Record_Type__c='Max Lab customer lead';
        insert m;
        delete m;
        test.stopTest();
    }
}