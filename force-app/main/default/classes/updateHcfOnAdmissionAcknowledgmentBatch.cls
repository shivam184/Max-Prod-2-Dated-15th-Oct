/*created By:Nitya(IRT) on 1st April 2022
* to run once on production to correct auto tag issue.
*/
global class updateHcfOnAdmissionAcknowledgmentBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query=system.label.updateHcfOnAdmAck;
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Admission_acknowledgement__c> admList){
        // system.debug(admList);
        set<id> accSet=new Set<id>();
        for(Admission_acknowledgement__c adm:admList){
            if(adm.Patient__c!=null){
                accSet.add(adm.Patient__c);
            }
        }
        date d=date.today()-90;
        system.debug(d);
        Map<Id,Account> accMap= new Map<id,Account>([Select id,alletec_patientregisterationdate__c,First_OPD_IPD_Bill_Date__c,First_OPD_IPD_Bill_No__c,
                                                     (SELECT Id,Tagged_On__c,SMS_Tagged__c,Is_Tagged_By_International_Hidden__c,Auto_tagged__c,Pre_Intimation_Status__c,International_Status__c,Tagged_Pre_Intimation__c,alletec_billdate__c,HCF_Source__c
                                                      FROM Billing_Summary_Patients__r WHERE alletec_isinternational__c=true and HCF_Source__c!=Null AND alletec_billdate__c>=:d ORDER BY alletec_billdate__c desc),
                                                     (SELECT Id,Tagged_On__c,Is_Tagged_By_International_Hidden__c,SMS_Tagged__c,Auto_tagged__c,Pre_Intimation_Status__c,International_Status__c,Max_Id__c,HCF_Source__c,Tagged_Pre_Intimation__c,Date_Time_of_Admission__c FROM
                                                      Admission_Acknowledgements3__r WHERE HCF_Source__c!=null AND 
                                                      ((Tagged_Pre_Intimation__c!=null and (Pre_Intimation_Status__c = 'Pre' OR Pre_Intimation_Status__c='Post')) OR (pre_intimation_status__c='Direct' OR pre_intimation_status__c='Without Pre-Intimation')) AND Date_Time_of_Admission__c>=:d ORDER BY Date_Time_of_Admission__c)
                                                     From Account Where  ID In:accSet]);
        system.debug(accMap);
        if(accmap.Isempty())
            return;
        List<Admission_acknowledgement__c> listToUpdate=new list<Admission_acknowledgement__c>();
        for(Admission_acknowledgement__c adm:admList){
            if(adm.Patient__c!=null && accMap.containsKey(adm.patient__c) && accMap.get(adm.Patient__c).Admission_Acknowledgements3__r.size()>0 && adm.Is_Emergency__c){
                Admission_Acknowledgement__c frstAdm=accMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0];
                system.debug(frstAdm);
                adm.International_Status__c = 'Pre-Intimations ER';
                adm.Pre_Intimation_Status__c=frstAdm.Pre_Intimation_Status__c;
                adm.HCF_Source__c = frstAdm.HCF_Source__c;
                adm.Tagged_Pre_Intimation__c=frstAdm.Tagged_Pre_Intimation__c;                             
                adm.Auto_tagged__c=true;
                adm.SMS_Tagged__c=frstAdm.SMS_Tagged__c;
                if(Adm.Tagged_On__c ==NULL){    
                    adm.Tagged_On__c=system.today();
                }
                adm.Tagged_RecordId__c=frstAdm.id;
                adm.Is_Tagged_By_International_Hidden__c=true;  
            }
            else if(adm.alletec_international__c && adm.Patient__c!=null && accMap.containsKey(adm.Patient__c)){
                if(accMap.get(adm.Patient__c).Admission_Acknowledgements3__r.size()>0  && accMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0].Date_Time_of_Admission__c.date().daysBetween(adm.Date_Time_of_Admission__c.date())<=90){
                    
                    Admission_Acknowledgement__c frstAdm=accMap.get(adm.Patient__c).Admission_Acknowledgements3__r[0];  
                    adm.International_Status__c = frstAdm.International_Status__c;
                    adm.Pre_Intimation_Status__c=frstAdm.Pre_Intimation_Status__c;
                    adm.HCF_Source__c = frstAdm.HCF_Source__c;
                    adm.Tagged_Pre_Intimation__c=frstAdm.Tagged_Pre_Intimation__c;                             
                    adm.Auto_tagged__c=true;
                    adm.SMS_Tagged__c=frstAdm.SMS_Tagged__c;
                    if(Adm.Tagged_On__c ==NULL){    
                        adm.Tagged_On__c=system.today();
                    }
                    adm.Tagged_RecordId__c=frstAdm.id;
                    adm.Is_Tagged_By_International_Hidden__c=true;
                }
                else if(accMap.get(adm.Patient__c).Billing_Summary_Patients__r.size()>0 && accMap.containsKey(adm.Patient__c) && accMap.get(adm.Patient__c).Billing_Summary_Patients__r[0].alletec_billdate__c.date().daysBetween(adm.Date_Time_of_Admission__c.date())<=90){
                    billing_Summary__c frstBill=accMap.get(adm.Patient__c).billing_Summary_Patients__r[0];    
                    adm.International_Status__c = frstBill.International_Status__c;
                    adm.Pre_Intimation_Status__c=frstBill.Pre_Intimation_Status__c;
                    adm.HCF_Source__c = frstBill.HCF_Source__c;
                    adm.Tagged_Pre_Intimation__c=frstBill.Tagged_Pre_Intimation__c;                             
                    adm.Auto_tagged__c=true;
                    adm.SMS_Tagged__c=frstBill.SMS_Tagged__c;
                    if(Adm.Tagged_On__c ==NULL){    
                        adm.Tagged_On__c=system.today();
                    }
                    adm.Tagged_RecordId__c=frstBill.id;
                    adm.Is_Tagged_By_International_Hidden__c=true; 
                }
            }
            listToUpdate.add(adm);
        }
        system.debug(listToUpdate);
        update listToUpdate;
    }
    global void finish(Database.BatchableContext bc){
        
    }
}