@RestResource(urlMapping='/createmaxlablead/*')
global class createmaxlabLead {
    @HttpPost
    global static void doCreateLabLead(){
        Savepoint sp = Database.setSavepoint();
        try{
            RestRequest request = RestContext.request;
            if(String.isNotBlank(request.requestBody.toString())){
                
                map<String,Object> mapKeyToValue = (map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
                Lead__c ld = new Lead__c();
                if(mapKeyToValue.containsKey('Name') && mapKeyToValue.get('Name')!=null)
                    ld.Name = (String)mapKeyToValue.get('Name');
                ld.RecordTypeId = [SELECT id FROM RecordType WHERE sobjectType='Lead__c' AND Name ='Max Labs Call Center' LIMIT 1].Id;
                if(mapKeyToValue.containsKey('Phone') && mapKeyToValue.get('Phone')!=null)
                    ld.Mobile_Phone__c = (String)mapKeyToValue.get('Phone');
                if(mapKeyToValue.containsKey('Email') && mapKeyToValue.get('Email')!=null)
                    ld.Email__c = (String)mapKeyToValue.get('Email');
                if(mapKeyToValue.containsKey('City') && mapKeyToValue.get('City')!=null)
                    ld.City__c = (String)mapKeyToValue.get('City');
                
                String Ids = '';
                API_Error_Log__c apiError = new API_Error_Log__c();
                
                if(ld != NULL){
                    
                    Database.SaveResult serecord = Database.insert(ld,false);
                    if(!serecord.isSuccess()){
                        apiError.API_Name__c = 'MaxLab Lead Creation';
                        apiError.Error_Message__c = String.valueOf(serecord.getErrors());
                        apiError.Trigger_Point__c = 'lead-insert';
                        apiError.Record_Identifier__c = '{"Name" : "'+ld.Name+'","Phone" : "'+ld.Mobile_Phone__c+'"}';
                    }
                    else 
                        ids += serecord.getId();
                }
                
                if(apiError != NULL)
                    insert apiError;
                
                String jsonStr = '{"success" : true,"message" : "Lead Created Successfully!","Ids" : "'+Ids+'"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
                    
            }else{
                string jsonstr = '{"success":"false","message":"Provide Body"}';
                RestContext.response.addHeader('Content-Type','application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonstr);
                return;
            }
        }catch(Exception e){
            Database.rollback(sp);
           String jsonstr = '{"success" : false,"message" : "'+e.getMessage()+'"}'; 
            RestContext.response.addHeader('Content-Type','application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonstr);
            return;
        }
    }
}