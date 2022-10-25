public without sharing class PrescriptionAndVital {
    
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
    public static List<Wrapper> fetchWrapper(string sRecordId){   
        
        system.debug('50 sRecordId - ---> '+sRecordId);//a16N0000008GqObIAK//a15N000000IeAslIAF
        // where Isolation_Max_Home__c
        List<E_Prescription__c>  lstEPrescription=[SELECT Id,Signature_of_the_Doctor__c,None_of_the_Comorbidities__c,None_of_the_Investigation__c,Any_Other_Comorbities__c,Any_Other_Instruction__c,Any_Other_Investigation__c,Any_Other_Treatment__c,Doctor_Name__c,Registration_No__c,Doctor_Contact__c,Isolation_Max_Home__r.Patient_Name__c,Isolation_Max_Home__r.Assign_Doctor__c,Isolation_Max_Home__r.Name,Isolation_Max_Home__r.Name__c,Isolation_Max_Home__r.Age__c,Isolation_Max_Home__r.Gender__c,
                                                   Isolation_Max_Home__r.Diagnosis__c,Name, Isolation_Max_Home__c, CKD__c, Diabetes__c, Hypertension__c, COPD_Asthama__c, 
                                                   Obesity__c, Cancer__c, Immunosuppession__c, Pregenancy__c, Tab_HCQS__c, Tab_Ivernectin__c, Tab_Irithromycin__c, Tab_Azithromycin__c, Tab_Calpol_650_mg_SDS__c, Tab_Vit_C__c, Cap_Zincovit__c, Cap_Uprise_D__c, Tab_Pantocid__c, Complete_hemogram_with_ESR__c, LFT__c, HbAIC__c, CRP__c, LDH__c, Serum_Fertin__c, D_dimer__c, Procacitomic__c, Drop_I__c, Xray_Chest_PA__c, HRCT_Chest__c, ECG__c, Monitor_Oxygen_Saturation_Using_Pulse__c, Monitor_temperature_respiratory_rate__c, Plenty_of_Fluids__c, Home_Isolation_for_2_Weeks__c, SaO2_94__c, RR_30_Min__c, High_grade_fever__c, 
                                                   Shortness_of_breath__c,Isolation_Max_Home__r.Severity__c,Isolation_Max_Home__r.Doctor__r.PersonMobilePhone,Isolation_Max_Home__r.Doctor__r.Name,Isolation_Max_Home__r.Medical_History__c, Diarrhoea_Vomiting__c, Hemoptysis__c FROM E_Prescription__c 
                                                   where Isolation_Max_Home__c =: sRecordId];
        system.debug('lstEPrescription --->>> '+lstEPrescription);
        List<Wrapper> lstWrapper = new List<Wrapper>();
        Wrapper objWrapper=new Wrapper();
        List<MedicalComorbiditiesWrapper> lstaccountListWrapper = new List<MedicalComorbiditiesWrapper>();
        List<MedicalComorbiditiesOneWrapper> lstaccountListWrapperOne = new List<MedicalComorbiditiesOneWrapper>();
        List<TreatmentsWrapper> lstTreatmentsWrapper = new List<TreatmentsWrapper>();
        List<InvestigationWrapper> lstInvestigationWrapper = new List<InvestigationWrapper>();
        List<InvestigationOneWrapper> lstInvestigationOneWrapper = new List<InvestigationOneWrapper>();
        List<homeWrapper> lsthomeWrapper = new List<homeWrapper>();
        List<HospitalWrapper> lstHospitalWrapper = new List<HospitalWrapper>();
        List<HospitalOneWrapper> lstHospitalOneWrapper = new List<HospitalOneWrapper>();
        if(lstEPrescription.size()>0){
            MedicalComorbiditiesWrapper obj=new MedicalComorbiditiesWrapper();
            obj.objMedical='Diabetes mellitus';
            obj.isChecked=lstEPrescription[0].Diabetes__c;
            lstaccountListWrapper.add(obj);
            MedicalComorbiditiesWrapper obj1=new MedicalComorbiditiesWrapper();
            obj1.objMedical='Hypertension';
            obj1.isChecked=lstEPrescription[0].Hypertension__c;
            lstaccountListWrapper.add(obj1);
            
            MedicalComorbiditiesWrapper obj2=new MedicalComorbiditiesWrapper();
            obj2.objMedical='COPD/Asthma';
            obj2.isChecked=lstEPrescription[0].COPD_Asthama__c;
            lstaccountListWrapper.add(obj2);
            
            MedicalComorbiditiesWrapper obj3=new MedicalComorbiditiesWrapper();
            obj3.objMedical='CKD';
            obj3.isChecked=lstEPrescription[0].CKD__c;
            lstaccountListWrapper.add(obj3);
            
            MedicalComorbiditiesOneWrapper obj4=new MedicalComorbiditiesOneWrapper();
            obj4.objMedicalOne='Obesity';
            obj4.isChecked=lstEPrescription[0].Obesity__c;
            lstaccountListWrapperOne.add(obj4);
            
            MedicalComorbiditiesOneWrapper obj5=new MedicalComorbiditiesOneWrapper();
            obj5.objMedicalOne='Cancer';
            obj5.isChecked=lstEPrescription[0].Cancer__c;
            lstaccountListWrapperOne.add(obj5);
            
            MedicalComorbiditiesOneWrapper obj6=new MedicalComorbiditiesOneWrapper();
            obj6.objMedicalOne='Immunosupression';
            obj6.isChecked=lstEPrescription[0].Immunosuppession__c;
            lstaccountListWrapperOne.add(obj6);
            
            MedicalComorbiditiesOneWrapper obj7=new MedicalComorbiditiesOneWrapper();
            obj7.objMedicalOne='Pregnancy';
            obj7.isChecked=lstEPrescription[0].Pregenancy__c;
            lstaccountListWrapperOne.add(obj7);
            
            //---------- TreatmentsWrapper -----------
            TreatmentsWrapper Treatobj=new TreatmentsWrapper();
            Treatobj.objTreatment='Tab.HCQS(400 mg) 1 tab twice daily X 1 day followed by (200 mg) 1 tab twice daily x 4 days';
            Treatobj.isChecked=lstEPrescription[0].Tab_HCQS__c;
            lstTreatmentsWrapper.add(Treatobj);
            
            TreatmentsWrapper reatobj1=new TreatmentsWrapper();
            reatobj1.objTreatment='Tab.lvernectin(12 mg) 1 tab once daily x 2 day)';
            reatobj1.isChecked=lstEPrescription[0].Tab_Ivernectin__c;
            lstTreatmentsWrapper.add(reatobj1);
            
            TreatmentsWrapper Treatobj2=new TreatmentsWrapper();
            Treatobj2.objTreatment='Tab.Azithromycin(500 mg) 1 tab once daily x 5 day)';
            Treatobj2.isChecked=lstEPrescription[0].Tab_Azithromycin__c;
            lstTreatmentsWrapper.add(Treatobj2);
            
            TreatmentsWrapper Treatobj3=new TreatmentsWrapper();
            Treatobj3.objTreatment='Tab.Calpol(650 mg)SOS';
            Treatobj3.isChecked=lstEPrescription[0].Tab_Calpol_650_mg_SDS__c;
            lstTreatmentsWrapper.add(Treatobj3);
            
            TreatmentsWrapper Treatobj4=new TreatmentsWrapper();
            Treatobj4.objTreatment='Tab.Vit C(Limcee)(500 mg) 1 tab twice daily x 5 day';
            Treatobj4.isChecked=lstEPrescription[0].Tab_Vit_C__c;
            lstTreatmentsWrapper.add(Treatobj4);
            
            TreatmentsWrapper Treatobj5=new TreatmentsWrapper();
            Treatobj5.objTreatment='Tab.Zincovit 1 Cap. twice daily x 5 day';
            Treatobj5.isChecked=lstEPrescription[0].Cap_Zincovit__c;
            lstTreatmentsWrapper.add(Treatobj5);
            
            TreatmentsWrapper Treatobj6=new TreatmentsWrapper();
            Treatobj6.objTreatment='Tab.Uprise D3 60000 unit once a week x 4 weeks';
            Treatobj6.isChecked=lstEPrescription[0].Cap_Uprise_D__c;
            lstTreatmentsWrapper.add(Treatobj6);
            
            TreatmentsWrapper Treatobj7=new TreatmentsWrapper();
            Treatobj7.objTreatment='Tab.Pantocid (400 mg) 1 tab before breakfast x 5 days';
            Treatobj7.isChecked=lstEPrescription[0].Tab_Pantocid__c;
            lstTreatmentsWrapper.add(Treatobj7);
            
            
            //---------- InvestigationWrapper -----------
            
            InvestigationWrapper InstObj=new InvestigationWrapper();
            InstObj.objInvestigation='Complete hemogram with ESR';
            InstObj.isChecked=lstEPrescription[0].Complete_hemogram_with_ESR__c;
            lstInvestigationWrapper.add(InstObj);
            
            InvestigationWrapper InstObj1=new InvestigationWrapper();
            InstObj1.objInvestigation='LFT';
            InstObj1.isChecked=lstEPrescription[0].LFT__c;
            lstInvestigationWrapper.add(InstObj1);
            
            InvestigationWrapper InstObj2=new InvestigationWrapper();
            InstObj2.objInvestigation='HbAIC';
            InstObj2.isChecked=lstEPrescription[0].HbAIC__c;
            lstInvestigationWrapper.add(InstObj2);
            
            
            InvestigationWrapper InstObj3=new InvestigationWrapper();
            InstObj3.objInvestigation='CRP';
            InstObj3.isChecked=lstEPrescription[0].CRP__c;
            lstInvestigationWrapper.add(InstObj3);
            
            InvestigationWrapper InstObj4=new InvestigationWrapper();
            InstObj4.objInvestigation='LDH';
            InstObj4.isChecked=lstEPrescription[0].LDH__c;
            lstInvestigationWrapper.add(InstObj4);
            
            
            InvestigationWrapper InstObj5=new InvestigationWrapper();
            InstObj5.objInvestigation='Serum Feritin';
            InstObj5.isChecked=lstEPrescription[0].Serum_Fertin__c;
            lstInvestigationWrapper.add(InstObj5);
            
            
            
            //---------- InvestigationOneWrapper -----------
            
            
            InvestigationOneWrapper InstOneobj=new InvestigationOneWrapper();
            InstOneobj.objInvestigationOne='d-dimer';
            InstOneobj.isChecked=lstEPrescription[0].Tab_Pantocid__c;
            lstInvestigationOneWrapper.add(InstOneobj);
            
            
            InvestigationOneWrapper InstOneobj1=new InvestigationOneWrapper();
            InstOneobj1.objInvestigationOne='Procacitomic';
            InstOneobj1.isChecked=lstEPrescription[0].Procacitomic__c;
            lstInvestigationOneWrapper.add(InstOneobj1);
            
            InvestigationOneWrapper InstOneobj2=new InvestigationOneWrapper();
            InstOneobj2.objInvestigationOne='Trop -l';
            InstOneobj2.isChecked=lstEPrescription[0].Drop_I__c;
            lstInvestigationOneWrapper.add(InstOneobj2);
            
            InvestigationOneWrapper InstOneobj3=new InvestigationOneWrapper();
            InstOneobj3.objInvestigationOne='Xray Chest(PA)';
            InstOneobj3.isChecked=lstEPrescription[0].Xray_Chest_PA__c;
            lstInvestigationOneWrapper.add(InstOneobj3);
            
            
            InvestigationOneWrapper InstOneobj4=new InvestigationOneWrapper();
            InstOneobj4.objInvestigationOne='HRCT Chest';
            InstOneobj4.isChecked=lstEPrescription[0].HRCT_Chest__c;
            lstInvestigationOneWrapper.add(InstOneobj4);
            
            InvestigationOneWrapper nstOneobj5=new InvestigationOneWrapper();
            nstOneobj5.objInvestigationOne='ECG';
            nstOneobj5.isChecked=lstEPrescription[0].ECG__c;
            lstInvestigationOneWrapper.add(nstOneobj5);
            
            //---------- homeWrapper -----------
            
            homeWrapper homeobj=new homeWrapper();
            homeobj.objhome='Monitor oxygen saturation using pulse oximeter 3 times a day';
            homeobj.isChecked=lstEPrescription[0].Monitor_Oxygen_Saturation_Using_Pulse__c;
            lsthomeWrapper.add(homeobj);
            
            homeWrapper homeobj1=new homeWrapper();
            homeobj1.objhome='Monitor temperature, respiratory rate and pulse rate and blood pressure thrice daily';
            homeobj1.isChecked=lstEPrescription[0].Monitor_temperature_respiratory_rate__c;
            lsthomeWrapper.add(homeobj1);
            
            homeWrapper homeobj3=new homeWrapper();
            homeobj3.objhome='Plenty of fluids';
            homeobj3.isChecked=lstEPrescription[0].Plenty_of_Fluids__c;
            lsthomeWrapper.add(homeobj3);
            
            homeWrapper homeobj4=new homeWrapper();
            homeobj4.objhome='Home isolation for 2 weeks';
            homeobj4.isChecked=lstEPrescription[0].Home_Isolation_for_2_Weeks__c;
            lsthomeWrapper.add(homeobj4);
            
            //---------- HospitalWrapper -----------
            
            HospitalWrapper Hospitalobj=new HospitalWrapper();
            Hospitalobj.objHospital='SpO2<94%';
            Hospitalobj.isChecked=lstEPrescription[0].SaO2_94__c;
            lstHospitalWrapper.add(Hospitalobj); 
            
            HospitalWrapper Hospitalobj1=new HospitalWrapper();
            Hospitalobj1.objHospital='RR>30/min';
            Hospitalobj1.isChecked=lstEPrescription[0].RR_30_Min__c;
            lstHospitalWrapper.add(Hospitalobj1);
            
            
            HospitalWrapper Hospitalobj2=new HospitalWrapper();
            Hospitalobj2.objHospital='High grade fever';
            Hospitalobj2.isChecked=lstEPrescription[0].High_grade_fever__c;
            lstHospitalWrapper.add(Hospitalobj2);
            
            //---------- HospitalOneWrapper -----------
            
            HospitalOneWrapper HospitalOneobj=new HospitalOneWrapper();
            HospitalOneobj.objHospitalOne='Shortness of Breath';
            HospitalOneobj.isChecked=lstEPrescription[0].Shortness_of_breath__c;
            lstHospitalOneWrapper.add(HospitalOneobj); 
            
            HospitalOneWrapper HospitalOneobj1=new HospitalOneWrapper();
            HospitalOneobj1.objHospitalOne='Diarrhoea, vomiting';
            HospitalOneobj1.isChecked=lstEPrescription[0].Diarrhoea_Vomiting__c;
            lstHospitalOneWrapper.add(HospitalOneobj1);
            
            HospitalOneWrapper HospitalOneobj2=new HospitalOneWrapper();
            HospitalOneobj2.objHospitalOne='Hemoptysis';
            HospitalOneobj2.isChecked=lstEPrescription[0].Hemoptysis__c;
            lstHospitalOneWrapper.add(HospitalOneobj2);
            
            objWrapper.PatientsName=lstEPrescription[0].Isolation_Max_Home__r.Patient_Name__c;
            string sComorbiditiesget='';
            if(lstEPrescription[0].None_of_the_Comorbidities__c)
                sComorbiditiesget='None';
            if(lstEPrescription[0].Diabetes__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Diabetes mellitus';
            else
                sComorbiditiesget+='Diabetes mellitus';
            if(lstEPrescription[0].Hypertension__c)
               if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Hypertension';
            else
                sComorbiditiesget+='Hypertension__c';
            if(lstEPrescription[0].COPD_Asthama__c)
               if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',COPD/Asthma';
            else
                sComorbiditiesget+='COPD/Asthma';
            if(lstEPrescription[0].CKD__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',CKD';
            else
                sComorbiditiesget+='CKD';
            if(lstEPrescription[0].Obesity__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Obesity';
            else
                sComorbiditiesget+='Obesity';
            if(lstEPrescription[0].Cancer__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Cancer';
            else
                sComorbiditiesget+='Cancer';
             if(lstEPrescription[0].Immunosuppession__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Immunosupression';
            else
                sComorbiditiesget+='Immunosupression';
             if(lstEPrescription[0].Pregenancy__c)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=',Pregenancy';
            else
                sComorbiditiesget+='Pregenancy';
              if(lstEPrescription[0].Any_Other_Comorbities__c !=''  && lstEPrescription[0].Any_Other_Comorbities__c !=null)
                if(!string.isEmpty(sComorbiditiesget))
                sComorbiditiesget+=','+string.valueOf(lstEPrescription[0].Any_Other_Comorbities__c );
            else
                if(lstEPrescription[0].Any_Other_Comorbities__c !='' && lstEPrescription[0].Any_Other_Comorbities__c !=null)
                sComorbiditiesget+=string.valueOf(lstEPrescription[0].Any_Other_Comorbities__c );
            objWrapper.Comorbiditiesget = sComorbiditiesget;
            
            
            objWrapper.SeverityGet = lstEPrescription[0].Isolation_Max_Home__r.Severity__c;
            objWrapper.AnyOtherTreatmentget = lstEPrescription[0].Any_Other_Treatment__c;
            objWrapper.AnyOtherInvestigationget = lstEPrescription[0].Any_Other_Investigation__c;
            objWrapper.AnyOtherComorbitiesGet = lstEPrescription[0].Any_Other_Comorbities__c;
            objWrapper.AnyOtherInstructionget = lstEPrescription[0].Any_Other_Instruction__c;
            objWrapper.NoneofComorbitiditiesGet = lstEPrescription[0].None_of_the_Comorbidities__c;
            objWrapper.NoneofInvestigationGet = lstEPrescription[0].None_of_the_Investigation__c;
            objWrapper.SignatureOfDoctorGet = lstEPrescription[0].Signature_of_the_Doctor__c;
            objWrapper.ConsultantName = lstEPrescription[0].Isolation_Max_Home__r.Doctor__r.Name;
            objWrapper.ConsultantMobile = lstEPrescription[0].Isolation_Max_Home__r.Doctor__r.PersonMobilePhone;
            objWrapper.Age=string.valueOf(lstEPrescription[0].Isolation_Max_Home__r.Age__c);
            objWrapper.Gender=string.valueOf(lstEPrescription[0].Isolation_Max_Home__r.Gender__c);
            objWrapper.Diagnosis=lstEPrescription[0].Isolation_Max_Home__r.Diagnosis__c;
            objWrapper.DoctorName=lstEPrescription[0].Doctor_Name__c;	
            objWrapper.EnquiryNo=lstEPrescription[0].Registration_No__c;
            //Doctor_Contact__c
        }
        objWrapper.lstMCWra=lstaccountListWrapper;
        objWrapper.lstMCWraOne=lstaccountListWrapperOne;
        objWrapper.lstTreatWra=lstTreatmentsWrapper;
        objWrapper.lstInvsgWra=lstInvestigationWrapper; 
        objWrapper.lstInvsgOneWra=lstInvestigationOneWrapper;
        objWrapper.lstHomeWra=lsthomeWrapper;
        objWrapper.lstHospitalWra=lstHospitalWrapper;
        objWrapper.lstHospitalOneWra=lstHospitalOneWrapper;
        lstWrapper.add(objWrapper);
        return lstWrapper;
    }
    
    @AuraEnabled 
    public static List<Vital__c> fetchVitalWrapper(string sRecordId){   
        
        system.debug('sRecordId---->> '+sRecordId);
        List<VitalWrapper> lstVitalWrapper = new List<VitalWrapper>();
        VitalWrapper objVtWrp=new VitalWrapper();
        List<Vital__c> LstRecVital=[SELECT Id,Patient_Remarks__c,isDeveloping__c,EnableRecord__c,Name,Developing_Symptoms__c,Isolation_Max_Home__r.Doctor__c, Isolation_Max_Home__c,Quarantine_Day__c,Date__c,Temperature_F__c,Pulse_Rate__c,Respiratory_Rate__c,O2SaturationLable__c,
                                    Blood_Pressure__c,Blood_sugar__c,Mask_Change__c,Urine_Output_frequency__c,Aspiration__c,
                                    Temperature_0F__c, Pulse_Rate_min__c, Respiratory_Rate_min__c, O2Saturation__c, Blood_Pressure_mm_of_Hg__c, Blood_sugar_mg_dl_if_diabetic__c, Mask_Change_8th_hourly__c, Fluid_Intake_check_for_fluid_intake__c, Temperature_0F_8_PM__c, Temperature_0F_2_PM__c, Pulse_Rate_min_2_PM__c, Pulse_Rate_min_8_PM__c, Respiratory_Rate_min_2_PM__c, Respiratory_Rate_min_8_PM__c, O2Saturation_2_PM__c, O2Saturation_8_PM__c, Blood_Pressure_mm_of_Hg_2_PM__c, Blood_Pressure_mm_of_Hg_8_PM__c, Blood_sugar_mg_dl_if_diabetic_2_PM__c, Blood_sugar_mg_dl_if_diabetic_8_PM__c,Any_other_family_member_developing_2_PM__c, 
                                    Fluid_Intake_check_for_fluid_intake_2PM__c,Mask_Change_2_PM__c,Mask_Change_8_PM__c,
                                    Developing_Symptomps_of_8AM__c,Developing_Symptomps_of_2PM__c,Developing_Symptomps_of_8PM__c,
                                    Worsening_of_Symptomps_8am__c,Worsening_of_Symptomps_2pm__c,Worsening_of_Symptomps_8pm__c,
                                    Any_other_family_member_developing_8_PM__c,
                                    None_of_the_Symptom_at_8_AM__c,None_of_the_Symptom_at_2_PM__c,None_of_the_Symptom_at_8_PM__c,
                                    Any_othr_family_mmbr_developing_any_8AM__c,
                                    
                                    Cold_2_PM__c,Cold_8_AM__c,Cold_8_PM__c,Cough_2_PM__c,Cough_8_AM__c,Cough_8_PM__c,
                                    Difficulty_in_Breathing_2_PM__c,Difficulty_in_Breathing_8_AM__c,Difficulty_in_Breathing_8_PM__c,Discolouration_Lips_Face_2_PM__c,
                                    Discolouration_Lips_Face_8_AM__c,Discolouration_Lips_Face_8_PM__c,Headache_2_PM__c,Headache_8_AM__c,Headache_8_PM__c,
                                    Mental_Confusion_2_PM__c,Mental_Confusion_8_AM__c,Mental_Confusion_8_PM__c,Persistent_Pain_2_PM__c,Persistent_Pain_8_AM__c,
                                    Persistent_Pain_8_PM__c,Sneezing_2_PM__c,Sneezing_8_AM__c,Sneezing_8_PM__c,
                                    Isolation_Max_Home__r.Patient_Verify_Morning__c,Isolation_Max_Home__r.Patient_Verify_Evening__c,
                                    Urine_Output__c,Urine_Output_2_PM__c,Urine_Output_8_PM__c,Aspiration_Vomit__c,Aspiration_Vomit_2_PM__c,Aspiration_Vomit_8_PM__c,
                                    Fluid_Intake_check_for_fluid_intake_8PM__c FROM Vital__c where Isolation_Max_Home__c =: sRecordId order by Date__c  asc];
        
        return LstRecVital;
    }
    
    @AuraEnabled 
    public static boolean saveVital(List<Vital__c> lstRecVitalWrapper,String currentDay){   
        Integer curday=Integer.valueOF(currentDay);
        system.debug('lstRecVitalWrapper ----->>> '+lstRecVitalWrapper);
        System.debug('currentDay--->'+currentDay);
       // system.debug('lstRecVitalWrapper ----->>> '+lstRecVitalWrapper[curday]);
        try{
            Max_at_Home_Enquiry_Page__c max = new Max_at_Home_Enquiry_Page__c();
            max.Id= lstRecVitalWrapper[curday].Isolation_Max_Home__c;
            max.Quarantine_Day__c=lstRecVitalWrapper[curday].Quarantine_Day__c;
            if(lstRecVitalWrapper[curday].Temperature_0F__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Temperature_0F__c)||
               lstRecVitalWrapper[curday].Pulse_Rate_min__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Pulse_Rate_min__c)||
               lstRecVitalWrapper[curday].O2Saturation__c != null && String.isNotBlank(lstRecVitalWrapper[curday].O2Saturation__c)||
               lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg__c)
              ){
                  max.Patient_Verify_Morning__c=true;
                  max.Morning_Temp__c=lstRecVitalWrapper[curday].Temperature_0F__c;
                  max.Morning_BP__c=lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg__c;
                  max.Morning_O2__c=lstRecVitalWrapper[curday].O2Saturation__c;
              }else{
                  max.Patient_Verify_Morning__c=false;
                  max.Morning_Temp__c=lstRecVitalWrapper[curday].Temperature_0F__c;
                  max.Morning_BP__c=lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg__c;
                  max.Morning_O2__c=lstRecVitalWrapper[curday].O2Saturation__c;
              }
            if(lstRecVitalWrapper[curday].Temperature_0F_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Temperature_0F_8_PM__c )||
               lstRecVitalWrapper[curday].Pulse_Rate_min_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Pulse_Rate_min_8_PM__c)||
               lstRecVitalWrapper[curday].O2Saturation_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[curday].O2Saturation_8_PM__c)||
               lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg_8_PM__c != null && String.isNotBlank(lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg_8_PM__c)
              ) {
                max.Evening_Temp__c=lstRecVitalWrapper[curday].Temperature_0F_8_PM__c;
                max.Evening_BP__c=lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg_8_PM__c;
                max.Evening_O2__c=lstRecVitalWrapper[curday].O2Saturation_8_PM__c;
                max.Patient_Verify_Evening__c=true;
            }else{
                max.Patient_Verify_Evening__c=false;
                max.Evening_Temp__c=lstRecVitalWrapper[curday].Temperature_0F_8_PM__c;
                max.Evening_BP__c=lstRecVitalWrapper[curday].Blood_Pressure_mm_of_Hg_8_PM__c;
                max.Evening_O2__c=lstRecVitalWrapper[curday].O2Saturation_8_PM__c;
            }
            update lstRecVitalWrapper;
            update max;
            //update lstRecVitalWrapper;
        }catch(Dmlexception d){
            
        }
        return true;
    }
    public class  VitalWrapper  {
        @AuraEnabled public string sId {get;set;}
        
        @AuraEnabled public string TempeLable {get;set;}
        @AuraEnabled public string Tempe8AM {get;set;}
        @AuraEnabled public string Tempe2PM {get;set;}
        @AuraEnabled public string Tempe8PM {get;set;}
        
        @AuraEnabled public string PulseLable {get;set;}
        @AuraEnabled public string Pulse8AM {get;set;}
        @AuraEnabled public string Pulse2PM {get;set;}
        @AuraEnabled public string Pulse8PM {get;set;}
        
        @AuraEnabled public string RespirLable {get;set;}
        @AuraEnabled public string Respir8AM {get;set;}
        @AuraEnabled public string Respir2PM {get;set;}
        @AuraEnabled public string Respir8PM {get;set;}
        
        @AuraEnabled public string SaturaLable {get;set;}
        @AuraEnabled public string Satura8AM {get;set;}
        @AuraEnabled public string Satura2PM {get;set;}
        @AuraEnabled public string Satura8PM {get;set;}
        
        @AuraEnabled public string BloodPressureLable {get;set;}
        @AuraEnabled public string BloodPressure8AM {get;set;}
        @AuraEnabled public string BloodPressure2PM {get;set;}
        @AuraEnabled public string BloodPressure8PM {get;set;}
        
        @AuraEnabled public string BloodSugarLable {get;set;}
        @AuraEnabled public string BloodSugar8AM {get;set;}
        @AuraEnabled public string BloodSugar2PM {get;set;}
        @AuraEnabled public string BloodSugar8PM {get;set;}
        
        @AuraEnabled public string MaskChangeLable {get;set;}
        @AuraEnabled public string MaskChange8AM {get;set;}
        @AuraEnabled public string MaskChange2PM {get;set;}
        @AuraEnabled public string MaskChange8PM {get;set;}
        
        @AuraEnabled public string UrineLable {get;set;}
        @AuraEnabled public string Urine8AM {get;set;}
        @AuraEnabled public string Urine2PM {get;set;}
        @AuraEnabled public string Urine8PM {get;set;}
        
        @AuraEnabled public string AspirationLable {get;set;}
        @AuraEnabled public string Aspiration8AM {get;set;}
        @AuraEnabled public string Aspiration2PM {get;set;}
        @AuraEnabled public string Aspiration8PM {get;set;}
    }
    public class  Wrapper  {
        @AuraEnabled public string EnquiryNo {get;set;}
        @AuraEnabled public string DoctorName {get;set;}
        @AuraEnabled public string PatientsName {get;set;}
        @AuraEnabled public string Comorbiditiesget {get;set;}
        @AuraEnabled public string ConsultantName {get;set;}
        @AuraEnabled public string ConsultantMobile {get;set;}
        @AuraEnabled public string AnyOtherTreatmentget {get;set;}
        @AuraEnabled public string AnyOtherInvestigationget {get;set;}
        @AuraEnabled public string AnyOtherInstructionget {get;set;}
        @AuraEnabled public string AnyOtherComorbitiesGet {get;set;}
        @AuraEnabled public Boolean NoneofComorbitiditiesGet {get;set;}
        @AuraEnabled public Boolean NoneofInvestigationGet {get;set;}
        @AuraEnabled public Boolean SignatureOfDoctorGet {get;set;}
        @AuraEnabled public string SeverityGet {get;set;}
        @AuraEnabled public string Age  {get;set;}
        @AuraEnabled public string Gender  {get;set;}
        @AuraEnabled public string Diagnosis {get;set;}
        @AuraEnabled public string sDate {get;set;}
        @AuraEnabled public List<MedicalComorbiditiesWrapper> lstMCWra{get;set;}
        @AuraEnabled public List<MedicalComorbiditiesOneWrapper> lstMCWraOne{get;set;}
        @AuraEnabled public List<TreatmentsWrapper> lstTreatWra{get;set;}
        @AuraEnabled public List<InvestigationWrapper> lstInvsgWra{get;set;}
        @AuraEnabled public List<InvestigationOneWrapper> lstInvsgOneWra{get;set;}
        @AuraEnabled public List<homeWrapper> lstHomeWra{get;set;}
        @AuraEnabled public List<HospitalWrapper> lstHospitalWra{get;set;}
        @AuraEnabled public List<HospitalOneWrapper> lstHospitalOneWra{get;set;}
    }
    public class  MedicalComorbiditiesWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objMedical{get;set;}
    }
    public class  MedicalComorbiditiesOneWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objMedicalOne{get;set;}
    }
    public class  TreatmentsWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objTreatment{get;set;}
    }
    public class  InvestigationWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objInvestigation{get;set;}
    }
    public class  InvestigationOneWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objInvestigationOne{get;set;}
    }
    public class  homeWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objhome{get;set;}
    }
    public class   HospitalWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objHospital{get;set;}
    }
    public class   HospitalOneWrapper  {
        @AuraEnabled public string sId {get;set;}
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  String objHospitalOne{get;set;}
    }
    
}