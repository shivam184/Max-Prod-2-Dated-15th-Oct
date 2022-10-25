@RestResource(urlMapping='/updateAdBill/entity/*')
global class UpdateAdAckBillSumApiController {
    @HttpPost
    global static void doUpdateRecords(){
        Savepoint sp = Database.setSavepoint();
        try {
            RestRequest request = RestContext.request;
            String entityName = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            if(String.isNotBlank(request.requestBody.toString())) {
                Map<String,Object> mapKeyToValue = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
                List<Object> listObject = (List<Object>)mapKeyToValue.get('Data');
                if(listObject !=  NULL && listObject.size() > 0) {
                    if(String.isNotBlank(entityName)){
                        if(entityName == Label.AdmissionAcknowledgement){  
                            Map<String,Id> mapHisCodeToHospitalLocationId = new Map<String,Id>();
                            for(Business_Unit__c bUnit :[SELECT Id,HIS_ID__c FROM Business_Unit__c WHERE HIS_ID__c!= NULL]){                                
                                mapHisCodeToHospitalLocationId.put(bUnit.HIS_ID__c,bUnit.Id);
                            }
                            
                            Map<String,Admission_Acknowledgement__c> mapIpidHospitalLocationToAdmAck = new Map<String,Admission_Acknowledgement__c>();
                            Set<String> ipidSet = new Set<String>();
                            Set<String> hospitalLocationSet = new Set<String>();                            
                            for(Integer i=0;i < listObject.size() ; i++) {
                                Map<String,Object> admissionAckMap = (Map<String,Object>)listObject[i];
                                if(admissionAckMap != NULL && admissionAckMap.keySet().size() > 0){
                                    
                                    String ipid='';
                                    String hospitalLocation='';
                                    Admission_Acknowledgement__c admissionAck = new Admission_Acknowledgement__c();
                                    if(admissionAckMap.containsKey('IPID') && admissionAckMap.get('IPID') != NULL ){
                                        
                                        ipid = (String)admissionAckMap.get('IPID');
                                        if(String.isNotBlank(ipid)){    
                                            admissionAck.IPID__c = ipid;
                                            ipidSet.add(ipid);   
                                        }                                            
                                    }
                                    if(admissionAckMap.containsKey('HOSPITALLOCATION') && admissionAckMap.get('HOSPITALLOCATION') != NULL){
                                        
                                        hospitalLocation = (String)admissionAckMap.get('HOSPITALLOCATION');
                                        if(String.isNotBlank(hospitalLocation)) {
                                            if(mapHisCodeToHospitalLocationId.containsKey(hospitalLocation)){
                                                admissionAck.alletec_hospitallocation__c = mapHisCodeToHospitalLocationId.get(hospitalLocation);
                                                hospitalLocationSet.add(mapHisCodeToHospitalLocationId.get(hospitalLocation));                                                 
                                            }                                            
                                        }                                        
                                    }
                                    if(admissionAckMap.containsKey('INTERNATIONAL') && admissionAckMap.get('INTERNATIONAL') != NULL){
                                        
                                        String international = (String)admissionAckMap.get('INTERNATIONAL');
                                        if(String.isNotBlank(international)){
                                            if(international == 'true')
                                                admissionAck.alletec_international__c = true;
                                            if(international == 'false')
                                                admissionAck.alletec_international__c = false;
                                        }
                                    }
                                    if(String.isNotBlank(ipid) && String.isNotBlank(hospitalLocation) && mapHisCodeToHospitalLocationId != NULL && mapHisCodeToHospitalLocationId.containsKey(hospitalLocation))                                        
                                        mapIpidHospitalLocationToAdmAck.put(ipid+'*'+mapHisCodeToHospitalLocationId.get(hospitalLocation),admissionAck);
                                }
                            }
                            
                            if(mapIpidHospitalLocationToAdmAck != NULL && mapIpidHospitalLocationToAdmAck.keySet().size() > 0){   
                                
                                List<Admission_Acknowledgement__c> admissionAcknowledgementUpdateList = new List<Admission_Acknowledgement__c>();
                                if(ipidSet != NULL && ipidSet.size() > 0 && hospitalLocationSet != NULL && hospitalLocationSet.size() > 0){
                                    for(Admission_Acknowledgement__c admAck : [SELECT Id,IPID__c,alletec_hospitallocation__c FROM Admission_Acknowledgement__c WHERE IPID__c IN :ipidSet AND alletec_hospitallocation__c IN :hospitalLocationSet ]){
                                        if(mapIpidHospitalLocationToAdmAck.containsKey(admAck.IPID__c+'*'+admAck.alletec_hospitallocation__c)){                                             
                                            Admission_Acknowledgement__c aAck = mapIpidHospitalLocationToAdmAck.get(admAck.IPID__c+'*'+admAck.alletec_hospitallocation__c);
                                            aAck.Id = admAck.Id;         
                                            if(!admissionAcknowledgementUpdateList.contains(admAck))
                                            	admissionAcknowledgementUpdateList.add(aAck);
                                        }
                                    }
                                }                                                                
                                
                                if(admissionAcknowledgementUpdateList != NULL && admissionAcknowledgementUpdateList.size() > 0){
                                    
                                    Database.SaveResult[] result = Database.update(admissionAcknowledgementUpdateList,false);
                                    String Ids = '';
                                    List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                                    for(Integer i=0;i<result.size();i++){
                                        if(!result[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Admission Acknowledgement Update International';
                                            apiError.Error_Message__c = String.valueOf(result[i].getErrors());
                                            apiError.Trigger_Point__c = 'admission-acknowledgement';
                                            apiError.Record_Identifier__c = '{"IPID" : "'+admissionAcknowledgementUpdateList[i].IPID__c+'","Hospital Location" : "'+admissionAcknowledgementUpdateList[i].alletec_hospitallocation__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += result[i].getId() + ',';
                                    }
                                    
                                    if(String.isNotBlank(ids))
                                        ids = ids.removeEnd(',');
                                    
                                    if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                                        insert listApiErrorLog;
                                    
                                    String jsonStr = '{"success" : true,"message" : "Admission Acknowledgements Updated Successfully!","Ids" : "'+Ids+'"}';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                    return;                                    
                                } 
                                else{
                                    String jsonStr = '{"success" : false,"message" : "Records not Found"}';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                    return;
                                }                                                                    
                            }
                        }
                        else if(entityName == Label.BillingSummary) {
                            Map<String,Billing_Summary__c> mapBillNoTrancTypeToBillSummary = new Map<String,Billing_Summary__c>();
                            Set<String> billNoSet = new Set<String>();
                            Set<String> transactionTypeSet = new Set<String>();
                            for(Integer i=0 ; i < listObject.size() ; i++) {
                                Map<String,Object> billingSummaryMap = (Map<String,Object>)listObject[i];
                                String billNo='';
                                String transactionType='';
                                if(billingSummaryMap != NULL && billingSummaryMap.keySet().size() > 0){
                                    Billing_Summary__c billingSummary = new Billing_Summary__c();
                                    if(billingSummaryMap.containsKey('BILLNO') && billingSummaryMap.get('BILLNO') != NULL){
                                        billNo = (String)billingSummaryMap.get('BILLNO');
                                        if(String.isNotBlank(billNo)){   
                                            billingSummary.invoicenumber__c = billNo;
                                            billNoSet.add(billNo);
                                        }                                                                                    
                                    }
                                    if(billingSummaryMap.containsKey('TRANSACTIONTYPE') && billingSummaryMap.get('TRANSACTIONTYPE') != NULL){
                                        transactionType = (String)billingSummaryMap.get('TRANSACTIONTYPE');
                                        if(String.isNotBlank(transactionType)){  
                                            billingSummary.alletec_transactiontype__c = transactionType;
                                            transactionTypeSet.add(transactionType);   
                                        }                                            
                                    }
                                    if(billingSummaryMap.containsKey('INTERNATIONAL') && billingSummaryMap.get('INTERNATIONAL') != NULL){
                                        String international = (String)billingSummaryMap.get('INTERNATIONAL');
                                        if(String.isNotBlank(international)){
                                            if(international == 'true')
                                                billingSummary.alletec_isinternational__c = true;
                                            if(international == 'false')
                                                billingSummary.alletec_isinternational__c = false;
                                        }                                                                                
                                    }
                                    
                                    if(billNo != NULL && transactionType != NULL)
                                        mapBillNoTrancTypeToBillSummary.put(billNo+'*'+transactionType,billingSummary);
                                }
                            }
                            
                            if(mapBillNoTrancTypeToBillSummary != NULL && mapBillNoTrancTypeToBillSummary.keySet().size() > 0){    
                                List<Billing_Summary__c> billingSummaryUpdateList = new List<Billing_Summary__c>();
                                if(billNoSet != NULL && billNoSet.size() > 0 && transactionTypeSet != NULL && transactionTypeSet.size() > 0){                                     
                                    for(Billing_Summary__c bSummary : [SELECT Id,invoicenumber__c,alletec_transactiontype__c FROM Billing_Summary__c WHERE invoicenumber__c IN :billNoSet AND alletec_transactiontype__c IN :transactionTypeSet]){
                                        if(mapBillNoTrancTypeToBillSummary.containsKey(bSummary.invoicenumber__c+'*'+bSummary.alletec_transactiontype__c)){                                            
                                            Billing_Summary__c bs = mapBillNoTrancTypeToBillSummary.get(bSummary.invoicenumber__c+'*'+bSummary.alletec_transactiontype__c);
                                            bs.Id = bSummary.Id;   
                                            if(!billingSummaryUpdateList.contains(bs))
                                            	billingSummaryUpdateList.add(bs);                                             
                                        }                                                                                                                        	
                                    }                                    
                                }                                     
                                if(billingSummaryUpdateList != NULL && billingSummaryUpdateList.size() > 0){
                                    Database.SaveResult[] result = Database.update(billingSummaryUpdateList,false);
                                    String Ids = '';
                                    List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                                    
                                    for(Integer i=0;i<result.size();i++){
                                        if(!result[i].isSuccess()){
                                            API_Error_Log__c apiError = new API_Error_Log__c();
                                            apiError.API_Name__c = 'Billing Summary Update International';
                                            apiError.Error_Message__c = String.valueOf(result[i].getErrors());
                                            apiError.Trigger_Point__c = 'billing-summary update international';
                                            apiError.Record_Identifier__c = '{"Bill No" : "'+billingSummaryUpdateList[i].invoicenumber__c+'","Transaction Type" : "'+billingSummaryUpdateList[i].alletec_transactiontype__c+'"}';
                                            listApiErrorLog.add(apiError); 
                                        }
                                        else 
                                            ids += result[i].getId() + ',';
                                    }
                                    
                                    Ids = Ids.removeEnd(','); 
                                    
                                    if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                                        insert listApiErrorLog;
                                    
                                    String jsonStr = '{"success" : true,"message" : "Billing Summaries Updated Successfully!","Ids" : "'+Ids+'"}';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                    return;
                                }
                                else{
                                    String jsonStr = '{"success" : false,"message" : "Records not Found"}';
                                    RestContext.response.addHeader('Content-Type', 'application/json');
                                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                                    return;
                                }
                                
                            }                            
                        }
                        else{
                            String jsonStr = '{"success" : false,"message" : "Provide Valid Entity."}';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(jsonStr);
                            return;  
                        }                           
                    }
                    else {
                        String jsonStr = '{"success" : false,"message" : "Provide entity name"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;    
                    }
                }                
                else {
                    String jsonStr = '{"success" : false,"message" : "Provide atleast one record"}';
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
            Database.rollback(sp);
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';            
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return;      
        }
    }
    
}