/* LAst Modified by: Nitya (IRT)
* Purpose: Trigger on Billing Summary Objects
*/
@suppressWarnings('PMD')public class BillingSummaryTriggerHelper{
    Static Set<Id> setBeforeRecursive = new Set<Id>();
    Static Set<Id> processedSet = new Set<Id>();
    //added by Nitya on 14th April 2022 to replace workflow
    public static void updateHospitalLocation(list<billing_summary__c> triggerNew, set<id> bSet){
        Map<id, business_unit__c> hospitalLocationMap = new Map<id, business_unit__c>([select id, name
                                                                                       from business_unit__c
                                                                                       where id in:bSet]);
        system.debug(hospitalLocationMap);
        for (billing_summary__c bs : triggerNew){
            if (hospitalLocationMap.containsKey(bs.alletec_hospitallocation__c))
                bs.Hospital_Location__c = hospitalLocationMap.get(bs.alletec_hospitallocation__c).name;
        }
    }
    
    //added by Nitya on 19th April 2022 to replace workflow
    public static void transactionBillNoField(list<billing_summary__c> triggerNew){
        for (billing_summary__c bs : triggerNew){
            bs.TransactionBillNo__c = bs.invoicenumber__c + bs.alletec_transactiontype__c;
        }
    }
    //TPA Logic added by Shivam
    public static void ProspectLogic(list<billing_summary__c> triggerNew){
        list<billing_summary__c> billinglist = new list<billing_summary__c>([Select name,id,Corporate_TPA__c ,Corporate_TPA_Other__c ,TPA_Type__c from billing_summary__c where id=:triggerNew]);
        system.debug(billinglist);
        if(billinglist.size()>0){
        for(billing_summary__c bill:billinglist){
            if(bill.Corporate_TPA__c==null && bill.Corporate_TPA_Other__c==null){
                bill.TPA_Type__c='Retail TPA';
            }
            else{
                bill.TPA_Type__c='Corporate TPA';
         
            }
            system.debug('bill.TPA_Type__c'+bill.TPA_Type__c);
        }
        }
        update billinglist;
    }
    
    
    
    
    
    
  
    //added by nitya on 20th April 2022
    public static void updateBillDateOnAdmAck(list<billing_summary__c> triggerNew, set<id> admSet){
        
        map<id, admission_acknowledgement__c> admMap = new map<id, admission_acknowledgement__c>([select id, bill_date__c
                                                                                                  from admission_acknowledgement__c
                                                                                                  where id in:admSet]);
        for (billing_summary__c bs : triggerNew){
            admMap.get(bs.Admission_Acknowledgement__c).bill_date__c = bs.alletec_billdate__c;
        }
        update admMap.values();
    }
    
    //added by Nitya on 26th April 2022 to populate first OPD/IPD bill date and bill number on Account on creation/updation of billing summary
    public static void updateFirstOpdIpdDate(List<billing_summary__c> triggerNew){
        map<id, billing_summary__c> bMap = new map<id, billing_summary__c>();
        date d = system.today();
        for (billing_summary__c bs : triggerNew){
            if (bs.name__c != null && bs.alletec_billdate__c != null && bs.Patient__c != null && bs.alletec_isinternational__c){
                bMap.put(bs.Patient__c, bs);
                if (d > bs.alletec_billdate__c)
                    d = bs.alletec_billdate__c.date();
            }
        }
        d = d - 90;
        // system.debug(d);
        map<id, Account> accMap = new map<id, account>([select id, first_opd_ipd_bill_date__c, first_opd_ipd_bill_no__c, (Select id, alletec_billdate__c, invoiceNumber__c
                                                                                                                          from Billing_Summary_Patients__r
                                                                                                                          where alletec_isinternational__c = true and alletec_billdate__c != null and alletec_billdate__c >= :d
                                                                                                                          ORDER BY alletec_billdate__c asc)
                                                        from account 
                                                        where id in:bMap.keySet()]);
        if (accMap.isEmpty())
            return;
        for (billing_summary__c bs : bMap.values()){
            if (accMap.get(bs.Patient__c).Billing_Summary_Patients__r.size() > 0 && accMap.get(bs.Patient__c).Billing_Summary_Patients__r[0].alletec_billdate__c.date().daysbetween(bs.alletec_billdate__c.date()) <= 90){
                Billing_Summary__c frstbill = accMap.get(bs.Patient__c).Billing_Summary_Patients__r[0];
                accMap.get(bs.Patient__c).first_opd_ipd_bill_date__c = frstbill.alletec_billdate__c;
                accMap.get(bs.Patient__c).first_opd_ipd_bill_no__c = frstbill.invoicenumber__c;
            }
        }
        update accMap.values();
        
        //iterate over triggerNew and for each related patient- find the oldest billing summary record and update map.keyset()
    }
    //added by Shivam on 8th August 2022 
    //This class is used to check if any appointment exists and then tag it on Billing summary from AppointmentId custom field
  /*public static void AppointBilling(List<Billing_Summary__c>BillingList){
        string recordid;
        id Nameid;
        System.debug(BillingList);
        if(BillingList.size()>0){
            
            for(Billing_Summary__c bill:BillingList){
                recordid=bill.AppointmentID__c;
               
            }
         
        }

        list<Appointment__c> Appointlist=new list<Appointment__c> ();
        Appointlist=[Select Name,id, Appointment_ID__c  from Appointment__c where Appointment_ID__c=:recordid limit 99999];
        System.debug('Appointlist'+Appointlist);
        for(Appointment__c app:Appointlist){
            Nameid=app.id;
            system.debug(Nameid);
           
        }

        list<Billing_Summary__c>bill2=new list<Billing_Summary__c>();
        for(Billing_Summary__c bill:BillingList){
          bill.Digital_Appointment__c=Nameid;
            system.debug( bill.Digital_Appointment__c);
}
        update bill2; 
       
       
}*/
    //added by Nitya on 15th June 2022
    //to link campaign code management with billing Summary
    public static void linkCampaignWithBilling(List<billing_summary__c> triggerNew){
        Set<String> campCode = new Set<String>();
        for (billing_summary__c bs : triggerNew){
            if (bs.Campaign_Code__c != null){
                campCode.add(bs.Campaign_Code__c);
            }
        }
        if (campCode.isEmpty())
            return;
        Map<String, campaign_code_management__c> campMap = new Map<String, campaign_code_management__c>();
        List<campaign_code_management__c> campList = [select id, campaign_code__c, start_date__c, end_date__c
                                                      from campaign_code_management__c
                                                      where campaign_code__c in:campCode];
        for (campaign_code_management__c c : campList){
            campMap.put(c.campaign_code__c, c);
        }
        if (campMap.isEmpty())
            return;
        for (billing_summary__c bs : triggerNew){
            if (bs.Campaign_Code__c != null && campMap.containsKey(bs.Campaign_Code__c) && campMap.get(bs.campaign_code__c).start_date__c <= system.today() && campMap.get(bs.campaign_code__c).end_date__c >= system.today()){
                bs.campaign_code_management__c = campMap.get(bs.Campaign_Code__c).id;
            }
        }
    }
    
    //added by Nitya on 22/02/2022 to run in before context
    //Method to auto tag International Leads with OP-Transactions records
    public static void autoTagInternationalLeads(List<Billing_Summary__c> triggerNew){
        set<id> accSet = new set<id>();
        Date d = Date.today();
        //  system.debug(triggerNew);
        for (billing_summary__c bs : triggerNew){
            if (bs.alletec_isinternational__c && bs.Patient__c != null){
                accSet.add(bs.Patient__c);
                if (bs.alletec_billdate__c != null && d > bs.alletec_billdate__c.date()){
                    d = bs.alletec_billdate__c.date();
                }
            }
        }
        //  system.debug(d);
        d = d - Integer.valueOf(label.Internation_Patient_AutoTag_Days);
        //  system.debug(d);
        Map<Id, Account> accMap = new Map<id, Account>([Select id, alletec_patientregisterationdate__c, First_OPD_IPD_Bill_Date__c, First_OPD_IPD_Bill_No__c, (SELECT Id, Tagged_On__c, SMS_Tagged__c, Is_Tagged_By_International_Hidden__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c, alletec_billdate__c, HCF_Source__c
                                                                                                                                                               FROM Billing_Summary_Patients__r
                                                                                                                                                               WHERE alletec_isinternational__c = true and HCF_Source__c != Null AND alletec_billdate__c >= :d
                                                                                                                                                               ORDER BY alletec_billdate__c Desc), (SELECT Id, Tagged_On__c, Is_Tagged_By_International_Hidden__c, SMS_Tagged__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Max_Id__c, HCF_Source__c, Tagged_Pre_Intimation__c, Date_Time_of_Admission__c, alletec_international__c
                                                                                                                                                                                                    FROM Admission_Acknowledgements3__r
                                                                                                                                                                                                    WHERE HCF_Source__c != null AND Date_Time_of_Admission__c >= :d and alletec_international__c = true
                                                                                                                                                                                                    ORDER BY Date_Time_of_Admission__c)
                                                        From Account 
                                                        Where ID In:accSet]);
        //  system.debug(accMap);
        //  system.debug('Size======>accMap=' + accMap.keyset().size());
        for (billing_summary__c bs : triggerNew){
            if (bs.alletec_isinternational__c && bs.Patient__c != null){
                if (accMap.get(bs.Patient__c).Billing_Summary_Patients__r.size() > 0 && accMap.get(bs.Patient__c).Billing_Summary_Patients__r[0].alletec_billdate__c.date().daysbetween(bs.alletec_billdate__c.date()) <= 90){
                    Billing_Summary__c frstbill = accMap.get(bs.Patient__c).Billing_Summary_Patients__r[0];
                    
                    bs.International_Status__c = frstbill.International_Status__c;
                    bs.Pre_Intimation_Status__c = frstbill.Pre_Intimation_Status__c;
                    bs.HCF_Source__c = frstbill.HCF_Source__c;
                    bs.Tagged_Pre_Intimation__c = frstbill.Tagged_Pre_Intimation__c;
                    bs.Auto_tagged__c = true;
                    bs.SMS_Tagged__c = frstbill.SMS_Tagged__c;
                    if (bs.Tagged_On__c == NULL){
                        bs.Tagged_On__c = system.today();
                    }
                    bs.Tagged_RecordId__c = frstbill.id;
                    bs.Is_Tagged_By_International_Hidden__c = true;
                } else if (accMap.get(bs.Patient__c).Admission_Acknowledgements3__r.size() > 0 && accMap.get(bs.Patient__c).Admission_Acknowledgements3__r[0].Date_Time_of_Admission__c.date().daysbetween(bs.alletec_billdate__c.date()) <= 90){
                    Admission_Acknowledgement__c frstAck = accMap.get(bs.Patient__c).Admission_Acknowledgements3__r[0];
                    bs.International_Status__c = frstAck.International_Status__c;
                    bs.Pre_Intimation_Status__c = frstAck.Pre_Intimation_Status__c;
                    bs.HCF_Source__c = frstAck.HCF_Source__c;
                    bs.Tagged_Pre_Intimation__c = frstAck.Tagged_Pre_Intimation__c;
                    bs.Auto_tagged__c = true;
                    bs.SMS_Tagged__c = frstAck.SMS_Tagged__c;
                    if (bs.Tagged_On__c == NULL){
                        bs.Tagged_On__c = system.today();
                    }
                    bs.Is_Tagged_By_International_Hidden__c = true;
                    bs.Tagged_RecordId__c = frstAck.id;
                }
                
            }
            
        }
    }
    
    //added by Nitya on 30th June 2022 to auto tag the billing summary (late tagging).
    //on after update
    public static void tagOnLateTagging(set<id> bsSet){
        //only one record with be auto tagged at once. Still bulkified the code.
        Map<string, billing_summary__c> bsMap = new map<string, billing_summary__c>();
        date d = date.today();
        for (billing_summary__c bs : [select id, name__c, alletec_billdate__c, hcf_source__c, Tagged_On__c, SMS_Tagged__c, Is_Tagged_By_International_Hidden__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c
                                      from billing_summary__c
                                      where id in:bsSet and alletec_billdate__c != null and name__c != null]){
                                          bsMap.put(bs.name__c, bs);
                                          if (d > bs.alletec_billdate__c.date())
                                              d = bs.alletec_billdate__c.date();
                                      }
        list<billing_summary__c> billToUpdate = [select id, name__c, alletec_billDate__c, hcf_source__c, Tagged_On__c, SMS_Tagged__c, Is_Tagged_By_International_Hidden__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c
                                                 from billing_summary__c
                                                 where name__c in:bsMap.keyset() and hcf_source__c = null and alletec_isinternational__c = true and day_only(convertTimezone(alletec_billdate__c)) >= :d];
        
        
        if (billToUpdate.isEmpty())
            return;
        for (billing_summary__c bs : billToUpdate){
            if (bsMap.get(bs.name__c).alletec_billdate__c.date().daysbetween(bs.alletec_billdate__c.date()) <= 90){
                bs.International_Status__c = bsMap.get(bs.name__c).International_Status__c;
                bs.Pre_Intimation_Status__c = bsMap.get(bs.name__c).Pre_Intimation_Status__c;
                bs.HCF_Source__c = bsMap.get(bs.name__c).HCF_Source__c;
                bs.Tagged_Pre_Intimation__c = bsMap.get(bs.name__c).Tagged_Pre_Intimation__c;
                bs.Auto_tagged__c = true;
                bs.SMS_Tagged__c = bsMap.get(bs.name__c).SMS_Tagged__c;
                if (bs.Tagged_On__c == NULL){
                    bs.Tagged_On__c = system.today();
                }
                bs.Tagged_RecordId__c = bsMap.get(bs.name__c).id;
                bs.Is_Tagged_By_International_Hidden__c = true;
            }
        }
        update billToUpdate;
        List<admission_acknowledgement__c> admToUpdate = [select id, max_id__c, date_time_of_admission__c, hcf_source__c, Tagged_On__c, SMS_Tagged__c, Is_Tagged_By_International_Hidden__c, Auto_tagged__c, Pre_Intimation_Status__c, International_Status__c, Tagged_Pre_Intimation__c
                                                          from admission_acknowledgement__c
                                                          where max_id__c in:bsMap.keyset() and hcf_source__c = null and alletec_international__c = true and day_only(convertTimezone(date_time_of_admission__c)) >= :d];
        if (admToUpdate.isempty())
            return;
        for (admission_acknowledgement__c ack : admToUpdate){
            if (bsMap.get(ack.max_id__c).alletec_billdate__c.date().daysbetween(ack.date_time_of_admission__c.date()) <= 90){
                ack.International_status__c = bsMap.get(ack.max_id__c).International_status__c;
                ack.Pre_Intimation_Status__c = bsMap.get(ack.max_id__c).Pre_Intimation_Status__c;
                ack.HCF_Source__c = bsMap.get(ack.max_id__c).HCF_Source__c;
                ack.Tagged_Pre_Intimation__c = bsMap.get(ack.max_id__c).Tagged_Pre_Intimation__c;
                ack.Auto_tagged__c = true;
                ack.SMS_Tagged__c = bsMap.get(ack.max_id__c).SMS_Tagged__c;
                if (ack.Tagged_On__c == NULL){
                    ack.Tagged_On__c = system.today();
                }
                ack.Tagged_RecordId__c = bsMap.get(ack.max_id__c).id;
                ack.Is_Tagged_By_International_Hidden__c = true;
            }
        }
        update admToUpdate;
    }
    
    //Method to change stage of case
    public static void changeCaseStage(list<Billing_Summary__c> triggernew){
        
        set<string> maxIdSet = new set<string>();
        set<string> leadStagesFromCustomLabel = new set<string>();
        leadStagesFromCustomLabel.addAll(system.label.CaseLeadList.split(','));
        
        for (Billing_Summary__c bill : triggernew){
            if (bill.name__c != null)
                maxIdSet.add(bill.name__c);
        }
        String recordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Digital Customer Acquisition').getRecordTypeId();
        
        if (maxIdSet.size() > 0){
            
            List<lead__c> leadList = [Select id, Submitted_On__c, Stage__c, Max_ID__c
                                      from lead__c
                                      where RecordTypeId = :recordTypeId AND Max_ID__c != null AND Max_ID__c IN:maxIdSet AND Stage__c In:leadStagesFromCustomLabel];
            system.debug(leadList);
            if (leadList != null && leadList.size() > 0){
                
                list<Lead__c> leadUpdatelist = new list<lead__c>();
                
                for (lead__c ld : leadList){
                    lead__c led = new Lead__c();
                    led.Id = ld.Id;
                    led.Stage__c = 'OPD Consult Taken';
                    //led.Submitted_On__c=system.Now();
                    leadUpdatelist.add(led);
                }
                
                if (leadUpdatelist.size() > 0)
                    update leadUpdatelist;
            }
        }
    }
    
    //added by Nitya on 25th Feb 2022
    public static Integer uniqMaxId(String MaxId){
        Integer count = 0;
        for (International_OP_Patient_Journey__c IOPJ : [select id, Journey_Day__c
                                                         from International_OP_Patient_Journey__c
                                                         WHERE Patient_Max_id__c = :MaxId]){
                                                             if (IOPJ.Journey_Day__c < 90){
                                                                 count = count + 1;
                                                             }
                                                         }
        return count;
    }
    
    //Added by Nitya on 25th Feb 2022
    // Function for Inserting International OP Patient Journey Records
    public static void InsertInternationalOPPatientJourney(List<billing_summary__c> triggerNew){
        set<String> maxIdWoutIOP = new Set<String>();
        set<String> maxIdWIOP = new Set<String>();
        set<Id> patientSet = new Set<Id>();
        Map<String, billing_summary__c> bsMap = new Map<String, billing_summary__c>();
        
        for (billing_summary__c bs : TriggerNew){
            if (bs.name__c != null && bs.alletec_billdate__c != null){
                if (!bsMap.isEmpty() && bsMap.containsKey(bs.name__c.ToUpperCase()) && bsMap.get(bs.name__c.ToUpperCase()).alletec_billdate__c <= bs.alletec_billdate__c){
                    continue;
                } else{
                    bsMap.put(bs.name__c.ToUpperCase(), bs);
                }
                if (bs.IOP_journey__c == null){
                    maxIdWoutIOP.add(bs.name__c.ToUpperCase());
                } else
                    maxIdWIOP.add(bs.name__c.ToUpperCase());
            }
            /* if(bs.Patient__c!=null){
patientSet.add(bs.Patient__c);
}*/
        }
        
        List<international_OP_Patient_journey__c> ipojList = new List<international_OP_Patient_journey__c>();
        for (international_OP_Patient_journey__c ipoj : [select id, patient_max_id__c, journey_day__c, OP_Bill_Lists__c, Patient__c
                                                         from international_OP_Patient_journey__c
                                                         where patient_max_id__c in:maxIdWIOP]){
                                                             if (ipoj.journey_day__c < 90){
                                                                 ipoj.OP_Bill_Lists__c += ',' + bsMap.get(ipoj.patient_max_id__c.ToUpperCase()).invoicenumber__c;
                                                                 ipojList.add(ipoj);
                                                             } else if (uniqMaxId(ipoj.patient_max_id__c.ToUpperCase()) == 0 && bsMap.get(ipoj.patient_max_id__c.ToUpperCase()).alletec_isInternational__c && bsMap.get(ipoj.patient_max_id__c.ToUpperCase()).alletec_transactiontype__c == 'OP'){
                                                                 International_OP_Patient_Journey__c iopj = new International_OP_Patient_Journey__c();
                                                                 iopj.Patient__c = ipoj.Patient__c;
                                                                 iopj.Name = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_patientname__c;
                                                                 iopj.Patient_Max_id__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).name__c;
                                                                 iopj.First_OP_Bill__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).invoicenumber__c;
                                                                 iopj.OP_Bill_Lists__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).invoicenumber__c;
                                                                 iopj.Patient_Age__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).Patient__r.Age__c;
                                                                 iopj.Patient_Phone_Number__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).Patient__r.PersonMobilePhone;
                                                                 iopj.Patient_Email_Id__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).Patient__r.PersonEmail;
                                                                 iopj.First_OP_Bill_Date__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_billdate__c;
                                                                 iopj.Date_Of_Admission__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_dateofadmission__c;
                                                                 iopj.Stage__c = 'New';
                                                                 iopj.Channel_Name__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_channeltype__c;
                                                                 iopj.Patient_Nationality__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).Nationality__c;
                                                                 iopj.Doctor_Name__c = bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_doctorname__c;
                                                                 
                                                                 if (bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_department__r.name == 'Radiology'){
                                                                     iopj.Radiology__c = true;
                                                                 }
                                                                 if (bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_department__r.name == 'Pathology'){
                                                                     iopj.Pathology__c = true;
                                                                 }
                                                                 if (bsMap.get(ipoj.Patient_Max_id__c.ToUpperCase()).alletec_department__r.name == 'Pharmacy'){
                                                                     iopj.Pharmacy__c = true;
                                                                 }
                                                                 
                                                                 ipojList.add(iopj);
                                                             }
                                                             
                                                         }
        upsert ipojList;
        List<International_OP_Patient_Journey__c> ipojNew = new list<International_OP_Patient_Journey__c>();
        //        Map<string, billing_summary__c> bsMap2=new Map<string, billing_summary__c>();
        for (billing_summary__c bs : [select id, alletec_patientname__c, name__c, invoicenumber__c, Patient__r.Age__c, Patient__c, Patient__r.PersonMobilePhone, Patient__r.Alternate_Email__c, alletec_doctorname__c, Nationality__c, alletec_channeltype__c, alletec_dateofadmission__c, alletec_billdate__c, alletec_department__r.name
                                      from billing_summary__c
                                      where name__c in:maxIdWoutIOP and alletec_transactiontype__c = 'OP' and alletec_isInternational__c = true and id in:triggerNew and patient__c != null]){
                                          //  bsMap2.put(bs.id,bs);
                                          International_OP_Patient_Journey__c iopj = new International_OP_Patient_Journey__c();
                                          iopj.Name = bs.alletec_patientname__c;
                                          iopj.Patient_Max_id__c = bs.name__c.ToUpperCase();
                                          iopj.First_OP_Bill__c = bs.invoicenumber__c;
                                          iopj.OP_Bill_Lists__c = bs.invoicenumber__c;
                                          iopj.Patient__c = bs.Patient__c;
                                          iopj.Patient_Age__c = bs.Patient__r.Age__c;
                                          iopj.Patient_Phone_Number__c = bs.Patient__r.PersonMobilePhone;
                                          iopj.Patient_Email_Id__c = bs.Patient__r.Alternate_Email__c;
                                          iopj.First_OP_Bill_Date__c = bs.alletec_billdate__c;
                                          iopj.Date_Of_Admission__c = bs.alletec_dateofadmission__c;
                                          iopj.Stage__c = 'New';
                                          iopj.Channel_Name__c = bs.alletec_channeltype__c;
                                          iopj.Patient_Nationality__c = bs.Nationality__c;
                                          iopj.Doctor_Name__c = bs.alletec_doctorname__c;
                                          if (bs.alletec_department__r.name == 'Radiology'){
                                              iopj.Radiology__c = true;
                                          }
                                          if (bs.alletec_department__r.name == 'Pathology'){
                                              iopj.Pathology__c = true;
                                          }
                                          if (bs.alletec_department__r.name == 'Pharmacy'){
                                              iopj.Pharmacy__c = true;
                                          }
                                          ipojNew.add(iopj);
                                      }
        
        insert ipojNew;
    }
    
    // Added by Nitya on 25th Feb 2022
    // Function for tagging IPOJ on Billing Records in before Insert and update (only if max Id changes)
    public static void TagIOPJourneyOnBillingSummary(List<billing_summary__c> TriggerNew){
        Set<string> maxIds = new Set<string>();
        for (billing_summary__c bs : triggerNew){
            if (bs.name__c != null && bs.IOP_Journey__c == null && bs.alletec_transactionType__c == 'OP')
                maxIds.add(bs.name__c.ToUpperCase());
            else
                return;
        }
        
        Map<String, international_OP_Patient_journey__c> iopjMap = new map<string, international_OP_Patient_journey__c>();
        
        for (international_OP_Patient_journey__c ipoj : [select id, patient_max_id__c, journey_day__c
                                                         from international_OP_Patient_journey__c
                                                         where patient_max_id__c in:maxIds
                                                         order by journey_day__c desc]){
                                                             //and Journey_day__c<90 and (Stage__c!='Closed Lost' OR Stage__c!='Closed Won')
                                                             iopjMap.put(ipoj.patient_max_id__c.ToUpperCase(), ipoj);
                                                         }
        if (!iopjMap.IsEmpty()){
            for (billing_summary__c bs : triggerNew){
                if (iopjMap.containsKey(bs.name__c.ToUpperCase())){
                    bs.IOP_Journey__c = iopjMap.get(bs.name__c.ToUpperCase()).id;
                }
            }
        }
    }
    
    // Added by Nitya on 25th Feb 2022
    // Function to update IPOJ record on updation of Billing Summary Records
    public static void updateInternationalOPPatientJourney(List<billing_summary__c> triggerNew, Map<id, billing_summary__c> oldMap){
        Map<String, billing_summary__c> bsMap = new Map<String, billing_summary__c>();
        set<id> bsIds = new Set<id>();
        for (billing_summary__c bs : triggerNew){
            if ((oldmap.get(bs.id).alletec_doctorname__c != bs.alletec_doctorname__c) || (oldmap.get(bs.id).Nationality__c != bs.Nationality__c) || (oldmap.get(bs.id).alletec_channeltype__c != bs.alletec_channeltype__c) || (oldmap.get(bs.id).alletec_dateofadmission__c != bs.alletec_dateofadmission__c) || (oldmap.get(bs.id).alletec_billdate__c != bs.alletec_billdate__c) || (oldmap.get(bs.id).alletec_patientname__c != bs.alletec_patientname__c)){
                bsIds.add(bs.id);
            }
        }
        if (bsIds.isEmpty())
            return;
        //need to query because trigger.new doesn't contains parent fields data
        for (billing_summary__c bs : [select id, name, alletec_patientname__c, name__c, Patient__r.Age__c, Patient__r.PersonMobilePhone, Patient__r.PersonEmail, alletec_billdate__c, alletec_dateofadmission__c, alletec_channeltype__c, Nationality__c, alletec_doctorname__c
                                      from Billing_Summary__c
                                      where id in:bsIds]){
                                          if (bs.name__c != null)
                                              bsMap.put(bs.name__c.ToUpperCase(), bs);
                                      }
        List<International_OP_Patient_Journey__c> ipojList = new list<International_OP_Patient_Journey__c>();
        for (International_OP_Patient_Journey__c iopjUpdate : [select id, Patient_Max_id__c, Patient_Age__c, Patient_Phone_Number__c, Patient_Email_Id__c, First_OP_Bill_Date__c, Date_Of_Admission__c, Channel_Name__c, Patient_Nationality__c, Doctor_Name__c
                                                               from International_OP_Patient_Journey__c
                                                               WHERE Patient_Max_id__c = :bsMap.keyset()]){
                                                                   iopjUpdate.Name = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).alletec_patientname__c;
                                                                   iopjUpdate.Patient_Max_id__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).name__c;
                                                                   iopjUpdate.Patient_Age__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).Patient__r.Age__c;
                                                                   iopjUpdate.Patient_Phone_Number__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).Patient__r.PersonMobilePhone;
                                                                   iopjUpdate.Patient_Email_Id__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).Patient__r.PersonEmail;
                                                                   iopjUpdate.First_OP_Bill_Date__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).alletec_billdate__c;
                                                                   iopjUpdate.Date_Of_Admission__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).alletec_dateofadmission__c;
                                                                   iopjUpdate.Channel_Name__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).alletec_channeltype__c;
                                                                   iopjUpdate.Patient_Nationality__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).Nationality__c;
                                                                   iopjUpdate.Doctor_Name__c = bsMap.get(iopjUpdate.Patient_Max_id__c.ToUpperCase()).alletec_doctorname__c;
                                                                   ipojList.add(iopjUpdate);
                                                                   
                                                               }
        update ipojList;
    }
   
    
    //Added by Nitya upto here
    public void mapBillingDetails1(list<Billing_Summary__c> triggerNew){
        
        system.debug('mapBIllingDetails1 method called');
        set<String> citySet = new set<String>();
        set<String> localitySet = new set<String>();
        set<String> stateSet = new set<String>();
        set<String> countrySet = new set<String>();
        set<String> businessUnitSet = new set<String>();
        set<String> maxIdSet = new set<String>();
        set<String> doctorIdSet = new set<String>();
        set<String> glCodeSet = new set<String>();
        
        for (Billing_Summary__c bsummary : triggerNew){
            if (String.isNotBlank(bsummary.billto_city__c))
                citySet.add(bsummary.billto_city__c);
            if (String.isNotBlank(bsummary.alletec_locality__c))
                localitySet.add(bsummary.alletec_locality__c);
            if (String.isNotBlank(bsummary.alletec_state__c))
                stateSet.add(bsummary.alletec_state__c);
            if (String.isNotBlank(bsummary.billto_country__c))
                countrySet.add(bsummary.billto_country__c);
            if (String.isNotBlank(bsummary.Hospital_Location_HIS__c))
                businessUnitSet.add(bsummary.Hospital_Location_HIS__c);
            if (String.isNotBlank(bsummary.name__c))
                maxIdSet.add(bsummary.name__c);
            if (String.isNotBlank(bsummary.alletec_doctorid__c))
                doctorIdSet.add(bsummary.alletec_doctorid__c);
            if (String.isNotBlank(bsummary.GL_Code__c))
                glCodeSet.add(bsummary.GL_Code__c);
        }
        
        map<String, Id> cityMap = new map<String, Id>();
        map<String, Id> localitytyMap = new map<String, Id>();
        map<String, Id> stateMap = new map<String, Id>();
        map<String, Id> countryMap = new map<String, Id>();
        map<String, Id> businessUnitMap = new map<String, Id>();
        map<String, Id> patientMap = new map<String, Id>();
        map<String, Id> doctorMap = new map<String, Id>();
        map<String, Id> companyMap = new map<String, Id>();
        
        String condition;
        if (!citySet.isEmpty())
            condition = 'alletec_cityid__c IN : citySet';
        if (!citySet.isEmpty())
            condition += ' OR alletec_countryid__c IN : countrySet';
        if (!citySet.isEmpty())
            condition += ' OR alletec_localityid__c IN : localitySet';
        if (!citySet.isEmpty())
            condition += ' OR State_ID__c IN : stateSet';
        if (String.isNotBlank(condition)){
            condition = '(' + condition + ')';
            System.debug('condition = ' + condition);
            
            Set<String> recordtypes = new Set<String>{ 'City', 'Country', 'Locality', 'State' };
                String query = 'SELECT Id, Recordtype.Name, alletec_cityid__c, alletec_countryid__c, alletec_localityid__c, alletec_state__c FROM Address_Master__c';
            query += ' WHERE RecordType.Name IN : recordtypes AND ' + condition;
            System.debug('query == ' + query);
            for (Address_Master__c adm : Database.query(query)){
                if (String.isNotBlank(adm.alletec_countryid__c) && adm.RecordType.Name.equalsIgnoreCase('Country'))
                    countryMap.put(adm.alletec_countryid__c, adm.Id);
                if (String.isNotBlank(adm.alletec_state__c) && adm.RecordType.Name.equalsIgnoreCase('State'))
                    stateMap.put(adm.alletec_state__c, adm.Id);
                if (String.isNotBlank(adm.alletec_cityid__c) && adm.RecordType.Name.equalsIgnoreCase('City'))
                    cityMap.put(adm.alletec_cityid__c, adm.Id);
                if (String.isNotBlank(adm.alletec_localityid__c) && adm.RecordType.Name.equalsIgnoreCase('Locality'))
                    localitytyMap.put(adm.alletec_localityid__c, adm.Id);
            }
        }
        
        String objectName;
        String columnName;
        String recordType;
        
        //Creating Business Unit Map
        if (!businessUnitSet.isEmpty()){
            objectName = 'Business_Unit__c';
            columnName = 'HIS_ID__c';
            recordType = '';
            list<Business_Unit__c> businessUnits = (List<Business_Unit__c>)serachMaster(objectName, columnName, recordType, businessUnitSet);
            
            if (businessUnits != null && businessUnits.size() > 0){
                for (Business_Unit__c adm : businessUnits){
                    if (String.isNotBlank(adm.HIS_ID__c))
                        businessUnitMap.put(adm.HIS_ID__c, adm.Id);
                }
            }
        }
        
        //Creating Company Map
        if (!glCodeSet.isEmpty()){
            objectName = 'Company_Master__c';
            columnName = 'GL_Code__c';
            recordType = '';
            list<Company_Master__c> companies = (List<Company_Master__c>)serachMaster(objectName, columnName, recordType, glCodeSet);
            
            if (companies != null && !companies.isEmpty()){
                for (Company_Master__c company : companies){
                    if (String.isNotBlank(company.GL_Code__c))
                        companyMap.put(company.GL_Code__c, company.Id);
                }
            }
        }
        
        if (!maxIdSet.isEmpty()){
            objectName = 'Account';
            columnName = 'Max_ID__c';
            recordType = 'Patient';
            list<Account> patientList = (List<Account>)serachMaster(objectName, columnName, recordType, maxIdSet);
            
            if (patientList != null && patientList.size() > 0){
                for (Account pat : patientList){
                    if (String.isNotBlank(pat.Max_ID__c))
                        patientMap.put(pat.Max_ID__c, pat.Id);
                }
            }
        }
        
        //Creating Doctor Map
        if (!doctorIdSet.isEmpty()){
            objectName = 'Account';
            columnName = 'alletec_doctorid__c';
            recordType = 'Doctor';
            list<Account> doctorList = (List<Account>)serachMaster(objectName, columnName, recordType, doctorIdSet);
            
            if (doctorList != null && doctorList.size() > 0){
                for (Account acc : doctorList){
                    if (String.isNotBlank(acc.alletec_doctorid__c))
                        doctorMap.put(acc.alletec_doctorid__c, acc.Id);
                }
            }
        }
        
        
        Set<String> billingSummmaryIpIds = new Set<String>();
        Set<Id> businessUnits = new Set<Id>();
        Set<String> maxIdSetBilling = new Set<String>();
        Map<String, Id> admissionAckIdMap = new Map<String, Id>();
        
        TriggerExecutions__c billingerror = TriggerExecutions__c.getOrgDefaults();
        Channel_Massaging__mdt objSetting = [SELECT channel_massaging_active__c
                                             FROM Channel_Massaging__mdt
                                             WHERE MasterLabel = 'Setting'];
        system.debug('objSetting --> ' + objSetting);
        
        System.debug('ConnectVisaInviteWithBillingSummary Start');
        /*-------------------------------ConnectVisaInviteWithBillingSummary Method Code Starts Here------------------------------------*/
        //List<Visa_Invite__c> listVisaInviteUpdate = new List<Visa_Invite__c>();
        Map<String, Id> VisaInviteMap = new Map<String, Id>();
        map<id, Visa_Invite__c> visaInviteMapForUpdate = new map<id, Visa_Invite__c>();
        Map<string, Visa_Invite__c> mapBillDate = new Map<string, Visa_Invite__c>();
        Set<String> stages = new Set<String>{ 'Expired', 'Converted', 'Converted and Expired' };
            
            if (!maxIdSet.isEmpty() && label.Biling_trigger == 'On'){
                for (Visa_Invite__c objVisaInvite : [SELECT Id, Stage__c, Max_Id__c, Patient__c
                                                     FROM Visa_Invite__c
                                                     WHERE Max_ID__c != NULL AND Patient__c != NULL AND (Stage__c = 'New' OR Stage__c = 'Converted') AND Max_ID__c = :maxIdSet]){
                                                         mapBillDate.put(objVisaInvite.Max_Id__c, objVisaInvite);
                                                         VisaInviteMap.put(objVisaInvite.Max_ID__c, objVisaInvite.id);
                                                     }
                //end of visa invite loop
            }
        //end of Max Id Size check
        
        System.debug('businessUnitMap= ' + businessUnitMap);
        //Mapping Master record values
        for (Billing_Summary__c bsumm : triggerNew){
            if (String.isNotBlank(bsumm.billto_city__c) && cityMap.containsKey(bsumm.billto_city__c))
                bsumm.City__c = cityMap.get(bsumm.billto_city__c);
            if (String.isNotBlank(bsumm.alletec_locality__c) && localitytyMap.containsKey(bsumm.alletec_locality__c))
                bsumm.Locality__c = localitytyMap.get(bsumm.alletec_locality__c);
            if (String.isNotBlank(bsumm.alletec_state__c) && stateMap.containsKey(bsumm.alletec_state__c))
                bsumm.State__c = stateMap.get(bsumm.alletec_state__c);
            if (String.isNotBlank(bsumm.billto_country__c) && countryMap.containsKey(bsumm.billto_country__c))
                bsumm.Country__c = countryMap.get(bsumm.billto_country__c);
            if (String.isNotBlank(bsumm.Hospital_Location_HIS__c) && businessUnitMap.containsKey(bsumm.Hospital_Location_HIS__c)){
                bsumm.alletec_hospitallocation__c = businessUnitMap.get(bsumm.Hospital_Location_HIS__c);
                if (String.isNotBlank(bsumm.alletec_ipid__c) && bsumm.alletec_hospitallocation__c != null && bsumm.name__c != NULL){
                    billingSummmaryIpIds.add(bsumm.alletec_ipid__c);
                    businessUnits.add(bsumm.alletec_hospitallocation__c);
                    maxIdSetBilling.add(bsumm.name__c);
                }
            }
            if (String.isNotBlank(bsumm.alletec_doctorid__c) && doctorMap.containsKey(bsumm.alletec_doctorid__c))
                bsumm.alletec_companyname__c = doctorMap.get(bsumm.alletec_doctorid__c);
            if (String.isNotBlank(bsumm.GL_Code__c) && companyMap.containsKey(bsumm.GL_Code__c))
                bsumm.Company__c = companyMap.get(bsumm.GL_Code__c);
            if (String.isNotBlank(bsumm.name__c)){
                if (patientMap.containsKey(bsumm.name__c)){
                    bsumm.Patient__c = patientMap.get(bsumm.name__c);
                } else if (!patientMap.containsKey(bsumm.name__c) && billingerror.Billing_Summary_Error__c){
                    bsumm.addError('No patient found with the specified MaxId');
                }
            }
            if (mapBillDate.containskey(bsumm.name__c) && label.Biling_trigger == 'On'){
                if (mapBillDate.get(bsumm.name__c).Stage__c == 'New'){
                    bsumm.Visa_Invite__c = mapBillDate.get(bsumm.name__c).Id;
                    Visa_Invite__c visaInvite = new Visa_Invite__c();
                    visaInvite.id = mapBillDate.get(bsumm.name__c).Id;
                    visaInvite.Stage__c = 'Converted';
                    visaInviteMapForUpdate.put(visainvite.id, visaInvite);
                    //listVisaInviteUpdate.add(visaInvite);
                } else{
                    bsumm.Visa_Invite__c = mapBillDate.get(bsumm.name__c).Id;
                }
            }
            // If Condition Ended
        }
        // Outer For Loop Ended
        /*Updating Stage of Visa Invite */
        if (!visaInviteMapForUpdate.isEmpty() && label.Biling_trigger == 'On')
            Database.SaveResult[] srList = Database.Update (visaInviteMapForUpdate.values(), false);
        /*-------------------------------ConnectVisaInviteWithBillingSummary Method Code ends Here------------------------------------*/
        
        
        map<Id, List<Billing_Summary__c>> mapAdminAckIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
        map<Id, List<Billing_Summary__c>> mapPatientIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
        System.debug('Admission Acknowledgement Mapping= ' + (!billingSummmaryIpIds.isEmpty() && !businessUnits.isEmpty() && !maxIdSetBilling.isEmpty()));
        
        //Admission Acknowledgement Mapping on Billing summary based on IPID and Hospital Location
        //Look for any adm ack record based on same ipid , business unit and max id
        //Last Modified By: Nitya IRT on 13th July 2022
        if (!billingSummmaryIpIds.isEmpty() && !businessUnits.isEmpty() && !maxIdSetBilling.isEmpty()){
            for (Admission_Acknowledgement__c admAck : [SELECT Id, Max_ID__c, IPID__c, alletec_hospitallocation__c
                                                        FROM Admission_Acknowledgement__c
                                                        WHERE alletec_hospitallocation__c IN:businessUnits AND IPID__c IN:billingSummmaryIpIds AND Max_ID__c IN:maxIdSetBilling]){
                                                            String key = admAck.IPID__c + '-' + String.valueOf(admAck.alletec_hospitallocation__c);
                                                            admissionAckIdMap.put(key, admAck.Id);
                                                        }
            if (objSetting.channel_massaging_active__c){
                for (Billing_Summary__c bsum : triggerNew){
                    if (!admissionAckIdMap.isEmpty()){
                        if (String.isNotBlank(bsum.alletec_ipid__c) && bsum.alletec_hospitallocation__c != null){
                            String key = bsum.alletec_ipid__c + '-' + String.valueOf(bsum.alletec_hospitallocation__c);
                            if (admissionAckIdMap.containsKey(key))
                                bsum.Admission_Acknowledgement__c = admissionAckIdMap.get(key);
                        }
                    }
                    if (String.isNotBlank(bsum.alletec_channeltype__c) && (bsum.alletec_channeltype__c.equalsIgnoreCase('PSU') || bsum.alletec_channeltype__c.equalsIgnoreCase('Corporate')))
                        bsum.R_Channel__c = bsum.alletec_channeltype__c;
                    else if (String.isBlank(bsum.Admission_Acknowledgement__c) && String.isNotBlank(bsum.Patient__c)){
                        if (!mapPatientIdWithBillSum.containsKey(bsum.Patient__c))
                            mapPatientIdWithBillSum.put(bsum.Patient__c, new List<Billing_Summary__c>{bsum});
                        else
                            mapPatientIdWithBillSum.get(bsum.Patient__c).add(bsum);
                    } else if (String.isNotBlank(bsum.Admission_Acknowledgement__c)){
                        if (!mapAdminAckIdWithBillSum.containsKey(bsum.Admission_Acknowledgement__c))
                            mapAdminAckIdWithBillSum.put(bsum.Admission_Acknowledgement__c, new List<Billing_Summary__c>{bsum});
                        else
                            mapAdminAckIdWithBillSum.get(bsum.Admission_Acknowledgement__c).add(bsum);
                    }
                }
            }
        }
        // system.debug('setBeforeRecursive ---> ' + setBeforeRecursive);
        system.debug('mapPatientIdWithBillSum ---> ' + mapPatientIdWithBillSum);
        system.debug('mapAdminAckIdWithBillSum  --->  ' + mapAdminAckIdWithBillSum);
        try{
            if (!mapAdminAckIdWithBillSum.isEmpty()){
                for (Admission_Acknowledgement__c objAdminAck : [SELECT Id, pcl_markuptype__c, Patient__r.address2_country__c, MECP_Source__c
                                                                 FROM Admission_Acknowledgement__c
                                                                 WHERE Id IN:mapAdminAckIdWithBillSum.keySet()]){
                                                                     for (Billing_Summary__c objBillSum : mapAdminAckIdWithBillSum.get(objAdminAck.Id)){
                                                                         if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAdminAck.Patient__r.address2_country__c) && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('Indian') && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('149')) || (String.isNotBlank(objAdminAck.pcl_markuptype__c) && objAdminAck.pcl_markuptype__c.equalsIgnoreCase('is applied'))){
                                                                             // system.debug('Intrernational got true ');
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
                                                                             } else
                                                                                 objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                                                                         }
                                                                     }
                                                                     //end of BillSum Loop
                                                                 }
                //end of Admin Ack Loop
            }
            //incase of bill's other than Ip where there is no Admission Ack
            else if (!mapPatientIdWithBillSum.isEmpty()){
                system.debug('mapPatientIdWithBillSum '+ mapPatientIdWithBillSum);
                for (Account objAcc : [SELECT Id, address2_country__c
                                       FROM Account
                                       WHERE Id IN:mapPatientIdWithBillSum.keySet()]){
                                           for (Billing_Summary__c objBillSum : mapPatientIdWithBillSum.get(objAcc.Id)){
                                               if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAcc.address2_country__c) && !objAcc.address2_country__c.equalsIgnoreCase('Indian') && !objAcc.address2_country__c.equalsIgnoreCase('149'))){
                                                   //  system.debug('Intrernational got true ');
                                                   objBillSum.alletec_isinternational__c = true;
                                                   objBillSum.R_Channel__c = 'International';
                                               } else{
                                                   if (objBillSum.alletec_channeltype__c == 'Cash')
                                                       objBillSum.R_Channel__c = 'Walk-In';
                                                   else if (objBillSum.alletec_channeltype__c == 'Walk-In' || objBillSum.alletec_channeltype__c == 'TPA')
                                                       objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                                                   else
                                                       objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
                                               }
                                           }
                                           //end of BillSum Loop
                                       }
                //end of Account Obj Loop
            }
        } catch (Exception objExcep){
            system.debug(' error on massaging --> ' + objExcep.getMessage() + 'Line --- > ' + objExcep.getLineNumber());
        }
    }
    
    //Search values based on object name and column name
    public list<sObject> serachMaster(String objectName, String columnName, String recordtype, set<String> hisIds){
        String query = 'SELECT Id,' + columnName + ' FROM ' + objectName + ' WHERE ';
        query += columnName + ' IN :hisIds';
        if (String.isNotBlank(recordtype) )
            query += ' AND Recordtype.Name=\'' + recordtype + '\'';
        list<sObject> sobjList = Database.query(query);
        return sobjList;
    }
    
    //RollUp Values to Patient, Docotr and Admission Acknowledgement
    // Added by Navin Soni on 24-08-2021 for future method.
    @future
    public static void doInsertUpdateUndelete(Set<String> setOfIds){
        // Added by Navin Soni on 24-08-2021 for future method.
        List<Billing_Summary__c> triggerNew = [SELECT ID, alletec_companyname__c, Patient__c, Admission_Acknowledgement__c, alletec_billdate__c
                                               FROM Billing_Summary__c
                                               WHERE ID IN:setOfIds];
        
        set<Id> setDoctorId = new set<Id>();
        set<Id> setPatientId = new set<Id>();
        set<Id> setAdmissionId = new set<Id>();
        Map<String, Billing_Summary__c> MapAdmToBillingSummary = new Map<String, Billing_Summary__c>();
        List<Account> listDoctorToUpdate = new List<Account>();
        List<Account> listPatientToUpdate = new List<Account>();
        List<Admission_Acknowledgement__c> listAdmisson = new List<Admission_Acknowledgement__c>();
        List<Prospect__c> listProspect = new List<Prospect__c>();
        
        for (Billing_Summary__c bs : triggerNew){
            if (bs.alletec_companyname__c != NULL)
                setDoctorId.add(bs.alletec_companyname__c);
            if (bs.Patient__c != NULL)
                setPatientId.add(bs.Patient__c);
            if (bs.Admission_Acknowledgement__c != NULL)
                MapAdmToBillingSummary.put(bs.Admission_Acknowledgement__c, bs);
            setAdmissionId.add(bs.Admission_Acknowledgement__c);
            // system.debug('====setAdmissionId==='+setAdmissionId);
        }
        
        if (setDoctorId != NULL && setDoctorId.size() > 0){
            for (AggregateResult ar : [SELECT alletec_companyname__c, SUM(alletec_hisamount__c)totAmt
                                       FROM Billing_Summary__c
                                       WHERE alletec_companyname__c != NULL AND alletec_companyname__c IN:setDoctorId
                                       GROUP BY alletec_companyname__c]){
                                           Account doc = new Account();
                                           doc.Id = (Id) ar.get('alletec_companyname__c');
                                           doc.Total_Revenue__c = (Decimal) ar.get('totAmt');
                                           listDoctorToUpdate.add(doc);
                                       }
        }
        
        if (setPatientId != NULL && setPatientId.size() > 0){
            for (AggregateResult ar : [SELECT Patient__c, SUM(alletec_hisamount__c)totAmt
                                       FROM Billing_Summary__c
                                       WHERE Patient__c != NULL AND Patient__c IN:setPatientId
                                       GROUP BY Patient__c]){
                                           Account pat = new Account();
                                           pat.Id = (Id) ar.get('Patient__c');
                                           pat.Total_Revenue__c = (Decimal) ar.get('totAmt');
                                           listPatientToUpdate.add(pat);
                                       }
        }
        
        if (MapAdmToBillingSummary != NULL && MapAdmToBillingSummary.size() > 0){
            system.debug('MapAdmToBillingSummary ' + MapAdmToBillingSummary);
            for (AggregateResult ar : [SELECT Admission_Acknowledgement__c, SUM(alletec_hisamount__c)totAmt
                                       FROM Billing_Summary__c
                                       WHERE Admission_Acknowledgement__c != NULL AND Admission_Acknowledgement__c IN:MapAdmToBillingSummary.keySet()
                                       GROUP BY Admission_Acknowledgement__c]){
                                           system.debug(ar);
                                           Admission_Acknowledgement__c adsn = new Admission_Acknowledgement__c();
                                           adsn.Id = (Id) ar.get('Admission_Acknowledgement__c');
                                           adsn.Total_Revenue__c = (Decimal) ar.get('totAmt');
                                           //Added by Raghav on 14/06/2019 to update the date of discharge from billing summary.
                                           if (MapAdmToBillingSummary.containsKey(adsn.Id) && MapAdmToBillingSummary.get(adsn.Id).alletec_billdate__c != NULL){
                                               adsn.Date_of_Discharge__c = Date.valueOf(MapAdmToBillingSummary.get(adsn.Id).alletec_billdate__c);
                                           }
                                           //adsn.Date_of_Discharge__c =date.today();
                                           adsn.Admission_Status__c = 'D';
                                           listAdmisson.add(adsn);
                                           system.debug('listAdmisson ' + listAdmisson);
                                       }
        }
        //update listAdmisson;
        if (listAdmisson != NULL && listAdmisson.size() > 0){
            Database.SaveResult[] srList = Database.Update (listAdmisson, false);
        }
        //Change Prospect Stage to Discharge
        if (setAdmissionId.size() > 0){
            //  system.debug('====Call Prospect Stage to discharge====');
            UpdateProspectStageToDischarge(setAdmissionId);
        }
        
        
        if (listDoctorToUpdate != NULL && listDoctorToUpdate.size() > 0){
            Database.SaveResult[] srList = Database.Update (listDoctorToUpdate, false);
        }
        
        if (listPatientToUpdate != NULL && listPatientToUpdate.size() > 0){
            Database.SaveResult[] srList = Database.Update (listPatientToUpdate, false);
        }
        
    }
    
    public static void UpdateProspectStageToDischarge(Set<Id> setAdmissionId){
        
        // system.debug('======UpdateProspectStageToDischarge==='+setAdmissionId);
        List<API_Error_Log__c> listApiErrorLog = new List<API_Error_Log__c>();
        String Ids = '';
        
        map<Id, Prospect__c> listProspectStageUpdate = new map<Id, Prospect__c>();
        
        
        for (Admission_Acknowledgement__c ack : [SELECT Related_Prospect__c, Max_Id__c, Related_Prospect__r.Stage__c
                                                 FROM Admission_Acknowledgement__c
                                                 WHERE Id IN:setAdmissionId]){
                                                     //  system.debug('====ack===='+ack);
                                                     //system.debug('====ack.Related_Prospect__c===='+ack.Related_Prospect__c);
                                                     //system.debug('====ack.Related_Prospect__r.Stage__c==='+ack.Related_Prospect__r.Stage__c);
                                                     
                                                     
                                                     if (ack.Related_Prospect__c != NULL && ack.Related_Prospect__r.Stage__c != 'Patient Discharged'){
                                                         //   system.debug('=====lineNo347=====');
                                                         Prospect__c pros = new Prospect__c();
                                                         pros.Id = ack.Related_Prospect__c;
                                                         pros.Stage__c = 'Patient Discharged';
                                                         listProspectStageUpdate.put(pros.Id, pros);
                                                         // system.debug('=====listProspectStageUpdate==='+listProspectStageUpdate);
                                                     }
                                                 }
        
        //Save Result OPeration
        Database.SaveResult[] srList = Database.Update (listProspectStageUpdate.values(), false);
        //system.debug('====srList===='+srList);
        for (Integer i = 0; i < srList.size(); i++){
            if (!srList[i].isSuccess()){
                API_Error_Log__c apiError = new API_Error_Log__c();
                apiError.API_Name__c = 'Prospect Stage To Discharge Trigger ';
                apiError.Error_Message__c = String.valueOf(srList[i].getErrors());
                apiError.Trigger_Point__c = 'billing-trigger';
                // apiError.Record_Identifier__c = '{"Max Id" : "'+listProspectStageUpdate[i].Max_Id__c+'"}';
                listApiErrorLog.add(apiError);
            } else
                ids += srList[i].getId() + ',';
        }
        if (listApiErrorLog != NULL && listApiErrorLog.size() > 0)
            insert listApiErrorLog;
    }
    
    //Description: Method to update the lead stage to Patient Discharge if its maxId and IpID found in Billing Summary List(triggerNew)
    // Added by Navin Soni on 24-08-2021 for future method.
    @future
    public static void UpdateMaxAtHomeLeadStageToDischarge(Set<String> setOfIds){
        Set<String> setMaxIdAndIPid = new Set<String>();
        Set<String> setMaxId = new Set<String>();
        Set<String> setMaxIPId = new Set<String>();
        List<Billing_Summary__c> triggerNew = [SELECT ID, name__c, alletec_ipid__c
                                               FROM Billing_Summary__c
                                               WHERE ID IN:setOfIds AND name__c != null AND alletec_ipid__c != null];
        List<Lead__c> listLeadUpdate = new List<Lead__c>();
        for (Billing_Summary__c objBillingSum : triggerNew){
            if (objBillingSum.name__c != NULL && objBillingSum.alletec_ipid__c != NULL){
                setMaxIdAndIPid.add(objBillingSum.name__c + objBillingSum.alletec_ipid__c); //maxId+IpId
                setMaxId.add(objBillingSum.name__c);
                setMaxIPId.add(objBillingSum.alletec_ipid__c);
                
            }
        }
        List<String> listLeadStageName = Label.LeadStageNameFor.split(',');
        for (Lead__c objLead : [SELECT Id, Stage__c, Max_ID__c, IPID__c
                                FROM Lead__c
                                WHERE RecordType.Name = :Label.LeadRecordTypeForStatusChange AND Max_ID__c != NULL AND IPID__c != NULL AND Stage__c != 'Patient Discharged' AND IPID__c = :setMaxIPId AND Max_ID__c = :setMaxId]){
                                    if (listLeadStageName.contains(objLead.Stage__c) && setMaxIdAndIPid.contains(objLead.Max_ID__c + objLead.IPID__c)){
                                        objLead.Stage__c = 'Patient Discharged';
                                        listLeadUpdate.add(objLead);
                                    }
                                }
        if (listLeadUpdate.size() > 0)
            Database.SaveResult[] srList = Database.Update (listLeadUpdate, false);
    }
    
    //Method to update lead stage to Query Converted if billing summary is generated within 180 Days of Query Converted date
    // Added by Navin Soni on 24-08-2021 for future method.
    @future
    public static void updateInternationalLeadStage(Set<String> setOfIds){
        
        set<String> maxIdset = new set<String>();
        // Added by Navin Soni on 24-08-2021 for future method.
        List<Billing_Summary__c> triggerNew = [SELECT ID, name__c, alletec_billdate__c, alletec_transactiontype__c, alletec_department__c
                                               FROM Billing_Summary__c
                                               WHERE ID IN:setOfIds AND name__c != null];
        //get set of maxId from billing summary
        for (Billing_Summary__c billing : triggerNew){
            if (billing.name__c != null)
                maxIdset.add(billing.name__c);
        }
        System.debug('===maxIdset===>>>>>' + maxIdset);
        
        if (maxIdset != null && maxIdset.size() > 0){
            
            map<String, String> maxId2passportmap = new map<String, String>();
            Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getREcordTypeId();
            
            for (Account acc : [SELECT Id, Max_ID__c, Passport__c
                                from Account
                                where RecordTypeId = :recordtypeId AND Max_ID__c IN:maxIdset AND Patient_Type__c = 'International' AND Passport__c != null])
                maxId2passportmap.put(acc.Max_ID__c, acc.Passport__c);
            System.debug('===maxId2passportmap===>>>>>' + maxId2passportmap);
            
            if (maxId2passportmap != null && maxId2passportmap.size() > 0 || test.isRunningTest()){
                //Adding International Query Lead stages
                set<String> cmpLeadStagesForQuery = new set<String>();
                cmpLeadStagesForQuery.addAll(system.label.International_Query_Stage.split(';'));
                system.debug('cmpLeadStagesForQuery' + cmpLeadStagesForQuery);
                
                map<String, Lead__c> pasportnim2Lead = new map<String, Lead__c>();
                
                Id ldRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Query Management').getRecordTypeId();
                for (Lead__c lead : [SELECT Id, Name, Passport_No__c, Prospect__c, Prospect__r.Stage__c, CreatedDate, (SELECT ID, Stage__c
                                                                                                                       from Digital_Leads__r
                                                                                                                       where RecordType.Name IN ('International Query') AND Stage__c NOT IN:cmpLeadStagesForQuery)
                                     from Lead__c
                                     where RecordTypeId = :ldRecordTypeId AND Passport_No__c IN:maxId2passportmap.values() AND LeadType__c = 'International Query'])
                    pasportnim2Lead.put(lead.Passport_No__c, lead);
                System.debug('===pasportnim2Lead===>>>>>' + pasportnim2Lead);
                
                if (pasportnim2Lead != null && pasportnim2Lead.size() > 0 || test.isRunningTest()){
                    system.debug('==line849');
                    
                    list<Billing_Summary__c> listToUpdateBillingSummary = new list<Billing_Summary__c>();
                    list<Case> listToUpdatedigitalLeads = new list<Case>();
                    list<Prospect__c> listToUpsertprospects = new list<Prospect__c>();
                    list<Lead__c> listToUpdateLead = new list<Lead__c>();
                    
                    Id prospctrecordId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('International').getREcordTypeId();
                    
                    for (Billing_Summary__c billing : triggerNew){
                        if (billing.alletec_billdate__c != null && maxId2passportmap.containskey(billing.name__c)){
                            System.debug('===first===>>>>>' + maxId2passportmap.get(billing.name__c));
                            if (pasportnim2Lead.containskey(maxId2passportmap.get(billing.name__c))){
                                System.debug('===second===>>>>>' + pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)));
                                Integer daysdiff = (pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).CreatedDate.Date()).daysBetween(billing.alletec_billdate__c.Date());
                                System.debug('===daysdiff===>>>>>' + daysdiff);
                                if (daysdiff >= 0 && daysdiff <= 180){
                                    
                                    Billing_Summary__c bill = new Billing_Summary__c(Id = billing.Id);
                                    bill.Digital_Lead__c = pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Id;
                                    listToUpdateBillingSummary.add(bill);
                                    
                                    if (pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Digital_Leads__r.size() > 0){
                                        
                                        Case cs = pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Digital_Leads__r[0];
                                        cs.Stage__c = 'Query Converted';
                                        listToUpdatedigitalLeads.add(cs);
                                        
                                        Prospect__c pros = new Prospect__c();
                                        pros.RecordTypeId = prospctrecordId;
                                        pros.Name = pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Name;
                                        pros.Max_Id__c = billing.name__c;
                                        pros.Stage__c = 'New';
                                        System.debug('===pros===>>>>>' + billing.alletec_transactiontype__c);
                                        if (billing.alletec_transactiontype__c == 'OP'){
                                            System.debug('===pros===>>>>>' + billing.alletec_department__c);
                                            if (billing.alletec_department__c != null)
                                                pros.Stage__c = 'OPD Consult taken';
                                            else
                                                pros.Stage__c = 'Investigation Done';
                                        }
                                        System.debug('===pros===>>>>>' + pros);
                                        listToUpsertprospects.add(pros);
                                    } else{
                                        if (pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Prospect__c != null && pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Prospect__r.Stage__c == 'New'){
                                            System.debug('===pros===>>>>>' + billing.alletec_transactiontype__c);
                                            if (billing.alletec_transactiontype__c == 'OP'){
                                                
                                                Prospect__c pros = new Prospect__c(Id = pasportnim2Lead.get(maxId2passportmap.get(billing.name__c)).Prospect__c);
                                                if (billing.alletec_department__c != null)
                                                    pros.Stage__c = 'OPD Consult taken';
                                                else
                                                    pros.Stage__c = 'Investigation Done';
                                                System.debug('===pros===>>>>>' + pros);
                                                listToUpsertprospects.add(pros);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    System.debug('===listToUpdateBillingSummary===>>>>>' + listToUpdateBillingSummary.size());
                    System.debug('===listToUpdatedigitalLeads===>>>>>' + listToUpdatedigitalLeads.size());
                    
                    if (listToUpdateBillingSummary != null && listToUpdateBillingSummary.size() > 0)
                        update listToUpdateBillingSummary;
                    if (listToUpdatedigitalLeads != null && listToUpdatedigitalLeads.size() > 0)
                        update listToUpdatedigitalLeads;
                    System.debug('===listToUpdatedigitalLeads===>>>>>' + listToUpdatedigitalLeads);
                    
                    if (listToUpsertprospects != null && listToUpsertprospects.size() > 0){
                        
                        System.debug('===listToUpsertprospects===>>>>>' + listToUpsertprospects);
                        upsert listToUpsertprospects;
                        
                        for (Prospect__c pros : listToUpsertprospects){
                            if (maxId2passportmap.containskey(pros.Max_Id__c)){
                                System.debug('===first===>>>>>' + maxId2passportmap.get(pros.Max_Id__c));
                                if (pasportnim2Lead.containskey(maxId2passportmap.get(pros.Max_Id__c))){
                                    System.debug('===listToUpsertprospects===>>>>>' + pasportnim2Lead.get(maxId2passportmap.get(pros.Max_Id__c)).Prospect__c);
                                    if (pasportnim2Lead.get(maxId2passportmap.get(pros.Max_Id__c)).Prospect__c == null)
                                        listToUpdateLead.add(new Lead__c(Id = pasportnim2Lead.get(maxId2passportmap.get(pros.Max_Id__c)).Id, Prospect__c = pros.id));
                                }
                            }
                        }
                        System.debug('===listToUpdateLead===>>>>>' + listToUpdateLead);
                        if (listToUpdateLead != null && listToUpdateLead.size() > 0)
                            update listToUpdateLead;
                    }
                }
                
                
            }
        }
    }
    
    //Method to update lead stage to OPD CONSULT TAKEN if billing summary is generated //Trigger Setting
    Static set<Id> setBeforeRecursivecheck = new set<Id>();
    public static void updateLeadStagetoOPD(list<Billing_Summary__c> triggernew){
        Billing_Summary_Trigger__mdt triggerSetting = [SELECT Before_Update_updateLeadStagetoOPD__c
                                                       FROM Billing_Summary_Trigger__mdt
                                                       WHERE MasterLabel = 'Trigger Setting'];
        if (!triggerSetting.Before_Update_updateLeadStagetoOPD__c){
            return;
        }
        set<String> setOfMaxId = new set<String>();
        list<Billing_Summary__c> listToUpdateBillingSummary = new list<Billing_Summary__c>();
        list<lead__c> listToUpdateLeads = new list<lead__c>();
        map<String, String> mapMaxIdWithleadId = new map<String, String>();
        //get set of maxId from billing summary
        for (Billing_Summary__c BillSumm : triggerNew){
            if (setBeforeRecursivecheck.contains(BillSumm.Id))
                continue;
            if (String.isNotBlank(BillSumm.name__c)){
                setBeforeRecursivecheck.add(billSumm.Id);
                setOfMaxId.add(BillSumm.name__c);
            }
        }
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
        //update lead if maxID is not Null
        if (mapMaxIdWithleadId.keySet().size() > 0){
            for (Billing_Summary__c BillSumm : triggerNew){
                if (mapMaxIdWithleadId.containsKey(BillSumm.name__c)){
                    Billing_Summary__c bill = new Billing_Summary__c();
                    bill.Id = BillSumm.Id;
                    bill.CMP_Lead__c = mapMaxIdWithleadId.get(BillSumm.name__c);
                    listToUpdateBillingSummary.add(bill);
                }
            }
            for (String leadId : mapMaxIdWithleadId.values()){
                lead__c ld = new lead__c();
                ld.Id = leadId;
                ld.Stage__c = 'OPD Consult Taken';
                listToUpdateLeads.add(ld);
            }
        }
        
        if (listToUpdateBillingSummary.size() > 0 && listToUpdateBillingSummary != Null)
            update listToUpdateBillingSummary;
        if (listToUpdateLeads.size() > 0 && listToUpdateLeads != Null)
            update listToUpdateLeads;
    }
    
    //  //Trigger to insert/update the record in OncologyPatientJourney object
    public static void OncologyPatientJourney(List<Billing_Summary__c> triggerNew){
        
        System.debug('triggerNew >>> ' + triggerNew);
        List<Prospect__c> prospectList = new List<Prospect__c>();
        map<String, string> departmentMap = new map<String, string>();
        Set<string> departmentIdSet = new Set<string>();
        map<String, Department__c> departmentMapID = new map<String, Department__c>();
        map<String, Account> accountMap = new map<String, Account>();
        
        Set<string> accIdset = new Set<string>();
        Set<string> specilalityIdset = new Set<string>();
        Map<String, String> pMaxIds = new Map<String, String>();
        for (Billing_Summary__c bs : triggerNew){
            pMaxIds.put(bs.name__c, bs.invoicenumber__c);
        }
        Map<String, Billing_Summary__c> pMaxIdBS = new Map<String, Billing_Summary__c>();
        for (Billing_Summary__c bs : triggerNew){
            pMaxIdBS.put(bs.name__c, bs);
        }
        System.debug('Map Max Id' + pMaxIds);
        String lstopbill = '';
        String oncorecordTypeId = Schema.SObjectType.Prospect__c.getRecordTypeInfosByName().get('Onco Patient Prospect').getRecordTypeId();
        for (Prospect__c prospect : [select id, Max_Id__c, Billing_List__c, Stage__c
                                     from Prospect__c
                                     WHERE Max_Id__c IN:pMaxIds.keySet() and RecordTypeID = :oncorecordTypeId]){
                                         System.debug('Inside Prospect');
                                         if (prospect.Stage__c <> 'Treatment Completed'){
                                             
                                             lstopbill += prospect.Billing_List__c;
                                             prospect.Billing_List__c = lstopbill + ',' + pMaxIds.get(prospect.Max_Id__c);
                                             prospectList.add(prospect);
                                             
                                         }
                                     }
        System.debug('prospectList update in progress >> ' + prospectList);
        if (!prospectList.isEmpty()){
            upsert prospectList;
        }
        System.debug('update in progress >>>>>. ' + prospectList);
        for (Billing_Summary__c bs : triggerNew){
            if (bs.alletec_department__c != Null){
                departmentIdSet.add(bs.alletec_department__c);
            }
            if (bs.Patient__c != Null){
                accIdset.add(bs.Patient__c);
            }
            if (bs.alletec_speciality__c != Null){
                specilalityIdset.add(bs.alletec_speciality__c);
            }
            
        }
        
        Map<String, Speciality__c> mapHisIdToSpecializationId = new Map<String, Speciality__c>();
        for (Speciality__c spc : [SELECT Id, HIS_ID__c
                                  FROM Speciality__c
                                  where Id in:specilalityIdset]){
                                      mapHisIdToSpecializationId.put(spc.Id, spc);
                                  }
        system.debug('mapHisIdToSpecializationId' + mapHisIdToSpecializationId);
        
        
        for (Department__c department : [SELECT Id, Name, Deleted__c
                                         FROM Department__c
                                         where Id In:departmentIdSet]){
                                             departmentMap.put(department.Id, department.Name);
                                             departmentMapID.put(department.Id, department);
                                         }
        system.debug('Account Id' + departmentMap);
        for (Account acc : [Select Id, Name, Age__c, PersonMobilePhone, Gender__c, PersonEmail, Alternate_Email__c, Email_Address_2__c, Gender_HIS__c
                            from Account
                            Where Id IN:accIdset]){
                                accountMap.put(acc.Id, acc);
                            }
        List<oncology_patient_journey__c> oncologyList = new List<oncology_patient_journey__c>();
        
        for (Billing_Summary__c bs : triggerNew){
            system.debug('Department Name ' + departmentMap.get(bs.alletec_department__c));
            if (departmentMap.get(bs.alletec_department__c) == 'Oncology'){
                
                oncology_patient_journey__c onco = new oncology_patient_journey__c();
                onco.Patient_Name__c = bs.alletec_patientname__c;
                onco.Billing_Summary__c = bs.Id;
                onco.Patient_Max_id__c = bs.name__c;
                onco.Bill_No__c = bs.invoicenumber__c;
                onco.BillDate__c = bs.alletec_billdate__c;
                onco.Channel__c = bs.alletec_channeltype__c;
                onco.Total_Amount__c = bs.alletec_hisamount__c;
                onco.Stage__c = 'New';
                if (accountMap.containsKey(bs.Patient__c)){
                    
                    onco.Patient_Age__c = accountMap.get(bs.Patient__c).Age__c;
                    onco.Patient_Mobile_No__c = accountMap.get(bs.Patient__c).PersonMobilePhone;
                    onco.Patient_Gender__c = accountMap.get(bs.Patient__c).Gender__c;
                    onco.Patient_Email_id__c = accountMap.get(bs.Patient__c).Alternate_Email__c;
                    onco.Patient_Account__c = accountMap.get(bs.Patient__c).Id;
                }
                onco.Doctor_Name__c = bs.alletec_doctorname__c;
                onco.Business_Unit__c = bs.alletec_hospitallocation__c;
                if (departmentMapID.containsKey(bs.alletec_department__c)){
                    onco.Speciality__c = departmentMapID.get(bs.alletec_department__c).Id;
                }
                if (mapHisIdToSpecializationId.containsKey(bs.alletec_speciality__c)){
                    system.debug('Sub Specility ID' + mapHisIdToSpecializationId.get(bs.alletec_speciality__c).ID);
                    onco.Sub_Speciality__c = mapHisIdToSpecializationId.get(bs.alletec_speciality__c).ID;
                }
                
                oncologyList.add(onco);
            }
        }
        System.debug('oncologyList >>> ' + oncologyList);
        if (oncologyList?.size() > 0){
            insert oncologyList;
        }
        
        System.debug('oncologyList ++++ ' + oncologyList);
    }
    
}

/*
public static void checkEligiblityForMassagingPatient(List<Billing_Summary__c> triggerNew){

try{

Channel_Massaging__mdt objSetting = [SELECT channel_massaging_active__c
FROM Channel_Massaging__mdt
WHERE MasterLabel = 'Setting'];

system.debug('objSetting --> ' + objSetting);
if (objSetting.channel_massaging_active__c){

map<Id, List<Billing_Summary__c>> mapAdminAckIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
map<Id, List<Billing_Summary__c>> mapPatientIdWithBillSum = new map<Id, List<Billing_Summary__c>>();
//Set < String > setChannelName = new Set< String >{ 'PSU','Corporate' };

for (Billing_Summary__c objBillSum : triggerNew){

if (setBeforeRecursive.contains(objBillSum.Id)){
continue;
}


if (String.isNotBlank(objBillSum.alletec_channeltype__c) && objBillSum.alletec_channeltype__c.equalsIgnoreCase('PSU')){
objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
} else if (String.isNotBlank(objBillSum.alletec_channeltype__c) && objBillSum.alletec_channeltype__c.equalsIgnoreCase('Corporate')){
objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
} else if (String.isBlank(objBillSum.Admission_Acknowledgement__c) && String.isNotBlank(objBillSum.Patient__c)){

setBeforeRecursive.add(objBillSum.Id);
if (!mapPatientIdWithBillSum.containsKey(objBillSum.Patient__c))
mapPatientIdWithBillSum.put(objBillSum.Patient__c, new List<Billing_Summary__c>());
mapPatientIdWithBillSum.get(objBillSum.Patient__c).add(objBillSum);

} else if (String.isNotBlank(objBillSum.Admission_Acknowledgement__c)){

if (!mapAdminAckIdWithBillSum.containsKey(objBillSum.Admission_Acknowledgement__c))
mapAdminAckIdWithBillSum.put(objBillSum.Admission_Acknowledgement__c, new List<Billing_Summary__c>());
mapAdminAckIdWithBillSum.get(objBillSum.Admission_Acknowledgement__c).add(objBillSum);

}

}
//end of triggerNew

system.debug('setBeforeRecursive ---> ' + setBeforeRecursive);
system.debug('mapPatientIdWithBillSum ---> ' + mapPatientIdWithBillSum);
system.debug('mapAdminAckIdWithBillSum  --->  ' + mapAdminAckIdWithBillSum);

if (mapAdminAckIdWithBillSum.size() > 0){

for (Admission_Acknowledgement__c objAdminAck : [SELECT Id, pcl_markuptype__c, Patient__r.address2_country__c, MECP_Source__c
FROM Admission_Acknowledgement__c
WHERE Id IN:mapAdminAckIdWithBillSum.keySet()]){
//Channel_Name__c NOT IN : setChannelName AND

for (Billing_Summary__c objBillSum : mapAdminAckIdWithBillSum.get(objAdminAck.Id)){

system.debug('objBillSum --->' + objBillSum);
if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAdminAck.Patient__r.address2_country__c) && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('Indian') && !objAdminAck.Patient__r.address2_country__c.equalsIgnoreCase('149')) || (String.isNotBlank(objAdminAck.pcl_markuptype__c) && objAdminAck.pcl_markuptype__c.equalsIgnoreCase('is applied'))){
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
}
//end of BillSum Loop
}
//end of Admin Ack Loop

}
//end of mapAdminAckIdWithBillSum size check

//incase of bill's other than Ip where there is no Admission Ack
if (mapPatientIdWithBillSum.size() > 0){

for (Account objAcc : [SELECT Id, address2_country__c
FROM Account
WHERE Id IN:mapPatientIdWithBillSum.keySet()]){
for (Billing_Summary__c objBillSum : mapPatientIdWithBillSum.get(objAcc.Id)){

system.debug('objBillSum --->' + objBillSum);
system.debug('objAcc ---> ' + objAcc);

if (objBillSum.alletec_isinternational__c || (String.isNotBlank(objAcc.address2_country__c) && !objAcc.address2_country__c.equalsIgnoreCase('Indian') && !objAcc.address2_country__c.equalsIgnoreCase('149'))){
system.debug('Intrernational got true ');
objBillSum.alletec_isinternational__c = true;
objBillSum.R_Channel__c = 'International';

} else{

if (objBillSum.alletec_channeltype__c == 'Cash'){

objBillSum.R_Channel__c = 'Walk-In';
} else if ((objBillSum.alletec_channeltype__c == 'Walk-In' || objBillSum.alletec_channeltype__c == 'TPA')){
objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
} else{

objBillSum.R_Channel__c = objBillSum.alletec_channeltype__c;
}
}


}
}
}
//end of mapPatientIdWithBillSum size check

//----------------------------------------------------------------  Clearing Heap  ----------------------------------------------------------------------------------------------------
//  mapAdminAckIdWithBillSum = null;
// mapPatientIdWithBillSum = null;
//setChannelName = null;
}
} Catch (Exception objExcep){
system.debug(' error on massaging --> ' + objExcep.getMessage() + 'Line --- > ' + objExcep.getLineNumber());
}
}
*/
//end of checkEligiblityForMassagingPatient()
/*
//Search values based on object name and column name
//BillingSumarry Mapping On the basis of Latest Facebook lead


public static void mapBillingMappingwithFacebook(list<Billing_Summary__c> triggerNew){
Map<String,String>leadMap=new Map<String,String>();
List<Billing_Summary__c> BillingSummaryList=new List<Billing_Summary__c>();
List <Lead__c> facebookLead=[SELECT id,name,Max_ID__c from Lead__c where days__c<=180 ORDER BY CreatedDate ASC];
for(Lead__c ld:facebookLead){
leadMap.put(ld.Max_ID__c,ld.Id);
}
for(Billing_Summary__c bl:triggerNew)
{
if(leadMap.containskey(bl.name__c))
{
System.debug('leadMap.get(bl.name__c)'+leadMap.get(bl.name__c));
String temp=leadMap.get(bl.name__c);
bl.Leads__c=temp;
//BillingSummaryList.add(bl);
}
}
System.debug('BillingSummaryList'+BillingSummaryList);
System.debug('BillingSummaryList Size'+BillingSummaryList.size());
if(BillingSummaryList.size()>0)
{
update BillingSummaryList;
}
}

*/