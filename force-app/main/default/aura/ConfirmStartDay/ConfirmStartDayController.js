({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmStartDay : function(component , event , helper ) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.createStartDayApex");
        action.setParams({
            "beatPlanId" : component.get("v.beatPlanId"),
            "latitude" : component.get("v.latitude"),
            "longitude" : component.get("v.longitude")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                component.set("v.latitude",null);
                component.set("v.longitude",null);
                var cmpEvent = component.getEvent("startDayEvent");
                cmpEvent.fire();
                helper.showHideModal(component); 
                $A.util.addClass(spinner,"slds-hide");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Your Day Has Been Started Successfully',
                    type : 'success'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})