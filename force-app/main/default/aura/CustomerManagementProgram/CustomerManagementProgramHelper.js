({
    showToast : function(component,event,title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type" : type
        });
        toastEvent.fire();
    },
    
    doInitHelper : function(component,event) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        today = yyyy + '-' + mm + '-' + dd;
        component.set("v.maxDate",today);
        if($A.get("$Browser.formFactor")=='PHONE' || $A.get("$Browser.formFactor")=='TABLET')
            component.set("v.isDesktop",false);
        
        //Set Gender Picklist
   		var genderTypes = $A.get("$Label.c.Genders");
        component.set("v.listGender",genderTypes.split(';'));
        
        //Set Insurance Details Picklist
        var insuranceDetails = $A.get("$Label.c.CMP_Insurance_Details");
        component.set("v.insuranceList",insuranceDetails.split(';'));
        
        
        
        var action = component.get('c.getOccupations');
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                if(response.getReturnValue()!=null && response.getReturnValue()!=undefined){
                    component.set('v.listOccupation',response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    setEnrolmenttypes : function(component, event){ 
        var action = component.get('c.getEnrolmentTypes');
        
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                //alert('----->>>'+response.getReturnValue())
                if(response.getReturnValue()!=null)
                    component.set('v.listMemberEnrollmentType',response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    setValuesFromCustAct : function(component, event){ 
        var action = component.get('c.setMasterValues');
        action.setParams({
            'recordId' : component.get('v.recordId'),
            'ld' : component.get('v.lead')
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                if(response.getReturnValue()!=null)
                    component.set('v.lead',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
	
    doAPIcallout : function(component, event){
        if(!$A.util.isEmpty(component.get("v.leadPhone")) && component.get("v.leadPhone").length == 10) {
            component.set('v.showSpinner',true);
            component.set('v.lead',{});
            
            
            var action = component.get('c.searchMember');
            action.setParams({
                mobileNo : component.get("v.leadPhone")
            });
            action.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    
                    if(response.getReturnValue()!=null && !$A.util.isEmpty(response.getReturnValue())){
                        var response = response.getReturnValue();
                        component.set('v.patietnWrapper',response);
                        if(response.isExisiting==true && response.moreThanOnePat==false)
                            component.set('v.lead',response.leadObj);
                        if(response.isNewPat==true)
                            this.setValuesFromCustAct(component,event);
                        component.set('v.showSpinner',false);
                    }
                }
                else if(response.getState()==='ERROR'){
                    alert('An error has occurred. Please refresh the page');
                }
                    else if(response.getState()==='INCOMPLETE'){
                        alert('An error has occurred. Please refresh the page');
                    }
            });
            $A.enqueueAction(action);
            
        }
        else {   
        }
    },

	    
    validateDetails : function(component, event, btn){
        var buttonLabel = btn;
        var mobile = component.find('mobile');
        var fname = component.find('firstName');
        var sname = component.find('surName');
        var gender = component.find('gender');
        var age = component.find('Age');
        
        //Enrollment Type
        var enrol = component.find('enrol').get('v.checked');
        var enrolType;
        if(enrol==true)
            enrolType = component.find('memberEnrollmentTypeId');
        
        //Refer to Max
        var referToMax = component.get('v.referToMax');
        var doctor;
        var remarks
        if(referToMax==true){
            doctor = component.get('v.lead.Doctor__c');
            remarks = component.find('remarks');
        }
        
        
        if($A.util.isEmpty(mobile.get('v.value')) || $A.util.isEmpty(fname.get('v.value'))
           || $A.util.isEmpty(sname.get('v.value')) || $A.util.isEmpty(gender.get('v.value'))
           || $A.util.isEmpty(age.get('v.value')) || (enrol==true && $A.util.isEmpty(enrolType.get('v.value'))) 
           || (referToMax==true && ($A.util.isEmpty(doctor) || $A.util.isEmpty(remarks.get('v.value')))) ) {
            
            if($A.util.isEmpty(mobile.get('v.value')))
                mobile.focus();
            if($A.util.isEmpty(fname.get('v.value')))
                fname.focus();
            if($A.util.isEmpty(sname.get('v.value')))
                sname.focus();                
            if($A.util.isEmpty(gender.get('v.value')))
                gender.focus();
            if($A.util.isEmpty(age.get('v.value'))) 
                age.focus();
            if(enrol==true && $A.util.isEmpty(enrolType.get('v.value'))){
                enrolType.focus();
            }
            if(referToMax==true && ($A.util.isEmpty(doctor) || $A.util.isEmpty(remarks.get('v.value')))){
                if($A.util.isEmpty(doctor))
                    $A.util.removeClass(component.find('docError'),"slds-hide");
                if($A.util.isEmpty(remarks.get('v.value')))
                    remarks.focus();
            }
                
            
        }
        else{
            var isError = false;
            if(!$A.util.isEmpty(fname.get('v.value'))){
                var fvalidity = component.find('firstName').get("v.validity");
                if(fvalidity.valid ==false){
                    fname.reportValidity();
                    fname.focus();
                    isError =  true;
                } 
            }
            if(!$A.util.isEmpty(component.find('mname').get('v.value'))){
                var mvalidity = component.find('mname').get("v.validity");
                if(mvalidity.valid ==false){
                    component.find('mname').reportValidity();
                    component.find('mname').focus();
                    isError =  true;
                } 
            }
            if(!$A.util.isEmpty(sname.get('v.value'))){
                var svalidity = sname.get("v.validity");
                if(svalidity.valid ==false){
                    sname.reportValidity();
                    sname.focus();
                    isError =  true;
                } 
            }
            if(enrol==true && !$A.util.isEmpty(enrolType.get('v.value'))){
                if(enrolType.get('v.value')=='Citizen Plus'){
                    var avalidity = age.get("v.validity");
                    if(avalidity.valid==false){
                        age.reportValidity();
                        age.focus();
                        isError =  true;
                    }
                }
            }
            if(!$A.util.isEmpty(age.get('v.value'))){
                var agvalidity = age.get("v.validity");
                if(agvalidity.valid ==false){
                    age.reportValidity();
                    age.focus();
                    isError =  true;
                } 
            }
            if(!isError){
                component.set('v.showSpinner',true);
                var action = component.get('c.validateMemberDetails');
                action.setParams({
                    'exisitingLead' : component.get('v.lead'),
                    'primaryMember' : '',
                    'isNewWithExist' : component.get('v.patietnWrapper.isExistButNewPat')
                });
                action.setCallback(this, function(response){
                    if(response.getState()==='SUCCESS'){
                        var resp = response.getReturnValue();
                        if(resp==='OK'){
                            this.saveDetails(component, event, buttonLabel);
                        }else{
                            component.set('v.sucessMsg','');
                            component.set('v.showSpinner',false);
                            component.set('v.errorMsg',resp)
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    saveDetails : function(component, event, btn){
        
        component.set('v.lead.Health_Camp__c', component.get('v.recordId'));
        
        var saveAction = component.get('c.saveMemberDetails');
        saveAction.setParams({
            'leadObj' : component.get('v.lead'), 
            'primaryMember' : '',
            'isExisting' : component.get('v.patietnWrapper.isExisiting'),
            'isExistWithNew' : component.get('v.patietnWrapper.isExistButNewPat'),
            'leadPhone' : component.get('v.leadPhone'),
            'isPrimary' : true,
            'fileName' : component.get('v.original_filename'),
            'fileBase64' : component.get('v.fileBase64')
        }); 
        
        saveAction.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var resp = response.getReturnValue();
                if(resp.includes('Success')){
                    if(btn=='save'){
                        component.set('v.sucessMsg','Member added successfully!');
                        component.set('v.errorMsg','');
                        component.set('v.showSpinner',false)
                        component.set('v.leadPhone','');
                        component.set('v.lead',{});
                        component.set('v.referToMax',false);
                        component.set('v.patietnWrapper',{});
                    }
                    else if(btn=='savenadd'){
                        var objId = resp.split('#');
                        var recId = objId[1];
                        component.set('v.primaryMemberId',recId);
                        component.set('v.sucessMsg','Member added successfully!');
                        component.set('v.showFamilyMemberComponent',true);
                    }
                }
            }
        });
        $A.enqueueAction(saveAction);
    },
    
    
    
})