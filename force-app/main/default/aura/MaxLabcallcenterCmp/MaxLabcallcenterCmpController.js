({
    doInit : function(component, event, helper) {
    
        helper.searchPatient(component, event);
        helper.getCallType(component,event);
        
        component.set("v.callerType",$A.get("$Label.c.CallerType").split(','));
        component.set("v.listSource",$A.get("$Label.c.radiologySource").split(','));
        component.set("v.listTransferLevel",$A.get("$Label.c.TransferLevel").split(','));
        component.set("v.listStatus",$A.get("$Label.c.CallStatus").split(','));
        component.set("v.listChannel",$A.get("$Label.c.Channel").split(','));
        component.set("v.listAppointment",$A.get("$Label.c.LabAppointment").split(','));
        component.set("v.listSalutation",$A.get("$Label.c.Salutation").split(','));
        component.set("v.listGender",$A.get("$Label.c.GenderContact").split(','));
        component.set("v.listDisconnectionType",$A.get("$Label.c.DisconnectionType").split(',')); 
        
        
        component.set("v.showPage",true); 
    },
    getServiceForCallType : function(component,event,helper) {
        //alert('calltype---->>>>'+component.get("v.selectedCallType"));
        
        
        if(!$A.util.isEmpty(component.get("v.selectedCallType"))) {
            component.set("v.serviceTypeList",component.get("v.mapCallTypeToService")[component.get("v.selectedCallType")]);	
            /*
            if(component.get("v.selectedCallType") === 'Appointment' && component.get("v.selectedAppointment") === 'PHP')
                component.set("v.sendSMS",true);
            else if(component.get("v.selectedCallType") === 'Query' && (component.get("v.selectedService") === 'PHP' || component.get("v.selectedService") === 'Location/Route Map'))
                component.set("v.sendSMS",true);
            else
                component.set("v.sendSMS",false);*/
        }
        else {
            component.set("v.serviceTypeList",null);    
        }
        component.set("v.selectedService",null);
        component.set("v.selectedAppointment",null);
        //alert('selectedService---->>>>'+component.get("v.selectedService"));
    },
    getDataForMobile : function(component,event,helper){
        //component.find("contactNameId").set('v.errors', null);
        if(event.keyCode == 13 && !$A.util.isEmpty(component.get("v.mobileNo"))) {
            helper.searchPatient(component,event);    
        }
    },
     isNumber : function(component,event){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode!=46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            event.preventDefault();
        }
        return true; 
    },
    saveData : function(component,event,helper){
        var count = 0;
         if($A.util.isEmpty(component.get("v.mobileNo"))) {
            count = 1;
            component.find('mobileNoId').showHelpMessageIfInvalid();
            
        }
        //Call Type
        if($A.util.isEmpty(component.get('v.selectedCallType'))){
            count = 1;
            component.find('callType').showHelpMessageIfInvalid();
        }
        //Location
        if($A.util.isEmpty(component.get('v.selectedLocationId'))){
            count = 1;
            document.getElementById("locationId").style.display ='block';
            
            //document.getElementById("manageErrorId").children[0].style="border:2px solid rgb(194,57,52) !important;";
        }  
        //Email        
        if(!$A.util.isEmpty(component.get('v.contactEmail'))){
            var fname = component.find('emailId'); 
            var fvalidity = component.find('emailId').get("v.validity");
            if(fvalidity.valid ==false){
                fname.reportValidity();
                fname.focus();
                count = 1;
            } 	    
        }
        if(count == 0){
             component.set("v.showSpinner",true);
            var action = component.get("c.saveDataApex");
            action.setParams({
                "callingMobileNo" : component.get("v.callingMobileNo"),
                "mobileNo" : component.get("v.mobileNo"),
                "contactName" : component.get("v.contactName"),
                "contactSalutation" : component.get("v.contactSalutation"),
                "contactAge" : component.get("v.contactAge"),
                "contactGender" : component.get("v.contactGender"),
                "contactEmail" : component.get("v.contactEmail"),
                "contactAlternateNumber" : component.get("v.contactAlternateNumber"),
                "selectedCallType" : component.get("v.selectedCallType"),
                "selectedService" : component.get("v.selectedService"),
                "disconnectionType" : component.get("v.disconnectionType"),
                "selectedLocationId" : component.get("v.selectedLocationId"),
                "remarks" : component.get("v.remarks"),
                "selectedAppointment" : component.get("v.selectedAppointment"),
                "ltngCurrTime" : component.get("v.ltngCurrTime"),
                "currentTime" : component.get("v.currentTime"),
                "newContact" : component.get("v.newContact")
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS") {
                    if(response.getReturnValue() === 'Record Created Successfully') {
                        component.set("v.showSpinner",false);
                       
                        //alert('Return---->>>>>'+response.getReturnValue());
                        var cmpEventd = $A.get("e.c:CloseWindow");
                        cmpEventd.fire(); 
                    }
                    else
                        component.set("v.errorMsg",response.getReturnValue());    
                }
                component.set("v.showSpinner",false);
            });
            $A.enqueueAction(action);
        }
        
    },
    dateUpdate : function(component,event,helper){
       
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; 
        var yyyy = today.getFullYear();
       
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
       // alert('trey---->>>'+component.get("v.callbackDate"));
        
        if(component.get("v.myDate") != '' && component.get("v.callbackDate") < todayFormattedDate)
            component.set("v.dateValidationError" , true);
        else
            component.set("v.dateValidationError" , false);
        //alert('todayFormattedDate-->>'+todayFormattedDate);
        
    },
    getDataForMaxIdPicklist : function(component,event,helper) {   
        //component.find("contactNameId").set('v.errors', null);
        component.set("v.isPhoneSearch",false);
        helper.searchPatientForPicklist(component,event);         
        //document.getElementById("fullNameId").style.display = 'none'; 
    },
    getSource : function(component,event,helper) {
        //alert('--------------selectedService-->>'+component.get("v.listAppointment"));
    }
})