//Description: Apex Class to fetch Appoinment details from Practo through API callout
//Created by: Techmatrix Consulting

public without sharing class FetchAppointmentsFromPracto {
    
    //Method to be invoked from Scheduler class for every half an hour
    @future(callout=true)
    public static void processAppointmentsFromPracto(){
        
        //List variable for upserting Appoinments
        
        list<Appointment__c> appointmentsToUpsert = new list<Appointment__c>();
        
        map<String,String> appointmentMaxIdMap = new map<String,String>();
        
        map<String,String> doctorIdMap = new map<String,String>();
        map<String,String> businessUnitIdMap = new map<String,String>();
        map<String,String> specialtyIdMap = new map<String,String>();
        map<String,String> cmpLeadsIdMap = new map<String,String>();
        map<String,String> digitalLeadsIdMap = new map<String,String>();
        
        set<string> appointmentNameSet=new set<String>();
        set<string> appointmentPhoneSet=new set<String>();
        map<String,String> NMPhoneLeadMap = new map<String,String>();
        
        //Adding customer program Lead stages
        set<String> cmpLeadStagesForAppointment = new set<String>();
        cmpLeadStagesForAppointment.addAll(system.label.CMP_Appointment_Lead_Stages.split(';'));
        
        //Adding Digital Aquisition Lead stages
        set<String> dcaLeadStagesForAppointment = new set<String>();
        dcaLeadStagesForAppointment.addAll(system.label.DCA_Appointment_Lead_Stages.split(';'));
        
        //Adding Call Center Lead stages
        
        
        //Variables for storing Start Date Time (Half an hour before from current datetime)
        //String startTime;
        //Variables for storing End Date Time (Should be current Date & time)
        // String endTime;
        String since;
        String page='1';
        
        
        //Varaibles for storing key and API end point value
        String key; 
        String endpoint;
        
        if(!test.isRunningTest()){
            TriggerExecutions__c execution = TriggerExecutions__c.getOrgDefaults();
            if(execution.Practo_API__c){
                
                Practo_API__c practoApi = Practo_API__c.getOrgDefaults();
                //startTime = practoApi.Start_DateTime__c;
                // endTime = practoApi.End_DateTime__c;
                since = practoApi.since__c;
            }
            else{
                
                Practo_API__c practoApi = Practo_API__c.getOrgDefaults();
                since = constructDateTime(label.Practo_Add_Minutes);
                // endTime = constructDateTime('0');
                // since = practoApi.since__c;
            }
        }
        else{
            // startTime = '2019-04-26T15:00:00+530';
            // endTime = '2019-04-26T16:00:00+530';
            //since='2019-06-17T09:00:00+0530';
            since='2019-06-13T18:43:08+0530';
            
        }
        
        //Loop throughmetadata to get key and endpoints
        for(Practo_API_Details__mdt practo : [SELECT Id,Key__c,Salt__c,End_Point__c FROM Practo_API_Details__mdt]){
            if(String.isNotBlank(practo.Key__c))
                key = practo.Key__c; 
            if(String.isNotBlank(practo.End_Point__c))
                endpoint = practo.End_Point__c; 
        }
        
        //Do API callout if time formats are correct and not blank
        //if(String.isNotBlank(startTime) && String.isNotBlank(endTime)){
        if(String.isNotBlank(since) && String.isNotBlank(page)){ 
            
            set<String> appintmentIdSet = new set<String>();
            
            
            //String body = '{"start_time":"'+startTime+'","end_time":"'+endTime+'"}';
            String body = '{"since":"'+since+'","page":"'+page+'"}';
            
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-type','application/json');
            request.setHeader('key',key);
            //request.setHeader('signature',generateSignature(startTime,endTime));
            request.setHeader('signature',generateSignature(since));
            request.setBody(body);
            request.setMethod('POST');
            request.setEndPoint(endpoint);
            
            HttpResponse response = new HttpResponse();
            
            //To avoid API callout in Test Class
            if(!test.isRunningTest()){
                response = http.send(request);
            }else{
                String testbody = '{"meta":{"status":1,"message":"Success"},"data":{"appointments":[{"appointment_id":"dbb905c7-347d-43ca-a973-f3b03e0585ec","appointment_time":"2019-03-25T19:45:00+05:30","appointment_created_time":"2019-03-25T17:42:58+05:30","duration":15,"age":"","gender":"","occupation":"","dob":"","notes":null,"book_source":"PRACTOANDROIDAPP","patient_id":"d1b173ee-5d97-4268-bece-ce756931f75b","slot_id":"2cd4b916-4eba-4953-9b73-e08bc181c9af","procedure_id":"a71cebf8-7521-465a-bd65-c48d49426047","patient_phone":"9990232845","patient_email":"rishabhagrawal2303@gmail.com","doctor_id":"8825a8b4-c3a7-4660-a158-094ddeebb960","doctor_name":"Dr.MukeshKumar","clinic_name":"Saket–WestWing,MaxSuperSpecialityHospital","clinic_id":"f7fe6092-28ce-4719-81db-dd9d854d2d8c","uhid":"SDRT.876876","department_name":"MSW-Neurology","location_code":"10","doctor_code":"3322","speciality_code":"16","e_prescription_enabled":true,"procedure_name":"Consultation","amount":1250,"amount_after_discount":1250,"refund_amount":null,"prepaid":false,"currency":"INR","discount":0,"payment_status":null,"booking_status":"confirmed","transaction_code":null,"status":"missed","checked_in":false,"checked_out":false,"appt_original_time":"2019-03-25T19:45:00+05:30"}],"total_pages":2,"current_page":1,"results_per_page":20}}';
                response.setBody(testbody);
                response.setStatusCode(200);
            }
            
            //If response is OK
            if(response.getStatusCode()==200){
                if(response.getBody()!=null){
                    //system.debug('response.getBody()--->'+response.getBody());
                    
                    PractoAppoinmentJSONParser japex = PractoAppoinmentJSONParser.parse(response.getBody());
                    
                    
                    if(japex.Data!=null && japex.Data.appointments!=null){
                        
                        //Map response fields with Appoinment Object fields
                        for(PractoAppoinmentJSONParser.Appointments practoAppt : japex.Data.appointments){
                            Appointment__c appObj = new Appointment__c();
                            
                            appObj = mapAppoinmentFields(practoAppt);
                            
                            if(String.isNotBlank(appObj.Max_ID__c))
                                appointmentMaxIdMap.put(appObj.Max_ID__c,'');
                            
                            else if(String.isBlank(appObj.Max_ID__c) && string.isNotBlank(appObj.Patient_Name__c) && String.isNotBlank(appObj.Patient_Phone__c)){
                                appointmentNameSet.add(appObj.Patient_Name__c);
                                appointmentPhoneSet.add(appObj.Patient_Phone__c);
                                system.debug('=====appointmentNameSet=='+appointmentNameSet);
                                system.debug('=====appointmentPhoneSet=='+appointmentPhoneSet);
                            }
                            
                            if(String.isNotBlank(appObj.Location_Code__c))
                                businessUnitIdMap.put(appObj.Location_Code__c,'');
                            if(String.isNotBlank(appObj.Doctor_Code__c))
                                doctorIdMap.put(appObj.Doctor_Code__c,'');
                            if(String.isNotBlank(appObj.Specialty_Code__c))
                                specialtyIdMap.put(appObj.Specialty_Code__c,'');
                            
                            if(!appintmentIdSet.contains(appObj.Appointment_ID__c)){
                                appintmentIdSet.add(appObj.Appointment_ID__c);
                                appointmentsToUpsert.add(appObj);    
                            }
                            
                            
                        }
                        
                        //If pages are more than one, get all the remaining appoinments
                        if(japex.Data.total_pages>1){
                            for(Integer i=2;i<=japex.Data.total_pages;i++){
                                
                                //Add page parameter in the body of request
                                String nextBody = '{"since":"'+since+'","page":'+String.valueOf(i)+'}';
                                
                                Http nextHttp = new Http();
                                HttpRequest nextRequest = new HttpRequest();
                                nextRequest.setHeader('Content-type','application/json');
                                nextRequest.setHeader('key',key);
                                //nextRequest.setHeader('signature',generateSignature(startTime,endTime));
                                nextRequest.setHeader('signature',generateSignature(since));
                                nextRequest.setBody(nextBody);
                                nextRequest.setMethod('POST');
                                nextRequest.setEndPoint(endpoint);
                                
                                HttpResponse nextResponse = new HttpResponse();
                                if(!test.isRunningTest()){
                                    nextResponse = nextHttp.send(nextRequest);
                                }else{
                                    String testbody = '{"meta":{"status":1,"message":"Success"},"data":{"appointments":[{"appointment_id":"dbb935c7-347d-43ca-a973-f3b03e0585ec","appointment_time":"2019-03-25T19:45:00+05:30","appointment_created_time":"2019-03-25T17:42:58+05:30","duration":15,"age":"","gender":"","occupation":"","dob":"","notes":null,"book_source":"PRACTOANDROIDAPP","patient_id":"d1b173ee-5d97-4268-bece-ce756931f75b","slot_id":"2cd4b916-4eba-4953-9b73-e08bc181c9af","procedure_id":"a71cebf8-7521-465a-bd65-c48d49426047","patient_phone":"9990232845","patient_email":"rishabhagrawal2303@gmail.com","doctor_id":"8825a8b4-c3a7-4660-a158-094ddeebb960","doctor_name":"Dr.MukeshKumar","clinic_name":"Saket–WestWing,MaxSuperSpecialityHospital","clinic_id":"f7fe6092-28ce-4719-81db-dd9d854d2d8c","uhid":"SDRT.876876","department_name":"MSW-Neurology","location_code":"10","doctor_code":"3322","speciality_code":"16","e_prescription_enabled":true,"procedure_name":"Consultation","amount":1250,"amount_after_discount":1250,"refund_amount":null,"prepaid":false,"currency":"INR","discount":0,"payment_status":null,"booking_status":"confirmed","transaction_code":null,"status":"missed","checked_in":false,"checked_out":false,"appt_original_time":"2019-03-25T19:45:00+05:30"}],"total_pages":2,"current_page":2,"results_per_page":20}}';
                                    nextResponse.setBody(testbody);
                                    nextResponse.setStatusCode(200);
                                }
                                
                                //Map the fields with Appoinment fields if response is OK
                                if(nextResponse.getStatusCode()==200){
                                    if(nextResponse.getBody()!=null){
                                        
                                        system.debug('====raghav'+nextResponse.getBody());                                        
                                        PractoAppoinmentJSONParser nextJapex = PractoAppoinmentJSONParser.parse(nextResponse.getBody());
                                        
                                        system.debug('japex.Data.appointments 2--->'+nextJapex.Data.appointments.size());
                                        
                                        if(nextJapex.Data!=null && nextJapex.Data.appointments!=null){
                                            for(PractoAppoinmentJSONParser.Appointments nextAppt : nextJapex.Data.appointments){
                                                Appointment__c appObj = new Appointment__c();
                                                appObj = mapAppoinmentFields(nextAppt);
                                                
                                                if(String.isNotBlank(appObj.Max_ID__c))
                                                    appointmentMaxIdMap.put(appObj.Max_ID__c,'');
                                                else if(String.isBlank(appObj.Max_ID__c) && string.isNotBlank(appObj.Patient_Name__c) && String.isNotBlank(appObj.Patient_Phone__c)){
                                                    appointmentNameSet.add(appObj.Patient_Name__c);
                                                    appointmentPhoneSet.add(appObj.Patient_Phone__c);
                                                    system.debug('=====appointmentNameSet=='+appointmentNameSet);
                                                    system.debug('=====appointmentPhoneSet=='+appointmentPhoneSet);
                                                }
                                                if(String.isNotBlank(appObj.Location_Code__c))
                                                    businessUnitIdMap.put(appObj.Location_Code__c,'');
                                                if(String.isNotBlank(appObj.Doctor_Code__c))
                                                    doctorIdMap.put(appObj.Doctor_Code__c,'');
                                                if(String.isNotBlank(appObj.Specialty_Code__c))
                                                    specialtyIdMap.put(appObj.Specialty_Code__c,'');
                                                
                                                
                                                if(!appintmentIdSet.contains(appObj.Appointment_ID__c)){
                                                    appintmentIdSet.add(appObj.Appointment_ID__c);
                                                    
                                                    appointmentsToUpsert.add(appObj);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        if(appointmentMaxIdMap!=null && appointmentMaxIdMap.size()>0){
                            for(Account patient : (List<Account>)serachMaster('Account','Max_Id__c','',appointmentMaxIdMap.keySet(),null))
                                appointmentMaxIdMap.put(patient.Max_Id__c,patient.Id);
                            
                            for(Lead__c openLead : (List<Lead__c>)serachMaster('Lead__c','Max_Id__c','CMP',appointmentMaxIdMap.keySet(),cmpLeadStagesForAppointment))
                                cmpLeadsIdMap.put(openLead.Max_ID__c,openLead.Id);
                            
                            for(Lead__c openLead : (List<Lead__c>)serachMaster('Lead__c','Max_Id__c','Digital Customer Acquisition',appointmentMaxIdMap.keySet(),dcaLeadStagesForAppointment))
                                digitalLeadsIdMap.put(openLead.Max_ID__c,openLead.Id);
                        }
                        if(appointmentNameSet.size()>0 && appointmentPhoneSet.size()>0){
                            for(Lead__c openLead : [SELECT Name,Mobile_Phone__c,id from Lead__c WHERE Name IN :appointmentNameSet AND Mobile_Phone__c IN:appointmentPhoneSet AND Recordtype.Name='CMP' AND Stage__c=:cmpLeadStagesForAppointment])
                                NMPhoneLeadMap.put(openLead.Name+'-'+openLead.Mobile_Phone__c,openLead.Id); 
                            system.debug('=====>NMPhoneLeadMap===='+NMPhoneLeadMap);
                        }
                        
                        //Fill Business Unit Map
                        if(businessUnitIdMap!=null && businessUnitIdMap.size()>0){
                            for(Business_Unit__c location : (List<Business_Unit__c>)serachMaster('Business_Unit__c','HIS_ID__c','',businessUnitIdMap.keySet(),null))
                                businessUnitIdMap.put(location.HIS_ID__c,location.Id);
                        }
                        
                        //Fill Doctor ID Map
                        if(doctorIdMap!=null && doctorIdMap.size()>0){
                            for(Account doctor : (List<Account>)serachMaster('Account','alletec_doctorid__c','Doctor',doctorIdMap.keySet(),null))
                                doctorIdMap.put(doctor.alletec_doctorid__c,doctor.Id);
                        }
                        
                        //Fill Specilty ID Map
                        if(specialtyIdMap!=null && specialtyIdMap.size()>0){
                            for(Speciality__c specialty : (List<Speciality__c>)serachMaster('Speciality__c','HIS_ID__c','',specialtyIdMap.keySet(),null)){
                                specialtyIdMap.put(specialty.HIS_ID__c,specialty.Id);
                            }
                        }
                        
                        system.debug('appointmentMaxIdMap-->'+appointmentMaxIdMap); 
                        system.debug('appointmentsToUpsert-->'+appointmentsToUpsert); 
                        
                        //Upsert appoinments based on Appointment ID in Salesforce
                        if(appointmentsToUpsert!=null && appointmentsToUpsert.size()>0){
                            
                            for(Appointment__c obj : appointmentsToUpsert){
                                
                                if(String.isNotBlank(obj.Max_ID__c)){
                                    if(appointmentMaxIdMap.containsKey(obj.Max_ID__c) && String.isNotBlank(appointmentMaxIdMap.get(obj.Max_ID__c)))
                                        obj.Patient__c = appointmentMaxIdMap.get(obj.Max_ID__c);
                                    if(cmpLeadsIdMap.containsKey(obj.Max_ID__c) && String.isNotBlank(cmpLeadsIdMap.get(obj.Max_ID__c)))
                                        obj.Related_Lead__c = cmpLeadsIdMap.get(obj.Max_ID__c);
                                    if(digitalLeadsIdMap.containsKey(obj.Max_ID__c) && String.isNotBlank(digitalLeadsIdMap.get(obj.Max_ID__c)))
                                        obj.Related_Lead__c = digitalLeadsIdMap.get(obj.Max_ID__c);
                                }
                                else if(String.isBlank(Obj.Max_ID__c) && string.isNotBlank(Obj.Patient_Name__c) && String.isNotBlank(Obj.Patient_Phone__c)){
                                    if(NMPhoneLeadMap.containsKey(Obj.Patient_Name__c+'-'+Obj.Patient_Phone__c) && String.isNotBlank(NMPhoneLeadMap.get(Obj.Patient_Name__c+'-'+Obj.Patient_Phone__c)))
                                        obj.Related_Lead__c = NMPhoneLeadMap.get(Obj.Patient_Name__c+'-'+Obj.Patient_Phone__c);   
                                    system.debug('====obj.Related_Lead__c'+obj.Related_Lead__c);
                                }
                                
                                
                                if(String.isNotBlank(obj.Location_Code__c) && businessUnitIdMap.containsKey(obj.Location_Code__c) && String.isNotBlank(businessUnitIdMap.get(obj.Location_Code__c)))
                                    obj.Business_Unit__c = businessUnitIdMap.get(obj.Location_Code__c);
                                if(String.isNotBlank(obj.Doctor_Code__c) && doctorIdMap.containsKey(obj.Doctor_Code__c) && String.isNotBlank(doctorIdMap.get(obj.Doctor_Code__c)))
                                    obj.Doctor__c = doctorIdMap.get(obj.Doctor_Code__c);
                                if(String.isNotBlank(obj.Specialty_Code__c) && specialtyIdMap.containsKey(obj.Specialty_Code__c) && String.isNotBlank(specialtyIdMap.get(obj.Specialty_Code__c)))
                                    obj.Specialty__c = specialtyIdMap.get(obj.Specialty_Code__c);
                            }
                            
                            Schema.SObjectField field = Appointment__c.Fields.Appointment_ID__c;
                            Database.UpsertResult[] resultList = Database.upsert(appointmentsToUpsert,field,false);
                            system.debug('=====resultList=='+resultList);
                            
                            list<API_Error_Log__c> errorLogsToInsert = new list<API_Error_Log__c>();
                            for (Database.UpsertResult result : resultList) {
                                if(result.isSuccess()){
                                    System.debug('Successfully inserted Appoinment. Appointment ID: ' + result.getId());
                                }
                                else{
                                    for(Database.Error err : result.getErrors()) {
                                        API_Error_Log__c apiError = new API_Error_Log__c();
                                        apiError.API_Name__c = 'Practo Appointment API';
                                        apiError.ErrorMessage__c = String.valueOf(err.getMessage());
                                        apiError.Trigger_Point__c = 'Practo Appointment API';
                                        apiError.Record_Identifier__c = 'Fields : '+err.getFields();
                                        errorLogsToInsert.add(apiError); 
                                    }
                                }
                            }
                            if(!errorLogsToInsert.isEmpty())
                                insert errorLogsToInsert;
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    //Method to map the field values for Appoinment
    public static Appointment__c mapAppoinmentFields(PractoAppoinmentJSONParser.Appointments appoint){
        Appointment__c newAppoint = new Appointment__c();
        if(String.isNotBlank(appoint.appointment_id))
            newAppoint.Appointment_ID__c = appoint.appointment_id;
        if(String.isNotBlank(appoint.appointment_time))
            newAppoint.Appointment_Date_Time__c = constructTime(appoint.appointment_time);
        if(String.isNotBlank(appoint.appointment_created_time))
            newAppoint.Appointment_Created_Time__c = constructTime(appoint.appointment_created_time);
        if(String.isNotBlank(appoint.appointment_patient_name))
            newAppoint.Patient_Name__c = appoint.appointment_patient_name;
        // if(appoint.duration!=null)
        //   newAppoint.Duration__c = Decimal.valueOf(appoint.duration);
        
        if(String.isNotBlank(appoint.age))
            newAppoint.Age__c = Decimal.valueOf(appoint.age);
        
        if(String.isNotBlank(appoint.gender))
            newAppoint.Gender__c = appoint.gender;
        if(String.isNotBlank(appoint.occupation))
            newAppoint.Occupation__c = appoint.occupation; 
        //if(String.isNotBlank(appoint.dob))
        //newAppoint.Appointment_ID__c = appoint.appointment_id;
        if(String.isNotBlank(appoint.book_source))
            newAppoint.Booking_Source__c = appoint.book_source;
        if(String.isNotBlank(appoint.patient_id))
            newAppoint.Practo_Patient_ID__c = appoint.patient_id;
        if(String.isNotBlank(appoint.slot_id))
            newAppoint.Practo_Slot_ID__c = appoint.slot_id;
        if(String.isNotBlank(appoint.procedure_id))
            newAppoint.Practo_Procedure_ID__c = appoint.procedure_id;
        if(String.isNotBlank(appoint.patient_phone))
            newAppoint.Patient_Phone__c = appoint.patient_phone;
        
        if(String.isNotBlank(appoint.patient_email))
            newAppoint.Patient_Email__c = appoint.patient_email;
        
        if(String.isNotBlank(appoint.doctor_id))
            newAppoint.Practo_Doctor_ID__c = appoint.doctor_id;
        if(String.isNotBlank(appoint.doctor_name))
            newAppoint.Doctor_Name__c = appoint.doctor_name;
        if(String.isNotBlank(appoint.clinic_name))
            newAppoint.Clinic_Name__c = appoint.clinic_name;
        if(String.isNotBlank(appoint.clinic_id))
            newAppoint.Practo_Clinic_ID__c = appoint.clinic_id;
        if(String.isNotBlank(appoint.uhid))
            newAppoint.Max_ID__c = appoint.uhid; 
        if(String.isNotBlank(appoint.department_name))
            newAppoint.Department_Name__c = appoint.department_name;
        if(String.isNotBlank(appoint.location_code))
            newAppoint.Location_Code__c = appoint.location_code;
        if(String.isNotBlank(appoint.doctor_code))
            newAppoint.Doctor_Code__c = appoint.doctor_code;
        if(String.isNotBlank(appoint.speciality_code))
            newAppoint.Specialty_Code__c = appoint.speciality_code;
        if(appoint.e_prescription_enabled ==true)
            newAppoint.EPrescription_Enabled__c = appoint.e_prescription_enabled;
        if(String.isNotBlank(appoint.procedure_name))
            newAppoint.Procedure_Name__c = appoint.procedure_name;
        // if(appoint.amount!=null)
        //   newAppoint.Amount__c = Decimal.valueOf(appoint.amount);
        if(appoint.amount_after_discount!=null)
            newAppoint.Amount_After_Discount__c = appoint.amount_after_discount;
        // if(appoint.prepaid ==true)
        //   newAppoint.Prepaid__c = appoint.prepaid;
        // if(appoint.discount!=null)
        //     newAppoint.Discount__c = Decimal.valueOf(appoint.discount);
        // if(String.isNotBlank(appoint.payment_status))
        //     newAppoint.Payment_Status__c = (String)appoint.payment_status;
        if(String.isNotBlank(appoint.booking_status))
            newAppoint.Booking_Status__c = appoint.booking_status;
        //  if(String.isNotBlank(appoint.transaction_code))
        //      newAppoint.Transaction_Code__c = (String)appoint.transaction_code;
        if(String.isNotBlank(appoint.status))
            newAppoint.Status__c = appoint.status;
        if(appoint.checked_in ==true)
            newAppoint.Checked_In__c = appoint.checked_in;
        if(appoint.checked_out==true)
            newAppoint.Checked_Out__c = appoint.checked_out;
        if(String.isNotBlank(appoint.appt_original_time))
            newAppoint.Appointment_Original_Time__c = constructTime(appoint.appt_original_time);
        
        return newAppoint;
    }
    
    
    
    //Search values based on object name and column name 
    public static list<sObject> serachMaster(String objectName, String columnName, String recordtype, set<String> hisIds, set<String> leadStages){
        String query = 'SELECT Id,'+columnName+' FROM '+objectName+' WHERE ';
        query+=columnName+' IN :hisIds';
        
        if(leadStages!=null && leadStages.size()>0)
            query+=' AND Stage__c IN :leadStages';
        
        if(String.isNotBlank(recordtype))
            query+=' AND Recordtype.Name=\''+recordtype+'\'';
        list<sObject> sobjList = Database.query(query);
        return sobjList;
    } 
    
    
    
    public static DateTime constructTime(String practoTime){
        DateTime dt = system.now();
        //2019-03-25T19:45:00+05:30
        list<String> strList = practoTime.split('T');
        
        String timeStr = strList[1].substring(0,8);
        List<String> timeList = timeStr.split(':');
        
        Date tempDt = Date.valueOf(strList[0]);
        Time tempTm = Time.newInstance(Integer.valueOf(timeList[0]),Integer.valueOf(timeList[1]),Integer.valueOf(timeList[2]),0);
        
        dt = DateTime.newInstanceGmt(tempDt,tempTm);
        
        return dt;
    }
    
    
    
    //Method to generate signature
    // public static String generateSignature(String startTime,String endTime){
    public static String generateSignature(String since){
        //Variables for storing Salt and Key
        String key;
        String salt;
        //Loop through custom metadata type to get key and salt values
        for(Practo_API_Details__mdt practo : [SELECT MasterLabel, Key__c, Salt__c FROM Practo_API_Details__mdt]){
            if(String.isNotBlank(practo.Key__c))
                key = practo.Key__c;
            if(String.isNotBlank(practo.Salt__c))
                salt = practo.Salt__c;
        }
        //Create SHA512 method based encrypted signature
        //String data = key+'|'+startTime+'|'+endTime+'|'+salt;
        String data = key+'|'+since+'|'+salt;
        Blob tempBlob = Blob.valueOf(data);
        Blob encryptedData = Crypto.generateDigest('SHA-512', tempBlob);
        return EncodingUtil.convertToHex(encryptedData);
    }
    
    
    //Method to construct dateTime in Practo format
    public static String constructDateTime(String addminutes){
        
        Date todayDate = system.today();
        DateTime nowTime = system.now().addMinutes(Integer.valueOf(addminutes));
        
        String month = String.valueOf(todayDate.month());
        if(month.length()==1)
            month='0'+month;
        String day = String.valueOf(todayDate.day());
        if(day.length()==1)
            day='0'+day;
        
        String hourValue = String.valueOf(nowTime.hour());
        if(hourValue.length()==1)
            hourValue = '0'+hourValue;
        
        String minuteValue = String.valueOf(nowTime.minute());
        if(minuteValue.length()==1)
            minuteValue='0'+minuteValue;
        
        
        String practodtTime;
        practodtTime = String.valueOf(todayDate.year())+'-'+month+'-'+day;
        practodtTime+='T';
        practodtTime+=hourValue+':'+minuteValue+':00';
        practodtTime+='+530';
        
        return practodtTime;
        
    }
    
    
    
}