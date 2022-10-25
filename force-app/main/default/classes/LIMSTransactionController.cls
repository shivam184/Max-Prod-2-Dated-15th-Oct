@RestResource(urlMapping='/transactionservice/*')
global class LIMSTransactionController {
    
    @httpPost
    global static void updateTransaction(){
        try {
            RestRequest request = RestContext.request;
            if(String.isNotBlank(request.requestBody.toString())) {
                RequestBodyWrapper requestBody = (RequestBodyWrapper)JSON.deserialize(request.requestBody.toString(),RequestBodyWrapper.class);	
                
                Invoice__c inv = new Invoice__c();
                if(String.isNotBlank(requestBody.limscode)) {
                    List<Account> listAccount = [SELECT Id FROM Account WHERE recordtype.Name='Max Labs' And LIMS_code__c = :requestBody.limscode];  
                    
                    if(listAccount != NULL && listAccount.size() > 0) {
                        inv.Account__c = listAccount[0].Id;
                        inv.LIMS_code__c = requestBody.limscode;
                        if(String.isNotBlank(requestBody.canceldatetime))
                            inv.Cancel_Date_Time__c = DateTime.valueOf(requestBody.canceldatetime);
                        if(String.isNotBlank(requestBody.invoiceamount))
                            inv.Invoice_Amount__c = Decimal.valueOf(requestBody.invoiceamount);
                        if(String.isNotBlank(requestBody.name))
                            inv.Name = requestBody.name;
                        if(String.isNotBlank(requestBody.transactiontype))
                            inv.Type_Of_Transaction__c = requestBody.transactiontype;
                        if(String.isNotBlank(requestBody.description))
                            inv.Description__c = requestBody.description;
                        if(String.isNotBlank(requestBody.amount))
                            inv.amount__c = Decimal.valueOf(requestBody.amount);
                        if(String.isNotBlank(requestBody.labNoVisitId))
                            inv.Lab_No_Visit_Id__c = requestBody.labNoVisitId;
                        if(String.isNotBlank(requestBody.iscancel) && requestBody.iscancel == 'true')
                            inv.isCancel__c = true;
                        if(String.isNotBlank(requestBody.invoicedate))
                            inv.Invoice_Date__c = Date.valueOf(requestBody.invoicedate);
                        if(String.isNotBlank(requestBody.invoicenumber))
                        {
                            inv.Invoice_Number__c = requestBody.invoicenumber;
                            upsert inv Invoice_Number__c;
                            
                            String jsonStr = '{"success" : true,"message" : "Invoices Created Successfully","id" :"'+inv.Id+'"}';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(jsonStr);
                            return;
                        }
                        
                        
                        else
                        {
                            String jsonStr = '{"success" : false,"message" : "Invoice Number Cannot be blank"}';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(jsonStr);
                            return;
                        }
                        
                        
                    }
                    else {
                        String jsonStr = '{"success" : false,"message" : "No Account found with provided LIMS Code"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;     
                    }
                }
                else {
                    String jsonStr = '{"success" : false,"message" : "Provide LIMS Code"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;    
                }
                
            }
            else {
                String jsonStr = '{"success" : false,"message" : "Provide Body"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;     
            }
        }   
        catch(Exception e) {
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;    
        }
    }
    
    public class RequestBodyWrapper{
        public String name;
        public String iscancel;
        public String limscode;
        public String canceldatetime;
        public String description;
        public String invoiceamount;
        public String invoicedate;
        public String transactiontype;
        public string invoicenumber;
        public String amount;
        public string labNoVisitId;
        
    }
}