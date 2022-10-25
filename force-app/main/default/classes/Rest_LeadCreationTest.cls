@isTest
private class Rest_LeadCreationTest {
    @isTest
    private static void positiveTest(){
               
        list<lead__c> leadlist=new list<lead__c>();
        lead__c l=new lead__c();
        l.Lead_Id__c='JDF99CB5961B41';
        l.name='test from class';
        
        //updates
        date d=date.newinstance(2021,10,20);
        l.parent_id__c='PXX19';
        l.branch_pin__c='741528';
        l.time__c='14:22:01';
        l.pincode__c='796321';
        l.company_name__c='Icon technocloud';
        l.dncphone__c='7894562310';
        l.dncmobile__c='7894561230';
        l.branch_area__c='Connaught Place';
        l.city__c='Gurgaon';
        l.area__c='Gurgaon Sector 24';
        l.category__c='Ecommerce';
        l.lead_date__c=date.newInstance(2021,10,20);
        l.email__c='test@gmail.com';
        l.maxlab_phone__c='8529637410';
        l.mobile_phone__c='6541237890';
        l.prefix__c='Mr';
        l.leadtypejd__c='Ecommerce';
        l.lead_id__c='abcxyz';
        
        leadList.add(l);
               
        string jsonMessage=json.serialize(leadList);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Lead_Creation_SFDC';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        //req.requestBody = Blob.valueOf(jsonMessage);
        req.requestBody=blob.valueOf('{"leadid":"123456","leadtype":"Ecommerce","prefix":"Mr","name":"Test1","mobile":"9833700523","phone":"123354545","email":"test@gmail.com","date":"2021-09-23","category":"Ecommerce","area":"Connaught Place","city":"Delhi","brancharea":"Gurgaon Sector 24","dncmobile":0,"dncphone":0,"company":"Test","pincode":"110001","time":"15:28:16","branchpin":"122002","parentid":"PXX119"}');

        RestContext.request = req;
        RestContext.response= res;

        Rest_LeadCreation.initPostService();
    }
    
    @isTest
    private static void negativeTest(){
               
        list<lead__c> leadlist=new list<lead__c>();
        lead__c l=new lead__c();
        l.Lead_Id__c='JDF99CB5961B41';
        l.name='test lead';
        l.Email__c='test@gmail.com';
        
        leadList.add(l);
        
        l.Lead_Id__c='JDF99CB5961B41';
        l.name='test lead';
        l.Email__c='test@gmail.com';
        
        leadList.add(l);
        
        string jsonMessage=json.serialize(leadList);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Lead_Creation_SFDC';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        //req.requestBody = Blob.valueOf(jsonMessage);
        req.requestBody=blob.valueOf('{"leadid":"123456","leadtype":"Ecommerce","prefix":"Mr","name":"Test1","mobile":"9833700523","phone":"123354545","email":"test@gmail.com","date":"2021-09-23","category":"Ecommerce","area":"Connaught Place","city":"Delhi","brancharea":"Gurgaon Sector 24","dncmobile":0,"dncphone":0,"company":"Test","pincode":"110001","time":"15:28:16","branchpin":"122002","parentid":"PXX119"}');
        RestContext.request = req;
        RestContext.response= res;

        Rest_LeadCreation.initPostService();
    }
}