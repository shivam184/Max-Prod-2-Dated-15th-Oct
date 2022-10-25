@RestResource(urlMapping='/limsCenterUpdate/*')
global class LIMSCentreUpdateAPI {    
    
    @HttpPOST
    global static void doUpdateRecords(){
        try {
            RestRequest request = RestContext.request;
            if(String.isNotBlank(request.requestBody.toString())) {
                Map<String,Id> mapToEmpIdToUserId = new Map<String,Id>();
                for(User u : [SELECT Id,FederationIdentifier FROM User WHERE FederationIdentifier != NULL])
                    mapToEmpIdToUserId.put(u.FederationIdentifier,u.Id);
                Map<String,Object> mapKeyToValue = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
                if(mapKeyToValue != NULL && mapKeyToValue.keySet().size() > 0) {
                    List<Object> listObject = (List<Object>)mapKeyToValue.get('Data');
                    if(listObject !=  NULL && listObject.size() > 0) {
                        List<Account> accountList = new List<Account>();
                        List<Contact> conList = new List<Contact>();

                        String recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Max Labs').getRecordTypeId();
                        for(Integer i=0 ; i < listObject.size() ; i++) {
                            Map<String,Object> accountMap = (Map<String,Object>)listObject[i]; 

                            if(accountMap != NULL && accountMap.keySet().size() > 0) {
                                Account account = new Account();
                                if(String.isNotBlank(recordTypeId))
                                    account.RecordTypeId = recordTypeId;
                                if(accountMap.containsKey('CentreCode') && accountMap.get('CentreCode') != NULL)
                                    account.LIMS_Code__c = (String)accountMap.get('CentreCode');
                                if(accountMap.containsKey('Centre') && accountMap.get('Centre') != NULL)
                                    account.Name = (String)accountMap.get('Centre');
                                if(accountMap.containsKey('Mobile') && accountMap.get('Mobile') != NULL)
                                    account.Phone = (String)accountMap.get('Mobile');
                                if(accountMap.containsKey('Email') && accountMap.get('Email') != NULL)
                                    account.E_mail__c = (String)accountMap.get('Email');
                                if(accountMap.containsKey('Address') && accountMap.get('Address') != NULL)
                                    account.BillingStreet = (String)accountMap.get('Address');
                                if(accountMap.containsKey('State') && accountMap.get('State') != NULL)
                                    account.BillingState = (String)accountMap.get('State');
                                if(accountMap.containsKey('City') && accountMap.get('City') != NULL)
                                    account.BillingCity = (String)accountMap.get('City');                                
                                if(accountMap.containsKey('BusinessModel') && accountMap.get('BusinessModel') != NULL)
                                    account.Business_Model__c = (String)accountMap.get('BusinessModel');
                                if(accountMap.containsKey('SalesTerritory') && accountMap.get('SalesTerritory') != NULL)
                                    account.Sales_Terriotory__c = (String)accountMap.get('SalesTerritory');
                                if(accountMap.containsKey('SalesRegion') && accountMap.get('SalesRegion') != NULL)
                                    account.Sales_Region__c = (String)accountMap.get('SalesRegion');
                                if(accountMap.containsKey('PartnerCategory') && accountMap.get('PartnerCategory') != NULL)
                                    account.Partner_Category__c = (String)accountMap.get('PartnerCategory');               
                                if(accountMap.containsKey('Affiliation') && accountMap.get('Affiliation') != NULL)
                                    account.Affiliation__c = (String)accountMap.get('Affiliation');               
                                if(accountMap.containsKey('Alias') && accountMap.get('Alias') != NULL)
                                    account.Alias__c = (String)accountMap.get('Alias');               
                                if(accountMap.containsKey('status') && accountMap.get('status') != NULL)
                                    account.Status__c = (String)accountMap.get('status');
                              //  if(accountMap.containsKey('lat') && accountMap.get('lat') != NULL)
                               //     account.Office_Geolocation__Latitude__s= Decimal.valueOf((String)accountMap.get('lat'));    
                              //  if(accountMap.containsKey('long') && accountMap.get('long') != NULL)
                                //    account.Office_Geolocation__Longitude__s = Decimal.valueOf((String)accountMap.get('long')); 
                                if(accountMap.containsKey('LandlineNo') && accountMap.get('LandlineNo') != NULL)
                                    account.Landline_No__c =String.valueOf(accountMap.get('LandlineNo')); 
                                    
                                if(mapToEmpIdToUserId != NULL && mapToEmpIdToUserId.size() > 0)
                                    if(mapToEmpIdToUserId.containsKey((String)accountMap.get('UpdatedSalesManager')))
                                        account.OwnerId = mapToEmpIdToUserId.get((String)accountMap.get('UpdatedSalesManager'));
                                
                                accountList.add(account);
                                
                                
                                
                                
                                if(accountMap.containsKey('contactName') && accountMap.get('contactName') != NULL){
                                    Contact con=new Contact();
                                    con.account=account;
                                    con.lastName =String.valueOf(accountMap.get('contactName'));
                                    if(accountMap.containsKey('ContactNumber') && accountMap.get('ContactNumber') != NULL)
                                        con.Phone =String.valueOf(accountMap.get('ContactNumber'));
                                    if(accountMap.containsKey('ContactEmail') && accountMap.get('ContactEmail') != NULL)
                                        con.Email =String.valueOf(accountMap.get('ContactEmail'));
                                   
                                    conlist.add(con);
                                }
                            }
                        }
                        
                        List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        String ids='';
                        
                        if(accountList != NULL && accountList.size() > 0){
                            Database.UpsertResult[] results = Database.upsert(accountList,Account.LIMS_Code__c,false);
                           
                            Database.UpsertResult[] contactlist = Database.upsert(conList,false);

                            for(Integer i=0;i<results.size();i++){
                                if(!results[i].isSuccess()){
                                    API_Error_Log__c apiError = new API_Error_Log__c();
                                    apiError.API_Name__c = 'LIMS Centre Update';
                                    apiError.Error_Message__c = String.valueOf(results[i].getErrors());
                                    apiError.Trigger_Point__c = 'limsCenterUpdate';
                                    apiError.Record_Identifier__c = '{"Centre Code" : "'+accountList[i].LIMS_Code__c+'"}';
                                    listApiErrorLog.add(apiError); 
                                }
                                else 
                                    ids += results[i].getId() + ',';
                            }
                        }
                        
                        if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            insert listApiErrorLog;
                        
                        ids = ids.removeEnd(',');
                        String jsonStr = '{"success" : true,"message" : "Account Created Successfully","ids" :"'+ids+'"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;                        
                    }
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
}