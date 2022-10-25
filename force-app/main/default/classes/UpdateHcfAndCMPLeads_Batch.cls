/* Author:Nitya IRT
* date: 22nd Feb 2022
* Purpose: to update the existing billing summary records with autoTagging international lead issue
* To run once on Production on anonymous window
*/

global class UpdateHcfAndCMPLeads_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query=system.label.updateHcfOnInternationalBilling;
        //SELECT ID, alletec_isinternational__c, Patient__c, alletec_billdate__c, International_Status__c, Pre_Intimation_Status__c, HCF_Source__c, Tagged_Pre_Intimation__c, Auto_tagged__c, SMS_Tagged__c, Tagged_On__c, Tagged_RecordId__c, Is_Tagged_By_International_Hidden__c FROM Billing_Summary__c where HCF_source__c=null and alletec_isinternational__c=true
        //system.debug([SELECT ID, alletec_isinternational__c, Patient__c, alletec_billdate__c, International_Status__c, Pre_Intimation_Status__c, HCF_Source__c, Tagged_Pre_Intimation__c, Auto_tagged__c, SMS_Tagged__c, Tagged_On__c, Tagged_RecordId__c, Is_Tagged_By_International_Hidden__c FROM Billing_Summary__c where HCF_source__c=null and alletec_isinternational__c=true]);
        return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Billing_summary__c> bsList){
        set<id> accSet=new Set<id>();
        for(billing_summary__c bs:bsList){
            if(bs.Patient__c!=null){
                accSet.add(bs.Patient__c);
            }
        }
        date d=date.today()-90;
        system.debug(d);
        Map<Id,Account> accMap= new Map<id,Account>([Select id,alletec_patientregisterationdate__c,First_OPD_IPD_Bill_Date__c,First_OPD_IPD_Bill_No__c,
                                                     (SELECT Id,Tagged_On__c,SMS_Tagged__c,Is_Tagged_By_International_Hidden__c,Auto_tagged__c,Pre_Intimation_Status__c,International_Status__c,Tagged_Pre_Intimation__c,alletec_billdate__c,HCF_Source__c
                                                      FROM Billing_Summary_Patients__r WHERE alletec_isinternational__c=true and HCF_Source__c!=Null AND alletec_billdate__c>=:d ORDER BY alletec_billdate__c Asc),
                                                     (SELECT Id,Tagged_On__c,Is_Tagged_By_International_Hidden__c,SMS_Tagged__c,Auto_tagged__c,Pre_Intimation_Status__c,International_Status__c,Max_Id__c,HCF_Source__c,Tagged_Pre_Intimation__c,Date_Time_of_Admission__c FROM
                                                      Admission_Acknowledgements3__r WHERE HCF_Source__c!=null AND Date_Time_of_Admission__c>=:d ORDER BY Date_Time_of_Admission__c)
                                                     From Account Where  ID In:accSet]);
        system.debug(accMap);
        List<billing_summary__c> listToUpdate=new List<billing_summary__c>();
        for(billing_summary__c bs:bsList){
            if(bs.Patient__c!=null && accMap.get(bs.Patient__c).Billing_Summary_Patients__r.size()>0){ 
                Billing_Summary__c frstbill=accMap.get(bs.Patient__c).Billing_Summary_Patients__r[0]; 
                system.debug(frstbill);
                bs.International_Status__c = frstbill.International_Status__c;
                bs.Pre_Intimation_Status__c=frstbill.Pre_Intimation_Status__c;
                bs.HCF_Source__c = frstbill.HCF_Source__c;
                bs.Tagged_Pre_Intimation__c=frstbill.Tagged_Pre_Intimation__c;                            
                bs.Auto_tagged__c=true;
                bs.SMS_Tagged__c=frstbill.SMS_Tagged__c;
                if(bs.Tagged_On__c ==NULL){    
                    bs.Tagged_On__c=system.today();
                }
                bs.Tagged_RecordId__c=frstbill.id;
                bs.Is_Tagged_By_International_Hidden__c=true;
            }
            else if (accMap.get(bs.Patient__c).Admission_Acknowledgements3__r.size()>0 ){
                    Admission_Acknowledgement__c frstAck=accMap.get(bs.Patient__c).Admission_Acknowledgements3__r[0]; 
                system.debug(frstAck);
                    bs.International_Status__c = frstAck.International_Status__c;
                    bs.Pre_Intimation_Status__c=frstAck.Pre_Intimation_Status__c;
                    bs.HCF_Source__c = frstAck.HCF_Source__c;
                    bs.Tagged_Pre_Intimation__c=frstAck.Tagged_Pre_Intimation__c;                            
                    bs.Auto_tagged__c=true;
                    bs.SMS_Tagged__c=frstAck.SMS_Tagged__c;
                    if(bs.Tagged_On__c ==NULL){    
                        bs.Tagged_On__c=system.today();
                    }
                    bs.Is_Tagged_By_International_Hidden__c=true;
                    bs.Tagged_RecordId__c=frstAck.id;
                }
                
            
            listToUpdate.add(bs);
        }
        update listToUpdate;  
    }
    global void finish(Database.BatchableContext bc){
        
    }
}