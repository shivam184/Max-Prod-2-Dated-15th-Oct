({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);
        helper.setEnrolmenttypes(component, event);
        helper.setValuesFromCustAct(component, event);
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
       helper.doAPIcallout(component, event);
    },
    
    populateSelectedPat : function(component, event){
        var selVal = event.getSource().get('v.value');
        if(!$A.util.isEmpty(selVal))
            component.set('v.lead',component.get('v.patietnWrapper.patientDetailMap')[selVal]);
        else
            component.set('v.lead',{});
    },
	    
    handleNewChange : function(component, event){
        let selChk = event.getSource().get('v.checked');
        if(selChk==true)
            component.set('v.patietnWrapper.isExisiting',false);
        else
            component.set('v.patietnWrapper.isExisiting',true);
    },
     
    handleChangeWantToEnroll : function(component,event,helper) {
        if(!component.get("v.lead.Want_to_Enrol__c")) {
            component.set("v.selectedOccupation","");
            var activeSectionName = [];
            activeSectionName.push('PersonalInformation');
            component.set("v.activeSections",activeSectionName);
            component.set('v.lead.Want_to_Enrol__c ',false);
        }
        else {
            component.set('v.lead.Want_to_Enrol__c ',true);
            var activeSectionName = component.get("v.activeSections");
            activeSectionName.push('PresentOccupation');
            component.set("v.activeSections",activeSectionName);
            window.setTimeout(function(){
                component.find("accord").set("v.activeSectionName",activeSectionName);
            },100
                             );
             
        }
        
    },
    
    handleChangeReferToMax : function(component,event,helper) {
        if(!component.get("v.referToMax")) {
            component.set('v.lead.Stage__c','New');
        }else{
            component.set('v.lead.Stage__c','Referred to Max');
            var activeSectionName = component.get("v.activeSections");
            activeSectionName.push('VitalInformation');
            component.set("v.activeSections",activeSectionName);
            window.setTimeout(function(){
                component.find("accord").set("v.activeSectionName",activeSectionName);
            },100
                             );
        }    
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
    },
    
    handleChangeDoctor : function(component, event){
        var docId = component.get('v.lead.Doctor__c');
        if(!$A.util.isEmpty(docId))
            $A.util.addClass(component.find('docError'),"slds-hide");
        else
            $A.util.removeClass(component.find('docError'),"slds-hide");
    },
    
    validateAge : function(component, event){
        var enType = event.getSource().get('v.value');
        if(!$A.util.isEmpty(enType)){
            if(enType=='Citizen Plus'){
                var validity = component.find('Age').get("v.validity");
                if(validity.valid==false){
                    component.find('Age').reportValidity();
                    component.find('Age').focus();
                }
            }
        }
    },
     
    handleFileChange : function(component, event){
        var files = event.getSource().get("v.files");
        if(!$A.util.isEmpty(files)){
            var originalFileName = event.getSource().get("v.files")[0]['name'];
            component.set('v.original_filename',originalFileName);
            
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1]; 
                component.set('v.fileBase64',content);
            }
            reader.readAsDataURL(files[0]);
        }
        else{
            component.set('v.original_filename','');
            component.set('v.fileBase64','');
        }
    },
    
    removeFile : function(component, event){
        component.set('v.original_filename','');
        component.set('v.fileBase64','');
    }
      
    
    
})