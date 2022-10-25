/*last Modified by :Nitya (IRT) */
@suppressWarnings('PMd')public class AdmissionAcknowledgementHelper{
    
    //added by Nitya on 21st April 2022 to replace workflows
    public static void updateFieldsOnUpdationOfPreIntimationStatus(List<admission_acknowledgement__c> triggerNew){
        for (admission_acknowledgement__c adm : triggerNew){
            adm.SMS_Tagged__c = true;
            adm.Tagged_On__c = system.today();
        }
    }
    //added by shivam on 2nd september
    public static void IPID_UNPDATEONPROSPECT(List<admission_acknowledgement__c> triggerNew){
        id prsopect;
        string ipid;
        for(admission_acknowledgement__c adm:triggerNew){
            if(adm.IPID__c!=null && adm.Related_Prospect__c!=null){
                ipid=adm.IPID__c;
                prsopect= adm.Related_Prospect__c;
            }
        }
        list<prospect__c> proslist = new list<prospect__c>();
        proslist=[select name,id,ipid__c from prospect__c where id=:prsopect];
        
        for(prospect__c PROSPECT:proslist){
            {
             PROSPECT.IPID__c=ipid;
            }
        }
        update proslist;
        
        
    }
    
    
    //added by Nitya on 21st April 2022 to replace Process Builder in before context (Insert +Update)
    public static void updateHospitalLocationTextField(List<admission_acknowledgement__c> triggerNew){
        set<id> hospitalLocation = new set<id>();
        for (admission_acknowledgement__c adm : triggerNew){
            if (adm.alletec_hospitallocation__c != null){
                hospitalLocation.add(adm.alletec_hospitallocation__c);
            }
            //added by Nitya on 1st August 2022
            if(adm.Admission_Status__c=='EM'){
                adm.Transaction_Type__c='Emergency';
            }
        }

        Map<id, business_unit__c> admMap = new Map<id, business_unit__c>([select id, name
                                                                          from business_unit__c
                                                                          where id in:hospitalLocation]);
        if (admMap.isEmpty())
            return;
        for (admission_acknowledgement__c adm : triggerNew){
            if (admMap.containsKey(adm.alletec_hospitallocation__c))
                adm.Business_Unit_Text__c = admMap.get(adm.alletec_hospitallocation__c).name;
        }
    }

    //added by Nitya on 21st April 2022 to replace Process builder in after context (insert+update)
    public static void updateRelatedProspect(List<admission_acknowledgement__c> triggerNew){
        List<admission_acknowledgement__c> admList = [select id, related_prospect__c, alletec_hospitallocation__c, Acknowledgement_Created_Date__c, Prospect_Created_Date__c, related_prospect__r.source__c
                                                      from admission_acknowledgement__c
                                                      where id in:triggerNew];
        set<id> prosSet = new set<id>();
        for (admission_acknowledgement__c adm : admList){
            if (adm.Related_Prospect__c != null && adm.Acknowledgement_Created_Date__c == adm.Prospect_Created_Date__c && adm.related_Prospect__r.source__c == 'E Prescription'){
                prosSet.add(adm.Related_Prospect__c);
            }
        }
        Map<id, Prospect__c> prosMap = new Map<id, Prospect__c>([select id, same_day_opd__c
                                                                 from prospect__c
                                                                 where id in:prosSet]);
        for (prospect__c p : prosMap.values()){
            p.Same_Day_OPD__c = true;
        }
        update prosMap.values();
    }

    //added by Nitya on 25th April 2022 to replace process builder in after context (insert+update)
    public static void updateProspectInCaseOfEmergency(list<Admission_Acknowledgement__c> triggerNew){
        set<id> prospectSet = new set<id>();
        set<id> mecpSet = new Set<id>();
        map<id, Admission_Acknowledgement__c> admMap = new map<id, Admission_Acknowledgement__c>();
        for (Admission_Acknowledgement__c adm : triggerNew){
            if (adm.Is_Emergency__c && adm.Related_Prospect__c != null){
                prospectSet.add(adm.Related_Prospect__c);
            } else if (adm.MECP_Source__c != null){
                mecpSet.add(adm.MECP_Source__c);
                admMap.put(adm.MECP_Source__c, adm);
            }
        }
        if (!prospectSet.isEmpty()){

            list<prospect__c> prosList = [select id, admitted_through_ER__c
                                          from Prospect__c
                                          where id in:prospectSet];
            for (prospect__c p : prosList){
                p.Admitted_Through_ER__c = true;
            }
            update prosList;
        } else if (!mecpSet.isEmpty()){
            list<account> mecpList = [select id, last_bill_date__c
                                      from account
                                      where id in:mecpSet];
            for (account a : mecpList){
                if (admMap.containsKey(a.id) && admMap.get(a.id).bill_date__c != null){
                    a.Last_Bill_Date__c = admMap.get(a.id).bill_date__c.date();
                    system.debug(a.Last_Bill_Date__c);
                }
            }
            update mecpList;
        }
    }

    //Added by Nitya on 6th July 2022 to overcome late tagging

    public static void reTagOnLateTagging(set<id> admSet){
        date d = system.today();
        map<string, admission_acknowledgement__c> admMap = new Map<string, admission_acknowledgement__c>();
        for (admission_acknowledgement__c ack : [select id, Tagged_On__c, Is_Tagged_By_International_Hidden__c, SMS_Tagged__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Max_Id__c, HCF_Source__c, Tagged_Pre_Intimation__c, Date_Time_of_Admission__c
                                                 from admission_acknowledgement__c
                                                 where id in:admSet and date_time_of_admission__c!=null and max_id__c!=null]){
            admMap.put(ack.max_id__c, ack);
            if (d > ack.date_time_of_admission__c.date()){
                d = ack.date_time_of_admission__c.date();
            }
        }
        List<admission_acknowledgement__c> admListToUpdate = [select id, date_time_of_admission__c, alletec_international__c, hcf_source__c, Tagged_On__c, Is_Tagged_By_International_Hidden__c, SMS_Tagged__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Max_Id__c, Tagged_Pre_Intimation__c
                                                              from admission_acknowledgement__c where max_id__c in:admmap.keyset() and hcf_source__c = null and alletec_international__c = true and day_only(convertTimezone(date_time_of_admission__c)) >= :d];
        if (admListToUpdate.isEmpty())
            return;
        for (admission_acknowledgement__c a : admListToUpdate){
            if (admMap.get(a.max_id__c).date_time_of_admission__c.date().daysbetween(a.date_time_of_admission__c.date()) <= 90){
                a.International_status__c = admMap.get(a.max_id__c).International_status__c;
                a.Pre_Intimation_Status__c = admMap.get(a.max_id__c).Pre_Intimation_Status__c;
                a.HCF_Source__c = admMap.get(a.max_id__c).HCF_Source__c;
                a.Tagged_Pre_Intimation__c = admMap.get(a.max_id__c).Tagged_Pre_Intimation__c;
                a.Auto_tagged__c = true;
                a.SMS_Tagged__c = admMap.get(a.max_id__c).SMS_Tagged__c;
                if (a.Tagged_On__c == NULL){
                    a.Tagged_On__c = system.today();
                }
                a.Tagged_RecordId__c = admMap.get(a.max_id__c).id;
                a.Is_Tagged_By_International_Hidden__c = true;
            }
        }
        update admListToUpdate;
        List<Billing_Summary__c> billToUpdate = [select id, name__c, alletec_billDate__c, hcf_source__c, Tagged_On__c, SMS_Tagged__c, Is_Tagged_By_International_Hidden__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c
                                                 from billing_summary__c
                                                 where name__c in:admMap.keyset() and hcf_source__c = null and alletec_isinternational__c = true and day_only(convertTimezone(alletec_billdate__c)) >= :d];
        if (billToUpdate.isEmpty())
            return;
        for (billing_summary__c b : billToUpdate){
            if (admMap.get(b.name__c).date_time_of_admission__c.date().daysbetween(b.alletec_billdate__c.date()) <= 90){
                b.International_status__c = admMap.get(b.name__c).International_status__c;
                b.Pre_Intimation_Status__c = admMap.get(b.name__c).Pre_Intimation_Status__c;
                b.HCF_Source__c = admMap.get(b.name__c).HCF_Source__c;
                b.Tagged_Pre_Intimation__c = admMap.get(b.name__c).Tagged_Pre_Intimation__c;
                b.Auto_tagged__c = true;
                b.SMS_Tagged__c = admMap.get(b.name__c).SMS_Tagged__c;
                if (b.Tagged_On__c == NULL){
                    b.Tagged_On__c = system.today();
                }
                b.Tagged_RecordId__c = admMap.get(b.name__c).id;
                b.Is_Tagged_By_International_Hidden__c = true;
            }
        }
        update billToUpdate;
    }

    //Linking Prospects
    public void linkAdmissionAckWithProspects(list<Admission_Acknowledgement__c> triggerNew){
        set<String> statusSet = new set<String>();
        statusSet.addAll(label.Admission_Status_For_Prospect.split(','));

        set<String> maxIdSet = new set<String>();
        for (Admission_Acknowledgement__c adm : triggerNew){
            if (String.isNotBlank(adm.Admission_Status__c) && statusSet.contains(adm.Admission_Status__c) && adm.Max_Id__c != null)
                maxIdSet.add(adm.Max_Id__c);
        }

        list<Prospect__c> prospectToUpdate = new list<Prospect__c>();
        map<String, String> prospectIdMap = new map<String, String>();

        if (maxIdSet != null && maxIdSet.size() > 0){
            for (Prospect__c pros : [SELECT Id, Max_Id__c, Stage__c
                                     FROM Prospect__c
                                     WHERE Max_Id__c in:maxIdSet and Stage__c IN ('Admission Advised', 'Admission Confirmed by Patient', 'Discussion In Progress', 'Patient Admitted', 'Closed Lost – 90days', 'New', 'OPD Consult taken', 'Investigation Done', 'Work in Progress', 'Estimate Taken', 'Closed Won')]){
                prospectIdMap.put(pros.Max_Id__c, pros.Id);
            }

            if (prospectIdMap != null && prospectIdMap.size() > 0){
                for (Admission_Acknowledgement__c adm : triggerNew){
                    if (adm.Max_Id__c != null && prospectIdMap.containsKey(adm.Max_Id__c))
                        adm.Related_Prospect__c = prospectIdMap.get(adm.Max_Id__c);
                }
            }
        }
    }

    Public static void ConnectVisaInviteWithAdmissionAcknowledgement(List<Admission_Acknowledgement__c> AdmissionTrigger){
        Set<String> setMaxId = new Set<String>();
        List<Visa_Invite__c> listVisaInviteUpdate = new List<Visa_Invite__c>();
        for (Admission_Acknowledgement__c objAdmissionSum : AdmissionTrigger){
            if (objAdmissionSum.Max_ID__c != NULL){
                setMaxId.add(objAdmissionSum.Max_ID__c);
            }
        }
        Map<String, Id> VisaInviteMap = new Map<String, Id>();
        Map<string, Visa_Invite__c> mapBillDate = new Map<string, Visa_Invite__c>();

        if (setMaxId != NULL){
            for (Visa_Invite__c objVisaInvite : [SELECT Id, Stage__c, Max_Id__c, Patient__c, (SELECT Id, Date_Time_of_Admission__c
                                                                                              FROM Admission_Acknowledgements__r
                                                                                              where Date_Time_of_Admission__c != NULL
                                                                                              ORDER BY Date_Time_of_Admission__c DESC
                                                                                              LIMIT 1)
                                                 FROM Visa_Invite__c
                                                 Where Max_ID__c != NULL AND Patient__c != NULL AND (Stage__c = 'New' OR Stage__c = 'Converted') AND Max_ID__c = :setMaxId]){
                if (String.isNotBlank(objVisaInvite.Max_ID__c)){
                    if ((objVisaInvite.Admission_Acknowledgements__r).size() > 0){
                        mapBillDate.put(objVisaInvite.Max_Id__c, objVisaInvite);
                        system.debug('==' + mapBillDate);
                    }
                    VisaInviteMap.put(objVisaInvite.Max_ID__c, objVisaInvite.id);
                }
            }
        }
        For (Admission_Acknowledgement__c Admission : AdmissionTrigger){
            if (VisaInviteMap.containskey(Admission.Max_ID__c) && mapBillDate.containskey(Admission.Max_ID__c) && mapBillDate.get(Admission.Max_ID__c).Admission_Acknowledgements__r[0].Date_Time_of_Admission__c.date().daysBetween(Admission.Date_Time_of_Admission__c.date()) > 90){
                Visa_Invite__c visaInvite = new Visa_Invite__c();
                visaInvite.id = VisaInviteMap.get(Admission.Max_ID__c);
                visaInvite.Stage__c = 'Converted and Expired';
                listVisaInviteUpdate.add(visaInvite);
            } else if (VisaInviteMap.containskey(Admission.Max_ID__c)){
                Admission.Visa_Invite__c = VisaInviteMap.get(Admission.Max_ID__c);
                Visa_Invite__c visaInvite = new Visa_Invite__c();
                visaInvite.id = VisaInviteMap.get(Admission.Max_ID__c);
                visaInvite.Stage__c = 'Converted';
                listVisaInviteUpdate.add(visaInvite);
            }
        }
        if (listVisaInviteUpdate.size() > 0)
            Database.SaveResult[] srList = Database.Update (listVisaInviteUpdate, false);
    }

    //Roll Up Total Amount from Admission Acknowledgement to MECP Source Account
    public void rollupMethod(list<Admission_Acknowledgement__c> triggerNew){

        set<Id> mecpAccoundIds = new set<Id>();

        for (Admission_Acknowledgement__c adm : triggerNew){
            if (adm.MECP_Source__c != null){
                mecpAccoundIds.add(adm.MECP_Source__c);
            }
        }

        if (mecpAccoundIds != null && mecpAccoundIds.size() > 0){

            list<Account> accToUpdate = new list<Account>();

            if (mecpAccoundIds != NULL && mecpAccoundIds.size() > 0){
                for (AggregateResult ar : [SELECT MECP_Source__c, SUM(Total_Amount__c)totAmt, SUM(Total_Revenue__c)totRev
                                           FROM Admission_Acknowledgement__c
                                           WHERE MECP_Source__c != NULL AND MECP_Source__c IN:mecpAccoundIds
                                           GROUP BY MECP_Source__c]){
                    Account mecp = new Account();
                    mecp.Id = (Id) ar.get('MECP_Source__c');
                    mecp.Total_Admission_Amount__c = (Decimal) ar.get('totAmt');
                    mecp.Total_Revenue__c = (Decimal) ar.get('totRev');
                    accToUpdate.add(mecp);
                }
            }

            if (accToUpdate != null && accToUpdate.size() > 0)
                update accToUpdate;
        }
    }

    // Create Max@Home Lead Process
    /*--------------------------Method Updated By Kuldeep Sahu On 12 Aug 2021 to Remove Query from a Loop-------------------------------*/
    // @future
    public static void createMaxHomeLead(set<String> setOfAdmissionIds){
        List<Lead__c> listmaxAtHomeLead = new List<Lead__c>();
        List<Lead__c> UpdatelistmaxAtHomeLead = new List<Lead__c>();
        Map<String, Admission_Acknowledgement__c> admissionMap = new Map<String, Admission_Acknowledgement__c>();
        String str = '';
        Id maxHomeRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Max@Home').getRecordTypeId();

        for (Admission_Acknowledgement__c adm : [SELECT Id, Date_Time_of_Admission__c, Contact_Person_MobileNo__c, BedNo__c, Patient__c, Patient__r.Gender__c, Patient__r.firstName, Patient__r.lastName, Patient__r.salutation, Patient__r.Alternate_Email__c, Patient__r.Age__c, Contact_Person_Name__c, Doctor__c, 
                                                 IPID__c, Channel_Name__c, Max_ID__c, Patient_Name__c, alletec_speciality__c, WardNo__c, Patient__r.BillingStreet, Patient__r.BillingCity, Patient__r.BillingState, Patient__r.BillingPostalCode, Patient__r.BillingCountry, Patient__r.PersonMobilePhone, alletec_hospitallocation__c, alletec_hospitallocation__r.Name
                                                 FROM Admission_Acknowledgement__c
                                                 where Id IN:setOfAdmissionIds])
            // =:triggerNew // Commented by Navin Soni on 24-08-2021 for future method.
                {
                if (adm.Date_Time_of_Admission__c != NULL){
                    Lead__c cLead = new Lead__c();
                cLead.Admission_Acknowledgement__c = adm.id;
                cLead.RecordTypeId = maxHomeRecordTypeId;
                cLead.Admission_Date__c = Date.valueOf(adm.Date_Time_of_Admission__c);
                if (adm.BedNo__c != NULL)
                    cLead.BedNo__c = adm.BedNo__c;
                if (adm.Contact_Person_MobileNo__c != NULL)
                    cLead.Contact_Person_MobileNo__c = adm.Contact_Person_MobileNo__c;
                if (adm.Contact_Person_Name__c != NULL)
                    cLead.Contact_Person_Name__c = adm.Contact_Person_Name__c;
                if (adm.Doctor__c != NULL)
                    cLead.Doctor__c = adm.Doctor__c;
                if (adm.alletec_hospitallocation__r.Name != NULL)
                    cLead.Hospital_Location__c = adm.alletec_hospitallocation__r.Name;
                if (adm.IPID__c != NULL)
                    cLead.IPID__c = adm.IPID__c;
                if (adm.Channel_Name__c != NULL)
                    cLead.Lead_Channel__c = adm.Channel_Name__c;
                if (adm.Max_ID__c != NULL)
                    cLead.Max_ID__c = adm.Max_ID__c;
                if (adm.Patient_Name__c != NULL)
                    cLead.Patient_Name__c = adm.Patient_Name__c;
                if (adm.Patient__c != NULL)
                    cLead.Patient__c = adm.Patient__c;
                if (adm.alletec_speciality__c != NULL)
                    cLead.Speciality_Department__c = adm.alletec_speciality__c;
                if (adm.WardNo__c != NULL)
                    cLead.WardNo__c = adm.WardNo__c;
                if (adm.Patient__r.Gender__c != NULL)
                    cLead.Gender__c = adm.Patient__r.Gender__c;
                if (adm.Patient__r.FirstName != NULL)
                    cLead.First_Name__c = adm.Patient__r.FirstName;
                if (adm.Patient__r.lastName != NULL)
                    cLead.Last_Name__c = adm.Patient__r.lastName;
                if (adm.Patient__r.salutation != NULL)
                    cLead.Title__c = adm.Patient__r.salutation;
                if (adm.Patient__r.FirstName != NULL || adm.Patient__r.lastName != NULL)
                    cLead.Name = adm.Patient__r.FirstName + ' ' + adm.Patient__r.lastName;
                if (adm.Patient__r.Alternate_Email__c != NULL)
                    cLead.Email__c = adm.Patient__r.Alternate_Email__c;
                if (adm.Patient__r.PersonMobilePhone != NULL)
                    cLead.Mobile_Phone__c = adm.Patient__r.PersonMobilePhone;
                if (adm.Patient__r.Age__c != NULL)
                    cLead.Patient_Age__c = adm.Patient__r.Age__c;
                if (adm.Patient__r.BillingStreet != null)
                    str += adm.Patient__r.BillingStreet + ' ';
                if (adm.Patient__r.BillingCity != null)
                    str += adm.Patient__r.BillingCity + ' ';
                if (adm.Patient__r.BillingState != null)
                    str += adm.Patient__r.BillingState + ' ';
                if (adm.Patient__r.BillingPostalCode != null)
                    str += adm.Patient__r.BillingPostalCode + ' ';
                if (adm.Patient__r.BillingCountry != null)
                    str += adm.Patient__r.BillingCountry + ' ';
                cLead.Address_Line_2__c = str;
                cLead.Lead_Origin__c = Label.MaxAtHomeLeadOrigin;
                cLead.Patient_Type__c = Label.MaxAtHomeLeadOrigin;
                cLead.Stage__c = 'Patient Admitted';
                listmaxAtHomeLead.add(cLead);
                admissionMap.put(adm.id, adm);
            }
        }

        if (!admissionMap.isEmpty()){
            UpdatelistmaxAtHomeLead = [Select BedNo__c, WardNo__c, Admission_Acknowledgement__c
                                       FROM Lead__c
                                       WHERE Admission_Acknowledgement__c IN:admissionMap.keyset()];
            if (!UpdatelistmaxAtHomeLead.isEmpty()){
                for (lead__c lead : UpdatelistmaxAtHomeLead){
                    lead.BedNo__c = admissionMap.get(lead.Admission_Acknowledgement__c).BedNo__c;
                    lead.WardNo__c = admissionMap.get(lead.Admission_Acknowledgement__c).WardNo__c;
                }
            }
        }

        if (!test.isRunningTest())
            if (!listmaxAtHomeLead.isEmpty()){
                insert listmaxAtHomeLead;
        }
        if (!UpdatelistmaxAtHomeLead.isEmpty()){
            update UpdatelistmaxAtHomeLead;
        }
    }

    Static set<Id> setBeforeRecursivecheck = new set<Id>();
    // Added by Navin Soni on 24-08-2021 for future method.
    public static void CmpLeadAdmissionAckMaxId(set<String> setOfAdmissionIds){
        set<String> setOfMaxId = new set<String>();
        list<Admission_Acknowledgement__c> listToUpdateAdmissionAck = new list<Admission_Acknowledgement__c>();
        list<lead__c> listToUpdateLeads = new list<lead__c>();
        map<String, String> mapMaxIdWithleadId = new map<String, String>();
        //get set of maxId from Admission Acknowledgement
        // Added by Navin Soni on 24-08-2021 for future method.
        List<Admission_Acknowledgement__c> triggerNew = [SELECT ID, Max_ID__c
                                                         FROM Admission_Acknowledgement__c
                                                         WHERE ID IN:setOfAdmissionIds];

        for (Admission_Acknowledgement__c Ack : triggerNew){
            if (setBeforeRecursivecheck.contains(Ack.Id))
                continue;
            if (String.isNotBlank(Ack.Max_ID__c)){
                setBeforeRecursivecheck.add(Ack.Id);
                setOfMaxId.add(Ack.Max_ID__c);
            }
        }
        System.debug('===setOfMaxId===>>>>>' + setOfMaxId);
        //Query data from lead
        if (setOfMaxId.size() > 0){
            for (Lead__c ld : [Select Id, Max_ID__c
                               from lead__c
                               WHERE RecordType.Name IN ('CMP') AND Max_Id__c IN:setOfMaxId]){
                if (ld.Max_ID__c != Null){
                    mapMaxIdWithleadId.put(ld.Max_ID__c, ld.Id);
                }
            }
        }
        System.debug('===mapMaxIdWithleadId===>>>>>' + mapMaxIdWithleadId);
        //update lead if maxID is not Null
        if (mapMaxIdWithleadId.keySet().size() > 0){
            for (Admission_Acknowledgement__c Ack : triggerNew){
                if (mapMaxIdWithleadId.containsKey(Ack.Max_ID__c)){
                    Admission_Acknowledgement__c adm = new Admission_Acknowledgement__c();
                    adm.Id = Ack.Id;
                    adm.CMP_Lead__c = mapMaxIdWithleadId.get(Ack.Max_ID__c);
                    listToUpdateAdmissionAck.add(adm);
                }
            }
        }
        if (listToUpdateAdmissionAck.size() > 0 && listToUpdateAdmissionAck != Null)
            update listToUpdateAdmissionAck;
        if (listToUpdateLeads.size() > 0 && listToUpdateLeads != Null)
            update listToUpdateLeads;
    }

    //Update related Prospect  Stage to patient Admitted
    // Added by Navin Soni on 24-08-2021 for future method.
    @future
    public static void updateProspectStageToPateintAdmitted(set<String> setOfAdmissionIds){
        set<Id> prospectIdSet = new set<Id>();
        List<Admission_Acknowledgement__c> triggerNew = [SELECT ID, Related_Prospect__c
                                                         FROM Admission_Acknowledgement__c
                                                         WHERE ID IN:setOfAdmissionIds];
        for (Admission_Acknowledgement__c adm : triggerNew){
            if (adm.Related_Prospect__c != null)
                prospectIdSet.add(adm.Related_Prospect__c);
        }

        System.debug('prospectIdSet' + prospectIdSet);
        list<Prospect__c> prospectToUpdate = new list<Prospect__c>();

        if (prospectIdSet != null && prospectIdSet.size() > 0){
            String OPTOIPRecordtype = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('OP - IP').getRecordTypeId();
            for (Prospect__c pros : [SELECT Id, Stage__c, RecordTypeID
                                     FROM Prospect__c
                                     WHERE Id in:prospectIdSet and RecordTypeID = :OPTOIPRecordtype]){
                pros.Stage__c = 'Patient Admitted';
                prospectToUpdate.add(pros);
            }

            if (prospectToUpdate != null && prospectToUpdate.size() > 0)
                update prospectToUpdate;
        }
    }

    //To auto tag International leads and status on Admission Acknowlegement
    //added by Nitya in before Context
    public void autoTagInternational(list<Admission_acknowledgement__c> triggerNew){
        set<ID> Patientset = new set<ID>();
        Date dt;
        for (Admission_Acknowledgement__c adm : triggerNew){
            dt = Date.today();
            if (adm.Patient__c != null && adm.Date_Time_of_Admission__c != null && adm.alletec_international__c){
                Patientset.add(adm.Patient__c);
                if (dt > adm.Date_Time_of_Admission__c.date()){
                    dt = adm.Date_Time_of_Admission__c.date();
                }
            }
        }
        dt = dt - Integer.valueOf(label.Internation_Patient_AutoTag_Days);
        Map<Id, Account> patientMap = new Map<id, Account>([Select id, alletec_patientregisterationdate__c, First_OPD_IPD_Bill_Date__c, First_OPD_IPD_Bill_No__c, (SELECT Id, Tagged_On__c, Is_Tagged_By_International_Hidden__c, SMS_Tagged__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c, alletec_billdate__c, HCF_Source__c
                                                                                                                                                                   FROM Billing_Summary_Patients__r
                                                                                                                                                                   WHERE alletec_isinternational__c = true and HCF_Source__c != Null AND alletec_billdate__c >= :dt
                                                                                                                                                                   ORDER BY alletec_billdate__c DESC), (SELECT Id, Tagged_On__c, Is_Tagged_By_International_Hidden__c, SMS_Tagged__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Max_Id__c, HCF_Source__c, Tagged_Pre_Intimation__c, Date_Time_of_Admission__c
                                                                                                                                                                                                        FROM Admission_Acknowledgements3__r
                                                                                                                                                                                                        WHERE HCF_Source__c != null AND Date_Time_of_Admission__c >= :dt
                                                                                                                                                                                                        ORDER BY Date_Time_of_Admission__c desc)
                                                            From Account 
                                                            Where ID In:Patientset]);
        system.debug(patientMap);

        for (Admission_Acknowledgement__c adm : triggerNew){
            system.debug(patientMap.get(adm.Patient__c));
            // system.debug(patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r);
            //in the case of Emergency
            if (adm.Is_Emergency__c && adm.Patient__c != null && patientMap.containsKey(adm.Patient__c) && patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r.size() > 0){
                Admission_Acknowledgement__c frstAdm = patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0];
                system.debug(frstAdm);
                adm.International_Status__c = 'Pre-Intimations ER';
                adm.Pre_Intimation_Status__c = frstAdm.Pre_Intimation_Status__c;
                adm.HCF_Source__c = frstAdm.HCF_Source__c;
                adm.Tagged_Pre_Intimation__c = frstAdm.Tagged_Pre_Intimation__c;
                adm.Auto_tagged__c = true;
                adm.SMS_Tagged__c = frstAdm.SMS_Tagged__c;
                if (Adm.Tagged_On__c == NULL){
                    adm.Tagged_On__c = system.today();
                }
                adm.Tagged_RecordId__c = frstAdm.id;
                adm.Is_Tagged_By_International_Hidden__c = true;

            } else if (adm.alletec_international__c && adm.Patient__c != null && patientMap.containsKey(adm.Patient__c) && adm.Date_Time_of_Admission__c != null){
                if (patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r.size() > 0 && patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0].Date_Time_of_Admission__c.date().daysBetween(adm.Date_Time_of_Admission__c.date()) <= 90){
                    Admission_Acknowledgement__c frstAdm = patientMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0];
                    adm.International_Status__c = frstAdm.International_Status__c;
                    adm.Pre_Intimation_Status__c = frstAdm.Pre_Intimation_Status__c;
                    adm.HCF_Source__c = frstAdm.HCF_Source__c;
                    adm.Tagged_Pre_Intimation__c = frstAdm.Tagged_Pre_Intimation__c;
                    adm.Auto_tagged__c = true;
                    adm.SMS_Tagged__c = frstAdm.SMS_Tagged__c;
                    if (Adm.Tagged_On__c == NULL){
                        adm.Tagged_On__c = system.today();
                    }
                    adm.Tagged_RecordId__c = frstAdm.id;
                    adm.Is_Tagged_By_International_Hidden__c = true;
                } else if (patientMap.get(adm.Patient__c).Billing_Summary_Patients__r.size() > 0 && patientMap.containsKey(adm.Patient__c) && patientMap.get(adm.Patient__c).Billing_Summary_Patients__r[0].alletec_billdate__c.date().daysBetween(adm.Date_Time_of_Admission__c.date()) <= 90){
                    billing_Summary__c frstBill = patientMap.get(adm.Patient__c).billing_Summary_Patients__r[0];
                    adm.International_Status__c = frstBill.International_Status__c;
                    adm.Pre_Intimation_Status__c = frstBill.Pre_Intimation_Status__c;
                    adm.HCF_Source__c = frstBill.HCF_Source__c;
                    adm.Tagged_Pre_Intimation__c = frstBill.Tagged_Pre_Intimation__c;
                    adm.Auto_tagged__c = true;
                    adm.SMS_Tagged__c = frstBill.SMS_Tagged__c;
                    if (Adm.Tagged_On__c == NULL){
                        adm.Tagged_On__c = system.today();
                    }
                    adm.Tagged_RecordId__c = frstBill.id;
                    adm.Is_Tagged_By_International_Hidden__c = true;
                }
            }

        }
    }

    //------------------------------------------------Redemption Summary Insertion---------------------------------------------------------------------------------------------------------------------
    public void redemptionSummaryInsertion(list<Admission_Acknowledgement__c> triggerNew, Map<Id, Admission_Acknowledgement__c> oldMap){
        Set<id> setHCFSource = new Set<id>();
        Map<id, integer> mapHCFSourceToKeyProcedure = new map<id, integer>();
        Map<id, integer> mapHCFSourceToNormalProcedure = new map<id, integer>();
        Map<id, list<Id>> mapHCFSourceToKeyPatients = new map<id, list<Id>>();
        Map<String, Redemption_Summary_Points__mdt> mapToRedemtioSummaryPointsMetaData = new Map<String, Redemption_Summary_Points__mdt>();
        List<Redemption_Summary__c> listRedemptionSummary = new List<Redemption_Summary__c>();
        List<Account> listAccount = new List<Account>();
        List<Account> listAccountToUpdate = new List<Account>();
        Map<id, String> mapHCFSourceToEmailId = new map<id, String>();

        Map<Integer, String> monthNameMap = new Map<Integer, String>{ 1 => 'January', 2 => 'February', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December' };

        for (Redemption_Summary_Points__mdt rsp : [SELECT Label, No_of_Patient_10__c, No_of_Patient_0_5__c, No_of_Patient_6_10__c
                                                   FROM Redemption_Summary_Points__mdt])
            mapToRedemtioSummaryPointsMetaData.put(rsp.Label, rsp);
        for (Admission_Acknowledgement__c admsn : triggerNew){
            if (admsn.HCF_Source__c != NULL && admsn.Patient__c != NULL && admsn.Procedure__c != NULL && admsn.Procedure__c != oldMap.get(admsn.id).Procedure__c){
                setHCFSource.add(admsn.HCF_Source__c);
                if (mapHCFSourceToKeyPatients.containsKey(admsn.HCF_Source__c)){
                    list<id> listPatientId = mapHCFSourceToKeyPatients.get(admsn.HCF_Source__c);
                    if (!listPatientId.contains(admsn.Patient__c)){
                        if (admsn.Procedure__c == 'Normal'){
                            Integer normalCount = 1;
                            if (mapHCFSourceToNormalProcedure.containsKey(admsn.HCF_Source__c))
                                normalCount = mapHCFSourceToNormalProcedure.get(admsn.HCF_Source__c) + normalCount;
                            mapHCFSourceToNormalProcedure.put(admsn.HCF_Source__c, normalCount);
                        } else{
                            Integer keyCount = 1;
                            if (mapHCFSourceToKeyProcedure.containsKey(admsn.HCF_Source__c))
                                keyCount = mapHCFSourceToKeyProcedure.get(admsn.HCF_Source__c) + keyCount;
                            mapHCFSourceToKeyProcedure.put(admsn.HCF_Source__c, keyCount);
                        }
                    }
                    listPatientId.add(admsn.Patient__c);
                    mapHCFSourceToKeyPatients.put(admsn.HCF_Source__c, listPatientId);
                } else{
                    list<id> listPatientId = new list<id>();
                    listPatientId.add(admsn.Patient__c);
                    mapHCFSourceToKeyPatients.put(admsn.HCF_Source__c, listPatientId);
                    if (admsn.Procedure__c == 'Normal'){
                        Integer normalCount = 1;
                        if (mapHCFSourceToNormalProcedure.containsKey(admsn.HCF_Source__c))
                            normalCount = mapHCFSourceToNormalProcedure.get(admsn.HCF_Source__c) + normalCount;
                        mapHCFSourceToNormalProcedure.put(admsn.HCF_Source__c, normalCount);
                    } else{
                        Integer keyCount = 1;
                        if (mapHCFSourceToKeyProcedure.containsKey(admsn.HCF_Source__c))
                            keyCount = mapHCFSourceToKeyProcedure.get(admsn.HCF_Source__c) + keyCount;
                        mapHCFSourceToKeyProcedure.put(admsn.HCF_Source__c, keyCount);
                    }
                }
            }
        }

        for (Account acc : [SELECT Id, Max_Connect_Account__c, E_mail__c
                            FROM Account
                            WHERE Id IN:setHCFSource AND E_mail__c != NULL]){
            mapHCFSourceToEmailId.put(acc.Id, acc.E_mail__c);
            listAccount.add(acc);
        }

        for (Id hcfSource : setHCFSource){
            Redemption_Summary__c redSummary = new Redemption_Summary__c();
            redSummary.Points_Accured__c = 0;
            if (mapHCFSourceToKeyProcedure.containsKey(hcfSource)){
                Integer count = mapHCFSourceToKeyProcedure.get(hcfSource);
                if (count >= 0 && count <= 5)
                    redSummary.Points_Accured__c = count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('Key').No_of_Patient_0_5__c);
                else if (count >= 6 && count <= 10)
                    redSummary.Points_Accured__c = count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('key').No_of_Patient_6_10__c);
                else if (count >= 11)
                    redSummary.Points_Accured__c = count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('key').No_of_Patient_10__c);
            }

            if (mapHCFSourceToNormalProcedure.containskey(hcfSource)){
                Integer count = mapHCFSourceToNormalProcedure.get(hcfSource);
                if (count >= 0 && count <= 5)
                    redSummary.Points_Accured__c = redSummary.Points_Accured__c + count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('Normal').No_of_Patient_0_5__c);
                else if (count >= 6 && count <= 10)
                    redSummary.Points_Accured__c = redSummary.Points_Accured__c + count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('Normal').No_of_Patient_6_10__c);
                else if (count >= 11)
                    redSummary.Points_Accured__c = redSummary.Points_Accured__c + count * Integer.valueOf(mapToRedemtioSummaryPointsMetaData.get('Normal').No_of_Patient_10__c);
            }

            if (mapHCFSourceToEmailId != NULL && mapHCFSourceToEmailId.keySet().size() > 0){
                if (mapHCFSourceToEmailId.containsKey(hcfSource))
                    redSummary.Account_Email__c = mapHCFSourceToEmailId.get(hcfSource);
            }
            redSummary.Month__c = monthNameMap.get(Date.Today().Month());
            redSummary.Year__c = String.valueOf(Date.Today().Year());
            redSummary.Name_of_Partner__c = hcfSource;
            listRedemptionSummary.add(redSummary);
        }

        if (listRedemptionSummary != NULL && listRedemptionSummary.size() > 0)
            insert listRedemptionSummary;
        for (Account acc : listAccount){
            Account account = new Account();
            account.Id = acc.Id;
            account.Max_Connect_Account__c = true;
            listAccountToUpdate.add(account) ;
        }

        if (listAccountToUpdate != NULL && listAccountToUpdate.size() > 0)
            update listAccountToUpdate;
    }

    //--------------------------------------------------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------  Channel Massaging ---------------------------------------------------------------
    // for adminssion ack
    public Static set<Id> setRecursiveCheckBefore = new set<Id>();
    public Static void checkChannelMassaging(){

        try{

            map<Id, Admission_Acknowledgement__c> mapValidAdminAck = new map<Id, Admission_Acknowledgement__c>();
            map<Id, Account> mapAccountDetails = new map<Id, Account>();

            for (Admission_Acknowledgement__c objAdminAck : (list<Admission_Acknowledgement__c>)trigger.new ){

                if (setRecursiveCheckBefore.contains(objAdminAck.Id))
                    continue;
                //recursion check

                if (objAdminAck.Channel_Name__c == 'PSU' || objAdminAck.Channel_Name__c == 'Corporate'){

                    objAdminAck.R_Channel__c = objAdminAck.Channel_Name__c;
                    continue;
                }

                // if( trigger.isUpdate &&  ( (Map< Id, Admission_Acknowledgement__c > ) trigger.oldMap ).get( objAdminAck.Id ).MECP_Source__c == objAdminAck.MECP_Source__c ) continue; //if MECP_Source__c is changed only

                if (String.isNotBlank(objAdminAck.Patient__c)){
                    mapAccountDetails.put(objAdminAck.Patient__c, Null);
                }

                setRecursiveCheckBefore.add(objAdminAck.id);
                mapValidAdminAck.put(objAdminAck.Id, objAdminAck);
            }
            //end of trigger new loop

            system.debug('mapValidAdminAck---> ' + mapValidAdminAck);
            if (mapValidAdminAck.size() > 0){

                //this will re-initialize the map with only those account who's Nationality( address2_country__c ) is not Indian and Id in Keyset
                mapAccountDetails = new map<Id, Account>([SELECT Id, address2_country__c
                                                          FROM Account
                                                          WHERE address2_country__c <> NULL AND Id In:mapAccountDetails.keyset()]);

                system.debug('mapAccountDetails-----> ' + mapAccountDetails);

                for (Admission_Acknowledgement__c objAdminAck : mapValidAdminAck.values()){

                    //either patient will be non indian or should be international or markup should be is applied
                    if ((mapAccountDetails.containsKey(objAdminAck.Patient__c) && !mapAccountDetails.get(objAdminAck.Patient__c).address2_country__c.equalsIgnoreCase('Indian') && !mapAccountDetails.get(objAdminAck.Patient__c).address2_country__c.equalsIgnoreCase('149')) || objAdminAck.alletec_international__c || (String.isNotBlank(objAdminAck.pcl_markuptype__c) && objAdminAck.pcl_markuptype__c.equalsIgnoreCase('is applied'))){

                        if (mapAccountDetails.containsKey(objAdminAck.Patient__c)){
                            system.debug('mapAccountDetails.get( objAdminAck.Patient__c ).address2_country__c' + mapAccountDetails.get(objAdminAck.Patient__c).address2_country__c);
                        }

                        system.debug('Intrernational got true ');
                        objAdminAck.alletec_international__c = true;  //incase if international is not true

                        objAdminAck.R_Channel__c = 'International';
                        Id recordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
                        if (String.isNotBlank(recordTypeId))
                            objAdminAck.RecordTypeId = recordTypeId;
                    } else{


                        if (objAdminAck.Channel_Name__c == 'Cash'){

                            if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                objAdminAck.R_Channel__c = 'MECP';
                            else
                                objAdminAck.R_Channel__c = 'Walk-In';
                        } else if ((objAdminAck.Channel_Name__c == 'Walk-In' || objAdminAck.Channel_Name__c == 'TPA')){

                            if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                objAdminAck.R_Channel__c = 'MECP';
                            else
                                objAdminAck.R_Channel__c = objAdminAck.Channel_Name__c;
                        } else{

                            objAdminAck.R_Channel__c = objAdminAck.Channel_Name__c;
                        }

                    }
                }
                //end of Admin Ack Loop

            }
            //end of listValidAdminAck size check

            //-----------------------------------------------------------------  Clearing Heap  -----------------------------------------------------------------------------------------
            //    mapValidAdminAck = null;
            //    mapAccountDetails = null;

        } Catch (Exception objExcep){
            system.debug(' error on massaging --> ' + objExcep.getMessage() + 'Line --- > ' + objExcep.getLineNumber());
        }
    }

    //end of checkChannelMassaging
    public Static set<Id> setRecursiveCheckAfter = new set<Id>();
    //if mecp source if later updated then its bill sum also get update
    public Static void updateChannelMassagingForBillSum(){

        try{
            set<Id> setValidAdminAckid = new set<Id>();
            list<Billing_Summary__c> listBillSum = new list<Billing_Summary__c>();
            Set<String> setChannelName = new Set<String>{ 'PSU', 'Corporate' };

            for (Admission_Acknowledgement__c objAdminAck : (List<Admission_Acknowledgement__c>)trigger.new ){

                if (setRecursiveCheckAfter.contains(objAdminAck.id))
                    continue;
                //  if( trigger.isUpdate &&  ( (Map< Id, Admission_Acknowledgement__c > ) trigger.oldMap ).get( objAdminAck.Id ).MECP_Source__c == objAdminAck.MECP_Source__c ) continue; //if MECP_Source__c is changed only

                if (String.isNotBlank(objAdminAck.R_Channel__c)){

                    setRecursiveCheckAfter.add(objAdminAck.Id);
                    setValidAdminAckid.add(objAdminAck.id);
                }

            }
            //end of trigger.new

            system.debug('setValidAdminAckid ---> ' + setValidAdminAckid);
            if (setValidAdminAckid.size() > 0){

                for (Admission_Acknowledgement__c objAdminAck : [SELECT Id, MECP_Source__c, pcl_markuptype__c, Patient__r.address2_country__c, (SELECT Id, alletec_channeltype__c, R_Channel__c, alletec_isinternational__c
                                                                                                                                                FROM Billing_Summary__r)//WHERE R_Channel__c <> NULL AND alletec_channeltype__c NOT IN : setChannelName
                                                                 FROM Admission_Acknowledgement__c
                                                                 WHERE Id IN:setValidAdminAckid]){

                    if (objAdminAck.Billing_Summary__r.size() == 0)
                        continue;
                    for (Billing_Summary__c objBillSUm : objAdminAck.Billing_Summary__r){

                        system.debug('objBillSUm --> ' + objBillSUm);
                        system.debug('objAdminAck.Patient__r.address2_country__c --> ' + objAdminAck.Patient__r.address2_country__c);

                        if (String.isNotBlank(objBillSum.alletec_channeltype__c) && objBillSum.alletec_channeltype__c.equalsIgnoreCase('PSU')){
                            objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                        } else if (String.isNotBlank(objBillSum.alletec_channeltype__c) && objBillSum.alletec_channeltype__c.equalsIgnoreCase('Corporate')){
                            objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                        } else if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAdminAck.Patient__r.address2_country__c) && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('Indian') && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('149')) || (String.isNotBlank(objAdminAck.pcl_markuptype__c) && objAdminAck.pcl_markuptype__c.equalsIgnoreCase('is applied'))){
                            system.debug('Intrernational got true ');
                            objBillSum.alletec_isinternational__c = true;
                            objBillSum.R_Channel__c = 'International';

                        } else{

                            if (objBillSum.alletec_channeltype__c == 'Cash'){

                                if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                    objBillSum.R_Channel__c = 'MECP';
                                else
                                    objBillSum.R_Channel__c = 'Walk-In';
                            } else if ((objBillSum.alletec_channeltype__c == 'Walk-In' || objBillSum.alletec_channeltype__c == 'TPA')){

                                if (String.isNotBlank(objAdminAck.MECP_Source__c))
                                    objBillSum.R_Channel__c = 'MECP';
                                else
                                    objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                            } else{

                                objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                            }
                        }


                        listBillSum.add(objBillSum);
                    }
                    // end of Bill Sum Loop
                }
                //end of admin ack loop
            }
            //end of valid Admin Ack

            if (listBillSum.size() > 0){

                try{

                    update listBillSum;
                } Catch (Exception objException){
                    system.debug(' error  ---> ' + objException.getMessage() + '  Line No ---> ' + objException.getLineNumber());
                }

            }

            //--------------------------------------------------------------------  Clearing Heap  -------------------------------------------------------------------
            // setValidAdminAckid = null;
            //listBillSum = null;
        } Catch (Exception objExcep){
            system.debug(' error on massaging --> ' + objExcep.getMessage() + 'Line --- > ' + objExcep.getLineNumber());
        }
    }

    //end of updateChannelMassagingForBillSum()
    //-------------------------------------------------------------  END Channel Massaging   -----------------------------------------------------------
    //AutoTag Admission Acknowledgement to MECP Source based on Specialty
    //AutoTag international Admission Acknowledgements based on number of days from last visit
    /*public void autoTagPatients(list<Admission_Acknowledgement__c> triggerNew,list<Admission_Acknowledgement__c> triggerold){
     map<id,Admission_Acknowledgement__c> oldmap;
     if(triggerold!=null)
     oldmap = new map<id,Admission_Acknowledgement__c>(triggerold);
     if(AvoidRecursion.isFirstRun()){
     //Getting preferred specialities for Auto Tagging
     map<Integer,Integer> specialityCodeMap = new map<Integer,Integer>();
     for(AutoTagging_Specialities__mdt admMdt : [SELECT Speciality_Code__c,No_of_Days__c FROM AutoTagging_Specialities__mdt]){
     if(String.isNotBlank(admMdt.Speciality_Code__c))
     specialityCodeMap.put(Integer.valueOf(admMdt.Speciality_Code__c),Integer.valueOf(admMdt.No_of_Days__c));
     }

     map<Id,Integer> specialityIdMap = new map<Id,Integer>();
     if(specialityCodeMap!=null && specialityCodeMap.size()>0){
     for(Department__c depart : [SELECT Id, alletec_id__c FROM Department__c WHERE alletec_id__c in: specialityCodeMap.keySet()]){
     specialityIdMap.put(depart.Id,specialityCodeMap.get(Integer.valueOf(depart.alletec_id__c)));
     }
     }


     set<Id> patientIds = new set<Id>();
     set<String> maxIds = new set<String>();
     set<Id> admAckIds = new set<Id>();
     Id domRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
     Id intlRecordTypeId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();

     for(Admission_Acknowledgement__c adm : triggerNew){
     if(adm.recordtypeId==intlRecordTypeId || (adm.recordtypeId==domRecordTypeId && adm.alletec_speciality__c!=null && specialityIdMap.containsKey(adm.alletec_speciality__c))){
     if(adm.Patient__c!=null)
     patientIds.add(adm.Patient__c);
     else if(adm.Max_Id__c!=null)
     maxIds.add(adm.Max_Id__c);

     admAckIds.add(adm.Id);
     }
     }


     if((patientIds!=null && patientIds.size()>0) || (maxIds!=null && maxIds.size()>0)){

     map<String,Id> maxIdMecpMap = new map<String,Id>();
     map<String,Id> patIdMecpMap = new map<String,Id>();
     map<String,Id> taggedIntimationMap = new map<String,Id>();
     map<string,string> billingSummaryHcfSourceMap = new map<string,string>();
     map<string,Admission_Acknowledgement__c> ackStatusMap = new map<string,Admission_Acknowledgement__c>();
     map<string,Billing_Summary__c> billingStatusMap = new map<string,Billing_Summary__c>();


     //Loop through patients to find the recent admission acknowledgements
     for(Account acc : [SELECT Id,Max_Id__c,(SELECT Id,Tagged_Pre_Intimation__c,MECP_Source__c,International_Status__c,Pre_Intimation_Status__c,HCF_Source__c,Date_Time_of_Admission__c,alletec_speciality__c FROM
     Admission_Acknowledgements3__r WHERE (MECP_Source__c!=null or HCF_Source__c!=null) ORDER BY Date_Time_of_Admission__c DESC LIMIT 5) ,
     (SELECT Id,name__c,HCF_Source__c,alletec_billdate__c,International_Status__c,Pre_Intimation_Status__c,Tagged_Pre_Intimation__c FROM Billing_Summary_Patients__r Where HCF_Source__c!=null ORDER BY alletec_billdate__c ASC)
     FROM Account WHERE Recordtype.Name=:'Patient' and (Id in:patientIds OR Max_Id__c in:maxIds)]){

     //Loop through recent five admission acknowledgements
     if(acc.Admission_Acknowledgements3__r!=null && acc.Admission_Acknowledgements3__r.size()>0){
     ackStatusMap.put(acc.id,acc.Admission_Acknowledgements3__r[0]);
     for(Admission_Acknowledgement__c adm : acc.Admission_Acknowledgements3__r){


     //For Domestic
     if(adm.MECP_Source__c!=null){
     if(adm.alletec_speciality__c!=null && specialityIdMap.containsKey(adm.alletec_speciality__c)){
     if(adm.Date_Time_of_Admission__c!=null){
     Date startDt = system.today() - specialityIdMap.get(adm.alletec_speciality__c);
     Date endDt = system.today();

     //Compare the dates if lies within the specified days.
     if(adm.Date_Time_of_Admission__c >= startDt && adm.Date_Time_of_Admission__c <= endDt){
     maxIdMecpMap.put(acc.Max_Id__c,adm.MECP_Source__c);
     patIdMecpMap.put(acc.Id,adm.MECP_Source__c);
     }

     }
     }
     }

     //For international
     if(adm.HCF_Source__c!=null){
     if(adm.Date_Time_of_Admission__c!=null){
     Date startDt = system.today() - Integer.valueOf(label.Internation_Patient_AutoTag_Days);
     Date endDt = system.today();
     if(adm.Date_Time_of_Admission__c >= startDt && adm.Date_Time_of_Admission__c <= endDt){
     system.debug('---maxIdMecpMap.containsKey(admAck.Max_Id__c)->');
     maxIdMecpMap.put(acc.Max_Id__c,adm.HCF_Source__c);
     patIdMecpMap.put(acc.Id,adm.HCF_Source__c);
     if(adm.Tagged_Pre_Intimation__c!=null)
     taggedIntimationMap.put(acc.Max_Id__c,adm.Tagged_Pre_Intimation__c);
     }
     }
     }
     }
     }


     //Tag with billing summary
     if(acc.Billing_Summary_Patients__r!=null && acc.Billing_Summary_Patients__r.size()>0){
     billingStatusMap.put(acc.id,acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1]);
     if(acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].alletec_billdate__c!=null){
     String tempMaxId = acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].name__c;
     String tempHCF = acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].HCF_Source__c;
     Date tempDt = Date.valueOf(acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].alletec_billdate__c);
     Date startDt = system.today() - Integer.valueOf(label.Internation_Patient_AutoTag_Days);
     Date endDt = system.today();

     if(tempDt >= startDt && tempDt <= endDt)
     billingSummaryHcfSourceMap.put(tempMaxId,tempHCF);
     if(acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].Tagged_Pre_Intimation__c!=null)
     taggedIntimationMap.put(tempMaxId,acc.Billing_Summary_Patients__r[acc.Billing_Summary_Patients__r.size()-1].Tagged_Pre_Intimation__c);
     }
     }
     }


     list<Admission_Acknowledgement__c> ackToUpdate = new list<Admission_Acknowledgement__c>();
     //List<Account> listDirectAccount= [select Id,Name from Account where Name='Direct' AND Recordtype.Name='International HCF Account'];
     if((maxIdMecpMap!=null && maxIdMecpMap.size()>0) || (patIdMecpMap!=null && patIdMecpMap.size()>0) || billingSummaryHcfSourceMap!=null && billingSummaryHcfSourceMap.size()>0){
     for(Admission_Acknowledgement__c admAck : [SELECT Id,Auto_Tagged__c,RecordtypeId,Max_Id__c,Patient__c,MECP_Source__c,
     Channel_Name__c, Pre_Intimation_Status__c, Pre__c, Tagged_On__c,Tagged_Pre_Intimation__c,
     HCF_Source__c,Is_Tagged_By_International_Hidden__c,SMS_Tagged__c,
     Is_Emergency__c,International_Status__c
     FROM Admission_Acknowledgement__c
     WHERE Id in: admAckIds]){

     Boolean isAutoTaggedDomestic = false;
     Boolean isAutoTaggedInternational = false;
     //Domestic Patients
     if(admAck.recordtypeId==domRecordTypeId){
     if(admAck.Max_Id__c!=null && maxIdMecpMap.containsKey(admAck.Max_Id__c)){
     admAck.MECP_Source__c = maxIdMecpMap.get(admAck.Max_Id__c);
     isAutoTaggedDomestic = true;
     }
     else if(admAck.Patient__c!=null && patIdMecpMap.containsKey(admAck.Patient__c)){
     admAck.MECP_Source__c = patIdMecpMap.get(admAck.Patient__c);
     isAutoTaggedDomestic = true;
     }

     if(isAutoTaggedDomestic){
     admAck.Auto_Tagged__c = true;
     admAck.Channel_Name__c = label.MECP_Channel;
     admAck.Pre_Intimation_Status__c =label.Pre_Intimation_Status;
     admAck.Pre__c = true;
     if(admAck.HCF_Source__c !=NULL && (!trigger.IsUpdate || admAck.HCF_Source__c!=oldmap.get(admAck.id).HCF_Source__c))
     admAck.Tagged_On__c = system.today();
     admAck.MECP_Status__c = label.MECP_Channel;
     }
     ackToUpdate.add(admAck);
     }

     //International Patients
     if(test.isRunningTest())
     admAck.recordtypeId=intlRecordTypeId;
     if(admAck.recordtypeId==intlRecordTypeId){
     //system.debug('---maxIdMecpMap.containsKey(admAck.Max_Id__c)->'+maxIdMecpMap.containsKey(admAck.Max_Id__c));
     if(admAck.Max_Id__c!=null && maxIdMecpMap.containsKey(admAck.Max_Id__c)){
     admAck.HCF_Source__c = maxIdMecpMap.get(admAck.Max_Id__c);
     isAutoTaggedInternational = true;
     }
     else if(admAck.Patient__c!=null && patIdMecpMap.containsKey(admAck.Patient__c)){
     admAck.HCF_Source__c = patIdMecpMap.get(admAck.Patient__c);
     isAutoTaggedInternational = true;
     }else if(admAck.Max_Id__c!=null && billingSummaryHcfSourceMap.containsKey(admAck.Max_Id__c)){
     admAck.HCF_Source__c = billingSummaryHcfSourceMap.get(admAck.Max_Id__c);
     isAutoTaggedInternational = true;
     }

     if(isAutoTaggedInternational){
     admAck.Auto_Tagged__c = true;
     admAck.Is_Tagged_By_International_Hidden__c = true;
     admAck.SMS_Tagged__c = true;
     // if(listDirectAccount!=NULL && listDirectAccount.size()>0){
     if(admAck.HCF_Source__c==label.DirectAccountTagging){
     admAck.Pre_Intimation_Status__c='';
     admAck.International_Status__c = 'Direct';
     }
     // }
     else{
     if(ackStatusMap.containsKey(admAck.Patient__c) && ackStatusMap.get(admAck.Patient__c) !=NULL){
     admAck.Pre_Intimation_Status__c =ackStatusMap.get(admAck.Patient__c).Pre_Intimation_Status__c; //label.Pre_Intimation_Status;
     }
     else if(billingStatusMap.containsKey(admAck.Patient__c) && billingStatusMap.get(admAck.Patient__c) !=NULL){
     admAck.Pre_Intimation_Status__c=billingStatusMap.get(admAck.Patient__c).Pre_Intimation_Status__c;
     }
     else{
     admAck.Pre_Intimation_Status__c =label.Pre_Intimation_Status;
     }

     }


     // In Case of ER

     if(admAck.Is_Emergency__c){
     admAck.International_Status__c = 'Pre-Intimations ER';
     }
     else{
     // admAck.International_Status__c = 'Pre-Intimations';
     if(ackStatusMap.containsKey(admAck.Patient__c) && ackStatusMap.get(admAck.Patient__c) !=NULL){
     admAck.International_Status__c =ackStatusMap.get(admAck.Patient__c).International_Status__c; //label.Pre_Intimation_Status;
     }
     else if(billingStatusMap.containsKey(admAck.Patient__c) && billingStatusMap.get(admAck.Patient__c) !=NULL){
     admAck.International_Status__c=billingStatusMap.get(admAck.Patient__c).International_Status__c;
     }
     else{
     admAck.International_Status__c = 'Pre-Intimations';
     }
     }

     if(admAck.HCF_Source__c !=NULL && (!trigger.IsUpdate || admAck.HCF_Source__c!=oldmap.get(admAck.id).HCF_Source__c))
     admAck.Tagged_On__c = system.today();
     if(admAck.Max_Id__c!=null && taggedIntimationMap.containsKey(admAck.Max_Id__c))
     admAck.Tagged_Pre_Intimation__c = taggedIntimationMap.get(admAck.Max_Id__c);

     }
     ackToUpdate.add(admAck);
     }
     }

     if(ackToUpdate!=null && ackToUpdate.size()>0)
     update ackToUpdate;

     }
     }
     }
     } */
}