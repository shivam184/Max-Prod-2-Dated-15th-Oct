@suppressWarnings('PMD')public class MaxLabcallcenterApexController1{
    @AuraEnabled(cacheable = true)
    public static WrapperClass getPatientNameForMobileNumber(String searchId, Boolean isPhoneSearch){
        WrapperClass wrpCls = new WrapperClass();
        try{
            list<Lead__c> listLeads = new list<Lead__c>();
            String query = 'SELECT Id,Salutation,Name,Max_ID__c,mobilephone__c,PersonMobilePhone FROM Account WHERE RecordType.Name = \'Patient\'';
            if (isPhoneSearch){
                system.debug(isPhoneSearch);
                query += ' AND (PersonMobilePhone = :searchId OR mobilephone__c = :searchId)';
               
                String res = getUserInfo(searchId);
                //AND Source__c=\'Max Lab\'
                listLeads = searchLeadForPhone(searchId);
                if (listLeads != NULL && listLeads.size() > 0 && listLeads[0].Max_Lab_Call_History__r.size() > 0)
                    wrpCls.listCallDetails = listLeads[0].Max_Lab_Call_History__r;
                 system.debug('res'+searchId);
            } else
                query += ' AND Max_Id__c = :searchId';
            List<Account> listPatient = Database.query(query);
              
            if (listPatient != null && listPatient.size() > 0){
                if (listPatient != NULL && listPatient.size() > 1)
                    wrpCls.listPatient = listPatient;
                if (listPatient != NULL && listPatient.size() == 1)
                    if (listPatient[0].Max_Id__c != NULL){
                        WrapperClass wrpClsNew = searchPatientForPicklistApex(listPatient[0].Max_Id__c);
                    wrpCls = wrpClsNew;
                }
            } else
                wrpCls.listLeads = listLeads;
            wrpCls.status = 'SUCCESS';
             system.debug('List==>'+listPatient);

            return wrpCls;
            
        } catch (Exception e){
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
        
        
           }

    @AuraEnabled(cacheable = true)
    public static WrapperClass getPatientForMobileNumber(String searchId, Boolean isPhoneSearch){
        WrapperClass wrpCls = new WrapperClass();
        try{
            list<Lead__c> listLeads = new list<Lead__c>();
            String query = 'SELECT Id,Salutation,Name,Max_Id__c,Age__c,Gender__c,PersonEmail,mobilephone__c FROM Account WHERE RecordType.Name = \'Patient\'';
            if (isPhoneSearch){
                query += ' AND (PersonMobilePhone = :searchId OR mobilephone__c = :searchId)';
                String res = getUserInfo(searchId);
                //AND Source__c=\'Max Lab\'
                listLeads = searchLeadForPhone(searchId);
                if (listLeads != NULL && listLeads.size() > 0 && listLeads[0].Max_Lab_Call_History__r.size() > 0)
                    wrpCls.listCallDetails = listLeads[0].Max_Lab_Call_History__r;
            } else
                query += ' AND Max_Id__c = :searchId';
            List<Account> listPatient = Database.query(query);

            if (listPatient != null && listPatient.size() > 0){
                if (listPatient != NULL && listPatient.size() > 1)
                    wrpCls.listPatient = listPatient;
                if (listPatient != NULL && listPatient.size() == 1)
                    if (listPatient[0].Max_Id__c != NULL){
                        WrapperClass wrpClsNew = searchPatientForPicklistApex(listPatient[0].Max_Id__c);
                    wrpCls = wrpClsNew;
                }
            } else
                wrpCls.listLeads = listLeads;
            wrpCls.status = 'SUCCESS';
            system.debug('List======>s'+listLeads);
            return wrpCls;
        } catch (Exception e){
            wrpCls.status = e.getMessage();
          
            return wrpCls;
            //
            
        }
    }

    @AuraEnabled(cacheable = true)
    public static list<Lead__c> searchLeadForPhone(String searchId){
        List<Lead__c> listLeads = [SELECT Id, Title__c, Name, (SELECT Max_Lab_Account__r.Name, CreatedDate, Call_Type__c, Service__c, Sub_Category__c, Call_Category__c,End_disposition__C
                                                               FROM Max_Lab_Call_History__r
                                                               ORDER BY CreatedDate DESC
                                                               LIMIT 5), Age__c, Gender__c, Email__c, Mobile_Phone__c,End_disposition__C
                                   FROM Lead__c
                                   WHERE RecordType.Name = 'Max Labs Call Center' AND Mobile_Phone__c = :searchId];
       
        return listLeads;
       
    }

    @AuraEnabled(cacheable = true)
    public static WrapperClass searchPatientForPicklistApex(String maxId){
        WrapperClass wrpCls = new WrapperClass();
        try{
            //
            String query = 'SELECT Id,Salutation,Name,Max_Id__c,Age__c,Gender__c,PersonMobilePhone,PersonEmail,mobilephone__c FROM Account WHERE RecordType.Name = \'Patient\' AND Max_Id__c = :maxId';
            List<Account> listPatient = Database.query(query);

            if (listPatient != NULL && listPatient.size() > 0){

                list<Account> tempList = new list<Account>();
                tempList.add(listPatient[0]);
                wrpCls.listPatient = tempList;

                List<Transaction__c> listTransactions = new List<Transaction__c>();

                for (Transaction__c trns : [SELECT Name, CreatedDate, Net_Amount__c, Referred_Doctor__r.Name, Billing_Date_Time__c, Centre_Name__c
                                            FROM Transaction__c
                                            WHERE Patient__c = :listPatient[0].Id
                                            ORDER BY CreatedDate desc
                                            LIMIT 5])
                    listTransactions.add(trns);
                if (listTransactions != NULL && listTransactions.size() > 0)
                    wrpCls.listTransactions = listTransactions;
                String phone;
                if (listPatient[0].PersonMobilePhone != null)
                    phone = listPatient[0].PersonMobilePhone;
                else
                    phone = listPatient[0].PersonMobilePhone;
                list<Lead__c> listLeads = searchLeadForPhone(phone);
                if (listLeads != NULL && listLeads.size() > 0 && listLeads[0].Max_Lab_Call_History__r.size() > 0)
                    wrpCls.listCallDetails = listLeads[0].Max_Lab_Call_History__r;
            }
            wrpCls.status = 'SUCCESS';
            return wrpCls;

        } catch (Exception e){
            wrpCls.status = e.getMessage();
            return wrpCls;
        }
    }

    @AuraEnabled(cacheable = true)
    public static CallTypeWrapper getCallTypeApex(){
        CallTypeWrapper callWrpCls = new CallTypeWrapper();
        try{
            for (Call_Detail_Metadata__mdt callType : [SELECT Label, Sub_Category__c
                                                       FROM Call_Detail_Metadata__mdt
                                                       ORDER By Label]){
                callWrpCls.listMapKeys.add(callType.Label);
                callWrpCls.mapCallTypeToService.put(callType.Label, callType.Sub_Category__c.split(','));
            }
            for (Service_Detail_Metadata__mdt serv : [SELECT label, end_disposition__c
                                                      from Service_Detail_Metadata__mdt
                                                      order by Label]){
                callWrpCls.mapEndDispositionToService.put(serv.Label, serv.end_disposition__c.split(','));
            }
            Schema.DescribeFieldResult fieldResult = Lead__c.IVR__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry pickListVal : ple){
                callWrpCls.listIVR.add(pickListVal.getLabel());
            }
            Schema.DescribeFieldResult fieldResult2 = Lead__c.Call_Source__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for (Schema.PicklistEntry pickListVal2 : ple2){
                callWrpCls.listCallSource.add(pickListVal2.getLabel());
            }
            callWrpCls.status = 'SUCCESS';
            System.debug('===callWrpCls==listIVR==>>>' + callWrpCls.listIVR);
            System.debug('===callWrpCls==listCallSource===>>>' + callWrpCls.listCallSource);
            return callWrpCls;

        } catch (Exception e){
            callWrpCls.status = e.getMessage();
            return callWrpCls;
        }
    }
    
    @AuraEnabled
    public static CallTypeWrapper ComplaintCategoryApex(string ComplaintCategorys){
        system.debug('complaint'+ComplaintCategorys);
        CallTypeWrapper callWrpCls = new CallTypeWrapper();
        for(Complaint_Category__mdt var:[SELECT Label,Complaint_Sub_Category__c FROM Complaint_Category__mdt where Label=:ComplaintCategorys]){
            callWrpCls.listMapKeys2.add(var.Complaint_Sub_Category__c.split(','));
  
        }
        for(list<string> finallist:callWrpCls.listMapKeys2){
            callWrpCls.listcomplaintsub.addAll(finallist);
            
        }
        system.debug('Final=====>'+callWrpCls.listcomplaintsub);
            
        callWrpCls.status = 'SUCCESS';
        return callWrpCls;
    }
    
    
    
    

    @AuraEnabled
    public static String saveDataApex(string Subcatgory,string complaintcatgeory,String callingMobileNo, String mobileNo, String contactName, String contactSalutation, String contactAge, String contactGender, String contactEmail, String contactAlternateNumber, String selectedCallType, String selectedService, String selectedEndDisposition, String selectedIVR, String selectedLocationId, String callSource, String remarks, String ltngCurrTime, String currentTime, Boolean newContact, String campaignName, String preBookingId, Decimal bookingAmount, Boolean satisfiedfFeedback, String transactionId, String patientId,string Prebooking){
        try{
            
            system.debug('Remarks'+Remarks);
            system.debug('Inside selectedEndDisposition' + selectedEndDisposition);
            String parentId = '';
            System.debug('newContact-->>>>>>' + newContact);
            if (!newContact){
                if (String.isNotBlank(contactName) && String.isNotBlank(callingMobileNo)){
                    String query = 'SELECT Id FROM Lead__c WHERE RecordType.Name = \'Max Labs Call Center\' AND Mobile_Phone__c = :callingMobileNo';
                    List<Lead__c> listLead = Database.query(query);
                    System.debug('listLead--->>>>>' + listLead.size());
                    if (listLead != NULL && listLead.size() > 0){
                        parentId = listLead[0].Id;
                    }
                        
                   
                    else{
                        parentId = createLead(contactSalutation, callingMobileNo, contactAge, contactGender, contactEmail, contactName, selectedCallType, selectedService, selectedEndDisposition, selectedIVR, callSource, preBookingId, bookingAmount, satisfiedfFeedback, false, transactionId, patientId, campaignName,Subcatgory ,complaintcatgeory,Prebooking,Remarks);
                    }
                }
            } else{
                parentId = createLead(contactSalutation, callingMobileNo, contactAge, contactGender, contactEmail, contactName, selectedCallType, selectedService, selectedEndDisposition, selectedIVR, callSource, preBookingId, bookingAmount, satisfiedfFeedback, false, transactionId, patientId, campaignName,Subcatgory ,complaintcatgeory,Prebooking,Remarks);
            }

            if (String.isNotBlank(selectedCallType) && String.isNotBlank(selectedService) && selectedCallType.equalsIgnoreCase('New Booking') && selectedService.equalsIgnoreCase('Appointment Booked')){
                createLead(contactSalutation, callingMobileNo, contactAge, contactGender, contactEmail, contactName, selectedCallType, selectedService, selectedEndDisposition, selectedIVR, callSource, preBookingId, bookingAmount, satisfiedfFeedback, true, transactionId, patientId, campaignName,Subcatgory ,complaintcatgeory,Prebooking,Remarks);
            } else if (String.isNotBlank(selectedEndDisposition) && (selectedEndDisposition.equalsIgnoreCase('Prescription assistance') || selectedEndDisposition.equalsIgnoreCase('Call us back') || selectedEndDisposition.equalsIgnoreCase('Price Issue') || selectedEndDisposition.equalsIgnoreCase('Slots not available'))){
                createLead(contactSalutation, callingMobileNo, contactAge, contactGender, contactEmail, contactName, selectedCallType, selectedService, selectedEndDisposition, selectedIVR, callSource, preBookingId, bookingAmount, satisfiedfFeedback, true, transactionId, patientId, campaignName,Subcatgory ,complaintcatgeory,Prebooking,Remarks);
            }
            /* else if(String.isNotBlank(techStatus) &&(techStatus.equalsIgnoreCase('Call Again')||techStatus.equalsIgnoreCase('Need Doctor Prescription')||techStatus.equalsIgnoreCase('Test Not found')||techStatus.equalsIgnoreCase('Connection /Network Lost'))){
             createLead(contactSalutation,callingMobileNo,contactAge,contactGender,contactEmail,contactName,selectedCallType,selectedService,selectedIVR,techStatus,callSource,preBookingId,bookingAmount,satisfiedfFeedback,true,transactionId,patientId,campaignName);
             }*/

            if (String.isNotBlank(parentId)){
                System.debug('WER'+selectedCallType);
                if (String.isNotBlank(selectedCallType)){
                    Max_Lab_Call_History__c mxbhstry = new Max_Lab_Call_History__c();
                    //Create History Record
                    mxbhstry = createHistoryRecord(currentTime, contactName, ltngCurrTime, callingMobileNo, selectedCallType, selectedService, selectedEndDisposition, selectedIVR, callSource, selectedLocationId, remarks, parentId, campaignName);
                    if (mxbhstry != Null){
                        insert mxbhstry;
                    }

                    System.debug('Id-->' + mxbhstry.Id);
                }
            }
            if (String.isNotBlank(selectedCallType) && String.isNotBlank(selectedService) && selectedCallType.equalsIgnoreCase('Existing Booking') && selectedService.equalsIgnoreCase('Appointment Reschedule / Cancel')){
                String recordId = searchLeadByMobileNo(mobileNo);
                if (String.isNotBlank(recordId)){
                    system.debug('recordId:-' + recordId);
                    return 'Record Created Successfully#' + recordId;
                } else{
                    system.debug('Record Created Successfully#notFound:-');
                    return 'Record Created Successfully#notFound';
                }
            }
            return 'Record Created Successfully';
        } catch (Exception e){
            system.debug('e.getMessage();' + e.getMessage());
            return e.getMessage();
        }
    }

    public static String createLead(String contactSalutation,String callingMobileNo, String contactAge, String contactGender, String contactEmail, String contactName, String selectedCallType, String selectedService, String selectedEndDisposition, String selectedIVR, String callSource, String preBookingId, Decimal bookingAmount, Boolean satisfiedfFeedback, Boolean isNewBooking, String transactionId, String patientId, String campaignName,string Subcatgory,string complaintcatgeory,string Prebooking,string Remarks){
        system.debug('Inside CreateLead');
        system.debug('Subcatgory'+Subcatgory);
        system.debug('Subcatgory'+complaintcatgeory);
        system.debug('Prebooking'+ Prebooking);
        system.debug('Remarks'+Remarks);
      
        Lead__c lea = new Lead__c();
        String recordTypeIdLead = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Labs Call Center').getRecordTypeId();
        if (String.isNotBlank(recordTypeIdLead))
            lea.RecordTypeId = recordTypeIdLead;
        lea.Title__c = contactSalutation;
        if (String.isNotBlank(patientId) && patientId.startsWith(Account.SObjectType.getDescribe().getKeyPrefix())){
            lea.Lab_patient_name__c = patientId;
            // lea.Address_Master__c = patientId;
        }
        lea.Mobile_Phone__c = callingMobileNo;
        lea.Gender__c = contactGender;
        lea.Email__c = contactEmail;
        lea.Name = contactName;
        lea.Transaction__c = transactionId;
        lea.Call_Category__c = selectedCallType;
        lea.Sub_Category__c = selectedService;
        lea.End_Disposition__c = selectedEndDisposition;
        lea.IVR__c = selectedIVR;
        lea.Remarks__c=Remarks;
        //  lea.Tech_Status__c = techStatus;
        lea.Call_Source__c = callSource;
        lea.Are_You_Satisfied_With_Call__c = satisfiedfFeedback;
        lea.Pre_booking_id__c = preBookingId;
        lea.Booking_Amount__c = bookingAmount;
        lea.Campaign_Name__c = campaignName;
        lea.Complaint_Category__c =complaintcatgeory;
        lea.Complaint_Sub_Category__c=Subcatgory;
        if (String.isNotBlank(complaintcatgeory) && String.isNotBlank(Subcatgory)){
            lea.Stage_Status__c = 'New';
            lea.Complaint_Number__c = 'C-' + String.valueOf(Datetime.now().formatGMT('MMddHHmmss'));
        }
        if (isNewBooking){
            lea.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        }
        insert lea;
        return lea.Id;
    }

    public static String getUserInfo(String phoneno){
        String body = '';

        try{
            if (phoneno != null && phoneno != '')
                body = '"Mobile No":' + phoneno + '';
            Http hreq = new Http();
            HttpRequest req = new HttpRequest();
            String url = 'http:';
            req.setEndpoint(url) ;
            req.setHeader('Content-Type', 'application-json');
            req.setHeader('User-Agent', 'M022433');
            req.setHeader('Content-Length', '1574');
            req.setHeader('Authorization', 'Basic  TTAyMjQzMzpQYXNzdzByZA==');
            req.setHeader('Host', '10.208.122.35');
            req.setHeader('Password', 'Passw0rd');
            req.setBody(body);
            HttpResponse res = hreq.send(req);


            if (res.getStatusCode() == 200){
                String str = res.getBody();
                if (String.isNotBlank(str)){
                    Map<String, Object> mapKeyToValue = (Map<String, Object>)Json.deserializeUntyped(str);
                    if (mapKeyToValue != null && mapKeyToValue.keySet().size() > 0){
                        return (string) mapKeyToValue.get('Caller Type');
                    }
                }
                return 'Response Is Empty';
            }
            return res.getStatusCode() + '';
        } catch (Exception e){
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static String searchLeadByMobileNo(String mobileNo){
        String recordId = '';
        String accountId = '';
        if (String.isNotBlank(mobileNo)){
            List<Lead__c> listLead = [Select Id, Lab_patient_name__c
                                      from Lead__c
                                      WHERE (Mobile_Phone__c = :mobileNo OR Maxlab_Mobile_no__c = :mobileNo) AND RecordType.Name = 'Max Lab Customer lead'
                                      ORDER BY createdDate desc];
            if (listLead.size() > 0){
                recordId = listLead[0].id;
                accountId = listLead[0].Lab_patient_name__c;
            }
        }
        return recordId;
    }

    @AuraEnabled
    public static Max_Lab_Call_History__c createHistoryRecord(String currentTime, String contactName, String ltngCurrTime, String callingMobileNo, String selectedCallType, String selectedService, String selectedEndDisposition, String selectedIVR, String callSource, String selectedLocationId, String remarks, String parentId, String campaignName){
        // Map<Id,Business_Unit__c> mapBusinessUnit = new Map<Id,Business_Unit__c>([SELECT Id,Name,Unit_Name_Custom__c FROM Business_Unit__c]);
        Max_Lab_Call_History__c mxbhstry = new Max_Lab_Call_History__c();

        mxbhstry.Call_Start_Time__c = String.valueOf(System.today()) + ' ' + currentTime;
        mxbhstry.Name = contactName;
        mxbhstry.Call_Time__c = ltngCurrTime;
        if (String.isNotBlank(callingMobileNo))
            mxbhstry.Calling_Number__c = callingMobileNo;
        mxbhstry.Call_Category__c = selectedCallType;
        mxbhstry.Sub_Category__c = selectedService;
        mxbhstry.end_disposition__c = selectedEndDisposition;
        mxbhstry.IVR__c = selectedIVR;
        // mxbhstry.Tech_Status__c = techStatus;
        mxbhstry.Call_Source__c = callSource;
        mxbhstry.Campaign_Name__c = campaignName;
        if (String.isNotBlank(selectedLocationId)){
            // if(mapBusinessUnit != NULL && mapBusinessUnit.keySet().size() > 0 && mapBusinessUnit.containsKey(selectedLocationId)) {
            //   mxbhstry.Location_Name__c = mapBusinessUnit.get(selectedLocationId).Name;
            //   mxbhstry.Business_Unit__c = mapBusinessUnit.get(selectedLocationId).Unit_Name_Custom__c;
            //   mxbhstry.Max_Lab_Account__c = selectedLocationId;
            mxbhstry.Address_Master__c = selectedLocationId;
            //}
        }

        mxbhstry.Remarks__c = remarks;
        if (String.isNotBlank(callingMobileNo))
            mxbhstry.Leads__c = parentId;
        return mxbhstry;
    }

    public class WrapperClass{
        @AuraEnabled
        public string status;
        @AuraEnabled
        public List<Account> listPatient;
        @AuraEnabled
        public List<Lead__c> listLeads;
        @AuraEnabled
        public List<Max_Lab_Call_History__c> listCallDetails;
        @AuraEnabled
        public Integer probability;
        @AuraEnabled
        public List<Transaction__c> listTransactions;
        @AuraEnabled
        public String preferredChannel;
        @AuraEnabled
        public Integer conversionProbability;
        

        public WrapperClass(){
            status = '';
            listPatient = new List<Account>();
            listLeads = new List<Lead__c>();
            listCallDetails = new List<Max_Lab_Call_History__c>();
            probability = 0;
            listTransactions = new List<Transaction__c>();
            preferredChannel = '';
            conversionProbability = 0;
        }

    }

    public class CallTypeWrapper{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Map<String, List<String>> mapCallTypeToService;
        @AuraEnabled
        public Map<String, List<String>> mapEndDispositionToService;
        @AuraEnabled
        public List<String> listMapKeys;
        @AuraEnabled
        public List<String> listIVR;
        @AuraEnabled
        public List<String> listCallSource;
        @AuraEnabled
        public List<list<String>> listMapKeys2;
        @AuraEnabled
        public Map<String,List<list<String>>> Mapsubcomplaint;
        @AuraEnabled
        public List<String> listcomplaintsub;
       
        public CallTypeWrapper(){
            status = '';
            mapCallTypeToService = new Map<String, List<String>>();
            mapEndDispositionToService = new Map<String, List<String>>();
            listMapKeys = new List<String>();
            listIVR = new List<String>();
            listCallSource = new List<String>();
            listMapKeys2 = new List<list<String>>();
             Mapsubcomplaint = new Map<String,List<list<String>>>();
            listcomplaintsub=new List<String>();
        }

    }

}