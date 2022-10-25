({
    showToast : function(title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    
    searchPatient : function(component, event){
        component.set("v.showSpinner",true);
        if($A.util.isEmpty(component.get("v.mobileNo"))) {
            component.set("v.noMobile",true);
        }
        else {
            var action = component.get("c.getPatientForMobileNumber");
            //alert(component.get("v.isPhoneSearch"));
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
                    // alert(JSON.stringify(response.getReturnValue().listPatient));
                    component.set("v.listPatientAlternate",response.getReturnValue().listPatient);
                    
                    if(response.getReturnValue().listPatient.length > 0)
                        component.set("v.listPatient",response.getReturnValue().listPatient);
                    else
                        component.set("v.listPatient",response.getReturnValue().listLeads);
                    
                    if(component.get("v.listPatient").length == 1) {
                        
                        component.set("v.calltype",'Existing');
                        component.set("v.newContact",false);
                        component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                       // console.log('v.listCallDetails '+JSON.stringify(response.getReturnValue().listCallDetails));
                        if(response.getReturnValue().listPatient.length > 0){
                            component.set("v.contactName",response.getReturnValue().listPatient[0].Name);
                            component.set("v.contactSalutation",response.getReturnValue().listPatient[0].Salutation);
                            component.set("v.contactAge",response.getReturnValue().listPatient[0].Age__c);
                            component.set("v.contactGender",response.getReturnValue().listPatient[0].Gender__c);
                            component.set("v.contactEmail",response.getReturnValue().listPatient[0].Email__c);
                            component.set("v.listTransactions",response.getReturnValue().listTransactions);
                            component.set("v.listPatient",response.getReturnValue().listPatient);
                            component.set("v.listPatientAlternate",response.getReturnValue().listPatient);
                        }else{
                            component.set("v.contactName",response.getReturnValue().listLeads[0].Name);
                            component.set("v.contactSalutation",response.getReturnValue().listLeads[0].Title__c);
                            component.set("v.contactAge",response.getReturnValue().listLeads[0].Age__c);
                            component.set("v.contactGender",response.getReturnValue().listLeads[0].Gender__c);
                            component.set("v.contactEmail",response.getReturnValue().listLeads[0].Email__c);
                            component.set("v.listTransactions",response.getReturnValue().listTransactions);
                            component.set("v.listPatient",response.getReturnValue().listLeads);
                            component.set("v.listPatientAlternate",response.getReturnValue().listLeads);
                            
                        }
                        component.set("v.onLoad",false);
                    }else{
                        
                        if(component.get("v.listPatient").length > 1){
                            component.set("v.calltype",'Existing');
                            component.set("v.newContact",false);
                            component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        }
                        else{
                            component.set("v.calltype",'New');
                            component.set("v.listCallDetails",null);
                        }
                        component.set("v.contactName",'');
                        component.set("v.contactSalutation",'');
                        component.set("v.contactAge",'');
                        component.set("v.contactGender",'');
                        component.set("v.contactEmail",'');
                        component.set("v.contactAlternateNumber",'');
                        component.set("v.onLoad",false);
                    }
                    //alert(JSON.stringify(component.get("v.listPatientAlternate")));
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
                   // alert('----resp'+JSON.stringify(response.getReturnValue()));
                    component.set("v.mapCallTypeToService",response.getReturnValue().mapCallTypeToService);
                     component.set("v.mapEndDispositionToService",response.getReturnValue().mapEndDispositionToService);
                    component.set("v.listMapKeys",response.getReturnValue().listMapKeys);
                    component.set("v.listIVR",response.getReturnValue().listIVR);
                    component.set("v.listCallSource",response.getReturnValue().listCallSource);
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
                        component.set("v.listTransactions",response.getReturnValue().listTransactions);
                        component.set("v.listCallDetails",response.getReturnValue().listCallDetails);
                        component.set("v.patientIdForLead",response.getReturnValue().listPatient[0].Id);
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
            component.set("v.patientIdForLead",null);
        }
        

    },
    //Added By Shivam For Complaint Category Part of Form
   
    getcomplaintcategory:function(component,event){
             console.log('166'+component.get("v.ComplaintCategory"));  
          /*console.log(component.get("v.ComplaintCategory"));
        var action = component.get("c.ComplaintCategoryApex");
        action.setParams({
            "ComplaintCategory" : component.get("v.ComplaintCategory")    
        });
        
        
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                component.set("v.SubComplaintCategorylist",response.getReturnValue().listMapKeys2); 

                }
              }); 
        $A.enqueueAction(action);*/
                                    
         
            var action = component.get("c.ComplaintCategoryApex");
            action.setParams({
                "ComplaintCategorys" : component.get("v.ComplaintCategory"),
                "Subcatgory" : component.get("v.SubComplaintCategory")

                              
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                      component.set("v.SubComplaintCategorylist",response.getReturnValue().listcomplaintsub);                  
                }
                
            });
            $A.enqueueAction(action);
        }
   
})