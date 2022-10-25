@RestResource(urlMapping='/createadmissionack/*')
global class AdmissionAcknowledgementsController {
    @HttpPOST
    global static void doCreateAdmission() {
        RestRequest req = RestContext.request;
        string jsonStr;
         RestContext.response.addHeader('Content-Type', 'application/json');
        if(!String.isBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class); 
            system.debug('requestBody  -->  ' + requestBody );
            Savepoint sp = Database.setSavepoint();
            try {
                if(requestBody.Data != NULL && requestBody.Data.size() > 0) {
                    
                    List<Admission_Acknowledgement__c> listToInsert = new List<Admission_Acknowledgement__c>();
                    List<Admission_Acknowledgement__c> listToUpdate = new List<Admission_Acknowledgement__c>();
                    
                    set<String> ipIds = new set<String>();
                    set<String> businessUnits = new set<String>();                    
                    map<String,Admission_Acknowledgement__c> admDataMap = new map<String,Admission_Acknowledgement__c>();
                    
                    map<String,Admission_Acknowledgement__c> admMap = new map<String,Admission_Acknowledgement__c>();
                    map<String,Boolean> admErMap = new map<String,Boolean>();
                    
                    set<String> statusSet = new set<String>();
                    statusSet.addAll(label.Admission_Status_For_Prospect.split(','));
                    
                    //shifted to Trigger
                    //map<String, List< Admission_Acknowledgement__c > > mapAdminAckForInternationalPatient = new map<String, List< Admission_Acknowledgement__c>>(); //14March2020
                    
                    Set<String> doctorIds = new Set<String>();
                    Set<String> doctorIdNameSet = new Set<String>();
                    Set<String> patientMaxIds = new Set<String>();
                    Set<String> patientNameSet = new Set<String>();
                    Set<String> specialityIds = new Set<String>();
                    Set<String> specialityIdNameSet = new Set<String>();
                    Set<String> subSpecialityIds = new Set<String>();
                    Set<String> subSpecialityIdNameSet = new Set<String>();
                    Set<String> businessUnitSet = new Set<String>();
                    Set<String> maxIdSet = new Set<String>();
                    
                    /*==================== Set Filling Start=======================*/
                    for(Integer i = 0; i < RequestBody.Data.size(); i++) {                        
                        if(String.isNotBlank(requestBody.Data[i].DOCTORNAME)) {                                         
                            doctorIds.add(requestBody.Data[i].DoctorID);
                            doctorIdNameSet.add((requestBody.Data[i].DoctorID + '-' + requestBody.Data[i].DOCTORNAME));
                        }
                        if(String.isNotBlank(requestBody.Data[i].SpecialityId)){
                            specialityIds.add(requestBody.Data[i].SpecialityId);
                            specialityIdNameSet.add((requestBody.Data[i].SpecialityId + '-' + requestBody.Data[i].Speciality));
                        }
                        if(String.isNotBlank(requestBody.Data[i].SubSpecialityId)) {
                            subSpecialityIds.add(requestBody.Data[i].SubSpecialityId);
                            subSpecialityIdNameSet.add((requestBody.Data[i].SubSpecialityId + '-' + requestBody.Data[i].SubSpeciality));
                        }
                        if(String.isNotBlank(requestBody.Data[i].HospitalLocation)) {
                            businessUnitSet.add(requestBody.Data[i].HospitalLocation);
                        }
                        if(String.isNotBlank(requestBody.Data[i].MaxId)){   
                            maxIdSet.add(requestBody.Data[i].MaxId);
                            patientMaxIds.add(requestBody.Data[i].MaxId);
                            patientNameSet.add(requestBody.Data[i].MaxId + '-' + requestBody.Data[i].PatientName);
                        }
                    }
                    /*==================== Set Filling End=======================*/
                    
                    
                    /*=====================MAP Filling Start========================*/
                    Map<String, String> doctorMap = new Map<String, String>();
                    Map<String, String> patientMap = new Map<String, String>();
                    Map<String, String> specializationMap = new Map<String, String>();
                    Map<String, String> BUMap = new Map<String, String>();
                    Map<String, String> subSpecializationMap = new Map<String, String>();
                   // Map<String, International_OP_Patient_Journey__c> IOPMap = new  Map<String, International_OP_Patient_Journey__c> ();
                    
                    if(!doctorIds.isEmpty())
                        doctorMap = RecordCheckUtilityClass.checkRecords(doctorIds, doctorIdNameSet, Label.Account);
                    if(!businessUnitSet.isEmpty())
                        BUMap = RecordCheckUtilityClass.checkRecords(businessUnitSet, null, Label.Business_Unit);
                    if(!patientMaxIds.isEmpty())
                        patientMap = RecordCheckUtilityClass.checkRecords(patientMaxIds, patientNameSet, Label.Patient);
                    if(!doctorIds.isEmpty())
                        specializationMap = RecordCheckUtilityClass.checkRecords(specialityIds, specialityIdNameSet, Label.Department);
                    if(!doctorIds.isEmpty())
                        subSpecializationMap = RecordCheckUtilityClass.checkRecords(subSpecialityIds, subSpecialityIdNameSet, Label.Specialization);
                    
                    /*=====================MAP Filling End========================*/
                    
                    
                    for(Integer i=0;i<RequestBody.Data.size();i++) {
                        Admission_Acknowledgement__c admission = new Admission_Acknowledgement__c();
                        if(String.isNotBlank(requestBody.Data[i].SSNNo))
                            admission.SSN_No__c = requestBody.Data[i].SSNNo;
                        if(String.isNotBlank(requestBody.Data[i].IPID))
                            admission.IPID__c = requestBody.Data[i].IPID;
                        if(String.isNotBlank(requestBody.Data[i].EmergencyNo))
                            admission.Emergency_No__c = requestBody.Data[i].EmergencyNo;
                        if(String.isNotBlank(requestBody.Data[i].PreadmitNo))
                            admission.Pre_Admit_No__c = requestBody.Data[i].PreadmitNo;
                        if(String.isNotBlank(requestBody.Data[i].TransactionType))
                            admission.Transaction_Type__c = requestBody.Data[i].TransactionType;
                        if(String.isNotBlank(requestBody.Data[i].Address))
                            admission.Address__c = requestBody.Data[i].Address;
                        if(String.isNotBlank(requestBody.Data[i].Locality))
                            admission.Locality__c = requestBody.Data[i].Locality;
                        if(String.isNotBlank(requestBody.Data[i].City))
                            admission.City__c = requestBody.Data[i].City;
                        if(String.isNotBlank(requestBody.Data[i].Country))
                            admission.Country__c = requestBody.Data[i].Country;
                        if(String.isNotBlank(requestBody.Data[i].OP))
                            admission.OP__c = requestBody.Data[i].OP;
                        if(String.isNotBlank(requestBody.Data[i].Pincode))
                            admission.Pin_Code__c = requestBody.Data[i].Pincode;
                       if(String.isNotBlank(requestBody.Data[i].BILLNO))
                            admission.Bill_No__c = requestBody.Data[i].BILLNO;
                        if(String.isNotBlank(requestBody.Data[i].BILLDATE))
                            admission.Bill_Date__c = DateTime.valueOf(requestBody.Data[i].BILLDATE);
                        if(String.isNotBlank(requestBody.Data[i].DISCOUNT))
                            admission.Discount__c = Decimal.valueOf(requestBody.Data[i].DISCOUNT);                        
                        if(String.isNotBlank(requestBody.Data[i].DOCTORNAME))
                            admission.Doctor_Name__c = requestBody.Data[i].DOCTORNAME;                        
                        if(String.isNotBlank(requestBody.Data[i].TOTALAMOUNT))
                            admission.Total_Amount__c = Decimal.valueof(requestBody.Data[i].TOTALAMOUNT);
                        if(String.isNotBlank(requestBody.Data[i].CASHOrCredit))
                            admission.Cash_Or_Credit__c = requestBody.Data[i].CASHOrCredit;
                        if(String.isNotBlank(requestBody.Data[i].CAMPAIGNCODE))
                            admission.Campaign_Code__c = requestBody.Data[i].CAMPAIGNCODE; 
                        if(String.isNotBlank(requestBody.Data[i].CHANNELNAME))
                            admission.Channel_Name__c = requestBody.Data[i].CHANNELNAME;                        
                        if(String.isNotBlank(requestBody.Data[i].DATEOFADMISSION))
                            admission.Date_Time_of_Admission__c = DateTime.valueOf(requestBody.Data[i].DATEOFADMISSION);
                        if(String.isNotBlank(requestBody.Data[i].DATEOFDISCHARGE))
                            admission.Date_of_Discharge__c = Date.valueOf(requestBody.Data[i].DATEOFDISCHARGE);                        
                        if(String.isNotBlank(requestBody.Data[i].isbillcancelled))
                            admission.Is_Bill_Cancelled__c = requestBody.Data[i].isbillcancelled;
                        if(String.isNotBlank(requestBody.Data[i].State))
                            admission.State__c = requestBody.Data[i].State;
                        if(String.isNotBlank(requestBody.Data[i].doctor_employee_id))
                            admission.Doctor_Employee_ID__c = requestBody.Data[i].doctor_employee_id;
                        if(String.isNotBlank(requestBody.Data[i].AppointmentBookinId))
                            admission.Appointment_Booking_ID__c = requestBody.Data[i].AppointmentBookinId;
                        if(String.isNotBlank(requestBody.Data[i].ProcessByDrAppointment))
                            admission.Process_By_Dr_Appointment__c = requestBody.Data[i].ProcessByDrAppointment;
                        if(String.isNotBlank(requestBody.Data[i].International)) {
                            if(requestBody.Data[i].International == 'true') {
                                admission.alletec_international__c = true;
                                Id recordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
                                if(String.isNotBlank(recordTypeId))
                                    admission.RecordTypeId = recordTypeId;
                            }
                            else {
                                admission.alletec_international__c = false; 
                                Id recordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
                                if(String.isNotBlank(recordTypeId))
                                    admission.RecordTypeId = recordTypeId;
                            }
                        }
                        
                        if(String.isNotBlank(requestBody.Data[i].AccountID))
                            admission.Account_ID__c = requestBody.Data[i].AccountID;
                        if(String.isNotBlank(requestBody.Data[i].DiscountReason))
                            admission.Discount_Reason__c = requestBody.Data[i].DiscountReason; 
                        if(String.isNotBlank(requestBody.Data[i].PatientName))
                            admission.Patient_Name__c = requestBody.Data[i].PatientName;
                        if(String.isNotBlank(requestBody.Data[i].SourceOfInfo))
                            admission.Source_of_Info__c = requestBody.Data[i].SourceOfInfo;
                        if(String.isNotBlank(requestBody.Data[i].billupdated))
                            admission.Bill_Updated__c = requestBody.Data[i].billupdated;
                        if(String.isNotBlank(requestBody.Data[i].CompanyShareAmount))
                            admission.Company_Share_Amount__c = requestBody.Data[i].CompanyShareAmount;
                        if(String.isNotBlank(requestBody.Data[i].CompanyName))
                            admission.Company_Name__c = requestBody.Data[i].CompanyName;
                        if(String.isNotBlank(requestBody.Data[i].AdmissionStatus))
                            admission.Admission_Status__c = requestBody.Data[i].AdmissionStatus; 
                        if(String.isNotBlank(requestBody.Data[i].IsEmergency)) {
                            if(requestBody.Data[i].IsEmergency == 'true')
                                admission.Is_Emergency__c = true;
                            else
                                admission.Is_Emergency__c = false;
                        }
                        if(String.isNotBlank(requestBody.Data[i].CouponCode))
                            admission.Coupon_Code__c = requestBody.Data[i].CouponCode; 
                        if(String.isNotBlank(requestBody.Data[i].IsPatientTransfer)) 
                            admission.Is_Patient_Transfer__c = requestBody.Data[i].IsPatientTransfer;    
                        if(String.isNotBlank(requestBody.Data[i].MarkupPer))
                            admission.pcl_markuppercentage__c = requestBody.Data[i].MarkupPer;
                        
                        if(String.isNotBlank(requestBody.Data[i].MarkupType))
                            admission.pcl_markuptype__c = requestBody.Data[i].MarkupType;
                        
                        if(String.isNotBlank(requestBody.Data[i].WardNo))
                            admission.WardNo__c = requestBody.Data[i].WardNo;
                        if(String.isNotBlank(requestBody.Data[i].BedNo))
                            admission.BedNo__c = requestBody.Data[i].BedNo;
                        if(String.isNotBlank(requestBody.Data[i].ContactPersonName))
                            admission.Contact_Person_Name__c = requestBody.Data[i].ContactPersonName;
                        if(String.isNotBlank(requestBody.Data[i].ContactPersonMobileNo))
                            admission.Contact_Person_MobileNo__c = requestBody.Data[i].ContactPersonMobileNo;
                         
                        String key='';  
                        /*================ Values Filling FROM Maps ==================*/
                        if(String.isNotBlank(requestBody.Data[i].DoctorID) && doctorMap.containskey(requestBody.Data[i].DoctorID)) {
                            admission.Doctor_Name__c = requestBody.Data[i].DOCTORNAME;
                            admission.Doctor_ID__c = requestBody.Data[i].DoctorID;                            
                            admission.Doctor__c = doctorMap.get(requestBody.Data[i].DoctorID); 
                        }
                        if(String.isNotBlank(requestBody.Data[i].SpecialityId) && specializationMap.containsKey(requestBody.Data[i].SpecialityId)){
                            admission.alletec_speciality__c = specializationMap.get(requestBody.Data[i].SpecialityId);
                        }
                        if(String.isNotBlank(requestBody.Data[i].SubSpecialityId) && subSpecializationMap.containsKey(requestBody.Data[i].SubSpecialityId)) {
                            admission.Sub_Speciality__c = subSpecializationMap.get(requestBody.Data[i].SubSpecialityId);
                        }
                        if(String.isNotBlank(requestBody.Data[i].HospitalLocation) && BUMap.containsKey(requestBody.Data[i].HospitalLocation)) {                                                        
                            admission.alletec_hospitallocation__c = BUMap.get(requestBody.Data[i].HospitalLocation);
                        }
                                                
                        if(String.isNotBlank(requestBody.Data[i].MaxId) && patientMap.containsKey(requestBody.Data[i].MaxId)){
                            admission.Max_ID__c = requestBody.Data[i].MaxId;                            
                            admission.Patient_Name__c = requestBody.Data[i].PatientName;
                            admission.patient__c = patientMap.get(requestBody.Data[i].MaxId);
                            
                            //Filling two maps to fetch existing prospect records if patient is actually admitted in the hospital                            
                            if(statusSet.contains(admission.Admission_Status__c)){
                                admMap.put(admission.Max_ID__c,admission); 
                                admErMap.put(admission.Max_ID__c,admission.Is_Emergency__c);  
                            }                            
                        }
                                                                                                                        
                        //Create a unique Identifier based on Hospital Location and IPID                        
                        
                        //--------------------------------------------Added on 14 March 2020 (adding functionality of checking international and populaitng R-channel )--------------------------
                        //for massaging module modification if admission 
                        
                        /*
                         * //shifted to Trigger 30 March 2020
                         * 
                        if( admission.alletec_international__c && String.isNotBlank(requestBody.Data[i].MarkupType) && requestBody.Data[i].MarkupType.toLowerCase() == 'is applied'
                           && String.isNotBlank(admission.Company_Name__c ) && admission.Company_Name__c.toLowerCase() != 'psu' && String.isNotBlank( admission.Patient__c )){
                               
                               if( !mapAdminAckForInternationalPatient.containsKey( admission.Patient__c ) )
                                   mapAdminAckForInternationalPatient.put( admission.Patient__c, new List< Admission_Acknowledgement__c >() );
                                   
                               mapAdminAckForInternationalPatient.get( admission.Patient__c ).add( admission );
                                   
                           }
                        */
                        //-----------------------------------------------------------------  END 14 March 2020   -------------------------------------------------------------------------
                        
                        if(admission.IPID__c!=null){
                            ipIds.add(admission.IPID__c);
                            key = admission.IPID__c;
                        }
                        
                        if(admission.alletec_hospitallocation__c!=null){
                            key += ('-' + admission.alletec_hospitallocation__c);
                            businessUnits.add(admission.alletec_hospitallocation__c);
                        }
                        admDataMap.put(key, admission);
                        
                    }//end of RequestBody.Data Loop
                    //system.debug('admDataMap ---> ' + admDataMap);
                    //Mapping of Existing Prospects with the Admission Acknowledgement to be created
                    TriggerExecutions__c exec = TriggerExecutions__c.getOrgDefaults();
                    
                    
                    
                    if(exec.Admission_Ack_API__c){
                        if(admMap.keySet()!=null && admMap.keySet().size()>0){
                            map<String,Id> existingProspectMap = new map<String,Id>();
                            existingProspectMap = existingprospectIdMap(admErMap,admMap);
                            
                            
                            if(existingProspectMap!=null && existingProspectMap.size()>0){
                                for(Admission_Acknowledgement__c adm : admDataMap.values()){
                                    if(String.IsNotBlank(adm.Max_Id__c) && existingProspectMap.containsKey(adm.Max_Id__c))
                                        adm.Related_Prospect__c = existingProspectMap.get(adm.Max_Id__c);
                                }
                            }
                        }
                    }
                    
                    map<String,Id> existingAdmMap = new map<String,Id>();
                    
                    if(ipIds!=null && ipIds.size()>0 && businessUnits!=null && businessUnits.size()>0){
                        for(Admission_Acknowledgement__c adm : [SELECT Id,IPID__c,alletec_hospitallocation__c FROM Admission_Acknowledgement__c WHERE 
                                                                IPID__c in: ipIds and alletec_hospitallocation__c in: businessUnits]){
                                                                    if(adm.IPID__c!=null && adm.alletec_hospitallocation__c!=null)
                                                                        existingAdmMap.put(adm.IPID__c+'-'+adm.alletec_hospitallocation__c,adm.Id);
                                                                }
                    }
                    
                    if(admDataMap!=null && admDataMap.size()>0){
                        for(String admNewKey : admDataMap.keySet()){
                            if(existingAdmMap.containsKey(admNewKey)){
                                admDataMap.get(admNewKey).Id = existingAdmMap.get(admNewKey);
                                listToUpdate.add(admDataMap.get(admNewKey));
                            }
                            else{
                                
                                listToInsert.add(admDataMap.get(admNewKey));
                            }
                        }
                    }
                    
                    
                    
                    String ids='';
                    
                    //--------------------------------------------Added on 14 March 2020 (adding functionality of checking international and populaitng R-channel )--------------------------
                    /*
                         * //shifted to Trigger 30 March 2020
                         * 
                        
                    for( Account objAcc : [ SELECT address2_country__c FROM Account 
                                           	WHERE address2_country__c <> NULL AND address2_country__c != 'Indian' AND Id In: mapAdminAckForInternationalPatient.keyset() ] ){
                                                
                                                for( Admission_Acknowledgement__c objAdminAck : mapAdminAckForInternationalPatient.get( objAcc.Id ) ){
                                                    
                                                    if( objAdminAck.Channel_Name__c == 'Cash' ){
                                                        
                                                        if( String.isNotBlank( objAdminAck.MECP_Source__c ) )
                                                            objAdminAck.R_Channel__c = 'MECP';
                                                        else
                                                            objAdminAck.R_Channel__c = 'Walk-In' ;
                                                    }
                                                    else if( ( objAdminAck.Channel_Name__c == 'Walk-In' || objAdminAck.Channel_Name__c == 'TPA' )){
                                                        
                                                        if( String.isNotBlank( objAdminAck.MECP_Source__c ) )
                                                            objAdminAck.R_Channel__c = 'MECP';
                                                        else
                                                            objAdminAck.R_Channel__c = objAdminAck.Channel_Name__c ;
                                                    }
                                                    else{
                                                        
                                                        objAdminAck.R_Channel__c = objAdminAck.Channel__c;
                                                    }
                                                }
                                            }//end of account loop
                    
                    //----------------------------------------------------------------- Heap De-allocate  -----------------------------------------------------
                    mapAdminAckForInternationalPatient.clear();
                    //-----------------------------------------------------------------  END 14 March 2020   -------------------------------------------------------------------------
                    */
                    
                    //List To Insert
                    if(listToInsert != NULL && listToInsert.size() > 0) {
                       // system.debug('listToInsert  --> ' + listToInsert);
                        Database.SaveResult[] srList = Database.insert(listToInsert,false);
                      // system.debug('srList ---> ' + srList[0]);
                       List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        
                        for(Integer i=0;i<srList.size();i++){
                            if(!srList[i].isSuccess()){
                                API_Error_Log__c apiError = new API_Error_Log__c();
                                apiError.API_Name__c = 'Admission Acknowlegdement';
                               // apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                               // System.debug('Error in API 1 = '+srList[i].getErrors());
                                apiError.Error_Message__c = srList[i].getErrors().get(0).getMessage();
                                apiError.Trigger_Point__c = 'createadmissionack';
                                apiError.Record_Identifier__c = '{"IPID" : "'+listToInsert[i].IPID__c+'","Hospital Location" : "'+listToInsert[i].alletec_hospitallocation__c+'","MAX ID" : "'+listToInsert[i].Max_ID__c+'"}';
                                listApiErrorLog.add(apiError); 
                            }
                            else 
                                ids += srList[i].getId() + ',';
                        }
                        
                        if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            insert listApiErrorLog;
                    }
                    
                    //List To Update
                    if(listToUpdate != NULL && listToUpdate.size() > 0) {
                       // system.debug('listToUpdate  --> ' + listToUpdate);
                        Database.SaveResult[] srList = Database.update(listToUpdate,false);
                        
                        
                        List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        
                        for(Integer i=0;i<srList.size();i++){
                            if(!srList[i].isSuccess()){
                                API_Error_Log__c apiError = new API_Error_Log__c();
                                apiError.API_Name__c = 'Admission Acknowlegdement';
                               // System.debug('Error in API 2 ='+srList[i].getErrors());
                                apiError.Error_Message__c = srList[i].getErrors().get(0).getMessage();
                                apiError.Trigger_Point__c = 'createadmissionack';
                                apiError.Record_Identifier__c = '{"IPID" : "'+listToUpdate[i].IPID__c+'","Hospital Location" : "'+listToUpdate[i].alletec_hospitallocation__c+'","MAX ID" : "'+listToUpdate[i].Max_ID__c+'"}';
                                listApiErrorLog.add(apiError); 
                            }
                            else 
                                ids += srList[i].getId() + ',';
                        }
                        
                        if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            insert listApiErrorLog;
                    }
                
                    ids = ids.removeEnd(',');
                
                     jsonStr = '{"success" : true,"message" : "Admission Acknowledgement created successfully","ids":"'+ids+'"}';
                   
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return ; 
                }
                else {
                     jsonStr = '{"success" : false,"message" : "Provide Admission Acknowledgement"}';
                  //  RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return ;     
                }
            }
            catch(Exception e) {
               Database.rollback(sp);
                 jsonStr = '{"success" : false,"message" : "'+e.getMessage()+' '+e.getLineNumber()+'"}';
              //  RestContext.response.addHeader('Content-Type', 'application/json');
               RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return ;            
            }
        } //end of request body check
        else{
             jsonStr = '{"success" : false,"message" : "Provide Body"}';
          //  RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return ;
        }  
    }//end of doCreateAdmission()
    public class RequestBody {
        public List<AdmissionAcknowledgementData> Data;
        
        public RequestBody() {
            Data = new List<AdmissionAcknowledgementData>();
        }
    }
    
    
    public class AdmissionAcknowledgementData {
        public String SSNNo;
        public String MaxId;
        public String IPID;
        public String EmergencyNo;
        public String PREADMITNO;
        public String TRANSACTIONTYPE;
        public String ADDRESS;
        public String LOCALITY;
        public String CITY;
        public String COUNTRY;
        public String OP;
        public String PINCODE;
        public String BILLNO;
        public String BILLDATE;
        public String DISCOUNT;
        public String DOCTORNAME;
        public String SPECIALITY;
        public String SpecialityId;
        public String TOTALAMOUNT;
        public String CASHOrCredit;
        public String CAMPAIGNCODE;
        public String CHANNELNAME;
        public String HOSPITALLOCATION;
        public String DATEOFADMISSION;
        public String DATEOFDISCHARGE;
        public String SUBSPECIALITYID;
        public String isbillcancelled;
        public String SUBSPECIALITY;
        public String State;
        public String doctor_employee_id;
        public String AppointmentBookinId;
        public String ProcessByDrAppointment;
        public String International;
        public String DoctorID;
        public String AccountID;
        public String DiscountReason;
        public String PatientName;
        public String SourceOfInfo;
        public String billupdated;
        public String CompanyShareAmount;
        public String CompanyName;
        public String ImportedInCRM;
        public String AdmissionStatus;
        public String IsEmergency;
        public String CouponCode;
        public String IsPatientTransfer;
        public String MarkupPer;
        public String MarkupType;
        public String TableRowDate;
        public String slno;
        public String WardNo;
        public String BedNo;
        public String ContactPersonName;
        public String ContactPersonMobileNo;
    }
    
    //Method to get the exisiting prospect records for that patient being admitted
    public static map<String,Id> existingprospectIdMap (map<String,Boolean> maxIdMap, map<String,Admission_Acknowledgement__c> admAckMap){
        map<String,Id> prospectMap = new map<String,Id>();
        
        list<Prospect__c> prospectToUpdate = new list<Prospect__c>();
        
        map<Id,Id> docCordinatorMap = new map<Id,Id>();
        
        set<Id> doctorIds = new set<Id>();
        for(Admission_Acknowledgement__c adm : admAckMap.values()){
            if(adm.Doctor__c!=null)
                doctorIds.add(adm.Doctor__c);
        }
        
        if(doctorIds!=null && doctorIds.size()>0){
            for(Doctor_Coordinator_Master__c doc : [SELECT Id,Doctor__c,Co_ordinator__c, Specialization__c FROM Doctor_Coordinator_Master__c
                                                    WHERE Doctor__c in: doctorIds]){
                                                        if(doc.Co_ordinator__c!=null)
                                                            docCordinatorMap.put(doc.Doctor__c,doc.Co_ordinator__c);
                                                    }
        }
        
        /***************************************************added bu uzair tmc 4june 2020***************/
        map<String,Id> maxId2internationalmap = new map<String,Id>(); 
        
        String internationalrecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        
        for(Prospect__c pros : [SELECT Id,Max_Id__c from Prospect__c WHERE Max_Id__c in: maxIdMap.keySet() AND 
                                RecordTypeId=:internationalrecordTypeId AND Stage__c='Closed Lost'])
            maxId2internationalmap.put(pros.Max_Id__c,pros.id);
        /********************************************************************************/
        
        
        for(Prospect__c pros : [SELECT Id,Max_Id__c,Source__c,Doctor__c,Stage__c,Doctor_Est_Ep__c,RecordType.Name,Doctor_Est_Ep__r.Name FROM Prospect__c                  //added in 4th JUne 2020
                                WHERE Max_Id__c in: maxIdMap.keySet() and Stage__c NOT IN('Patient Discharged','Closed Lost')]){                      
                                 
                                    prospectMap.put(pros.Max_Id__c,pros.Id);
                                    
                                    if(pros.Stage__c!='Closed Won'){            //added in 4th June 2020
                                        
                                        pros.Stage__c = label.Prospect_Admitted;
                                        
                                        if(pros.RecordType.Name=='International')    //added in 4th JUne 2020                        
                                            pros.Stage__c = 'Closed Won';
                                        
                                        if(pros.Max_Id__c != NULL && maxIdMap.containsKey(pros.Max_Id__c) && maxIdMap.get(pros.Max_Id__c) != NULL && maxIdMap.get(pros.Max_Id__c)){
                                            pros.Admitted_Through_ER__c = true;
                                        }
                                        
                                        //If Patients gets admitted through ER or the primary source is Estimation
                                        if((pros.Max_Id__c != NULL && maxIdMap.containsKey(pros.Max_Id__c) && maxIdMap.get(pros.Max_Id__c) != NULL && maxIdMap.get(pros.Max_Id__c)) || pros.Source__c==label.Prospect_Estimation){
                                            if(pros.Doctor__c!=null && admAckMap.containsKey(pros.Max_Id__c) && admAckMap.get(pros.Max_Id__c).Doctor__c!=null){
                                                if(pros.Doctor__c!=admAckMap.get(pros.Max_Id__c).Doctor__c){
                                                    pros.Doctor_Est_Ep__c = pros.Doctor__c;
                                                    pros.Doctor__c = admAckMap.get(pros.Max_Id__c).Doctor__c;
                                                    if(docCordinatorMap.containsKey(pros.Doctor__c) && docCordinatorMap.get(pros.Doctor__c)!=null)
                                                        pros.OwnerId = docCordinatorMap.get(pros.Doctor__c);
                                                    
                                                    pros.Remarks__c = 'Patient Admitted under doctor '+pros.Doctor_Est_Ep__r.Name;
                                                }
                                            }
                                        }
                                        
                                        
                                        //If the specialty of both doctors are same 
                                        if(pros.Max_Id__c != NULL && maxIdMap.containsKey(pros.Max_Id__c) && maxIdMap.get(pros.Max_Id__c) != NULL && !maxIdMap.get(pros.Max_Id__c) && pros.Source__c!=label.Prospect_Estimation){
                                            //if(pros.Doctor_Specialization__c==admAckMap.get(pros.Max_Id__c).Sub_Speciality__c){
                                            if(pros.Doctor_Est_Ep__c==null || pros.Doctor_Est_Ep__c!= admAckMap.get(pros.Max_Id__c).Doctor__c)
                                                pros.Doctor_Est_Ep__c = admAckMap.get(pros.Max_Id__c).Doctor__c;
                                            //}
                                        }
                                        
                                    }
                                        prospectToUpdate.add(pros);
                                    
                                }
        
        /***************************************************added bu uzair tmc 4june 2020***************/
        if(maxId2internationalmap!=null && maxId2internationalmap.size() > 0){
            for(String pros : maxId2internationalmap.keyset()){
                if(maxId2internationalmap.containskey(pros))
                    prospectMap.put(pros,maxId2internationalmap.get(pros));
            }
        }
        /*************************************************************************************************/
        
        
        if(prospectToUpdate!=null && prospectToUpdate.size()>0)
            Database.update(prospectToUpdate,false);
        
        
        if(prospectMap!=null && prospectMap.size()>0){
            if(maxIdMap.keySet().size()!=prospectMap.keySet().size()){
                list<Prospect__c> prospectToInsert = new list<Prospect__c>();
                for(String maxId : maxIdMap.keySet()){
                    if(!prospectMap.containsKey(maxId)){               
                        Prospect__c prospect = new Prospect__c();
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Patient_Name__c!=null){
                            prospect.Name = admAckMap.get(maxId).Patient_Name__c;
                            prospect.Patient_Name__c = admAckMap.get(maxId).Patient_Name__c;
                        }
                        
                        prospect.Max_Id__c = maxId;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).alletec_hospitallocation__c!=null)
                            prospect.HIS_Hospital_Location__c = admAckMap.get(maxId).alletec_hospitallocation__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Patient__c!=null)
                            prospect.Account__c = admAckMap.get(maxId).Patient__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Doctor_Name__c!=null)
                            prospect.Doctor_Name__c = admAckMap.get(maxId).Doctor_Name__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Doctor__c!=null)
                            prospect.Doctor__c = admAckMap.get(maxId).Doctor__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Sub_Speciality__c!=null)
                            prospect.Doctor_Specialization__c = admAckMap.get(maxId).Sub_Speciality__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).alletec_speciality__c!=null)
                            prospect.Doctor_Department__c = admAckMap.get(maxId).alletec_speciality__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).SSN_No__c!=null)
                            prospect.SSN__c = admAckMap.get(maxId).SSN_No__c;
                        if(admAckMap.containsKey(maxId) && admAckMap.get(maxId).Discount_Reason__c!=null)
                            prospect.Discount_Reason__c = admAckMap.get(maxId).Discount_Reason__c;
                        
                        prospect.RecordtypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
                        prospect.Stage__c = label.Prospect_Admitted;
                        prospect.Source__c = label.Prospect_Emergency_Source;
                        prospectToInsert.add(prospect);
                    }
                }
                
                
                
                if(prospectToInsert!=null && prospectToInsert.size()>0){
                    Database.insert(prospectToInsert,false);
                    
                    for(Prospect__c prospect : prospectToInsert)
                        prospectMap.put(prospect.Max_Id__c,prospect.Id);
                }
            }
        }
        return prospectMap;
    }    
}