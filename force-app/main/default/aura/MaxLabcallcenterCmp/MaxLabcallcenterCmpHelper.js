({
    searchPatient : function(component, event){
        component.set("v.showSpinner",true);
        if($A.util.isEmpty(component.get("v.mobileNo"))) {
            component.set("v.noMobile",true);
        }
        else {
            //alert('mobile---->>>'+component.get("v.mobileNo"));
            var action = component.get("c.getPatientForMobileNumber");
            action.setParams({
                "searchId" : component.get("v.mobileNo")
            });
            action.setCallback(this,function(response){
                
                if(response.getReturnValue().status.includes('SUCCESS')) {
                    component.set("v.listPatient",response.getReturnValue().listPatient);
                    component.set("v.listPatientAlternate",response.getReturnValue().listPatient);
                    if(response.getReturnValue().listPatient.length == 1) {
                        component.set("v.calltype",'Existing');
                        component.set("v.newContact",false);
                        //component.set("v.maxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        //component.set("v.selectedMaxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        component.set("v.contactName",response.getReturnValue().listPatient[0].Name);
                        component.set("v.contactSalutation",response.getReturnValue().listPatient[0].Title__c);
                        component.set("v.contactAge",response.getReturnValue().listPatient[0].Age__c);
                        component.set("v.contactGender",response.getReturnValue().listPatient[0].Gender__c);
                        component.set("v.contactEmail",response.getReturnValue().listPatient[0].Email__c);
                        //component.set("v.contactAlternateNumber",responsne.getReturnValue().listPatient[0].mobilephone__c);
                        component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        //component.set("v.probability",response.getReturnValue().probability);
                        //component.set("v.listTransactions",response.getReturnValue().listTransactions);
                        //component.set("v.preferredChannel",response.getReturnValue().preferredChannel);
                        //component.set("v.conversionProbability",response.getReturnValue().conversionProbability);
                        component.set("v.onLoad",false);
                    }else{
                        
                        component.set("v.calltype",'New');
                        component.set("v.contactName",'');
                        component.set("v.contactSalutation",'');
                        component.set("v.contactAge",'');
                        component.set("v.contactGender",'');
                        component.set("v.contactEmail",'');
                        component.set("v.contactAlternateNumber",'');
                        component.set("v.listCallDetails",null);
                       // component.set("v.probability",'0');
                        //component.set("v.selectedMaxId",null);
                        //component.set("v.maxId",null);
                       // component.set("v.listTransactions",null);
                        //component.set("v.preferredChannel",null);
                        //component.set("v.conversionProbability",0);
                        //component.set("v.contactSalutation",'');
                       // component.set("v.contactGender",'');
                        component.set("v.onLoad",false);
                    }
                }else {
                    component.set("v.errorMsg",response.getReturnValue().status);
                }
            });
            $A.enqueueAction(action);
        }
        component.set("v.showSpinner",false);
    },
    getCallType : function(component,event) {
        component.set("v.showSpinner",true);
        var action = component.get("c.getCallTypeApex");
        action.setStorable();
        //alert('pqr');
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status.includes("SUCCESS")) {
                    //alert('----resp'+JSON.stringify(response.getReturnValue()));
                	component.set("v.mapCallTypeToService",response.getReturnValue().mapCallTypeToService);
                    component.set("v.listMapKeys",response.getReturnValue().listMapKeys);
                    /*component.set("v.mapAppTypeToSource",response.getReturnValue().mapAppTypeToSource);
                    component.set("v.mapReason",response.getReturnValue().mapReason);
                    component.set("v.mapServiceToSubService",response.getReturnValue().mapServiceToSubService);*/
                }
                else {
                	component.set("v.errorMsg",response.getReturnValue().status);    
                }
                component.set("v.showSpinner",false);
            }   
        });
        $A.enqueueAction(action); 
    },
        searchPatientForPicklist : function(component,event) {
        if(!$A.util.isEmpty(component.get("v.selectedMaxId"))) {
           component.set("v.showSpinner",true);
        	var action = component.get("c.searchPatientForPicklistApex");
            action.setParams({
                "maxId" : component.get("v.selectedMaxId")    
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    if(response.getReturnValue().status.includes("SUCCESS")) {
                    	component.set("v.listPatient",response.getReturnValue().listPatient);
                        component.set("v.maxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        component.set("v.selectedMaxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        component.set("v.contactName",response.getReturnValue().listPatient[0].Name);
                        component.set("v.contactSalutation",response.getReturnValue().listPatient[0].Salutation);
                        component.set("v.contactAge",response.getReturnValue().listPatient[0].Age__c);
                        component.set("v.contactGender",response.getReturnValue().listPatient[0].Gender__c);
                        component.set("v.contactEmail",response.getReturnValue().listPatient[0].PersonEmail);
                        //component.set("v.contactAlternateNumber",responsne.getReturnValue().listPatient[0].mobilephone__c);
                        /*component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        component.set("v.probability",response.getReturnValue().probability);
                        component.set("v.listTransactions",response.getReturnValue().listTransactions);
                        component.set("v.preferredChannel",response.getReturnValue().preferredChannel);
                        component.set("v.conversionProbability",response.getReturnValue().conversionProbability);
                        window.setTimeout(
                        $A.getCallback( function() {
                            component.find("channelId").set("v.value",component.get("v.preferredChannel"));
                        }));*/
                    }  
                    else {
                        component.set("v.errorMsg",response.getReturnValue().status);
                    }
                }
                component.set("v.showSpinner",false);
            });
            $A.enqueueAction(action);
        }  
        else {
        	component.set("v.listPatient",null);
            component.set("v.contactName",null);
            component.set("v.contactSalutation",null);
            component.set("v.contactAge",null);
            component.set("v.contactGender",null);
            component.set("v.contactEmail",null);
            component.set("v.contactAlternateNumber",null);
        }
    }
})