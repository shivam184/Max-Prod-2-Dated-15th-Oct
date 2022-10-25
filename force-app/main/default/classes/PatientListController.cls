public class PatientListController {
    
        
    @AuraEnabled
    public static Map<String, String> getGender(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Max_at_Home_Enquiry_Page__c.Gender__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled
    public static Map<String, String> getFamilySymptomps(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult =Vital__c.Any_othr_family_mmbr_developing_any_8AM__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled
    public static Map<String, String> getDevelopingsymptoms(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Vital__c.Developing_Symptoms__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled
    public static Map<String, String> getWorseningsymptoms(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Vital__c.Worsening_of_Symptomps_8am__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled 
    public static List<accountListWrapper> fetchAccountWrapper(string sRecordId){   
        
        system.debug('sRecordId ---->> '+sRecordId);
        List<accountListWrapper> lstaccountListWrapper = new List<accountListWrapper>();
        for(Vital__c acc : [Select id,EnableRecord__c,Isolation_Max_Home__r.Name__c,Covid_Tested_Date__c,Assigned_Doctor__c,
                            Assigned_Nurse__c,Name,Patient_Mobile_no__c,Isolation_Max_Home__c,Patient_Name__c, Quarantine_Day__c
                            ,Verify_in_Morning__c, Verify_in_Evening__c,Date__c From Vital__c where Isolation_Max_Home__c =: sRecordId/* where Nurse__c=:UserInfo.getUserId()*/
                            order by name Limit 1000]){
                                system.debug(acc.Assigned_Doctor__c);
                                lstaccountListWrapper.add(new accountListWrapper(false,acc));
                            } 
        return lstaccountListWrapper; 
    }
    
    @AuraEnabled 
    public static List<Vital__c> fncGetUserDetails(string sRecordId){
        
        system.debug('sRecordId ---->> '+sRecordId);
        
        list<Vital__c> lstRec=[Select id,Date__c,EnableRecord__c,Patient_Remarks__c,
                               Isolation_Max_Home__r.Patient_Name__c,Isolation_Max_Home__r.Name__c,Aspiration__c,
                              
                               
                               Isolation_Max_Home__r.Medical_History__c,Isolation_Max_Home__r.Doctor__r.Name,Isolation_Max_Home__r.Doctor__r.PersonMobilePhone,
                               Cold_2_PM__c,Cold_8_AM__c,Cold_8_PM__c,Cough_2_PM__c,Cough_8_AM__c,Cough_8_PM__c,
                               Difficulty_in_Breathing_2_PM__c,Difficulty_in_Breathing_8_AM__c,Difficulty_in_Breathing_8_PM__c,Discolouration_Lips_Face_2_PM__c,
                               Discolouration_Lips_Face_8_AM__c,Discolouration_Lips_Face_8_PM__c,Headache_2_PM__c,Headache_8_AM__c,Headache_8_PM__c,
                               Mental_Confusion_2_PM__c,Mental_Confusion_8_AM__c,Mental_Confusion_8_PM__c,Persistent_Pain_2_PM__c,Persistent_Pain_8_AM__c,
                               Persistent_Pain_8_PM__c,Sneezing_2_PM__c,Sneezing_8_AM__c,Sneezing_8_PM__c,
                               None_of_the_Symptom_at_8_AM__c,None_of_the_Symptom_at_2_PM__c,None_of_the_Symptom_at_8_PM__c,
                               
                               Developing_Symptomps_of_8AM__c,Developing_Symptomps_of_2PM__c,Developing_Symptomps_of_8PM__c,
                               Worsening_of_Symptomps_8am__c,Worsening_of_Symptomps_2pm__c,Worsening_of_Symptomps_8pm__c,
                               Aspiration_Vomit_2_PM__c,Aspiration_Vomit_8_PM__c,Urine_Output_frequency__c,Urine_Output_2_PM__c,Urine_Output_8_PM__c,Isolation_Max_Home__r.Gender__c,Fluid_Intake_check_for_fluid_intake__c,Fluid_Intake_check_for_fluid_intake_2PM__c,Fluid_Intake_check_for_fluid_intake_8PM__c,
                               Any_othr_family_mmbr_developing_any_8AM__c,Any_other_family_member_developing_2_PM__c,Any_other_family_member_developing_8_PM__c,
                               Quarantine_Day__c,Hand_hygiene_washing_hands_with_soap__c,Hand_hygiene_washing_hands_with_soap_2__c,Hand_hygiene_washing_hands_with_soap_8__c,
                               Mask_Change__c,Mask_Change_2_PM__c,Mask_Change_8_PM__c,Blood_sugar_mg_dl_if_diabetic__c,Blood_sugar_mg_dl_if_diabetic_2_PM__c,
                               Blood_sugar_mg_dl_if_diabetic_8_PM__c,Blood_Pressure_mm_of_Hg__c,Blood_Pressure_mm_of_Hg_2_PM__c,Blood_Pressure_mm_of_Hg_8_PM__c,
                               O2Saturation__c,O2Saturation_2_PM__c,O2Saturation_8_PM__c,Respiratory_Rate_min__c,Respiratory_Rate_min_2_PM__c,
                               Respiratory_Rate_min_8_PM__c,Pulse_Rate_min__c,Pulse_Rate_min_2_PM__c,Pulse_Rate_min_8_PM__c,Temperature_0F__c,
                               Temperature_0F_2_PM__c,Temperature_0F_8_PM__c,Isolation_Max_Home__r.Date__c,Isolation_Max_Home__r.Age__c,
                               Covid_Tested_Date__c,Assigned_Doctor__c,Assigned_Nurse__c,Name,Patient_Mobile_no__c,Isolation_Max_Home__c,Patient_Name__c                         
                               From Vital__c  where id =: sRecordId];
        system.debug('lstRec--->>> '+lstRec);
        return lstRec;
    }
    
    @AuraEnabled 
    public static List<E_Prescription__c> fncGetPrescription(string sRecordId){ 
        
        system.debug('sRecordId ---->> '+sRecordId);
        list<Vital__c> lstRec=[Select id,Isolation_Max_Home__r.Name__c,Aspiration__c,Aspiration_Vomit_2_PM__c,Aspiration_Vomit_8_PM__c,Urine_Output_frequency__c,Urine_Output_2_PM__c,Urine_Output_8_PM__c,Isolation_Max_Home__r.Gender__c,Fluid_Intake_check_for_fluid_intake__c,Fluid_Intake_check_for_fluid_intake_2PM__c,Fluid_Intake_check_for_fluid_intake_8PM__c,Any_othr_family_mmbr_developing_any_8AM__c,Any_other_family_member_developing_2_PM__c,Any_other_family_member_developing_8_PM__c,Quarantine_Day__c,Hand_hygiene_washing_hands_with_soap__c,Hand_hygiene_washing_hands_with_soap_2__c,Hand_hygiene_washing_hands_with_soap_8__c,Mask_Change__c,Mask_Change_2_PM__c,Mask_Change_8_PM__c,Blood_sugar_mg_dl_if_diabetic__c,Blood_sugar_mg_dl_if_diabetic_2_PM__c,Blood_sugar_mg_dl_if_diabetic_8_PM__c,Blood_Pressure_mm_of_Hg__c,Blood_Pressure_mm_of_Hg_2_PM__c,Blood_Pressure_mm_of_Hg_8_PM__c,O2Saturation__c,O2Saturation_2_PM__c,O2Saturation_8_PM__c,Respiratory_Rate_min__c,Respiratory_Rate_min_2_PM__c,Respiratory_Rate_min_8_PM__c,Pulse_Rate_min__c,Pulse_Rate_min_2_PM__c,Pulse_Rate_min_8_PM__c,Temperature_0F__c,Temperature_0F_2_PM__c,Temperature_0F_8_PM__c,Isolation_Max_Home__r.Date__c,Isolation_Max_Home__r.Age__c,date__c,Covid_Tested_Date__c,Assigned_Doctor__c,Assigned_Nurse__c,Name,Patient_Mobile_no__c,Isolation_Max_Home__c,Patient_Name__c                         
                               From Vital__c  where id =: sRecordId];
        list<E_Prescription__c> listPrescription = [Select id,Isolation_Max_Home__c,Cap_Zincovit__c,
                                                    Diabetes__c,
                                                    Hypertension__c,
                                                    Immunosuppession__c,
                                                    Pregenancy__c,
                                                    Cancer__c,
                                                    CKD__c,
                                                    Obesity__c,
                                                    COPD_Asthama__c,
                                                    Any_Other_Comorbities__c,
                                                    Cap_Uprise_D__c,Tab_Pantocid__c,Tab_Calpol_650_mg_SDS__c,Tab_Irithromycin__c,Tab_Azithromycin__c,
                                                    Tab_Ivernectin__c,Tab_HCQS__c,Tab_Vit_C__c from E_Prescription__c WHERE Isolation_Max_Home__c =:lstRec[0].Isolation_Max_Home__c];
        system.debug('lstRec--->>> '+lstRec);
        system.debug('lstRec--->>> '+listPrescription);
        return listPrescription;
    }
    
  
    
    @AuraEnabled 
    public static void saveVital(list<Vital__c> lstRecVitalWrapper){ 
        system.debug(' 87 lstRec ---->> '+lstRecVitalWrapper);
        try{
            Max_at_Home_Enquiry_Page__c max = new Max_at_Home_Enquiry_Page__c();
            max.Id= lstRecVitalWrapper[0].Isolation_Max_Home__c;
            max.Quarantine_Day__c=lstRecVitalWrapper[0].Quarantine_Day__c;
            if(lstRecVitalWrapper[0].Temperature_0F__c != null && String.isNotBlank(lstRecVitalWrapper[0].Temperature_0F__c)||
               lstRecVitalWrapper[0].Pulse_Rate_min__c != null && String.isNotBlank(lstRecVitalWrapper[0].Pulse_Rate_min__c)||
               lstRecVitalWrapper[0].O2Saturation__c != null && String.isNotBlank(lstRecVitalWrapper[0].O2Saturation__c)||
               lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg__c != null && String.isNotBlank(lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg__c)){
                   lstRecVitalWrapper[0].Verify_in_Morning__c=true;
                   max.Vital_Verify_in_Morning__c=true;
                   max.Morning_Temp__c=lstRecVitalWrapper[0].Temperature_0F__c;
                   max.Morning_BP__c=lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg__c;
                   max.Morning_O2__c=lstRecVitalWrapper[0].O2Saturation__c;
                   
               }else{
                   lstRecVitalWrapper[0].Verify_in_Morning__c=false;
                   max.Vital_Verify_in_Morning__c=false; 
                   max.Morning_Temp__c=lstRecVitalWrapper[0].Temperature_0F__c;
                   max.Morning_BP__c=lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg__c;
                   max.Morning_O2__c=lstRecVitalWrapper[0].O2Saturation__c;
               }
            if(lstRecVitalWrapper[0].Temperature_0F_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[0].Temperature_0F_8_PM__c )||
               lstRecVitalWrapper[0].Pulse_Rate_min_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[0].Pulse_Rate_min_8_PM__c)||
               lstRecVitalWrapper[0].O2Saturation_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[0].O2Saturation_8_PM__c)||
               lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg_8_PM__c)
              ){
                  lstRecVitalWrapper[0].Verify_in_Evening__c=true;
                  max.Vital_Verify_in_Evening__c=true;
                   max.Evening_Temp__c=lstRecVitalWrapper[0].Temperature_0F_8_PM__c;
                max.Evening_BP__c=lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg_8_PM__c;
                max.Evening_O2__c=lstRecVitalWrapper[0].O2Saturation_8_PM__c;
              }else{
                  lstRecVitalWrapper[0].Verify_in_Evening__c=false;
                  max.Vital_Verify_in_Evening__c=false;   
                  max.Evening_Temp__c=lstRecVitalWrapper[0].Temperature_0F_8_PM__c;
                  max.Evening_BP__c=lstRecVitalWrapper[0].Blood_Pressure_mm_of_Hg_8_PM__c;
                  max.Evening_O2__c=lstRecVitalWrapper[0].O2Saturation_8_PM__c;
              }
            update lstRecVitalWrapper;
            update max;
            
        }catch(Dmlexception d){
            
        }
    }

    
    public class accountListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  Vital__c objAccount{get;set;}
        public accountListWrapper(boolean isChecked, Vital__c objAccount){
            this.isChecked = isChecked;
            this.objAccount = objAccount;
        }
    }
    
    
    public class ShowVitalWrapper{
        
    }

}