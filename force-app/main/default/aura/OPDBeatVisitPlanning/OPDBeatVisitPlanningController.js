({
    doInit : function(component, event, helper) {
        
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        
        if($A.get("$Browser.formFactor")=='PHONE' || $A.get("$Browser.formFactor")=='TABLET')
            component.set("v.isDesktop",false);
        
        var action = component.get("c.getDataFromApex");
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                component.set('v.today',response.getReturnValue().today);
                component.set('v.nextMonthName',response.getReturnValue().nextMonthName);
                component.set('v.year',response.getReturnValue().year);
                component.set('v.listAccount',response.getReturnValue().listAccountWrapperClass);
                component.set('v.listContact',response.getReturnValue().listContactWrapperClass);
                component.set('v.lastDate',response.getReturnValue().lastDate);
                $A.util.addClass(spinner,"slds-hide");
            }    
        });
        $A.enqueueAction(action);
    },
    /*
    validateDate : function(component, event, helper){
        var customDate = new Date(event.getSource().get('v.value')); 
        var today = new Date(); 
        
        var custDay = customDate.getDate();
        var custMnth = customDate.getMonth();
        
        var todayDay = today.getDate();
        var todayMnth = today.getMonth();
        
        const monthNames = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"
                           ];
        
        component.set('v.nextMonthName',monthNames[customDate.getMonth()])
        
        if(customDate.getFullYear() == today.getFullYear()){
            if(custMnth==todayMnth && custDay<todayDay){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":'error',
                    "message": "Please select a future date."
                });
                toastEvent.fire();
            }
            else if(custMnth<todayMnth){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":'error',
                    "message": "Please select a future date."
                });
                toastEvent.fire();
            }
        }
        
    },
    */
    createBeatDetails : function(component,event,helper) {
        var count = 0; 
        var listAccount = component.get("v.listAccount");
        for(var i=0;i<listAccount.length;i++) {
            if(listAccount[i].isSelected == true) {
                count = 1;
                break;
            }    
        }
        var listContact = component.get("v.listContact");
        for(var i=0;i<listContact.length;i++) {
            if(listContact[i].isSelected == true) {
                count = 1;
                break;
            }    
        }
        
        if(count == 1) {
            var spinner = component.find("spinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.createBeatDetailsApex");
            action.setParams({
                'listAccount' : JSON.stringify(component.get("v.listAccount")),
                'visitDate' : component.get("v.today"),
                'listContact' : JSON.stringify(component.get("v.listContact"))
            });
            action.setCallback(this,function(response){
                if(response.getState() === "SUCCESS") {
                    
                    if(response.getReturnValue().includes("SUCCESS")) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type":'success',
                            "message": "Meetings scheduled successfully!"
                        });
                        $A.get('e.force:refreshView').fire();
                        toastEvent.fire();    
                    }
                    else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":'error',
                            "message": response.getReturnValue()
                        });
                        toastEvent.fire();	    
                    }
                    
                    $A.util.addClass(spinner,"slds-hide");
                }
                
            });
            $A.enqueueAction(action);        
        }
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":'error',
                "message": "Please schedule one meeting!"
            });
            toastEvent.fire();    
        }
        
        
    },
    
    redirectToDoc : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.dataset.selid,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    
    sobjectHome : function(component, event){
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Beat_Plan__c"
        });
        homeEvent.fire();
    },
    
    doSearch : function(component,event,helper) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doSearchApex");
        action.setParams({
            "checkAccount" : component.get("v.checkAccount"),
            "checkContact" : component.get("v.checkContact"),
            "Self" : component.get("v.Self"),
            "Others" : component.get("v.Others"),
            "selectedSpeciality" : component.get("v.account.Account_Channel__c"),
            "searchName" : component.get("v.searchName"),
            "selectedTerritory" : component.get("v.selectedTerritory")
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                component.set('v.listAccount',response.getReturnValue().listAccountWrapperClass);
                component.set('v.listContact',response.getReturnValue().listContactWrapperClass);
                $A.util.addClass(spinner,"slds-hide");			    
            }    
        });
        $A.enqueueAction(action);
    },
    
    doReschedule : function(component,event,helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:ListBeatDetails"
            //componentAttributes :{ }
        });
        evt.fire();
    }
})