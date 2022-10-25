@RestResource(urlMapping='/MaxLabCallHistory/*')
global class RestAPI_Collection {
  @HttpPost
    global static void initPostService() {
        String response = '';
        RestContext.response.addHeader('Content-Type', 'application/json');
        Savepoint sp;
        try{
            RestRequest req = RestContext.request; 
            Map<String, String> headers = (Map<String, String>)req.headers;
            Map<String, String> params = (Map<String, String>)req.params; 
            
            if(req.requestBody.size() > 0){
                List<String> errors = new List<String>();
                String jsonString = req.requestBody.toString();
                
                Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                system.debug('dataMap'+dataMap);
                if(dataMap.size() > 0){
                    List<Object> CollectionLst= (List<Object>)dataMap.get('MaxLabCallHistory');
                    List<Max_Lab_Call_History__c> MaxLabCallHistoryList = new List<Max_Lab_Call_History__c>();
                    for(Object obj : CollectionLst){
                        Map<String, Object> innerdataMap = (Map<String, Object>)obj;
                        Max_Lab_Call_History__c MaxLabCallHistory = new Max_Lab_Call_History__c();
                        if(String.valueOf(innerdataMap.get('Call_TypeuseinAPI__c')) != null && String.valueOf(innerdataMap.get('Call_TypeuseinAPI__c')) != ''){
                            
                            MaxLabCallHistory.Call_TypeuseinAPI__c = String.valueOf(innerdataMap.get('Call_TypeuseinAPI__c'));
                        }
                        if(String.valueOf(innerdataMap.get('Call_start_date_time__c')) != null && String.valueOf(innerdataMap.get('Call_start_date_time__c')) != ''){
                            MaxLabCallHistory.Call_start_date_time__c = String.valueOf(innerdataMap.get('Call_start_date_time__c'));
                        }                                
                        if(String.valueOf(innerdataMap.get('Call_End_date_time__c')) != null && String.valueOf(innerdataMap.get('Call_End_date_time__c')) != ''){
                            MaxLabCallHistory.Call_End_date_time__c = String.valueOf(innerdataMap.get('Call_End_date_time__c'));
                        }
                        if(String.valueOf(innerdataMap.get('Call_Duration__c')) != null && String.valueOf(innerdataMap.get('Call_Duration__c')).isNumeric()){
                            MaxLabCallHistory.Call_Duration__c = Decimal.valueof(String.valueOf(innerdataMap.get('Call_Duration__c')));
                        }
                        if(String.valueOf(innerdataMap.get('Leads__c')) != null && String.valueOf(innerdataMap.get('Leads__c')) != ''){
                            MaxLabCallHistory.Leads__c = ID.valueOf(String.valueOf(innerdataMap.get('Leads__c')));
                        }
                        MaxLabCallHistoryList.add(MaxLabCallHistory);
                    }
                    list<id>collectionidlist = new list<id>();
                    List<API_Error_Log__c> ErrorSapList = new List<API_Error_Log__c>();
                    if(MaxLabCallHistoryList != null){
                        Database.SaveResult[] CollectLst = Database.insert(MaxLabCallHistoryList,false);
                        // Database.UpsertResult[] CollectLst = Database.upsert(CollectionList, false);
                        for (Database.SaveResult Collection : CollectLst) {
                            if (Collection.isSuccess()) {
                                System.debug('Successfully Updated ID: ' + Collection.getId());
                                collectionidlist.add(Collection.getId());
                                response = '{ "success": "true", "message":"Data Successful inserted",}';  
                            }else{
                                for(Database.Error err : Collection.getErrors()) {
                                    System.debug('The following error has occurred.');
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Collection fields that affected this error: ' + err.getFields());
                                    API_Error_Log__c ErrorSap = New API_Error_Log__c();
                                    ErrorSap.API_Name__c = 'MaxLabCallHistory';
                                    // ErrorSap.Error_Fields__c = String.valueof(err.getFields());
                                    ErrorSap.Error_Message__c = err.getMessage();
                                    ErrorSap.Trigger_Point__c= 'MaxLabCallHistory';
                                    // ErrorSap.Object_Name__c = 'Collection';
                                    // ErrorSap.Record_Id__c = Collection.getId();
                                    ErrorSapList.add(ErrorSap);
                                    System.debug(ErrorSapList);
                                    
                                    
                                    
                                }   
                            }
                        }
                    }
                    
                    
                    Database.SaveResult[] errorList = Database.insert(ErrorSapList, false);
                    response = '{ "success": "true" ,  "message": "Successfully updated" }'+ collectionidlist; 
                    RestContext.response.responseBody = Blob.valueOf( response );
                }
            }           
        }catch(Exception e){
            response = '{ "success": "false", "message":"Bad request", "errors":"'+e.getMessage()+'"}';
            RestContext.response.responseBody = Blob.valueOf( response );
        }
    }
}