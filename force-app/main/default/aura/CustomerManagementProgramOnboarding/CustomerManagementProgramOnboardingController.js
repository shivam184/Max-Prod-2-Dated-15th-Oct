({
    doCancel : function(component,event,helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);
        helper.setValuesFromCustAct(component, event);

    },

    
    doSave : function(component,event,helper) {
       
        helper.validateDetails(component, event); 
        
    },
    doCheckMobileNumber : function(component,event,helper) {
            helper.doAPIcallout(component, event);
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