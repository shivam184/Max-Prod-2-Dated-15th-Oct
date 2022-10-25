({
    /*showToastt : function(title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },*/
    
   /* showWarning:function(component,event){
        alert('here');
		        var vfOrigin = "https://maxhealthcare--developer--c.visualforce.com/apex/calldisposalpage/";
        alert(vfOrigin);
        window.addEventListener("message", function(event) {
            alert('inside event listener');
            if ( (event.data.type) && (event.data.type=='EventFromVF') )
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            }
            alert('creating toast');
            // Handle the message
            var toastEvent = $A.get('e.force:showToast');
	        toastEvent.setParams({
    	        type: 'info',
        	    message: event.data.message
	        });
            alert('firing');
    	    toastEvent.fire();
	alert('done');
            console.log(event.data);
        }, false);
    },*/
    showWarning:function(component,event){
    var action = component.get("c.getMobileNumberFromUrl");
        action.setParams({
                    "searchId" : component.get("v.mobileNo")
                });
         action.setCallback(this,function(response){
                if(response.getReturnValue()==true) {
                    alert('Handle With Care !!!');
                }
             });
            $A.enqueueAction(action);
                    
    },
    searchPatient : function(component, event){
        component.set("v.showSpinner",true);
        if($A.util.isEmpty(component.get("v.mobileNo"))) {
            component.set("v.noMobile",true);
        }
        // else if()
        else {
            
            var action = component.get("c.getPatientForMobileNumber");
            if(component.get("v.isPhoneSearch"))
                action.setParams({
                    "searchId" : component.get("v.mobileNo"),
                    "isPhoneSearch" : true
                });
            else 
                action.setParams({
                    "searchId" : component.get("v.mobileNo"),
                    "isPhoneSearch" : false
                });    
            action.setCallback(this,function(response){
                if(response.getReturnValue().status.includes('SUCCESS')) {
                    component.set("v.listPatient",response.getReturnValue().listPatient);
                    component.set("v.listPatientAlternate",response.getReturnValue().listPatient);
                    if(response.getReturnValue().listPatient.length == 1) {
                        component.set("v.maxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        component.set("v.selectedMaxId",response.getReturnValue().listPatient[0].Max_ID__c);
                        component.set("v.contactName",response.getReturnValue().listPatient[0].Name);
                        component.set("v.contactSalutation",response.getReturnValue().listPatient[0].Salutation);
                        component.set("v.contactAge",response.getReturnValue().listPatient[0].Age__c);
                        component.set("v.contactGender",response.getReturnValue().listPatient[0].Gender__c);
                        component.set("v.contactEmail",response.getReturnValue().listPatient[0].PersonEmail);
                        //component.set("v.contactAlternateNumber",responsne.getReturnValue().listPatient[0].mobilephone__c);
                        component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        component.set("v.probability",response.getReturnValue().probability);
                        component.set("v.listTransactions",response.getReturnValue().listTransactions);
                        component.set("v.preferredChannel",response.getReturnValue().preferredChannel);
                        component.set("v.conversionProbability",response.getReturnValue().conversionProbability);
                        component.set("v.onLoad",false);
                        window.setTimeout(
                            $A.getCallback( function() {
                                component.find("channelId").set("v.value",component.get("v.preferredChannel"));
                            }));
                    }
                    else {
                        component.set("v.contactName",'');
                        component.set("v.contactSalutation",'');
                        component.set("v.contactAge",'');
                        component.set("v.contactGender",'');
                        component.set("v.contactEmail",'');
                        component.set("v.contactAlternateNumber",'');
                        component.set("v.listCallDetails",null);
                        component.set("v.probability",'0');
                        component.set("v.selectedMaxId",null);
                        component.set("v.maxId",null);
                        component.set("v.listTransactions",null);
                        component.set("v.preferredChannel",null);
                        component.set("v.conversionProbability",0);
                        component.set("v.contactSalutation",'');
                        component.set("v.contactGender",'');
                        component.set("v.onLoad",false);
                    }
                    //component.find("contactNameId").set('v.errors', null);
                }
                else {
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
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().status.includes("SUCCESS")) {
                    component.set("v.mapCallTypeToService",response.getReturnValue().mapCallTypeToService);
                    component.set("v.listMapKeys",response.getReturnValue().listMapKeys);
                    component.set("v.mapAppTypeToSource",response.getReturnValue().mapAppTypeToSource);
                    component.set("v.mapReason",response.getReturnValue().mapReason);
                    component.set("v.mapServiceToSubService",response.getReturnValue().mapServiceToSubService);
                }
                else {
                    component.set("v.errorMsg",response.getReturnValue().status);    
                }
                component.set("v.showSpinner",false);
            }   
        });
        $A.enqueueAction(action); 
    },
    
    getSourceAppointmentHelper : function(component,event) {
        //alert('Testing Data helper');
        component.set("v.listSourceAppointment",component.get("v.mapAppTypeToSource")[component.get("v.selectedAppointment")+'+'+component.get("v.selectedService")]);
        component.set("v.listReason",component.get("v.mapReason")[component.get("v.selectedAppointment")+'+'+component.get("v.selectedService")]);
        component.set("v.listSubService",component.get("v.mapServiceToSubService")[component.get("v.selectedService")]); 
    },
    
     //Added by SHIVAM
   getUserid : function(component,event){
        var action = component.get("c.getUseridApex");
        action.setParams({
            "UserID" : component.get("v.UserID")
        });
        $A.enqueueAction(action);
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                
            component.set("v.UserName",response.getReturnValue().UserID); 
            
                         }
        }); 
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
                        component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        component.set("v.probability",response.getReturnValue().probability);
                        component.set("v.listTransactions",response.getReturnValue().listTransactions);
                        component.set("v.preferredChannel",response.getReturnValue().preferredChannel);
                        component.set("v.conversionProbability",response.getReturnValue().conversionProbability);
                        window.setTimeout(
                            $A.getCallback( function() {
                                component.find("channelId").set("v.value",component.get("v.preferredChannel"));
                            }));
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