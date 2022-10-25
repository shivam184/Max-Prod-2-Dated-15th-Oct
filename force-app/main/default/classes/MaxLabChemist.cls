@RestResource(urlMapping='/MaxLabChemist/*')
Global class MaxLabChemist {
    @HttpPOST
    global static void doCreateMAXChemistLead() {
        RestRequest req = RestContext.request;
        if(!String.isBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class);
            system.debug(requestBody);
            
            
           
            //Finding the chemist record type on Account
            boolean check = false;
            id chemist;
            list<Account>Chemistcheck = new list<Account>();
            Chemistcheck=[select Account_Id__c ,id, RecordType.name from Account where id =:requestBody.ChemistID and RecordType.name='Chemist Account'];
            system.debug(Chemistcheck+'Chemistcheck');
            if(Chemistcheck.size()>0){
                for(Account var:Chemistcheck){
                    chemist= var.id;
                    check = true;
                }
                system.debug(chemist);
                system.debug(check);
            }
            
            
            Max_lab_Chemist__c maxch = new Max_lab_Chemist__c();
            if(!String.isBlank(requestBody.name)) {
                maxch.Name =requestBody.name;
            }
            if(!String.isBlank(requestBody.ChemistID)){
                if(check == true){
                    maxch.Chemist_Name__c = chemist;
                }
                
                else if(check == false){
                    String jsonStr = '{"success" : false,"message" : "Provide Correct Chemist Account ID"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;
            }
            }
          
           
            
            if(!String.isBlank(requestBody.Mobile)) {
                maxch.Mobile__c  = requestBody.Mobile;
            }
            if(!String.isBlank(requestBody.URL)) {
                maxch.URL__c  =requestBody.URL;
            }
            if(!String.isBlank(requestBody.Source)) {
                maxch.Source__c  =requestBody.Source;
            }
            if(!String.isBlank(requestBody.Median)) {
                maxch.Median__c  =requestBody.Median;
            }
            
            if(!String.isBlank(requestBody.Campaign)) {
                maxch.Campaign__c   =requestBody.Campaign;
            }
            
            insert maxch;
          
            String jsonStr = '{"success" : true,"message" : "Max Chemist Record created successfully","Id" : "'+maxch.Id+'"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;
            
            
        }else{
            String jsonStr = '{"success" : false}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;
            
        }
    }
    public class RequestBody {
        public string name;
        public string Mobile;
        public string URL;
        public string Source;
        public string Median;
        public string Campaign;
        public string ChemistID;
        
  
    }
    
}