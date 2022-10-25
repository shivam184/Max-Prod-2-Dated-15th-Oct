({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmVisitToOffice : function(component , event , helper ) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.createVisitToOfficeApex");
        action.setParams({
            "beatPlanId" : component.get("v.beatPlanId")
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
                    message: 'Your Visit For Office has been scheduled Successfully...',
                    type : 'success'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})