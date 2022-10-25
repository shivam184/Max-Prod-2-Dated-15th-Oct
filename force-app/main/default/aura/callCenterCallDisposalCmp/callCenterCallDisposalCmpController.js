({
    /*
	openIframe : function(component, event, helper) {
        component.set('v.showDialog',true);
	},
    */
   
    doInit : function(component,event,helper) {           
        //component.set("v.showSpinner",true);
        //var action = component.get("c.checkValidation");
        //action.setParams({
        //"param" : component.get("v.param")
        //});
        //action.setCallback(this,function(response){
        //if(response.getState() === 'SUCCESS'){
        //if(response.getReturnValue()) {
        helper.getUserid(component, event);
        //
        helper.showWarning(component, event);  
        helper.searchPatient(component, event);
        helper.getCallType(component,event);
        component.set("v.listSource",$A.get("$Label.c.radiologySource").split(','));
        component.set("v.listTransferLevel",$A.get("$Label.c.TransferLevel").split(','));
        component.set("v.listStatus",$A.get("$Label.c.CallStatus").split(','));
        component.set("v.listChannel",$A.get("$Label.c.Channel").split(','));
        component.set("v.listAppointment",$A.get("$Label.c.Appointment").split(','));
        component.set("v.listSalutation",$A.get("$Label.c.Salutation").split(','));
        component.set("v.listGender",$A.get("$Label.c.GenderContact").split(','));
        component.set("v.listDisconnectionType",$A.get("$Label.c.DisconnectionType").split(',')); 
        component.set("v.showPage",true); 
        //}
        //else {
        //component.set("v.showPage",false);    
        //}
        //} 
        //component.set("v.showSpinner",false);
        //});
        //$A.enqueueAction(action);
    },
    
  
    
    getDataForMaxId : function(component,event,helper) {
        //component.find("contactNameId").set('v.errors', null);
        if(event.keyCode == 13 && !$A.util.isEmpty(component.get("v.maxId"))) {
            component.set("v.isPhoneSearch",false);
            component.set("v.selectedMaxId",component.get("v.maxId"));
            helper.searchPatient(component,event);    
        }
    },
    
    getDataForMaxIdPicklist : function(component,event,helper) {   
        //component.find("contactNameId").set('v.errors', null);
        component.set("v.isPhoneSearch",false);
        helper.searchPatientForPicklist(component,event);         
        //document.getElementById("fullNameId").style.display = 'none'; 
    },
    
    getDataForMobile : function(component,event,helper){
        //component.find("contactNameId").set('v.errors', null);
        if(event.keyCode == 13 && !$A.util.isEmpty(component.get("v.mobileNo"))) {
            if(component.get("v.value") === 'phoneSearch')
                component.set("v.isPhoneSearch",true);
            else
                component.set("v.isPhoneSearch",false);
            helper.searchPatient(component,event);    
        }
    },
    
    saveData : function(component,event,helper) {
        var count = 0;
        component.set("v.hideSave", true); 
        //alert('Save Called');
        if(!component.get("v.newContact")) {
            // alert('In If');
            if(component.get("v.listPatientAlternate").length > 1 && $A.util.isEmpty(component.get("v.selectedMaxId"))) {
                count = 1;
                component.find('picklistId').showHelpMessageIfInvalid();
            }
            
            if(component.get("v.listPatientAlternate").length <= 1 && $A.util.isEmpty(component.get("v.contactName"))){
                count = 1;
                component.find('contactNameId').showHelpMessageIfInvalid();
            }    
        }
        
        else {
            // alert('In else')
            if($A.util.isEmpty(component.get("v.contactName"))) {
                count = 1;
                component.find('contactNameId').showHelpMessageIfInvalid();    
            }
        }
        //////////////////////////////////////////////////////////////////
        
        if(component.get('v.selectedCallType') == 'Appointment' && (component.find('channelId').get("v.disabled")==false) ){
        if($A.util.isEmpty(component.get('v.selectedChannel'))){
            count = 1;
            component.find('channelId').showHelpMessageIfInvalid();
        }
        }
        if($A.util.isEmpty(component.get('v.remarks'))){           
            count = 1;
            component.find('remarksId').showHelpMessageIfInvalid();
        }
        //Appointment Type
        if(component.get('v.selectedCallType') == 'Appointment'){
            if($A.util.isEmpty(component.get('v.selectedService'))){ 
                count = 1;
                component.find('ser').showHelpMessageIfInvalid();
            }
        }   
        
        //////////////////////////////////////////////////////////////////
        
        if($A.util.isEmpty(component.get("v.mobileNo"))) {
            count = 1;
            //alert('Line 122' +count);
            component.find('mobileNoId').showHelpMessageIfInvalid();
            
        }
        
        //Call Type
        if($A.util.isEmpty(component.get('v.selectedCallType'))){
            count = 1;
          //  alert('Line 130' +count);
            component.find('callType').showHelpMessageIfInvalid();
        }else{
            
            component.set("v.hideSave", false);
        }                 
        
        //Doctor
        if(component.get('v.selectedAppointment') == 'Dr.Appointment' || component.get('v.selectedAppointment') == 'Immigration'){
            if($A.util.isEmpty(component.get('v.selectedDoctorId'))){
                count = 1;
              //  alert('Line 141' +count);
                document.getElementById("doctorId").style.display ='block';
                
            }else{
                
                component.set("v.hideSave", false);
            }
        }
        //country
      /*  if($A.util.isEmpty(component.get('v.selectedCountryId'))){
            count = 1;
           // document.getElementById("countryId").style.display ='block';
            
            //document.getElementById("manageErrorId").children[0].style="border:2px solid rgb(194,57,52) !important;";
        }else{
            
            component.set("v.hideSave", false);
        }          
        
*/        
        //Location
        if($A.util.isEmpty(component.get('v.selectedLocationId'))){
            count = 1;
            //alert('Line 153' +count);
            document.getElementById("locationId").style.display ='block';
            
            //document.getElementById("manageErrorId").children[0].style="border:2px solid rgb(194,57,52) !important;";
        }else{
            
            component.set("v.hideSave", false);
        }          
        
        //Appointment Type
        if(component.get('v.selectedCallType') == 'Appointment'){
            if($A.util.isEmpty(component.get('v.selectedAppointment'))){           
                count = 1;
            //    alert('Line 166' +count);
                component.find('appType').showHelpMessageIfInvalid();
            }else{
                
                component.set("v.hideSave", false);
            } 	
        }   
        
        if(component.get('v.selectedCallType') == 'Call transfer'){
            if($A.util.isEmpty(component.get('v.transferLevel'))){           
                count = 1;
            //    alert('Line 177' +count);
                component.find('tLevel').showHelpMessageIfInvalid();
            }
            
            
            if($A.util.isEmpty(component.get('v.selectedStatus'))){           
                count = 1;
            //    alert('Line 184' +count);
                component.find('callTransStatus').showHelpMessageIfInvalid();
            }	
        } 
        //Service
        if(component.get('v.selectedCallType') != 'Appointment'){
            //alert('Testing Service data ')
            if($A.util.isEmpty(component.get('v.selectedService'))){           
                count = 1;
            //    alert('Line 193' +count);
                component.find('service').showHelpMessageIfInvalid();
            }else{
                
                component.set("v.hideSave", false);
            } 	
        }   
        
        //Email        
        if(!$A.util.isEmpty(component.get('v.contactEmail'))){
            var fname = component.find('emailId'); 
            var fvalidity = component.find('emailId').get("v.validity");
            if(fvalidity.valid ==false){
                fname.reportValidity();
                fname.focus();
                count = 1;
            //    alert('Line 209' +count);
            } 	    
        }
       //  alert('line 212' +count);
        if(count == 0){
            component.set("v.hideSave", true);
            component.set("v.showSpinner",true);
            if((component.get("v.selectedCallType") === 'Appointment' && component.get("v.selectedAppointment") === 'PHP') || (component.get("v.selectedCallType") === 'Query' && component.get("v.selectedService") === 'PHP') || (component.get("v.selectedCallType") === 'Query' && component.get("v.selectedService") === 'Location/Route Map'))
                component.set("v.sendSMS",true);
            //alert('Creating Action');
            var action = component.get("c.saveDataApex");
            //alert('Param Setting');
            action.setParams({

                "callingMobileNo" : component.get("v.callingMobileNo"),
                "UserID" : component.get("v.UserID"),
                "mobileNo" : component.get("v.mobileNo"),
                "contactName" : component.get("v.contactName"),
                "contactSalutation" : component.get("v.contactSalutation"),
                "contactAge" : component.get("v.contactAge"),
                "contactGender" : component.get("v.contactGender"),
                "contactEmail" : component.get("v.contactEmail"),
                "contactAlternateNumber" : component.get("v.contactAlternateNumber"),
                "selectedMaxId" : component.get("v.selectedMaxId"),
                "selectedCallType" : component.get("v.selectedCallType"),
                "selectedService" : component.get("v.selectedService"),
                "disconnectionType" : component.get("v.disconnectionType"),
                "selectedLocationId" : component.get("v.selectedLocationId"),
                "selectedCountryId":component.get("v.selectedCountryId"),
                "remarks" : component.get("v.remarks"),
                "callBack" : component.get("v.callBack"),
                "selectedSource" : component.get("v.selectedSource"),
                "transferLevel" : component.get("v.transferLevel"),
                "selectedStatus" : component.get("v.selectedStatus"),
                "selectedAppointment" : component.get("v.selectedAppointment"),
                "selectedDoctorId" : component.get("v.selectedDoctorId"),
                "valueSublabel" : component.get("v.valueSublabel"),
                "selectedSourceAppointment" : component.get("v.selectedSourceAppointment"),
                "selectedChannel" : component.get("v.selectedChannel"),
                "selectedReason" : component.get("v.selectedReason"),
                "selectedSubService" : component.get("v.selectedSubService"),
                "ltngCurrTime" : component.get("v.ltngCurrTime"),
                "smsNumber" : component.get("v.smsNumber"),
                "sendSMS" : component.get("v.sendSMS"),
                "newContact" : component.get("v.newContact"),
                "currentTime" : component.get("v.currentTime")
            });
         //  alert('Param Set');
            action.setCallback(this,function(response){
               //  alert(response.getState());
                if(response.getState() === "SUCCESS") {
                   
                 //    alert(response.getReturnValue());
                    if(response.getReturnValue() === 'Record Created Successfully') {
                        component.set("v.showSpinner",false);
                        //if(event.getSource().get("v.label") === 'Save') {
                        
                        var res = action.getReturnValue();
                        var cmpEventd = $A.get("e.c:CloseWindow");
                        cmpEventd.fire(); 
                        
                        //}
                        /*
                    else {
                        component.set("v.sucessMsg",response.getReturnValue());
                        //component.set("v.maxId",null);
                        //component.set("v.selectedMaxId",null);
                        component.set("v.selectedCallType",null);
                        component.set("v.selectedService",null);
                        component.set("v.disconnectionType",null);
                        component.set("v.selectedLocationId",null);
                        component.set("v.remarks",null);
                        component.set("v.callBack",null);
                        component.set("v.selectedSource",null);
                        component.set("v.transferLevel",null);
                        component.set("v.selectedStatus",null);
                        component.set("v.selectedAppointment",null);
                        component.set("v.selectedDoctorId",null);
                        component.set("v.selectedSpeciality",null);
                        component.set("v.selectedSourceAppointment",null);
                        component.set("v.selectedChannel",null);
                        component.set("v.selectedReason",null);
                        component.set("v.selectedSubService",null);
                    }
                    */
                    }
                    else
                        component.set("v.errorMsg",response.getReturnValue());    
                }
                component.set("v.showSpinner",false);
            });
            $A.enqueueAction(action);
        }        
    },
    
    getServiceForCallType : function(component,event,helper) {
        
        //alert('selectedCallType');
        
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
        component.set("v.selectedAppointment",null);
    },
    
    getSource : function(component,event,helper) {
        //alert('Testing Data ');
        if(component.get("v.selectedService") != 'Radiology')
            component.set("v.selectedSource",'');
        helper.getSourceAppointmentHelper(component,event);
        /*if(component.get("v.selectedCallType") === 'Query' && (component.get("v.selectedService") === 'PHP' || component.get("v.selectedService") === 'Location/Route Map'))
        	component.set("v.sendSMS",true);
        else
            component.set("v.sendSMS",false);*/
    },
    
    getSourceAppointment : function(component,event,helper) {
        helper.getSourceAppointmentHelper(component,event);
        /*if(component.get("v.selectedCallType") === 'Appointment' && component.get("v.selectedAppointment") === 'PHP')
        	component.set("v.sendSMS",true);
        else
            component.set("v.sendSMS",false);*/
    },
    
    isNumber : function(component,event){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode!=46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            event.preventDefault();
        }
        return true; 
    },
    
    getSpeciality :  function(component,event,helper){        
        if(!$A.util.isEmpty(component.get("v.selectedDoctorId"))) {
            var action = component.get('c.getSpecialityApex');  
            action.setStorable();
            action.setParams({
                selectedDoctorId : component.get("v.selectedDoctorId")
            });
            
            action.setCallback(this,function(response){
                if(response.getState() == "SUCCESS")
                    component.set("v.docSpeciality",response.getReturnValue()); 
            });
            $A.enqueueAction(action);    
        }
        else {
            component.set("v.docSpeciality",'');     
        }
    },
    
    chngeLocationSpan : function(component,event,helper){  
        if($A.util.isEmpty(component.get('v.selectedLocationId'))){
            document.getElementById("locationId").style.display ='block';
            //document.getElementById("manageErrorId").children[0].style="border:2px solid rgb(194,57,52) !important;";
        }
        else{
            document.getElementById("locationId").style.display ='none';
            //document.getElementById("manageErrorId").children[0].style="border:1px solid rgb(217,219,221) !important;";
        }
    }
   
    
 
    
    
})