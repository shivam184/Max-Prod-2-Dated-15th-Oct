@RestResource(urlMapping='/createeprescription/*')
global class EPrescriptionLeadCreation{
    @HttpPOST
    global static void doEPrescriptionLead() {
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class);
            Savepoint sp = Database.setSavepoint();
            
            try{
                System.debug('1requestBody.MaxID >>> ' + requestBody.MaxID);
                
                
                

              if( String.isNotBlank(requestBody.AdmissionAdvised) && requestBody.AdmissionAdvised == 'Yes'){
                   System.debug('Inseide Else if');
                    String leadId;
                    String prospectId;
                    String dcaLeadsId;
                    String callCenterIds;
                    String recordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
                    Prospect__c prospect = new Prospect__c();
                    if(String.isNotBlank(requestBody.PatientName)) {
                        prospect.Name = requestBody.PatientName;
                        prospect.Patient_Name__c = requestBody.PatientName;
                    }
                    else {
                        String jsonStr = '{"success" : false,"message" : "Provide Patient Name"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;         
                    }
                    if(String.isNotBlank(requestBody.pcl_visitid))
                        prospect.PCL_VisitId__c = requestBody.pcl_visitid;
                    else {
                        String jsonStr = '{"success" : false,"message" : "Provide PCL Visit ID"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;     
                    }
                    
                    
                    if(String.isNotBlank(recordTypeId))
                        prospect.RecordTypeId = recordTypeId;
                    if(String.isNotBlank(requestBody.ID))
                        prospect.Id__c = requestBody.ID;
                    
                    if(String.isNotBlank(requestBody.DoctorName))
                        prospect.Doctor_Name__c = requestBody.DoctorName;
                    if(String.isNotBlank(requestBody.MaxID)) {
                        prospect.Max_Id__c = requestBody.MaxID;
                        String patientId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,requestBody.PatientName,Label.Patient);
                        if(String.isNotBlank(patientId))
                            prospect.Account__c = patientId;
                        leadId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.Lead);
                        prospectId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.ProspectEstimation);
                        callCenterIds = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'','CallCenterLead'); 
                    }
                  /* New change 15-07-2021 if any IOP Lead present with related max ID and there stage is Closed Lost and Journey_Day__c < 90 
					then auto tag the prospect */
                   Map<String, International_OP_Patient_Journey__c> IOPMAP = new  Map<String, International_OP_Patient_Journey__c> ();
                   for(International_OP_Patient_Journey__c IOP : [Select id, Stage__c,Journey_Day__c,Patient_Max_id__c
                                                                 FROM International_OP_Patient_Journey__c 
                                                                 WHERE Patient_Max_id__c =:requestBody.MaxID
                                                                AND Stage__c <> 'Closed Lost' AND Journey_Day__c < 90])
                   {
                       
                       IOPMAP.put(IOP.Patient_Max_id__c,IOP);
                   }
                  if(IOPMAP.ContainsKey(prospect.Max_Id__c))
                  {
                        prospect.International_OP_Patient_Journey__c = IOPMAP.get(prospect.Max_Id__c).ID;
                      	
                      
                  }
                // END 15-07-2021 Changes 
                  
                    if(String.isNotBlank(requestBody.Birthdate))
                        prospect.Date_Of_Birth__c = Date.valueOf(requestBody.BirthDate);
                    if(String.isNotBlank(requestBody.OPBillNo))
                        prospect.OP_Bill_No__c = requestBody.OPBillNo;
                    if(String.isNotBlank(requestBody.ProcedureName))
                        prospect.Procedure_Name__c = requestBody.ProcedureName;
                    if(String.isNotBlank(requestBody.PrescriptionDate))
                        prospect.Prescription_Date__c = Date.valueOf(requestBody.PrescriptionDate);
                    if(String.isNotBlank(requestBody.SpecializationId)) {
                        prospect.Specialization_Id__c = requestBody.SpecializationId;
                        String specialItyId = RecordCheckUtilityClass.checkRecord(requestBody.SpecializationId,requestBody.Specialization,Label.Specialization);
                        if(String.isNotBlank(specialItyId))
                            prospect.Doctor_Specialization__c = specialItyId;
                    }
                    if(String.isNotBlank(requestBody.Specialization))
                        prospect.Specialization__c = requestBody.Specialization;
                    if(String.isNotBlank(requestBody.DepartmentId)) {
                        prospect.Department_Id__c = requestBody.DepartmentId;
                        String departId = RecordCheckUtilityClass.checkRecord(requestBody.DepartmentId,requestBody.DepartmentName,Label.Department);
                        if(String.isNotBlank(departId))
                            prospect.Doctor_Department__c = departId;
                    }
                    if(String.isNotBlank(requestBody.DepartmentName))
                        prospect.Department_Name__c = requestBody.DepartmentName;
                    if(String.isNotBlank(requestBody.Gender))
                        prospect.Gender__c = requestBody.Gender;
                    if(String.isNotBlank(requestBody.Mobile))
                        prospect.Mobile__c = requestBody.Mobile;
                    if(String.isNotBlank(requestBody.PayerChannel)){
                        prospect.Payer_Channel__c = requestBody.PayerChannel;
                        prospect.Channel__c = requestBody.PayerChannel;
                    }
                    if(String.isNotBlank(requestBody.DiscountReason))
                        prospect.Discount_Reason__c = requestBody.DiscountReason;
                    if(String.isNotBlank(requestBody.VisitDate))
                        prospect.Visit_Date__c = Date.valueOf(requestBody.VisitDate);
                    if(String.isNotBlank(requestBody.SSN))
                        prospect.SSN__c = requestBody.SSN;
                    if(String.isNotBlank(requestBody.LocationCode))
                        prospect.Location_Code__c = requestBody.LocationCode;
                    if(String.isNotBlank(requestBody.AdmissionAdvised))
                        prospect.Admission_Advised__c = requestBody.AdmissionAdvised;
                    
                    
                    if(String.isNotBlank(requestBody.MaxID))
                        dcaLeadsId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.DCALeads);
                    else if(String.isNotBlank(requestBody.PatientName) && String.isNotBlank(requestBody.Mobile))
                        dcaLeadsId = RecordCheckUtilityClass.checkRecord(requestBody.PatientName,requestBody.Mobile,Label.DCALeads);    
                    System.debug('===dcaLeadsId====>>>'+dcaLeadsId);
                    
                    if(String.isBlank(prospectId))
                        prospect.Stage__c = 'Admission Advised';
                    
                    if(String.isNotBlank(leadId))
                        prospect.CMP_Prospect__c = true;
                    
                    if(String.isNotBlank(dcaLeadsId))
                        prospect.DCA_Prospect__c = true;
                    
                    if(String.isNotBlank(callCenterIds))
                        prospect.Call_Center_Prospect__c = true;
                    
                    if(String.isNotBlank(requestBody.DoctorID)){
                        prospect.Doctor_Id__c = requestBody.DoctorID;
                        String doctorId = RecordCheckUtilityClass.checkRecord(requestBody.DoctorID,requestBody.DoctorName,Label.Doctor);
                        if(String.isNotBlank(doctorId)){
                            if(String.isNotBlank(prospectId)){
                                prospect.Id = prospectId;
                                prospect.Doctor_Est_Ep__c = doctorId;
                                prospect.Secondary_Doctor_Business_Unit__c = RecordCheckUtilityClass.checkRecord(requestBody.HospitalLocation,'',Label.Business_Unit);
                            }
                            else{
                                prospect.Doctor__c = doctorId;
                            }
                        }
                    }
                    
                    if(String.isNotBlank(requestBody.HospitalLocation) && String.isBlank(prospectId)){
                        prospect.Hospital_Location__c = requestBody.HospitalLocation;   
                        String businessUnitId = RecordCheckUtilityClass.checkRecord(requestBody.HospitalLocation,'',Label.Business_Unit);
                        if(String.isNotBlank(businessUnitId))
                            prospect.HIS_Hospital_Location__c = businessUnitId;
                        else {
                            String jsonStr = '{"success" : false,"message" : "Provide Valid Hospital Location"}';
                            RestContext.response.addHeader('Content-Type', 'application/json');
                            RestContext.response.responseBody = Blob.valueOf(jsonStr);
                            return;        
                        }
                    }
                    
                    
                    
                    //Logic to look for Admission Acknowledgements and change the Prospect Stage to Admitted/Discharged if found
                    list<Admission_Acknowledgement__c> ackList = new list<Admission_Acknowledgement__c>();
                    set<String> statusSet = new set<String>();
                    statusSet.addAll(label.Admission_Status_For_Prospect.split(','));
                    
                    if(String.isNotBlank(prospect.Max_Id__c)){
                        DateTime endt = system.now();
                        DateTime stDt = system.now().addDays(Integer.valueOf(label.Prospect_Previous_Hous));
                        
                        ackList = [SELECT Id,Related_Prospect__c,Max_ID__c,CreatedDate,(SELECT Id FROM Billing_Summary__r) FROM Admission_Acknowledgement__c
                                   WHERE Related_Prospect__c=null and Max_ID__c=:prospect.Max_Id__c and Admission_Status__c in:statusSet
                                   and CreatedDate>=:stDt and CreatedDate<=:endt];
                        
                        if(ackList!=null && ackList.size()>0){
                            prospect.Stage__c = label.Prospect_Admitted;
                            
                            for(Admission_Acknowledgement__c ack : ackList)
                                if(ack.Billing_Summary__r!=null && ack.Billing_Summary__r.size()>0)
                                prospect.Stage__c = label.Patient_Discharged;
                            
                        }                                                                                
                    }
                    
                    system.debug(prospectId);
                    //Updating / Upserting Prospects into Salesforce.
                  if(String.isNotBlank(prospectId)){
                        system.debug('Line 197');
                        update prospect;
                  }
                    else {
                        system.debug('Line 200');
                        prospect.Source__c = 'E Prescription';
                        upsert prospect Prospect__c.Fields.PCL_VisitId__c;    
                    }
                    
                    system.debug(ackList.size());
                    //Linking Admission Acknowledgements with Prospects
                    if(ackList!=null && ackList.size()>0){
                        for(Admission_Acknowledgement__c ack : ackList)
                            ack.Related_Prospect__c = prospect.Id;
                        
                        update ackList;
                        
                    }
                    
                    
                    
                    List<Lead__c> listLead = new List<Lead__c>();
                    
                    if(String.isNotBlank(leadId)) {
                        for(String lId : leadId.split(',')) {
                            Lead__c lead = new Lead__c();
                            lead.Id = lId;
                            lead.Prospect__c = prospect.Id;
                            lead.Stage__c = 'OPD Consult Taken';
                            listLead.add(lead);         
                        }
                    }
                    
                    if(String.isNotBlank(dcaLeadsId)) {
                        for(String lId : dcaLeadsId.split(',')) {
                            Lead__c lead = new Lead__c();
                            lead.Id = lId;
                            lead.Prospect__c = prospect.Id;
                            lead.Stage__c = 'OPD Consult Taken';
                            listLead.add(lead);         
                        }    
                    }
                    
                    if(String.isNotBlank(callCenterIds)) {
                        for(String lId : callCenterIds.split(',')) {
                            Lead__c lead = new Lead__c();
                            lead.Id = lId;
                            lead.Prospect__c = prospect.Id;
                            listLead.add(lead);         
                        }    
                    }
                    
                    
                    if(listLead != NULL && listLead.size() > 0)
                        update listLead;
                  
                 // Update internation Patient Journey Fields  
                 //  IsInternational = true 
                 //  PrescriptionAdvice = true 
                 //  MaxID <> Null
                 //  AdmissionAdvised  = 'Yes'
                 if(boolean.valueOf(requestBody.IsInternational) == true && boolean.valueOf(requestBody.PrescriptionAdvice) == true && requestBody.MaxID !=null)
                  {
                      System.debug('requestBody.MaxID >>> ' + requestBody.MaxID);
                      International_OP_Patient_Journey__c pmxId = [Select id, Advice_Consult__c, Advice_Pharmacy__c, Advice_Radiology__c, Advice_Pathology__c 
                                                                   from International_OP_Patient_Journey__c WHERE Patient_Max_id__c =:requestBody.MaxID];
                      if(requestBody.Consult!=null)
                          pmxId.Advice_Consult__c = boolean.valueOf(requestBody.Consult);
                      if(requestBody.Pharmacy!=null)
                          pmxId.Advice_Pharmacy__c = boolean.valueOf(requestBody.Pharmacy);
                      if(requestBody.Radiology!=null)
                          pmxId.Advice_Radiology__c = boolean.valueOf(requestBody.Radiology);
                      if(requestBody.Pathology!=null)
                          pmxId.Advice_Pathology__c = boolean.valueOf(requestBody.Pathology);
                      //}
                      update pmxId;
                    //String jsonStr = '{"id":"'+pmxId.Id+'","success" : true,"message" : "E-Prescription created successfully"}';
                    //RestContext.response.addHeader('Content-Type', 'application/json');
                    //RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    //return;
                  }
                    String jsonStr = '{"id":"'+prospect.Id+'","success" : true,"message" : "E-Prescription created successfully"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;    
                }
                Else if(boolean.valueOf(requestBody.IsInternational) == true && boolean.valueOf(requestBody.PrescriptionAdvice) == true && requestBody.MaxID !=null)
                {
                      System.debug('requestBody.MaxID >>> ' + requestBody.MaxID);
                      International_OP_Patient_Journey__c pmxId = [Select id, Advice_Consult__c, Advice_Pharmacy__c, Advice_Radiology__c, Advice_Pathology__c 
                                                                   from International_OP_Patient_Journey__c WHERE Patient_Max_id__c =:requestBody.MaxID];
                      if(requestBody.Consult!=null)
                          pmxId.Advice_Consult__c = boolean.valueOf(requestBody.Consult);
                      if(requestBody.Pharmacy!=null)
                          pmxId.Advice_Pharmacy__c = boolean.valueOf(requestBody.Pharmacy);
                      if(requestBody.Radiology!=null)
                          pmxId.Advice_Radiology__c = boolean.valueOf(requestBody.Radiology);
                      if(requestBody.Pathology!=null)
                          pmxId.Advice_Pathology__c = boolean.valueOf(requestBody.Pathology);
                      //}
                      update pmxId;
                    String jsonStr = '{"id":"'+pmxId.Id+'","success" : true,"message" : "E-Prescription created successfully"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;
                  }
              
		 // New changes to Update Oncology Prospect Object 02-07-2021  (discuss with atul sir also these data come from New e-pre API) this code moved to OncologyPatientApiController class
            /*    Else if(requestBody.MaxID !=null){
					 System.debug('Inside If max Id');       
                    String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
                    System.debug('Max Id' +requestBody.MaxID);
                     List<Prospect__c> UpdateprospectList = new List<Prospect__c> ();
                     List<Id> Idlist = new List<Id>();
                     List<Prospect__c> prospectList = [Select id, Prescription_Date__c, Admission_Date__c, Discount_Reason__c, Procedure_Name__c ,Visit_Date__c,
												Payer_Channel__c,Max_Id__c
                                                       from Prospect__c WHERE Max_Id__c =:requestBody.MaxID and RecordTypeID =:oncorecordTypeId ];
                    system.debug('prospect.OncoNumber__c' +prospectList);
                    for(Prospect__c p : prospectList){
                        
                    if(String.isNotBlank(requestBody.ID))
                       Idlist.add(p.ID);
                        if(String.isNotBlank(requestBody.PrescriptionDate))
                        p.Prescription_Date__c = Date.valueOf(requestBody.PrescriptionDate);
                      system.debug('prospect.OncoNumber__c' +p.Prescription_Date__c);
                        //if(requestBody.Admission_Date__c!=null)
                        //pmxId.Admission_Date__c = requestBody.;
                        if(String.isNotBlank(requestBody.DiscountReason))
                        p.Discount_Reason__c = requestBody.DiscountReason;
                        if(String.isNotBlank(requestBody.ProcedureName))
                        p.Procedure_Name__c = requestBody.ProcedureName;
						if(String.isNotBlank(requestBody.VisitDate))
                        p.Visit_Date__c = Date.valueOf(requestBody.VisitDate);
						if(String.isNotBlank(requestBody.PayerChannel)){
                        p.Payer_Channel__c = requestBody.PayerChannel;
                           p.Company_Type__c = requestBody.PayerChannel;
                             }
                            System.debug('###'+p);
                    	UpdateprospectList.add(p);
                            
                       
                    }
                    if(UpdateprospectList?.size()>0)
                    {
                        update UpdateprospectList;
                    }
                      for (Prospect__c pro : UpdateprospectList){
                      
                     String jsonStr = '{"id":"'+pro.Id+'","success" : true,"message" : "E-Prescription created successfully"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;
                      }
                }// End Changes 02-07-2021
				*/
                else {
                    String jsonStr = '{"success" : false,"message" : "Prospect not created as admission not advised."}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;    
                }
                
                
            }
            catch(Exception e) {
                Database.rollback(sp);
                String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
                system.debug(jsonStr);
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
    
    public class RequestBody{
        public String ID;
        public String pcl_visitid;
        public String DoctorId;
        public String DoctorName;
        public String PatientName;
        public String MaxID;
        public String Birthdate;
        public String OPBillNo;
        public String ProcedureName;
        public String PrescriptionDate;
        public String SpecializationId;
        public String Specialization;
        public String DepartmentId;
        public String DepartmentName;
        public String Gender;
        public String HospitalLocation;
        public String Mobile;
        public String PayerChannel;
        public String DiscountReason;
        public String VisitDate;
        public String SSN;
        public String LocationCode;
        public String AdmissionAdvised;
        public String PrescriptionAdvice;
        public String Consult;
        public String Radiology;
        public String Pathology;
        public String Pharmacy;
        public String IsInternational;
    }
}