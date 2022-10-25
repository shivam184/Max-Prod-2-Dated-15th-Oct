/*lastModifiedBy: Nitya(IRT) on 25th march 2022
* lastmodifiedBy: Nitya IRT from 25th May 2022- 2nd june 2022- replaced process builders and workflows  to triggers
*
*/
public class LeadTriggerHelper{
    //only on insertion in before context
    //added on 25th May 2022
    public static void updateWebSourceAndManagerEmailId(List<lead__c> triggerNew){
        Map<id, id> leadWithOwnerMap = new map<id, id>();
        for (lead__c l : triggerNew){
            leadWithOwnerMap.put(l.id, l.OwnerId);
        }
        map<id, string> userMap = new map<id, String>();
        list<user> userList = [select id, managerId, manager.email
                               from user
                               where id in:leadWithOwnerMap.values()];
        //  system.debug(userList);
        for (user u : userList){
            userMap.put(u.id, u.manager.email);
        }
        // system.debug(userMap);
        for (lead__c l : triggerNew){
            l.Manager_Email_id__c = userMap.get(l.ownerId);
            if (l.Source_of_Lead__c == 'Website Cart Page'){
                l.Web_Sub_Source__c = 'Cart Abandoned';
            }
            //  system.debug(l.Manager_Email_id__c);
        }
    }
    
    // Added by Nitya to change the lead stage to invalid lead or appointment booked
    // added on 25th march 2022
    // updated on 25th May 2022:added if condition
    // only on Insertion in before context
    public static void UpdateLeadStage(List<lead__c> triggerNew){
        for (lead__c l : triggerNew){
            if (l.Sub_Category__c == 'Appointment Booked' && l.Source_of_Lead__c != 'Website Cart Page'){
                l.Stage__c = 'Appointment Booked';
            } else if (l.Phone_Formula__c != null && l.Phone_Formula__c.length() < 10){
                l.Stage__c = 'Invalid Lead';
            }
            
        }
    }
    
    /*****************Sending SMS to QR Code User Specified***************************************************************/
     public static void sendSMS2(List<lead__c> leadr) {
        system.debug('lead list'+leadr);
        string phone1;
        string createdby;
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        //string user= 'QR Site Guest User' ;
        string user = 'TMC Admin';
        list<lead__c>Leadr2 = new list<lead__c>([Select RecordTypeId,id,name,createdby.Name,Mobile_Phone__c from lead__c where id=:leadr ]);
        for(lead__c lr:Leadr2){
            system.debug('Phone-->'+ lr.Mobile_Phone__c );
            system.debug('Record-->'+ lr.RecordTypeId );
            phone1=lr.Mobile_Phone__c;
            createdby=lr.createdby.Name;
            system.debug('Created-->'+createdby);
            if(lr.RecordTypeId == recordtype && createdby==user && phone1!=null){
                {
                    
                   system.debug('Inside loop'); 
                    string toNumber = phone1;            
                    SMSQRCode.sendSMS2(toNumber);
                  System.debug('check SMS');
                    
                }
            }
            
        }
        
    }
    /****************************************Added by shivam to send SMS for Complaint Registerd****************************/
    public static void sendSMS3(List<lead__c> leadr) {
        system.debug('lead list'+leadr);
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        list<lead__c>Leadr2 = new list<lead__c>([Select RecordTypeId,id,name,Complaint_Number__c ,Mobile_Phone__c,stage_status__c from lead__c where id=:leadr ]);
        for(lead__c lr:Leadr2){
            system.debug('Phone-->'+ lr.Mobile_Phone__c );
            system.debug('Stage-->'+ lr.stage_status__c );
  
            if(lr.stage_status__c == 'New' && lr.Mobile_Phone__c!=null){
                {
                    
                    system.debug('Inside loop'); 
                    string toNumber = lr.Mobile_Phone__c; 
                    string CompliantNumber = lr.Complaint_Number__c ; 
                    SMSQRCode.sendSMS3(toNumber,CompliantNumber);
                  System.debug('check SMS');
                    
                }
            }
            
        }
        
    }
  
    /****************************************Added by shivam to send SMS for Complaint Closed****************************/
    public static void sendSMS4(List<lead__c> leadr) {
        system.debug('lead list'+leadr);
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max Lab customer lead').getRecordTypeId();
        list<lead__c>Leadr2 = new list<lead__c>([Select RecordTypeId,id,name,Complaint_Number__c ,Mobile_Phone__c,stage_status__c from lead__c where id=:leadr ]);
        for(lead__c lr:Leadr2){
            system.debug('Phone-->'+ lr.Mobile_Phone__c );
            system.debug('Stage-->'+ lr.stage_status__c );
  
            if(lr.stage_status__c == 'Closed' && lr.Mobile_Phone__c!=null){
                {
                    
                    system.debug('Inside loop'); 
                    string toNumber = lr.Mobile_Phone__c; 
                    string CompliantNumber = lr.Complaint_Number__c ; 
                    SMSQRCode.sendSMS4(toNumber,CompliantNumber);
                   System.debug('check SMS');
                    
                }
            }
            
        }
        
    }
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
    /********************ADDED BY SHIVAM FOR DUPLICATE CHECK ON LEAD FOR 24HOURS 16th sept 2022***************************/
    
    public static void checkduplicate2(list<Lead__c>leadlist1){
        string Namecheck;
        string Phonecheck;
        string combination;
        string idname;
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        for(Lead__c leadcheck:leadlist1){
            if(leadcheck.RecordTypeId==recordtype){
                system.debug(leadlist1);
                Namecheck=leadcheck.Name; 
                Phonecheck=leadcheck.Mobile_Phone__c;
                combination=Namecheck.toUpperCase()+Phonecheck;
            }
        }
    
        if(combination!=null){
            list<Lead__c>leadchecklist = new list<Lead__c>([Select id,Name,DuplicateCheck__c,Hiddencheck__c, Timecreated__c,CombinationNamePhone__c,createddate, Mobile_Phone__c from lead__c  where CombinationNamePhone__c=:combination and createddate=today order by createddate ASC]);
            if(leadchecklist.size()>0){
                idname= leadchecklist[0].id;
                for(Lead__c leadr:leadchecklist){
                    leadr.DuplicateCheck__c = true;
                }
                
                update leadchecklist;
                leadchecklist[0].DuplicateCheck__c=false;
                update leadchecklist;
            }
        }
    }
      
    /********************ADDED BY SHIVAM FOR AUTO DESK API 25th Aug 2022***************************/
 /*   
    public static void autodeskapi(list<lead__c>leading){
        string PhoneNumber;
        string Source;
        id leadid;
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        for(lead__c leadvar:leading)
        {
            if(leadvar.RecordTypeID==RecordTypeId && leadvar.Sub_Source__c!='CT-call'){
                Source=leadvar.Lead_Source__c;
                system.debug(Source);  
            }
            
        }
        list<Auto_Desk_Sources__mdt>leadlist= new list<Auto_Desk_Sources__mdt>();
        leadlist=[ Select id,Lead_Source__c from Auto_Desk_Sources__mdt where Lead_Source__c=:Source  limit 1];
        system.debug(leadlist);
        system.debug(leadlist.size());
        if(leadlist.size()==0){
            for(lead__c ld:leading){ 
                PhoneNumber=ld.Mobile_Phone__c;
                 leadid=ld.id;
                system.debug(PhoneNumber);
            }
        }      
        if(PhoneNumber!=null){
            Autodesk.Followup1(PhoneNumber,leadid);
        }
    }
    */
    /*****************************ADDED BY SHIVAM FOR CHECKBOX LOGIC IN AUTODESK API********************/
   /* 
    public static void autodeskapi2(list<lead__c>leading){
        System.debug(leading);
        string PhoneNumber;
        id leadid;
        string Source;
        boolean check= false;
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        for(lead__c leadvar:leading)
        {
            Source=leadvar.Lead_Source__c;
            system.debug(Source);
            
            if(leadvar.Follow_up_Checked__c==true && leadvar.RecordTypeID== RecordTypeId && leadvar.Sub_Source__c!='CT-call'){   
                check = true;
            }
            system.debug('leadvar.Follow_up_Checked__c'+leadvar.Follow_up_Checked__c);
            system.debug('check'+check);
            system.debug('leadvar.RecordType.Name'+leadvar.RecordType.Name);
        }
        list<Auto_Desk_Sources__mdt>leadlist= new list<Auto_Desk_Sources__mdt>();
        leadlist=[ Select id,Lead_Source__c from Auto_Desk_Sources__mdt where Lead_Source__c=:Source limit 1];
        system.debug(leadlist);
        system.debug(leadlist.size());
        if(leadlist.size()==0){
            for(lead__c ld:leading){ 
                PhoneNumber=ld.Mobile_Phone__c;
                leadid=ld.id;
                system.debug(PhoneNumber);
            }
        }      
        system.debug(PhoneNumber+'PhoneNumber');
         system.debug(check+'check');
        if(PhoneNumber!=null && check==true){
            system.debug('PhoneNumber'+PhoneNumber);
            Autodesk.Followup1(PhoneNumber,leadid);
        }
    }
     
    
  */  
    
    
    /* private Boolean isValid(String PhoneNumber) {
return Pattern.matches('[0-9(),./\\-]+', PhoneNumber);
}*/
    
    
    // Added by Nitya to change the lead stage to duplicate lead
    // added on 25th march 2022
    // Only on Insertion in before context
    public static void changeLeadStageToDuplicate(List<lead__c> triggerNew){
        set<String> phoneSet = new set<string>();
        set<string> sourceSet = new set<string>();
        Map<string, lead__c> leadMap = new map<string, lead__c>();
        for (lead__c l : triggerNew){
            //added on 25th May
            if (l.Stage__c != 'Invalid Lead' && l.Stage__c != 'Appointment booked'){
                phoneSet.add(l.Phone_Formula__c);
                sourceSet.add(l.Source_of_Lead__c);
            }
        }
        //system.debug(phoneSet);
        //system.debug(sourceSet);
        dateTime dt = System.Now().addHours(-1);
        
        for (lead__c l : [select Phone_Formula__c, Source_of_Lead__c, stage__c
                          from lead__c
                          where Phone_Formula__c in:phoneSet AND Source_of_Lead__c in:sourceSet AND createdDate >= :dt and recordtype.name = 'Max Lab Customer Lead']){
                              leadMap.put(l.Phone_Formula__c + l.Source_of_Lead__c, l);
                          }
        //added on 25th May 2022
        if (leadMap.isEmpty())
            return;
        // system.debug(leadMap);
        for (lead__c lead : triggerNew){
            if (leadMap.containsKey(lead.Phone_Formula__c + lead.Source_of_Lead__c)){
                lead.Stage__c = 'Duplicate Lead';
            }
        }
    }
    
    //Added by Nitya on 25th May 2022 to remove process builder
    //on insertion as well as updation
    //before context
    public static void updateMobileAndSourceOfLead(List<Lead__c> triggerNew){
        for (lead__c l : triggerNew){
            if (l.Sub_Category__c == 'Appointment Booked'){
                l.Source_of_Lead__c = 'Call Center converted inbound';
                l.MaxLab_Mobile_no__c = l.Mobile_Phone__c;
            }
        }
    }
    
    //added by Nitya on 26th May 2022 in after context
    //on Insertion
    public static void createCase(List<lead__c> triggerNew){
        
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        List<case> caseList = new List<case>();
        for (lead__c l : triggerNew){
            if (l.RecordTypeId == recordtype && l.Lead_Create__c == false && l.Source_of_Lead__c != 'JustDial'){
                Case c = new case();
                c.Address_Line_1__c = l.Address_Line_1__c;
                c.Appointment_Date__c = l.Appointment_Date__c;
                c.Campaign__c = l.Campaign__c;
                c.Country_Region__c = l.Country_Region__c;
                c.DCA_Subtype__c = l.DCA_Subtype__c;
                c.Description = l.Digital_Description__c;
                c.Doctor_Name__c = l.Doctor_Name__c;
                c.Email__c = l.Email__c;
                c.EnquiryID__c = l.EnquiryID__c;
                c.File_Link__c = l.File_Link__c;
                c.File_Name__c = l.File_Name__c;
                c.Form_Name__c = l.Form_Name__c;
                c.HIS_Unique_Lead_ID__c = l.HIS_Unique_Lead_ID__c;
                c.Hospital_Name__c = l.Hospital_Name__c;
                c.IP_Address__c = l.IP_Address__c;
                c.Keyw__c = l.Keyw__c;
                c.Lead_Channel__c = l.Digital_Lead_Channel__c;
                c.Lead_Create__c = false;
                c.Lead_Source__c = l.Lead_Source__c;
                c.Lead_Type__c = l.Lead_Type__c;
                c.Lead__c = l.id;
                c.Max_ID__c = l.Max_ID__c;
                c.Mobile_Phone__c = l.Mobile_Phone__c;
                c.OwnerId = l.OwnerId;
                c.Passport_No__c = l.Passport_No__c;
                c.Patient_Name__c = l.Patient_Name__c;
                c.Placement__c = l.Placement__c;
                c.Speciality__c = l.Speciality_Text__c;
                c.Stage__c = l.Stage__c;
                c.State_Province__c = l.State_Province__c;
                c.Status = l.Stage__c;
                c.Sub_Source__c = l.Sub_Source__c;
                c.Submitted_On__c = l.Submitted_On__c;
                c.Name__c = l.Lead_Name__c;
                c.UTM_Parameters__c=l.UTM_Parameters__c;
                c.GCLID__c=l.GCLID__c;
                //added by Nitya on 6th June for preventing default assignment rule to run
                /*  Database.DMLOptions options = new Database.DMLOptions();
options.assignmentRuleHeader.useDefaultRule = false;
c.setOptions(options);
*/
                caseList.add(c);
            }
        }
        
        insert caseList;
    }
    
    //added by Nitya on 26th May 2022
    //after update in after context
    public static void updateCaseRecord(list<lead__c> triggerNew, map<id, lead__c> oldMap){
        Id recordtype = schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        // Set<id>leadIds=new Set<id>();
        List<lead__c> leadListFiltered = new List<lead__c>();
        for (lead__c l : triggerNew){
            if ((oldmap.get(l.id).max_Id__c != l.Max_ID__c) || (oldmap.get(l.id).stage__c != l.Stage__c && l.RecordTypeId == recordtype)){
                //  leadIds.add(l.id);
                leadListFiltered.add(l);
            }
        }
        Map<id, case> LeadWithCaseMap = new map<id, case>();
        list<lead__c> leadList = [select id, stage__c, max_id__c, (select id, stage__c, max_id__c, status
                                                                   from Digital_Leads__r)
                                  from lead__c
                                  where id in:leadListFiltered];
        if (leadList.isEmpty())
            return;
        for (lead__c l : leadList){
            leadWithCaseMap.put(l.id, l.digital_leads__r);
        }
        for (lead__c l : leadListFiltered){
            if (l.max_id__c != oldmap.get(l.id).max_id__c){
                leadWithCaseMap.get(l.id).max_id__c = l.max_id__c;
            } else if (oldmap.get(l.id).stage__c != l.Stage__c && l.RecordTypeId == recordtype){
                leadWithCaseMap.get(l.id).stage__c = l.Stage__c;
                leadWithCaseMap.get(l.id).status = l.Stage__c;
            }
        }
        //added by Nitya on 6th June for preventing default assignment rule to run
        /* for(case c:leadWithCaseMap.values()){
Database.DMLOptions options = new Database.DMLOptions();
options.assignmentRuleHeader.useDefaultRule = false;
c.setOptions(options);
}  */
        update leadWithCaseMap.values();
    }
    
    // added on 31st May 2022 to replace process builder
    //on both insertion and updation in after context
    public static void updateRelatedProspect(List<lead__c> triggerNew){
        Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        set<id> setOfIds = new set<id>();
        list<prospect__c> prospectList = new list<prospect__c>();
        for (lead__c l : triggerNew){
            if (l.recordTypeID == recordTypeId && l.Prospect__c != null){
                //setOfIds.add(l.id);
                if (l.Existing_Patient__c && l.member_id__c == null){
                    prospectList.add(new prospect__c(id = l.prospect__c, existing_patient__c = true));
                } else if (l.Member_ID__c != null && l.Existing_Patient__c == false){
                    prospectList.add(new prospect__c(id = l.prospect__c, cmp_enrolled_member__c = true));
                } else if (l.Member_ID__c != null && l.Existing_Patient__c){
                    prospectList.add(new prospect__c(id = l.prospect__c, cmp_enrolled_member__c = true, existing_patient__c = true));
                }
            }
        }
        update prospectList;
    }
    
    //added by Nitya on 1st june 2022 to replace process builder
    //on insertion in before context
    //to update the owner for digital call center record type
    public static void updateDigitalCallCenterOwner(List<lead__c> triggerNew){
        id recordtypeId = schema.SObjectType.Lead__c.getrecordtypeInfosByName().get('Digital Call Center').getRecordTypeId();
        id userid = [select id
                     from user
                     where name = 'Basant Mehta'].id;
        for (lead__c l : triggerNew){
            if (l.recordtypeId == recordtypeId){
                l.OwnerId = userId;
            }
        }
    }
    
    //added by Nitya on 1st June 2022 to replace workflows
    //on insertion in before context
    //replaced createddate with system.now() coz created date is null in before insert context
    public static void updateIntimationDate(List<lead__c> triggerNew){
        id recordtypeId = schema.SObjectType.lead__c.getRecordTypeInfosByName().get('MECP').getRecordTypeId();
        id recordTypeId1 = schema.SObjectType.lead__c.getRecordTypeinfosByName().get('International Tagging').getRecordTypeId();
        for (lead__c l : triggerNew){
            if (l.RecordTypeId == recordTypeId || l.RecordTypeId == recordTypeId1){
                l.Intimation_Date_Time__c = system.now();
            }
        }
    }
    
    //to replace workflows
    //on after insert and update
    //added by Nitya on 1st june 2022
    public static void createFollowupLead(List<lead__c> triggerNew){
        list<task> taskList = new list<task>();
        for (lead__c l : triggerNew){
            if (l.Follow_Up_time__c == '1' || l.Follow_Up_time__c == '2' || l.Follow_Up_time__c == '3' || l.Follow_Up_time__c == '4'){
                task t = new task();
                t.WhatId = l.id;
                t.Priority = 'Normal';
                t.Status = 'Open';
                t.OwnerId = l.OwnerId;
                t.Subject = 'Follow Up Lead';
                if (l.Follow_Up_Data_TIme__c != null)
                    t.ActivityDate = l.Follow_Up_Data_TIme__c.date();
                taskList.add(t);
            }
        }
        insert taskList;
    }
    
    //upto here
    public static void generateSFRelationShipId(List<Lead__c> triggerNew){
        list<lead__c> listtoupdate = new list<lead__c>();
        map<id, lead__c> leadmapprimary = new map<id, lead__c>();
        
        Id devRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        
        CMP_Relationship_SF_ID__c mySettings = CMP_Relationship_SF_ID__c.getOrgDefaults();
        Double myAutoNum = mySettings.AutoNumber__c;
        
        for (lead__c ld : triggerNew){
            if (ld.recordtypeid == devRecordTypeId)
                leadmapprimary.put(ld.id, null);
        }
        
        for (lead__c ld : [select id, Family_Member__c, SF_Relationship_ID__c, Primary_Member__c, Family_Member__r.SF_Relationship_ID__c, Family_Member__r.Primary_Member__c
                           from lead__c
                           where id in:leadmapprimary.keySet()]){
                               leadmapprimary.put(ld.id, ld);
                               //system.debug(ld.Family_Member__c);
                               if (ld.Primary_Member__c == true && ld.Family_Member__c == null){
                                   ld.SF_Relationship_ID__c = 'CMP-' + string.valueOf(myAutoNum).removeEnd('.0');
                                   myAutoNum = myAutoNum + 1;
                                   listtoupdate.add(ld);
                               }
                               if (ld.Primary_Member__c == false && ld.Family_Member__c != null && ld.Family_Member__r.SF_Relationship_ID__c == null){
                                   listtoupdate.add(new lead__c(id = ld.id, SF_Relationship_ID__c = 'CMP-' + string.valueOf(myAutoNum).removeEnd('.0')));
                                   listtoupdate.add(new lead__c(id = ld.Family_Member__c, SF_Relationship_ID__c = 'CMP-' + string.valueOf(myAutoNum).removeEnd('.0')));
                                   myAutoNum = myAutoNum + 1;
                               }
                               if (ld.Primary_Member__c == false && ld.Family_Member__c != null && ld.Family_Member__r.SF_Relationship_ID__c != null){
                                   ld.SF_Relationship_ID__c = ld.Family_Member__r.SF_Relationship_ID__c;
                                   listtoupdate.add(ld);
                               }
                           }
        mySettings.AutoNumber__c = myAutoNum;
        //system.debug(myAutoNum);
        update mySettings;
        
        if (listtoupdate.size() > 0)
            update listtoupdate;
    }
    
    public static void validationFunction(List<Lead__c> triggerNew){
        map<Id, boolean> leadmapprimaryerror = new map<Id, boolean>();
        for (lead__c ld : triggerNew){
            if (ld.Family_Member__c != null)
                leadmapprimaryerror.put(ld.Family_Member__c, null);
        }
        
        for (lead__c ld : [select id, SF_Relationship_ID__c, Primary_Member__c
                           from lead__c
                           where id in:leadmapprimaryerror.keySet()]){
                               leadmapprimaryerror.put(ld.id, ld.Primary_Member__c);
                           }
        
        for (lead__c ld : triggerNew){
            if (leadmapprimaryerror.containskey(ld.Family_Member__c) && leadmapprimaryerror.get(ld.Family_Member__c) == true && ld.Primary_Member__c == true){
                ld.adderror('Error: Primary member already exists');
            }
        }
    }
    
    //Duplicate Lead Logic for Digital Process
    public static void validationDuplicate(List<Lead__c> triggerNew){
        
        map<string, Lead__c> emailmap = new map<string, Lead__c>();
        map<string, Lead__c> mobilemap = new map<string, Lead__c>();
        map<string, Lead__c> namemap = new map<string, Lead__c>();
        
        for (Lead__c ld : triggerNew){
            if (ld.RecordTypeId == Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId()){
                if (ld.Email__c != null && ld.Mobile_Phone__c != null && ld.Name != null){
                    emailmap.put(ld.Email__c, ld);
                    mobilemap.put(ld.Mobile_Phone__c, ld);
                    namemap.put(ld.Name, ld);
                }
            }
        }
        if (emailmap != null && emailmap.size() > 0){
            Id recordtypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
            for (Lead__c existlead : [SELECT Email__c, Mobile_Phone__c, Name
                                      from Lead__c
                                      where RecordTypeId = :recordtypeId AND Name IN:namemap.keyset() AND Mobile_Phone__c IN:mobilemap.keyset() AND Email__c IN:emailmap.keyset()]){
                                          Lead__c lea = emailmap.get(existlead.Email__c);
                                          lea.addError('There is already a lead with this email,phone no and Name');
                                      }
        }
    }
    
    //Round Robin Logic Assignment for Digital Process
    //edited by Nitya(IRT)
    public static void AssignleadAndIncrementUser(List<Lead__c> triggerNew){
        
        List<Round_Robin_Sequence__c> mcs = new List<Round_Robin_Sequence__c>();
        map<decimal, string> usermap = new map<decimal, string>();
        for (user u : [select id, name, Round_Robin__c
                       from user
                       where IsActive = true and Round_Robin__c != null AND userrole.name = 'Digital Customer Acquisition'
                       order by Round_Robin__c]){
                           usermap.put(u.Round_Robin__c, u.id);
                       }
        // system.debug(userMap);
        integer countNumber;
        String rt = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        mcs = Round_Robin_Sequence__c.getall().values();
        countNumber = Integer.valueof(mcs[0].Sequence__c);
        // system.debug(countNumber);
        List<String> setSource = Label.RoundRobinFilter.split(';');
        //added by Nitya on 15th March 2022
        List<String> hospitalName = Label.Round_Robin_Hospital.split(',');
        // system.debug(hospitalName);
        List<String> subSource = Label.Round_Robin_Subsource.split(',');
        List<String> campaignName = label.campaign_name.split(';');
        //Added By Nitya on 25th July 2022
        map<string, id> metaMap = new map<string, id>();
        for (map_campaign_with_user__mdt rec : [select DeveloperName, user_id__c
                                                from map_campaign_with_user__mdt
                                                where label in:campaignName]){
                                                    metaMap.put(rec.developerName, rec.user_id__c);
                                                }
        system.debug(metaMap);
        
        for (Lead__c ld : triggerNew){
            Boolean flag = false;
            if (ld.Lead_Source__c != NULL && setSource.contains(ld.Lead_Source__c) && ld.RecordTypeId == rt && (!hospitalName.contains(ld.Hospital_Name__c)) && (!subSource.contains(ld.Sub_Source__c))){
                for (string s : campaignName){
                    if (ld.Campaign__c!= null && ld.Campaign__c.containsIgnoreCase(s)){
                        ld.ownerId = metaMap.get(s);
                        flag = true;
                    }
                    
                }
                if (flag == false && usermap != null && usermap.size() > 0){
                    if (usermap.containsKey(countNumber)){
                        ld.OwnerId = usermap.get(countNumber);
                        countNumber++;
                    }
                    //   system.debug(ld);
                    if (countNumber == Integer.valueOf(label.Round_Robin_Logic)){
                        countNumber = 1;
                    }
                }
            }
            
        }
        
        mcs[0].Sequence__c = countNumber;
        update mcs;
    }
    
    public static void postChatter(){
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
        Set<Id> docId = new Set<Id>();
        List<Lead__c> listLead = new List<Lead__c>();
        List<FeedItem> listFeedItem = new List<FeedItem>();
        String urlInstance = URL.getSalesforceBaseUrl().toExternalForm();
        
        Map<Id, Id> mapToDocCoordinatorMaster = new Map<Id, Id>();
        for (SObject sobj : trigger.New ){
            Lead__c lead = (Lead__c)sobj;
            if (lead.RecordTypeId == recordTypeId && lead.Stage__c == 'Referred to Max' && lead.Doctor__c != NULL){
                docId.add(lead.Doctor__c);
                listLead.add(lead) ;
            }
        }
        
        if (docId != NULL && docId.size() > 0)
            for (Doctor_Coordinator_Master__c dcm : [SELECT Id, Doctor__c, Co_ordinator__c
                                                     FROM Doctor_Coordinator_Master__c
                                                     WHERE Doctor__c IN:docId AND Co_ordinator__c != NULL])
            mapToDocCoordinatorMaster.put(dcm.Doctor__c, dcm.Co_ordinator__c);
        if (mapToDocCoordinatorMaster != NULL && mapToDocCoordinatorMaster.keySet().size() > 0){
            for (Lead__c lead : listLead){
                if (mapToDocCoordinatorMaster.containsKey(lead.Doctor__c)){
                    FeedItem post = new FeedItem();
                    String customLabelPost = Label.ReferToMaxPostMessage;
                    customLabelPost = customLabelPost.replace('Patient_Name', lead.Name);
                    post.ParentId = mapToDocCoordinatorMaster.get(lead.Doctor__c);
                    post.Body = customLabelPost + '\n\n' + urlInstance + '/' + lead.Id;
                    listFeedItem.add(post);
                }
            }
        }
        
        if (listFeedItem != NULL && listFeedItem.size() > 0)
            insert listFeedItem;
    }
    
    @future(callout = true)
    public static void UpdateLeadIdInLead(string ldId){
        try{
            ModelObj obj = new ModelObj();
            list<Lead__c> listlead = new list<Lead__c>();
            List<Lead__c> ld = [SELEct id, Name, First_Name__c, Last_Name__c, Admission_Date__c, Doctor__c, Contact_Person_Name__c, Ward_Bed__c, Address_Line_2__c, Owner_Name__c, Contact_Person_MobileNo__c, Stage__c, WardNo__c, Hospital_Location__c, Speciality_Department__c, Speciality_Department__r.Name, Remarks__c, Doctor__r.Name, Email__c, Mobile_Phone__c, Max_ID__c, Patient__c, Lead_Origin__c, Title__c, Lead_Id_For_Max_Home__c, Diagnostic__c, Ailment__c, Services__r.Service_Id__c, BedNo__c, Updated_Ward_and_Bed_Number__c
                                FROM Lead__c
                                WHERE id = :ldId AND Patient__c != NULL];
            
            string body = '';
            if (ld != NULL && ld.size() > 0){
                if (string.isNotBlank(ld[0].Remarks__c))
                    obj.specialRequest = ld[0].Remarks__c;
                if (string.isNotBlank(ld[0].First_Name__c))
                    obj.firstName = ld[0].First_Name__c;
                if (string.isNotBlank(ld[0].Last_Name__c))
                    obj.lastName = ld[0].Last_Name__c;
                if (string.isNotBlank(ld[0].Email__c))
                    obj.Email = ld[0].Email__c;
                if (string.isNotBlank(ld[0].Mobile_Phone__c))
                    obj.MobilePhone = ld[0].Mobile_Phone__c;
                if (string.isNotBlank(ld[0].Max_ID__c))
                    obj.MaxId = ld[0].Max_ID__c;
                if (string.isNotBlank(ld[0].Title__c))
                    obj.PatientTitle = ld[0].Title__c;
                if (string.isNotBlank(ld[0].Speciality_Department__r.Name))
                    obj.dept = ld[0].Speciality_Department__r.Name;
                if (string.isNotBlank(ld[0].Hospital_Location__c))
                    obj.HospitalName = ld[0].Hospital_Location__c;
                if (string.isNotBlank(ld[0].Stage__c))
                    obj.DischargeStatus = ld[0].Stage__c;
                if (string.isNotBlank(ld[0].WardNo__c))
                    obj.Ward = ld[0].WardNo__c;
                if (string.isNotBlank(ld[0].Contact_Person_Name__c))
                    obj.AttendantName = ld[0].Contact_Person_Name__c;
                if (string.isNotBlank(ld[0].Contact_Person_MobileNo__c))
                    obj.AttendantPhoneNumber = ld[0].Contact_Person_MobileNo__c;
                if (string.isNotBlank(ld[0].Owner_Name__c))
                    obj.LeadOwner = ld[0].Owner_Name__c;
                if (string.isNotBlank(ld[0].Address_Line_2__c))
                    obj.Address = ld[0].Address_Line_2__c;
                if (ld[0].Admission_Date__c != NULL)
                    obj.AdmitDate = ld[0].Admission_Date__c;
                if (string.isNotBlank(ld[0].Doctor__r.Name))
                    obj.doctorName = ld[0].Doctor__r.Name;
                if (string.isNotBlank(ld[0].Lead_Origin__c))
                    obj.leadOrgin = ld[0].Lead_Origin__c;
                if (string.isNotBlank(ld[0].Services__r.Service_Id__c))
                    obj.ServiceId = ld[0].Services__r.Service_Id__c;
                if (string.isNotBlank(ld[0].Diagnostic__c))
                    obj.diagnosis = ld[0].Diagnostic__c;
                if (string.isNotBlank(ld[0].Ailment__c))
                    obj.Ailment = ld[0].Ailment__c;
                //if(string.isNotBlank(ld[0].BedNo__c))
                //  obj.Bed=ld[0].BedNo__c;
                
                if (string.isNotBlank(ld[0].Ward_Bed__c))
                    obj.wardbed = ld[0].Ward_Bed__c;
                if (string.isNotBlank(ld[0].Lead_Id_For_Max_Home__c)){
                    obj.LeadId = ld[0].Lead_Id_For_Max_Home__c;
                    //system.debug('Inside IF  Part' + ld[0].Lead_Id_For_Max_Home__c);
                } else{
                    //system.debug('Inside Else Part' + ld[0].Lead_Id_For_Max_Home__c);
                    obj.LeadId = ld[0].Lead_Id_For_Max_Home__c;
                }
                
                System.debug('Lead Object Data ====> ' + obj);
                body = JSON.serialize(obj);
                
                
            }
            
            Http hreq = new Http();
            HttpRequest req = new HttpRequest();
            String url = Label.SaveLeadAPI;
            req.setEndpoint(url) ;
            req.setMethod('POST');
            String username = Label.SaveLeadAPIUserName;
            String password = Label.SaveLeadAPIPassword;
            req.setHeader('Content-type', 'application/json');
            Blob headerValue = Blob.valueOf(username + ':' + password);
            EncodingUtil.base64Encode(headerValue);
            //req.setHeader('User-Agent',Label.SaveLeadAPIUserName);
            //req.setHeader('Content-Length',Label.SaveLeadAPIContentLength);
            req.setHeader('Authorization', Label.SaveLeadAPIAuthorization);
            //req.setHeader('Host',Label.SaveLeadAPIHost);
            //req.setHeader('charset','utf-8');
            //req.setHeader('Password',Label.SaveLeadAPIPassword);
            req.setTimeout(60000);
            req.setBody(body);
            //system.debug('==body=='+body);
            //system.debug('====>req==>'+req);
            if (!test.isRunningTest()){
                HttpResponse res = hreq.send(req);
                if (res.getStatusCode() == 200){
                    string str = res.getBody();
                    if (String.isNotBlank(res.getBody())){
                        Map<String, Object> mapKeyToValue = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                        if (mapKeyToValue != NULL && mapKeyToValue.keySet().size() > 0){
                            if (mapKeyToValue.containsKey('LeadId') && mapKeyToValue.get('LeadId') != NULL){
                                //system.debug('LeadId===========>'+ (String)mapKeyToValue.get('LeadId'));
                                ld[0].Lead_Id_For_Max_Home__c = (String) mapKeyToValue.get('LeadId');
                            }
                            
                        }
                    }
                }
            } else{
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
            }
            if (ld != NULL && ld.size() > 0)
                listlead.addAll(ld);
            if (listlead.size() > 0)
                update listlead;
        } catch (Exception e){
            
        }
    }
    
    //Populate Max Id on lead
    public static void updateMaxId(list<lead__c> leadlist){
        
        map<String, String> mapofPhone = new map<string, string>();
        map<String, String> mapofEmail = new map<string, string>();
        set<string> setofpatients = new set<string>();
        Map<String, String> mapPhoneToMaxId;
        Map<String, String> mapEmailToMaxId;
        
        Id recordtypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        
        for (lead__c ld : leadlist){
            if (ld.RecordTypeId == recordtypeId){
                if (ld.Mobile_Phone__c != null)
                    mapofPhone.put(ld.Mobile_Phone__c, null);
                else if (ld.Email__c != null)
                    mapofEmail.put(ld.Email__c, null);
                if (ld.Patient_Name__c != null)
                    setofpatients.add(ld.Patient_Name__c);
            }
        }
        
        if (mapofPhone.keySet().size() > 0)
            mapPhoneToMaxId = FetchMaxIDsFromPatients.fetchMaxIdFromPhone(mapofPhone, setofpatients);
        if (mapofEmail.keySet().size() > 0)
            mapEmailToMaxId = FetchMaxIDsFromPatients.fetchMaxIdFromEmail(mapofEmail, setofpatients);
        if ((mapPhoneToMaxId != NULL && mapPhoneToMaxId.keySet().size() > 0) || (mapEmailToMaxId != NULL && mapEmailToMaxId.keySet().size() > 0)){
            for (Lead__c lead : leadList){
                if (lead.Mobile_Phone__c != null && mapPhoneToMaxId.containsKey(lead.Mobile_Phone__c))
                    lead.Max_ID__c = mapPhoneToMaxId.get(lead.Mobile_Phone__c);
                else if (lead.Email__c != null && mapEmailToMaxId.containsKey(lead.Email__c)){
                    lead.Max_ID__c = mapEmailToMaxId.get(lead.Email__c);
                }
            }
        }
    }
    
    public class ModelObj{
        public string specialRequest;
        public string firstName;
        public string lastName;
        public String Email;
        public String MobilePhone;
        public String MaxId;
        public String HospitalName;
        public string DischargeStatus;
        public string Ward;
        public string AttendantName;
        public string AttendantPhoneNumber;
        public String PatientTitle;
        public String dept;
        public string LeadOwner;
        public string Address;
        public Date AdmitDate;
        public string doctorName;
        public String leadOrgin;
        public String ServiceId;
        public string diagnosis;
        public string Ailment;
        public string Bed;
        public string LeadId;
        public string wardbed;
        
        // New Field update
        /*public string productName;
public string title;
public string description;
public string pincode;
public string RatingStatus;
public string PatientID;
public string AlternateNo;
public String EmpId;
public String createdBy;
public string LeadId;*/
    }
    
    /* Following code is not used now - It creates Max lab call history

public static void createMaxLabCustomerLead(List<Lead__c> leadList){
List<Max_Lab_Call_History__c> maxLabHistoryList = new List<Max_Lab_Call_History__c>();
System.debug('leadList=Helper=>>'+leadList);
for(Lead__c lead : leadList){
Max_Lab_Call_History__c maxLabHistory = new Max_Lab_Call_History__c();
Max_Lab_Call_History__c maxLabHistoryToCheck = new Max_Lab_Call_History__c();
maxLabHistory = MaxLabcallcenterApexController1.createHistoryRecord(Lead.Call_Start_Time_Test__c , Lead.Name, lead.Call_Time_Test__c, Lead.Maxlab_Mobile_no__c,
Lead.Call_Category__c, Lead.Sub_Category__c, Lead.IVR__c, Lead.Tech_Status__c, Lead.Call_Source__c,
'', lead.Description__c, Lead.Id);
If(maxLabHistoryToCheck != maxLabHistory){
maxLabHistoryList.add(maxLabHistory);
}
}
System.debug('maxLabHistoryList==>>'+maxLabHistoryList);
if(maxLabHistoryList.size() > 0 ){
insert maxLabHistoryList;
}
}*/
    /*
// Assign Digital Call Center Lead to Call Center Agent User
public static void AssignleadToCallCenterUser(List<Lead__c> triggerNew){
system.debug('====Raghav===');
List<Round_Robin_For_Call_Center_Agent__c> mcs = new  List<Round_Robin_For_Call_Center_Agent__c>();
//system.debug('=====mcs==='+mcs);
map<decimal,string> usermap = new map<decimal,string>();

for(user u : [select id, name,Round_Robin_Call_Centre__c,userrole.name from user where IsActive = true
AND Round_Robin_Call_Centre__c !=null
AND userrole.name='Call Center Agent'
order by Round_Robin_Call_Centre__c]){
usermap.put(u.Round_Robin_Call_Centre__c, u.id);

}
//system.debug('====usermap===='+usermap);
integer countNumber ;
mcs = Round_Robin_For_Call_Center_Agent__c.getall().values();
//system.debug('===mcs188=='+mcs);
countNumber = Integer.valueof(mcs[0].Round_Sequence__c);
//system.debug('====countNumber==='+countNumber);
for(Lead__c ld : triggerNew){
if(ld.RecordTypeId == Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('OP-OP').getRecordTypeId()){
if(usermap != null && usermap.size()>0)
{
if(usermap.containsKey(countNumber)){
system.debug('===contains===');
ld.OwnerId = usermap.get(countNumber);
ld.APISave__c=true;
countNumber++;

}
if (countNumber == Integer.valueOf(label.Round_Robin_Logic_For_Digital_Call_Center)){
countNumber = 1;
}
}
}

}
mcs[0].Round_Sequence__c = countNumber;
update mcs;
//system.debug('===mcs=='+mcs);
}
*/
    // Added by Nitya to change the lead stage once there is an updation on maxid.
    /* public static void searchBillingSummary(List<lead__c> triggerNew, Map<id,lead__c> OldMap){

//add maxId of all incoming lead records to set if maxId has changed or maxId is not null
set<String> setOfMaxIds=new set<string>();
String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
for(lead__c lead:triggerNew){
if(lead.max_id__c!=null && oldMap.get(lead.id).max_id__c!=lead.max_id__c && lead.RecordTypeId==recordTypeId)
setOfMaxIds.add(lead.max_id__c);
}

//If set is empty, we exit as all records have either no max id OR maxId has not changed for any record
if(setOfMaxIds.isEmpty()) return;

//Fetch all billing summary records with maxId in the set created above
list<billing_summary__c> listOfBillingSummaries=[select name__c from billing_summary__c where name__c in :setOfMaxIds and Digital_Lead__c=null];

//create a map of billing summary with key as maxId from the list fetched above as this allows us to
//quickly check if there is a billing summary record against a particular max id using containsKey() method.
map<string,billing_summary__c> mapOfBillingSummary=new map<string,billing_summary__c>();
for(billing_summary__c bill:listOfBillingSummaries){
mapOfBillingSummary.put(bill.name__c.toLowerCase(),bill);
}

//Iterate over all lead records and check the map for billing summary record against the maxId tagged on each lead record. If it exists, update stage
for(lead__c lead:triggerNew){
if(mapOfBillingSummary.containsKey(lead.max_id__c.tolowerCase())) lead.stage__c='OPD Consult Taken';
}
}*/
    /*    public static void DigitalLeadStageUpdation(List<lead__c> triggerNew,Map<id,lead__c> OldMap){
set<String> leadSet=new set<String>();
for(lead__c l:triggerNew){
if(l.recordType.name=='Digital Customer Acquisition' && oldMap.get(l.id).Stage__c!=l.stage__c){
leadSet.add(l.max_id__c);
}
}
list<case> caseList=[select id, stage__c, status, max_id__c from case where max_id__c in: leadSet  ];
for(case c:caseList){
c.Stage__c=c.lead__r.stage__c;
c.Status=c.Lead__r.stage__c;
}
update caseList;

}*/
    /*
//After Insert for SMS1 & SMS2
public static void sendSMS12(){
String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('CMP').getRecordTypeId();
String leadId = '';
for(SObject sObj : trigger.New){
Lead__c lead = (Lead__c)sObj;
if(recordTypeId == lead.RecordTypeId){
leadId += lead.Id + ',';
}
}
if(string.isNotBlank(leadId)) {
leadId.removeEnd(',');
//sendSMS12ToLead(leadId);
}
}

@future(callout=true)
public static void sendSMS12ToLead(String leadId){
Map<String,String> mapToBusinessUnitHelpline = new Map<String,String>();
for(BusinessUnitWithhHelplineNumer__mdt hList : [SELECT Label,HelpLineNumber__c FROM BusinessUnitWithhHelplineNumer__mdt]){
mapToBusinessUnitHelpline.put(hList.Label,hList.HelpLineNumber__c);
}
List<String> leadIdList = leadId.split(',');
for(Lead__c lead : [SELECT Id,Name,Want_to_Enrol__c,Business_Unit__c,Mobile_Phone__c,Membership_Enrolment_Type__c FROM Lead__c WHERE Id IN : leadIdList]){
if(lead.Want_to_Enrol__c == true && lead.Membership_Enrolment_Type__c != NULL){
String customLabelSMS2 = Label.SMS2;
customLabelSMS2 = customLabelSMS2.replace('XXXXXXXXXX',lead.Name);
customLabelSMS2 = customLabelSMS2.replace('"<Program Name>"',lead.Membership_Enrolment_Type__c);
if(mapToBusinessUnitHelpline.containsKey(lead.Business_Unit__c))
customLabelSMS2 = customLabelSMS2.replace('<Unit helpline number>',mapToBusinessUnitHelpline.get(lead.Business_Unit__c));
customLabelSMS2 = customLabelSMS2.replace(' ','%20');
customLabelSMS2 = customLabelSMS2.replace('&','%26');
if(!Test.isRunningTest())
SMSClass.sendSMS(lead.Mobile_Phone__c,customLabelSMS2);
}

if(lead.Want_to_Enrol__c == false) {
String customLabelSMS1 = Label.SMS1;
customLabelSMS1 = customLabelSMS1.replace('XXXXXXXXXX',lead.Name);
customLabelSMS1 = customLabelSMS1.replace(' ','%20');
if(!Test.isRunningTest())
SMSClass.sendSMS(lead.Mobile_Phone__c,customLabelSMS1);
}
}
}

*/
    //Update Patient Account if Facebook lead Name and Mobile Number Matched.
    //commented to deploy on Production
    /*
public static void updatePatientRecord1(){
System.debug('Inside Account  First');
List<Lead__c> lList=[SELECT Id,Name,Mobile_Phone__c,Sub_Source__c,Lead_Source__c,createdDate FROM Lead__c WHERE id IN :trigger.new AND recordTypeId='012N0000000XmAtIAK'];
List<Billing_Summary__c> billingList=[SELECT Id,name__c,Leads__c FROM Billing_Summary__c WHERE Leads__c=null order By createdDate  ASC];
Map<String,Account> AccountMapObj=new Map<String,Account>();
Map<String,Lead__c> LeadMapObj=new Map<String,Lead__c>();
Map<String,Lead__c> LeadMap=new Map<String,Lead__c>();
List<Lead__c> updateLeadList=new List<Lead__c>();
List<Billing_Summary__c> billingSummaryList=new List<Billing_Summary__c>();
Map<String,Billing_Summary__c> billingSummaryMap=new Map<String,Billing_Summary__c>();
// Added by Navin Soni on 24-08-2021 for store lead unique data.
Set<String> setOfLeadName = new Set<String>();
Set<String> setOfLeadPhone = new Set<String>();


for(Billing_Summary__c bs:billingList)
{
billingSummaryMap.put(bs.name__c,bs);
}

for(Lead__c ld:lList)
{
String AccTemp=ld.Name.replaceAll( '\\s+', '');
if(ld.Mobile_Phone__c!=null){ AccTemp+=ld.Mobile_Phone__c; }
LeadMapObj.put(AccTemp,ld);
LeadMap.put(ld.Id,ld);

// Added by Navin Soni on 24-08-2021
setOfLeadName.add(AccTemp);
if(ld.Mobile_Phone__c!=null){
setOfLeadPhone.add(ld.Mobile_Phone__c);

}
}

// Added by Navin Soni on 24-08-2021 for avoid extra Account records.
List<Account> acclist = [SELECT Id,PersonMobilePhone,CreatedDate,Max_ID__c,Leads__c,MiddleName,FirstName,LastName FROM Account WHERE Lead__c = null AND (Name IN : setOfLeadName OR PersonMobilePhone IN : setOfLeadPhone) Order By CreatedDate DESC ];
System.debug('Inside Account  acclist'+acclist);
for(Account acc:acclist){
System.debug('Inside Account  Second');
String AccTemp='';
if(acc.FirstName!=null) { AccTemp+=acc.FirstName; }
if(acc.MiddleName!=null){ AccTemp+=acc.MiddleName; }
if(acc.LastName!=null){ AccTemp+=acc.LastName; }
if(acc.PersonMobilePhone!=null) { AccTemp+=acc.PersonMobilePhone;}
AccountMapObj.put(AccTemp,acc);
}
System.debug('AccountMapObj'+AccountMapObj);

if(LeadMapObj.size()>0){
System.debug('Inside Account  Third');
for(Lead__c leads:LeadMapObj.values())
{
String AccTemp=leads.Name.replaceAll( '\\s+', '');
if(leads.Mobile_Phone__c!=null){ AccTemp+=leads.Mobile_Phone__c; }
System.debug('Inside Account  AccTemp'+AccTemp);
if(AccountMapObj.containsKey(AccTemp))
{
Account ac=AccountMapObj.get(AccTemp);

System.debug('Inside Account  Summary'+ac);
Integer temp=0;
//For Billing Summary field Updation
if(billingSummaryMap.ContainsKey(ac.Max_ID__c) && ac.Max_ID__c!=null)
{
temp=1;
System.debug('Inside Billing Summary');
Billing_Summary__c billingSummary =billingSummaryMap.get(ac.Max_ID__c);
if(billingSummary.Leads__c==Null){
billingSummary.Leads__c=leads.Id;
billingSummaryList.add(billingSummary);
}

Lead__c leads1=LeadMap.get(leads.Id);
leads1.Stage__c='OPD Consult Taken';
leads1.Max_ID__c=ac.Max_ID__c;
leads1.Patient__c=ac.id;
updateLeadList.add(leads1);
}
if(temp==0)
{
System.debug('Inside temp');

Lead__c leads1=LeadMap.get(leads.Id);
leads1.Max_ID__c=ac.Max_ID__c;
leads1.Patient__c=ac.id;
updateLeadList.add(leads1);
}
}
}
}


System.debug('billingSummaryList '+billingSummaryList.size());
if(billingSummaryList.size()>0)
{
System.debug('billingSummaryList'+billingSummaryList);
update billingSummaryList;
}
System.debug('updateLeadList '+updateLeadList.size());
if(updateLeadList.size()>0)
{
System.debug('updateLeadList '+updateLeadList);
update updateLeadList;
}

}


//Update Appointment record if Facebook lead Name and Mobile Number Matched.
public static void updateAppointmentRecord(){
Map<String,String> LeadMap=new Map<String,String>();
Map<String,String> LeadMapId=new Map<String,String>();
List<Appointment__c> updateAppointmentList=new List<Appointment__c>();
list<lead__c> leadlist=[SELECT Id,Name,Mobile_Phone__c,Sub_Source__c,Lead_Source__c FROM Lead__c  WHERE recordTypeId='012N0000000XmAtIAK'];
List<Appointment__c> appointmentlist=[SELECT Id,Patient_Phone__c,Name,Patient__r.name,CreatedDate,Leads__c FROM Appointment__c WHERE Leads__c=null];
for(Lead__c ld:leadlist)
{
LeadMap.put(ld.Mobile_Phone__c,ld.Name);
LeadMapId.put(ld.Mobile_Phone__c,ld.Id);
}
System.debug('LeadMap'+LeadMap);
System.debug('LeadMapId'+LeadMapId);
System.debug('appointmentlist'+appointmentlist);
for(Appointment__c ap:appointmentlist)
{
String tempName=LeadMap.get(ap.Patient_Phone__c);
System.debug('LeadMap.containsKey(ap.Patient_Phone__c)'+LeadMap.containsKey(ap.Patient_Phone__c));
System.debug('tempName'+tempName);
System.debug('ap.Patient__r.name'+ap.Patient__r.name);
if(LeadMap.containsKey(ap.Patient_Phone__c) && tempName==ap.Patient__r.name)
{
System.debug('Inside If');
Id tempId=LeadMapId.get(ap.Patient_Phone__c);
ap.Leads__c=tempId;
updateAppointmentList.add(ap);
}
}
System.debug('updateAppointmentList.size() '+updateAppointmentList.size());
if(updateAppointmentList.size()>0)
{
update updateAppointmentList;
}
}

*/
}