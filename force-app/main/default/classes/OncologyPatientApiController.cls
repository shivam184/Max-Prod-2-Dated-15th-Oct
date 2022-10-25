@RestResource(urlMapping='/OncologyPatientJourney/*')
global class OncologyPatientApiController {
    @HttpPOST
    global static void doCreateRecords(){
        Savepoint sp = Database.setSavepoint();
        try{
        RestRequest request = RestContext.request;
        String entityName = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        if(String.isNotBlank(request.requestBody.toString())) {
            system.debug('request.requestBody.toString()--->'+request.requestBody.toString());
            
            system.debug('entityName--->'+entityName);
            Map<String,Object> mapKeyToValue = (Map<String,Object>)JSON.deserializeUntyped(request.requestBody.toString());
            List<Object> listObject = (List<Object>)mapKeyToValue.get('Data');
            
            if(String.isNotBlank(entityName)){
                if(entityName == Label.OncologyEprescription) {
                   
                                            List<oncology_patient_journey__c> oncologyList = new List<oncology_patient_journey__c>();
                    Map<String, string> oncologyPatientMap1 = new Map<String, string>();
                    Set<String> maxPatientID = new set<String>();
                    for(Integer i=0 ; i < listObject.size() ; i++) {
                        Map<String,Object> oncologyPatientMap = (Map<String,Object>)listObject[i]; 
                        oncology_patient_journey__c oncology = new oncology_patient_journey__c();
                        if(oncologyPatientMap != NULL && oncologyPatientMap.keySet().size() > 0) {
                            
                            if(oncologyPatientMap.containsKey('Maxid') && oncologyPatientMap.get('Maxid') != NULL) {
                                oncology.Patient_Max_id__c  = (String)oncologyPatientMap.get('Maxid');
                                maxPatientID.add(oncology.Patient_Max_id__c); 
                            }
                            if(oncologyPatientMap.containsKey('EPrescriptionNo') && oncologyPatientMap.get('EPrescriptionNo') != NULL) {
                                oncology.EP_Number__c  = (String)oncologyPatientMap.get('EPrescriptionNo');
                                oncology.E_Precription__c = true ;
                                
                            }
                            if(oncologyPatientMap.containsKey('RequiredMoreinvestigation') && oncologyPatientMap.get('RequiredMoreinvestigation') != NULL) {
                                oncology.Requires_More_Investigation__c  =(Boolean) oncologyPatientMap.get('RequiredMoreinvestigation');
                                
                            }
                            if(oncologyPatientMap.containsKey('Malignant') && oncologyPatientMap.get('Malignant') != NULL) {
                                oncology.Malignant__c  =  (Boolean)oncologyPatientMap.get('Malignant');
                                
                            }
                            if(oncologyPatientMap.containsKey('Benign') && oncologyPatientMap.get('Benign') != NULL) {
                                oncology.Benign__c  = (Boolean) oncologyPatientMap.get('Benign');
                                
                            }
                        }
                        oncologyList.add(oncology);
                        
                        system.debug('oncolist==='+oncologyList);
                    }
                    List<id> erroridlist = new list<id>();
                    list<id> idlist = new list<id>(); 
                    if(oncologyList != NULL && oncologyList.size() > 0)
                    {
                        List<oncology_patient_journey__c> listOncologypatientjourneyUpdate = new List<oncology_patient_journey__c>();
                        if(maxPatientID != null && maxPatientID.size() > 0)
                        {
                            for(oncology_patient_journey__c oncology : [SELECT Id, Patient_Max_id__c, Requires_More_Investigation__c, Malignant__c, Benign__c, EP_Number__c 
                                                                        FROM oncology_patient_journey__c
                                                                        WHERE Patient_Max_id__c IN :maxPatientID]) 
                            {
                                
                                oncologyPatientMap1.put(oncology.Patient_Max_id__c, oncology.id);
                            }
                            
                        }
                         List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        for(oncology_patient_journey__c rwrap: oncologyList){
                            system.debug('dfghjkl');
                            //oncology_patient_journey__c oncologyPatient = oncologyPatientMap.get(rwrap.patientMaxID);
                            if(oncologyPatientMap1.containsKey(rwrap.Patient_Max_id__c)) {
                                //rwrap.Id = oncologyPatientMap1.get(rwrap.Patient_Max_id__c);
                                System.debug('12345');
                                oncology_patient_journey__c oncologyPatient = new oncology_patient_journey__c();
                                oncologyPatient.id =  oncologyPatientMap1.get(rwrap.Patient_Max_id__c);
                                oncologyPatient.Requires_More_Investigation__c = rwrap.Requires_More_Investigation__c;
                                oncologyPatient.Malignant__c = rwrap.Malignant__c;
                                oncologyPatient.Benign__c   = rwrap.Benign__c;
                                oncologyPatient.EP_Number__c = rwrap.EP_Number__c;
                                oncologyPatient.E_Precription__c = true ;
                                listOncologypatientjourneyUpdate.add(oncologyPatient);
                            }
                            else{
                               API_Error_Log__c apiError = new API_Error_Log__c();
                                    apiError.API_Name__c = 'Oncology Patient Journey';
                                   // apiError.Error_Message__c = String.valueOf(srList1[i].getErrors());
                                    apiError.Trigger_Point__c = 'oncology-Patient Journey';
                                    apiError.Record_Identifier__c = rwrap.Patient_Max_id__c;
                                listApiErrorLog.add(apiError);
                                
                            }
                        }
                        system.debug('=======Updated Oncology List ===='+listOncologypatientjourneyUpdate);
                        string ids ='';
                        //List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        if(listOncologypatientjourneyUpdate.size() > 0) {
                         
                            Database.SaveResult[] srList1 = Database.update(listOncologypatientjourneyUpdate,false);
                           system.debug('===================SrList ==='+srList1);
                            for(Integer i=0;i<srList1.size();i++){
                                if(srList1[i].isSuccess()){
                                     ids += srList1[i].getId() + ',';
                                    idlist.add(srList1[i].getId());
                                   
                                }
                               
                            }
                           
                        }
                         if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            {
                                insert listApiErrorLog;
                            }
                            for(API_Error_Log__c apiError : listApiErrorLog)
                            {
                                      erroridlist.add(apiError.id);
                           }
                            system.debug('Error List Data ==='+listApiErrorLog);
                        List<oncology_patient_journey__c> oncoList = [select id,Patient_Max_id__c,EP_Number__c from oncology_patient_journey__c where id IN: idlist];
                        List<API_Error_Log__c> ErrorLogDataList = [select id,Record_Identifier__c  from API_Error_Log__c where  ID In : erroridlist];
                                System.debug('==========================> ' + ErrorLogDataList);
                        // If Response is getting in Array format 
                   
                        String jsonresponse = '[';
                        
                        for(oncology_patient_journey__c onco : oncoList){
                            
                            jsonresponse+=' {';
                            jsonresponse+='   "EP-Number":"'+onco.EP_Number__c+'" ,';
							 jsonresponse+='   "Lead Id":"'+onco.Id+'" ,';
                            
                            jsonresponse+='  "Status": "success",';
                            jsonresponse+='   "Message":"Record Updated Successfully "';
                            jsonresponse+='},';
                            
                        }
                        for(API_Error_Log__c error : ErrorLogDataList){
                                           
                            jsonresponse+=' {';
                            
                            jsonresponse+=' "MAX ID": "'+error.Record_Identifier__c+'",';
                            
                            jsonresponse+='  "Status": "Failure",';
                            jsonresponse+='   "Message":"Patient Max Id Not Present in System "';
                            
                            jsonresponse+='},';
                                                        
                            }
                        jsonresponse=jsonresponse.removeEnd(',');
                        
                        jsonresponse+=']';
                        
                        
                        
                        //String jsonStr = '{"success" : true,"message" : "Test data ","LeadID" : "'+Ids+'"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonresponse);
                       // String jsonStr = '{"success" : true,"message" : "Oncology Patient Journey Updated  Successfully","Lead ID" :"'+ids+'"}';
                       // RestContext.response.addHeader('Content-Type', 'application/json');
                       //RestContext.response.responseBody = Blob.valueOf(jsonresponse);
                        return;
                        
                    } 
                    
             
            }//End IF OncologyEprescription
                // For OncoTracker API
				   else if(entityName == Label.OncoTracker) {     
                   List<Prospect__c> prospectList = new List<Prospect__c>();
                    Map<String, string> prospectMapID = new Map<String, string>();
                    Set<String> maxPatientIDSet = new set<String>();
                    for(Integer i=0 ; i < listObject.size() ; i++) {
                        Map<String,Object> prospectMap = (Map<String,Object>)listObject[i]; 
                        Prospect__c prospectObj = new Prospect__c();
                        if(prospectMap != NULL && prospectMap.keySet().size() > 0) {
                            
                            if(prospectMap.containsKey('MaxID') && prospectMap.get('MaxID') != NULL) {
                               
                                prospectObj.Max_Id__c  = (String)prospectMap.get('MaxID');
                                maxPatientIDSet.add(prospectObj.Max_Id__c); 
                                 
                            }
                            if(prospectMap.containsKey('Referstotumourboard') && prospectMap.get('Referstotumourboard') != NULL) {
                                prospectObj.Refers_to_tumour_board__c  = (Boolean)prospectMap.get('Referstotumourboard');
                                
                                
                            }
                            if(prospectMap.containsKey('DMG') && prospectMap.get('DMG') != NULL) {
                                prospectObj.DMG__c  =(String) prospectMap.get('DMG');
                                
                                
                            }
                            if(prospectMap.containsKey('Surgery') && prospectMap.get('Surgery') != NULL) {
                                prospectObj.Surgery__c  =  (Boolean)prospectMap.get('Surgery');
                                 
                                
                            }
                            if(prospectMap.containsKey('Chemo') && prospectMap.get('Chemo') != NULL) {
                                prospectObj.Chemo__c  = (Boolean) prospectMap.get('Chemo');
                                 
                                
                            }
							 if(prospectMap.containsKey('RT') && prospectMap.get('RT') != NULL) {
                                prospectObj.RT__c  = (Boolean) prospectMap.get('RT');
                                  
                                
                            }
							if(prospectMap.containsKey('CTRT') && prospectMap.get('CTRT') != NULL) {
                                prospectObj.CTRT__c  = (Boolean) prospectMap.get('CTRT');
                                 
                                
                            }
							if(prospectMap.containsKey('SurRT') && prospectMap.get('SurRT') != NULL) {
                                prospectObj.SurRT__c  = (Boolean) prospectMap.get('SurRT');
                                  
                                
                            }
							if(prospectMap.containsKey('SurCT') && prospectMap.get('SurCT') != NULL) {
                                prospectObj.SurCT__c  = (Boolean) prospectMap.get('SurCT');
                                  
                                
                            }
							if(prospectMap.containsKey('TreatmentStarted') && prospectMap.get('TreatmentStarted') != NULL) {
                                prospectObj.Treatment_Started__c  = (Boolean) prospectMap.get('TreatmentStarted');
                                  
                                
                            }
							if(prospectMap.containsKey('TreatmentCompleted') && prospectMap.get('TreatmentCompleted') != NULL) {
                                prospectObj.Treatment_Completed__c  = (Boolean) prospectMap.get('TreatmentCompleted');
                                  
                                
                            }
                            if(prospectMap.containsKey('Surgical') && prospectMap.get('Surgical') != NULL) {
                                prospectObj.Surgical__c  = (Boolean) prospectMap.get('Surgical');
                                 
                                
                            }
                            if(prospectMap.containsKey('Medical') && prospectMap.get('Medical') != NULL) {
                                prospectObj.Medical__c  = (Boolean) prospectMap.get('Medical');
                                  
                                
                            }
                            if(prospectMap.containsKey('Radiation') && prospectMap.get('Radiation') != NULL) {
                                prospectObj.Radiation__c  = (Boolean) prospectMap.get('Radiation');
                                  
                                
                            }
                               if(prospectMap.containsKey('oncono') && prospectMap.get('oncono') != NULL) {
									prospectObj.OncoNumber__c  = (String)prospectMap.get('oncono');
                                     
									
								}
                            if(prospectMap.containsKey('Diagnosis') && prospectMap.get('Diagnosis') != NULL) {
									prospectObj.Diagnosis__c  = (String)prospectMap.get('Diagnosis');
                                  
									
								}
                            if(prospectMap.containsKey('OncoStage') && prospectMap.get('OncoStage') != NULL) {
									prospectObj.OncoStage__c  = (String)prospectMap.get('OncoStage');
                                  
									
								}
                            if(prospectMap.containsKey('PathologyPrescribe') && prospectMap.get('PathologyPrescribe') != NULL) {
									prospectObj.Radiology_Prescribe__c  = (String)prospectMap.get('PathologyPrescribe');
                                  
									
								}
                            if(prospectMap.containsKey('RadiologyPrescribe') && prospectMap.get('RadiologyPrescribe') != NULL) {
									prospectObj.Pathology_Prescribe__c  = (String)prospectMap.get('RadiologyPrescribe');
                                  
									
								}
                               if(prospectMap.containsKey('DiscountReason') && prospectMap.get('DiscountReason') != NULL) {
									prospectObj.Discount_Reason__c  = (String)prospectMap.get('DiscountReason');
                                  
									
								}
                            if(prospectMap.containsKey('ProcedureName') && prospectMap.get('ProcedureName') != NULL) {
									prospectObj.Procedure_Name__c  = (String)prospectMap.get('ProcedureName');
                                  
									
								}
                            if(prospectMap.containsKey('PrescriptionDate') && prospectMap.get('PrescriptionDate') != NULL) {
                                String dateStr = (String)prospectMap.get('PrescriptionDate');
                                if(String.isNotBlank(dateStr))
                                    prospectObj.Prescription_Date__c = Date.valueOf((String)prospectMap.get('PrescriptionDate')); 
                                
								}
                            if(prospectMap.containsKey('VisitDate') && prospectMap.get('VisitDate') != NULL) {
                                String dateStr = (String)prospectMap.get('VisitDate');
                                if(String.isNotBlank(dateStr))
                                    prospectObj.Visit_Date__c = Date.valueOf((String)prospectMap.get('VisitDate')); 
                                
								}
                               if(prospectMap.containsKey('DATEOFADMISSION') && prospectMap.get('DATEOFADMISSION') != NULL) {
                                String dateStr = (String)prospectMap.get('DATEOFADMISSION');
                                if(String.isNotBlank(dateStr))
                                    prospectObj.Admission_Date__c = Date.valueOf((String)prospectMap.get('DATEOFADMISSION')); 
                                
								}
                            
                              if(prospectMap.containsKey('PayerChannel') && prospectMap.get('PayerChannel') != NULL) 
                              {
									prospectObj.Payer_Channel__c  = (String)prospectMap.get('PayerChannel');
                                  prospectObj.Company_Type__c  = (String)prospectMap.get('PayerChannel');
                                  
								}
								
                            
                             prospectList.add(prospectObj);
                        }
                       
                        
                        
                        system.debug('prospectList==='+prospectList);
                    }
                    List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                       List<id> erroridlist = new list<id>();
                    list<id> idlist1 = new list<id>(); 
                       system.debug('prospectList' +prospectList);
                       system.debug('maxPatientIDSet' +maxPatientIDSet);
                    if(prospectList != NULL && prospectList.size() > 0)
                    {
                        List<Prospect__c> prospectListtoUpdate = new List<Prospect__c>();
                        
                        if(maxPatientIDSet != null && maxPatientIDSet.size() > 0)
                        {
                            System.debug('Inside IF');
                            for(Prospect__c pros : [SELECT Id, Max_Id__c
                                                                        FROM Prospect__c
                                                                        WHERE Max_Id__c IN :maxPatientIDSet]) 
                            {
                                
                                prospectMapID.put(pros.Max_Id__c, pros.id);
                            }
                            
                        
                        
                        for(Prospect__c rwrap: prospectList){
                            
                            if(prospectMapID.containsKey(rwrap.Max_Id__c)) {
                                //rwrap.Id = prospectMap1.get(rwrap.Max_Id__c);
                                Prospect__c prospect = new Prospect__c();
                                prospect.id =  prospectMapID.get(rwrap.Max_Id__c);
                                prospect.Refers_to_tumour_board__c = rwrap.Refers_to_tumour_board__c;
                                prospect.DMG__c = rwrap.DMG__c;
                                prospect.Surgery__c   = rwrap.Surgery__c;
                                prospect.Chemo__c = rwrap.Chemo__c;
								prospect.RT__C = rwrap.RT__C;
								prospect.CTRT__c = rwrap.CTRT__c;
								prospect.SurRT__c = rwrap.SurRT__c;
								prospect.SurCT__c = rwrap.SurCT__c;
                                prospect.OncoNumber__c =rwrap.OncoNumber__c;
								prospect.Treatment_Started__c = rwrap.Treatment_Started__c;
								prospect.Treatment_Completed__c = rwrap.Treatment_Completed__c;
                                prospect.Surgical__c =rwrap.Surgical__c;
                                prospect.Medical__c =rwrap.Medical__c;
                                prospect.Radiation__c=rwrap.Radiation__c;
                                prospect.Diagnosis__c=rwrap.Diagnosis__c;
                                prospect.OncoStage__c=rwrap.OncoStage__c;
                                prospect.Radiology_Prescribe__c  =rwrap.Radiology_Prescribe__c;
                                prospect.Pathology_Prescribe__c =rwrap.Pathology_Prescribe__c;
                                prospect.Prescription_Date__c =rwrap.Prescription_Date__c;
                                prospect.Admission_Date__c =rwrap.Admission_Date__c;
                                prospect.Discount_Reason__c =rwrap.Discount_Reason__c;
                                prospect.Procedure_Name__c =rwrap.Procedure_Name__c;
                                prospect.Visit_Date__c =rwrap.Visit_Date__c;
                                prospect.Payer_Channel__c =rwrap.Payer_Channel__c;
                                prospect.Company_Type__c =rwrap.Company_Type__c;
                                prospectListtoUpdate.add(prospect);
                            }
                            else {
                                system.debug('Inside Else');
                                  API_Error_Log__c apiError = new API_Error_Log__c();
                                    apiError.API_Name__c = 'Oncology Patient Journey Prospect Object';
                                    apiError.Error_Message__c = String.valueOf(rwrap.getErrors());
                                    apiError.Trigger_Point__c = 'Procept Object';
                                    apiError.Record_Identifier__c = rwrap.Max_Id__c;
                                    listApiErrorLog.add(apiError); 

                            }
                        }
                    }
                        system.debug('=======listApiErrorLog ===='+listApiErrorLog);
                        system.debug('=======Updated Oncology List ===='+prospectListtoUpdate);
                        string ids ='';
                        //List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        if(prospectListtoUpdate.size() > 0) {
                          
                            Database.SaveResult[] srList1 = Database.update(prospectListtoUpdate,false);
                           system.debug('=======prospectListtoUpdate=========='+prospectListtoUpdate);
                            for(Integer i=0;i<srList1.size();i++){
                                if(srList1[i].isSuccess()){
                                        ids += srList1[i].getId() + ',';
                                    idlist1.add(srList1[i].getId());                               
                                    
                                }
                               
                            }
  
                        }
                         if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            {
                                insert listApiErrorLog;
                            }
                         system.debug('Error List Data ==='+listApiErrorLog);
                            for(API_Error_Log__c apiError : listApiErrorLog)
                            {
                                      erroridlist.add(apiError.id);
                           }
                            system.debug('Error ID Data set ==='+erroridlist);
                            system.debug('Error List Data ==='+listApiErrorLog);
                        List<Prospect__c> prosList = [select id,Max_Id__c,OncoNumber__c from Prospect__c where id IN: idlist1];
                         List<API_Error_Log__c> ErrorLogDataList = [select id,Record_Identifier__c  from API_Error_Log__c where  ID In : erroridlist];
                        system.debug('Error List Data'+ErrorLogDataList );
                       
                        String jsonresponse = '[';
                        
                        for(Prospect__c pros : prosList){
                            
                            jsonresponse+=' {';
							 jsonresponse+='   "Lead Id":"'+pros.Id+'" ,';
                             jsonresponse+='   "OncoNumber":"'+pros.OncoNumber__c+'" ,';
                            jsonresponse+='  "Status": "success",';
                            jsonresponse+='   "Message":"Record Updated Successfully "';
                            jsonresponse+='},';
                            
                        }
                       for(API_Error_Log__c error : ErrorLogDataList){
                                           
                            jsonresponse+=' {';
                            
                            jsonresponse+=' "MAX ID": "'+error.Record_Identifier__c+'",';
                            
                            jsonresponse+='  "Status": "Failure",';
                            jsonresponse+='   "Message":"Patient Max Id Not Present in System "';
                            
                            jsonresponse+='},';
                                                        
                           }
                        jsonresponse=jsonresponse.removeEnd(',');
                        
                        jsonresponse+=']';
                        
                        //String jsonStr = '{"success" : true,"message" : "Test data ","LeadID" : "'+Ids+'"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonresponse);
                        //String jsonStr = '{"success" : true,"message" : "Oncology Patient Journey  Prospect Updated  Successfully","Lead ID" :"'+ids+'"}';
                        //RestContext.response.addHeader('Content-Type', 'application/json');
                       //RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                    }
				   }// End OncoTracker	
                       
                      // For Chemo API//Chemo
                    else if(entityName == Label.Chemo) {
                      List<ID> erroridLIST = new List<ID>();
                       List<Chemo_Appointment__c> chemoList = new List<Chemo_Appointment__c>();
                        Map<String, Prospect__c> chemoMap = new Map<String, Prospect__c>();
                        Set<String> maxIDSet = new set<String>();
                        for(Integer i=0 ; i < listObject.size() ; i++) {
                        Map<String,Object> chemoMapObj = (Map<String,Object>)listObject[i]; 
                        Chemo_Appointment__c chemoObj = new Chemo_Appointment__c();
						
                        if(chemoMapObj != NULL && chemoMapObj.keySet().size() > 0) {
                            System.debug('Test');
                            if(chemoMapObj.containsKey('Maxid') && chemoMapObj.get('Maxid') != NULL) {
                                chemoObj.Max_Id__c  = (String)chemoMapObj.get('Maxid');
                                maxIDSet.add(chemoObj.Max_Id__c); 
                            }
							
                            if(chemoMapObj.containsKey('Title') && chemoMapObj.get('Title') != NULL) {
                                chemoObj.Title__c  = (String)chemoMapObj.get('Title');
                                
                            }
							if(chemoMapObj.containsKey('FirstName') && chemoMapObj.get('FirstName') != NULL) {
                                chemoObj.First_Name__c  = (String)chemoMapObj.get('FirstName');
                                
                            }
							if(chemoMapObj.containsKey('LastName') && chemoMapObj.get('LastName') != NULL) {
                                chemoObj.Last_Name__c  = (String)chemoMapObj.get('LastName');
                                
                            }
							  if(chemoMapObj.containsKey('DrugName') && chemoMapObj.get('DrugName') != NULL) {
									chemoObj.Drug_Name__c  = (String)chemoMapObj.get('DrugName');
									
								}
								 if(chemoMapObj.containsKey('Drugtype') && chemoMapObj.get('Drugtype') != NULL) {
									chemoObj.Drug_type__c  = (String)chemoMapObj.get('Drugtype');
									
								}
									 if(chemoMapObj.containsKey('DrugNameSecondary') && chemoMapObj.get('DrugNameSecondary') != NULL) {
									chemoObj.Drug_Name_Secondary__c  = (String)chemoMapObj.get('DrugNameSecondary');
									
								}
								
									 if(chemoMapObj.containsKey('Estimate') && chemoMapObj.get('Estimate') != NULL) {
									chemoObj.Estimate__c  = (String)chemoMapObj.get('Estimate');
									
								}
								
								if(chemoMapObj.containsKey('ProcedureType') && chemoMapObj.get('ProcedureType') != NULL) {
									chemoObj.Procedure_Type__c  = (String)chemoMapObj.get('ProcedureType');
									
								}
								 if(chemoMapObj.containsKey('Age') && chemoMapObj.get('Age') != NULL) {
									chemoObj.Age__c  = (String)chemoMapObj.get('Age');
									
								}
								 if(chemoMapObj.containsKey('EmailId') && chemoMapObj.get('EmailId') != NULL) {
									chemoObj.Email_Id__c  = (String)chemoMapObj.get('EmailId');
									
								}
							 if(chemoMapObj.containsKey('Phoneno') && chemoMapObj.get('Phoneno') != NULL) {
                                 String intStr = (String)chemoMapObj.get('Phoneno');
                                        if(String.isNotBlank(intStr))
                                            chemoObj.Phone_Number__c = Integer.valueOf((String)chemoMapObj.get('Phoneno')); 
									
									
								}
								if(chemoMapObj.containsKey('Admissiondate') && chemoMapObj.get('Admissiondate') != NULL) {
                                     String dateStr = (String)chemoMapObj.get('Admissiondate');
                                        if(String.isNotBlank(dateStr))
                                            chemoObj.Admission_Date__c = Date.valueOf((String)chemoMapObj.get('Admissiondate'));  
									
									
								}
								if(chemoMapObj.containsKey('Gender') && chemoMapObj.get('Gender') != NULL) {
									chemoObj.Gender__c  = (String)chemoMapObj.get('Gender');
									
								}
								if(chemoMapObj.containsKey('DMG') && chemoMapObj.get('DMG') != NULL) {
									chemoObj.DMG__c  = (string)chemoMapObj.get('DMG');
									
								}
								if(chemoMapObj.containsKey('Diagnosis') && chemoMapObj.get('Diagnosis') != NULL) {
									chemoObj.Diagnosis__c  = (String)chemoMapObj.get('Diagnosis');
									
								}
								if(chemoMapObj.containsKey('Admittingdoctor') && chemoMapObj.get('Admittingdoctor') != NULL) {
									chemoObj.Admitting_doctor__c  = (String)chemoMapObj.get('Admittingdoctor');
									
								}
									if(chemoMapObj.containsKey('ProcedureDate') && chemoMapObj.get('ProcedureDate') != NULL) {
                                         String procedureDate = (String)chemoMapObj.get('ProcedureDate');
                                        if(String.isNotBlank(procedureDate))
                                            chemoObj.Procedure_Date__c = Datetime.valueOf((String)chemoMapObj.get('ProcedureDate'));  
									//chemoObj.Procedure_Date__c  = (String)chemoMapObj.get('Procedure Date');
									
								}
									if(chemoMapObj.containsKey('FollowUpDate') && chemoMapObj.get('FollowUpDate') != NULL) {
                                        String followUpDate = (String)chemoMapObj.get('FollowUpDate');
                                        if(String.isNotBlank(followUpDate))
                                            chemoObj.Follow_Up_Date__c = Datetime.valueOf((String)chemoMapObj.get('FollowUpDate'));
									//chemoObj.Follow_Up_Date__c  = (String)chemoMapObj.get('Follow Up Date');
									
								}
                                    if(chemoMapObj.containsKey('Chemoid') && chemoMapObj.get('Chemoid') != NULL) {
									chemoObj.Chemo_Id__c  = (String)chemoMapObj.get('Chemoid');
									
								}
								if(chemoMapObj.containsKey('Remark') && chemoMapObj.get('Remark') != NULL) {
									chemoObj.Remark__c  = (String)chemoMapObj.get('Remark');
									
								}
                         
                            
                        }
                        chemoList.add(chemoObj);
                       }  
                         List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        system.debug('chemoList==='+chemoList);
                       list<id> idlist1 = new list<id>(); 
                    if(	chemoList!= NULL && chemoList.size() > 0)
                    {
                        List<Chemo_Appointment__c> chemoListInsert = new List<Chemo_Appointment__c>();
                        if(maxIDSet != null && maxIDSet.size() > 0)
                        {
                            for(Prospect__c pros : [SELECT Id, Max_Id__c FROM Prospect__c
                                                                        WHERE Max_Id__c IN :maxIDSet]) 
                            {
                               
                                chemoMap.put(pros.Max_Id__c, pros);
                            }
                            
                        }
                        
                        for(Chemo_Appointment__c rwrap: chemoList){
                             if(chemoMap.ContainsKey(rwrap.Max_Id__c))
                             {
                                 rwrap.Prospect__c = chemoMap.get(rwrap.Max_Id__c).ID;
                                 chemoListInsert.add(rwrap);
                             }
                            else {
                                system.debug('Inside Else');
                                  API_Error_Log__c apiError = new API_Error_Log__c();
                                    apiError.API_Name__c = 'Chemo  Object';
                                    apiError.Error_Message__c = String.valueOf(rwrap.getErrors());
                                    apiError.Trigger_Point__c = 'Procept Object';
                                    apiError.Record_Identifier__c = rwrap.Chemo_Id__c;
                                    listApiErrorLog.add(apiError); 

                            }
                        
							
							
                        }
                         
                        system.debug('=======Chemo Insert Lisr  ===='+chemoListInsert);
                        string ids ='';
                       // List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
                        if(chemoListInsert.size() > 0) {
                          
                            Database.SaveResult[] srList1 = Database.Insert(chemoListInsert,false);
                           system.debug('=======chemoListInsert=========='+chemoListInsert);
                            for(Integer i=0;i<srList1.size();i++){
                                if(!srList1[i].isSuccess()){
                                    API_Error_Log__c apiError = new API_Error_Log__c();
                                    apiError.API_Name__c = 'Chemo Appointment';
                                    apiError.Error_Message__c = String.valueOf(srList1[i].getErrors());
                                    apiError.Trigger_Point__c = 'Chemo Appointment Object';
                                    apiError.Record_Identifier__c = chemoListInsert[i].Chemo_Id__c;
                                    listApiErrorLog.add(apiError); 
                                }
                                else {
                                    ids += srList1[i].getId() + ',';
                                    idlist1.add(srList1[i].getId());
                                }
                            }
                            if(listApiErrorLog != NULL && listApiErrorLog.size() > 0)
                            {
                                insert listApiErrorLog;
                            }
                            system.debug('Error List Data ==='+listApiErrorLog);
                             for(API_Error_Log__c apiError : listApiErrorLog)
                            {
                                      erroridlist.add(apiError.id);
                           }
                            system.debug('Error List Data ==='+listApiErrorLog);
                        }
                        List<Chemo_Appointment__c> chemo = [select id,Max_Id__c,Chemo_Id__c from Chemo_Appointment__c where id IN: idlist1];
                        List<API_Error_Log__c> ErrorLogDataList = [select id,Record_Identifier__c  from API_Error_Log__c where  ID In : erroridlist];
                        // If Response is getting in Array format 
                      
                        String jsonresponse = '[';
                        
                        for(Chemo_Appointment__c ch : chemo){
                            
                            jsonresponse+=' {';
							
                            jsonresponse+='   "Chemo Number":"'+ch.Chemo_Id__c+'" ,';
                            jsonresponse+='  "Status": "success",';
                            jsonresponse+='   "Message":"Chemo record Created  Successfully ",';
                            jsonresponse+='   "Chemo ID ":"'+ch.ID+'" ,';
                            jsonresponse+='},';
                            
                        }
                          for(API_Error_Log__c error : ErrorLogDataList){
                                           
                            jsonresponse+=' {';
                            
                            jsonresponse+=' "Chemo Number": "'+error.Record_Identifier__c+'",';
                            
                            jsonresponse+='  "Status": "Failure",';
                            jsonresponse+='   "Message":"Patient Max Id Not Present in System"';
                            
                            jsonresponse+='},';
                                                        
                           }
                        jsonresponse=jsonresponse.removeEnd(',');
                        
                        jsonresponse+=']';
                        
                        //String jsonStr = '{"success" : true,"message" : "Test data ","LeadID" : "'+Ids+'"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonresponse);
                        //String jsonStr = '{"Status" : "success","message" : "Chemo Appointment Created Successfully","Lead ID" :"'+ids+'"}';
                        //RestContext.response.addHeader('Content-Type', 'application/json');
                       //RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                    }
                        
                    } // END Chemo API 
                 // Correct entity Name       
                else {
                    system.debug('Inside elde Entity Name');
                    String jsonStr = '{"success" : false,"message" : "Provide Correct Entity Name"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;     
                }
            }// End IF Entity Name 
            else {
                    String jsonStr = '{"success" : false,"message" : "Provide atleast one record"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;     
                }
            
            
            
            
            
        }//End Request Body 
            else {
                String jsonStr = '{"success" : false,"message" : "Provide Body"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
            }
    }// End Try Block
    
        catch(Exception e){
              Database.rollback(sp);
            String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';            
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
            return; 
        }
    }


}