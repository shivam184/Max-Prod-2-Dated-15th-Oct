({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmEndDay : function(component , event , helper ) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.createEndDayApex");
        action.setParams({
            "beatDayId" : component.get("v.beatDayId"),
            "longitude" : component.get("v.longitude"),
            "latitude" : component.get("v.latitude")
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
                    message: 'Your Day Has Been Ended Successfully...',
                    type : 'success'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})