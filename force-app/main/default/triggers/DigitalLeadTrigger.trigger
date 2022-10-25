trigger DigitalLeadTrigger on Case (before insert, before update, After Insert, After Update) {
    TriggerExecutions__c trex = TriggerExecutions__c.getOrgDefaults();
    
    if(trex.Digital_Lead__c){
        if(Trigger.isbefore && Trigger.isInsert){
            List<Lead__c> lead=new List<Lead__c>();
            
            for( Case cs:Trigger.new){
                //  system.debug('--->>>'+cs.Lead_Create__c);
                if(cs.Lead_Create__c==True){
                    Lead__c ld=new Lead__c();
                    ld.RecordTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
                    if(cs.Name__c!=NULL)
                        ld.Name=cs.Name__c;
                    if(cs.Max_ID__c !=NULL)
                        ld.Max_ID__c=cs.Max_ID__c;
                    if(cs.Lead_Source__c!=NULL)
                        ld.Lead_Source__c=cs.Lead_Source__c;
                    if(cs.Sub_Source__c !=NULL)
                        ld.Sub_Source__c=cs.Sub_Source__c;
                    if(cs.Address_Line_1__c !=NULL)
                        ld.Address_Line_1__c=cs.Address_Line_1__c;
                    if(cs.Appointment_Date__c !=NULL)
                        ld.Appointment_Date__c=cs.Appointment_Date__c;
                    if(cs.Campaign__c !=NULL)
                        ld.Campaign__c=cs.Campaign__c;
                    if(cs.Country_Region__c!=NULL)
                        ld.Country_Region__c=cs.Country_Region__c;
                    if(cs.DCA_Subtype__c!=NULL)
                        ld.DCA_Subtype__c=cs.DCA_Subtype__c;
                    if(cs.Doctor_Name__c!=NULL)
                        ld.Doctor_Name__c=cs.Doctor_Name__c;
                    if(cs.Email__c!=NULL)
                        ld.Email__c=cs.Email__c;
                    if(cs.EnquiryID__c!=NULL)
                        ld.EnquiryID__c=cs.EnquiryID__c;
                    if(cs.File_Link__c!=NULL)
                        ld.File_Link__c=cs.File_Link__c;
                    if(cs.File_Name__c!=NULL)
                        ld.File_Name__c=cs.File_Name__c;
                    if(cs.Form_Name__c!=NULL)
                        ld.Form_Name__c=cs.Form_Name__c;
                    if(cs.HIS_Unique_Lead_ID__c!=NULL)
                        ld.HIS_Unique_Lead_ID__c=cs.HIS_Unique_Lead_ID__c;
                    if(cs.IP_Address__c!=NULL)
                        ld.IP_Address__c=cs.IP_Address__c;
                    if(cs.Keyw__c !=NULL)
                        ld.Keyw__c=cs.Keyw__c;
                    if(cs.Lead_Channel__c!=NULL)
                        ld.Lead_Channel__c=cs.Lead_Channel__c;
                    if(cs.Type!=NULL)
                        ld.Lead_Type__c=cs.Type;
                    if(cs.Mobile_Phone__c !=NULL)
                        ld.Mobile_Phone__c=cs.Mobile_Phone__c;
                    if(cs.OwnerId !=NULL)
                        ld.OwnerId=cs.OwnerId;
                    if(cs.Passport_No__c!=NULL)
                        ld.Passport_No__c=cs.Passport_No__c;
                    if(cs.Patient_Name__c!=NULL)
                        ld.Patient_Name__c=cs.Patient_Name__c;
                    if(cs.Placement__c!=NULL)
                        ld.Placement__c=cs.Placement__c;
                    if(cs.Speciality__c!=NULL)
                        ld.Speciality_Text__c=cs.Speciality__c;
                    if(cs.Status!=NULL)
                        ld.Stage__c=cs.Status;
                    if(cs.Submitted_On__c!=NULL)
                        ld.Submitted_On__c=cs.Submitted_On__c;
                    ld.Lead_Create__c=cs.Lead_Create__c;
                    system.debug('---->'+cs.ID);
                    ld.CaseId__c=cs.OwnerId;
                    cs.Lead__r=ld;
                    lead.add(ld);
                }
                //added by Nitya on 9th june 2022
                if(String.isNotBlank(cs.status)){
                    if(cs.status=='New'){
                        cs.New_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Contacted Patient'){
                        cs.Contacted_Patient_Stage_Date_Time__c=system.now();
                    }
                    
                    else if(cs.status == 'Reports Shared with Unit'){
                        cs.Report_shared_by_Unit__c = 1;
                        cs.Report_Shared_with_Unit_Stage_Date_Time__c=system.now();
                    }
                    // Added by Navin Soni on 25-08-2021 for Convert "Digital Case Praposal Shared" Process Builder into code.
                    else if(cs.status == 'Proposal Shared'){
                        cs.Proposal_Shared__c = 1;
                        cs.Proposal_Shared_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Appointment Booked'){
                        cs.Appointment_Booked_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='OPD Consult Taken'){
                        cs.OPD_Consult_Taken_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Closed Lost'){
                        cs.Closed_Lost_Stage_Date_Time__c=system.now();
                    }
                }
            }
            if(lead.size()>0){
                Insert lead;
            }
            for( Case cs:Trigger.new){
                if(cs.Lead_Create__c==True){
                    cs.Lead__c = cs.Lead__r.id;
                }
            }
        }
        //updated by Nitya on 9th june 2022 to record the time when the stage has changed
        if(Trigger.isBefore && Trigger.isUpdate){
            for( Case cs : Trigger.new){
                if(String.isNotBlank(cs.status) && trigger.oldmap.get(cs.id).status!=cs.status){
                    if(cs.status=='New'){
                        cs.New_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Contacted Patient'){
                        cs.Contacted_Patient_Stage_Date_Time__c=system.now();
                    }
                    
                    else if(cs.status == 'Reports Shared with Unit'){
                        cs.Report_shared_by_Unit__c = 1;
                        cs.Report_Shared_with_Unit_Stage_Date_Time__c=system.now();
                    }
                    // Added by Navin Soni on 25-08-2021 for Convert "Digital Case Praposal Shared" Process Builder into code.
                    else if(cs.status == 'Proposal Shared'){
                        cs.Proposal_Shared__c = 1;
                        cs.Proposal_Shared_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Appointment Booked'){
                        cs.Appointment_Booked_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='OPD Consult Taken'){
                        cs.OPD_Consult_Taken_Stage_Date_Time__c=system.now();
                    }
                    else if(cs.status=='Closed Lost'){
                        cs.Closed_Lost_Stage_Date_Time__c=system.now();
                    }
                }
            }
        }
        
        // Added by Navin Soni on 24-08-2021 for Convert "Lead Stage Updation Through Digital Lead" Process Builder into code.
        if(Trigger.isAfter){
            List<Lead__c> listOfLeadUpdate = new List<Lead__c>();
            if(Trigger.isInsert){
                for(Case objCase : Trigger.New){
                    if(objCase.Lead__c != null){
                        if(String.isNotBlank(objCase.Status) || String.isNotBlank(objCase.Passport_No__c) || String.isNotBlank(objCase.Max_Id__c) || String.isNotBlank(objCase.Lead_Source__c) ||
                           String.isNotBlank(objCase.Sub_Source__c) || objCase.Submitted_On__c != null || String.isNotBlank(objCase.OwnerId)){
                               Lead__c objLead = new Lead__c(); 
                               objLead.Id = objCase.Lead__c;
                               objLead.Hospital_Location__c = objCase.Hospital_Location__c;
                               objLead.Lead_Source__c = objCase.Lead_Source__c;
                               objLead.Max_ID__c = objCase.Max_ID__c;
                               objLead.OwnerId = objCase.OwnerId;
                               objLead.Passport_No__c = objCase.Passport_No__c;
                               objLead.Stage__c = objCase.Stage__c;
                               // system.debug('objLead.Stage__c'+objLead.Stage__c);
                               // system.debug('objCase.Status'+objCase.Status);
                               
                               objLead.Sub_Source__c = objCase.Sub_Source__c;
                               objLead.Submitted_On__c = objCase.Submitted_On__c;
                               listOfLeadUpdate.add(objLead);
                           }
                    }
                }
                if(listOfLeadUpdate != null && listOfLeadUpdate.size() > 0){
                    Update listOfLeadUpdate;
                }
            }
            
            if(Trigger.isUpdate && DigitalLeadTriggerHelper.isFirstTime){
                DigitalLeadTriggerHelper.isFirstTime = false;
                for(Case objCase : Trigger.New){
                    if(objCase.Lead__c != null){
                        if(objCase.Status != Trigger.OldMap.get(objCase.Id).Status || objCase.Passport_No__c != Trigger.OldMap.get(objCase.Id).Passport_No__c || objCase.Max_Id__c != Trigger.OldMap.get(objCase.Id).Max_Id__c || objCase.Lead_Source__c != Trigger.OldMap.get(objCase.Id).Lead_Source__c ||
                           objCase.Sub_Source__c != Trigger.OldMap.get(objCase.Id).Sub_Source__c || objCase.Submitted_On__c != Trigger.OldMap.get(objCase.Id).Submitted_On__c || objCase.OwnerId != Trigger.OldMap.get(objCase.Id).OwnerId){
                               Lead__c objLead = new Lead__c(); 
                               objLead.Id = objCase.Lead__c;
                               objLead.Hospital_Location__c = objCase.Hospital_Location__c;
                               objLead.Lead_Source__c = objCase.Lead_Source__c;
                               objLead.Max_ID__c = objCase.Max_ID__c;
                               objLead.OwnerId = objCase.OwnerId;
                               objLead.Passport_No__c = objCase.Passport_No__c;
                               objLead.Stage__c = objCase.Stage__c;
                               objLead.Sub_Source__c = objCase.Sub_Source__c;
                               objLead.Submitted_On__c = objCase.Submitted_On__c;
                               listOfLeadUpdate.add(objLead);
                           }
                    }
                }
                if(listOfLeadUpdate != null && listOfLeadUpdate.size() > 0){
                    Update listOfLeadUpdate;
                }
            }
        }
    }
}