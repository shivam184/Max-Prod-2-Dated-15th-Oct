global class OPDAutomationFetchMaxIdBatch implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful{
    global String query;
    global List<Id> LeadToUpdateMemberId;
    
    global OPDAutomationFetchMaxIdBatch(){
        LeadToUpdateMemberId = new List<Id>();
        this.query = system.label.CMP_Batch_Class_Query;
        query+=' WHERE Recordtype.Name=\'OPD automation Lead\'';
        query+=' AND Max_ID__c=null';
        
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext batchContext){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext context, List<sObject> scope){
        list<Lead__c> leadsForMaxIds = new list<Lead__c>();
        list<Lead__c> leadObjList = new list<Lead__c>();
        list<Lead__c> leadToUpdate = new list<Lead__c>();
        Set<String>   MemberIdSet = new Set<String>();
        set<Id> doctorIds = new set<Id>();
        
        for(sObject obj : scope){
            Lead__c leadObj = (Lead__c)obj;
            if(String.isBlank(leadObj.Max_ID__c))
                leadsForMaxIds.add(leadObj);
        }
        //Fill User and Federation ID Map
        map<Id,User> userIdMap = new map<Id,User>([SELECT Id,FederationIdentifier,Business_Unit__c FROM User WHERE UserRole.Name like : 'Outreach%']);
        //Fill HIS ID Map
        map<String,String> userLocationIdMap = new map<String,String>();
        for(Business_Unit__c location : [SELECT Name,HIS_ID__c,Active__c FROM Business_Unit__c WHERE Active__c=True]){
            if(String.isNotBlank(location.HIS_ID__c))
                userLocationIdMap.put(location.Name, location.HIS_ID__c);
        }
        if(leadsForMaxIds!=null && leadsForMaxIds.size()>0){
            OutboundAPIUtilityController.fetchDetailsFromMetadata(system.label.Patient_Registration_API_method);
            String endpoint = OutboundAPIUtilityController.endpoint;
            
            String apikeyHeader = OutboundAPIUtilityController.apikeyHeader;
            String timeStampHeader = OutboundAPIUtilityController.timeStampHeader;
            String signatureHeader = OutboundAPIUtilityController.signatureHeader;
            String dtFormat = OutboundAPIUtilityController.dtFormat;
            String api_key = OutboundAPIUtilityController.api_key;
            
            
            
            Map<String, Gender__c> genders = Gender__c.getAll();
            map<String,String> genderMap = new map<String,String>();   
            // Sort them by name
            List<String> genderNames = new List<String>();
            genderNames.addAll(genders.keySet());
            
            // Create the Select Options.
            for (String gn : genderNames) {
                Gender__c bg = genders.get(gn);
                genderMap.put(bg.Name,bg.HIS_ID__c);
            }
            
            
            //Looping through Leads without Max IDs and registering them in HIS to generate Max ID
            for(Lead__c lead : leadsForMaxIds){
                
                if(String.isNotBlank(lead.Mobile_Phone__c)){
                    String searchValue;
                    if(String.isNotBlank(lead.Email__c)){
                        searchValue = lead.Mobile_Phone__c+'|'+lead.Email__c;
                    }else{
                        searchValue = lead.Mobile_Phone__c+'|'+system.label.Max_Default_Email;
                        lead.Email__c = system.label.Max_Default_Email;
                    }
                    system.debug('>>>>'+searchValue);
                    
                    String signature = OutboundAPIUtilityController.generateSignature(system.label.Patient_Registration_API_method,searchValue);
                    
                    String body = '{"FirstName":"'+lead.First_Name__c+'",';
                    body+='"LastName":"'+lead.Last_Name__c+'",';
                    body+='"Address":"'+lead.Address_Line_1__c+'",';
                    body+='"MobileNo":"'+lead.Mobile_Phone__c+'",';
                    body+='"Gender":"'+genderMap.get(lead.Gender__c)+'",';
                    body+='"Email":"'+lead.Email__c+'",';
                    
                    Date dt = lead.DOB__c; 
                    
                    String str = String.valueOf(dt);
                    if(str !=NULL){
                        List<String> strList = str.split('-');
                        
                        String tempDt = strList[1]+'/'+strList[2]+'/'+strList[0];
                        body+='"DateOfBirth":"'+tempDt+'",';
                        body+='"CityID":"'+String.valueOf(Integer.valueOf(lead.City_Id_Onboarding__c))+'",';
                        String zipcode = lead.ZIP_Postal_Code__c!=null ? lead.ZIP_Postal_Code__c : '';
                        body+='"ZipCode":"'+zipcode+'",';
                    }
                    
                    if(!test.isRunningTest()){
                        if(userIdMap.containsKey(lead.OwnerId)){
                            if(String.isNotBlank(userIdMap.get(lead.OwnerId).Business_Unit__c))
                                if(userLocationIdMap.containsKey(userIdMap.get(lead.OwnerId).Business_Unit__c))
                                body+='"LocationID":"'+userLocationIdMap.get(userIdMap.get(lead.OwnerId).Business_Unit__c)+'",';
                            body+='"UserID":'+Integer.valueOf('1')+',';
                        }
                    }
                    else{
                        body+='"LocationID":"15",';
                        body+='"UserID":'+Integer.valueOf('012888')+',';
                    }
                    body+='"Source":"'+api_key+'"}';
                    system.debug('Body--->'+body);
                    Http http = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setHeader(apikeyHeader,api_key);
                    request.setHeader(timeStampHeader,system.now().format(dtFormat));
                    request.setHeader(signatureHeader,signature);
                    request.setHeader('Content-Type', 'application/json');
                    request.setEndpoint(endpoint);
                    request.setBody(body);
                    request.setMethod('POST');
                    
                    
                    HttpResponse response = new HttpResponse();
                    if(!test.isRunningTest()){
                        response = http.send(request);
                    }
                    else{
                        response.setStatusCode(200);
                        response.setBody('{"ISSuccessfull":0,"MaxID":"SKDD.682864","Code":1,"Status":"Success","Message":"Patient registered successfully"}');
                    }
                    system.debug('===response='+response);
                    if(response.getStatusCode()==200){
                        system.debug('===LineNo133==');
                        if(response.getBody()!=null){
                            map<String,Object> responseMap =  (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                            system.debug('responseMap--->'+responseMap);
                            if(responseMap.containsKey('Status')){
                                if(responseMap.get('Status')=='Success'){
                                    lead.Max_ID__c = (String)responseMap.get('MaxID');
                                    leadToUpdate.add(lead);
                                }
                            }
                        }
                    }  
                }
            }
        }
        
        if(leadToUpdate!=null && leadToUpdate.size()>0){
            Database.SaveResult[] resultList = Database.update(leadToUpdate,false);
            for (Database.SaveResult sr : resultList) {
                     LeadToUpdateMemberId.add(sr.getId());
            }
            
            list<API_Error_Log__c> errorLogsToInsert = new list<API_Error_Log__c>();
            for (Database.SaveResult result : resultList) {
                if(!result.isSuccess()){
                    for(Database.Error err : result.getErrors()){
                        API_Error_Log__c apiError = new API_Error_Log__c();
                        apiError.API_Name__c = 'Patient Registration/membership API';
                        apiError.Error_Message__c = String.valueOf(err.getMessage());
                        apiError.Trigger_Point__c = 'Patient Registration/membership API';
                        apiError.Record_Identifier__c = 'Fields : '+err.getFields();
                        errorLogsToInsert.add(apiError); 
                    }
                    //system.debug('errorLogsToInsert'+errorLogsToInsert);
                    if(!errorLogsToInsert.isEmpty())
                        insert errorLogsToInsert;
                }
            }
        }
        
    }
    
    global void finish(Database.BatchableContext context){
        
    }
}