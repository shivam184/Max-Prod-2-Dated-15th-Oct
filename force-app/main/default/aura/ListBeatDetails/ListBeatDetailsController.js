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
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.doInitApex");
        action.setParams({
            "todayDate" : component.get("v.todayDate")    
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS") {
                if(response.getReturnValue().message === "SUCCESS") {
                    component.set("v.todayDate",response.getReturnValue().todayDate);
                    component.set("v.minDate",response.getReturnValue().minDate);
                    component.set("v.listBeatPlanDetails",response.getReturnValue().listBeatDetails);
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
    }
})