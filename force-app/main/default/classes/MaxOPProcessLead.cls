/**************************************************************
 * Date: 23th August 2022                                     *
 * Written By: Shivam Gupta                                   *
 * API Class controller for MaxOpProcessLead creation         *
 * Test Class: MaxOPProcessLeadTest                           *
 * ************************************************************/
@RestResource(urlMapping='/MaxOPProcessLead/*')
global class MaxOPProcessLead {
    @HttpPOST
    global static void doCreateMAXOPLead() {
        RestRequest req = RestContext.request;
        if(!String.isBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class);
            system.debug(requestBody);
            Max_at_Home_OP_Process__c  maxop = new Max_at_Home_OP_Process__c();
            if(!String.isBlank(requestBody.name)) {
                maxop.Patient_Name__c=requestBody.name;
            }
            
            else {
                String jsonStr = '{"success" : false,"message" : "Name is required"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }
            
            if(!String.isBlank(requestBody.Phone)) {
                maxop.Phone_Number__c=requestBody.Phone;
            }
            
            else {
                String jsonStr1 = '{"success" : false,"message" : "Phone is required"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr1);
                return;
            }
            if(!String.isBlank(requestBody.Source)) {
                maxop.Source__c=requestBody.Source;         
            }
            
            else {
                String jsonStr2 = '{"success" : false,"message" : "Source is required"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr2);
                return;
            }
            if(!String.isBlank(requestBody.Email)) {
                Boolean check = ValidateData.validateEmail(requestBody.email);   
                if(check)
                    maxop.Email__c = requestBody.Email;
                
                else {
                    String jsonStr = '{"success" : false,"message" : "Provide email in correct format"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;
                }
            }
            if(!String.isBlank(requestBody.City)) {
                maxop.City__c =requestBody.City;         
            }
            
            if(!String.isBlank(requestBody.Remark)) {
                maxop.Remark__c=requestBody.Remark;         
            }
            
            if(!String.isBlank(requestBody.LabTest)) {
                maxop.Lab_Test__c=requestBody.LabTest;         
            }
            
            insert maxop;
            String jsonStr = '{"success" : true,"message" : "Max OPLead created successfully","Id" : "'+maxop.Id+'"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;
            
        }
        
    }
    
    public class RequestBody {
        public string name;
        public string Phone;
        public string City;
        public string Email;
        public string Source;
        public string LabTest;
        public string Remark;
    }
    
}