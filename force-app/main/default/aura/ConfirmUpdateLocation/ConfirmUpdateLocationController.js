({
    toggleDialog : function(component, event, helper) {
        helper.showHideModal(component);	
    },
    
    confirmUpdate : function(component , event , helper ) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner,"slds-hide");
        var action = component.get("c.getLocationApex");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "latitude" : component.get("v.latitude"),
            "longitude" : component.get("v.longitude")
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
                    message: 'Location has been captured successfully...',
                    type : 'success'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    }
})