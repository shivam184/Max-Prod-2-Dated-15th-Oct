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
    
    doInitHelper : function(component,event) {
        if(component.get('v.recordId')!=undefined)
            component.set('v.primaryMemberId',component.get('v.recordId'));
        
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
        
        
        var genderTypes = $A.get("$Label.c.Genders");
        component.set("v.listGender",genderTypes.split(';'));
        
        //Set Insurance Details Picklist
        var insuranceDetails = $A.get("$Label.c.CMP_Insurance_Details");
        component.set("v.insuranceList",insuranceDetails.split(';'));
        
        var action = component.get('c.fetchPrimaryMember');
        action.setParams({
            'leadRecordId' : component.get('v.primaryMemberId') 
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                if(response.getReturnValue()!=null){
                    var resp = response.getReturnValue();
                    resp = resp.split('#');
                    component.set('v.primaryMemberId',resp[0]);
                    component.set('v.primaryMemberEnrolmentType',resp[1]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    validateDetails : function(component, event, btn){
        var buttonLabel = btn;
        
        var mobile = component.find('mobile');
        var fname = component.find('firstName');
        var sname = component.find('surName');
        var gender = component.find('gender');
        var age = component.find('Age');
        
        
        
        if($A.util.isEmpty(mobile.get('v.value')) || $A.util.isEmpty(fname.get('v.value'))
           || $A.util.isEmpty(sname.get('v.value')) || $A.util.isEmpty(gender.get('v.value'))
           || $A.util.isEmpty(age.get('v.value'))){
            
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
            
        }
        else{
            var isError = false;
            if(!$A.util.isEmpty(fname.get('v.value'))){
                var fvalidity = component.find('firstName').get("v.validity");
                if(fvalidity.valid ==false){
                    fname.reportValidity();
                    isError =  true;
                } 
            }
            if(!$A.util.isEmpty(component.find('mname').get('v.value'))){
                var mvalidity = component.find('mname').get("v.validity");
                if(mvalidity.valid ==false){
                    component.find('mname').reportValidity();
                    isError =  true;
                } 
            }
            if(!$A.util.isEmpty(sname.get('v.value'))){
                var svalidity = sname.get("v.validity");
                if(svalidity.valid ==false){
                    sname.reportValidity();
                    isError =  true;
                } 
            }
            
            if(!isError){
                
                component.set('v.showSpinner',true);
                var action = component.get('c.validateMemberDetails');
                action.setParams({
                    'exisitingLead' : component.get('v.lead'),
                    'primaryMember' : component.get('v.primaryMemberId'),
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
        var saveAction = component.get('c.saveMemberDetails');
        saveAction.setParams({
            'leadObj' : component.get('v.lead'),
            'primaryMember' : component.get('v.primaryMemberId'),
            'isExisting' : component.get('v.patietnWrapper.isExisiting'),
            'isExistWithNew' : component.get('v.patietnWrapper.isExistButNewPat'),
            'leadPhone' : component.get('v.leadPhone'),
            'isPrimary' : false
        }); 
         
        saveAction.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                var resp = response.getReturnValue();
                 
                if(resp.includes('Success')){
                    if(btn=='save'){
                        var objId = resp.split('#');
                        var recId = objId[1];
                        this.showToast('Success!','Family Member added successfully!','success');
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": recId,
                            "slideDevName": "related"
                        });
                        navEvt.fire();
                    }
                    else if(btn=='savenadd'){
                        component.set('v.sucessMsg','Family Member added successfully!');
                        component.set('v.errorMsg','');
                        component.set('v.showSpinner',false);
                        component.set('v.leadPhone','');
                        component.set('v.lead',{});
                        component.set('v.patietnWrapper',{});
                    }
                }
                else {
                	component.set('v.showSpinner',false);
                    this.showToast('ERROR',resp,'error');
                     
                }
            }
        });
        $A.enqueueAction(saveAction);
    },
    
    
    
    
    
    
})