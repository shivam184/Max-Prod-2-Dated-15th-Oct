({
    openInNewtab : function(component,event){
        var itemId = event.target.getAttribute('id');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": itemId
        });
        navEvt.fire();
    },
    
    doInit : function(component, event, helper) {
        var selectedDate = '';
        if(component.find("dateSelected"))
            selectedDate = component.find("dateSelected").get("v.value");
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doInitApex");
        action.setParams({
            "selectedDate" : selectedDate
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().message === "SUCCESS") {
                    component.set("v.listLead",response.getReturnValue().listLead);
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": response.getReturnValue().message,
                        "type" : "error"
                    });
                    toastEvent.fire();    
                }
            }   
            $A.util.addClass(spinner,"slds-hide");
        });
        $A.enqueueAction(action);
    },
    
    doBack : function(component,event,helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:PreIntimationForm"
            //componentAttributes :{ }
        });
        evt.fire();
    },
    
    
    /*
    doNew : function(component,event,helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:PreIntimationForm"
            //componentAttributes :{ }
        });
        evt.fire();
    }
    */
})