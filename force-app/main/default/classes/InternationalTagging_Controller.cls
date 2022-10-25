public class InternationalTagging_Controller {
    
    @AuraEnabled
    public static WrapperClass fetchLead(String maxId,Date fromDateLead,Date toDateLead){
        WrapperClass wrapObj = new WrapperClass();
       // try{
            Id RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('International Tagging').getRecordTypeId();
            Id IntAckRtId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
            
            String query = 'Select Id,Lead_Channel__c,Lead_Source__c,CreatedDate,Description__c,Name,Intlr_Intimation_Date__c,Intlr_Time_formula__c';
            query += ' FROM Lead__c WHERE Lead_Channel__c = \'International\' AND (RecordType.Name = \'International Tagging\' OR (RecordType.Name = \'International Query Management\' AND VIL_Detail__c!=NULL) ) AND Pre_Intimation_Status__c = NULL AND Lead_Source__c = \'Email\'';
            
            if(fromDateLead == NULL && toDateLead == NULL)
                query += ' AND Intlr_Intimation_Date__c=LAST_N_DAYS:35';
            
            if(String.isNotBlank(maxId)){
                String val='\'%' + String.escapeSingleQuotes(maxId.trim()) + '%\'';
                query += ' AND Description__c like '+val;
                
            }
            
            if(fromDateLead != NULL) {
                //DateTime fromDateTime = DateTime.newInstanceGMT(fromDateLead.year(), fromDateLead.month(), fromDateLead.day(), 0, 0, 0);
                query += ' AND Intlr_Intimation_Date__c >= :fromDateLead';
            }
            
            if(toDateLead != NULL) {
                //DateTime toDateTime = DateTime.newInstanceGMT(toDateLead.year(), toDateLead.month(), toDateLead.day(), 0, 0, 0);
                query += ' AND Intlr_Intimation_Date__c <= :toDateLead';
            }
            
            
            query += ' ORDER BY Intlr_Intimation_Date__c DESC LIMIT 100';
            
            
            wrapObj.leadLst = database.query(query);
            
        map<string,Admission_Acknowledgement__c> mapmaxId2latestime = new map<string,Admission_Acknowledgement__c>();
        Boolean isupdate = true;
        for(Admission_Acknowledgement__c ad : [SELECT Id,Max_ID__c,OPID__c,Tagging_Availability__c,IPID__c,Patient_Name__c,alletec_speciality__c, alletec_speciality__r.Name, Doctor_Name__c,Last_OPD_Speciality__r.Name,Patient__c,Patient__r.alletec_patientregisterationdate__c,
                                               Date_Time_of_Admission__c,Date_of_Discharge__c,Transaction_Type__c,OP_Transaction_Type__c,HCF_Source__c,HCF_Source__r.Name, Sub_Speciality__c, Sub_Speciality__r.Name
                                               FROM Admission_Acknowledgement__c
                                               WHERE RecordtypeId=:IntAckRtId And
                                               HCF_Source__c = NULL 
                                               AND Patient__c !=NULL
                                               AND (Channel_Name__c='International' or 
                                                    SMS_Tagged__c = false or pcl_markuptype__c!=null)
                                               ORDER BY Date_Time_of_Admission__c DESC LIMIT 50]){

                                                   isupdate = false;
                                                   if(ad.Tagging_Availability__c==true)
                                                       isupdate = true;
                                                   else if(ad.Date_Time_of_Admission__c !=null && ad.Date_of_Discharge__c== NULL)
                                                       isupdate = true;
                                                   else if(ad.Date_of_Discharge__c!=null){ 
                                                       Date NextMonthDate = Date.valueof(ad.Date_of_Discharge__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4); 
                                                       if(NextMonthDate !=NULL && system.today()<=NextMonthDate)                            
                                                           isupdate = true;
                                                   }
                                                   if(isupdate){
                                                       if(mapmaxId2latestime.containskey(ad.Max_ID__c)){ 
                                                           if(mapmaxId2latestime.get(ad.Max_ID__c).Date_Time_of_Admission__c > ad.Date_Time_of_Admission__c)
                                                               mapmaxId2latestime.remove(ad.Max_ID__c);
                                                           else
                                                               isupdate = false;
                                                       }
                                                   }
                                                   if(isupdate)
                                                       mapmaxId2latestime.put(ad.Max_ID__c,ad);
                                               }
        isupdate = true;
        Set<String> transactionType = new Set<String>();
        transactionType.addAll(label.Internation_transaction_types.split(';'));
        map<string,Billing_Summary__c> mapmaxId2billingsummary = new map<string,Billing_Summary__c>();
        Boolean isadd = true;
        for(Billing_Summary__c bill : [Select Id,Name,Treating_Doctor__c,Tagging_Availability__c,Treating_Doctor__r.Name,alletec_billdate__c,HCF_Source__c,HCF_Source__r.Name,Patient__r.alletec_patientregisterationdate__c,OP_Transaction_Type__c,
                                       alletec_ipid__c,name__c,alletec_op__c,Patient__c,Patient__r.Name,alletec_department__c,alletec_department__r.Name,alletec_transactiontype__c,alletec_dateofadmission__c 
                                       From Billing_Summary__c 
                                       Where alletec_isinternational__c=True 
                                       AND alletec_transactiontype__c IN:transactionType 
                                       AND HCF_Source__c = NULL 
                                       AND Patient__c !=NULL
                                       AND (SMS_Tagged__c=false OR alletec_preadmitno__c!=null)
                                       LIMIT 50]){
                                           isupdate = false;
                                           isadd = false;
                                           if(bill.Tagging_Availability__c==true){
                                               isupdate = true;
                                           }
                                           else if(bill.alletec_dateofadmission__c !=NULL && bill.alletec_billdate__c ==NULL){
                                               isupdate = true;
                                           }
                                           else if(bill.alletec_billdate__c!=null){
                                               Date NextMonthDt = Date.valueof(bill.alletec_billdate__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4);                        
                                               if(system.today()<=NextMonthDt)                            
                                                   isupdate = true;
                                           }
                                           if(isupdate){
                                               if(mapmaxId2latestime.containskey(bill.name__c)){
                                                   if(mapmaxId2latestime.get(bill.name__c).Date_Time_of_Admission__c > bill.alletec_billdate__c){
                                                       mapmaxId2latestime.remove(bill.name__c);
                                                       isadd = true; 
                                                   }else
                                                       isadd = false; 
                                               }else if(mapmaxId2billingsummary.containskey(bill.name__c)){
                                                   if(mapmaxId2billingsummary.get(bill.name__c).alletec_billdate__c > bill.alletec_billdate__c){
                                                       mapmaxId2billingsummary.remove(bill.name__c);
                                                       isadd = true; 
                                                   }else
                                                       isadd = false; 
                                               }else
                                                   isadd = true;
                                           }
                                          
                                           if(isadd)
                                               mapmaxId2billingsummary.put(bill.name__c,bill);
                                       }
        
        wrapObj.acknowledgeList.addall(mapmaxId2latestime.values());
        wrapObj.opTransacList.addall(mapmaxId2billingsummary.values());
         
            wrapObj.status = 'SUCCESS';
            
            return wrapObj;
       // }
       // catch(Exception e){
         //   wrapObj.status = e.getMessage()+' at Line '+e.getLineNumber();
           // system.debug('error occured---->'+e.getMessage());
         //   return wrapObj;
       // }
    }
    
    @AuraEnabled

    public static WrapperClass doSearchAckOpApex(String patName, String ipid, String maxid, Boolean isTagged){
        WrapperClass wrapObj = new WrapperClass();
        Id IntAckRtId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
        Set<String> transactionType = new Set<String>();
        

        transactionType.addAll(label.Internation_transaction_types.split(';'));
        
        //Admission Query 
        String admissionQuery = 'SELECT Id,Max_ID__c,OPID__c,Tagging_Availability__c,Date_of_Discharge__c,IPID__c,Patient_Name__c,alletec_speciality__c, alletec_speciality__r.Name,Doctor_Name__c,Last_OPD_Speciality__r.Name,OP_Transaction_Type__c,Date_Time_of_Admission__c,Transaction_Type__c ,Patient__r.alletec_patientregisterationdate__c FROM Admission_Acknowledgement__c';
        admissionQuery+=' WHERE RecordtypeId=:IntAckRtId';
        
        //Billing Query 
        String billingQuery = 'Select Id,Name,Treating_Doctor__c,Tagging_Availability__c,Treating_Doctor__r.Name,alletec_billdate__c,HCF_Source__c,HCF_Source__r.Name,Patient__r.alletec_patientregisterationdate__c,OP_Transaction_Type__c,alletec_ipid__c,name__c,alletec_op__c,Patient__c,Patient__r.Name,alletec_department__c,alletec_department__r.Name,alletec_transactiontype__c,alletec_dateofadmission__c From Billing_Summary__c';
        billingQuery+=' WHERE alletec_isinternational__c=True';
        
        
        
        
        if(!isTagged){
            admissionQuery+=' AND HCF_Source__c=NULL AND Patient__c !=NULL AND (Channel_Name__c=\'International\' or SMS_Tagged__c = false or pcl_markuptype__c!=null)';
            billingQuery+=' AND HCF_Source__c=NULL AND Patient__c !=NULL AND alletec_transactiontype__c IN:transactionType AND (SMS_Tagged__c=false OR alletec_preadmitno__c!=null)';
        }else{
            admissionQuery+=' AND HCF_Source__c!=null';
            billingQuery+=' AND HCF_Source__c!=NULL';
        }
        
        
        if(String.isNotBlank(patName)){
            String val='\'%' + String.escapeSingleQuotes(patName) + '%\'';
            admissionQuery+=' AND Patient_Name__c like '+val;
            billingQuery+=' AND Patient__r.Name like '+val;
        }
        if(String.isNotBlank(ipid)){
            admissionQuery+=' AND IPID__c =:ipid';
            billingQuery+=' AND alletec_ipid__c =:ipid';
        }
        if(String.isNotBlank(maxid)){
            admissionQuery+=' AND Max_ID__c =:maxid';
            billingQuery+=' AND name__c =:maxid';
        }
        
        
        admissionQuery+=' ORDER BY Date_Time_of_Admission__c DESC LIMIT 50';
        billingQuery+=' ORDER BY alletec_billdate__c DESC LIMIT 50';
        
                    system.debug('=====>admissionQuery='+admissionQuery);
                    system.debug('=====>billingQuery='+billingQuery);

/********************************************************************************/
       
        map<string,Admission_Acknowledgement__c> mapmaxId2admission = new map<string,Admission_Acknowledgement__c>();
        Boolean isupdate = true;
        for(Admission_Acknowledgement__c ad : Database.query(admissionQuery)){
            
            isupdate = false;
            if(ad.Tagging_Availability__c==true)
                isupdate = true;
            else if(ad.Date_Time_of_Admission__c !=null && ad.Date_of_Discharge__c== NULL)
                isupdate = true;
            else if(ad.Date_of_Discharge__c!=null){ 
                Date NextMonthDate = Date.valueof(ad.Date_of_Discharge__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4); 
                if(NextMonthDate !=NULL && system.today()<=NextMonthDate)                            
                    isupdate = true;
            }
            if(isupdate){
                if(mapmaxId2admission.containskey(ad.Max_ID__c)){ 
                    if(mapmaxId2admission.get(ad.Max_ID__c).Date_Time_of_Admission__c > ad.Date_Time_of_Admission__c)
                        mapmaxId2admission.remove(ad.Max_ID__c);
                    else
                        isupdate = false;
                }
            }
            if(isupdate)
                mapmaxId2admission.put(ad.Max_ID__c,ad);
        }
        
        map<string,Billing_Summary__c> mapmaxId2billingsummary = new map<string,Billing_Summary__c>();
        isupdate = true;
        Boolean isadd = true;
        for(Billing_Summary__c bill : Database.query(billingQuery)){
            isupdate = false;
            isadd = false;
            if(bill.Tagging_Availability__c==true){
                isupdate = true;
            }
            else if(bill.alletec_dateofadmission__c !=NULL && bill.alletec_billdate__c ==NULL){
                isupdate = true;
            }
            else if(bill.alletec_billdate__c!=null){
                Date NextMonthDt = Date.valueof(bill.alletec_billdate__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4);                        
                if(system.today()<=NextMonthDt)                            
                    isupdate = true;
            }
            if(isupdate){
                if(mapmaxId2admission.containskey(bill.name__c)){
                    if(mapmaxId2admission.get(bill.name__c).Date_Time_of_Admission__c > bill.alletec_billdate__c){
                        mapmaxId2admission.remove(bill.name__c);
                        isadd = true; 
                    }else
                        isadd = false; 
                }else if(mapmaxId2billingsummary.containskey(bill.name__c)){
                    if(mapmaxId2billingsummary.get(bill.name__c).alletec_billdate__c > bill.alletec_billdate__c){
                        mapmaxId2billingsummary.remove(bill.name__c);
                        isadd = true; 
                    }else
                        isadd = false; 
                }else
                    isadd = true;
            }
            
            if(isadd)
                mapmaxId2billingsummary.put(bill.name__c,bill);
        }
        wrapObj.acknowledgeList.addall(mapmaxId2admission.values());
        wrapObj.opTransacList.addall(mapmaxId2billingsummary.values());
        wrapObj.status = 'SUCCESS';
        return wrapObj;
    }
    
    
    @AuraEnabled
    public static String doTagWithSMSApex(String selectedLeadId, String selectedAdmissionId, String selectedMecpSource ) { 
        List<Admission_Acknowledgement__c> AckToupdate = new List<Admission_Acknowledgement__c>();
        List<Billing_Summary__c> BillingToUpdate = new List<Billing_Summary__c>();
        String ackPrefix = Schema.getGlobalDescribe().get('Admission_Acknowledgement__c').getDescribe().getKeyPrefix();
        String BillingPrefix = Schema.getGlobalDescribe().get('Billing_Summary__c').getDescribe().getKeyPrefix(); 
        List<Lead__c> LeadList;
        Admission_Acknowledgement__c Ack ;
        Billing_Summary__c Bill ;
        String AckPatient;
        DateTime regDate;
        DateTime refDate;
        DateTime LeadDate;
        //To check the record of Admission or Billing
        boolean isAck;
        list<Billing_Summary__c> billList;
        if(String.isNotBlank(selectedLeadId)){
            LeadList = [SELECT Id,CreatedDate,Pre_Intimation_Status__c,Intlr_Intimation_Date__c,Intlr_Intimation_Time__c FROM Lead__c Where Id =:selectedLeadId];            
            LeadDate =  DateTime.newInstanceGMT(LeadList[0].Intlr_Intimation_Date__c, LeadList[0].Intlr_Intimation_Time__c);       
            //Pre Intimation Date
        }
        List<Account> pt; 
        if(String.isNotBlank(selectedAdmissionId) && selectedAdmissionId!=null){
            //Getting referencedate of billing or admission accordingly
            if(ackPrefix == selectedAdmissionId.subString(0,3)){
                isAck = true;
                Ack = [Select Id,CreatedDate, Date_of_Discharge__c,Name,Date_Time_of_Admission__c,Pre_Intimation_Status__c,International_Status__c,
                       Is_Emergency__c,Is_Tagged_By_International_Hidden__c,
                       Tagged_Pre_Intimation__c,SMS_Tagged__c,HCF_Source__c,Patient__r.alletec_patientregisterationdate__c,
                       Sub_Speciality__c, Sub_Speciality__r.Name
                       From Admission_Acknowledgement__c Where Id=:selectedAdmissionId]; 
                refDate=Ack.Date_Time_of_Admission__c;
                Ack.HCF_Source__c = selectedMecpSource;
                Ack.Tagged_Pre_Intimation__c=selectedLeadId;
                Ack.Tagged_On__c=system.today();
                AckPatient=Ack.Patient__c;
                Ack.Is_Tagged_By_International_Hidden__c=true;
                regDate=Ack.Patient__r.alletec_patientregisterationdate__c.addHours(5).addMinutes(30);                
            }
            else{
                isAck= false;
                Bill = [Select Id,alletec_dateofadmission__c,Is_Emergency__c,CreatedDate,Tagged_Pre_Intimation__c,Pre_Intimation_Status__c,
                        SMS_Tagged__c,HCF_Source__c,Patient__r.alletec_patientregisterationdate__c,International_Status__c,
                        Patient__c,alletec_billdate__c From Billing_Summary__c Where Id=:selectedAdmissionId]; 
                refDate=Bill.alletec_billdate__c;
                Bill.HCF_Source__c = selectedMecpSource;
                Bill.Tagged_Pre_Intimation__c=selectedLeadId;
                Bill.Tagged_On__c=system.today();
                AckPatient=Bill.Patient__c;
                Bill.Is_Tagged_By_International_Hidden__c=true;
                regDate=Bill.Patient__r.alletec_patientregisterationdate__c.addHours(5).addMinutes(30);
            }
            pt= [SELECT id,First_OPD_IPD_Bill_Date__c,First_OPD_IPD_Bill_No__c FROM Account where id=:AckPatient];
            
            //1
            
            //Checking the referencedate with patient registration date
            //Admission date or billing date difference registration date by 90 days
 
            if(regDate!=null && refDate!=null && regDate.date().daysBetween(refDate.date())<=90){
                
                //Checking the pre intimation date with registration date
                // IF Registration date is> PreIntimation date=pre
                if(regDate>LeadDate){  
                    if(isAck){
                        Ack.Pre_Intimation_Status__c='Pre';
                        Ack.Is_Tagged_By_International_Hidden__c=true;
                        Ack.SMS_Tagged__c=true;
                        Ack.Tagged_On__c=system.today();
                        if(Ack.Is_Emergency__c){
                            Ack.International_Status__c='Pre-Intimations ER';
                        }else{
                            Ack.International_Status__c='Pre-Intimations';
                        }                        
                    }
                    else{
                        Bill.Pre_Intimation_Status__c='Pre';
                        Bill.Is_Tagged_By_International_Hidden__c=true;
                        Bill.SMS_Tagged__c=true;
                        Bill.Tagged_On__c=system.today();
                        if(Bill.Is_Emergency__c){
                            Bill.International_Status__c='Pre-Intimations ER';
                        }else{
                            Bill.International_Status__c='Pre-Intimations';
                        }                        
                    }
                    if(LeadList.size()>0){
                        LeadList[0].Pre_Intimation_Status__c='Pre'; 
                    }
                }
                // IF Registration date is< PreIntimation date=post
                else{
                    if(isAck){
                       // system.debug('====>464===');
                        Ack.Pre_Intimation_Status__c='Post';
                        Ack.Is_Tagged_By_International_Hidden__c=true;
                        Ack.Tagged_On__c=system.today();
                        Ack.SMS_Tagged__c=true; 
                        if(Ack.Is_Emergency__c){
                            Ack.International_Status__c='Pre-Intimations ER';
                        }else{
                            Ack.International_Status__c='Pre-Intimations';
                        }
                    }
                    else{
                        Bill.Pre_Intimation_Status__c='Post';
                        Bill.Is_Tagged_By_International_Hidden__c=true;
                        Bill.Tagged_On__c=system.today();
                        Bill.SMS_Tagged__c=true;
                        if(Bill.Is_Emergency__c){
                            Bill.International_Status__c='Pre-Intimations ER';
                        }else{
                            Bill.International_Status__c='Pre-Intimations';
                        } 
                    }
                    if(LeadList.size()>0){
                        LeadList[0].Pre_Intimation_Status__c='Post'; 
                    } 
                }
            }
       
            //
            //Admission date or billing date difference registration date more than 90 days
            else{
                
                billList=[Select Id,alletec_dateofadmission__c,Is_Emergency__c,Admission_Acknowledgement__c,CreatedDate,Tagged_Pre_Intimation__c,Pre_Intimation_Status__c,
                          SMS_Tagged__c,HCF_Source__c,Patient__r.alletec_patientregisterationdate__c,invoicenumber__c,
                          alletec_billdate__c From Billing_Summary__c Where Patient__c=:AckPatient AND alletec_billdate__c!=null AND alletec_billdate__c <=: refDate AND alletec_billdate__c=LAST_90_DAYS  
                          ORDER BY alletec_billdate__c ASC limit 1];
                //if one or more billing found in last 90 days 
                if(billList !=NULL && billList.size()>0){
                    pt[0].First_OPD_IPD_Bill_No__c=billList[0].invoicenumber__c;
                    pt[0].First_OPD_IPD_Bill_Date__c=billList[0].alletec_billdate__c;
                    // bill date > pre intimation date
                    if(billList[0].alletec_billdate__c.addHours(5).addMinutes(30)>LeadDate){
                        if(isAck){
                            Ack.Pre_Intimation_Status__c='Pre';
                            Ack.Is_Tagged_By_International_Hidden__c=true;
                            Ack.SMS_Tagged__c=true;
                            Ack.International_Status__c = 'OP/IP Episode';  
                            Ack.Tagged_On__c=system.today();
                        }
                        else{
                            Bill.Pre_Intimation_Status__c='Pre';
                            Bill.Is_Tagged_By_International_Hidden__c=true;
                            Bill.SMS_Tagged__c=true;
                            Bill.International_Status__c = 'OP/IP Episode';   
                            Bill.Tagged_On__c=system.today();
                        }
                        if(LeadList.size()>0){
                            LeadList[0].Pre_Intimation_Status__c='Pre'; 
                        }
                        
                    }
                    // bill date < pre intimation date
                    else{
                        if(isAck){
                            Ack.Pre_Intimation_Status__c='Post';
                            Ack.Is_Tagged_By_International_Hidden__c=true;
                            Ack.SMS_Tagged__c=true;
                            Ack.International_Status__c = 'OP/IP Episode';   
                            Ack.Tagged_On__c=system.today();
                        }
                        else{
                            Bill.Pre_Intimation_Status__c='Post';
                            Bill.Is_Tagged_By_International_Hidden__c=true;
                            Bill.SMS_Tagged__c=true;
                            Bill.Tagged_On__c=system.today();
                            Bill.International_Status__c = 'OP/IP Episode';
                        }
                        if(LeadList.size()>0){
                            LeadList[0].Pre_Intimation_Status__c='Post'; 
                        }                         
                    }      
                }
                
                //3
                //if no billing found in last 90 days 
                
                else{
                    //admission or billind date> pre intimation
                    if(refDate> LeadDate){
                        if(isAck){
                            Ack.Pre_Intimation_Status__c='Pre';
                            Ack.Is_Tagged_By_International_Hidden__c=true;
                            Ack.SMS_Tagged__c=true;
                            Ack.Tagged_On__c=system.today();
                            if(Ack.Is_Emergency__c){
                                Ack.International_Status__c='Pre-Intimations ER';
                            }else{
                                Ack.International_Status__c='Pre-Intimations';
                            }
                            
                        }
                        else{
                            Bill.Pre_Intimation_Status__c='Pre';
                            Bill.Is_Tagged_By_International_Hidden__c=true;
                            Bill.SMS_Tagged__c=true;
                            Bill.Tagged_On__c=system.today();
                            if(Bill.Is_Emergency__c){
                                Bill.International_Status__c='Pre-Intimations ER';
                            }else{
                                Bill.International_Status__c='Pre-Intimations';
                            }                        
                        }
                        if(LeadList.size()>0){
                            LeadList[0].Pre_Intimation_Status__c='Pre'; 
                        }
                    }
                    //admission or billind date<current date
                    else{
                        if(isAck){
                            Ack.Pre_Intimation_Status__c='Post';
                            Ack.Is_Tagged_By_International_Hidden__c=true;
                            Ack.SMS_Tagged__c=true;
                            Ack.Tagged_On__c=system.today();
                            if(Ack.Is_Emergency__c){
                                Ack.International_Status__c='Pre-Intimations ER';
                            }else{
                                Ack.International_Status__c='Pre-Intimations';
                            } 
                        }
                        else{
                            Bill.Pre_Intimation_Status__c='Post';
                            Bill.Is_Tagged_By_International_Hidden__c=true;
                            Bill.SMS_Tagged__c=true;
                            Bill.Tagged_On__c=system.today();
                            if(Bill.Is_Emergency__c){
                                Bill.International_Status__c='Pre-Intimations ER';
                            }else{
                                Bill.International_Status__c='Pre-Intimations';
                            } 
                        }
                        if(LeadList.size()>0){
                            LeadList[0].Pre_Intimation_Status__c='Post'; 
                        } 
                    }
                }
            }
            Date referenceDate;
            if(isAck){
                AckToupdate.add(ack);
                
                //referenceDate = Ack.CreatedDate.date();
                referenceDate=Ack.Date_Time_of_Admission__c.date();
            }
            else{
                //referenceDate = Bill.CreatedDate.date();
                if(Bill.alletec_billdate__c!=null)
                referenceDate = Bill.alletec_billdate__c.date();

                BillingToUpdate.add(Bill);
            }
            
            
            for(Billing_Summary__c adm  : [SELECT Id,CreatedDate,alletec_billdate__c,HCF_Source__c,Is_Emergency__c,SMS_Tagged__c,Tagged_Pre_Intimation__c FROM Billing_Summary__c 
                                           WHERE Patient__c=:AckPatient and HCF_Source__c=null
                                           AND alletec_isinternational__c=true
                                           AND alletec_billdate__c >=:referenceDate]){
                                               Date dt; 
                                               if(adm.alletec_billdate__c!=null)
                                               dt=adm.alletec_billdate__c.date();
                                               //if(dt>=referenceDate && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId){
                                               
                                               if((referenceDate!=null && referenceDate.daysBetween(dt)<=90 && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId)  
                                                  && (dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId)){
                                                   if(isAck){
                                                       adm.International_Status__c = Ack.International_Status__c;
                                                       adm.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                       
                                                   }
                                                   else if(!isAck){                                                   
                                                       adm.International_Status__c = Bill.International_Status__c;
                                                       adm.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                       
                                                   }
                                                   adm.HCF_Source__c = selectedMecpSource;
                                                   adm.Tagged_Pre_Intimation__c=selectedLeadId;
                                                   adm.SMS_Tagged__c = true; 
                                                   if(Bill!=NULL && adm.id!=Bill.Id){   
                                                   adm.Auto_tagged__c=true;
                                                   }
                                                   adm.Tagged_On__c=system.today();
                                                   adm.Is_Tagged_By_International_Hidden__c=true;
                                                   BillingToUpdate.add(adm);
                                               }
                                              
                                           }
            
            for(Admission_Acknowledgement__c adm : [SELECT Id,CreatedDate,Date_Time_of_Admission__c,HCF_Source__c,Tagged_Pre_Intimation__c,Is_Tagged_By_International_Hidden__c,International_Status__c
                                                    FROM Admission_Acknowledgement__c WHERE Recordtype.Name=:'International' 
                                                    and Patient__c=:AckPatient and HCF_Source__c=null
                                                    AND Date_Time_of_Admission__c >=:referenceDate]){
                                                       //Date dt = adm.CreatedDate.date();  
                                                       Date dt = adm.Date_Time_of_Admission__c.date();                                       
                                     
                                                      // if(/*dt>=referenceDate*/ dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId)
                                                       if((referenceDate!=null && referenceDate.daysBetween(dt)<=90 && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId)  
                                                          && (dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null && adm.Id!=selectedAdmissionId)){
                                                              if(isAck){
                                                                  adm.International_Status__c = Ack.International_Status__c;
                                                                  adm.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                              }
                                                              else if(!isAck){                                                   
                                                                  adm.International_Status__c = Bill.International_Status__c;
                                                                  adm.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                              }
                                                              adm.HCF_Source__c = selectedMecpSource;
                                                              adm.Tagged_Pre_Intimation__c=selectedLeadId;
                                                              adm.SMS_Tagged__c = true;                                                  
                                                              adm.Auto_tagged__c=true;
                                                              adm.Is_Tagged_By_International_Hidden__c=true;
                                                              adm.Tagged_On__c=system.today();
                                                              AckToupdate.add(adm);
                                                          }
                                                   }
            
            
        }
        try{
            AvoidRecursion.firstRun = false;
            if(LeadList.size()>0){
                Update LeadList; 
            }
            if(pt!=null && pt.size()>0)
                update pt;
            if(AckToupdate.size()>0){
                Update AckToupdate;
            }
            if(BillingToUpdate.size()>0){
                Update BillingToUpdate;
            }
            return 'SUCCESS';
            
            
        }catch(DMLException e){
            return e.getMessage();
        }
        
        
    }        
    
    @auraEnabled
    public static WrapperClass getTaggedApex(){
        WrapperClass wrapObj = new WrapperClass();
        try{
            List<Lead__c> leadList = [SELECT Id,Lead_Channel__c,Lead_Source__c,CreatedDate,Description__c,Name 
                                      FROM Lead__c
                                      WHERE Lead_Channel__c='International' AND 
                                      RecordType.Name='International Tagging' AND 
                                      Lead_Source__c='Email' AND 
                                      Pre_Intimation_Status__c != NULL AND createddate=LAST_N_DAYS:30 LIMIT 100];
            
            if(leadList != NULL && leadList.size() >0 )
                wrapObj.leadLst = leadList;
            
            Id IntAckRtId = Schema.SObjectType.Admission_Acknowledgement__c.getRecordTypeInfosByName().get('International').getRecordTypeId();
            List<Admission_Acknowledgement__c> ackledgList = [SELECT Id,Max_ID__c,OPID__c,Date_of_Discharge__c,IPID__c,Patient_Name__c,alletec_speciality__c, alletec_speciality__r.Name,Doctor_Name__c,Last_OPD_Speciality__r.Name,Patient__c,Patient__r.alletec_patientregisterationdate__c,
                                                              Date_Time_of_Admission__c,Transaction_Type__c,OP_Transaction_Type__c,Sub_Speciality__c, Sub_Speciality__r.Name,HCF_Source__c,HCF_Source__r.Name
                                                              FROM Admission_Acknowledgement__c
                                                              WHERE Channel_Name__c='International' AND 
                                                              RecordtypeId=:IntAckRtId and HCF_Source__c!=null LIMIT 100];
            
            List<Admission_Acknowledgement__c> ackList = new List<Admission_Acknowledgement__c>();
            if(ackledgList != NULL && ackledgList.size()>0)                
                for(Admission_Acknowledgement__c ack : ackledgList){                      
                    if(ack.Date_of_Discharge__c!=null){                           
                        Date NextMonthDate = Date.valueof(ack.Date_of_Discharge__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4);                        
                        if(system.today()<=NextMonthDate){ 
                            ack.Re_Tagged__c=true;
                            ack.Tagged_On__c=system.today();
                            ackList.add(ack);
                        }
                    }
                }           
            if(ackList.size()>0){
                wrapObj.acknowledgeList = ackList;   
            }                                                      
            
            
            Set<String> transactionType = new Set<String>();
            transactionType.addAll(label.Internation_transaction_types.split(';'));
            List<Billing_Summary__c> BillingSummList = [Select Id,Name,Treating_Doctor__c,Treating_Doctor__r.Name,alletec_billdate__c,HCF_Source__c,HCF_Source__r.Name,Patient__r.alletec_patientregisterationdate__c,OP_Transaction_Type__c,
                                                        alletec_ipid__c,name__c,alletec_op__c,Patient__c,Patient__r.Name,alletec_department__c,alletec_department__r.Name,alletec_transactiontype__c,alletec_dateofadmission__c 
                                                        From Billing_Summary__c WHERE alletec_isinternational__c=True AND HCF_Source__c!=NULL AND (alletec_transactiontype__c IN:transactionType OR alletec_preadmitno__c!=null) LIMIT 100]; 
            
            List<Billing_Summary__c> BillingList = new List<Billing_Summary__c>();
            if(BillingSummList != NULL && BillingSummList.size()>0)
                for(Billing_Summary__c bs : BillingSummList){
                    if(bs.alletec_billdate__c!=null){
                        Date NextMonthDt = Date.valueof(bs.alletec_billdate__c).addmonths(Integer.valueOf(label.International_Add_Days)).toStartOfMonth().adddays(4);                        
                        if(system.today()<=NextMonthDt){  
                            bs.Tagged_On__c=system.today();
                            BillingList.add(bs);
                        }
                    }
                }
            if(BillingList.size()>0){
                wrapObj.opTransacList = BillingList;
            }           
            wrapObj.status = 'SUCCESS';
            return wrapObj;
            
        }catch(Exception e){
            wrapObj.status = e.getMessage()+' at line '+e.getLineNumber();
            system.debug('-error occured--'+e.getMessage());
            return wrapObj;
        }
    }
    
    @auraEnabled
    public static String TagWithOutSMSApex(String admaAckOpTransId, string HCFId, string Rmrk){ 
        List<Admission_Acknowledgement__c> AckToupdate = new List<Admission_Acknowledgement__c>();
        List<Billing_Summary__c> BillingToUpdate = new List<Billing_Summary__c>();
        String ackPrefix = Schema.getGlobalDescribe().get('Admission_Acknowledgement__c').getDescribe().getKeyPrefix();
        String BillingPrefix = Schema.getGlobalDescribe().get('Billing_Summary__c').getDescribe().getKeyPrefix(); 
        Admission_Acknowledgement__c Ack ;
        Billing_Summary__c Bill ;
        boolean isAck;
        String AckPatient;
        if(admaAckOpTransId!=null && HCFId!=null){
            if(ackPrefix == admaAckOpTransId.subString(0,3)){
                isAck=true;
                Ack=[SELECT Id,CreatedDate,Patient__c,Date_Time_of_Admission__c,International_Status__c,Auto_Tagged__c,Pre_Intimation_Status__c,HCF_Source__c,Remarks__c,SMS_Tagged__c,Is_Emergency__c,Is_Tagged_By_International_Hidden__c 
                     FROM Admission_Acknowledgement__c 
                     WHERE Id=:admaAckOpTransId];
                
                Ack.Pre_Intimation_Status__c='Without Pre-Intimation';
                Ack.International_Status__c='Without Pre-Intimation';
                Ack.Auto_Tagged__c=false;
                Ack.SMS_Tagged__c=false;
                Ack.Is_Tagged_By_International_Hidden__c=true;
                Ack.HCF_Source__c=HCFId;
                Ack.Tagged_On__c=system.today();
                AckPatient=Ack.Patient__c;
                if(Rmrk!=null){
                    Ack.Remarks__c=Rmrk;
                }
                
            }
            else{
                isAck= false;
                Bill=[Select Id,CreatedDate,Patient__c,alletec_billdate__c,Pre_Intimation_Status__c,International_Status__c,Is_Tagged_By_International_Hidden__c,Auto_Tagged__c,HCF_Source__c,Remark__c,SMS_Tagged__c 
                      From Billing_Summary__c 
                      Where Id=:admaAckOpTransId];
                
                Bill.Pre_Intimation_Status__c='Without Pre-Intimation';
                Bill.International_Status__c='Without Pre-Intimation';
                Bill.Auto_Tagged__c=false;
                Bill.SMS_Tagged__c=false;
                Bill.Is_Tagged_By_International_Hidden__c=true;
                Bill.HCF_Source__c=HCFId;
                AckPatient=Bill.Patient__c;
                Bill.Tagged_On__c=system.today();
                if(Rmrk!=null){
                    Bill.Remark__c=Rmrk;
                }
            }
            Date referenceDate;
            if(isAck){
                AckToupdate.add(Ack);
                referenceDate=Ack.Date_Time_of_Admission__c.date();
                //referenceDate = Ack.CreatedDate.date();
                
            }
            else{
                BillingToUpdate.add(Bill);
                referenceDate = Bill.alletec_billdate__c.date();
                //referenceDate = Bill.CreatedDate.date();
                
            }
          
            //auto tagging
            for(Admission_Acknowledgement__c adm : [SELECT Id,CreatedDate,Date_Time_of_Admission__c,
                                                    International_Status__c,SMS_Tagged__c,Auto_tagged__c,Remarks__c,
                                                    Pre_Intimation_Status__c,HCF_Source__c,Is_Tagged_By_International_Hidden__c
                                                    FROM Admission_Acknowledgement__c 
                                                    WHERE Recordtype.Name=:'International' 
                                                    AND Patient__c=:AckPatient
                                                    AND HCF_Source__c=null 
                                                    AND Id!=:admaAckOpTransId
                                                   AND Date_Time_of_Admission__c >=:referenceDate]){
                                                        Date dt = adm.Date_Time_of_Admission__c.date(); 
                                                        //if(dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null)
                                                        if((referenceDate.daysBetween(dt)<=90 && adm.HCF_Source__c==null)  
                                                           && (dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null)) {
                                                               if(isAck){
                                                                adm.International_Status__c = Ack.International_Status__c;
                                                                adm.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                            }
                                                            else if(!isAck){                                                   
                                                                adm.International_Status__c = Bill.International_Status__c;
                                                                adm.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                            }
                                                            adm.HCF_Source__c = HCFId;
                                                            adm.SMS_Tagged__c = false;                                                  
                                                            adm.Auto_tagged__c=true;
                                                            adm.Tagged_On__c=system.today();
                                                            adm.Is_Tagged_By_International_Hidden__c=true;
                                                            if(Rmrk!=null){
                                                                adm.Remarks__c=Rmrk;
                                                            }
                                                            
                                                            AckToupdate.add(adm);
                                                        }
                                                        
                                                    }
            for(Billing_Summary__c bsum : [SELECT Id,CreatedDate,alletec_billdate__c,Pre_Intimation_Status__c,HCF_Source__c,Remark__c 
                                           FROM Billing_Summary__c
                                           WHERE Patient__c=:AckPatient
                                           AND HCF_Source__c=null
                                           AND alletec_isinternational__c=true 
                                           AND Id!=:admaAckOpTransId
                                          AND alletec_billdate__c >=:referenceDate]){
                                               
                                               Date dt = bsum.alletec_billdate__c.date();
                                               //if(dt.daysBetween(referenceDate)<=90 && bsum.HCF_Source__c==null)
                                               if((referenceDate.daysBetween(dt)<=90 && bsum.HCF_Source__c==null)  
                                                  && (dt.daysBetween(referenceDate)<=90 && bsum.HCF_Source__c==null)){
                                                   if(isAck){
                                                       bsum.International_Status__c = Ack.International_Status__c;
                                                       bsum.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                   }
                                                   else if(!isAck){                                                   
                                                       bsum.International_Status__c = Bill.International_Status__c;
                                                       bsum.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                   }
                                                   bsum.HCF_Source__c = HCFId;
                                                   bsum.Tagged_On__c=system.today();
                                                   bsum.SMS_Tagged__c = false; 
                                                   if(Bill !=NULL && bsum.id!=Bill.id){   
                                                   bsum.Auto_tagged__c=true;
                                                   }
                                                   bsum.Is_Tagged_By_International_Hidden__c=true;

                                                   if(Rmrk!=null){
                                                       bsum.Remark__c=Rmrk;
                                                   }
                                                   
                                                   BillingToUpdate.add(bsum);
                                               }
                                           }
            
        }
        
        try{
            AvoidRecursion.firstRun = false;
            if(AckToupdate.size()>0){
                Update AckToupdate;
            }
            if(BillingToUpdate.size()>0){
                Update BillingToUpdate;
            }
            return 'SUCCESS';
            
            
        }catch(DMLException e){
            return e.getMessage();
        }
        
    }
    
    
    @AuraEnabled
    Public static string directTagging(String AckId , string selectedLeadId){
        List<Admission_Acknowledgement__c> AckToupdate = new List<Admission_Acknowledgement__c>();
        List<Billing_Summary__c> BillingToUpdate = new List<Billing_Summary__c>();
        String ackPrefix = Schema.getGlobalDescribe().get('Admission_Acknowledgement__c').getDescribe().getKeyPrefix();
        String BillingPrefix = Schema.getGlobalDescribe().get('Billing_Summary__c').getDescribe().getKeyPrefix(); 
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('International HCF Account').getRecordTypeId();
        List<Account> AccList = [Select Id From Account Where Name='Direct' AND RecordtypeId=:RecordTypeId];
        Admission_Acknowledgement__c Ack ;
        Billing_Summary__c Bill ;
        boolean isAck;
        String AckPatient;
        
        
        if(String.isNotBlank(AckId)){
            if(ackPrefix == AckId.subString(0,3)){
                isAck = true;
                Ack = [Select Id,CreatedDate, Date_of_Discharge__c,Patient__c,Name,Date_Time_of_Admission__c,Pre_Intimation_Status__c,International_Status__c,Is_Emergency__c,Is_Tagged_By_International_Hidden__c,
                       Tagged_Pre_Intimation__c,SMS_Tagged__c,HCF_Source__c,Patient__r.alletec_patientregisterationdate__c,Sub_Speciality__c, Sub_Speciality__r.Name
                       From Admission_Acknowledgement__c Where Id=:AckId];
                
                Ack.Is_Tagged_By_International_Hidden__c = true;
                Ack.International_Status__c = 'Direct';
                Ack.Pre_Intimation_Status__c='Direct';
                Ack.HCF_Source__c = label.International_Direct_Account;
                Ack.SMS_Tagged__c=false;
                Ack.Id = AckId;
                Ack.Tagged_On__c=system.today();
                AckPatient=Ack.Patient__c;
                if(String.isNotBlank(selectedLeadId))
                    ACK.Tagged_Pre_Intimation__c = selectedLeadId;
            }
            else{
                isAck= false;
                Bill = [Select Id,alletec_dateofadmission__c,Is_Tagged_By_International_Hidden__c,International_Status__c,Is_Emergency__c,CreatedDate,Tagged_Pre_Intimation__c,Pre_Intimation_Status__c,
                        SMS_Tagged__c,HCF_Source__c,Patient__r.alletec_patientregisterationdate__c,
                        Patient__c,alletec_billdate__c From Billing_Summary__c Where Id=:AckId]; 
                
                Bill.Is_Tagged_By_International_Hidden__c = true;
                Bill.International_Status__c = 'Direct';
                Bill.Pre_Intimation_Status__c='Direct';
                Bill.HCF_Source__c = label.International_Direct_Account;
                Bill.SMS_Tagged__c=false;
                Bill.Tagged_On__c=system.today();
                Bill.Id = AckId;
                AckPatient=Bill.Patient__c;
                if(String.isNotBlank(selectedLeadId))
                    Bill.Tagged_Pre_Intimation__c = selectedLeadId;
                
            }
            Date referenceDate;
            if(isAck){
                AckToupdate.add(Ack);
                referenceDate = Ack.Date_Time_of_Admission__c.date();
                
            }
            else{
                BillingToUpdate.add(Bill);
                referenceDate = Bill.alletec_billdate__c.date();

                
            }
            for(Billing_Summary__c adm  : [SELECT Id,CreatedDate,alletec_billdate__c,Pre_Intimation_Status__c,SMS_Tagged__c,Auto_tagged__c,International_Status__c,HCF_Source__c,Remark__c FROM Billing_Summary__c
                                           WHERE Patient__c=:AckPatient and HCF_Source__c=null
                                           and alletec_isinternational__c=true and Id!=:AckId
                                          AND alletec_billdate__c >=:referenceDate]){
                                               Date dt = adm.alletec_billdate__c.date();
                                              // if(dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null && adm.Id!=AckId)
                                              if((referenceDate.daysBetween(dt)<=90 && adm.HCF_Source__c==null)  
                                                  && (dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null)) {
                                                   if(isAck){
                                                       adm.International_Status__c = Ack.International_Status__c;
                                                       adm.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                   }
                                                   else if(!isAck){                                                   
                                                       adm.International_Status__c = Bill.International_Status__c;
                                                       adm.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                   }
                                                   adm.HCF_Source__c = label.International_Direct_Account;
                                                   adm.SMS_Tagged__c = false; 
                                                   if(Bill!=NULL && adm.id!=Bill.id){   
                                                   adm.Auto_tagged__c=true;
                                                   }
                                                   adm.Tagged_On__c=system.today();
                                                   BillingToUpdate.add(adm);
                                               }
                                           }
            
            for(Admission_Acknowledgement__c adm : [SELECT Id,CreatedDate,Date_Time_of_Admission__c,International_Status__c,SMS_Tagged__c,Auto_tagged__c,Pre_Intimation_Status__c,HCF_Source__c,
                                                    Is_Tagged_By_International_Hidden__c
                                                    FROM Admission_Acknowledgement__c WHERE Recordtype.Name=:'International' and
                                                    Patient__c=:AckPatient and HCF_Source__c=null and Id!=:AckId
                                                     AND Date_Time_of_Admission__c >=:referenceDate
                                                   ]){
                                                       Date dt = adm.Date_Time_of_Admission__c.date();                                       
                                                       if(dt.daysBetween(referenceDate)<=90 && adm.HCF_Source__c==null && adm.Id!=AckId){
                                                           if(isAck){
                                                               adm.International_Status__c = Ack.International_Status__c;
                                                               adm.Pre_Intimation_Status__c=Ack.Pre_Intimation_Status__c;
                                                           }
                                                           else if(!isAck){                                                   
                                                               adm.International_Status__c = Bill.International_Status__c;
                                                               adm.Pre_Intimation_Status__c=Bill.Pre_Intimation_Status__c;
                                                           }
                                                           adm.HCF_Source__c = label.International_Direct_Account;
                                                           adm.SMS_Tagged__c = false;                                                  
                                                           adm.Auto_tagged__c=true;
                                                           adm.Is_Tagged_By_International_Hidden__c=true;
                                                           adm.Tagged_On__c=system.today();
                                                           AckToupdate.add(adm);
                                                       }
                                                   }
            
            
        }
        try{
            AvoidRecursion.firstRun = false;
            if(AckToupdate.size()>0){
                Update AckToupdate;
            }
            if(BillingToUpdate.size()>0){
                Update BillingToUpdate;
            }
            return 'SUCCESS';
            
            
      }catch(DMLException e){
            return e.getMessage();
        }
    }
    
    
    @AuraEnabled(cacheable=true)
    public static WrapperClass doGetMecpDoctor(String mecpName) {
        WrapperClass wrpCls = new WrapperClass();
        try {
            if(String.isNotBlank(mecpName)) {
                String query = 'SELECT Id,Name,Owner.Name,Account_Territory__c,Account_Territory__r.Name,AccountNumber,Type,Phone FROM Account WHERE RecordType.Name = \'International HCF Account\' AND Name LIKE \'%' + mecpName+ '%\'';
                wrpCls.listAccount = Database.query(query);
                wrpCls.status = 'SUCCESS';
                return wrpCls;
            }
            else {
                wrpCls.status = 'Please fill HCF Name.';
                return wrpCls;
            }
        }
        catch(Exception e) {
            wrpCls.status = e.getMessage();
            return wrpCls;    
        }
    }
    
    public class WrapperClass{
        @auraEnabled 
        public List<Lead__c> leadLst;
        @auraEnabled 
        public List<Admission_Acknowledgement__c> acknowledgeList;
        @auraEnabled
        public List<Billing_Summary__c> opTransacList;
        @auraEnabled
        public String status;
        @auraEnabled
        public List<Account> listAccount;
        public WrapperClass(){
            leadLst = new List<Lead__c>();
            acknowledgeList = new List<Admission_Acknowledgement__c>();
            opTransacList = new List<Billing_Summary__c>();
            status = '';
        }
    }
    
    
}