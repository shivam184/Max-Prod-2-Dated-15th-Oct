/*created by : Nitya(IRT)
* Created Date :10th March 2022
* Purpose: Common API for Max Digital Process
*/
@RestResource(urlMapping='/MaxDigitalLead/*')
global class DigitalLeadApi {
    @HttpPOST
    global static void createCase(){
        RestRequest request = RestContext.request;
        //system.debug('request.requestBody.toString()--->'+request.requestBody.toString());
        Map<String,object> mapKeyToValue = (Map<String,object>)JSON.deserializeUntyped(request.requestBody.toString());
        List<Object> listObject = (List<Object>)mapKeyToValue.get('Data');
        // system.debug(listObject);
        List<case> caseList=new List<case>();
        for(integer i=0;i<listObject.size();i++){
            Map<String,Object> caseMap = (Map<String,Object>)listObject[i];
            if(!caseMap.isEmpty()&& caseMap.keyset().size()>0){
                case c=new case();
                if(caseMap.containsKey('Name')&& caseMap.get('Name')!=null)
                    c.Patient_Name__c=(string)caseMap.get('Name');
                if(caseMap.containsKey('Hospital Location')&& caseMap.get('Hospital Location')!=null)
                    c.Hospital_Name__c=(string)caseMap.get('Hospital Location');
                if(caseMap.containsKey('Mobile Phone')&& caseMap.get('Mobile Phone')!=null)
                    c.Mobile_Phone__c=(string)caseMap.get('Mobile Phone');
                if(caseMap.containsKey('Doctor Name')&& caseMap.get('Doctor Name')!=null)
                    c.Doctor_Name__c=(string)caseMap.get('Doctor Name');
                if(caseMap.containsKey('Specialty')&& caseMap.get('Specialty')!=null)
                    c.Speciality__c=(string)caseMap.get('Specialty');
                if(caseMap.containsKey('Campaign')&& caseMap.get('Campaign')!=null)
                    c.Campaign__c=(string)caseMap.get('Campaign');
                if(caseMap.containsKey('Lead Source')&& caseMap.get('Lead Source')!=null)
                    c.Lead_Source__c=(string)caseMap.get('Lead Source');
                if(caseMap.containsKey('Lead Sub Source')&& caseMap.get('Lead Sub Source')!=null)
                    c.Sub_Source__c=(string)caseMap.get('Lead Sub Source');
                if(caseMap.containsKey('Lead Channel')&& caseMap.get('Lead Channel')!=null)
                    c.Lead_Channel__c=(string)caseMap.get('Lead Channel');
                if(caseMap.containsKey('Email')&& caseMap.get('Email')!=null)
                    c.Email__c=(string)caseMap.get('Email');
                if(caseMap.containsKey('Description')&& caseMap.get('Description')!=null)
                    c.Description=(string)caseMap.get('Description');
                caseList.add(c);
            }
        }
        
        /*insert caseList;
return 'Record inserted successfully';*/
        Database.saveResult[] srList=Database.insert(caseList,false);
        list<API_Error_Log__c> errorRecords=new list<API_Error_Log__c>();
        String JsonResponse='';
        for(database.SaveResult result:srList){
            if(result.isSuccess()){
                JsonResponse+=result;
            }
            else{
                for(Database.Error err : result.getErrors()) {
                    API_Error_Log__c error=new API_Error_Log__c();
                    error.API_Name__c='Allied Healthcare API';
                    error.Error_Message__c=err.getMessage();
                    error.Trigger_Point__c='Allied Healthcare API';
                    error.Record_Identifier__c=json.serialize(err.getFields());
                    errorRecords.add(error);
                    JsonResponse+=result;
                }
            }
        }
        if(errorRecords.size()>0) 
            insert errorRecords;
        RestContext.response.responseBody = Blob.valueOf(JsonResponse);
        
    }
}