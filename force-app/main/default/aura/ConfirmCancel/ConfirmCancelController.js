({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmCancel : function(component , event , helper ) {
        if(component.get("v.cancelReason") != "") {
            var spinner = component.find("spinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.createCancelApex");
            action.setParams({
                "beatPlanDetailId" : component.get("v.beatPlanDetailId"),
                "cancelReason" : component.get("v.cancelReason")
            });
            action.setCallback(this,function(response){
                if(response.getState() === 'SUCCESS') {
                    var cmpEvent = component.getEvent("startDayEvent");
                    cmpEvent.fire();
                    helper.showHideModal(component); 
                    $A.util.addClass(spinner,"slds-hide");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Visit has been Cancelled Successfully...',
                        type : 'success'
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else {
            document.getElementById("error").style.display = "block";    
        }
    }
})