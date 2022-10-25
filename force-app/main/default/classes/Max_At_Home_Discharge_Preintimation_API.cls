//Description : Update the lead Existing records on the basis of IPID and Hospital location
//Created By : Prashant Gahlaut
@RestResource(urlMapping = '/dischargepreintimation/*')
global class Max_At_Home_Discharge_Preintimation_API {
    
    @HttpPOST
    global static void updaterecAPI(){
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class);
            
            if(requestBody.Data != NULL && requestBody.Data.size() > 0){
                List<Lead__c> listToUpdate = new List<Lead__c>();
                set<String> ipIds = new set<String>();
                set<String> businessUnits = new set<String>(); 
                map<string,String> docmap= new map<string,String>();
                map<String,lead__c> admDataMap = new map<String,lead__c>();
                String leadId;
                string recordtypeId= Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();
                List<Lead__c> listLead = new List<Lead__c>();
                
                
                for(Integer i=0;i<RequestBody.Data.size();i++) {
                    system.debug('=====RequestBody'+ requestBody.Data[i].IPID);
                    
                    Lead__c lead = new Lead__c();
                    
                    
                    if(String.isNotBlank(requestBody.Data[i].DoctorID))
                        lead.DoctorId__c = requestBody.Data[i].DoctorID;
                    if(String.isNotBlank(recordtypeId))
                        lead.RecordTypeId = recordtypeId;
                    if(String.isNotBlank(requestBody.Data[i].IPID))
                        lead.IPID__c = requestBody.Data[i].IPID;
                    if(String.isNotBlank(requestBody.Data[i].HospitalID))
                        lead.Hospital_Location__c = requestBody.Data[i].HospitalID;
                    if(String.isNotBlank(requestBody.Data[i].DoctorName))
                        lead.Doctor_Name__c = requestBody.Data[i].DoctorName;
                    if(String.isNotBlank(requestBody.Data[i].StationID))
                            lead.StationID__c = requestBody.Data[i].StationID;
                    if(String.isNotBlank(requestBody.Data[i].StationName))
                        lead.StationName__c = requestBody.Data[i].StationName;
                    if(String.isNotBlank(requestBody.Data[i].UserID))
                        lead.UserID__c = requestBody.Data[i].UserID;
                    if(String.isNotBlank(requestBody.Data[i].UserName))
                        lead.UserName__c = requestBody.Data[i].UserName;
                    if(String.isNotBlank(requestBody.Data[i].MaxID))
                        lead.Max_ID__c = requestBody.Data[i].MaxID;
                    if(String.isNotBlank(requestBody.Data[i].ReqDisDatetime)){
                        Date dt = Date.valueOf(requestBody.Data[i].ReqDisDatetime);
                        lead.Request_Discharge_Date__c = Datetime.newInstance(dt.year(), dt.month(), dt.day(),0,0,0);
                    }
                    if(String.isNotBlank(requestBody.Data[i].ProposedDischargeDate)){
                        Date dt = Date.valueOf(requestBody.Data[i].ProposedDischargeDate);
                        lead.Proposed_Discharge_Date__c = Datetime.newInstance(dt.year(), dt.month(), dt.day(),0,0,0);
                    }
                    String key='';
                    
                    if(lead.IPID__c!=null){
                        ipIds.add(lead.IPID__c);
                        key = lead.IPID__c;
                    }
                    
                    if(lead.Hospital_Location__c!=null){
                        businessUnits.add(lead.Hospital_Location__c);
                        key+='-'+lead.Hospital_Location__c;
                    }
                    admDataMap.put(key, lead);
                    docmap.put(lead.DoctorId__c,null);
                    
                }
                
                map<String,Id> existingAdmMap = new map<String,Id>();
                map<string,string> businesmap= new map <string, string>();
                
                if(docmap!=null && docmap.size()>0){
                    for(Account acc : [select id,name,alletec_doctorid__c from account where RecordType.Name =:'Doctor'
                                       And alletec_doctorid__c in: docmap.keyset() ]){
                                           
                                           docmap.put(acc.alletec_doctorid__c,acc.id);
                                       }
                }
                system.debug('====>businessUnits='+businessUnits);
                
                if ( businessUnits!=null && businessUnits.size()>0){
                    for(Business_Unit__c bs : [select name,HIS_ID__c from Business_Unit__c where HIS_ID__c in : businessUnits]){
                        
                        businesmap.put(bs.HIS_ID__c,bs.name);
                    }
                    
                }
                
                
                if(ipIds!=null && ipIds.size()>0 && businessUnits!=null && businessUnits.size()>0){
                    for(lead__c ld : [SELECT Id,IPID__c,Hospital_Location__c FROM lead__c WHERE 
                                      IPID__c in: ipIds and Hospital_Location__c in: businessUnits
                                      and RecordType.Name IN ('Max@Home')]){
                                          system.debug('====>ld='+ld);
                                          system.debug('====>ld.IPID__c=='+ld.IPID__c);
                                          system.debug('====>ld.Hospital_Location__c=='+ld.Hospital_Location__c);
                                          
                                          if(ld.IPID__c!=null && ld.Hospital_Location__c!=null)
                                              existingAdmMap.put(ld.IPID__c+'-'+ld.Hospital_Location__c,ld.Id);
                                      }
                }
                system.debug('=====>admDataMap='+admDataMap);
                system.debug('=====>existingAdmMap='+existingAdmMap);
                system.debug('=====>admDataMap.keySet()='+admDataMap.keySet());
                ApiResponse ars = new ApiResponse();
                ars.success ='true';
                List<msgClass> msg1=new List<msgClass>();
                if(admDataMap!=null && admDataMap.size()>0){
                    for(String admNewKey : admDataMap.keySet()){
                        system.debug('=====>admNewKey='+admNewKey);
                        
                        if(existingAdmMap.containsKey(admNewKey)){
                            system.debug('====>Key2222='+existingAdmMap.get(admNewKey));
                            
                            admDataMap.get(admNewKey).Id = existingAdmMap.get(admNewKey);
                            system.debug('====>Key1111='+admDataMap.get(admNewKey).Id);
                            
                            string key = admNewKey.split('-')[1];
                            system.debug('====>Key='+Key);
                            if(businesmap.containsKey(key) && businesmap.get(key)!=null)
                                admDataMap.get(admNewKey).Business_Unit__c = businesmap.get(key);
                            
                            if( admDataMap.get(admNewKey).doctorId__c != null){
                                if(docmap.containskey(admDataMap.get(admNewKey).doctorId__c)){
                                    admDataMap.get(admNewKey).Doctor__c = docmap.get(admDataMap.get(admNewKey).doctorId__c);
                                }
                            }
                            system.debug('=====>admDataMap1='+admDataMap.get(admNewKey));
                            listToUpdate.add(admDataMap.get(admNewKey));                           
                        }
                        else{
                            msgClass ms= new msgClass();
                            ms.message = 'Not Found '+admNewKey;
                            msg1.add(ms);
                            ars.success ='false';
                        }
                    }
                }
                ars.DataDetail = msg1;
                String ids='';
                if(listToUpdate != NULL && listToUpdate.size() > 0) {
                    Database.SaveResult[] srList = Database.update(listToUpdate,false);
                    List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                    
                    for(Integer i=0;i<srList.size();i++){
                        if(!srList[i].isSuccess()){
                            API_Error_Log__c apiError = new API_Error_Log__c();
                            apiError.API_Name__c = 'Admission Acknowlegdement';
                            apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                            apiError.Trigger_Point__c = 'createadmissionack';
                            apiError.Record_Identifier__c = '{"IPID" : "'+listToUpdate[i].IPID__c+'","Hospital Location" : "'+listToUpdate[i].Hospital_Location__c+'"}';
                            msgClass ms= new msgClass();
                            ms.message = 'Error in update '+listToUpdate[i].IPID__c+'-'+listToUpdate[i].Hospital_Location__c;
                             ars.success ='false';
                            msg1.add(ms);
                            listApiErrorLog.add(apiError); 
                        }
                        else{ 
                            ids += srList[i].getId() + ',';
                            msgClass ms= new msgClass();
                            ms.message = 'Lead Updated successfully '+listToUpdate[i].IPID__c+'-'+listToUpdate[i].Hospital_Location__c;
                            ms.LeadId = srList[i].getId();
                            msg1.add(ms);
                        }
                        system.debug('====>='+ids);
                        
                    }
                    ars.DataDetail = msg1;
                    system.debug(JSON.serialize(ars));
                    ids = ids.removeEnd(',');
                    /*if(listApiErrorLog != NULL && listApiErrorLog.size() > 0){
                        insert listApiErrorLog;
                        String jsonStr = '{"success" : false,"message" : "one of the data does not match with any of records"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                        }
                        else if(listApiErrorLog.size() == 0) {
                        String jsonStr = '{"success" : true,"message" : "Lead Updated successfully","ids":"'+ids+'"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                        }*/
                    
                }
                /*else{                    
                String jsonStr = '{"success" : false,"message" : "Body data does not match with any of records"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
                
                }*/
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(ars));
                return;
                
                
            }
        }
    }
    
    
    public class RequestBody {
        public List<DischargeData> Data;
        
        public RequestBody() {
            Data = new List<DischargeData>();
        }
    }
    public class DischargeData{
        public String IPID;
        public string HospitalID;
        public string DoctorID;
        public string DoctorName;
        public string StationID;
        public string StationName;
        public string UserID;
        public string UserName;
        public string MaxID;
        public string ReqDisDatetime;
        public string ProposedDischargeDate;
        
    }
    public class msgClass{
        public string message;
        public string LeadId; 
        public msgClass(){
            LeadId='';
        }
    }
    public class ApiResponse{
        public string success;
        public List<msgClass> DataDetail;
    }
}