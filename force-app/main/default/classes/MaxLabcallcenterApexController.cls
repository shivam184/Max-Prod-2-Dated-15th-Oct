public class MaxLabcallcenterApexController {
    @AuraEnabled(cacheable=true)
    public static WrapperClass getPatientForMobileNumber(String searchId) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            
            String res = getUserInfo(searchId);
           // if(res=='New'){
                List<Lead__c> listPatient = [SELECT Id,Title__c,Name,(SELECT Location_Name__c,CreatedDate,Call_Type__c,Service__c 
                                                                      FROM Max_Lab_Call_History__r 
                                                                      ORDER BY CreatedDate DESC LIMIT 5),Age__c,Gender__c,Email__c,Mobile_Phone__c FROM Lead__c 
                                             WHERE RecordType.Name = 'Max Labs Call Center' AND Mobile_Phone__c=:searchId];
                
                if(listPatient != NULL && listPatient.size() >  0) {
                    wrpCls.listPatient = listPatient;
                    if(listPatient[0].Max_Lab_Call_History__r.size() > 0)
                        wrpCls.listCallDetails = listPatient[0].Max_Lab_Call_History__r;
                    
                }
            //}
            
            wrpCls.status = 'SUCCESS';
            return wrpCls;     
        }catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
    }
    @AuraEnabled(cacheable=true)
    public static CallTypeWrapper getCallTypeApex() {
        CallTypeWrapper callWrpCls = new CallTypeWrapper();
        try {
            for(MaxlabCallTypeMetadata__mdt callType : [SELECT Label,Call_Type__c,Order__c FROM MaxlabCallTypeMetadata__mdt ORDER BY Order__c]) {
                callWrpCls.listMapKeys.add(callType.Label);    
                callWrpCls.mapCallTypeToService.put(callType.Label,callType.Call_Type__c.split(','));
            }
            callWrpCls.status = 'SUCCESS';
            return callWrpCls;
            
        }
        catch(Exception e) {
            callWrpCls.status = e.getMessage();
            return callWrpCls;
        }
    }
     @AuraEnabled
    public static String saveDataApex(String callingMobileNo,String mobileNo,String contactName,String contactSalutation,String contactAge,String contactGender,String contactEmail,String contactAlternateNumber,String selectedCallType,String selectedService,String disconnectionType,String selectedLocationId,String remarks,String selectedAppointment,String ltngCurrTime,String currentTime,Boolean newContact) {
        TriggerExecutions__c triggercheck = TriggerExecutions__c.getOrgDefaults();
            String parentId = '';
            System.debug('newContact-->>>>>>'+newContact);
        if(!newContact) {
            if(String.isNotBlank(contactName) && String.isNotBlank(callingMobileNo)) {
                String query = 'SELECT Id FROM Lead__c WHERE RecordType.Name = \'Max Labs Call Center\' AND Mobile_Phone__c = :callingMobileNo';
                List<Lead__c> listLead = Database.query(query);
                if(listLead != NULL && listLead.size() > 0)
                    parentId = listLead[0].Id;
                else {
                    parentId = createLead(contactSalutation,callingMobileNo,contactAge,contactGender,contactEmail,contactName);
                }
            }
        }else {
            parentId = createLead(contactSalutation,callingMobileNo,contactAge,contactGender,contactEmail,contactName);    
        }
            
            if(String.isNotBlank(parentId)) {
                System.debug(selectedCallType);
                if(String.isNotBlank(selectedCallType)) {
                   Map<Id,Business_Unit__c> mapBusinessUnit = new Map<Id,Business_Unit__c>([SELECT Id,Name,Unit_Name_Custom__c FROM Business_Unit__c]);
                    Max_Lab_Call_History__c mxbhstry = new Max_Lab_Call_History__c();
                    mxbhstry.Call_Start_Time__c = String.valueOf(System.today()) +' '+currentTime; 
                    mxbhstry.Name = contactName;
                    mxbhstry.Call_Time__c = ltngCurrTime;
                    if(String.isNotBlank(callingMobileNo))
                        mxbhstry.Calling_Number__c = callingMobileNo;
                   
                    mxbhstry.Call_Type__c = selectedCallType;
                    mxbhstry.Service__c = selectedService;
                    
                    if(selectedCallType == 'Blank Call') 
                        mxbhstry.DisconnectionType__c =  disconnectionType;   
                    if(String.isNotBlank(selectedLocationId)) {
                        if(mapBusinessUnit != NULL && mapBusinessUnit.keySet().size() > 0 && mapBusinessUnit.containsKey(selectedLocationId)) {
                            
                            mxbhstry.Location_Name__c = mapBusinessUnit.get(selectedLocationId).Name;
                            mxbhstry.Business_Unit__c = mapBusinessUnit.get(selectedLocationId).Unit_Name_Custom__c; 

                        }
                    }
                    
                    
                    mxbhstry.Remarks__c = remarks;
                    if(String.isNotBlank(callingMobileNo))
                        mxbhstry.Leads__c = parentId;
                        
                    insert mxbhstry;
                    System.debug('Id-->'+mxbhstry.Id);
                }    
            }
            return 'Record Created Successfully';     
    }
    public static String createLead(String contactSalutation,String callingMobileNo,String contactAge,String contactGender,String contactEmail,String contactName) {
        Lead__c lea = new Lead__c();
        String recordTypeIdLead = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
        if(String.isNotBlank(recordTypeIdLead))
            lea.RecordTypeId = recordTypeIdLead;
        lea.Title__c = contactSalutation;
        lea.Mobile_Phone__c = callingMobileNo;
        lea.Gender__c = contactGender;
        lea.Email__c = contactEmail;
        lea.Name = contactName;
        insert lea;  
        return lea.Id;
    }
   
    public static String getUserInfo(String phoneno){
        String body = '';
        
        try{
            if(phoneno!=null && phoneno!='')
                body='"Mobile No":'+phoneno+'';
            Http hreq = new Http();
            HttpRequest req = new HttpRequest();
            String url = 'http:';
            req.setEndpoint(url);
            req.setHeader('Content-Type', 'application-json');
            req.setHeader('User-Agent', 'M022433');
            req.setHeader('Content-Length', '1574');
            req.setHeader('Authorization', 'Basic  TTAyMjQzMzpQYXNzdzByZA==');
            req.setHeader('Host', '10.208.122.35');
            req.setHeader('Password', 'Passw0rd');
            req.setBody(body);
            HttpResponse res = hreq.send(req);
            
            
            if(res.getStatusCode()==200){
                String str = res.getBody();
                if(String.isNotBlank(str)){
                    Map<String,Object> mapKeyToValue = (Map<String,Object>)Json.deserializeUntyped(str);
                    if(mapKeyToValue!=null && mapKeyToValue.keySet().size() > 0){
                        return  (string)mapKeyToValue.get('Caller Type');
                    }
                }
                return 'Response Is Empty';
            }
            return res.getStatusCode()+'';
        }catch(Exception e){
            return e.getMessage();
        }
        
    }
    
    public class WrapperClass {
         @AuraEnabled
        public string status;
        @AuraEnabled
        public List<Lead__c> listPatient;
        @AuraEnabled
        public List<Max_Lab_Call_History__c> listCallDetails;
        @AuraEnabled
        public Integer probability;
        @AuraEnabled
        public List<Billing_Summary__c> listTransactions;
        @AuraEnabled
        public String preferredChannel;
        @AuraEnabled
        public Integer conversionProbability;
        
        public WrapperClass() {
            status = '';
            listPatient = new List<Lead__c>();
            listCallDetails = new List<Max_Lab_Call_History__c>();
            probability = 0;
            listTransactions = new List<Billing_Summary__c>();
            preferredChannel = '';
            conversionProbability = 0;
        }
    }
    public class CallTypeWrapper {
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Map<String,List<String>> mapCallTypeToService;
        @AuraEnabled
        public List<String> listMapKeys;
       
        
        public CallTypeWrapper() {
            status = '';
            mapCallTypeToService = new Map<String,List<String>>();
            listMapKeys = new List<String>();
           
        }        
        
    }
}