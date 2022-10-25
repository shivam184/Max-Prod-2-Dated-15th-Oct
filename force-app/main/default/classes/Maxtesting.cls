@istest
public class Maxtesting implements HttpCalloutMock{
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('Salesforcescool');
        return res;
    }

    
    public static testmethod void testsample(){
    Test.setMock(HttpCalloutMock.class, new Maxtesting());
    Test.startTest();
    lead__c ld = new lead__c();
    ld.Name='Shivam test';
    ld.Stage__c='New';
    ld.Mobile_Phone__c='12347680';
    insert ld;
    Set<Id> LeadIds= new set<Id>();
    LeadIds.add(ld.Id);
    List<Lead__c> LeadList = [Select Id ,contact_id__c ,Campaign__c ,MaxLab_Phone__c,priority__c,ExecutiveID__c,follow_up_date__c,Patient_Name__c,Lead_Id__c from Lead__c where id in:LeadIds] ; 
    MAXApi.APIMAXintegration(LeadIds);
    Test.stopTest();
    
    }
    
}