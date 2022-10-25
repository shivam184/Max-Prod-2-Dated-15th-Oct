({
    doInit : function(component, event, helper) {
        //alert(component.get("v.selectedMaxId"));
        //alert($A.util.isEmpty(component.get("v.selectedMaxId")));
        //var loadTime = window.performance.timing.domContentLoadedEventEnd- window.performance.timing.navigationStart;
        //alert(loadTime);
        if($A.util.isEmpty(component.get("v.selectedMaxId"))){
        	helper.searchPatient(component, event);
        }else{
            helper.searchPatientForPicklist(component,event); 
        }
        helper.getCallType(component,event);
        console.log('@2==>'+component.get("v.listPatient.length"));
        console.log('@3==>'+component.get("v.newContact")); 
       console.log('@4==>'+component.get("v.listPatientAlternate.length")); 
        
        
        /* component.set("v.callerType",$A.get("$Label.c.CallerType").split(','));
        component.set("v.listSource",$A.get("$Label.c.radiologySource").split(','));
        component.set("v.listTransferLevel",$A.get("$Label.c.TransferLevel").split(','));
        component.set("v.listStatus",$A.get("$Label.c.CallStatus").split(','));
        component.set("v.listChannel",$A.get("$Label.c.Channel").split(','));
        component.set("v.listAppointment",$A.get("$Label.c.LabAppointment").split(','));
        component.set("v.listDisconnectionType",$A.get("$Label.c.DisconnectionType").split(',')); */
        
        component.set("v.listSalutation",$A.get("$Label.c.Salutation").split(','));
        component.set("v.listGender",$A.get("$Label.c.GenderContact").split(','));
        //Custom Label for Complaint added by shivam on 27th Sept 2022
        component.set("v.ComplaintCategorylist",$A.get("$Label.c.Complaint_Category").split(',')); 
        component.set("v.showPage",true); 
    },
    getServiceForCallType : function(component,event,helper) {
        
        if(!$A.util.isEmpty(component.get("v.selectedCallType"))) 
            component.set("v.serviceTypeList",component.get("v.mapCallTypeToService")[component.get("v.selectedCallType")]);	
        else 
            component.set("v.serviceTypeList",null);    
        
        component.set("v.selectedService",null);
        component.set("v.selectedAppointment",null);
        
    },
    getcomplaintcategory:function(component,event,helper){
         helper.getcomplaintcategory(component,event);
         
    },
    
    
    
    
    getEndDispositionForService:function(component,event,helper){
        if(!$A.util.isEmpty(component.get("v.selectedService"))) {
            component.set("v.endDispositionTypeList",component.get("v.mapEndDispositionToService")[component.get("v.selectedService")]);	
            console.log(component.get("v.mapEndDispositionToService")[component.get("v.selectedService")]);}
        else 
            component.set("v.endDispositionTypeList",null);    
        
        component.set("v.selectedEndDisposition",null);
       
    },
    
  
    getDataForMobile : function(component,event,helper){
        //component.find("contactNameId").set('v.errors', null);
        if(event.keyCode == 13 && !$A.util.isEmpty(component.get("v.mobileNo"))) {
            if(component.get("v.value") === 'phoneSearch')
                component.set("v.isPhoneSearch",true);
            else
                component.set("v.isPhoneSearch",false);
                
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
      // alert(component.get("v.listPatient"));
        var count = 0;
       
      
        
        if($A.util.isEmpty(component.get('v.selectedCallSource'))){
            count = 1;
            alert('Call Source is Required');
        }
         if($A.util.isEmpty(component.get('v.ComplaintCategory')) &&  component.get('v.selectedEndDisposition')=='Complaint'){
            count = 1;
            alert('Complaint Category is Required');
        }
         if($A.util.isEmpty(component.get('v.SubComplaintCategory')) &&  component.get('v.selectedEndDisposition')=='Complaint'){
            count = 1;
            alert('Sub Complaint Category is Required');
        }
         
         
        
      
        //Location
       
        
        
        //Call Type   picklistId1
        
        
        //Email        
                
        if(count == 0){
           
            component.set("v.disableSave",true);
            component.set("v.showSpinner",true);
            // alert(component.get("v.selectedEndDisposition"));
            var action = component.get("c.saveDataApex");
          
//alert('Setting PArams') ;          
            action.setParams({
                "Prebooking":component.get("v.NewPreBookingID"),
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
                "selectedEndDisposition":component.get("v.selectedEndDisposition"),
                "selectedIVR" : component.get("v.selectedIVR"),
                "selectedLocationId" : component.get("v.selectedLocationId"),
                "callSource" : component.get("v.selectedCallSource"),
                "remarks" : component.get("v.remarks"),
                "ltngCurrTime" : component.get("v.ltngCurrTime"),
                "currentTime" : component.get("v.currentTime"),
                "newContact" : component.get("v.newContact"),
                "campaignName" : component.get("v.campaignName"),
                "preBookingId" : component.get("v.preBookingId"),
                "bookingAmount" : component.get("v.bookingAmount"),
                "satisfiedfFeedback" : component.get("v.satisfiedfFeedback"),
                "transactionId" : component.get("v.transactionId"),
                "Subcatgory": component.get("v.SubComplaintCategory"),
                "complaintcatgeory":component.get("v.ComplaintCategory"),
                "patientId" : (!$A.util.isEmpty(component.get("v.listPatient")) ? component.get("v.listPatient")[0].Id : null)
            });
        //    alert('Set PArams') ;   
            action.setCallback(this,function(response){
               
                if(response.getState() === "SUCCESS") {
                    if(response.getReturnValue() === 'Record Created Successfully') {
                        component.set("v.showSpinner",false);
                       // alert('Record Created Successfully');
                        var cmpEventd = $A.get("e.c:CloseWindow");
                        cmpEventd.fire(); 
                    }else if(response.getReturnValue().includes('#')){
                        //alert('Record #');
                        let returnStr = response.getReturnValue().split('#')[1];     
                       // console.log('Found #'+returnStr);
                       // alert('Record #'+returnStr);
                        console.log('Found #'+returnStr);
                        console.log('Found #'+returnStr.includes('notFound'));
                        if(!returnStr.includes('notFound')){
                        //    alert('Found #'+returnStr);
                            console.log('Found #'+returnStr);
                            // alert("https://maxhealthcare--maxdev.lightning.force.com/lightning/cmp/c__CreateMaxLabCustomerLead?c__recordId="+returnStr);
							//var urlEvent = $A.get("e.force:navigateToURL");
    						//				urlEvent.setParams({
     						  // "url": "https://maxhealthcare--maxdev.lightning.force.com/lightning/cmp/c__CreateMaxLabCustomerLead?c__recordId="+returnStr
   															// });

    						//urlEvent.fire();
                              
                              window.location = "https://maxhealthcare--maxdev.lightning.force.com/lightning/cmp/c__CreateMaxLabCustomerLead?c__recordId="+returnStr;
                           /* component.set("v.showSpinner",false);
                            var editRecordEvent = $A.get("e.force:editRecord");
                            console.log(returnStr);
                            editRecordEvent.setParams({
                                                       "recordId": returnStr
                                                      });
                            editRecordEvent.fire();*/
                        }else{
                          //  alert('notFound #'+returnStr);
                         //   alert('No related customer lead found');
                            component.set("v.showSpinner",false);
                           // var cmpEventd = $A.get("e.c:CloseWindow");
                            //cmpEventd.fire();
                          /*  var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/lightning/page/home"
    });
    urlEvent.fire();*/
                            window.location = "https://maxhealthcare--maxdev--c.visualforce.com/apex/Maxlabdisposalpage?mobileNo=9999999999";
                        }
                    }else
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
        
        if(component.get("v.myDate") != '' && component.get("v.callbackDate") < todayFormattedDate)
            component.set("v.dateValidationError" , true);
        else
            component.set("v.dateValidationError" , false);
        //alert('todayFormattedDate-->>'+todayFormattedDate);
        
    },
    getDataForMaxIdPicklist : function(component,event,helper) {   
       
       // alert(component.get("v.selectedMaxId"));
        component.set("v.isPhoneSearch",false);
        helper.searchPatientForPicklist(component,event);         
        
    },
    getSource : function(component,event,helper) {
        //alert('--------------selectedService-->>'+component.get("v.listAppointment"));
    }
})