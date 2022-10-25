({
    doInitHelper1 : function(component,event){
        component.set("v.spinner", true);  
        var action = component.get("c.fetchWrapper");
        var recId = component.get("v.recordId");
        console.log('recId >>>> ', recId);
        if(recId != undefined){
        //alert(recId);
        action.setParams({
            "sRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.spinner", false); 
            if (state === "SUCCESS"){
                console.log('state >>>> ', state);
                // var spinner = component.find("mySpinner");
                // $A.util.addClass(spinner, "slds-hide");
                var oRes = response.getReturnValue();
                 //alert('oRes ---->> '+   JSON.stringify(oRes));
                if(oRes.length > 0){
                    console.log('oRes.length >>>> ', oRes.length);
                    console.log('oRes >>>> ', oRes);
                   // component.set("v.spinner", false); 
                    component.set('v.MedicalComorbiditiesList', oRes[0].lstMCWra);
                    component.set('v.MedicalComorbiditiesListOne', oRes[0].lstMCWraOne);
                    component.set('v.TreatmentList', oRes[0].lstTreatWra);
                    component.set('v.InvestigationsList', oRes[0].lstInvsgWra);
                    component.set('v.InvestigationsOneList', oRes[0].lstInvsgOneWra);
                    component.set('v.HomeList', oRes[0].lstHomeWra);
                    component.set('v.HospitalList', oRes[0].lstHospitalWra);
                    component.set('v.HospitalOneList', oRes[0].lstHospitalOneWra);
                    component.set('v.PasentName', oRes[0].PatientsName);
                    component.set('v.CoMorbidities', oRes[0].Comorbiditiesget);
                     component.set('v.Severity', oRes[0].SeverityGet);
                    component.set('v.AnyotherTreatment', oRes[0].AnyOtherTreatmentget);
                     component.set('v.AnyotherInvestigation', oRes[0].AnyOtherInvestigationget);
                    component.set('v.NoneOfComorbidity', oRes[0].NoneofComorbitiditiesGet);
                     component.set('v.NoneOfInvestigation', oRes[0].NoneofInvestigationGet);
                     component.set('v.SignOfDoctor', oRes[0].SignatureOfDoctorGet);
                     component.set('v.AnyotherInstruction', oRes[0].AnyOtherInstructionget);
                    component.set('v.AnyotherComorbities', oRes[0].AnyOtherComorbitiesGet);
                     component.set('v.Consultant', oRes[0].ConsultantName + '('+ oRes[0].ConsultantMobile+')');
                    component.set('v.ConsultantNameOnly', oRes[0].ConsultantName);
                    component.set('v.Age', oRes[0].Age);
                    component.set('v.Genger', oRes[0].Gender);
                    component.set('v.Diagnosis', oRes[0].Diagnosis);
                    component.set('v.sDate', '15th June 2020');
                    component.set('v.DoctorName', oRes[0].DoctorName);
                    component.set('v.EnquiryNo', oRes[0].EnquiryNo);
                }else{ 
                } 
            }
            else{
                alert('Error...40');
            }
        });
        $A.enqueueAction(action);  
        }
    },
    FatchVital : function(component,event){
        var action = component.get("c.fetchVitalWrapper");
        action.setParams({
            "sRecordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert('state ---->> '+ state);
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                // alert('state ---->> '+   JSON.stringify(oRes))Quarantine_Day__c
                if(oRes.length > 0){
                    for (var i = 0; i < oRes.length; i++) {
                        var date = new Date();
                        var date1=$A.localizationService.formatDate(date, "yyyy-MM-dd");
                        var date2 = new Date(oRes[i].Date__c);
                        date2=$A.localizationService.formatDate(date2, "yyyy-MM-dd");
                        if (Date.parse(date2) === Date.parse(date1)){ 
                            var  QuarantineDay=oRes[i].Quarantine_Day__c;
                            if(isNaN(QuarantineDay)){
                                QuarantineDay=0;
                                component.set("v.CurrentNumber",QuarantineDay);
                            }
                            else{
                                QuarantineDay=QuarantineDay-1;
                                component.set("v.CurrentNumber",JSON.stringify(QuarantineDay));
                            }
                            oRes[i].EnableRecord__c=false;
                        }else{
                            oRes[i].EnableRecord__c=true;
                        }
                    }
                   // alert('CurrentNumber Tab ---->> '+ component.get("v.CurrentNumber"));
                 component.set("v.VitalList", oRes);
                    component.set("v.Isdata", true);
                }else{ 
                    component.set("v.Isdata", false);
                    
                } 
            }
            else{
                alert('Error...78');
            }
        });
        $A.enqueueAction(action);  
    },
    addAccountRecord: function(component, event) { 
        var VitalList = component.get("v.VitalList");
        VitalList.push({
            'sId':'',
            'Temperature_F__c':'Temperature (F)',
            'Temperature_0F__c': '',
            'Temperature_0F_2_PM__c': '',
            'Temperature_0F_8_PM__c':'',
            'Pulse_Rate__c':'Pulse Rate (/min)',
            'Pulse_Rate_min__c': '',
            'Pulse_Rate_min_2_PM__c': '',
            'Pulse_Rate_min_8_PM__c':'',
            'Respiratory_Rate__c':'Respiratory Rate (/min)',
            'Respiratory_Rate_min__c': '',
            'Respiratory_Rate_min_2_PM__c': '',
            'Respiratory_Rate_min_8_PM__c':'',
            'O2SaturationLable__c':'O2Saturation (%)',
            'O2Saturation__c': '',
            'O2Saturation_2_PM__c': '',
            'O2Saturation_8_PM__c': '',
            'Blood_Pressure__c':'Blood Pressure (mm of Hg)',
            'Blood_Pressure_mm_of_Hg__c': '',
            'Blood_Pressure_mm_of_Hg_2_PM__c': '',
            'Blood_Pressure_mm_of_Hg_8_PM__c': '',
            'Blood_sugar__c':'Blood Sugar (mm/dl) if diabetic',
            'Blood_sugar_mg_dl_if_diabetic__c': '',
            'Blood_sugar_mg_dl_if_diabetic_2_PM__c': '',
            'Blood_sugar_mg_dl_if_diabetic_8_PM__c': '',
            'Mask_Change__c':'Mask Change (8th hourly)',
            'Mask_Change_8th_hourly__c': '',
            'Mask_Change_2_PM__c': '',
            'Mask_Change_8_PM__c': '',
            'Urine_Output_frequency__c':'Urine Output ( frequency and adequate or not)',
            'Urine_Output__c': '',
            'Urine_Output_2_PM__c': '',
            'Urine_Output_8_PM__c': '',
            'Aspiration__c':'Aspiration / Vomit',
            'Aspiration_Vomit__c': '',
            'Aspiration_Vomit_2_PM__c': '',
            'Aspiration_Vomit_8_PM__c': ''
        });
        component.set("v.VitalList", VitalList);
    },
    
    validateAccountList: function(component, event) {
        //Validate all account records
        var isValid = true;
        var VitalList = component.get("v.VitalList");
       // alert('VitalList ---->> '+   JSON.stringify(VitalList))
        for (var i = 0; i < VitalList.length; i++) {
            if (VitalList[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on row number ' + (i + 1));
            }
        }
        return isValid;
    },
    saveVitalList: function(component, event, helper) {
        var iCurrentNumber=0;
        if(JSON.stringify(component.get("v.CurrentNumber")).includes(":"))
            iCurrentNumber=0;
        else
            iCurrentNumber=component.get("v.CurrentNumber");
        
        //alert(' 169 iCurrentNumber --->> '+iCurrentNumber);
        console.log(JSON.stringify(component.get("v.VitalList")));
        var action = component.get('c.saveVital');
        action.setParams({
            "lstRecVitalWrapper": JSON.stringify(component.get("v.VitalList")),
            "currentDay":iCurrentNumber
        });
        action.setCallback(this, function(response){
            //alert('response --->> '+response);
            //alert('getState --->> '+response.getState());
            if(response.getState()==='SUCCESS'){
                component.set("v.isModalOpen",true); 
            }else{ 
            }
        });
        $A.enqueueAction(action); 
    },
    
    genderPickList: function(component, event, helper) {
        var action = component.get("c.getGender");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var gender = [];
                for(var key in result){
                    gender.push({key: key, value: result[key]});
                }
                component.set("v.gender", gender);
            }
        });
        $A.enqueueAction(action);
    },
    
    familySymptompsPickList: function(component, event, helper) {
        var action = component.get("c.getFamilySymptomps");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var familyMemberSymptomps = [];
                for(var key in result){
                    familyMemberSymptomps.push({key: key, value: result[key]});
                }
                component.set("v.familyMemberSymptomps", familyMemberSymptomps);
            }
        });
        $A.enqueueAction(action);
    },
    
    fillPickList: function(component, event, helper) {
        var action = component.get("c.getDevelopingsymptoms");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var symptomps = [];
                for(var key in result){
                    symptomps.push({key: key, value: result[key]});
                }
                component.set("v.symptomps", symptomps);
            }
        });
        $A.enqueueAction(action);
    },
    fillWorseningSympPickList: function(component, event, helper) {
        var action = component.get("c.getWorseningsymptoms");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var WorseningSymptomps = [];
                for(var key in result){
                    WorseningSymptomps.push({label: key, value: result[key]});
                }
                component.set("v.WorseningSymptomps", WorseningSymptomps);
            }
        });
        $A.enqueueAction(action);
    }
})