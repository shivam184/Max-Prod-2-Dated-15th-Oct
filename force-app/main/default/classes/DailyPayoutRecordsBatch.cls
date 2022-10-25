global class DailyPayoutRecordsBatch implements Database.Batchable<SObject>
{
    global static Database.QueryLocator start(Database.BatchableContext start)
    {
        String query='SELECT Id,Patient__c, Admission_Acknowledgement__r.Name,Admission_Acknowledgement__r.Patient_Name__c,Admission_Acknowledgement__r.Max_ID__c,';
        query+=' Admission_Acknowledgement__r.Transaction_Type__c,Admission_Acknowledgement__r.IPID__c,Admission_Acknowledgement__r.alletec_hospitallocation__c,';
        query+=' Admission_Acknowledgement__r.Doctor__c,Admission_Acknowledgement__r.alletec_speciality__c,HCF_Source__c,HCF_Source__r.ParentId,';
        query+= 'Admission_Acknowledgement__r.Parent_Account__c ,Admission_Acknowledgement__r.Pre_Intimation_DateTime__c,';
        query+=' Admission_Acknowledgement__r.Patient_Reg_DateTime__c,alletec_dateofadmission__c,Admission_Acknowledgement__r.Date_Time_of_Admission__c,';
        query+=' Admission_Acknowledgement__r.Date_of_Discharge__c,Admission_Acknowledgement__r.Pre_Intimation_Status__c,Admission_Acknowledgement__r.SMS_Tagged__c,';
        query+=' Admission_Acknowledgement__r.Auto_Tagged__c, Admission_Acknowledgement__r.First_OPD_IPD_Bill_Date__c,Admission_Acknowledgement__r.First_OPD_IPD_Bill_No__c,';
        query+=' Admission_Acknowledgement__r.Tagged_On__c,Admission_Acknowledgement__r.Remarks__c,Admission_Acknowledgement__r.Message_Description__c,';
        query+=' Nationality__c,Admission_Acknowledgement__r.pcl_markuppercentage__c,alletec_billdate__c,invoicenumber__c,alletec_hisamount__c,';
        query+= 'Admission_Acknowledgement__r.Discount__c,Admission_Acknowledgement__c,Admission_Acknowledgement__r.OPID__c,Admission_Acknowledgement__r.Last_Number_of_Hours__c from Billing_Summary__c';
        query+=' where CreatedDate=YESTERDAY AND alletec_isinternational__c=true AND alletec_isbillcancelled__c = false AND HCF_Source__c!=NULL AND alletec_transactiontype__c IN(\'IP\',\'OP\',\'Preadmission\')' ;
        System.debug(' within a start query ===>>> ' +query );
        return Database.getQueryLocator(query);
    }
    global static void execute(Database.BatchableContext bt,List<Billing_Summary__c> lst)
    {

		System.debug('execute list  ===>>>' +lst.size());        
        //   Slab_Master__c slb = [select Id,HCF_Source__c,Validity__c from Slab_Master__c];
        
        list<Payout__c> payout2insert = new list<Payout__c>();
        
        /*----------------------------------------------------------------------------------------by uzair 26032020-------------------------------------------------*/
        map<id,map<String,list<Slab_Master__c>>> maphcf2slabmstr = new map<id,map<string,list<Slab_Master__c>>>();
        set<string> countryset = new set<string>();//to get country of Patients
        
        for(Billing_Summary__c billing : lst) {
            System.debug('execute list  ===>>>');   
            Payout__c pay = new Payout__c(Patient_Name__c=billing.Admission_Acknowledgement__r.Patient_Name__c,Patient__c=billing.Patient__c,Max_ID__c=billing.Admission_Acknowledgement__r.Max_ID__c,
                                          Transaction_Type__c=billing.Admission_Acknowledgement__r.Transaction_Type__c,IPID__c=billing.Admission_Acknowledgement__r.IPID__c,
                                          alletec_hospitallocation__c=billing.Admission_Acknowledgement__r.alletec_hospitallocation__c,Doctor__c=billing.Admission_Acknowledgement__r.Doctor__c,
                                          alletec_speciality__c=billing.Admission_Acknowledgement__r.alletec_speciality__c,
                                          Parent_Account__c = billing.Admission_Acknowledgement__r.Parent_Account__c,
                                          New_Pre_Intimation_Date_Time__c=billing.Admission_Acknowledgement__r.Pre_Intimation_DateTime__c,
                                          alletec_dateofadmission__c = billing.alletec_dateofadmission__c,Date_Time_of_Admission__c=billing.Admission_Acknowledgement__r.Date_Time_of_Admission__c,
                                          Date_of_Discharge__c = billing.Admission_Acknowledgement__r.Date_of_Discharge__c,
                                          Pre_Intimation_Status__c=billing.Admission_Acknowledgement__r.Pre_Intimation_Status__c,SMS_Tagged__c=billing.Admission_Acknowledgement__r.SMS_Tagged__c,
                                          Auto_Tagged__c=billing.Admission_Acknowledgement__r.Auto_Tagged__c,First_OPD_IPD_Bill_Date__c = billing.Admission_Acknowledgement__r.First_OPD_IPD_Bill_Date__c,
                                          First_OPD_IPD_Bill_No__c = billing.Admission_Acknowledgement__r.First_OPD_IPD_Bill_No__c,
                                          Tagged_On__c=billing.Admission_Acknowledgement__r.Tagged_On__c,
                                          Remarks__c = billing.Admission_Acknowledgement__r.Remarks__c,Message_Description__c = billing.Admission_Acknowledgement__r.Message_Description__c,
                                          Nationality__c=billing.Nationality__c,pcl_markuppercentage__c=billing.Admission_Acknowledgement__r.pcl_markuppercentage__c,
                                          alletec_billdate__c=billing.alletec_billdate__c,invoicenumber__c=billing.invoicenumber__c,alletec_hisamount__c=billing.alletec_hisamount__c,
                                          Discount__c=billing.Admission_Acknowledgement__r.Discount__c,Patient_RecordId__c = billing.Admission_Acknowledgement__c,
                                          OPID__c=billing.Admission_Acknowledgement__r.OPID__c,
                                          Number_of_Hours__c = billing.Admission_Acknowledgement__r.Last_Number_of_Hours__c);
            
            System.debug('execute before if block billing.HCF_Source__r.Parent_Account__c ===>>> ' +billing.HCF_Source__r.ParentId);
            if(billing.HCF_Source__r.ParentId!=null){
                
                System.debug('execute if block billing.HCF_Source__r.Parent_Account__c ===>>> ' +billing.HCF_Source__r.ParentId);
                pay.HCF_Source__c = billing.HCF_Source__r.ParentId;
                if(!maphcf2slabmstr.containskey(billing.HCF_Source__r.ParentId))
                    maphcf2slabmstr.put(billing.HCF_Source__r.ParentId,new map<string,list<Slab_Master__c>>());
            }else{
                pay.HCF_Source__c = billing.HCF_Source__c;
                System.debug('execute else block pay.HCF_Source__c ===>>> ' +pay.HCF_Source__c);
                if(!maphcf2slabmstr.containskey(billing.HCF_Source__c))
                    maphcf2slabmstr.put(billing.HCF_Source__c,new map<string,list<Slab_Master__c>>());
            }
            System.debug('execute maphcf2slabmstr printing ===>>> ' +maphcf2slabmstr);
            payout2insert.add(pay);
            
        }
        System.debug('execute list  ==uzair=>>>');   
        
        if(maphcf2slabmstr!=null && maphcf2slabmstr.size() > 0){
            System.debug('execute if block maphcf2slabmstr with size ===>>> ' +maphcf2slabmstr +maphcf2slabmstr.size());
            for(Slab_Master__c slb : [SELECT Id,HCF_Source__c,Minimum_Range__c,Payout_Percent__c,Maximum_Range__c,Validity__c, 
                                      GST__c,Location__c from Slab_Master__c where HCF_Source__c In:maphcf2slabmstr.keyset() AND 
                                      Validity__c>=:System.today()-1]){
                                          if(!maphcf2slabmstr.get(slb.HCF_Source__c).containskey(slb.Location__c))
                                              maphcf2slabmstr.get(slb.HCF_Source__c).put(slb.Location__c,new list<Slab_Master__c>());
                                          maphcf2slabmstr.get(slb.HCF_Source__c).get(slb.Location__c).add(slb);
                                      }
            System.debug('execute after for loop maphcf2slabmstr with size ===>>> ' +maphcf2slabmstr +maphcf2slabmstr.size());
            
            if(maphcf2slabmstr!=null && maphcf2slabmstr.size() > 0){
                for(Payout__c pay : payout2insert){
                    if(maphcf2slabmstr.containskey(pay.HCF_Source__c) && maphcf2slabmstr.get(pay.HCF_Source__c).size() > 0){
                        if(maphcf2slabmstr.get(pay.HCF_Source__c).containskey(pay.Nationality__c))
                            getPercentInfo(pay,maphcf2slabmstr.get(pay.HCF_Source__c).get(pay.Nationality__c));
                        else if(maphcf2slabmstr.get(pay.HCF_Source__c).get('Other')!=null && maphcf2slabmstr.get(pay.HCF_Source__c).get('Other').size() > 0)
                            getPercentInfo(pay,maphcf2slabmstr.get(pay.HCF_Source__c).get('Other'));
                    }
                }
            }
            
            if(payout2insert!=null && payout2insert.size() > 0)
                insert payout2insert;
            
       /************************************end**********************************************************************************/
            
        } 
    }
    global void finish(Database.BatchableContext bt){
    }
    private static Payout__c getPercentInfo(Payout__c pay,List<Slab_Master__c> slblst){
        System.debug('pay  ===>>> ' +pay );
        Boolean IsIn = false;
        /**********************************by uzair 26032020*********************************************************************/
        for(Slab_Master__c slb : slblst){
            if(slb.Minimum_Range__c!=null && slb.Maximum_Range__c!=null){
                system.debug('====Line 108 ====');
                if(pay.alletec_hisamount__c>=slb.Minimum_Range__c && pay.alletec_hisamount__c<=slb.Maximum_Range__c){
                                    system.debug('====Line 110====');

                    pay.GST__c = slb.GST__c;
                    pay.Payout_Percentage__c = slb.Payout_Percent__c;
                    pay.Slab_Master__c = slb.Id;
                    IsIn = true;
                    break;
                }
                
            }else if(slb.Minimum_Range__c!=null){
                if(pay.alletec_hisamount__c>=slb.Minimum_Range__c){
                    pay.GST__c = slb.GST__c;
                    pay.Payout_Percentage__c = slb.Payout_Percent__c;
                    pay.Slab_Master__c = slb.id;
                    IsIn = true;
                    break;
                }
            }else if(slb.Maximum_Range__c!=null){
                if(pay.alletec_hisamount__c<=slb.Maximum_Range__c){
                    pay.GST__c = slb.GST__c;
                    pay.Payout_Percentage__c = slb.Payout_Percent__c;
                    pay.Slab_Master__c = slb.id;
                    IsIn = true;
                    break;
                }
            }else{
                pay.GST__c = slb.GST__c;
                pay.Payout_Percentage__c = slb.Payout_Percent__c;
                pay.Slab_Master__c = slb.id;
                IsIn = true;
                break;
            }
            
        }
        if(pay.alletec_hisamount__c!=null && IsIn==true){
            if(pay.Payout_Percentage__c !=NULL){
             pay.Total_Payout__c = pay.alletec_hisamount__c + (pay.alletec_hisamount__c*Integer.valueof(pay.Payout_Percentage__c))/100;
             pay.Total_Payout__c+= (pay.Total_Payout__c*pay.GST__c)/100;
            }
        }
        return pay;
        /*****************************************************by uzair 26032020************************************************/
    }
}