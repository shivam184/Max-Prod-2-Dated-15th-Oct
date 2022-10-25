({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmReschedule : function(component , event , helper ) {
        
        if((component.get("v.rescheduleReason") != "") && (component.get("v.rescheduleDate") != "")) {
            var spinner = component.find("spinner");
            $A.util.removeClass(spinner,"slds-hide");
            var action = component.get("c.createRescheduleApex");
            action.setParams({
                "beatPlanDetailId" : component.get("v.beatPlanDetailId"),
                "rescheduleReason" : component.get("v.rescheduleReason"),
                "rescheduleDate" : component.get("v.rescheduleDate")
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
                        message: 'Visit has been Rescheduled Successfully...',
                        type : 'success'
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else {
            if(component.get("v.rescheduleDate") == "")
            	document.getElementById("error1").style.display = "block"; 
            if(component.get("v.rescheduleReason") == "")
            	document.getElementById("error2").style.display = "block"; 
        }
    }
})