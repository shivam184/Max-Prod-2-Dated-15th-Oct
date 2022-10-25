({
	doInit : function(component, event, helper) {

		component.set("v.spinner", true); 
        var action = component.get("c.fetchEPrescription");
        var recId = component.get("v.recordId");
       // console.log('recId >>>> ', recId);
        if(recId != undefined){
        action.setParams({
            "sRecordId": component.get("v.recordId")
        });

        action.setCallback(this, function(response) {

            var state = response.getState();
            component.set("v.spinner", false); 
            if (state === "SUCCESS"){

                var prescriptionList = response.getReturnValue();
                if(prescriptionList.length> 0){
                    component.set('v.Name', prescriptionList[0].Patient_Name__c);
                    component.set('v.Age', prescriptionList[0].Age__c);
                    component.set('v.Gender', prescriptionList[0].Gender__c);
                    component.set('v.Diagnosis', prescriptionList[0].Diagnosis__c);
                    component.set('v.covid', prescriptionList[0].Covid_Vaccination__c);
                    component.set('v.vName', prescriptionList[0].Vaccine_Name__c);
                    component.set('v.dose1', prescriptionList[0].Dose_1__c);
                    component.set('v.dose2', prescriptionList[0].Dose_2__c);
                    component.set('v.booster', prescriptionList[0].Booster__c);
                    component.set('v.allergy', prescriptionList[0].Allergies__c);
                    component.set('v.ifYes', prescriptionList[0].If_yes__c);
                    component.set('v.currentIssue', prescriptionList[0].Current_Issues__c);
                    component.set('v.presentIll', prescriptionList[0].History_of_Present_Illness__c);
                    component.set('v.pastIll', prescriptionList[0].History_of_Past_Illness__c);
                    component.set('v.familyHist', prescriptionList[0].Personal_History_Family_History__c);
                    component.set('v.clinical', prescriptionList[0].Clinical_Notes__c);
                    component.set('v.pDiagnosis', prescriptionList[0].Provisional_Diagnosis__c);
                    component.set('v.testToDo', prescriptionList[0].Tests_to_be_Done__c);
                    component.set('v.treatment', prescriptionList[0].Treatment__c);
                    component.set('v.secConsult', prescriptionList[0].Secondary_Consultation_If_required__c);
                    component.set('v.docName', prescriptionList[0].Doctor_Name__c);
                    component.set('v.dmc', prescriptionList[0].DMC__c);
                    component.set('v.sign', prescriptionList[0].Signature__c);
                } 
            }
                else{
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);  
        }
    }
	
})