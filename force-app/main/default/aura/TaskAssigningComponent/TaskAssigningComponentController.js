({
    doInit : function(component, event, helper) {
        var action = component.get("c.getIsolationMax");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.unassignedLeadTableColumns', [
                    {label: 'Enquiry Name', fieldName: 'Name', type: 'text'},
                    {label: 'Patient Name', fieldName: 'Patient_Name__c', type: 'text'},
                    {label: 'Age', fieldName: 'Age__c', type: 'number'},
                    {label: 'Phone', fieldName: 'Phone_No__c', type: 'text'},
                    {label: 'Package', fieldName: 'Package__c', type: 'Phone'},
                    {label: 'Spoke', fieldName: 'Spoke__c', type: 'text '},
                    {label: 'Service Start Date', fieldName: 'Service_Started_Date__c', type: 'date-local'},
                    {label: 'Doctor', fieldName: 'AssignDoctor__c', type: 'text '},
                    {label: 'Stage', fieldName: 'Stage__c', type: 'text '},
                    {label: 'Address', fieldName: 'Address__c', type: 'text '}
                ]);
                component.set('v.assignedLeadTableColumns', [
                    {label: 'Enquiry Name', fieldName: 'Name', type: 'text'},
                    {label: 'Patient Name', fieldName: 'Patient_Name__c', type: 'text'},
                    {label: 'Phone', fieldName: 'Phone_No__c', type: 'text'},
                    {label: 'Age', fieldName: 'Age__c', type: 'number'},
                    {label: 'Spoke', fieldName: 'Spoke__c', type: 'text '},
                    {label: 'Service Start Date', fieldName: 'Service_Started_Date__c', type: 'date-local'},
                    {label: 'Stage', fieldName: 'Stage__c', type: 'text '},
                    {label: 'Doctor', fieldName: 'AssignDoctor__c', type: 'text '},
                    {label: 'Nurse', fieldName: 'AssignNurse__c', type: 'text '},
                    {label: 'Package', fieldName: 'Package__c', type: 'Phone'},
                    {label: 'Address', fieldName: 'Address__c', type: 'text '},
                    {label: 'Quarantine Day', fieldName: 'QuarantineDayOnly__c', type: 'text '}
                ]);
                component.set("v.unassignedPatientsList",result.unassignedPatientsList);
                component.set("v.assignedPatientsList",result.assignedPatientsList);
                component.set("v.timeValues",result.hourValues);
            }
        });    
        $A.enqueueAction(action);
    },
    
    handleUnassignedSelect :  function(component, event, helper) {
        var selectRow = event.getParam('selectedRows');
        var setRows = [];
        for(var i=0; i < selectRow.length ; i++){
            setRows.push(selectRow[i]);
        }
        component.set("v.selectedUnassignedPatientTable", setRows);
    }, 
    
    handleAssignedSelect : function(component, event, helper) {
        var selectRow = event.getParam('selectedRows');
        var setRows = [];
        for(var i=0; i < selectRow.length ; i++){
            setRows.push(selectRow[i]);
        }
        component.set("v.selectedAssignedPatientTable", setRows);
    }, 
    
    
    searchLeadByDate: function(component,event,helper){
        var searchDate = component.get("v.searchDate");
        var patientNameForSearch = component.get("v.patientNameForSearch");
        var phoneNumberForSearch = component.get("v.phoneForSearch");
        var docNameForSearch = component.get("v.selectedDocForSearch");
        var searchAction = component.get("c.getSearchResults");
        searchAction.setParams({
            "searchDate" : searchDate,
            "patientNameForSearch" : patientNameForSearch,
            "phoneNumberForSearch" : phoneNumberForSearch,
            "docNameForSearch" : docNameForSearch
        });
        searchAction.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.unassignedPatientsList",result.unassignedPatientsList);
            }
        });
        $A.enqueueAction(searchAction);
    },
    
    searchLeadByDateAssigned: function(component,event,helper){
        var searchDateAssigned = component.get("v.searchDateAssigned");
        var patientNameForSearchAssigned = component.get("v.patientNameForSearchAssigned");
        var phoneForSearchAssigned = component.get("v.phoneForSearchAssigned");
        var selectedDocForSearchAssigned = component.get("v.selectedDocForSearchAssigned");
        var searchActionforAssigned = component.get("c.getSearchResultsAssigned");
        searchActionforAssigned.setParams({
            "searchDateAssigned" : searchDateAssigned,
            "patientNameForSearchAssigned" : patientNameForSearchAssigned,
            "phoneForSearchAssigned" : phoneForSearchAssigned,
            "selectedDocForSearchAssigned" : selectedDocForSearchAssigned
        });
        searchActionforAssigned.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.assignedPatientsList",result.assignedPatientsList);
            }
        });
        $A.enqueueAction(searchActionforAssigned);
    },
    
    openModal : function(component, event, helper){
        var unassignedList = component.get("v.selectedUnassignedPatientTable");
        var serviceStartDate = component.get("v.serviceStartDate");
        if(unassignedList.length > 0 ){
        	component.set("v.isModalOpen",true);
            if(unassignedList.length === 1  && unassignedList[0].Doctor__c != null && unassignedList[0].Doctor__c != ''){
                component.set("v.selectedDoc",unassignedList[0].Doctor__c);
            }
            if(unassignedList.length === 1  && unassignedList[0].Service_Started_Date__c != null && unassignedList[0].Service_Started_Date__c != ''){
                component.set("v.serviceStartDate",unassignedList[0].Service_Started_Date__c);
            }
        }else{
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "No Record Selected!",
                    "message": "Please Select a Unassigned Lead first!"
                });
                toastEvent.fire();
        }
    },
    
    closeModel : function(component,event,helper){
        component.set("v.isModalOpen",false);
    },
    
    assignTask : function(component, event, helper) {
         component.set("v.IsDisabled",true);
        component.set("v.spinner", true); 
        var assignDoc = component.get("v.selectedDoc");
        var assignNurse = component.get("v.selectedNurse");
        var unassignPatient = component.get("v.selectedUnassignedPatientTable");
        var docFrequency = component.get("v.docFrequency");
        var docVisits = component.get("v.docVisits");
        var docVisitTime1 = component.get("v.docVisitTime1");
        var docVisitTime2 = component.get("v.docVisitTime2");
        var nurseFrequency = component.get("v.nurseFrequency");
        var nurseVisits = component.get("v.nurseVisits"); 
        var nurseVisitTime1 = component.get("v.nurseVisitTime1");
        var nurseVisitTime2 = component.get("v.nurseVisitTime2");
        var nurseVisitTime3 = component.get("v.nurseVisitTime3");
        var serviceStartDate = component.get("v.serviceStartDate");
        var serviceEndDate = component.get("v.serviceEndDate");
        var action = component.get("c.assignPatient");
        
        
        if(serviceStartDate==null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Service Start Date should not be blank.!",
                "type" : 'Warning'
            });
            toastEvent.fire();
            component.set("v.IsDisabled",false);
        }else{
            
            action.setParams({
                "assignDoc" : assignDoc,
                "assignNurse" : assignNurse,
                "unassignPatient" : unassignPatient,
                "docFrequency" : docFrequency,
                "docVisits" : docVisits,
                "docVisitTime1" : docVisitTime1,
                "nurseFrequency" : nurseFrequency,
                "nurseVisits" : nurseVisits,
                "nurseVisitTime1" : nurseVisitTime1,
                "nurseVisitTime2" : nurseVisitTime2,
                "serviceStartDate" : serviceStartDate,
                "serviceEndDate" : serviceEndDate
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS"){
                    component.set("v.spinner", true); 
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "SUCCESS!",
                        "message": "Doctor and Nurse have been assigned successfully!",
                        "type" : 'SUCCESS'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                    
                    
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:TaskAssigningComponent",
                        componentAttributes: {} 
                    });
                    evt.fire(); 
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    changeDoc : function(component, event, helper) {
        var docToUpdate = component.get("v.selectedDoc");
        var assignPatient = component.get("v.selectedAssignedPatientTable");
        if(docToUpdate == null || assignPatient == null){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please Select atleast one assigned Patient and Doctor!"
                });
                toastEvent.fire();
        }
        else{
            var changeDocAction = component.get("c.replaceDoc");
            changeDocAction.setParams({
                "docToUpdate" : docToUpdate,
                "assignPatient" : assignPatient
            });
            changeDocAction.setCallback(this,function(response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Doctor Assigned Successfully"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(changeDocAction);
    	}
    },
    
    changeNurse : function(component, event, helper){
        var nurseToUpdate = component.get("v.selectedNurse");
        var assignPatient = component.get("v.selectedAssignedPatientTable");
        var nurseChangeAction = component.get("c.replaceNurse");
        if(nurseToUpdate == null || assignPatient == null){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please Select atleast one assigned Patient and Nurse!"
                });
                toastEvent.fire();
        }
        else{
            nurseChangeAction.setParams({
                "nurseToUpdate" : nurseToUpdate,
                "assignPatient" : assignPatient
            });
            nurseChangeAction.setCallback(this,function(response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Nurse Assigned Successfully"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(nurseChangeAction);
        }
    },
    
    unassignedTabValues : function(component, event, helper){
        component.set("v.showUnassignedButtons",true);   	
    },
    
    assignedTabValues : function(component, event, helper){
        component.set("v.showUnassignedButtons",false);   	
    },
})