public class CallCenterDisposalApexController {
    
    @AuraEnabled(cacheable=true)
    public static Boolean getMobileNumberFromUrl(String searchId) {
        List<string> priorityNumbers=Label.Handle_With_Care_Numbers.split(',');
        if(priorityNumbers.contains(searchId))
            return true;
        else
            return false;
    }
    
    @AuraEnabled(cacheable=true) 
    public static WrapperClass getUseridApex(String UserID){
        system.debug(UserID);
        WrapperClass wrpCls = new WrapperClass();
        list<Account > callcentreuserlist= new list<Account >([Select id,Name,AccountNumber from Account  where AccountNumber=:UserID AND RecordType.Name='Call Center Users']); 
        for(Account call:callcentreuserlist){
            wrpCls.UserID = call.Name;
            wrpCls.UniqueID = call.AccountNumber;
            
    }
         return wrpCls;   
    }
    
    @AuraEnabled(cacheable=true)
    public static WrapperClass getPatientForMobileNumber(String searchId,Boolean isPhoneSearch) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            String query = 'SELECT Id,Salutation,Name,Max_Id__c,Age__c,Gender__c,PersonEmail,mobilephone__c FROM Account WHERE RecordType.Name = \'Patient\'';
            if(isPhoneSearch)
                query += ' AND (PersonMobilePhone = :searchId OR mobilephone__c = :searchId)';
            else 
                query += ' AND Max_Id__c = :searchId';
            
            List<Account> listPatient = Database.query(query);
            
            if(listPatient != NULL && listPatient.size() >  1) 
                wrpCls.listPatient = listPatient;
            
            if(listPatient != NULL && listPatient.size() ==  1)
                if(listPatient[0].Max_Id__c != NULL) {
                    WrapperClass wrpClsNew = searchPatientForPicklistApex(listPatient[0].Max_Id__c);
                    wrpCls = wrpClsNew;
                }
            
            //Identifying if search from Phone or Max ID
            if(!isPhoneSearch){
                if(listPatient != NULL && listPatient.size() >  1){ 
                    list<Account> tempList = new list<Account>();
                    tempList.add(listPatient[0]);
                    wrpCls.listPatient = tempList;
                    WrapperClass wrpClsNew = searchPatientForPicklistApex(tempList[0].Max_Id__c);
                    wrpCls = wrpClsNew;
                }
            }
            
            wrpCls.status = 'SUCCESS';
            return wrpCls;     
        }
        catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static CallTypeWrapper getCallTypeApex() {
        CallTypeWrapper callWrpCls = new CallTypeWrapper();
        try {
            for(CallTypeMetadata__mdt callType : [SELECT Label,Service_Type__c,Order__c FROM CallTypeMetadata__mdt ORDER BY Order__c]) {
                callWrpCls.listMapKeys.add(callType.Label);    
                callWrpCls.mapCallTypeToService.put(callType.Label,callType.Service_Type__c.split(','));
            }
            
            for(AppointmentType__mdt appType : [SELECT Label,Source__c FROM AppointmentType__mdt])
                callWrpCls.mapAppTypeToSource.put(appType.Label,appType.Source__c.split(','));
            
            for(ReasonType__mdt reason : [SELECT Label,Source__c FROM ReasonType__mdt])
                callWrpCls.mapReason.put(reason.Label,reason.Source__c.split(','));
            
            for(SubService__mdt subservice : [SELECT Label,Sub_Service__c FROM SubService__mdt])
                callWrpCls.mapServiceToSubService.put(subservice.Label,subservice.Sub_Service__c.split(','));
            
            callWrpCls.status = 'SUCCESS';
            return callWrpCls;
            
        }
        catch(Exception e) {
            callWrpCls.status = e.getMessage();
            return callWrpCls;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static WrapperClass searchPatientForPicklistApex(String maxId) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            String query = 'SELECT Id,Salutation,Name,Max_Id__c,Age__c,Gender__c,PersonEmail,mobilephone__c FROM Account WHERE RecordType.Name = \'Patient\' AND Max_Id__c = :maxId'; 
            List<Account> listPatient = Database.query(query);
            if(listPatient != NULL && listPatient.size()> 0) {
                
                list<Account> tempList = new list<Account>();
                tempList.add(listPatient[0]);
                wrpCls.listPatient = tempList;
                
                List<Lead__c> listCallDetails = new List<Lead__c>();
                Integer count = 1;
                Integer appoitnmentCount = 0;
                Integer totalCount = 0;
                for(Lead__c lead : [SELECT Location_Name__c,Country_Query__c,CreatedDate,Call_Type__c,Service__c 
                                    FROM Lead__c 
                                    WHERE Patient__c = :listPatient[0].Id 
                                    AND RecordType.Name = 'Call Center'
                                    ORDER BY CreatedDate DESC]) {
                                        if(count <= 5)
                                            listCallDetails.add(lead);
                                        
                                        if(String.isNotBlank(lead.Call_Type__c) && lead.Call_Type__c == 'Appointment')
                                            appoitnmentCount++;
                                        
                                        count++;
                                        totalCount++;
                                    }
                
                
                if(listCallDetails != NULL && listCallDetails.size() > 0) {
                    wrpCls.listCallDetails = listCallDetails;
                    wrpCls.probability = Integer.valueOf(((Decimal)appoitnmentCount/totalCount)*100);
                }
                
                List<Billing_Summary__c> listTransactions = new List<Billing_Summary__c>();
                String preferredChannel = '';
                
                for(Billing_Summary__c billingSummary : [SELECT CreatedDate,alletec_channeltype__c,alletec_speciality__r.Name,alletec_hospitallocation__r.Name 
                                                         FROM Billing_Summary__c
                                                         WHERE Patient__c = :listPatient[0].Id
                                                         AND alletec_channeltype__c IN ('PSU','Cash')
                                                         ORDER BY CreatedDate
                                                         LIMIT 5]) {
                                                             listTransactions.add(billingSummary);
                                                             if(billingSummary.alletec_channeltype__c == 'PSU')
                                                                 preferredChannel = 'PSU';    
                                                         }
                
                if(listTransactions != NULL && listTransactions.size() > 0) {
                    wrpCls.listTransactions = listTransactions;
                    if(String.isNotBlank(preferredChannel))
                        wrpCls.preferredChannel = preferredChannel;
                    else
                        wrpCls.preferredChannel = 'Cash';                        
                }
                
                Integer compAppt = 0;
                Integer totalAppt = 0;
                for(Appointment__c app : [SELECT Id,Status__c FROM Appointment__c WHERE Patient__c = :listPatient[0].Id]) {
                    if(app.Status__c == 'Completed')   
                        compAppt++;
                    totalAppt++;
                }
                
                if(totalAppt != 0)
                    wrpCls.conversionProbability = Integer.valueOf(((Decimal)compAppt/totalAppt)*100);
            }
            wrpCls.status = 'SUCCESS';
            return wrpCls;
            
        }
        catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;    
        }
    }
    
    @AuraEnabled
    public static String saveDataApex(String callingMobileNo,String UserID,String mobileNo,String contactName,String contactSalutation,String contactAge,String contactGender,String contactEmail,String contactAlternateNumber,String selectedMaxId,String selectedCallType,String selectedService,String disconnectionType,String selectedLocationId,String selectedCountryId,String remarks,String callBack,String selectedSource,String transferLevel,String selectedStatus,String selectedAppointment,String selectedDoctorId,String valueSublabel,String selectedSourceAppointment,String selectedChannel,String selectedReason,String selectedSubService,String ltngCurrTime,String smsNumber,Boolean sendSMS,Boolean newContact,String currentTime) {
       // system.debug('Remarks'+remarks);
      //  system.debug('=====>selectedSource='+selectedSource);
        //  try{
        id User;
        TriggerExecutions__c triggercheck = TriggerExecutions__c.getOrgDefaults();
        String parentId = '';
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();
        
        if(!newContact) {
            if(String.isNotBlank(selectedMaxId)){
                List<Account> listPatient = [SELECT Id FROM Account WHERE RecordType.Name = 'Patient' AND Max_ID__c = :selectedMaxId];
                if(listPatient != NULL && listPatient.size() > 0)
                    parentId = listPatient[0].Id;    
            }
            else {
                if(String.isNotBlank(contactName) && String.isNotBlank(callingMobileNo)) {
                    String query = 'SELECT Id FROM Contact WHERE RecordType.Name = \'Patient\' AND Phone = :callingMobileNo AND Name LIKE \'%'+contactName+'%\'';
                    List<Contact> listPatient = Database.query(query);
                    if(listPatient != NULL && listPatient.size() > 0)
                        parentId = listPatient[0].Id;
                    else {
                        parentId = createContact(contactSalutation,callingMobileNo,contactAge,contactGender,contactEmail,contactAlternateNumber,contactName);
                    }
                }
            }    
        }
        else {
            parentId = createContact(contactSalutation,callingMobileNo,contactAge,contactGender,contactEmail,contactAlternateNumber,contactName);    
        }
        
        
        if(String.isNotBlank(parentId)) {
            if(String.isNotBlank(selectedCallType)) {
                Map<Id,Business_Unit__c> mapBusinessUnit = new Map<Id,Business_Unit__c>([SELECT Id,Name,Unit_Name_Custom__c FROM Business_Unit__c]);
                Lead__c lead = new Lead__c();
                lead.Call_Start_Time__c = String.valueOf(System.today()) +' '+currentTime; 
                lead.Name = contactName;
                if(String.isNotBlank(UserID)){ 
                     list<Account > callleadsave= new list<Account >([Select Name,AccountNumber from Account  where AccountNumber=:UserID AND RecordType.Name='Call Center Users']); 
                    for(Account call:callleadsave){
                        User = call.id;
                    }
                    lead.User__c = User;
                }
                   
                lead.Call_Time__c = ltngCurrTime;
                if(String.isNotBlank(callingMobileNo))
                    lead.Calling_Number__c = callingMobileNo;
                if(String.isNotBlank(mobileNo))
                    lead.Mobile_Phone_Max_ID__c = mobileNo;
                if(String.isNotBlank(recordTypeId))
                    lead.RecordTypeId = recordTypeId;
                lead.Call_Type__c = selectedCallType;
                lead.Service__c = selectedService;
                if(selectedCallType == 'Blank Call') {
                    lead.DisconnectionType__c =  disconnectionType;   
                }
                else if(selectedCallType == 'Feedback/Complaints'){
                    lead.Call_Back__c = callBack;
                }
                else if(selectedCallType == 'Call Transfer') {
                    lead.Source__c = selectedSource;//Source need to be mapped 
                    lead.Transfer_Level__c = transferLevel;//Transfer Level need to be mapped
                    lead.Call_Transfer_Status__c = selectedStatus;//Call Transfer Status need to be mapped  
                }
                else if(selectedCallType == 'Appointment') {
                    lead.Appointment_Type__c = selectedAppointment;
                    if(String.isNotBlank(selectedDoctorId))
                        lead.Doctor__c = selectedDoctorId;
                    lead.Specilization__c = valueSublabel;
                    lead.Appointment_Source__c = selectedSourceAppointment;// Need to map Appointment Source
                    lead.Lead_Channel__c = selectedChannel;// Need to map Channel
                    lead.Reason__c = selectedReason;// Need to Map Reason
                }
                else if(selectedCallType == 'Query') {
                    lead.Sub_Service__c = selectedSubService;//Need to Map Subservice
                    if(String.isNotBlank(selectedDoctorId))
                        lead.Doctor__c = selectedDoctorId;
                    lead.Specilization__c = valueSublabel;
                    lead.Source__c = selectedSource;//need to map Source
                    lead.Call_Back__c = callBack;
                }
                
                if(String.isNotBlank(selectedLocationId)) {
                    if(mapBusinessUnit != NULL && mapBusinessUnit.keySet().size() > 0 && mapBusinessUnit.containsKey(selectedLocationId)) {
                        //lead.Location_Name__c = mapBusinessUnit.get(selectedLocationId).Name;
                        // lead.Business_Unit__c = mapBusinessUnit.get(selectedLocationId).Name; Unit_Name_Custom__c
                        lead.Location_Name__c = mapBusinessUnit.get(selectedLocationId).Unit_Name_Custom__c;
                        lead.Business_Unit__c = mapBusinessUnit.get(selectedLocationId).Unit_Name_Custom__c; 
                        
                    }
                }
                if(String.isNotBlank(selectedCountryId)){
                    lead.Country_Query__c=selectedCountryId;
                }
                
                lead.Remarks__c = remarks;
                if(String.isNotBlank(selectedMaxId) && !newContact)
                    lead.Patient__c = parentId;
                else
                    lead.Parent_Contact_for_lead__c = parentId;
                
                if(sendSMS && triggercheck.Send_SMS__c)
                    sendSMS(smsNumber);        
              // system.debug(lead.Remarks__c);
                insert lead;
              //  system.debug(lead.Remarks__c);
                System.debug('Id-->'+lead.Id);
            }    
        }
        return 'Record Created Successfully';     
        //  }
        /*  catch(Exception e) {   
API_Error_Log__c apiErrorLog = new API_Error_Log__c();
apiErrorLog.API_Name__c = 'Call Center';
apiErrorLog.Error_Message__c = e.getMessage()+'-'+e.getLineNumber();
apiErrorLog.Trigger_Point__c = 'Call Center Page';
apiErrorLog.Record_Identifier__c = callingMobileNo;
insert apiErrorLog;
return e.getMessage();
}*/
        
    }
    @auraEnabled
    public static void dummyFunction(){
        system.debug('I am Here');
    }
    public static String createContact(String contactSalutation,String callingMobileNo,String contactAge,String contactGender,String contactEmail,String contactAlternateNumber,String contactName) {
        Contact con = new Contact();
        String recordTypeIdPatient = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        if(String.isNotBlank(recordTypeIdPatient))
            con.RecordTypeId = recordTypeIdPatient;
        con.Salutation = contactSalutation;
        con.Phone = callingMobileNo;
        con.Age__c = contactAge;
        con.Gender__c = contactGender;
        con.Email = contactEmail;
        //MapAlternateNumber
        con.alternate_number__c=contactAlternateNumber;
        con.LastName = contactName;
        insert con;  
        return con.Id;
    }
    
    @AuraEnabled
    public static Boolean checkValidation(String param) {
        if(String.isNotBlank(param) && param.isNumeric()){
            if(param.length() == 12) {
                String yr = String.valueOf(System.today().year());
                Integer year = Integer.valueOf(yr.substring(0,2)+param.substring(0,2));
                Integer month = Integer.valueOf(param.substring(2,4));
                Integer day = Integer.valueOf(param.substring(4,6));
                Integer hour = Integer.valueOf(param.substring(6,8));
                Integer minute = Integer.valueOf(param.substring(8,10));
                Integer second = Integer.valueOf(param.substring(10,12));
                
                DateTime dt1 =  DateTime.newInstance(year, month, day, hour, minute, second);
                Long dt1Long = dt1.getTime();
                Long dt2Long = DateTime.now().getTime();
                Long milliseconds = dt2Long - dt1Long;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                if(minutes <= Integer.valueOf(Label.CallPageMinute) && minutes >= 0)
                    return true; 
                else
                    return false;
            }   
            else {
                return false;       
            }
        }   
        else {
            return false;
        }
    }
    
    
    /* @AuraEnabled(cacheable=true) 
public static String getSpecialityApex(String selectedDoctorId){
String speciality='';
List<Account> accountList;
if(selectedDoctorId != NULL){
accountList = [SELECT Id,SF_Speciality__r.Name FROM Account where Id =:selectedDoctorId]; 
}      

if(accountList != NULL && accountList.size() > 0)
if(accountList[0].SF_Speciality__r.Name != NULL)
speciality = accountList[0].SF_Speciality__r.Name;            
return speciality;               
}*/
    
  
   
    
    
    
    
    
    
    @future(callout=true)
    public static void sendSMS(String smsNumber){   
        SMSClass.sendSMS(smsNumber,Label.CallCenter);      
    }
    
    public class WrapperClass {
        @AuraEnabled
        public string status;
        @AuraEnabled
        public List<Account> listPatient;
        @AuraEnabled
        public List<Lead__c> listCallDetails;
        @AuraEnabled
        public Integer probability;
        @AuraEnabled
        public List<Billing_Summary__c> listTransactions;
        @AuraEnabled
        public String preferredChannel;
        @AuraEnabled
        public Integer conversionProbability;
        @AuraEnabled
        public String UserID;
        @AuraEnabled
        public String UniqueID;
        
        public WrapperClass() {
            status = '';
            UserID ='';
            UniqueID = '';
            listPatient = new List<Account>();
            listCallDetails = new List<Lead__c>();
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
        @AuraEnabled
        public Map<String,List<String>> mapAppTypeToSource;
        @AuraEnabled
        public Map<String,List<String>> mapReason;
        @AuraEnabled
        public Map<String,List<String>> mapServiceToSubService;
        
        public CallTypeWrapper() {
            status = '';
            mapCallTypeToService = new Map<String,List<String>>();
            listMapKeys = new List<String>();
            mapAppTypeToSource = new Map<String,List<String>>();
            mapReason = new Map<String,List<String>>();
            mapServiceToSubService = new Map<String,List<String>>();
        }        
        
    }
}