({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);    
    },
    
    doCancel : function(component,event,helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    doSave : function(component,event,helper) {
        var btn = event.getSource().get('v.accesskey');
        helper.validateDetails(component, event,btn);       
    },
    
 	doCheckMobileNumber : function(component,event,helper) {
        
        //API Call
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
                        component.set('v.showSpinner',false);
                        if(response.isExisiting==true && response.moreThanOnePat==false)
                            component.set('v.lead',response.leadObj);
                    }
                }
                else if(response.getState()==='ERROR'){
                    alert('An error has occurred. Please refreh the page');
                }
                else if(response.getState()==='INCOMPLETE'){
                    alert('An error has occurred. Please refreh the page');
                }
            });
            $A.enqueueAction(action);
             
        }
        else {   
        }
    },
    
    
    populateSelectedPat : function(component, event){
        var selVal = event.getSource().get('v.value');
        if(!$A.util.isEmpty(selVal))
            component.set('v.lead',component.get('v.patietnWrapper.patientDetailMap')[selVal]);
        else
            component.set('v.lead',{});
    },
	    
    handleNewChange : function(component, event){
        var selChk = event.getSource().get('v.checked');
        if(selChk==true)
            component.set('v.patietnWrapper.isExisiting',false);
        else
            component.set('v.patietnWrapper.isExisiting',true);
    },
     
    
    handleChangeDob : function(component,event,helper){
        var dob = component.find("dob").get("v.value");
        var dateOfBirth = new Date(dob);
        var currentTimestamp = Date.now();
        var finalTimeStamp = currentTimestamp - dateOfBirth.getTime();
        var ageInYears = Math.floor(((((finalTimeStamp/1000)/60)/60)/24)/365);
        component.set("v.lead.CMP_Age__c",ageInYears);
    },
    
    handleChangeAge :function(component,event,helper){
        var currentAge=event.getSource().get('v.value');
        var today = new Date();
        var currentYear = today.getFullYear() ;
        var birthdayPast = false;
        var Birthyear =currentYear-currentAge;
        component.set("v.lead.DOB__c",Birthyear+'-01-01');
    }
    
})