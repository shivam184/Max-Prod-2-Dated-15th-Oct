@istest
public class UploadLeadAPITEST {
    public static testmethod void mytest(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('UploadApiStaticResource');
        mock.setHeader('Content-Type', 'application/json');
		mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        //UploadLeadAPI.doCreate();
        
        Lead__c lead = new Lead__c();
        lead.Name = 'A S K';
        lead.City__c = 'Delhi';
        lead.Company_Name__c = 'MAX';
        lead.Last_Name__c = 'lab';
        lead.First_Name__c = 'test';
        lead.Business_Model__c = 'PAS';
        lead.Sales_Region__c = 'NCR';
        lead.Rating__c = 'Cold';
        lead.Source_of_Lead__c='Test';
        lead.Maxlab_Patient_Email_Id__c='fanindra@tmc.com';
        lead.Campaign_Name__c='test camp';
        lead.Maxlab_Mobile_no__c='9878798786';
        lead.Description__c='testing';
        insert lead;
        
       UploadLeadAPI.Wrapper leadwrap = new UploadLeadAPI.Wrapper();
        leadwrap.Campaign='testing';
        leadwrap.City='Delhi';
        leadwrap.Email='fanindra@tmc.com';
        leadwrap.Name='test';
        leadwrap.Phone='9555064159';
        leadwrap.Query='testing';
        leadwrap.Source_of_Lead='tes';
          
        test.startTest();
       RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/MaxLabWebsitetosalesforceLeads'; 
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueOf('{"Name":"Fanindra","Email":"fanindra@tmc.com","City":"Delhi","Phone":"9555064159","Query":"testing","Campaign":"Test","Source_of_Lead":"Cold Calling","Patient_ID":"CII2019","Patient_Name":"Test","Customer_Name":"Sample","Mobile":"1234567890", "PreBookingId":"101","Paid_Amount":"101","Address":"gdjasdhvs","URL":"https://universal-trinity-228578.postman.co/workspace/Max-Work~5a866ecf-245c-469a-b64d-a40dfea765a1/history/18183858-02cfdd9f-dc25-48d9-a10a-332e5c201dc9", "Payu_trans_id":"102","Payu_payid":"103","Payment_Mode":"Cash","Booking_Status":"Complete","Payment_Status":"Done","Lims_Response":"YEs","Cart_Items":""} ');
        
        String listDocument=JSON.serialize(leadwrap);
        
        RestContext.request = req;
        RestContext.response= res;
        
        UploadLeadAPI.doCreate();
        test.stopTest();
       
        
    }
}