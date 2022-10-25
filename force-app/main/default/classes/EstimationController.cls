@RestResource(urlMapping='/createestimation/*')
global  class EstimationController {
    
    @HttpPOST
    global static void doCreateOPIPLead() {
        RestRequest req = RestContext.request;
        if(String.isNotBlank(req.requestBody.toString())) {
            RequestBody requestBody = (RequestBody)JSON.deserialize(req.requestBody.toString(),RequestBody.class); 
            Savepoint sp = Database.setSavepoint();
            try {
                List<string> maxIdSet = new List<String>();
                List<oncology_patient_journey__c> UpdateOncoList = new List<oncology_patient_journey__c>();
                String leadId;
                String prospectId;
                String dcaLeadsId;
                String callCenterIds;
                String recordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
                
                
                Boolean NotInternationl = true;        //added by uzait tmc on 4th june2020
                
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
                
                if(String.isNotBlank(requestBody.MaxID)) {
                    //Abhishek Mishra
                    maxIdSet.add(requestBody.MaxID);
                    
                    //added bu uzair tmc 4june 2020
                    String internationalrecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
                    List<Prospect__c> listInternationalProspect = [SELECT Id FROM Prospect__c WHERE RecordTypeId=:internationalrecordTypeId 
                                                                   AND Max_Id__c = :requestBody.MaxID
                                                                   ]; 
                    if(listInternationalProspect != NULL && listInternationalProspect.size() > 0)
                        NotInternationl = false;
                    
                    //---------------------------------------End-------------------------------------------------
                    
                    prospect.Max_Id__c = requestBody.MaxID;
                    String patientId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,requestBody.PatientName,Label.Patient);
                    if(String.isNotBlank(patientId))
                        prospect.Account__c = patientId;
                    if(NotInternationl){                                        //added in 4th JUne 2020
                        leadId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.Lead);
                        prospectId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.Prospect);
                        dcaLeadsId = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'',Label.DCALeads);
                        callCenterIds = RecordCheckUtilityClass.checkRecord(requestBody.MaxID,'','CallCenterLead');
                    }else
                        prospectId = listInternationalProspect[0].id;             //added in 4th JUne 2020
                }
                else {
                    if(String.isNotBlank(requestBody.IsPatientReg) && requestBody.IsPatientReg == 'No') 
                    {
                        Contact con = new Contact();
                        Id recordTypeId2 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
                        if(String.isNotBlank(recordTypeId2)) 
                            con.RecordTypeId = recordTypeId2;
                        con.LastName = requestBody.PatientName;
                        insert con;
                        
                        Lead__c lead = new Lead__c();
                        Id recordTypeId1 = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
                        if(String.isNotBlank(recordTypeId1))
                            lead.RecordTypeId = recordTypeId1;
                        lead.Name = requestBody.PatientName;
                        if(String.isNotBlank(requestBody.AdmissionDate))
                            lead.Expected_Date_Of_Admissions__c = Date.valueOf(requestBody.AdmissionDate);
                        if(String.isNotBlank(requestBody.EstimationDate))
                            lead.Estimation_Date__c = Date.valueOf(requestBody.EstimationDate);
                        if(String.isNotBlank(requestBody.DoctorName))
                            lead.Doctor_Name__c = requestBody.DoctorName;
                        if(String.isNotBlank(requestBody.DoctorID)) 
                            lead.DoctorId__c = requestBody.DoctorID;
                        if(String.isNotBlank(requestBody.EstimatedGivenBy))
                            lead.Estimated_Given_By__c= requestBody.EstimatedGivenBy;
                        if(String.isNotBlank(requestBody.EstimatedGivenById))
                            lead.Estimated_Given_By_ID__c = requestBody.EstimatedGivenById;
                        if(String.isNotBlank(requestBody.EstimatedGivenByDepartment))
                            lead.Estimated_Given_By_Department__c = requestBody.EstimatedGivenByDepartment;
                        if(String.isNotBlank(requestBody.EstimationNo))
                            lead.Estimation_No__c = requestBody.EstimationNo;  
                        if(String.isNotBlank(requestBody.CurrentBedType))
                            lead.Current_Bed_Type__c = requestBody.CurrentBedType; 
                        if(String.isNotBlank(requestBody.CompanyType))
                            lead.Company_Type__c = requestBody.CompanyType;
                        if(String.isNotBlank(requestBody.LocationName))
                            lead.Location_Name__c = requestBody.LocationName;  
                        if(String.isNotBlank(requestBody.LocationCode))
                            lead.Location_Code__c = requestBody.LocationCode; 
                        if(String.isNotBlank(requestBody.DiscountPer))
                            lead.Discount_per__c = Decimal.valueOf(requestBody.DiscountPer);
                        if(String.isNotBlank(requestBody.DiscRemarks))
                            lead.Discount_Remarks__c = requestBody.DiscRemarks;
                        if(String.isNotBlank(requestBody.DiscPerAmt))
                            lead.Discount_Amount__c = Decimal.valueOf(requestBody.DiscPerAmt);
                        if(String.isNotBlank(requestBody.DiscReason))
                            lead.Discount_Reason__c = requestBody.DiscReason; 
                        if(String.isNotBlank(requestBody.AnnexureDescription))
                            lead.Annexure_Description__c = requestBody.AnnexureDescription;  
                        
                        lead.Parent_Contact_for_lead__c = con.Id;    
                        insert lead;    
                        
                        String jsonStr = '{"success" : true,"message" : "Lead and Contact inserted successfully"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;                                                                               
                        
                    }
                    else {
                        String jsonStr = '{"success" : false,"message" : "Max Id is blank and Patient Registration is other than No"}';
                        RestContext.response.addHeader('Content-Type', 'application/json');
                        RestContext.response.responseBody = Blob.valueOf(jsonStr);
                        return;
                    }
                }
                
                if(String.isNotBlank(requestBody.EstimationID))
                    prospect.Estimation_ID__c = requestBody.EstimationID;
                else {
                    String jsonStr = '{"success" : false,"message" : "Provide Estimation ID"}';
                    RestContext.response.addHeader('Content-Type', 'application/json');
                    RestContext.response.responseBody = Blob.valueOf(jsonStr);
                    return;     
                }
                
                if(String.isNotBlank(recordTypeId) && NotInternationl==true)   //added in 4th JUne 2020 only  checked for Internationl Prospect     
                    prospect.RecordTypeId = recordTypeId;
                if(String.isNotBlank(requestBody.Birthdate))
                    prospect.Date_Of_Birth__c = Date.valueOf(requestBody.BirthDate);
                if(String.isNotBlank(requestBody.AdmissionDate))
                    prospect.Admission_Date__c = Date.valueOf(requestBody.AdmissionDate);
                if(String.isNotBlank(requestBody.LengthOfStay))
                    prospect.Length_Of_Stay__c = Decimal.valueOf(requestBody.LengthOfStay);
                if(String.isNotBlank(requestBody.EstimationDate))
                    prospect.Estimation_Date__c = Date.valueOf(requestBody.EstimationDate);
                if(String.isNotBlank(requestBody.EstimationDate))
                    prospect.Estimation_Date__c = Date.valueOf(requestBody.EstimationDate);
                
                if(String.isNotBlank(requestBody.DoctorName))
                    prospect.Doctor_Name__c = requestBody.DoctorName;
                if(String.isNotBlank(requestBody.EstimatedGivenBy))
                    prospect.Estimated_Given_By__c = requestBody.EstimatedGivenBy;
                if(String.isNotBlank(requestBody.EstimatedGivenById))
                    prospect.Estimated_Given_By_Id__c = requestBody.EstimatedGivenById;
                if(String.isNotBlank(requestBody.EstimatedGivenByDepartment))
                    prospect.Estimated_Given_By_Department__c = requestBody.EstimatedGivenByDepartment;
                if(String.isNotBlank(requestBody.EstimationNo))
                    prospect.Estimation_No__c = requestBody.EstimationNo;
                if(String.isNotBlank(requestBody.CurrentBedType))
                    prospect.Current_Bed_Type__c = requestBody.CurrentBedType;
                if(String.isNotBlank(requestBody.CompanyType)){
                    prospect.Company_Type__c = requestBody.CompanyType;
                    prospect.Channel__c = requestBody.CompanyType;
                }
                //Added to manage Payer Channel blank cases
                if(String.isNotBlank(requestBody.PayerChannel)){
                    prospect.Company_Type__c = requestBody.PayerChannel;
                    prospect.Channel__c = requestBody.PayerChannel;
                }
                
                
                if(String.isNotBlank(requestBody.IsPatientReg)) {
                    if(requestBody.IsPatientReg == 'Yes')
                        prospect.Is_Patient_Reg__c = true;
                    else
                        prospect.Is_Patient_Reg__c = false;
                }
                if(String.isNotBlank(requestBody.DepositAmount))
                    prospect.Deposit_Amt__c = Decimal.valueOf(requestBody.DepositAmount);
                if(String.isNotBlank(requestBody.CurrentBill))
                    prospect.Current_Bill__c = Decimal.valueOf(requestBody.CurrentBill);
                if(String.isNotBlank(requestBody.LocationCode))
                    prospect.Location_Code__c = requestBody.LocationCode;
                if(String.isNotBlank(requestBody.DiscountPer))
                    prospect.Discount_Percent__c = Decimal.valueOf(requestBody.DiscountPer);
                if(String.isNotBlank(requestBody.DiscRemarks))
                    prospect.Disc_Remarks__c = requestBody.DiscRemarks;
                if(String.isNotBlank(requestBody.DiscPerAmt))
                    prospect.Discount_Percent_Amount__c = Decimal.valueOf(requestBody.DiscPerAmt);
                if(String.isNotBlank(requestBody.DiscReason))
                    prospect.Discount_Reason__c = requestBody.DiscReason;
                if(String.isNotBlank(requestBody.AnnexureDescription))
                    prospect.Annexure_Description__c = requestBody.AnnexureDescription;
                
                
                if(NotInternationl){                        //added in 4th JUne 2020 only  checked for Internationl Prospect   
                    
                    if(String.isBlank(prospectId))
                        prospect.Stage__c = 'Admission Advised';
                    
                    if(String.isNotBlank(leadId))
                        prospect.CMP_Prospect__c = true;
                    
                    if(String.isNotBlank(dcaLeadsId))
                        prospect.DCA_Prospect__c = true;
                    
                    if(String.isNotBlank(callCenterIds))
                        prospect.Call_Center_Prospect__c = true;
                }else
                    prospect.Stage__c = 'Estimate Taken';        //added in 4th JUne 2020
                
                if(String.isNotBlank(requestBody.DoctorID)) {
                    prospect.Doctor_Id__c = requestBody.DoctorID;
                    String doctorId = RecordCheckUtilityClass.checkRecord(requestBody.DoctorID,requestBody.DoctorName,Label.Doctor);
                    if(String.isNotBlank(doctorId)){
                        if(String.isNotBlank(prospectId)) {
                            prospect.Id = prospectId;
                            prospect.Doctor_Est_Ep__c = doctorId;
                            prospect.Secondary_Doctor_Business_Unit__c = RecordCheckUtilityClass.checkRecord(requestBody.LocationName,'',Label.Business_Unit);
                        }
                        else{
                            prospect.Doctor__c = doctorId;
                        }
                    }
                } 
                
                //Look for Business Unit in Salesforce
                if(String.isNotBlank(requestBody.LocationName) && String.isBlank(prospectId)){
                    prospect.Location_Name__c = requestBody.LocationName;   
                    String businessUnitId = RecordCheckUtilityClass.checkRecord(requestBody.LocationName,'',Label.Business_Unit);
                    if(String.isNotBlank(businessUnitId))
                        prospect.HIS_Hospital_Location__c = businessUnitId;
                    else {
                        String jsonStr = '{"success" : false,"message" : "Provide Valid Location Name"}';
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
                    system.debug('line248=='+ackList.size());
                    if(ackList!=null && ackList.size()>0 && NotInternationl){                    //added in 4th JUne 2020 only  checked for Internationl Prospect  
                        prospect.Stage__c = label.Prospect_Admitted;
                        
                        for(Admission_Acknowledgement__c ack : ackList)
                            if(ack.Billing_Summary__r!=null && ack.Billing_Summary__r.size()>0)
                            prospect.Stage__c = label.Patient_Discharged;
                        
                    }else if(ackList!=null && ackList.size()>0 && NotInternationl==false)           //added in 4th JUne 2020 only  checked for Internationl Prospect 
                        prospect.Stage__c = 'Closed Won';
                    system.debug('prospect.Stage__c=='+prospect.Stage__c);
                }
                system.debug('prospect.Stage__c=='+prospect);
                //Update/Upsert Prospects
                if(String.isNotBlank(prospectId))
                    update prospect;
                else {
                    prospect.Source__c = 'Estimation';
                    upsert prospect Prospect__c.Fields.Estimation_ID__c;    
                }
                
                //Linking Admission Acknowledgements with Prospects
                if(ackList!=null && ackList.size()>0){
                    for(Admission_Acknowledgement__c ack : ackList)
                        ack.Related_Prospect__c = prospect.Id;
                    
                    update ackList;
                }
                
                
                List<Lead__c> listLead = new List<Lead__c>();
                
                //Look for Customer Program Leads
                if(String.isNotBlank(leadId)) {
                    for(String lId : leadId.split(',')) {
                        Lead__c lead = new Lead__c();
                        lead.Id = lId;
                        lead.Prospect__c = prospect.Id;
                        lead.Stage__c = 'OPD Consult Taken';
                        listLead.add(lead);         
                    }
                }
                
                //Look for Digital Leads
                if(String.isNotBlank(dcaLeadsId)) {
                    for(String lId : dcaLeadsId.split(',')) {
                        Lead__c lead = new Lead__c();
                        lead.Id = lId;
                        lead.Prospect__c = prospect.Id;
                        lead.Stage__c = 'OPD Consult Taken';
                        listLead.add(lead);         
                    }    
                }
                
                //Look for Call Center Leads
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
                
                
                //Upsert Estimation Line Items
                List<Estimation_Line_Items__c> listLineItems = new List<Estimation_Line_Items__c>();
                if(requestBody.LineItems != NULL && requestBody.LineItems.size() > 0) {
                    for(Integer i=0;i<requestBody.LineItems.size();i++) {
                        Estimation_Line_Items__c lineItem = new Estimation_Line_Items__c();
                        lineItem.Prospect__c = prospect.Id;
                        if(String.isNotBlank(requestBody.LineItems[i].ServiceName))
                            lineItem.Service_Name__c = requestBody.LineItems[i].ServiceName;
                        if(String.isNotBlank(requestBody.LineItems[i].SingleBed))
                            lineItem.Single_Bed__c = Decimal.valueOf(requestBody.LineItems[i].SingleBed);
                        if(String.isNotBlank(requestBody.LineItems[i].DoubleBed))
                            lineItem.Double_Bed__c = Decimal.valueOf(requestBody.LineItems[i].DoubleBed);
                        if(String.isNotBlank(requestBody.LineItems[i].FourBed))
                            lineItem.Four_Bed__c = Decimal.valueOf(requestBody.LineItems[i].FourBed);
                        if(String.isNotBlank(requestBody.LineItems[i].EconomyBed))
                            lineItem.Economy_Bed__c = Decimal.valueOf(requestBody.LineItems[i].EconomyBed);
                        if(String.isNotBlank(requestBody.LineItems[i].ClassicDeluxBed))
                            lineItem.Classic_Delux_Bed__c = Decimal.valueOf(requestBody.LineItems[i].ClassicDeluxBed);
                        if(String.isNotBlank(requestBody.LineItems[i].SuiteBed))
                            lineItem.Suite_Bed__c = Decimal.valueOf(requestBody.LineItems[i].SuiteBed);
                        if(String.isNotBlank(requestBody.LineItems[i].VIPSuiteBed))
                            lineItem.VIP_Suite_Bed__c = Decimal.valueOf(requestBody.LineItems[i].VIPSuiteBed);
                        if(String.isNotBlank(requestBody.LineItems[i].DayCareBed))
                            lineItem.Day_Care_Bed__c = Decimal.valueOf(requestBody.LineItems[i].DayCareBed);
                        if(String.isNotBlank(requestBody.LineItems[i].Itemcount))
                            lineItem.Item_Count__c = Decimal.valueOf(requestBody.LineItems[i].Itemcount);
                        listLineItems.add(lineItem);
                    }
                }
                
                if(listLineItems != NULL && listLineItems.size() > 0)
                {
                   insert listLineItems;  
                }
                  // Update Oncology  Record // 12-07-2021
                     Map<String, prospect__c> prospectmap = new Map<String, prospect__c>();
                System.debug('MAX ID' + maxIdSet);
                List<oncology_patient_journey__c> oncoList =  [Select Id , Current_bill__c,Deposit_Amt__c,Estimate_No__c,Estimated_Given_By__c,
                                                   Estimation_Date__c, Length_of_Stay__c,Name,(Select Id, Treatment_Completed__c,Onco_Lead__c  from Prospects__r)
                                                   from oncology_patient_journey__c where Stage__c <> 'Lead Close' and Patient_Max_id__c In : maxIdSet];
                system.debug('Oncology List ' + oncoList);
                
                
                for(oncology_patient_journey__c ack : oncoList){
                                if(ack.Prospects__r!=null && ack.Prospects__r.size()>0 )
                                //prospect.Stage__c = label.Patient_Discharged;
                                prospectmap.put(ack.Id,ack.Prospects__r);
                            
                        }  
                 system.debug('Prospect Map Data =====>'+prospectmap);
                
                for(oncology_patient_journey__c onco : oncoList)
                {
                    // Update Oncology Estimation Fields Values  If oncology prospects Treatment_Completed__c is false 
                 // if(!prospectmap.get(onco.ID).Treatment_Completed__c) {
                   
                    if(String.isNotBlank(requestBody.CurrentBill))
                        onco.Current_Bill__c = Decimal.valueOf(requestBody.CurrentBill);
                    if(String.isNotBlank(requestBody.EstimationNo))
                        onco.Estimate_No__c = requestBody.EstimationNo; 
                    if(String.isNotBlank(requestBody.DepositAmount))
                        onco.Deposit_Amt__c = Decimal.valueOf(requestBody.DepositAmount);
                    if(String.isNotBlank(requestBody.EstimationDate))
                        onco.Estimation_Date__c = Date.valueOf(requestBody.EstimationDate);
                    if(String.isNotBlank(requestBody.EstimatedGivenBy))
                        onco.Estimated_Given_By__c= requestBody.EstimatedGivenBy;
                    if(String.isNotBlank(requestBody.LengthOfStay))
                        onco.Length_of_Stay__c = Decimal.valueOf(requestBody.LengthOfStay);
                    UpdateOncoList.add(onco);
                }
               // }
                system.debug('Before  Oncology list Data' + UpdateOncoList);
                if(UpdateOncoList?.size()>0)
                {
                    Update UpdateOncoList;
                }
                 system.debug('After Update Oncology lIst Data' + UpdateOncoList);
                // End 12/07/2021
                String jsonStr = '{"id":"'+prospect.Id+'","success" : true,"message" : "Estimation created successfully"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(jsonStr);
                return;
                
            }
            catch(Exception e) {
                Database.rollback(sp);
                String jsonStr = '{"success" : false,"message" : "'+e.getMessage()+'"}';
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
    
    public class RequestBody {
        public String EstimationID;
        public String MaxID;
        public String PatientName;
        public String Birthdate;
        public String AdmissionDate;
        public String LengthOfStay;
        public String EstimationDate;
        public String DoctorName;
        public String DoctorID;
        public String EstimatedGivenBy;
        public String EstimatedGivenById;
        public String EstimatedGivenByDepartment;
        public String EstimationNo;
        public String CurrentBedType;
        public String CompanyType;
        public String PayerChannel;
        public String IsPatientReg;
        public String DepositAmount;
        public String CurrentBill;
        public String LocationName;
        public String LocationCode;
        public String DiscountPer;
        public String DiscRemarks;
        public String DiscPerAmt;
        public String DiscReason;
        public String AnnexureDescription;
        public List<LineItemClass> LineItems;
        
        public RequestBody() {
            LineItems = new List<LineItemClass>();      
        }
    }
    
    public class LineItemClass {
        public String ServiceName;
        public String SingleBed;
        public String DoubleBed;
        public String FourBed;
        public String EconomyBed;
        public String ClassicDeluxBed;
        public String SuiteBed;
        public String VIPSuiteBed;
        public String DayCareBed;
        public String Itemcount;
    }
}