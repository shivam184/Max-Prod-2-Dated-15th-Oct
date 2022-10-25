//public class CMPBatch3 //Description: Batch Class to register patient in Max HIS system and generate Max IDs. 
// Also, to generate membership Id of the registered patients
//Created By: Techmatrix Consulting 


global class CMPBatch3 implements Database.Batchable<sObject>, Database.AllowsCallouts,Database.Stateful
    {
     global String query;
     global List<Id> LeadToUpdateMemberId;
    
    global CMPBatch3()
    {
        LeadToUpdateMemberId = new List<Id>();
        this.query = system.label.CMP_Batch_Class_Query;
        query+=' WHERE Recordtype.Name=\'CMP\'';
        query+=' AND Membership_Enrolment_Type__c!=null';
        query+=' AND Max_ID__c !=null';
        query+=' AND Want_to_Enrol__c =true';
        query+=' AND Enrollment_Verified__c =\'Yes\'';
        query+=' AND Enrollment_Verified__c=\''+system.label.Verified_Enrolment+'\'';
        query+=' AND Member_ID__c=null' ;
        
        
    }
    
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext batchContext){
        return Database.getQueryLocator(query);
    }
    
    
    //Execute Method
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
            else
                leadObjList.add(leadObj);  
        }
        
        
        //Fill User and Federation ID Map
        map<Id,User> userIdMap = new map<Id,User>([SELECT Id,FederationIdentifier,Business_Unit__c FROM User]);
        //Comment by icon on 9-12-2021
        //  WHERE UserRole.Name like : 'CMP%']);
        
        //Fill HIS ID Map
        map<String,String> userLocationIdMap = new map<String,String>();
        for(Business_Unit__c location : [SELECT Name,HIS_ID__c,Active__c FROM Business_Unit__c WHERE Active__c=True]){
            if(String.isNotBlank(location.HIS_ID__c))
                userLocationIdMap.put(location.Name, location.HIS_ID__c);
        }
        
        //Leads without Max IDs
        
        //Fetch Plan IDs for all Business Unit
        map<String,String> planIDMap = new map<String, String>();
        for(CMP_Enrolment_Program__mdt cmp : [SELECT Business_Unit_HIS__c,Membership_Enrolment_Type__c,Plan_ID__c FROM CMP_Enrolment_Program__mdt]){
            if(String.isNotBlank(cmp.Business_Unit_HIS__c) && String.isNotBlank(cmp.Plan_ID__c) && String.isNotBlank(cmp.Membership_Enrolment_Type__c)){
                List<String> keyList=cmp.Membership_Enrolment_Type__c.split(';');
                List<String> planIdList=cmp.Plan_ID__c.split(';');
                for(Integer i=0;i<keyList.size();i++){
                    String newkey=cmp.Business_Unit_HIS__c+'-'+keyList[i];
                    planIDMap.put(newKey,planIdList[i]);
                }
            }
                
        }
        
        String today = String.valueOf(system.today());
        List<String> dateList = today.split('-');
        String stDt = dateList[1]+'/'+dateList[2]+'/'+dateList[0];
        String enDt = dateList[1]+'/'+dateList[2]+'/'+String.valueOf(Integer.valueOf(dateList[0])+10);
        
        String stDt2 = dateList[1]+'/'+dateList[2]+'/'+String.valueOf(Integer.valueOf(dateList[0])+1);
        String enDt2 = dateList[1]+'/'+dateList[2]+'/'+String.valueOf(Integer.valueOf(dateList[0])+11);
        
        map<Id,Account> doctorIdMap = new map<Id,Account>();
        
        //Inserting Membership for all Leads after generating Max IDs 
        if(leadObjList!=null && leadObjList.size()>0){
            for(Lead__c obj : leadObjList){
                
                system.debug('=====obj.Max_ID__c=='+obj.Max_ID__c);
                if(String.isNotBlank(obj.Max_ID__c)){
                    
                    
                    
                    OutboundAPIUtilityController.fetchDetailsFromMetadata(system.label.Membership_Insert);
                    String endpoint = OutboundAPIUtilityController.endpoint;
                   // system.debug('=====endpoint=='+endpoint);
                    String apikeyHeader = OutboundAPIUtilityController.apikeyHeader;
                    //system.debug('=====apikeyHeader=='+apikeyHeader);
                    String timeStampHeader = OutboundAPIUtilityController.timeStampHeader;
                    //system.debug('=====timeStampHeader=='+timeStampHeader);

                    String signatureHeader = OutboundAPIUtilityController.signatureHeader;
                    //system.debug('=====signatureHeader=='+signatureHeader);

                    String dtFormat = OutboundAPIUtilityController.dtFormat;
                    //system.debug('=====dtFormat=='+dtFormat);

                    String api_key = OutboundAPIUtilityController.api_key;
                    //system.debug('=====api_key=='+api_key);

                    
                    
                    String str = obj.Max_ID__c;
                    //system.debug('====str==='+str);
                    list<String> strList = str.split('\\.');
                    
                    
                    String searchValue = strList[1]+'|'+strList[0];
                    system.debug('Business_Unit__c :-'+obj.Business_Unit__c);
                    //obj.Business_Unit__c='Max Saket';
                    obj.Business_Unit__c='Max Bathinda';
                    if(String.isNotBlank(obj.Business_Unit__c) && planIDMap.containsKey(obj.Business_Unit__c +'-'+ obj.Membership_Enrolment_Type__c))
                        searchValue+='|'+planIDMap.get(obj.Business_Unit__c +'-'+ obj.Membership_Enrolment_Type__c);
                    
                    String signature = OutboundAPIUtilityController.generateSignature(system.label.Membership_Insert,searchValue);
                    system.debug('====signature==='+signature);

                    
                    //Constructing the body 
                    String body = '{"RegistrationNo":'+Integer.valueOf(strList[1])+',';
                    body+='"IACode":"'+strList[0]+'",';
                    
                    if(String.isNotBlank(obj.Business_Unit__c) && planIDMap.containsKey(obj.Business_Unit__c +'-'+ obj.Membership_Enrolment_Type__c))
                        body+='"PlanID":'+Integer.valueOf(planIDMap.get(obj.Business_Unit__c+'-'+obj.Membership_Enrolment_Type__c))+',';
                    
                    
                    body+='"StartDateTime":"'+stDt+' 00:00:01",';
                    body+='"EndDateTime":"'+enDt+' 23:59:59",';
                    body+='"Amount":'+Integer.valueOf('0')+',';
                    
                    if(!test.isRunningTest()){
                        if(userIdMap.containsKey(obj.OwnerId)){
                            if(String.isNotBlank(userIdMap.get(obj.OwnerId).Business_Unit__c))
                                if(userLocationIdMap.containsKey(userIdMap.get(obj.OwnerId).Business_Unit__c))
                            {
                                body+='"HospitalID":'+Integer.valueOf(userLocationIdMap.get(userIdMap.get(obj.OwnerId).Business_Unit__c))+',';
                            }
                            //String userId = userIdMap.get(obj.OwnerId).FederationIdentifier;
                            //userId = userId.substring(1,userId.length());
                            
                            body+='"OperatorID":'+Integer.valueOf('1')+',';
                        }
                    }
                    else{
                        body+='"OperatorID":'+Integer.valueOf('012888')+',';
                        body+='"HospitalID":'+Integer.valueOf('15')+',';
                    }
                    
                    body+='"AFPDoctorID":'+Integer.valueOf('2')+',';
                    body+='"IPFlag":'+Integer.valueOf('1')+','; 
                    body+='"IPStartDateTime":"'+stDt2+' 00:00:01",'; 
                    body+='"IPEndDateTime":"'+enDt2+' 23:59:59",';
                    body+='"Source":"'+api_key+'",';
                    if(obj.CMP_SF_ID__c !=NULL)
                    body+='"RequestNo":"'+obj.CMP_SF_ID__c+'",';
                    else 
                    body+='"RequestNo":"'+obj.SF_Relationship_ID__c+'",';

                    body+='"Additional":[]}';
                    
                    
                    system.debug('Body--->'+body);
                    
                    system.debug('signatureHeader--->'+signatureHeader);
                    system.debug('signature--->'+signature);
                    system.debug('endpoint--->'+endpoint);
                    system.debug('timeStampHeader--->'+timeStampHeader);
                    system.debug('apikeyHeader--->'+apikeyHeader);
                    system.debug('api_key--->'+api_key);
                    system.debug('signatureHeader--->'+signatureHeader);
                     system.debug('signatureHeader--->'+system.now().format(dtFormat));
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
                        system.debug('=====response==='+response);
                        response = http.send(request);
                    }
                    else{
                        system.debug('===raghav===');
                        response.setStatusCode(200);
                        response.setBody('{"Code":1,  "MemebershipNumber":"HPMOH7", "Message":"Membership Generated!", "Status":"Success"}');
                    }
                    
                    if(response.getStatusCode()==200){  
                        if(response.getBody()!=null){
                            map<String,Object> responseMap =  (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                            //system.debug('responseMap--->'+responseMap);
   system.debug('=====response==='+ responseMap.containsKey('Status'));
                                                      
                            if(responseMap.containsKey('Status')){
                                 system.debug('=====response==='+ responseMap.get('Status'));
   system.debug('responseMap--->'+responseMap);
                                if(responseMap.get('Status')=='Success'){
                                    Lead__c newObj = new Lead__c();
                                    newObj.Id = obj.Id;
                                    newObj.Max_ID__c = obj.Max_Id__c;
                                    newObj.Member_ID__c = (String)responseMap.get('MemebershipNumber');
                                      system.debug('=====response==='+responseMap.get('MemebershipNumber'));

                                    if(String.isNotBlank(obj.Business_Unit__c) && planIDMap.containsKey(obj.Business_Unit__c +'-'+ obj.Membership_Enrolment_Type__c))
                                        newObj.Plan_ID__c = planIDMap.get(obj.Business_Unit__c +'-'+ obj.Membership_Enrolment_Type__c);
                                    leadToUpdate.add(newObj);                                    
                                }
                                
                            }
                            
                        }
                    }  
                }
            }
        }
        
        //Update details in leads
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
    
    
    //Finish Method
    //Added by Raghav to send SMS when Member Id Update
    global void finish(Database.BatchableContext context){
        
    }
}